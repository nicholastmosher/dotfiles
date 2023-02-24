# Path to this directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Load .env if it exists
[[ -f "${SCRIPT_DIR}/.env" ]] && source "${SCRIPT_DIR}/.env"

# Usage: ./apply-darwin <system hostname>
#   <system hostname> default: NIX_HOSTNAME or "interceptor"
NIX_HOSTNAME="${1:-${NIX_HOSTNAME:-"interceptor"}}"

NIXPKGS_ALLOW_UNFREE=1 darwin-rebuild switch --flake ".#${NIX_HOSTNAME}" --impure
