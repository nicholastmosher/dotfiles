#[derive(Debug, thiserror::Error)]
pub enum GitError {
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
    GitDiscovery(#[from] Box<gix::discover::Error>),

    #[error("Clap error")]
    Clap(#[from] clap::Error),

    #[error(transparent)]
    Io(#[from] std::io::Error),
}

impl From<gix::discover::Error> for GitError {
    fn from(value: gix::discover::Error) -> Self {
        Self::GitDiscovery(Box::new(value))
    }
}
