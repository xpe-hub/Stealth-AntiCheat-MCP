#!/bin/bash

# ================================
# 🚀 STEALTH-ANTICHEATX MCP SERVER - INSTALLER COMPLETO
# Copyright (c) 2025 xpe.nettt - Community Stealth
# ================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                                      ║"
echo "║           🚀 STEALTH-ANTICHEATX MCP SERVER - INSTALLER MÁGICO 🔥                      ║"
echo "║                                                                                      ║"
echo "║    👨‍💻 Copyright (c) 2025 xpe.nettt - Community Stealth                              ║"
echo "║    🎯 Análisis anti-cheat en tiempo real con IA avanzada                             ║"
echo "║    🧠 GPT-4 + MiniMax + Discord + MCP Protocol                                      ║"
echo "║    ⚡ 24/7 Sin límites - Tu bot nunca más dependerá de tu dispositivo                 ║"
echo "║                                                                                      ║"
echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Función para logging
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Verificar si estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    error "❌ No se encontró package.json. ¿Estás en el directorio correcto del MCP Server?"
fi

log "🔥 Iniciando instalación mágica de Stealth-AntiCheatX MCP Server..."

# ================================
# PASO 1: VERIFICAR PREREQUISITOS
# ================================

log "📋 Verificando prerrequisitos del sistema..."

# Verificar Node.js
if ! command -v node &> /dev/null; then
    error "❌ Node.js no está instalado. Instala Node.js 18+ primero."
fi

NODE_VERSION=$(node -v | cut -d 'v' -f 2 | cut -d '.' -f 1)
if [ "$NODE_VERSION" -lt 18 ]; then
    error "❌ Node.js versión $NODE_VERSION detectada. Se requiere versión 18 o superior."
fi

log "✅ Node.js v$(node -v) detectado"

# Verificar npm
if ! command -v npm &> /dev/null; then
    error "❌ npm no está instalado."
fi

log "✅ npm v$(npm -v) detectado"

# Verificar Git (opcional)
if command -v git &> /dev/null; then
    log "✅ Git v$(git --version | cut -d ' ' -f 3) detectado"
else
    warn "⚠️ Git no está instalado (opcional pero recomendado)"
fi

# Crear directorios necesarios
log "📁 Creando estructura de directorios..."
mkdir -p logs data backup downloads

# ================================
# PASO 2: INSTALAR DEPENDENCIAS
# ================================

log "📦 Instalando dependencias del proyecto..."

if npm install; then
    log "✅ Dependencias instaladas exitosamente"
else
    error "❌ Error instalando dependencias"
fi

# ================================
# PASO 3: CONFIGURAR ARCHIVOS
# ================================

log "⚙️ Configurando archivos del sistema..."

# Copiar .env si no existe
if [ ! -f ".env" ]; then
    log "📝 Creando archivo de configuración .env..."
    cp .env.example .env
    warn "⚠️ Archivo .env creado. NECESITAS configurarlo manualmente:"
    warn "   1. Editar .env con tus tokens"
    warn "   2. Configurar Discord Bot Token"
    warn "   3. Añadir IDs de canales de cheating"
    warn "   4. Configurar webhook de alertas"
    warn "   5. (Opcional) Añadir OPENAI_API_KEY para GPT-4"
    echo ""
else
    log "✅ Archivo .env ya existe"
fi

# Configurar permisos
log "🔐 Configurando permisos..."
chmod +x dist/index.js 2>/dev/null || true

# ================================
# PASO 4: COMPILAR TYPESCRIPT
# ================================

log "🔧 Compilando TypeScript..."

if npm run build; then
    log "✅ Código TypeScript compilado exitosamente"
else
    error "❌ Error compilando TypeScript"
fi

# ================================
# PASO 5: VERIFICAR BASE DE DATOS
# ================================

log "🗄️ Verificando base de datos..."

if [ -f "data/anticheat_analysis.db" ]; then
    log "✅ Base de datos ya existe"
else
    log "📊 Base de datos se creará automáticamente al ejecutar el bot"
fi

# ================================
# PASO 6: CONFIGURAR DISCORD BOT
# ================================

