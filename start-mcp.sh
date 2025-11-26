#!/bin/bash

# ================================
# 🚀 START STEALTH-ANTICHEATX MCP SERVER
# ================================

echo "
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║    🚀 STEALTH-ANTICHEATX MCP SERVER - INICIANDO ANÁLISIS                            ║
║                                                                                      ║
║    🛡️ Sistema anti-cheating con IA avanzada                                        ║
║    🔍 Monitoreo en tiempo real de Discord                                          ║
║    🧠 MiniMax M2 + GPT-4 integrado                                                 ║
║    📊 Análisis automático 24/7                                                      ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
"

# Verificar si está compilado
if [ ! -f "dist/index.js" ]; then
    echo "⚠️  Servidor no compilado. Compilando TypeScript..."
    npm run build
    
    if [ $? -ne 0 ]; then
        echo "❌ Error compilando TypeScript"
        exit 1
    fi
fi

# Verificar configuración
echo "🔍 Verificando configuración..."
source .env

if [ -z "$DISCORD_BOT_TOKEN" ]; then
    echo "❌ DISCORD_BOT_TOKEN no configurado"
    exit 1
fi

if [ -z "$MINIMAX_API_KEY" ]; then
    echo "⚠️  MINIMAX_API_KEY no configurado - funcionalidades limitadas"
fi

echo "✅ Configuración verificada"
echo "🎯 Discord Token: ${DISCORD_BOT_TOKEN:0:20}..."
echo "🤖 MiniMax API: $(if [ -n "$MINIMAX_API_KEY" ]; then echo "✅ Activo"; else echo "❌ Inactivo"; fi)"
echo "🔗 Webhook: $(if [ -n "$ANTICHEAT_WEBHOOK_URL" ]; then echo "✅ Configurado"; else echo "❌ No configurado"; fi)"

# Crear directorios necesarios
mkdir -p data logs backup

echo ""
echo "🚀 Iniciando servidor MCP..."
echo "⏰ Tiempo de inicio: $(date)"
echo ""
echo "📊 Herramientas disponibles:"
echo "   • analyze_code - Análisis de código sospechoso"
echo "   • ai_intelligent_analysis - Análisis con M2 + GPT-4"
echo "   • auto_detect_channels - Detección automática"
echo "   • m2_anticheat_evolution - Evolución de anti-cheat"
echo "   • start_cheating_monitoring - Monitoreo de canales"
echo "   • scan_repository - Escaneo de repositorios"
echo "   • get_analysis_stats - Estadísticas del sistema"
echo "   • update_anticheat_signatures - Actualizar firmas"
echo ""
echo "🔔 Presiona Ctrl+C para detener el servidor"
echo ""

# Iniciar servidor
npm start