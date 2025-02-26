#!/bin/bash

echo '{
  "venvPath": "'$HOME'/.pyenv/versions",
  "venv": "'$PYENV_VERSION'",
}' > pyrightconfig.json

echo "[mypy]
python_executable = $(which python3)
" > .mypy.ini
