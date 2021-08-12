# Paths
export PATH="$HOME/.local/bin:$PATH"

# Emacs
export PATH="$HOME/tools/emacs/src:$HOME/tools/emacs/lib-src:$PATH"
# NB: clobbers $C_INCLUDE_PATH!
export C_INCLUDE_PATH="$HOME/tools/emacs/src:$HOME/tools/emacs/lib:$HOME/tools/emacs/lib-src"

# Rust dev
export MODE=debug
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$HOME/.rustup/toolchains/1.47.0-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library/"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

if [[ ! -d "$HOME/tools/clingo/b/lib" ]]; then
  echo "expected clingo lib dir to exist" >&2
else
  if [[ -z "$PYTHONPATH" ]]; then
    export PYTHONPATH="$HOME/tools/clingo/b/bin/python"
  else
    export PYTHONPATH="$HOME/tools/clingo/b/bin/python:$PYTHONPATH"
  fi
fi

# Node.js
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/Downloads/node-v14.17.3-linux-x64/bin:$PATH"

# time zone
export TZ='America/New_York'