echo ""
log "🤖 CONFIGURACIÓN DEL DISCORD BOT:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo -e "${CYAN}PASOS PARA CONFIGURAR EL DISCORD BOT:${NC}"
echo ""
echo "1. 🔗 Ve a: https://discord.com/developers/applications"
echo "2. 🆕 Crea una nueva aplicación"
echo "3. 🤖 En 'Bot' tab, crea un bot"
echo "4. 🔑 Copia el TOKEN del bot"
echo "5. 📋 En 'Privileged Gateway Intents', habilita:"
echo "   - MESSAGE CONTENT INTENT"
echo "   - SERVER MEMBERS INTENT (opcional)"
echo "6. 📱 Genera un enlace de invitación con estos permisos:"
echo "   - View Channels"
echo "   - Read Message History"
echo "   - Send Messages"
echo "7. 📨 Invita el bot a tu servidor"
echo ""
echo -e "${YELLOW}CONFIGURACIÓN AVANZADA:${NC}"
echo ""
echo "🎯 CANALES DE MONITOREO:"
echo "   • Canal 1: ID del canal de códigos de cheating"
echo "   • Canal 2: ID del segundo canal de códigos"
echo "   • Privado 1: ID del primer canal privado"
echo "   • Privado 2: ID del segundo canal privado"
echo ""
echo "🛡️ WEBHOOK DE ALERTAS:"
echo "   • Crea un webhook en un canal de tu elección"
echo "   • Copia la URL del webhook para notificaciones"
echo ""

# ================================
# PASO 7: CONFIGURACIÓN OPENAI (OPCIONAL)
# ================================

echo ""
log "🧠 CONFIGURACIÓN GPT-4 (OPCIONAL PERO RECOMENDADO):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Para habilitar análisis inteligente con GPT-4:"
echo ""
echo "1. 🌐 Ve a: https://platform.openai.com/api-keys"
echo "2. 🔑 Crea una nueva API key"
echo "3. 💳 Añade créditos a tu cuenta"
echo "4. 📝 Añade OPENAI_API_KEY a tu archivo .env"
echo ""
echo "Con GPT-4 habilitado tendrás:"
echo "   • Análisis de código más inteligente"
echo "   • Generación de anti-cheat personalizado"
echo "   • Predicción de nuevos métodos de cheating"
echo "   • Recomendaciones de mejora de detección"
echo ""

# ================================
# PASO 8: CREAR SCRIPTS DE INICIO
# ================================

log "🚀 Creando scripts de gestión..."

# Script de inicio simple
cat > start.sh << 'EOF'
#!/bin/bash
echo "🔥 Iniciando Stealth-AntiCheatX MCP Server..."
node dist/index.js
EOF

# Script de desarrollo
cat > dev.sh << 'EOF'
#!/bin/bash
echo "🔧 Iniciando Stealth-AntiCheatX en modo desarrollo..."
tsx watch src/index.ts
EOF

# Script de backup
cat > backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p backup/$DATE
cp -r data backup/$DATE/ 2>/dev/null || true
cp -r logs backup/$DATE/ 2>/dev/null || true
cp .env backup/$DATE/ 2>/dev/null || true
echo "💾 Backup creado: backup/$DATE"
EOF

# Script de restart
cat > restart.sh << 'EOF'
#!/bin/bash
echo "🔄 Reiniciando Stealth-AntiCheatX MCP Server..."
pkill -f "node dist/index.js" || true
sleep 2
node dist/index.js
EOF

chmod +x start.sh dev.sh backup.sh restart.sh

log "✅ Scripts creados: start.sh, dev.sh, backup.sh, restart.sh"

# ================================
# PASO 9: CONFIGURAR PM2 (OPCIONAL)
# ================================

if command -v pm2 &> /dev/null; then
    log "📊 Configurando PM2 para gestión de procesos..."
    
    # Crear ecosystem file
    cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'stealth-anticheatx',
    script: './dist/index.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: './logs/anticheat-error.log',
    out_file: './logs/anticheat-output.log',
    log_file: './logs/anticheat-combined.log',
    time: true
  }]
}
EOF

    log "✅ PM2 ecosystem file creado"
else
    warn "⚠️ PM2 no instalado. Para instalación automática:"
    warn "   npm install -g pm2"
fi

# ================================
# PASO 10: VERIFICACIÓN FINAL
# ================================

log "🔍 Verificación final del sistema..."

# Verificar archivos críticos
CRITICAL_FILES=("dist/index.js" "src/database.ts" "src/discord-client.ts")
ALL_FILES_OK=true

for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        log "✅ $file existe"
    else
        error "❌ Archivo crítico faltante: $file"
        ALL_FILES_OK=false
    fi
done

