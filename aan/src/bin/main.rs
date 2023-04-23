use aan::cli::Cli;
use clap::{CommandFactory, FromArgMatches};
use tracing_subscriber::prelude::*;
use tracing_subscriber::Registry;

#[tokio::main]
async fn main() -> color_eyre::Result<()> {
    color_eyre::install()?;
    dotenv::dotenv().ok();

    if let None | Some("") = std::env::var("RUST_LOG").as_deref().ok() {
        std::env::set_var("RUST_LOG", "info");
    }

    Registry::default()
        .with(tracing_subscriber::fmt::layer())
        .with(tracing_subscriber::EnvFilter::from_default_env())
        .try_init()?;
    tracing::debug!("Initialized tracing!");

    let clap_args = aan::preprocessed_args();
    let command = Cli::command();
    let matches = command.get_matches_from(clap_args);
    let cli = Cli::from_arg_matches(&matches)?;
    cli.run().await?;
    Ok(())
}
