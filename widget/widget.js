/**
 * COI AgentKit — Widget de Chat Embebible
 *
 * Uso:
 *   <script src="https://tu-backend.railway.app/widget/widget.js"></script>
 *
 * Configuración opcional (antes del script):
 *   <script>
 *     window.AgentKitConfig = {
 *       apiUrl: "https://tu-backend.railway.app",  // requerido si no está embebido
 *       title: "Asistente COI",
 *       subtitle: "¿En qué te puedo ayudar?",
 *       primaryColor: "#2563eb",
 *       position: "right"  // "right" o "left"
 *     };
 *   </script>
 */

(function () {
  "use strict";

  // ── Configuración ────────────────────────────────────────────────────────
  var config = window.AgentKitConfig || {};
  var API_URL = (config.apiUrl || "http://localhost:8000").replace(/\/$/, "");
  var TITLE = config.title || "Asistente COI";
  var SUBTITLE = config.subtitle || "¡Hola! ¿En qué te puedo ayudar hoy? 👁️";
  var PRIMARY = config.primaryColor || "#1d4ed8";
  var POSITION = config.position === "left" ? "left" : "right";

  // ── Session ID ────────────────────────────────────────────────────────────
  function getSessionId() {
    var key = "agentkit_session_id";
    var id = localStorage.getItem(key);
    if (!id) {
      id = "web-" + Date.now() + "-" + Math.random().toString(36).slice(2, 9);
      localStorage.setItem(key, id);
    }
    return id;
  }

  var sessionId = getSessionId();

  // ── Estilos ───────────────────────────────────────────────────────────────
  var css = `
    #agentkit-widget * { box-sizing: border-box; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }

    #agentkit-btn {
      position: fixed;
      bottom: 24px;
      ${POSITION}: 24px;
      width: 56px;
      height: 56px;
      border-radius: 50%;
      background: ${PRIMARY};
      color: #fff;
      border: none;
      cursor: pointer;
      font-size: 24px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 16px rgba(0,0,0,0.25);
      z-index: 9998;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    #agentkit-btn:hover { transform: scale(1.08); box-shadow: 0 6px 20px rgba(0,0,0,0.3); }

    #agentkit-panel {
      position: fixed;
      bottom: 92px;
      ${POSITION}: 16px;
      width: 360px;
      max-width: calc(100vw - 32px);
      height: 520px;
      max-height: calc(100vh - 120px);
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(0,0,0,0.18);
      display: flex;
      flex-direction: column;
      overflow: hidden;
      z-index: 9999;
      opacity: 0;
      transform: translateY(16px) scale(0.97);
      pointer-events: none;
      transition: opacity 0.22s ease, transform 0.22s ease;
    }
    #agentkit-panel.open {
      opacity: 1;
      transform: translateY(0) scale(1);
      pointer-events: all;
    }

    #agentkit-header {
      background: ${PRIMARY};
      color: #fff;
      padding: 14px 16px;
      display: flex;
      align-items: center;
      gap: 10px;
      flex-shrink: 0;
    }
    #agentkit-header-avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      background: rgba(255,255,255,0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      flex-shrink: 0;
    }
    #agentkit-header-info { flex: 1; min-width: 0; }
    #agentkit-header-title { font-weight: 600; font-size: 15px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    #agentkit-header-sub { font-size: 12px; opacity: 0.85; margin-top: 1px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    #agentkit-close {
      background: none;
      border: none;
      color: rgba(255,255,255,0.8);
      cursor: pointer;
      font-size: 20px;
      padding: 4px;
      line-height: 1;
      flex-shrink: 0;
      transition: color 0.15s;
    }
    #agentkit-close:hover { color: #fff; }

    #agentkit-messages {
      flex: 1;
      overflow-y: auto;
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 10px;
      background: #f8fafc;
      scroll-behavior: smooth;
    }
    #agentkit-messages::-webkit-scrollbar { width: 4px; }
    #agentkit-messages::-webkit-scrollbar-track { background: transparent; }
    #agentkit-messages::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }

    .ak-msg {
      max-width: 82%;
      padding: 9px 13px;
      border-radius: 14px;
      font-size: 14px;
      line-height: 1.5;
      word-wrap: break-word;
      white-space: pre-wrap;
    }
    .ak-msg.user {
      align-self: flex-end;
      background: ${PRIMARY};
      color: #fff;
      border-bottom-right-radius: 4px;
    }
    .ak-msg.assistant {
      align-self: flex-start;
      background: #fff;
      color: #1e293b;
      border: 1px solid #e2e8f0;
      border-bottom-left-radius: 4px;
      box-shadow: 0 1px 3px rgba(0,0,0,0.06);
    }

    .ak-typing {
      align-self: flex-start;
      background: #fff;
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      border-bottom-left-radius: 4px;
      padding: 10px 14px;
      display: flex;
      gap: 4px;
      align-items: center;
    }
    .ak-typing span {
      width: 7px;
      height: 7px;
      background: #94a3b8;
      border-radius: 50%;
      animation: ak-bounce 1.2s infinite ease-in-out;
    }
    .ak-typing span:nth-child(2) { animation-delay: 0.2s; }
    .ak-typing span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes ak-bounce {
      0%, 80%, 100% { transform: translateY(0); }
      40% { transform: translateY(-6px); }
    }

    #agentkit-footer {
      padding: 10px 12px;
      border-top: 1px solid #e2e8f0;
      display: flex;
      gap: 8px;
      align-items: flex-end;
      background: #fff;
      flex-shrink: 0;
    }
    #agentkit-input {
      flex: 1;
      border: 1px solid #cbd5e1;
      border-radius: 10px;
      padding: 9px 12px;
      font-size: 14px;
      color: #1e293b;
      resize: none;
      outline: none;
      line-height: 1.45;
      max-height: 100px;
      overflow-y: auto;
      transition: border-color 0.15s;
    }
    #agentkit-input:focus { border-color: ${PRIMARY}; }
    #agentkit-input::placeholder { color: #94a3b8; }
    #agentkit-send {
      width: 38px;
      height: 38px;
      border-radius: 10px;
      background: ${PRIMARY};
      color: #fff;
      border: none;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
      transition: background 0.15s, opacity 0.15s;
    }
    #agentkit-send:hover { opacity: 0.88; }
    #agentkit-send:disabled { opacity: 0.45; cursor: not-allowed; }
    #agentkit-send svg { width: 18px; height: 18px; }

    #agentkit-powered {
      text-align: center;
      font-size: 10px;
      color: #94a3b8;
      padding: 4px 0 8px;
      background: #fff;
    }
  `;

  // ── Inyectar CSS ───────────────────────────────────────────────────────────
  var style = document.createElement("style");
  style.textContent = css;
  document.head.appendChild(style);

  // ── HTML del widget ────────────────────────────────────────────────────────
  var wrapper = document.createElement("div");
  wrapper.id = "agentkit-widget";
  wrapper.innerHTML = `
    <button id="agentkit-btn" aria-label="Abrir chat">💬</button>

    <div id="agentkit-panel" role="dialog" aria-label="Chat de asistencia" aria-hidden="true">
      <div id="agentkit-header">
        <div id="agentkit-header-avatar">👁️</div>
        <div id="agentkit-header-info">
          <div id="agentkit-header-title">${TITLE}</div>
          <div id="agentkit-header-sub">${SUBTITLE}</div>
        </div>
        <button id="agentkit-close" aria-label="Cerrar chat">✕</button>
      </div>

      <div id="agentkit-messages" role="log" aria-live="polite"></div>

      <div id="agentkit-footer">
        <textarea
          id="agentkit-input"
          placeholder="Escribí tu consulta..."
          rows="1"
          aria-label="Mensaje"
          maxlength="1000"
        ></textarea>
        <button id="agentkit-send" aria-label="Enviar">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <line x1="22" y1="2" x2="11" y2="13"></line>
            <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
          </svg>
        </button>
      </div>
      <div id="agentkit-powered">Powered by AgentKit + Claude AI</div>
    </div>
  `;
  document.body.appendChild(wrapper);

  // ── Referencias DOM ────────────────────────────────────────────────────────
  var btn = document.getElementById("agentkit-btn");
  var panel = document.getElementById("agentkit-panel");
  var messages = document.getElementById("agentkit-messages");
  var input = document.getElementById("agentkit-input");
  var sendBtn = document.getElementById("agentkit-send");
  var closeBtn = document.getElementById("agentkit-close");

  // ── Estado ─────────────────────────────────────────────────────────────────
  var isOpen = false;
  var isLoading = false;
  var greeted = false;

  // ── Helpers ────────────────────────────────────────────────────────────────
  function scrollBottom() {
    messages.scrollTop = messages.scrollHeight;
  }

  function addMessage(role, text) {
    var div = document.createElement("div");
    div.className = "ak-msg " + role;
    div.textContent = text;
    messages.appendChild(div);
    scrollBottom();
    return div;
  }

  function showTyping() {
    var el = document.createElement("div");
    el.className = "ak-typing";
    el.innerHTML = "<span></span><span></span><span></span>";
    el.id = "ak-typing-indicator";
    messages.appendChild(el);
    scrollBottom();
  }

  function hideTyping() {
    var el = document.getElementById("ak-typing-indicator");
    if (el) el.remove();
  }

  function autoResize() {
    input.style.height = "auto";
    input.style.height = Math.min(input.scrollHeight, 100) + "px";
  }

  // ── Abrir / cerrar ─────────────────────────────────────────────────────────
  function openPanel() {
    isOpen = true;
    panel.classList.add("open");
    panel.setAttribute("aria-hidden", "false");
    btn.innerHTML = "✕";
    input.focus();

    if (!greeted) {
      greeted = true;
      addMessage("assistant", "¡Hola! 👋 Soy Anto, la asistente virtual del COI. ¿En qué te puedo ayudar hoy?");
    }
  }

  function closePanel() {
    isOpen = false;
    panel.classList.remove("open");
    panel.setAttribute("aria-hidden", "true");
    btn.innerHTML = "💬";
  }

  btn.addEventListener("click", function () {
    isOpen ? closePanel() : openPanel();
  });

  closeBtn.addEventListener("click", closePanel);

  // ── Enviar mensaje ─────────────────────────────────────────────────────────
  async function sendMessage() {
    var text = input.value.trim();
    if (!text || isLoading) return;

    isLoading = true;
    sendBtn.disabled = true;
    input.value = "";
    input.style.height = "auto";

    addMessage("user", text);
    showTyping();

    try {
      var res = await fetch(API_URL + "/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ session_id: sessionId, message: text })
      });

      hideTyping();

      if (!res.ok) {
        addMessage("assistant", "Lo siento, hubo un error al conectarme. Intentá de nuevo 🙏");
      } else {
        var data = await res.json();
        addMessage("assistant", data.response);
      }
    } catch (err) {
      hideTyping();
      addMessage("assistant", "No pude conectarme al servidor. Verificá tu conexión e intentá de nuevo.");
    }

    isLoading = false;
    sendBtn.disabled = false;
    input.focus();
  }

  sendBtn.addEventListener("click", sendMessage);

  input.addEventListener("keydown", function (e) {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  });

  input.addEventListener("input", autoResize);

  // ── Cerrar con Escape ──────────────────────────────────────────────────────
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && isOpen) closePanel();
  });

})();
