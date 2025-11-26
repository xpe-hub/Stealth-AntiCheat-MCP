#!/bin/bash

# ================================
# 🔍 VALIDACIÓN DEL SERVIDOR MCP
# Stealth-AntiCheatX Configuration Validator
# ================================

echo "
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                                                                      ║
║    🔍 STEALTH-ANTICHEATX MCP - VALIDACIÓN DE CONFIGURACIÓN                          ║
║                                                                                      ║
║    Verificando todas las configuraciones necesarias                                 ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
"

ERRORS=0
WARNINGS=0

# Función para mostrar errores
show_error() {
    echo "❌ ERROR: $1"
    ((ERRORS++))
}

# Función para mostrar advertencias
show_warning() {
    echo "⚠️  ADVERTENCIA: $1"
    ((WARNINGS++))
}

# Función para mostrar éxitos
show_success() {
    echo "✅ $1"
}

# Verificar Node.js
echo "🔍 Verificando Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "   Node.js detectado: $NODE_VERSION"
    if [[ $NODE_VERSION =~ v([0-9]+) ]]; then
        MAJOR_VERSION=${BASH_REMATCH[1]}
        if [ $MAJOR_VERSION -ge 18 ]; then
            show_success "Versión compatible"
        else
            show_error "Se requiere Node.js 18+, actual: $NODE_VERSION"
        fi
    fi
else
    show_error "Node.js no está instalado"
fi

# Verificar npm
echo ""
echo "🔍 Verificando npm..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "   npm detectado: $NPM_VERSION"
    show_success "npm disponible"
else
    show_error "npm no está instalado"
fi

# Verificar archivos necesarios
echo ""
echo "🔍 Verificando archivos del proyecto..."

if [ -f "package.json" ]; then
    show_success "package.json encontrado"
else
    show_error "package.json no encontrado"
fi

if [ -f "src/index.ts" ]; then
    show_success "Archivo principal src/index.ts encontrado"
else
    show_error "Archivo principal src/index.ts no encontrado"
fi

if [ -f ".env" ]; then
    show_success "Archivo de configuración .env encontrado"
else
    show_error "Archivo .env no encontrado"
fi

# Cargar variables de entorno
if [ -f ".env" ]; then
    source .env
    
    # Verificar variables críticas
    echo ""
    echo "🔍 Verificando variables de entorno..."
    
    # Discord Bot Token
    if [ -n "$DISCORD_BOT_TOKEN" ]; then
        echo "   🎯 Discord Bot Token: ${DISCORD_BOT_TOKEN:0:20}..."
        show_success "Token Discord configurado"
    else
        show_error "DISCORD_BOT_TOKEN no configurado"
    fi
    
    # MiniMax API Key
    if [ -n "$MINIMAX_API_KEY" ]; then
        echo "   🤖 MiniMax API Key: ${MINIMAX_API_KEY:0:30}..."
        show_success "API Key MiniMax configurada"
    else
        show_warning "MINIMAX_API_KEY no configurado - IA limitada"
    fi
    
    # Webhook URL
    if [ -n "$ANTICHEAT_WEBHOOK_URL" ]; then
        show_success "Webhook URL configurado"
    else
        show_warning "ANTICHEAT_WEBHOOK_URL no configurado - sin notificaciones"
    fi
    
    # Channel IDs
    if [ -n "$DISCORD_CHEATING_CHANNEL_1" ]; then
        echo "   📺 Canal Cheating 1: $DISCORD_CHEATING_CHANNEL_1"
        show_success "Canal Cheating 1 configurado"
    else
        show_error "DISCORD_CHEATING_CHANNEL_1 no configurado"
    fi
    
    if [ -n "$DISCORD_CHEATING_CHANNEL_2" ]; then
        echo "   📺 Canal Cheating 2: $DISCORD_CHEATING_CHANNEL_2"
        show_success "Canal Cheating 2 configurado"
    else
        show_warning "DISCORD_CHEATING_CHANNEL_2 no configurado"
    fi
    
    # Private Channels
    if [ -n "$DISCORD_PRIVATE_CHANNEL_1" ]; then
        show_success "Canal Privado 1 configurado"
    else
        show_warning "DISCORD_PRIVATE_CHANNEL_1 no configurado"
    fi
    
    if [ -n "$DISCORD_PRIVATE_CHANNEL_2" ]; then
        show_success "Canal Privado 2 configurado"
    else
        show_warning "DISCORD_PRIVATE_CHANNEL_2 no configurado"
    fi
