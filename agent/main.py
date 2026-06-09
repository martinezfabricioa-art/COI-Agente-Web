# agent/main.py — Servidor FastAPI para el agente web Centro de la Visión

"""
API REST del agente web. Expone endpoints para el widget de chat embebible.
"""

import os
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from dotenv import load_dotenv

from agent.brain import generar_respuesta
from agent.memory import inicializar_db, guardar_mensaje, obtener_historial, limpiar_historial

load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger("agentkit")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Inicializa la base de datos al arrancar."""
    await inicializar_db()
    logger.info("Base de datos inicializada")
    yield


app = FastAPI(
    title="Centro de la Visión Agente Web",
    description="API del asistente virtual Centro de la Visión Neuquén",
    version="1.0.0",
    lifespan=lifespan
)

# CORS — permite peticiones desde cualquier origen (configurable via env)
allowed_origins = os.getenv("ALLOWED_ORIGINS", "*")
origins = ["*"] if allowed_origins == "*" else allowed_origins.split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=False,
    allow_methods=["GET", "POST", "DELETE"],
    allow_headers=["Content-Type"],
)

# Servir el widget como archivo estático
if os.path.exists("widget"):
    app.mount("/widget", StaticFiles(directory="widget"), name="widget")


# ── Modelos de request/response ──────────────────────────────────────────────

class ChatRequest(BaseModel):
    session_id: str
    message: str


class ChatResponse(BaseModel):
    session_id: str
    response: str


# ── Endpoints ─────────────────────────────────────────────────────────────────

@app.get("/health")
async def health():
    """Health check."""
    return {"status": "ok", "service": "Centro de la Visión Agente Web"}


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    """
    Recibe un mensaje del widget y retorna la respuesta del agente.

    Body: { "session_id": "uuid", "message": "texto del usuario" }
    """
    if not req.session_id or not req.session_id.strip():
        raise HTTPException(status_code=400, detail="session_id es requerido")

    if not req.message or not req.message.strip():
        raise HTTPException(status_code=400, detail="message es requerido")

    session_id = req.session_id.strip()
    mensaje = req.message.strip()

    logger.info(f"[{session_id[:8]}...] Usuario: {mensaje[:80]}")

    # Guardar mensaje del usuario
    await guardar_mensaje(session_id, "user", mensaje)

    # Obtener historial previo (sin el mensaje recién guardado)
    historial = await obtener_historial(session_id, limite=20)
    # El historial incluye el mensaje actual al final — lo excluimos para no duplicar
    historial_previo = historial[:-1] if historial else []

    # Generar respuesta
    respuesta = await generar_respuesta(mensaje, historial_previo)

    # Guardar respuesta del asistente
    await guardar_mensaje(session_id, "assistant", respuesta)

    logger.info(f"[{session_id[:8]}...] Asistente: {respuesta[:80]}")

    return ChatResponse(session_id=session_id, response=respuesta)


@app.delete("/chat/{session_id}")
async def limpiar_chat(session_id: str):
    """Borra el historial de conversación de una sesión."""
    await limpiar_historial(session_id)
    logger.info(f"Historial limpiado para sesión {session_id[:8]}...")
    return {"status": "ok", "message": "Historial borrado"}
