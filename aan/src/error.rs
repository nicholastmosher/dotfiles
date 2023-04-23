use thiserror::Error;

pub type Result<T, E = Error> = core::result::Result<T, E>;

#[derive(Debug, Error)]
pub enum Error {
    #[error("Shell error")]
    Shell(#[from] xshell::Error),

    #[error("Watchexec critical error")]
    WatchexecCritical(#[from] watchexec::error::CriticalError),

    #[error("Watchexec reconfiguration error")]
    WatchexecReconfig(#[from] watchexec::error::ReconfigError),

    #[error("Tokio watchexec error")]
    Tokio(#[from] tokio::task::JoinError),

    #[error("Flume rx error")]
    FlumeRx(#[from] flume::RecvError),

    #[error("Failed to find git repo")]
    GitDiscovery(#[from] git_repository::discover::Error),

    #[error("Clap error")]
    Clap(#[from] clap::Error),

    #[error(transparent)]
    Io(#[from] std::io::Error),
}
