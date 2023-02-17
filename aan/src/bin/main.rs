use an::cli::Cli;
use clap::{CommandFactory, FromArgMatches, Parser};
use miette::IntoDiagnostic;
use tracing_subscriber::prelude::*;
use tracing_subscriber::Registry;

#[tokio::main]
async fn main() -> miette::Result<()> {
    let _ = dotenv::dotenv();
    miette::set_hook(Box::new(|_| {
        Box::new(
            miette::MietteHandlerOpts::new()
                .terminal_links(true)
                .unicode(false)
                .context_lines(3)
                .tab_width(4)
                .build(),
        )
    }))?;

    if let None | Some("") = std::env::var("RUST_LOG").as_deref().ok() {
        std::env::set_var("RUST_LOG", "info");
    }

    Registry::default()
        .with(tracing_subscriber::fmt::layer())
        .with(tracing_subscriber::EnvFilter::from_default_env())
        .try_init()
        .into_diagnostic()?;
    tracing::debug!("Initialized tracing!");

    let clap_args = an::preprocessed_args();
    let command = Cli::command();
    let matches = command.get_matches_from(clap_args);
    let cli = Cli::from_arg_matches(&matches).into_diagnostic()?;
    cli.run().await?;
    Ok(())
}
