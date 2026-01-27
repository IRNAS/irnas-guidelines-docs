#!/usr/bin/env bash
#
# Installation script for git-stack tools
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/<path to script>/install.sh | bash
#
set -euo pipefail

# Configuration
REPO_USER="irnas"
REPO_NAME="irnas-guidelines-docs"
BRANCH="main"
REPO_DIR="tools/git_stack"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# Files to install
FILES=(
    "_git-stack-lib.sh"
    "git-stack-submit"
    "git-sync"
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Check dependencies
check_dependencies() {
    local missing_deps=()

    # Required: git
    if ! command_exists git; then
        missing_deps+=("git")
    fi

    # Required: jq
    if ! command_exists jq; then
        missing_deps+=("jq")
    fi

    # Required: Graphite CLI
    if ! command_exists gt; then
        missing_deps+=("gt")
    fi

    # Required: gh or glab
    local has_platform_cli=false
    if command_exists gh; then
        has_platform_cli=true
    fi

    if command_exists glab; then
        has_platform_cli=true
    fi

    if [[ $has_platform_cli == false ]]; then
        missing_deps+=("gh-or-glab")
    fi

    # curl is needed for this installer
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi

    # If we have missing required dependencies, show installation instructions
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies"
        echo ""
        print_info "Please install the following:"
        echo ""

        for dep in "${missing_deps[@]}"; do
            case "$dep" in
            git)
                echo "  • git: https://git-scm.com/downloads"
                ;;
            jq)
                echo "  • jq: https://stedolan.github.io/jq/download/"
                echo "    - macOS: brew install jq"
                echo "    - Ubuntu/Debian: sudo apt-get install jq"
                ;;
            gt)
                echo "  • Graphite CLI: https://graphite.dev/docs/installing-the-cli"
                echo "    - npm: npm install -g @withgraphite/graphite-cli@stable"
                echo "    - brew: brew install --cask graphite"
                ;;
            gh-or-glab)
                echo "  • GitHub CLI (gh) OR GitLab CLI (glab):"
                echo "    - GitHub CLI: https://cli.github.com/"
                echo "      macOS: brew install gh"
                echo "      Ubuntu/Debian: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
                echo "    - GitLab CLI: https://gitlab.com/gitlab-org/cli"
                echo "      macOS: brew install glab"
                echo "      Ubuntu/Debian: https://gitlab.com/gitlab-org/cli#installation"
                ;;
            curl)
                echo "  • curl: https://curl.se/download.html"
                ;;
            esac
        done
        echo ""
        exit 1
    fi
}

# Download a file from GitHub
download_file() {
    local file="$1"
    local url="https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/refs/heads/${BRANCH}/${REPO_DIR}/${file}"
    local output="/tmp/${file}"

    if ! curl -fsSL "$url" -o "$output"; then
        print_error "Failed to download $file from $url"
        return 1
    fi

    echo "$output"
}

# Check if we need sudo for installation
need_sudo() {
    if [[ -w $INSTALL_DIR ]]; then
        return 1 # Don't need sudo
    else
        return 0 # Need sudo
    fi
}

# Install files
install_files() {
    print_info "Installing git-stack tools..."
    echo ""

    # Check if install directory exists
    if [[ ! -d $INSTALL_DIR ]]; then
        if need_sudo; then
            sudo mkdir -p "$INSTALL_DIR"
        else
            mkdir -p "$INSTALL_DIR"
        fi
    fi

    # Determine if we need sudo
    local use_sudo=""
    if need_sudo; then
        use_sudo="sudo"
        print_info "Using sudo for installation (requires password)"
    fi

    # Download and install each file
    for file in "${FILES[@]}"; do
        print_info "Downloading $file..."

        local tmp_file
        if ! tmp_file=$(download_file "$file"); then
            print_error "Failed to download $file"
            exit 1
        fi

        # Install the file
        if [[ -n $use_sudo ]]; then
            sudo cp "$tmp_file" "$INSTALL_DIR/$file"
        else
            cp "$tmp_file" "$INSTALL_DIR/$file"
        fi

        # Make executable scripts executable
        if [[ $file == "git-stack-submit" ]] || [[ $file == "git-sync" ]]; then
            if [[ -n $use_sudo ]]; then
                sudo chmod +x "$INSTALL_DIR/$file"
            else
                chmod +x "$INSTALL_DIR/$file"
            fi
        fi

        # Clean up temp file
        rm "$tmp_file"

        print_success "✓ Installed $file"
    done

    echo ""
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    echo ""

    local all_ok=true

    for file in "${FILES[@]}"; do
        if [[ ! -f "$INSTALL_DIR/$file" ]]; then
            print_error "✗ $file not found in $INSTALL_DIR"
            all_ok=false
        elif [[ $file == "git-stack-submit" ]] || [[ $file == "git-sync" ]]; then
            if [[ ! -x "$INSTALL_DIR/$file" ]]; then
                print_error "✗ $file is not executable"
                all_ok=false
            else
                print_success "✓ $file is installed and executable"
            fi
        else
            print_success "✓ $file is installed"
        fi
    done

    echo ""

    if [[ $all_ok == false ]]; then
        print_error "Installation verification failed"
        exit 1
    fi

    print_success "Installation verification successful!"
}

# Show next steps
show_next_steps() {
    echo ""
    echo "=========================================="
    print_success "Installation complete!"
    echo "=========================================="
    echo ""
    print_info "The following commands are now available:"
    echo "  • git stack-submit - Submit stacked branches as PRs/MRs"
    echo "  • git sync         - Sync branches and clean up merged PRs/MRs"
    echo ""
    print_info "Read the help description:"
    echo "  git stack-submit -h"
    echo "  git sync -h"
    echo ""
    print_info "Quick usage:"
    echo "  cd your-repo"
    echo "  git-stack-submit       # Submit current stack"
    echo "  git-sync               # Sync and clean up merged branches"
    echo ""
    print_info "To update these scripts, just re-run the installer:"
    echo "  curl -fsSL https://raw.githubusercontent.com/${REPO_USER}/${REPO_NAME}/${BRANCH}/${REPO_DIR}/install.sh | bash"
    echo ""

    # Check if INSTALL_DIR is in PATH
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_warning "Note: $INSTALL_DIR is not in your PATH"
        print_info "Add it to your PATH by adding this line to your ~/.bashrc or ~/.zshrc:"
        echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
        echo ""
    fi
}

# Main installation process
main() {
    echo ""
    echo "=========================================="
    print_info "git-stack tools installer"
    echo "=========================================="
    echo ""

    check_dependencies
    install_files
    verify_installation
    show_next_steps
}

main "$@"
