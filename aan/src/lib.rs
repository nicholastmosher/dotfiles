pub mod cli;
pub mod error;
mod git_graph;
mod git_watch;
pub mod watch_kit;

use clap::CommandFactory;
use resolve_path::PathResolveExt;
use std::{collections::VecDeque, path::Path};
use xshell::{cmd, Shell};

/// Maps the raw arguments to their canonical command names
///
/// `aan` is a chimera, meaning that it behaves differently based on what its
/// own executable name is. When `aan` is executed as `aan`, it's in
/// "top-level" mode, and serves as a home entrypoint for all the subcommands
/// housed within it. This is useful for discovery, since running `aan` will
/// simply print all the available subcommands and allow for navigation via
/// the help menu.
///
/// However, for convenience, we also take each subcommand and symlink `aan`
/// to that subcommand name directly. For example, we can create a symlink
/// called `gg` which just points to `aan`, but when executing the `gg`
/// symlink, it will execute as if you had run `aan gg`.
///
/// Ultimately, the output of argx will be used via `clap::Parser::parse_from`
///
/// # Example
///
/// ```
/// assert_eq!(aan::argx(["/target/debug/aan"]),   vec!["aan"]);
/// assert_eq!(aan::argx(["/target/release/aan"]), vec!["aan"]);
/// assert_eq!(aan::argx(["aan"]),                 vec!["aan"]);
/// assert_eq!(aan::argx(["aan", "-h"]),           vec!["aan", "-h"]);
/// assert_eq!(aan::argx(["aan", "gg"]),           vec!["aan", "gg"]);
/// assert_eq!(aan::argx(["aan", "gg", "-h"]),     vec!["aan", "gg", "-h"]);
/// assert_eq!(aan::argx(["gg", "-h"]),            vec!["aan", "gg", "-h"]);
/// ```
pub fn argx<S: Into<String>>(args: impl IntoIterator<Item = S>) -> Vec<String> {
    // Split the args list into the first arg (argv0) and the rest
    let (argv0, rest) = {
        let mut args: VecDeque<String> = args.into_iter().map(|it| it.into()).collect();
        let argv0 = args
            .pop_front()
            .expect("executalbe should be named (missing argv0)");
        (argv0, args)
    };

    // Check if this invocation is of the top-level `aan` executable
    let is_aan = argv0.ends_with("/aan") || argv0 == "aan";

    // If argv0 is not a form of `aan`, it must be a symlink to a subcommand.
    // In that case, derive the subcommand name from the filename of argv0.
    let shim = (!is_aan).then(|| {
        Path::new(&argv0)
            .file_name()
            .expect("executable should have a filename")
            .to_string_lossy()
            .to_string()
    });
    tracing::trace!(%argv0, ?rest, is_aan, ?shim);

    // The canonical invocation is made of the following parts:
    //
    // - The base name `aan`. This will always come first, regardless of
    //   the actual argv0 of this executable. Remember, this output needs
    //   to make sense to clap.
    // - If the argv0 is NOT a form of `aan` (a.k.a. is_aan=false),
    //   then take the filename of argv0 and append it to the base name.
    // - Then, we append the remainder of the original `args` input.
    let args: Vec<String> = ["aan".to_string()]
        .into_iter()
        .chain(shim)
        .chain(rest)
        .collect();
    tracing::debug!(argx = ?args);
    args
}

/// For each clap alias, create a symlink with that alias name to `aan`.
///
/// This effectively turns each subcommand into its own top-level command
/// in the shell if we put the target directory in the PATH.
pub fn install_symlinks() -> color_eyre::Result<()> {
    // Introspect the clap Cli to find all subcommands and their aliases
    let command = cli::Cli::command();
    let aliases: Vec<_> = command
        .get_subcommands()
        .flat_map(|sub| sub.get_subcommands().chain([sub]))
        .flat_map(|sub| sub.get_all_aliases().chain([sub.get_name()]))
        .collect();
    println!("Aliases! {aliases:?}");

    let sh = Shell::new().unwrap();
    let bin = "~/bin".resolve();
    sh.create_dir(&bin)?;
    cmd!(sh, "cargo build --release").run()?;

    for &alias in &aliases {
        let dst = bin.join(alias);
        sh.remove_path(&dst)?;
        let _ = cmd!(sh, "git rm {dst} -f").ignore_stderr().quiet().run();
        sh.hard_link("./target/release/aan", &dst)?;
        tracing::info!("Linking {} -> ./target/release/aan", dst.display());
    }

    Ok(())
}
