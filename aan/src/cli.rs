use crate::watch_kit::WatchKit;
use std::path::PathBuf;

/// An easy toolbox
#[derive(Debug, clap::Parser)]
#[command(about)]
pub struct Cli {
    /// Global args
    #[clap(flatten)]
    pub args: Args,
    /// Subcommands
    #[clap(subcommand)]
    pub cmd: Cmd,
}

impl Cli {
    pub async fn run(&self) -> color_eyre::Result<()> {
        self.cmd.run(&self.args).await?;
        Ok(())
    }
}

#[derive(Debug, clap::Args)]
pub struct Args {}

#[derive(Debug, clap::Subcommand)]
pub enum Cmd {
    /// (gg) Print git history as a graph
    #[clap(alias = "gg")]
    GitGraph {
        /// The path to the repo to watch
        #[clap(default_value = ".")]
        path: PathBuf,
    },
    /// (gw) Open a git graph that updates on change
    #[clap(alias = "gw")]
    GitWatch {
        /// The path to the repo to watch
        #[clap(default_value = ".")]
        path: PathBuf,
    },
    #[clap(alias = "sym")]
    Symlink,
}

impl Cmd {
    pub async fn run(&self, _args: &Args) -> color_eyre::Result<()> {
        match self {
            Self::GitWatch { path } => {
                // Clear screen and println
                let print = |text: String| {
                    clearscreen::clear().expect("failed to clear screen");
                    println!("{text}")
                };

                // Print the graph at startup
                let graph = crate::git_graph::git_graph(path, true)?;
                print(graph);

                // Rerender the graph on any change in .git/
                let mut watchkit = WatchKit::new().await?;
                let rx = crate::git_watch::git_watch(&mut watchkit, path, true).await?;
                loop {
                    let graph = rx.recv_async().await.expect("should receive git-graph");
                    print(graph);
                }
            }
            Self::GitGraph { path } => {
                let graph = crate::git_graph::git_graph(path, true)?;
                println!("{graph}");
            }
            Self::Symlink => {
                crate::install_symlinks()?;
            }
        }

        Ok(())
    }
}
