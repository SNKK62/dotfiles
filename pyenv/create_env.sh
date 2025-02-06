#!/bin/bash

echo '{
  "venvPath": "'$HOME'/.pyenv/versions",
  "venv": "'$PYENV_VERSION'",
}' > pyrightconfig.json
