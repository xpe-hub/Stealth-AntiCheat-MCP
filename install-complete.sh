#!/bin/bash

# ================================
# 🚀 INSTALADOR AUTOMÁTICO
# Stealth-AntiCheatX MCP Server
# ================================

echo "
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║    🚀 STEALTH-ANTICHEATX MCP SERVER - INSTALACIÓN AUTOMÁTICA                       ║
║                                                                                      ║
║    🎯 Sistema MCP Avanzado para detección de cheating en tiempo real               ║
║    🤖 Integración con MiniMax AI y GPT-4                                          ║
║    🛡️ Monitoreo continuo de servidores Discord                                     ║
║    📊 Análisis automático de código y patrones sospechosos                         ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
"

# Verificar Node.js
echo "🔍 Verificando Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Instala Node.js 18+ desde https://nodejs.org"
    exit 1
fi

NODE_VERSION=$(node --version)
echo "✅ Node.js detectado: $NODE_VERSION"

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm no está instalado"
    exit 1
fi

echo "✅ npm detectado: $(npm --version)"

# Verificar .env
if [ ! -f .env ]; then
    echo "⚠️  Archivo .env no encontrado. Creando desde plantilla..."
    if [ -f .env.template ]; then
        cp .env.template .env
        echo "✅ Archivo .env creado desde plantilla"
        echo "⚠️  IMPORTANTE: Edita .env con tus credenciales antes de continuar"
        echo "   nano .env  # o tu editor preferido"
        read -p "Presiona ENTER después de configurar .env..."
    else
        echo "❌ No se encontró .env.template"
        exit 1
    fi
fi

# Instalar dependencias
echo "📦 Instalando dependencias..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencias instaladas correctamente"
else
    echo "❌ Error instalando dependencias"
    exit 1
fi

# Compilar TypeScript
echo "🔧 Compilando TypeScript..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ TypeScript compilado correctamente"
else
    echo "❌ Error compilando TypeScript"
    exit 1
fi

# Verificar archivos de configuración
echo "🔍 Verificando configuración..."

if [ -f dist/index.js ]; then
    echo "✅ Archivo principal compilado"
else
    echo "❌ Error: Archivo principal no encontrado"
    exit 1
fi

if [ -f .env ]; then
    echo "✅ Archivo de configuración .env encontrado"
else
    echo "❌ Error: Archivo .env no encontrado"
    exit 1
fi

# Crear scripts de inicio
echo "⚙️  Creando scripts de gestión..."

# Script de inicio
cat > start-mcp.sh << 'EOF'
#!/bin/bash
echo "🚀 Iniciando Stealth-AntiCheatX MCP Server..."
echo "📊 Monitoreo activo para detección de cheating"
echo "🔄 Presiona Ctrl+C para detener"
echo ""
npm start
EOF

# Script de desarrollo
cat > dev-mcp.sh << 'EOF'
#!/bin/bash
echo "🔧 Iniciando servidor MCP en modo desarrollo..."
echo "🔄 Hot reload habilitado"
echo ""
npm run dev
EOF

# Script de validación
cat > validate-mcp.sh << 'EOF'
#!/bin/bash
echo "🔍 Validando configuración del servidor MCP..."

# Verificar archivo .env
if [ ! -f .env ]; then
    echo "❌ Archivo .env no encontrado"
    exit 1
fi

# Verificar variables críticas
source .env

if [ -z "$DISCORD_BOT_TOKEN" ]; then
    echo "❌ DISCORD_BOT_TOKEN no configurado"
    exit 1
fi

if [ -z "$MINIMAX_API_KEY" ]; then
    echo "⚠️  MINIMAX_API_KEY no configurado - funcionalidades de IA limitadas"
fi

echo "✅ Configuración validada"
echo "🎯 Discord Token: ${DISCORD_BOT_TOKEN:0:20}..."
echo "🤖 MiniMax API: $(if [ -n "$MINIMAX_API_KEY" ]; then echo "✅ Configurado"; else echo "❌ No configurado"; fi)"
echo "🔗 Webhook: $(if [ -n "$ANTICHEAT_WEBHOOK_URL" ]; then echo "✅ Configurado"; else echo "❌ No configurado"; fi)"
echo "📊 Base de datos: $(if [ -d "./data" ]; then echo "✅ Directorio listo"; else echo "❌ No encontrado"; fi)"
EOF

chmod +x start-mcp.sh
chmod +x dev-mcp.sh
chmod +x validate-mcp.sh

echo ""
echo "🎉 ¡INSTALACIÓN COMPLETADA!"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo ""
echo "1. 🔧 Valida la configuración:"
echo "   ./validate-mcp.sh"
echo ""
echo "2. 🚀 Inicia el servidor MCP:"
echo "   ./start-mcp.sh"
echo ""
echo "3. 🔧 Para desarrollo (con hot reload):"
echo "   ./dev-mcp.sh"
echo ""
echo "4. 📊 Herramientas MCP disponibles:"
echo "   • analyze_code - Analiza código para detectar cheating"
echo "   • start_cheating_monitoring - Inicia monitoreo de canales"
echo "   • ai_intelligent_analysis - Análisis inteligente con M2 + GPT-4"
echo "   • auto_detect_channels - Detecta canales sospechosos automáticamente"
echo "   • m2_anticheat_evolution - Evoluciona anti-cheat usando IA"
echo "   • scan_repository - Escanea repositorios GitHub"
echo "   • get_analysis_stats - Estadísticas del sistema"
echo "   • update_anticheat_signatures - Actualiza firmas de detección"
echo ""
echo "🌐 El servidor funcionará 24/7 monitoreando tu Discord"
echo "🔔 Recibirás notificaciones automáticas de actividad sospechosa"
echo ""
echo "📞 Soporte: https://discord.gg/NxewbWvW8J"
echo ""
echo "¡Tu sistema anti-cheat está listo para proteger tu servidor! 🛡️"
