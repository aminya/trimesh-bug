#!/usr/bin/bash

# Function to install a package if it is not already installed
may_sudo=$(command -v sudo || echo "")
function may_install() {
    if ! dpkg -s "$1" >/dev/null 2>&1; then
        $may_sudo "apt-get" install -y "$1"
    fi
}

# Python3
if ! command -v python3 &>/dev/null; then
    may_install python3
    may_install python-is-python3
fi

# Poetry
if ! command -v poetry &>/dev/null; then
    curl -sSL https://install.python-poetry.org | python3 -

    echo "Adding Poetry to the PATH via ~/.bashrc"
    EXPORT_STR="export PATH=\$HOME/.local/bin:\$PATH"
    echo "$EXPORT_STR" >>"$HOME/.bashrc"
    eval "$EXPORT_STR"
fi

# Create a virtual environment
poetry config virtualenvs.in-project true
poetry env use python3

# Install Poetry dependencies
poetry install --no-root

# Open the Python environment
if [[ $CI == "true" ]] || [[ $TERM_PROGRAM == "WarpTerminal" ]]; then
    # Activate the existing shell if the terminal program is CI or WarpTerminal
    source $(poetry env list --full-path | head -n 1 | sed 's/ (Activated)//')/bin/activate
else
    # Crate a new shell via poetry
    poetry shell
fi
