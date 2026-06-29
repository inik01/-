"""Мини-API для автоматизаций iPhone через приложение «Команды» (Shortcuts)."""

from __future__ import annotations

import json
import os
import random
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from uuid import uuid4

from fastapi import FastAPI, Header, HTTPException
from pydantic import BaseModel, Field

DATA_DIR = Path(os.environ.get("DATA_DIR", Path(__file__).resolve().parent.parent / "data"))
NOTES_FILE = DATA_DIR / "notes.json"
WEBHOOKS_FILE = DATA_DIR / "webhooks.json"

TIPS_RU = [
    "Выпей стакан воды — мозг скажет спасибо.",
    "Сделай 5 глубоких вдохов перед следующей задачей.",
    "Проверь календарь на ближайшие 2 часа.",
    "Отложи телефон на 10 минут — лучший перерыв.",
    "Запиши одну вещь, за которую ты благодарен сегодня.",
    "Встань и разомнись — спина оценит.",
    "Отправь короткое сообщение близкому человеку.",
]

app = FastAPI(
    title="iPhone Automation API",
    description="Простой бэкенд для Apple Shortcuts",
    version="1.0.0",
)


class NoteCreate(BaseModel):
    text: str = Field(..., min_length=1, max_length=2000)
    tags: list[str] = Field(default_factory=list)


class WebhookPayload(BaseModel):
    event: str = Field(..., min_length=1, max_length=100)
    data: dict[str, Any] = Field(default_factory=dict)


def _ensure_data_dir() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)


def _load_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def _save_json(path: Path, data: Any) -> None:
    _ensure_data_dir()
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def _check_token(authorization: str | None) -> None:
    expected = os.environ.get("API_TOKEN")
    if not expected:
        return
    if not authorization or authorization != f"Bearer {expected}":
        raise HTTPException(status_code=401, detail="Неверный или отсутствующий токен")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/api/brief")
def daily_brief() -> dict[str, Any]:
    """Утренний/дневной брифинг для команды «Команды»."""
    now = datetime.now(timezone.utc).astimezone()
    weekdays_ru = [
        "понедельник",
        "вторник",
        "среда",
        "четверг",
        "пятница",
        "суббота",
        "воскресенье",
    ]
    months_ru = [
        "января",
        "февраля",
        "марта",
        "апреля",
        "мая",
        "июня",
        "июля",
        "августа",
        "сентября",
        "октября",
        "ноября",
        "декабря",
    ]
    tip = random.choice(TIPS_RU)
    greeting = "Доброе утро" if now.hour < 12 else "Добрый день" if now.hour < 18 else "Добрый вечер"
    date_spoken = f"{now.day} {months_ru[now.month - 1]} {now.year}"

    return {
        "greeting": greeting,
        "date": now.strftime("%d.%m.%Y"),
        "time": now.strftime("%H:%M"),
        "weekday": weekdays_ru[now.weekday()],
        "tip": tip,
        "spoken": f"{greeting}! Сегодня {weekdays_ru[now.weekday()]}, {date_spoken}. Совет дня: {tip}",
    }


@app.post("/api/notes")
def create_note(
    note: NoteCreate,
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    """Быстрая заметка с iPhone (голос → текст → сюда)."""
    _check_token(authorization)
    notes = _load_json(NOTES_FILE, [])
    entry = {
        "id": str(uuid4()),
        "text": note.text,
        "tags": note.tags,
        "created_at": datetime.now(timezone.utc).isoformat(),
    }
    notes.insert(0, entry)
    _save_json(NOTES_FILE, notes[:200])
    return {"ok": True, "note": entry}


@app.get("/api/notes")
def list_notes(
    limit: int = 10,
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    _check_token(authorization)
    notes = _load_json(NOTES_FILE, [])
    return {"notes": notes[: max(1, min(limit, 50))]}


@app.post("/api/webhook")
def webhook(
    payload: WebhookPayload,
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    """Универсальный webhook: любая автоматизация может слать сюда события."""
    _check_token(authorization)
    events = _load_json(WEBHOOKS_FILE, [])
    entry = {
        "id": str(uuid4()),
        "event": payload.event,
        "data": payload.data,
        "received_at": datetime.now(timezone.utc).isoformat(),
    }
    events.insert(0, entry)
    _save_json(WEBHOOKS_FILE, events[:500])
    return {"ok": True, "event": entry}


@app.get("/api/webhooks")
def list_webhooks(
    event: str | None = None,
    limit: int = 20,
    authorization: str | None = Header(default=None),
) -> dict[str, Any]:
    _check_token(authorization)
    events = _load_json(WEBHOOKS_FILE, [])
    if event:
        events = [e for e in events if e.get("event") == event]
    return {"events": events[: max(1, min(limit, 100))]}
