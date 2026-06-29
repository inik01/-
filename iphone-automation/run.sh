#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

if [ ! -d .venv ]; then
  python3 -m venv .venv
fi

source .venv/bin/activate
pip install -q -r requirements.txt

export DATA_DIR="${DATA_DIR:-$(pwd)/data}"
echo "Сервер: http://127.0.0.1:8000"
echo "Документация API: http://127.0.0.1:8000/docs"
exec uvicorn server.main:app --host 0.0.0.0 --port 8000 --reload
