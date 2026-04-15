"""
Test local del agente web — simula conversación desde la terminal.
Uso: python tests/test_local.py
"""

import asyncio
import sys
import os

# Asegurarse de que el path raíz esté en sys.path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from agent.brain import generar_respuesta
from agent.memory import inicializar_db, guardar_mensaje, obtener_historial, limpiar_historial

SESSION_ID = "test-local-001"


async def main():
    await inicializar_db()
    print("\n=== COI AgentKit — Test Local ===")
    print("Comandos: 'limpiar' para reiniciar, 'salir' para terminar\n")

    while True:
        try:
            user_input = input("Vos: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\n\nHasta luego!")
            break

        if not user_input:
            continue

        if user_input.lower() == "salir":
            print("Hasta luego!")
            break

        if user_input.lower() == "limpiar":
            await limpiar_historial(SESSION_ID)
            print("[Historial limpiado]\n")
            continue

        await guardar_mensaje(SESSION_ID, "user", user_input)
        historial = await obtener_historial(SESSION_ID)
        historial_previo = historial[:-1]

        print("Anto: ", end="", flush=True)
        respuesta = await generar_respuesta(user_input, historial_previo)
        print(respuesta)
        await guardar_mensaje(SESSION_ID, "assistant", respuesta)
        print()


if __name__ == "__main__":
    asyncio.run(main())
