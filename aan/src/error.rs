use miette::Diagnostic;
use thiserror::Error;

pub type Result<T, E = Error> = core::result::Result<T, E>;

#[derive(Debug, Error, Diagnostic)]
pub enum Error {
    #[error("Shell error")]
    #[diagnostic(code(xshell))]
    Shell(#[from] xshell::Error),

    #[error("Watchexec critical error")]
    #[diagnostic(code(watchexec::critical))]
    WatchexecCritical(#[from] watchexec::error::CriticalError),

    #[error("Watchexec reconfiguration error")]
    #[diagnostic(code(watchexec::config))]
    WatchexecReconfig(#[from] watchexec::error::ReconfigError),

    #[error("Tokio watchexec error")]
    #[diagnostic(code(watchexec::tokio))]
    Tokio(#[from] tokio::task::JoinError),

    #[error("Flume rx error")]
    #[diagnostic(code(flume::rx))]
    FlumeRx(#[from] flume::RecvError),

    #[error("Failed to find git repo")]
    #[diagnostic(code(git::discover))]
    GitDiscovery(#[from] git_repository::discover::Error),

    #[error("Clap error")]
    #[diagnostic(code(clap))]
    Clap(#[from] clap::Error),

    #[error(transparent)]
    #[diagnostic(code(std::io))]
    Io(#[from] std::io::Error),
}
