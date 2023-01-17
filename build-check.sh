#!/bin/bash

POETRYLOCK=./poetry/poetry.lock
REQUIREMENTS=./poetry/requirements.txt

if [ -f "$POETRYLOCK" ] && [ -f "$REQUIREMENTS" ]; then
  echo "poetry.lock and requirements.txt created successfully"
  exit 0
fi

