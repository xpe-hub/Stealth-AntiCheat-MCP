#!/bin/bash

# ================================
# 🚂 RAILWAY.APP AUTO-DEPLOY
# Stealth-AntiCheatX MCP Server
# ================================

echo "
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║    🚂 STEALTH-ANTICHEATX - RAILWAY.APP AUTO-DEPLOY                                  ║
║                                                                                      ║
║    🎯 Despliegue automático en Railway.app para control desde iPhone               ║
║    📱 Control total desde móvil sin PC necesaria                                   ║
║    ⚡ Despliegue 24/7 automático                                                    ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
"

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ] || [ ! -f "railway.json" ]; then
    echo "❌ Error: No estás en el directorio del proyecto MCP"
    echo "   Asegúrate de estar en Stealth-AntiCheat-MCP"
    exit 1
fi

echo "✅ Directorio correcto confirmado"

# Mostrar instrucciones paso a paso
echo ""
echo "🎯 PASOS PARA DESPLEGAR EN RAILWAY.APP:"
echo ""
echo "1️⃣  ABRIR en tu iPhone:"
echo "   📱 https://railway.app"
echo ""
echo "2️⃣  CREAR CUENTA:"
echo "   - Usa tu email
echo "   - No necesitas tarjeta de crédito para empezar"
echo ""
echo "3️⃣  CONECTAR GITHUB:"
echo "   - Click en 'Deploy from GitHub repo'"
echo "   - Autoriza Railway a acceder a tu GitHub"
echo "   - Selecciona: xpe-hub/Stealth-AntiCheat-MCP"
echo ""
echo "4️⃣  RAILWAY HARÁ TODO AUTOMÁTICAMENTE:"
echo "   ✅ Detecta que es proyecto Node.js"
echo "   ✅ Instala dependencias"
echo "   ✅ Compila TypeScript"
echo "   ✅ Despliega tu bot"
echo "   ✅ Te da URL para controlarlo"
echo ""
echo "5️⃣  CONTROLAR DESDE iPhone:"
echo "   - Ve a la URL que te dé Railway"
echo "   - Ve logs en tiempo real"
echo "   - Reinicia el servicio si necesitas"
echo "   - Monitorea estadísticas"
echo ""

# Verificar configuración
echo "🔍 VERIFICANDO CONFIGURACIÓN..."

if [ -f ".env" ]; then
    echo "✅ Archivo .env encontrado"
    if grep -q "DISCORD_BOT_TOKEN=" .env; then
        echo "✅ Token Discord configurado"
    else
        echo "⚠️  Configura tu .env antes de continuar"
    fi
else
    echo "❌ Archivo .env no encontrado"
    echo "   Copia .env.example a .env y configura tus credenciales"
fi

echo ""
echo "🚀 ¡LISTO PARA RAILWAY.APP!"
echo ""
echo "📚 DOCUMENTACIÓN ADICIONAL:"
echo "   - README.md (guía completa)"
echo "   - COMANDOS-EJECUTAR-MCP.md (todos los comandos)"
echo ""
echo "🆘 SOPORTE:"
echo "   - Discord: https://discord.gg/NxewbWvW8J"
echo "   - Email: xpepaneles@gmail.com"
echo ""

# Crear summary para Railway
echo "📋 RESUMEN PARA RAILWAY.APP:"
echo "Repository: https://github.com/xpe-hub/Stealth-AntiCheat-MCP"
echo "Branch: master"
echo "Root Directory: ./"
echo "Build Command: npm install --legacy-peer-deps && npm run build"
echo "Start Command: npm start"