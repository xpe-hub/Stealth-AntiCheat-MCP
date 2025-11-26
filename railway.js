/**
 * Railway MCP Bridge - Permite usar Railway con servidores MCP stdio
 * 
 * Railway asigna un puerto dinámico en process.env.PORT
 * Este servidor HTTP básico actúa como proxy para el MCP stdio
 */

import http from 'http';
import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const PORT = process.env.PORT || 3000;

// Variables de entorno necesarias
const requiredEnvVars = [
  'DISCORD_BOT_TOKEN',
  'BOT_OWNER_ID', 
  'MINIMAX_API_KEY',
  'SUPPORT_CHANNEL_ID',
  'DESCUBRIMIENTOS_CHANNEL_ID',
  'IMPLEMENTACIONES_CHANNEL_ID',
  'CHAT_CHANNEL_ID',
  'CMD_CHANNEL_ID',
  'ANTICHEAT_WEBHOOK_URL'
];

console.log('🚀 Iniciando Railway MCP Bridge...');
console.log(`📡 Puerto asignado: ${PORT}`);

// Verificar variables de entorno
const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);
if (missingVars.length > 0) {
  console.warn(`⚠️ Variables faltantes: ${missingVars.join(', ')}`);
}

// Crear servidor HTTP básico
const server = http.createServer((req, res) => {
  res.writeHead(200, {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
  });

  if (req.method === 'OPTIONS') {
    res.end();
    return;
  }

  if (req.url === '/health') {
    res.end(JSON.stringify({
      status: 'ok',
      service: 'Stealth-AntiCheatX MCP Server',
      version: '3.0.0',
      timestamp: new Date().toISOString()
    }));
    return;
  }

  if (req.url === '/mcp/info') {
    res.end(JSON.stringify({
      name: 'stealth-anticheatx-mcp-server',
      version: '3.0.0',
      description: 'MCP Server para análisis anti-cheat en tiempo real',
      capabilities: [
        'analyze-code',
        'analyze-intelligent', 
        'monitor-discord',
        'm2-anticheat-evolution'
      ]
    }));
    return;
  }

  res.end(JSON.stringify({
    message: 'Stealth-AntiCheatX MCP Server - Railway Bridge Active',
    endpoints: ['/health', '/mcp/info']
  }));
});

// Iniciar servidor
server.listen(PORT, () => {
  console.log(`✅ Railway MCP Bridge activo en puerto ${PORT}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/health`);
  console.log(`ℹ️ MCP Info: http://localhost:${PORT}/mcp/info`);
  
  // Proceso MCP (en stdio)
  console.log('🔄 Iniciando proceso MCP en stdio...');
  
  const mcpProcess = spawn('node', ['dist/index.js'], {
    cwd: __dirname,
    stdio: ['pipe', 'pipe', 'pipe']
  });

  mcpProcess.stdout.on('data', (data) => {
    console.log(`📤 MCP Output: ${data.toString().trim()}`);
  });

  mcpProcess.stderr.on('data', (data) => {
    console.error(`❌ MCP Error: ${data.toString().trim()}`);
  });

  mcpProcess.on('close', (code) => {
    console.log(`🔚 Proceso MCP terminó con código: ${code}`);
    process.exit(code || 1);
  });

  mcpProcess.on('error', (error) => {
    console.error('❌ Error iniciando proceso MCP:', error);
    process.exit(1);
  });
});

// Manejo graceful de cierre
process.on('SIGTERM', () => {
  console.log('🔄 Cerrando Railway MCP Bridge...');
  server.close(() => {
    console.log('✅ Servidor HTTP cerrado');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🔄 Cerrando Railway MCP Bridge...');
  server.close(() => {
    console.log('✅ Servidor HTTP cerrado'); 
    process.exit(0);
  });
});