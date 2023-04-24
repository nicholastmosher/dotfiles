use std::path::Path;

use crate::error::GitError;
use resolve_path::PathResolveExt;
use watchexec::action::{Action, Outcome};

use crate::watch_kit::WatchKit;

/// Launch an async task that produces a fresh git graph
/// after any change to a git repo
///
/// This is implemented to be reusable but especially easy
/// to plug into the cli.
pub async fn git_watch(
    watch: &mut WatchKit,
    path: &Path,
    color: bool,
) -> color_eyre::Result<flume::Receiver<String>> {
    let (tx, rx) = flume::bounded(10);

    let discover_path = path.resolve();
    let repo = gix::discover(discover_path).map_err(GitError::from)?;
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
                    let output = crate::git_graph::git_graph(&repo_path, color)?;
                    let _ = tx.send_async(output).await;
                    break;
                }
            }

            action.outcome(Outcome::DoNothing);
            Ok::<_, GitError>(())
        }
    });

    watch.watcher.reconfigure(watch.config.clone())?;
    Ok(rx)
}