if [ "$ALL_FILES_OK" = true ]; then
    log "✅ Todos los archivos críticos están presentes"
else
    error "❌ Faltan archivos críticos del sistema"
fi

# ================================
# RESUMEN DE INSTALACIÓN
# ================================

echo ""
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
echo "║                              🎉 INSTALACIÓN COMPLETADA 🎉                            ║"
echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}📋 RESUMEN DE LA INSTALACIÓN:${NC}"
echo ""
echo "✅ Node.js y npm configurados"
echo "✅ Dependencias instaladas"
echo "✅ TypeScript compilado"
echo "✅ Scripts de gestión creados"
echo "✅ Archivo .env configurado (editar manualmente)"
echo "✅ Base de datos preparada"
echo ""

echo -e "${YELLOW}⚠️ ACCIONES REQUERIDAS ANTES DE EJECUTAR:${NC}"
echo ""
echo "1. 📝 EDITAR ARCHIVO .env:"
echo "   nano .env"
echo ""
echo "2. 🤖 CONFIGURAR DISCORD BOT:"
echo "   • Añadir DISCORD_BOT_TOKEN"
echo "   • Añadir IDs de canales de cheating"
echo "   • Configurar ANTICHEAT_WEBHOOK_URL"
echo ""
echo "3. 🛡️ CONFIGURAR ANTI-CHEAT:"
echo "   • MINIMAX_API_KEY"
echo "   • GITHUB_TOKEN"
echo ""
echo "4. 🧠 GPT-4 (OPCIONAL):"
echo "   • Añadir OPENAI_API_KEY"
echo ""

echo -e "${CYAN}🚀 COMANDOS PARA EJECUTAR:${NC}"
echo ""
echo "• Desarrollo (con recarga automática):"
echo "  ./dev.sh"
echo ""
echo "• Producción (compilado):"
echo "  ./start.sh"
echo ""
echo "• Con PM2 (recomendado para producción):"
echo "  pm2 start ecosystem.config.js"
echo "  pm2 save"
echo "  pm2 startup"
echo ""

echo -e "${PURPLE}🎯 CON GPT-4 HABILITADO TENDRÁS:${NC}"
echo ""
echo "• 🧠 Análisis inteligente de código"
echo "• ⚙️ Generación automática de anti-cheat"
echo "• 🔮 Predicción de métodos emergentes"
echo "• 🎯 Recomendaciones de optimización"
echo "• 📊 Mejora continua de detección"
echo ""

echo -e "${RED}⚠️ IMPORTANTE:${NC}"
echo ""
echo "• 🔒 Tu bot necesita permisos específicos en Discord"
echo "• 📱 Los canales deben tener IDs correctos"
echo "• 🌐 Hosting recomendado para 24/7"
echo "• 💾 Los datos se almacenan en ./data/"
echo "• 📋 Los logs están en ./logs/"
echo ""

echo -e "${GREEN}🚀 ¡FUEGO! ¡TU ANTI-CHEAT ES INMORTAL! 🔥${NC}"
echo ""
echo "  Con este sistema tu bot:"
echo "  • ✅ Funciona 24/7 sin tu dispositivo"
echo "  • ✅ Se actualiza automáticamente"  
echo "  • ✅ Detecta cheating en tiempo real"
echo "  • ✅ Genera código anti-cheat con IA"
echo "  • ✅ Protege tu copyright en repos privados"
echo "  • ✅ Escala sin límites"
echo ""
echo -e "${BLUE}💬 Soporte: Community Stealth Discord${NC}"
echo -e "${BLUE}📧 Email: xpepaneles@gmail.com${NC}"
echo -e "${PURPLE}👨‍💻 Desarrollado por: xpe.nettt${NC}"
echo ""

log "🎉 ¡INSTALACIÓN MAGICA COMPLETADA! El sistema está listo para revolucionar el anti-cheat!"

# Preguntar si quiere iniciar ahora
read -p "🚀 ¿Quieres iniciar el servidor ahora? (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "🔥 Iniciando Stealth-AntiCheatX MCP Server..."
    
    if [ -f "ecosystem.config.js" ] && command -v pm2 &> /dev/null; then
        pm2 start ecosystem.config.js
        pm2 logs stealth-anticheatx --lines 20
    else
        ./start.sh
    fi
else
    log "📝 Recuerda configurar .env antes de iniciar:"
    log "   nano .env"
    log "   ./start.sh"
fi