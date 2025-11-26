# 🚂 GUIDE: DEPLOY STEALTH-ANTICHEAT MCP EN RAILWAY.APP

> **Control total desde iPhone sin PC - 24/7 automático**

## 🚀 **INSTALACIÓN DESDE iPhone (SÚPER FÁCIL)**

### **PASO 1: Abrir Railway.app**
- 📱 En tu iPhone, abre Safari
- 🔗 Ve a: https://railway.app
- 👤 Crea cuenta gratuita

### **PASO 2: Conectar GitHub**
1. Click en **"Deploy from GitHub repo"**
2. Autoriza Railway a acceder a tu GitHub
3. Selecciona: **xpe-hub/Stealth-AntiCheat-MCP**
4. Railway detectará automáticamente que es proyecto Node.js

### **PASO 3: Railway hace TODO automático**
Railway automáticamente:
- ✅ Clona tu repositorio
- ✅ Detecta package.json
- ✅ Instala dependencias con `npm install --legacy-peer-deps`
- ✅ Compila TypeScript con `npm run build`
- ✅ Inicia servidor con `npm start`
- ✅ Te da URL para controlarlo

### **PASO 4: ¡Control desde iPhone!**
- 📱 Ve a la URL que te dé Railway
- 📊 Monitorea logs en tiempo real
- 🔄 Reinicia servicios si necesitas
- 📈 Ve estadísticas y métricas
- ⚙️ Configura variables de entorno si necesario

---

## 🛠️ **CONFIGURACIÓN AVANZADA**

### **Variables de Entorno (si las necesitas):**
En Railway, ve a tu proyecto → Variables y agrega:
```
DISCORD_BOT_TOKEN=tu_token_aqui
MINIMAX_API_KEY=tu_key_aqui
```

### **Dominio Personalizado:**
Railway te da URL automática, pero puedes configurar dominio propio si quieres.

---

## 📱 **CONTROL DESDE iPHONE**

### **Dashboard de Control:**
- **URL de tu bot** → Link directo al servidor
- **Logs** → Todo lo que hace tu bot en tiempo real
- **Métricas** → CPU, memoria, red
- **Reinicio** → Botón para reiniciar si algo falla
- **Variables** → Cambiar configuraciones

### **Monitoreo 24/7:**
- ✅ **Nunca se apaga** (salvo errores críticos)
- ✅ **Reinicio automático** si falla algo
- ✅ **Logs persistentes** (historial completo)
- ✅ **Métricas en tiempo real**

---

## 🔧 **COMANDOS DE RAILWAY**

### **Para desarrolladores que quieren CLI:**
```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Desplegar
railway up

# Ver logs
railway logs

# Variables
railway variables
```

### **Comandos del Proyecto:**
```bash
# Desde el directorio del proyecto
./deploy-railway.sh    # Guía paso a paso
npm run validate       # Verificar configuración
npm run quick-start    # Iniciar localmente
```

---

## 🆘 **SOLUCIÓN DE PROBLEMAS**

### **Si falla la instalación:**
1. Ve a Railway → Tu proyecto → Logs
2. Busca errores específicos
3. Comunícate con soporte de Railway (gratis)

### **Si el bot no conecta:**
1. Verifica variables de entorno en Railway
2. Revisa logs para ver errores
3. Asegúrate de que Discord token es válido

### **Para soporte:**
- 📞 Railway Support: Gratis con tu plan
- 💬 Discord: https://discord.gg/NxewbWvW8J
- 📧 Email: xpepaneles@gmail.com

---

## 💰 **COSTOS RAILWAY.APP**

### **Plan Gratuito:**
- ✅ $5 crédito mensual
- ✅ 512MB RAM
- ✅ 1GB storage
- ✅ Perfecto para tu bot MCP

### **Si necesitas más:**
- ✅ Plan Hobby: $5/mes
- ✅ Plan Pro: $20/mes
- ✅ Plan Team: $100/mes

**Tu bot MCP funciona perfectamente en plan gratuito.**

---

## 🎯 **VENTAJAS PARA TU CASO**

### **✅ Súper fácil desde iPhone:**
- No necesitas PC
- Interfaz web amigable
- Configuración automática

### **✅ Control total:**
- Monitoreo 24/7
- Reinicio automático
- Logs completos

### **✅ Escalable:**
- Si necesitas más recursos, fácilmente upgrade
- Actualizaciones automáticas desde GitHub

### **✅ Profesional:**
- Hosting confiable
- Backups automáticos
- SSL automático

**¡Perfecto para controlarlo 100% desde tu iPhone!** 📱