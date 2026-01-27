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
    echo -e "${YELLOW}$1${NC}"
}

# Check if required commands are available
check_requirements() {
    if ! git rev-parse --git-dir &>/dev/null; then
        print_error "Not a git repository (or any of the parent directories)"
        exit 1
    fi

    if ! command -v gt &>/dev/null; then
        print_error "Graphite CLI (gt) is not installed or not in PATH"
        echo "Please install Graphite: https://graphite.dev/docs/installing-the-cli"
        exit 1
    fi

    if ! command -v jq &>/dev/null; then
        print_error "jq is not installed or not in PATH"
        echo "Please install jq: https://stedolan.github.io/jq/"
        exit 1
    fi
}

# Detect whether this is a GitHub or GitLab repository
detect_platform() {
    local gh_output

    if [[ ${VERBOSE:-false} == true ]]; then
        print_info "Detecting platform (GitHub or GitLab)..." >&2
    fi

    # Try GitHub first
    gh_output=$(gh repo view 2>&1 || true)

    if ! echo "$gh_output" | grep -q "none of the git remotes configured for this repository point to a known GitHub host"; then
        # GitHub detected
        if ! command -v gh &>/dev/null; then
            print_error "This is a GitHub repository but 'gh' CLI is not installed" >&2
            echo "Please install GitHub CLI: https://cli.github.com/" >&2
            exit 1
        fi
        echo "github"
        return 0
    fi

    # Try GitLab
    if ! command -v glab &>/dev/null; then
        print_error "This is a GitLab repository but 'glab' CLI is not installed" >&2
        echo "Please install GitLab CLI: https://gitlab.com/gitlab-org/cli" >&2
        exit 1
    fi
    echo "gitlab"
}

# Get platform with caching
get_platform() {
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
        print_error "Graphite config file not found: $config_file" >&2
        echo "Please run 'gt repo init' to initialize Graphite in this repo" >&2
        exit 1
    fi

    local trunk
    trunk=$(jq -r '.trunk' "$config_file" 2>&1)

    if [[ $? -ne 0 ]] || [[ -z $trunk ]] || [[ $trunk == "null" ]]; then
        print_error "Failed to read trunk branch from $config_file" >&2
        echo "Output: $trunk" >&2
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
    gt_log=$(gt log short -s --all 2>&1)

    if [[ $? -ne 0 ]]; then
        print_error "Failed to get tracked branches from 'gt log short -s --all'" >&2
        echo "Output: $gt_log" >&2
        exit 1
    fi

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
