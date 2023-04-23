use std::path::Path;

use resolve_path::PathResolveExt;
use xshell::{cmd, Shell};

/// Generate a pretty git history graph for the repository at the given path
pub fn git_graph(path: &Path, color: bool) -> Result<String, crate::error::GitError> {
    let discover_path = path.resolve().canonicalize()?;
    let repo = git_repository::discover(discover_path)?;
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
