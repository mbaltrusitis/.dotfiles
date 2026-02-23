#!/usr/bin/env bash
# Claude Code Tmux Connection Helper
# Automatically connects Claude CLI to Neovim's MCP WebSocket server

set -euo pipefail

# shellcheck disable=SC2034  # Colors are used in print functions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# Globals (set by functions)
LOCK_FILE=""
CLAUDE_PORT=""
AUTH_TOKEN=""
IDE_NAME=""
NVIM_PID=""
TRANSPORT=""
WORKSPACE=""
MCP_NEOVIM_JSON=""
DEBUG=false

#######################################
# Print functions
#######################################

die() {
	printf '%b[Error]: %s%b\n' "$RED" "$1" "$NC" >&2
	exit 1
}

warn() {
	printf '%b%s%b\n' "$YELLOW" "$1" "$NC" >&2
}

info() {
	printf '%b[INFO]: %s%b\n' "$GREEN" "$1" "$NC"
}

success() {
	printf '%b%s%b\n' "$GREEN" "$1" "$NC"
}

debug() {
	if [[ "$DEBUG" == true ]]; then
		printf '%b[DEBUG]: %s%b\n' "$CYAN" "$1" "$NC" >&2
	fi
}

print_header() {
	printf '%b%b=== Claude Code MCP Connection Helper ===%b\n\n' "$BOLD" "$BLUE" "$NC"
}

#######################################
# Display usage information
#######################################
usage() {
	cat <<EOF
Usage: $(basename "$0") [OPTIONS] [-- CLAUDE_ARGS...]

Connect Claude CLI to Neovim's MCP WebSocket server.

Options:
    -h, --help      Show this help message
    -d, --debug     Enable debug output

Arguments after -- are passed directly to Claude CLI.

Examples:
    $(basename "$0")
    $(basename "$0") --debug
    $(basename "$0") -- --resume
EOF
}

