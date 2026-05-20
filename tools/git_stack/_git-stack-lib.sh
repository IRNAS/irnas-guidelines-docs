#!/usr/bin/env bash
# shellcheck disable=SC2181
#
# git-stack-lib.sh - Shared library for git-stack-* commands
#
# Common functions used by git-stack-submit and git-sync

# This file should be sourced, not executed
if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
    echo "Error: This file should be sourced, not executed directly" >&2
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions for output
print_error() {
    echo -e "${RED}Error: $1${NC}" >&2
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}" >&2
}

_fmt_cmd() {
    local cmd=""
    local arg
    for arg in "$@"; do
        cmd+=$(printf '%q ' "$arg")
    done
    echo "${cmd% }"
}

run() {
    # Run a command and return its combined output on success.
    # On failure, print a standardized error with the command and output,
    # then exit with the command's return code.
    local out_file rc
    out_file=$(mktemp)

    if "$@" >"$out_file" 2>&1; then
        cat "$out_file"
        rm -f "$out_file"
        return 0
    else
        rc=$?
    fi

    print_error "Command failed (rc=$rc): $(_fmt_cmd "$@")\n"

    echo "Command output:" >&2
    if [[ -s $out_file ]]; then
        cat "$out_file" >&2
    fi

    rm -f "$out_file"
    exit "$rc"
}

try() {
    # Run a command and return its combined output on success.
    # On failure, stay quiet and return the original non-zero exit code.
    local out_file rc
    out_file=$(mktemp)

    if "$@" >"$out_file" 2>&1; then
        cat "$out_file"
        rm -f "$out_file"
        return 0
    else
        rc=$?
    fi

    rm -f "$out_file"
    return "$rc"
}

# Check if required commands are available
check_requirements() {
    if ! git rev-parse --git-dir &>/dev/null; then
        print_error "Not a git repository (or any of the parent directories)"
        exit 1
    fi

    if ! command -v gt &>/dev/null; then
        print_error "Graphite CLI (gt) is not installed or not in PATH"
        echo "Please install Graphite: https://graphite.dev/docs/installing-the-cli" >&2
        exit 1
    fi

    if ! command -v jq &>/dev/null; then
        print_error "jq is not installed or not in PATH"
        echo "Please install jq: https://stedolan.github.io/jq/" >&2
        exit 1
    fi
}

# Check authentication for the detected platform CLI
check_platform_auth() {
    local platform="$1"

    if [[ $platform == "github" ]]; then
        if ! command -v gh &>/dev/null; then
            print_error "GitHub CLI (gh) is not installed or not in PATH"
            echo "Please install GitHub CLI: https://cli.github.com/" >&2
            exit 1
        fi

        if ! gh auth status &>/dev/null; then
            print_error "Not authenticated with GitHub CLI (gh)"
            echo "Please run: gh auth login" >&2
            exit 1
        fi
    elif [[ $platform == "gitlab" ]]; then
        if ! command -v glab &>/dev/null; then
            print_error "GitLab CLI (glab) is not installed or not in PATH"
            echo "Please install GitLab CLI: https://gitlab.com/gitlab-org/cli" >&2
            exit 1
        fi

        if ! glab auth status &>/dev/null; then
            print_error "Not authenticated with GitLab CLI (glab)"
            echo "Please run: glab auth login" >&2
            exit 1
        fi
    else
        print_error "Unknown platform '$platform'"
        exit 1
    fi
}

# Detect whether this is a GitHub or GitLab repository
detect_platform() {
    if [[ ${VERBOSE:-false} == true ]]; then
        print_info "Detecting platform (GitHub or GitLab)..." >&2
    fi

    local top_dir remote_url
    top_dir=$(git rev-parse --show-toplevel)
    remote_url=$(git config --get "remote.origin.url" || true)

    if [[ -z $remote_url ]] && [[ -f "$top_dir/.git/config" ]]; then
        print_error "No remote.origin.url configured for this repository"
        exit 1
    fi

    if [[ $remote_url =~ github ]]; then
        if ! command -v gh &>/dev/null; then
            print_error "This is a GitHub repository but 'gh' CLI is not installed"
            echo "Please install GitHub CLI: https://cli.github.com/" >&2
            exit 1
        fi
        echo "github"
        return 0
    fi

    if [[ $remote_url =~ gitlab ]]; then
        if ! command -v glab &>/dev/null; then
            print_error "This is a GitLab repository but 'glab' CLI is not installed"
            echo "Please install GitLab CLI: https://gitlab.com/gitlab-org/cli" >&2
            exit 1
        fi
        echo "gitlab"
        return 0
    fi

    print_error "Unable to detect platform from remote URL: $remote_url"
    print_error "Only GitHub and GitLab repositories are supported"
    exit 1
}

# Get platform with caching
get_platform() {
    local top_dir
    top_dir=$(git rev-parse --show-toplevel)
    local cache_file="${top_dir}/.git/.git-stack-submit-origin"

    # Check if cache file exists
    if [[ -f $cache_file ]]; then
        if [[ ${VERBOSE:-false} == true ]]; then
            print_info "Using cached platform from $cache_file" >&2
        fi
        cat "$cache_file"
        return 0
    fi

    # Cache doesn't exist, detect platform
    local platform
    platform=$(detect_platform)

    # Save to cache
    echo "$platform" >"$cache_file"

    if [[ ${VERBOSE:-false} == true ]]; then
        print_info "Cached platform to $cache_file" >&2
    fi

    echo "$platform"
}

# Get trunk branch from Graphite config
get_trunk_branch() {
    local top_dir
    top_dir=$(git rev-parse --show-toplevel)
    local config_file="${top_dir}/.git/.graphite_repo_config"

    if [[ ! -f $config_file ]]; then
        print_error "Graphite config file not found: $config_file"
        echo "Please run 'gt repo init' to initialize Graphite in this repo" >&2
        exit 1
    fi

    local trunk
    trunk=$(run jq -r '.trunk' "$config_file")

    if [[ -z $trunk ]] || [[ $trunk == "null" ]]; then
        print_error "Failed to read trunk branch from $config_file"
        exit 1
    fi

    echo "$trunk"
}

# Get current branch
get_current_branch() {
    git branch --show-current
}

# Get all Graphite-tracked branches
get_tracked_branches() {
    # Use gt log short -s to get all tracked branches
    local gt_log
    gt_log=$(run gt log short -s --all)

    local -a branches=()

    # Parse branches from gt log output
    while IFS= read -r line; do
        # Skip empty lines
        if [[ -z $line ]] || [[ $line =~ ^[[:space:]]*$ ]]; then
            continue
        fi

        # Extract branch name - look for patterns like "◯ branch-name" or "◉ branch-name"
        if [[ $line =~ [◯◉][[:space:]─│┘]*([a-zA-Z0-9/_.-]+) ]]; then
            local branch="${BASH_REMATCH[1]}"
            branches+=("$branch")
        fi
    done <<<"$gt_log"

    # Return unique branches
    printf '%s\n' "${branches[@]}" | sort -u
}
