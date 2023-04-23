pub mod cli;
pub mod error;
mod git_graph;
mod git_watch;
pub mod watch_kit;

use clap::CommandFactory;
use std::path::Path;

pub fn preprocessed_args() -> Vec<String> {
    let me = std::env::args().next().expect("executable should be named");
    let myself = match &*me {
        "target/debug/an" | "target/release/an" => None,
        name => {
            let name = Path::new(name).file_name();
            name.map(|osstr| osstr.to_string_lossy().to_string())
        }
    };

    ["toolbox".to_string()]
        .into_iter()
        .chain(myself.into_iter())
        .chain(std::env::args().skip(1))
        .collect::<Vec<_>>()
}

/// For each clap alias, create a symlink with that alias name to `an`.
///
/// This effectively turns each subcommand into its own top-level command
/// in the shell if we put the target directory in the PATH.
pub fn install_symlinks() -> color_eyre::Result<()> {
    let command = cli::Cli::command();
    let aliases: Vec<_> = command
        .get_subcommands()
        .flat_map(|sub| sub.get_subcommands().chain([sub]))
        .flat_map(|sub| sub.get_all_aliases().chain([sub.get_name()]))
        .collect();

    println!("Aliases! {aliases:?}");

    let root = env!("CARGO_MANIFEST_DIR");
    let parent = format!("{root}/target/release");
    let an_executable = format!("{parent}/an");
    for alias in &aliases {
        let alias_executable = format!("{parent}/{alias}");
        #[allow(clippy::needless_borrow)]
        let _ = symlink::symlink_file(&an_executable, alias_executable);
    }

    Ok(())
}
