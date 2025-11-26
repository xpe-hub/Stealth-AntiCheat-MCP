# Railway Deployment Guide - Stealth AntiCheat MCP

## 🚀 Configuración para Railway

Este proyecto está configurado para funcionar en Railway.app con un bridge HTTP que permite al servidor MCP comunicarse a través de un puerto web.

### 📋 Variables de Entorno Requeridas

Configure estas variables en Railway Dashboard > Settings > Environment Variables:

```
# Discord Bot Configuration
DISCORD_BOT_TOKEN=your_discord_bot_token_here
BOT_OWNER_ID=your_discord_user_id_here

# Minimax API
MINIMAX_API_KEY=your_minimax_api_key_here

# Discord Channels
SUPPORT_CHANNEL_ID=your_support_channel_id_here
DESCUBRIMIENTOS_CHANNEL_ID=your_descubrimientos_channel_id_here
IMPLEMENTACIONES_CHANNEL_ID=your_implementaciones_channel_id_here
CHAT_CHANNEL_ID=your_chat_channel_id_here
CMD_CHANNEL_ID=your_cmd_channel_id_here

# Webhook
ANTICHEAT_WEBHOOK_URL=your_discord_webhook_url_here
```

### ⚙️ Configuración de Railway

1. **Build Command**: Automático (Railway detecta Node.js)
2. **Start Command**: `npm start`
3. **Root Directory**: `/` (por defecto)
4. **Health Check**: Railway verificará automáticamente el puerto

### 🔗 Endpoints Disponibles

Una vez desplegado en Railway, tendrás acceso a:

- `GET /health` - Estado del servidor
- `GET /mcp/info` - Información del servidor MCP
- `POST /mcp/` - Interfaz MCP bridge (experimental)

### 🎯 Comportamiento del Bridge

El `railway.js` actua como proxy:

1. ✅ Inicia servidor HTTP en puerto asignado por Railway
2. ✅ Ejecuta proceso MCP en stdio como hijo
3. ✅ Proporciona health checks y status endpoints
4. ✅ Maneja cierre graceful del proceso

### 🛠️ Solución de Problemas

**Si el build falla:**
- Verifica que todas las variables de entorno estén configuradas
- Revisa los logs de build para errores de TypeScript
- Asegúrate de que el build (`npm run build`) se complete sin errores

**Si el servidor no inicia:**
- Verifica que `process.env.PORT` sea accesible
- Revisa que el proceso MCP hijo inicie correctamente
- Consulta los logs de runtime para errores específicos

### 📱 Conexión desde Claude Desktop

Una vez que el build sea exitoso, Railway proporcionará una URL. Para conectar desde Claude Desktop:

1. Obtén la URL de Railway del dashboard
2. Configura Claude Desktop para usar la URL como endpoint MCP
3. Asegúrate de que las credenciales estén disponibles

### 🔄 Actualizaciones

El proyecto está configurado para auto-deploy:
- Cada `git push` trigger automáticamente un nuevo build
- Railway detecta el commit y reconstruye automáticamente
- El proceso es transparente y continuo