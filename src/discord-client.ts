/**
 * Discord Anti-Cheat Client
 * Cliente especializado para analizar servidores de cheating en tiempo real
 * Copyright (c) 2025 xpe.nettt. All rights reserved.
 */

import { Client, GatewayIntentBits, TextChannel, ChannelType } from 'discord.js';
import * as fs from 'fs-extra';
import * as path from 'path';

export class DiscordCheatClient {
  // Properties
  config: DiscordCheatConfig;
  client: Client;
  connected: boolean;
  monitoredChannels: Set<string>;
  messageQueue: any[];
  analysisResults: any[];

  constructor(config: DiscordCheatConfig) {
    this.config = config;
    this.client = new Client({
      intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent,
        GatewayIntentBits.GuildMembers
      ]
    });

    this.messageQueue = [];
    this.analysisResults = [];
    this.monitoredChannels = new Set();
    this.connected = false;
  }

  /**
   * Conecta al Discord e inicia análisis automático
   */
  async connect(): Promise<void> {
    try {
      await this.client.login(this.config.botToken);
      this.connected = true;
      
      console.log('🔗 Discord Anti-Cheat Client conectado');
      
      // Evento de ready
      this.client.once('ready', () => {
        console.log(`🚀 Cliente listo - Analizando ${this.client.guilds.cache.size} servidores`);
        this.startMonitoring();
      });

      // Evento de mensajes
      this.client.on('messageCreate', async (message) => {
        await this.handleNewMessage(message);
      });

      // Eventos de canales
      this.client.on('channelCreate', async (channel) => {
        if (channel.type === ChannelType.GuildText) {
          console.log(`📺 Nuevo canal detectado: ${channel.name} (${channel.id})`);
        }
      });

    } catch (error) {
      console.error('❌ Error conectando Discord client:', error);
      throw error;
    }
  }

  /**
   * Añade canales específicos al monitoreo
   */
  addCheatingChannels(channelIds: string[]): void {
    for (const channelId of channelIds) {
      this.monitoredChannels.add(channelId);
    }
    console.log(`📊 ${channelIds.length} canales de cheating añadidos al monitoreo`);
  }

  /**
   * Añade canales privados al monitoreo
   */
  addPrivateChannels(channelIds: string[]): void {
    for (const channelId of channelIds) {
      this.monitoredChannels.add(channelId);
    }
    console.log(`🔒 ${channelIds.length} canales privados añadidos al monitoreo`);
  }

  /**
   * Inicia monitoreo continuo
   */
  private startMonitoring(): void {
    console.log('🔄 Iniciando monitoreo continuo de cheating...');
    
    // Análisis cada 15 segundos
    setInterval(() => {
      this.processMessageQueue();
    }, 15000);

    // Reporte de estadísticas cada 5 minutos
    setInterval(() => {
      this.reportStats();
    }, 5 * 60 * 1000);

    // Reconectar si se pierde conexión
    this.client.on('disconnect', () => {
      console.log('⚠️ Cliente desconectado, intentando reconectar...');
      setTimeout(() => this.connect(), 5000);
    });
  }

  /**
   * Maneja nuevos mensajes
   */
  private async handleNewMessage(message: any): Promise<void> {
    // Skip mensajes del bot o vacíos
    if (message.author.bot || !message.content || !message.guild) return;

    // Verificar si el canal está siendo monitoreado
    if (!this.monitoredChannels.has(message.channelId)) return;

    // Extraer información del mensaje
    const messageData = {
      id: message.id,
      content: message.content,
      author: {
        id: message.author.id,
        username: message.author.username,
        discriminator: message.author.discriminator
      },
      channel: {
        id: message.channelId,
        name: message.channel.name,
        guild: message.guild.name
      },
      timestamp: new Date(),
      hasAttachments: message.attachments.size > 0,
      hasEmbeds: message.embeds.length > 0
    };

    // Añadir a cola de análisis
    this.messageQueue.push(messageData);

    // Si hay adjuntos, también analizarlos
    if (message.attachments.size > 0) {
      await this.analyzeAttachments(message);
    }

    console.log(`📨 Mensaje analizado de ${message.author.username} en ${message.channel.name}`);
  }

  /**
   * Analiza adjuntos en el mensaje
   */
  private async analyzeAttachments(message: any): Promise<void> {
    const analysis: any = {
      type: 'attachments',
      channelId: message.channelId,
      attachments: [] as any[],
      timestamp: new Date()
    };

    for (const attachment of message.attachments.values()) {
      analysis.attachments.push({
        url: attachment.url || attachment.attachment || '',
        filename: attachment.name || attachment.filename || '',
        size: attachment.size || 0,
        type: this.detectFileType(attachment.name || attachment.filename || '')
      });
    }

    console.log(`📎 ${analysis.attachments.length} adjuntos detectados`);
  }

  /**
   * Detecta el tipo de archivo
   */
  private detectFileType(filename: string): string {
    const ext = path.extname(filename).toLowerCase();
    
    const fileTypes: Record<string, string> = {
      '.cpp': 'cpp',
      '.c': 'c',
      '.h': 'header',
      '.hpp': 'header',
      '.cs': 'csharp',
      '.js': 'javascript',
      '.py': 'python',
      '.java': 'java',
      '.kt': 'kotlin',
      '.go': 'go',
      '.rs': 'rust',
      '.dll': 'dll',
      '.exe': 'executable',
      '.bin': 'binary',
      '.txt': 'text'
    };

    return fileTypes[ext] || 'unknown';
  }

  /**
   * Procesa la cola de mensajes para análisis
   */
  private processMessageQueue(): void {
    if (this.messageQueue.length === 0) return;

    const batch = this.messageQueue.splice(0, 10); // Procesar 10 mensajes a la vez

    for (const message of batch) {
      const analysis = this.analyzeMessageContent(message);
      
      if (analysis.suspicious) {
        this.handleSuspiciousMessage(message, analysis);
      }
    }
  }

  /**
   * Analiza el contenido del mensaje en busca de cheating
   */
  private analyzeMessageContent(message: any): SuspiciousAnalysis {
    const analysis: SuspiciousAnalysis = {
      suspicious: false,
      reasons: [],
      confidence: 0,
      detectedPatterns: []
    };

    const content = message.content.toLowerCase();

    // Patrones de código sospechoso
    const suspiciousPatterns = [
      { 
        pattern: /```[a-zA-Z]*\n.*(GetWindowLongPtr|SetWindowLong|FindWindow).*```/i,
        reason: 'Códigos ESP/Aimbot detectados',
        severity: 'HIGH',
        confidence: 85
      },
      {
        pattern: /```[a-zA-Z]*\n.*(CreateRemoteThread|LoadLibrary|VirtualAlloc).*```/i,
        reason: 'Códigos de inyección DLL',
        severity: 'CRITICAL',
        confidence: 95
      },
      {
        pattern: /```[a-zA-Z]*\n.*(ReadProcessMemory|WriteProcessMemory|NtUnmapViewOfSection).*```/i,
        reason: 'Manipulación de memoria detectada',
        severity: 'HIGH',
        confidence: 90
      },
      {
        pattern: /(esp|aimbot|wallhack|speedhack|noclip|flyhack|jumphack)/i,
        reason: 'Menciones directas de cheating',
        severity: 'MEDIUM',
        confidence: 70
      },
      {
        pattern: /(cheat[ -]?engine|memory [ -]?scanner|mod[ -]?menu)/i,
        reason: 'Herramientas de cheating mencionadas',
        severity: 'HIGH',
        confidence: 80
      },
      {
        pattern: /(bypass|spoof|anticheat|detection)/i,
        reason: 'Intentos de bypass anti-cheat',
        severity: 'HIGH',
        confidence: 75
      }
    ];

    for (const { pattern, reason, severity, confidence } of suspiciousPatterns) {
      if (pattern.test(message.content)) {
        analysis.suspicious = true;
        analysis.reasons.push(reason);
        analysis.confidence = Math.max(analysis.confidence, confidence);
        analysis.detectedPatterns.push({
          pattern: pattern.source,
          reason,
          severity,
          confidence
        });
      }
    }

    // Buscar enlaces a repositorios sospechosos
    const repoLinks = content.match(/(https?:\/\/github\.com\/[^\s)]+)/gi);
    if (repoLinks) {
      analysis.reasons.push(`Enlaces a repositorios: ${repoLinks.length}`);
      analysis.confidence += 20;
      analysis.suspicious = true;
    }

    // Buscar adjuntos de código
    if (message.hasAttachments) {
      analysis.reasons.push('Adjuntos de código detectados');
      analysis.confidence += 30;
      analysis.suspicious = true;
    }

    return analysis;
  }

  /**
   * Maneja mensajes sospechosos
   */
  private handleSuspiciousMessage(message: any, analysis: SuspiciousAnalysis): void {
    console.log('🚨 MENSAJE SOSPECHOSO DETECTADO:');
    console.log(`   Canal: ${message.channel.name}`);
    console.log(`   Usuario: ${message.author.username}`);
    console.log(`   Confianza: ${analysis.confidence}%`);
    console.log(`   Razones: ${analysis.reasons.join(', ')}`);

    // Guardar resultado del análisis
    this.analysisResults.push({
      messageId: message.id,
      authorId: message.author.id,
      channelId: message.channelId,
      guildId: message.channel.guildId,
      timestamp: new Date(),
      suspicious: true,
      confidence: analysis.confidence,
      reasons: analysis.reasons,
      detectedPatterns: analysis.detectedPatterns,
      content: message.content.substring(0, 1000) // Limitar tamaño
    });

    // Enviar alerta si la confianza es alta
    if (analysis.confidence >= 80) {
      this.sendAlert(message, analysis);
    }
  }

  /**
   * Envía alertas de actividad sospechosa
   */
  private async sendAlert(message: any, analysis: SuspiciousAnalysis): Promise<void> {
    const alert = {
      type: 'suspicious_activity',
      timestamp: new Date(),
      severity: analysis.confidence >= 95 ? 'CRITICAL' : 'HIGH',
      channel: {
        id: message.channelId,
        name: message.channel.name,
        guild: message.guild.name
      },
      author: {
        id: message.author.id,
        username: message.author.username
      },
      confidence: analysis.confidence,
      detected_patterns: analysis.detectedPatterns,
      content_snippet: message.content.substring(0, 200)
    };

    console.log('🚨 ALERTA ENVIADA:', JSON.stringify(alert, null, 2));

    // Aquí se enviaría al webhook configurado
    // await this.sendWebhookAlert(alert);
  }

  /**
   * Genera reporte de estadísticas
   */
  private reportStats(): void {
    const recentResults = this.analysisResults.filter(
      r => Date.now() - r.timestamp.getTime() < 5 * 60 * 1000
    );

    const stats = {
      connected: this.connected,
      monitored_channels: this.monitoredChannels.size,
      total_guilds: this.client.guilds.cache.size,
      suspicious_messages_last_5min: recentResults.length,
      high_confidence_alerts: recentResults.filter(r => r.confidence >= 80).length,
      analysis_queue_size: this.messageQueue.length
    };

    console.log('📊 ESTADÍSTICAS DE ANÁLISIS:');
    console.log(JSON.stringify(stats, null, 2));
  }

  /**
   * Obtiene estadísticas actuales
   */
  getStats(): any {
    return {
      connected: this.connected,
      monitoredChannels: Array.from(this.monitoredChannels),
      totalGuilds: this.client.guilds.cache.size,
      analysisResults: this.analysisResults.length,
      messageQueue: this.messageQueue.length
    };
  }

  /**
   * Desconecta el cliente
   */
  async disconnect(): Promise<void> {
    await this.client.destroy();
    this.connected = false;
    console.log('🔌 Cliente Discord desconectado');
  }
}

// ================================
// 📊 TIPOS DE DATOS
// ================================

interface DiscordCheatConfig {
  botToken: string;
  cheatingChannelIds?: string[];
  privateChannelIds?: string[];
  webhookUrl?: string;
}

interface SuspiciousAnalysis {
  suspicious: boolean;
  reasons: string[];
  confidence: number;
  detectedPatterns: Array<{
    pattern: string;
    reason: string;
    severity: string;
    confidence: number;
  }>;
}

interface AnalysisResult {
  messageId: string;
  authorId: string;
  channelId: string;
  guildId: string;
  timestamp: Date;
  suspicious: boolean;
  confidence: number;
  reasons: string[];
  detectedPatterns: any[];
  content: string;
}