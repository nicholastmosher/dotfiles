use std::sync::Arc;

use watchexec::{
    config::{InitConfig, RuntimeConfig},
    handler::PrintDebug,
    Watchexec,
};

#[derive(Debug)]
pub struct WatchKit {
    pub watcher: Arc<Watchexec>,
    pub config: RuntimeConfig,
}

impl WatchKit {
    pub async fn new() -> crate::Result<Self> {
        let mut init = InitConfig::default();
        init.on_error(PrintDebug(std::io::stderr()));

        let config = RuntimeConfig::default();
        let watcher = Watchexec::new(init, config.clone())?;
        let watchkit = WatchKit {
            watcher: watcher.clone(),
            config: config.clone(),
        };

        watcher.reconfigure(config)?;

        tokio::spawn(async move {
            match watcher.main().await {
                Ok(Ok(_)) => {
                    tracing::info!("Returned from watcher.main()!");
                }
                Ok(Err(e)) => {
                    tracing::error!("Watchexec critical error: {e:?}");
                }
                Err(e) => {
                    tracing::error!("Tokio join error on watchexec: {e:?}");
                }
            }

            std::process::exit(1);
        });

        Ok(watchkit)
    }
}