else
    echo ""
    show_error "No se puede cargar .env - no existe o no se puede leer"
fi

# Verificar dependencias
echo ""
echo "🔍 Verificando dependencias..."

if [ -d "node_modules" ]; then
    show_success "node_modules encontrado"
    
    # Verificar dependencias críticas
    if [ -f "node_modules/@modelcontextprotocol/sdk/package.json" ]; then
        show_success "@modelcontextprotocol/sdk instalado"
    else
        show_error "@modelcontextprotocol/sdk no encontrado"
    fi
    
    if [ -f "node_modules/discord.js/package.json" ]; then
        show_success "discord.js instalado"
    else
        show_error "discord.js no encontrado"
    fi
    
    if [ -f "node_modules/minimax-mcp-js/package.json" ]; then
        show_success "minimax-mcp-js instalado"
    else
        show_error "minimax-mcp-js no encontrado"
    fi
else
    show_warning "node_modules no encontrado - ejecuta 'npm install'"
fi

# Verificar estructura de directorios
echo ""
echo "🔍 Verificando estructura de directorios..."

for dir in "data" "logs" "backup" "src"; do
    if [ -d "$dir" ]; then
        show_success "Directorio $dir existe"
    else
        show_warning "Directorio $dir no existe - se creará automáticamente"
    fi
done

# Verificar TypeScript
echo ""
echo "🔍 Verificando TypeScript..."

if [ -f "tsconfig.json" ]; then
    show_success "tsconfig.json encontrado"
else
    show_warning "tsconfig.json no encontrado"
fi

if [ -f "dist/index.js" ]; then
    show_success "Compilación TypeScript disponible"
else
    show_warning "No hay compilación disponible - ejecuta 'npm run build'"
fi

# Verificar permisos
echo ""
echo "🔍 Verificando permisos..."

if [ -r ".env" ]; then
    show_success "Archivo .env legible"
else
    show_warning "Archivo .env no es legible"
fi

if [ -w "data" ]; then
    show_success "Directorio data escribible"
else
    show_warning "Directorio data no es escribible"
fi

if [ -w "logs" ]; then
    show_success "Directorio logs escribible"
else
    show_warning "Directorio logs no es escribible"
fi

# Resumen final
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════════════╗"
echo "║                           RESUMEN DE VALIDACIÓN                                      ║"
echo "╠══════════════════════════════════════════════════════════════════════════════════════╣"

if [ $ERRORS -eq 0 ]; then
    echo "║  ✅ CONFIGURACIÓN VÁLIDA - El servidor puede iniciarse                           ║"
else
    echo "║  ❌ ERRORES ENCONTRADOS: $ERRORS - Corregir antes de iniciar                     ║"
fi

if [ $WARNINGS -gt 0 ]; then
    echo "║  ⚠️  ADVERTENCIAS: $WARNINGS - Recomendado revisar                               ║"
fi

echo "╚══════════════════════════════════════════════════════════════════════════════════════╝"

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "🎉 ¡Validación exitosa! Puedes iniciar el servidor con:"
    echo "   ./start-mcp.sh"
    echo "   o"
    echo "   npm start"
else
    echo "🔧 Corrige los errores antes de iniciar el servidor"
    echo ""
    echo "💡 Comandos útiles:"
    echo "   npm install           # Instalar dependencias"
    echo "   npm run build         # Compilar TypeScript"
    echo "   nano .env            # Editar configuración"
fi

echo ""
echo "📞 Soporte: https://discord.gg/NxewbWvW8J"
echo "📧 Email: xpepaneles@gmail.com"