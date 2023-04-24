use aan::cli::Cli;
use clap::Parser;
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
    tracing::info!("Initialized tracing!");

    let cli = Cli::parse_from(aan::argx(std::env::args()));
    cli.run().await?;
    Ok(())
}