#######################################
# Find lock file matching current directory
# Globals:
#   LOCK_FILE - set to matching lock file path
# Arguments:
#   $1 - directory to match
# Returns:
#   0 if found, 1 if not found
#######################################
find_lock_file() {
	local target_dir="$1"
	local -a available_workspaces=()

	shopt -s nullglob
	local -a lock_files=(~/.claude/ide/*.lock)
	shopt -u nullglob

	if [[ ${#lock_files[@]} -eq 0 ]]; then
		debug "No lock files found in ~/.claude/ide/"
		return 1
	fi

	# Sort by modification time (newest first)
	local -a sorted_locks
	mapfile -t sorted_locks < <(ls -t "${lock_files[@]}" 2>/dev/null)

	for lock in "${sorted_locks[@]}"; do
		debug "Checking lock file: $lock"
		local workspaces

		if command -v jq &>/dev/null; then
			workspaces=$(jq -r '.workspaceFolders[]' "$lock" 2>/dev/null) || continue
		else
			# Fallback: extract workspaceFolders using sed (portable)
			workspaces=$(sed -n 's/.*"workspaceFolders":\s*\[\([^]]*\)\].*/\1/p' "$lock" |
				tr ',' '\n' | sed 's/[" ]//g')
		fi

		while IFS= read -r ws; do
			[[ -z "$ws" ]] && continue
			local ws_normalized
			ws_normalized=$(realpath "$ws" 2>/dev/null) || ws_normalized="$ws"
			available_workspaces+=("$ws_normalized")
			debug "  Found workspace: $ws_normalized"

			if [[ "$ws_normalized" == "$target_dir" ]]; then
				LOCK_FILE="$lock"
				debug "  Match found!"
				return 0
			fi
		done <<<"$workspaces"
	done

	# No match found - print available workspaces
	printf '%b[Error]: No claudecode.nvim server running for this directory%b\n' "$RED" "$NC" >&2
	echo ""
	if [[ ${#available_workspaces[@]} -gt 0 ]]; then
		printf '%bAvailable workspaces with running Neovim instances:%b\n' "$YELLOW" "$NC"
		# Remove duplicates
		local -a unique_workspaces
		mapfile -t unique_workspaces < <(printf '%s\n' "${available_workspaces[@]}" | sort -u)
		for ws in "${unique_workspaces[@]}"; do
			printf '  %b%b%b %s\n' "$CYAN" "•" "$NC" "$ws"
		done
		echo ""
		echo "Please either:"
		echo "  1. Run this script from one of the above directories"
		printf '  2. Open Neovim in %b%s%b\n' "$CYAN" "$target_dir" "$NC"
	else
		echo "Please ensure:"
		echo "  1. Neovim is running with claudecode.nvim installed"
		echo "  2. The MCP server has started (auto_start = true)"
	fi
	echo ""
	printf 'Check server status in Neovim with: %b:ClaudeCodeStatus%b\n' "$CYAN" "$NC"
	return 1
}

#######################################
# Parse lock file and set globals
# Globals:
#   AUTH_TOKEN, IDE_NAME, NVIM_PID, TRANSPORT, WORKSPACE - set from lock file
# Arguments:
#   $1 - lock file path
#######################################
parse_lock_file() {
	local lock_file="$1"

	CLAUDE_PORT=$(basename "$lock_file" .lock)

	if ! [[ "$CLAUDE_PORT" =~ ^[0-9]+$ ]]; then
		die "Could not extract valid port from lock file: $lock_file"
	fi

	if command -v jq &>/dev/null; then
		AUTH_TOKEN=$(jq -r '.authToken' "$lock_file")
		IDE_NAME=$(jq -r '.ideName' "$lock_file")
		NVIM_PID=$(jq -r '.pid' "$lock_file")
		TRANSPORT=$(jq -r '.transport' "$lock_file")
		WORKSPACE=$(jq -r '.workspaceFolders[0]' "$lock_file")
	else
		# Portable fallback using sed
		AUTH_TOKEN=$(sed -n 's/.*"authToken":"\([^"]*\)".*/\1/p' "$lock_file")
		IDE_NAME=$(sed -n 's/.*"ideName":"\([^"]*\)".*/\1/p' "$lock_file")
		NVIM_PID=$(sed -n 's/.*"pid":\([0-9]*\).*/\1/p' "$lock_file")
		TRANSPORT=$(sed -n 's/.*"transport":"\([^"]*\)".*/\1/p' "$lock_file")
		WORKSPACE=$(sed -n 's/.*"workspaceFolders":\["\([^"]*\)".*/\1/p' "$lock_file")
	fi

	debug "Parsed - Port: $CLAUDE_PORT, PID: $NVIM_PID, Workspace: $WORKSPACE"
}

#######################################
# Verify Neovim process is running
# Arguments:
#   $1 - PID to check
# Returns:
#   0 if running, 1 if not
#######################################
verify_neovim_running() {
	local pid="$1"

	if ! ps -p "$pid" >/dev/null 2>&1; then
		warn "Warning: Neovim process (PID $pid) is not running!"
		echo "  The lock file may be stale. Try restarting Neovim."
		echo ""
		return 1
	fi
	return 0
}

#######################################
# Check if port is listening
# Arguments:
#   $1 - port number
# Returns:
#   0 if listening, 1 if not
#######################################
check_port_listening() {
	local port="$1"

	if command -v ss &>/dev/null; then
		if ss -ln 2>/dev/null | grep -q ":${port} "; then
			success "WebSocket server is listening on port $port"
			echo ""
			return 0
		fi
	elif command -v lsof &>/dev/null; then
		if lsof -i ":$port" >/dev/null 2>&1; then
			success "WebSocket server is listening on port $port"
			echo ""
			return 0
		fi
	else
		debug "Neither ss nor lsof available for port check"
		return 0
	fi

	warn "Warning: No listener found on port $port"
	echo "  The MCP server may not be running properly."
	echo ""
	return 1
}

#######################################
# Clean up stale lock files
#######################################
cleanup_stale_locks() {
	printf '%bCleaning up stale lock files...%b\n' "$BOLD" "$NC"
	local cleaned=0

	shopt -s nullglob
	local -a lock_files=(~/.claude/ide/*.lock)
	shopt -u nullglob

	for lock in "${lock_files[@]}"; do
		local lock_pid=""
		if command -v jq &>/dev/null; then
			lock_pid=$(jq -r '.pid' "$lock" 2>/dev/null) || continue
		else
			lock_pid=$(sed -n 's/.*"pid":\([0-9]*\).*/\1/p' "$lock")
		fi

		if [[ -n "$lock_pid" ]] && ! ps -p "$lock_pid" >/dev/null 2>&1; then
			local lock_port
			lock_port=$(basename "$lock" .lock)
			printf '  %bRemoving stale lock file for port %s (PID %s)%b\n' \
				"$YELLOW" "$lock_port" "$lock_pid" "$NC"
			rm -f "$lock"
			((cleaned++)) || true
		fi
	done

	if [[ $cleaned -eq 0 ]]; then
		printf '  %bNo stale lock files found%b\n' "$GREEN" "$NC"
	fi
	echo ""
}

#######################################
# Generate MCP configuration file
# Globals:
#   MCP_NEOVIM_JSON - set to config file path
# Arguments:
#   $1 - workspace directory
#   $2 - port number
#   $3 - auth token
#######################################
generate_mcp_config() {
	local workspace="$1"
	local port="$2"
	local auth_token="$3"

	if [[ -z "$workspace" ]] || [[ ! -d "$workspace" ]]; then
		warn "Warning: Workspace directory not found"
		echo "  Cannot create MCP config. Connection may fail."
		echo ""
		return 1
	fi

	MCP_NEOVIM_JSON="$workspace/.mcp-neovim.json"
	printf '%bGenerating dynamic MCP configuration...%b\n' "$BOLD" "$NC"

	cat >"$MCP_NEOVIM_JSON" <<EOF
{
  "mcpServers": {
    "neovim": {
      "type": "ws",
      "url": "ws://127.0.0.1:$port",
      "headers": {
        "x-claude-code-ide-authorization": "$auth_token"
      }
    }
  }
}
EOF

	printf '  %b Created: %s%b\n' "$GREEN" "$MCP_NEOVIM_JSON" "$NC"
	printf '  %bPort:%b %s\n' "$CYAN" "$NC" "$port"
	echo ""
}

#######################################
# Print connection details and instructions
#######################################
print_connection_info() {
	local port="$1"
	local workspace="$2"
	local auth_token="$3"

	printf '%bConnection Details:%b\n' "$BOLD" "$NC"
	printf '  %bWebSocket URL:%b ws://127.0.0.1:%s\n' "$CYAN" "$NC" "$port"
	printf '  %bWorkspace:%b %s\n' "$CYAN" "$NC" "$workspace"
	printf '  %bAuth Token:%b %b%s...%b\n' "$CYAN" "$NC" "$YELLOW" "${auth_token:0:12}" "$NC"
	echo ""

	printf '%b%bLaunching Claude Code CLI...%b\n\n' "$GREEN" "$BOLD" "$NC"
	printf '%bClaude will connect to Neovim via --mcp-config flag%b\n\n' "$CYAN" "$NC"
	printf '%bAfter Claude starts, verify the connection with:%b\n' "$CYAN" "$NC"
	printf '  %b/mcp%b\n\n' "$YELLOW" "$NC"
	printf '%bYou should see:%b\n' "$CYAN" "$NC"
	printf '  %b neovim%b\n' "$GREEN" "$NC"
	printf '  %b  WebSocket: ws://127.0.0.1:%s%b\n' "$GREEN" "$port" "$NC"
	printf '  %b  Tools: openFile, openDiff, saveDocument, getCurrentSelection, ...%b\n\n' "$GREEN" "$NC"
	printf '%bIf MCP server does not appear:%b\n' "$CYAN" "$NC"
	printf '  1. Check Neovim: %b:ClaudeCodeStatus%b\n' "$YELLOW" "$NC"
	printf '  2. Check config: %bcat %s/.mcp-neovim.json%b\n' "$YELLOW" "$workspace" "$NC"
	printf '  3. Check debug logs: %btail -f ~/.claude/debug/latest%b\n' "$YELLOW" "$NC"
	echo "  4. Restart both Neovim and Claude"
	echo ""
	printf '%b%b================================================%b\n\n' "$BOLD" "$BLUE" "$NC"
}

#######################################
# Print lock file information
#######################################
print_lock_info() {
	printf '%bLock File Contents:%b\n' "$BOLD" "$NC"
	printf '  IDE Name:      %b%s%b\n' "$YELLOW" "$IDE_NAME" "$NC"
	printf '  Port:          %b%s%b\n' "$YELLOW" "$CLAUDE_PORT" "$NC"
	printf '  Transport:     %b%s%b\n' "$YELLOW" "$TRANSPORT" "$NC"
	printf '  Workspace:     %b%s%b\n' "$YELLOW" "$WORKSPACE" "$NC"
	printf '  Neovim PID:    %b%s%b\n' "$YELLOW" "$NVIM_PID" "$NC"
	printf '  Auth Token:    %b%s...%s%b\n' "$YELLOW" "${AUTH_TOKEN:0:8}" "${AUTH_TOKEN: -8}" "$NC"
	echo ""
}

#######################################
# Cleanup on exit (trap handler)
#######################################
cleanup() {
	# Add any cleanup needed on exit
	:
}

#######################################
# Main function
#######################################
main() {
	local -a claude_args=()

	# Parse arguments
	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h | --help)
			usage
			exit 0
			;;
		-d | --debug)
			DEBUG=true
			shift
			;;
		--)
			shift
			claude_args=("$@")
			break
			;;
		*)
			claude_args+=("$1")
			shift
			;;
		esac
	done

	trap cleanup EXIT

	print_header

	# Get current directory (normalized)
	local current_dir
	current_dir=$(realpath "$(pwd)")
	printf '%bCurrent directory:%b %s\n\n' "$CYAN" "$NC" "$current_dir"

	# Find matching lock file
	if ! find_lock_file "$current_dir"; then
		exit 1
	fi

	info "Lock file found: $LOCK_FILE"
	echo ""

	# Parse lock file
	parse_lock_file "$LOCK_FILE"

	# Display lock file info
	print_lock_info

	# Verify Neovim is running
	verify_neovim_running "$NVIM_PID" || true

	# Check if port is listening
	check_port_listening "$CLAUDE_PORT" || true

	# Clean up stale lock files
	cleanup_stale_locks

	# Generate MCP config
	generate_mcp_config "$WORKSPACE" "$CLAUDE_PORT" "$AUTH_TOKEN" || true

	# Print connection info
	print_connection_info "$CLAUDE_PORT" "$WORKSPACE" "$AUTH_TOKEN"

	# Change to workspace directory
	cd "$WORKSPACE" || die "Cannot change to workspace directory: $WORKSPACE"

	# Launch Claude with debug flag and MCP config
	exec ~/.claude/local/claude --debug --ide --mcp-config "$MCP_NEOVIM_JSON" "${claude_args[@]}"
}

main "$@"
