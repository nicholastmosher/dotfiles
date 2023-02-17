pub mod cli;
mod error;
pub mod watch_kit;

use clap::CommandFactory;
pub use error::{Error, Result};
use resolve_path::PathResolveExt;
use std::path::Path;
use watch_kit::WatchKit;
use watchexec::action::{Action, Outcome};
use xshell::{cmd, Shell};

/// Launch an async task that produces a fresh git graph
/// after any change to a git repo
///
/// This is implemented to be reusable but especially easy
/// to plug into the cli.
pub async fn git_watch(
    watch: &mut WatchKit,
    path: &Path,
    color: bool,
) -> Result<flume::Receiver<String>> {
    let (tx, rx) = flume::bounded(10);

    let discover_path = path.resolve();
    let repo = git_repository::discover(discover_path).map_err(Error::from)?;
    let repo_path = repo.path().resolve().canonicalize()?;

    watch.config.pathset([repo_path.clone()]);
    watch.config.on_action(move |action: Action| {
        let tx = tx.clone();
        let repo_path = repo_path.clone();

        async move {
            for event in action.events.iter() {
                use watchexec::signal::source::MainSignal::*;

                for signal in event.signals() {
                    if let Hangup | Quit | Terminate | Interrupt = signal {
                        // TODO if we need any kind of cleanup,
                        // we'll need to arrange that here
                        std::process::exit(0);
                    }
                }

                // Whenever git is updated, regenerate the git graph
                let git_updated = event.paths().any(|(p, _)| p.starts_with(&repo_path));
                if git_updated {
                    let output = git_graph(&repo_path, color)?;
                    let _ = tx.send_async(output).await;
                    break;
                }
            }

            action.outcome(Outcome::DoNothing);
            Ok::<_, Error>(())
        }
    });

    watch.watcher.reconfigure(watch.config.clone())?;
    Ok(rx)
}

/// Generate a pretty git history graph for the repository at the given path
pub fn git_graph(path: &Path, color: bool) -> Result<String> {
    let discover_path = path.resolve().canonicalize()?;
    let repo = git_repository::discover(discover_path).map_err(Error::from)?;
    let repo_path = repo.path().resolve().canonicalize()?;

    // Spawn a shell in the repo dir to run the git graph
    let sh = Shell::new()?;
    let _guard = sh.push_dir(&repo_path);
    let colorize = if color { "--color=always" } else { "" };
    let output = cmd!(sh, "
        git log
            --graph
            --abbrev-commit
            --decorate
            {colorize}
            --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'
            --all
    ").read()?;
    Ok(output)
}

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
pub fn install_symlinks() -> Result<()> {
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
