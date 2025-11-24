/**
 * Anti-Cheat Analysis Database
 * Sistema de base de datos para almacenar análisis y signatures
 * Copyright (c) 2025 xpe.nettt. All rights reserved.
 */

import SQLite from 'sqlite3';
import * as fs from 'fs-extra';
import * as path from 'path';

export class AntiCheatDatabase {
  private db: SQLite.Database;
  private initialized = false;

  constructor(dbPath: string) {
    // Asegurar que el directorio existe
    fs.ensureDirSync(path.dirname(dbPath));
    
    this.db = new SQLite.Database(dbPath, (err) => {
      if (err) {
        console.error('❌ Error conectando a la base de datos:', err);
      } else {
        console.log('✅ Conectado a la base de datos Anti-Cheat');
        this.initialize();
      }
    });
  }

  /**
   * Inicializa las tablas de la base de datos
   */
  private async initialize(): Promise<void> {
    const tables = [
      // Tabla para almacenar código analizado
      `CREATE TABLE IF NOT EXISTS analyzed_code (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code_hash TEXT UNIQUE,
        original_code TEXT,
        analysis_result TEXT,
        risk_level TEXT,
        detected_methods TEXT,
        confidence_score INTEGER,
        source_channel TEXT,
        author_id TEXT,
        guild_id TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      )`,

      // Tabla para signatures de anti-cheat
      `CREATE TABLE IF NOT EXISTS anticheat_signatures (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        signature_name TEXT UNIQUE,
        regex_pattern TEXT,
        severity_level TEXT,
        description TEXT,
        detection_method TEXT,
        game_target TEXT,
        is_active INTEGER DEFAULT 1,
        usage_count INTEGER DEFAULT 0,
        false_positive_rate REAL DEFAULT 0.0,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        created_by TEXT DEFAULT 'system'
      )`,

      // Tabla para análisis de repositorios
      `CREATE TABLE IF NOT EXISTS repository_analysis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        repo_url TEXT,
        repo_name TEXT,
        analysis_type TEXT,
        files_scanned INTEGER,
        suspicious_files TEXT,
        threat_level TEXT,
        git_commit_hash TEXT,
        analysis_result TEXT,
        auto_update_triggered INTEGER DEFAULT 0,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        analyzer_version TEXT
      )`,

      // Tabla para mensajes Discord analizados
      `CREATE TABLE IF NOT EXISTS discord_analysis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message_id TEXT,
        channel_id TEXT,
        channel_name TEXT,
        guild_id TEXT,
        guild_name TEXT,
        author_id TEXT,
        author_username TEXT,
        content TEXT,
        suspicious_indicators TEXT,
        confidence_score INTEGER,
        is_suspicious INTEGER DEFAULT 0,
        alert_sent INTEGER DEFAULT 0,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )`,

      // Tabla para auto-updates de signatures
      `CREATE TABLE IF NOT EXISTS signature_updates (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        update_type TEXT,
        old_signatures TEXT,
        new_signatures TEXT,
        added_signatures TEXT,
        removed_signatures TEXT,
        success_rate REAL,
        update_trigger TEXT,
        affected_games TEXT,
        deployed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        deployment_status TEXT DEFAULT 'pending'
      )`,

      // Tabla para logs del sistema
      `CREATE TABLE IF NOT EXISTS system_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        log_level TEXT,
        component TEXT,
        message TEXT,
        metadata TEXT,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )`,

      // Tabla para estadísticas de detección
      `CREATE TABLE IF NOT EXISTS detection_stats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        detection_type TEXT,
        successful_detections INTEGER DEFAULT 0,
        false_positives INTEGER DEFAULT 0,
        missed_detections INTEGER DEFAULT 0,
        accuracy_rate REAL,
        detection_date DATE DEFAULT CURRENT_DATE,
        last_updated DATETIME DEFAULT CURRENT_TIMESTAMP
      )`
    ];

    // Crear índices para optimización
    const indexes = [
      'CREATE INDEX IF NOT EXISTS idx_analyzed_code_hash ON analyzed_code(code_hash)',
      'CREATE INDEX IF NOT EXISTS idx_analyzed_code_timestamp ON analyzed_code(timestamp)',
      'CREATE INDEX IF NOT EXISTS idx_discord_analysis_timestamp ON discord_analysis(timestamp)',
      'CREATE INDEX IF NOT EXISTS idx_discord_analysis_channel ON discord_analysis(channel_id)',
      'CREATE INDEX IF NOT EXISTS idx_signature_name ON anticheat_signatures(signature_name)',
      'CREATE INDEX IF NOT EXISTS idx_signature_severity ON anticheat_signatures(severity_level)'
    ];

    // Ejecutar creación de tablas
    for (const table of tables) {
      await this.runQuery(table);
    }

    // Crear índices
    for (const index of indexes) {
      await this.runQuery(index);
    }

    // Insertar signatures base
    await this.insertBaseSignatures();

    this.initialized = true;
    console.log('✅ Base de datos Anti-Cheat inicializada');
  }

  /**
   * Inserta signatures base del anti-cheat
   */
  private async insertBaseSignatures(): Promise<void> {
    const baseSignatures = [
      {
        signature_name: 'ESP_Window',
        regex_pattern: 'GetWindowLongPtr.*WS_EX_LAYERED|FindWindow.*ESP|SetWindowLong.*WS_EX_LAYERED',
        severity_level: 'HIGH',
        description: 'Detección de ventanas ESP overlays',
        detection_method: 'window_enumeration',
        game_target: 'universal',
        created_by: 'system'
      },
      {
        signature_name: 'Memory_Injection',
        regex_pattern: 'CreateRemoteThread.*Process|VirtualAllocEx|WriteProcessMemory|LoadLibrary',
        severity_level: 'CRITICAL',
        description: 'Detección de inyección de memoria/DLL',
        detection_method: 'memory_analysis',
        game_target: 'universal',
        created_by: 'system'
      },
      {
        signature_name: 'Process_Spoofing',
        regex_pattern: 'GetProcAddress.*GetModuleHandle|NtUnmapViewOfSection|SetThreadContext',
        severity_level: 'CRITICAL',
        description: 'Detección de falsificación de procesos',
        detection_method: 'process_analysis',
        game_target: 'universal',
        created_by: 'system'
      },
      {
        signature_name: 'Auto_Input',
        regex_pattern: 'SendInput.*keys|mouse_event.*button|sleep.*1000.*loop|thread.*while.*true',
        severity_level: 'MEDIUM',
        description: 'Detección de automatización de entrada',
        detection_method: 'behavioral_analysis',
        game_target: 'universal',
        created_by: 'system'
      },
      {
        signature_name: 'Memory_Scanning',
        regex_pattern: 'ReadProcessMemory.*Process|EnumProcessModules|GetModuleInformation',
        severity_level: 'HIGH',
        description: 'Detección de escaneo de memoria',
        detection_method: 'memory_access',
        game_target: 'universal',
        created_by: 'system'
      }
    ];

    for (const signature of baseSignatures) {
      await this.runQuery(
        `INSERT OR IGNORE INTO anticheat_signatures 
         (signature_name, regex_pattern, severity_level, description, detection_method, game_target, created_by)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [signature.signature_name, signature.regex_pattern, signature.severity_level, 
         signature.description, signature.detection_method, signature.game_target, signature.created_by]
      );
    }

    console.log(`🛡️ Insertadas ${baseSignatures.length} signatures base`);
  }

  /**
   * Almacena análisis de código
   */
  async storeCodeAnalysis(
    codeHash: string,
    code: string,
    analysisResult: any,
    sourceChannel: string,
    authorId: string,
    guildId: string
  ): Promise<void> {
    const query = `
      INSERT OR REPLACE INTO analyzed_code 
      (code_hash, original_code, analysis_result, risk_level, detected_methods, confidence_score, 
       source_channel, author_id, guild_id, timestamp)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
    `;

    await this.runQuery(query, [
      codeHash,
      code.substring(0, 10000), // Limitar tamaño del código
      JSON.stringify(analysisResult),
      analysisResult.riskLevel,
      JSON.stringify(analysisResult.detectedMethods),
      analysisResult.confidence,
      sourceChannel,
      authorId,
      guildId
    ]);

    console.log('💾 Análisis de código almacenado:', codeHash);
  }

  /**
   * Añade nueva signature al anti-cheat
   */
  async addSignature(
    signatureName: string,
    regexPattern: string,
    severityLevel: string,
    description: string,
    detectionMethod: string,
    gameTarget: string = 'universal',
    createdBy: string = 'auto_update'
  ): Promise<void> {
    const query = `
      INSERT OR REPLACE INTO anticheat_signatures 
      (signature_name, regex_pattern, severity_level, description, detection_method, game_target, created_by, updated_at)
      VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
    `;

    await this.runQuery(query, [
      signatureName, regexPattern, severityLevel, description, 
      detectionMethod, gameTarget, createdBy
    ]);

    console.log(`🛡️ Nueva signature añadida: ${signatureName} (${severityLevel})`);
  }

  /**
   * Obtiene todas las signatures activas
   */
  async getActiveSignatures(): Promise<any[]> {
    const query = `
      SELECT * FROM anticheat_signatures 
      WHERE is_active = 1 
      ORDER BY severity_level DESC, signature_name
    `;

    return await this.allQuery(query);
  }

  /**
   * Actualiza estadísticas de una signature
   */
  async updateSignatureStats(signatureName: string, success: boolean): Promise<void> {
    const query = `
      UPDATE anticheat_signatures 
      SET usage_count = usage_count + 1,
          updated_at = CURRENT_TIMESTAMP
      WHERE signature_name = ?
    `;

    await this.runQuery(query, [signatureName]);
  }

  /**
   * Almacena análisis de mensaje Discord
   */
  async storeDiscordAnalysis(analysisData: any): Promise<void> {
    const query = `
      INSERT INTO discord_analysis 
      (message_id, channel_id, channel_name, guild_id, guild_name, author_id, author_username, 
       content, suspicious_indicators, confidence_score, is_suspicious, timestamp)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
    `;

    await this.runQuery(query, [
      analysisData.messageId,
      analysisData.channelId,
      analysisData.channelName,
      analysisData.guildId,
      analysisData.guildName,
      analysisData.authorId,
      analysisData.authorUsername,
      analysisData.content,
      JSON.stringify(analysisData.indicators),
      analysisData.confidence,
      analysisData.isSuspicious ? 1 : 0
    ]);
  }

  /**
   * Obtiene estadísticas de detección
   */
  async getDetectionStats(days: number = 7): Promise<any> {
    const query = `
      SELECT 
        COUNT(*) as total_analyses,
        COUNT(CASE WHEN is_suspicious = 1 THEN 1 END) as suspicious_detected,
        AVG(confidence_score) as avg_confidence,
        MAX(confidence_score) as max_confidence
      FROM discord_analysis 
      WHERE timestamp >= datetime('now', '-${days} days')
    `;

    const result = await this.getQuery(query);
    
    return {
      ...result,
      detection_rate: result.total_analyses > 0 ? 
        (result.suspicious_detected / result.total_analyses * 100).toFixed(2) : '0.00'
    };
  }

  /**
   * Obtiene análisis recientes
   */
  async getRecentAnalyses(limit: number = 50): Promise<any[]> {
    const query = `
      SELECT da.*, ac.code_hash, ac.risk_level, ac.detected_methods
      FROM discord_analysis da
      LEFT JOIN analyzed_code ac ON da.content = ac.original_code
      WHERE da.timestamp >= datetime('now', '-1 day')
      ORDER BY da.timestamp DESC
      LIMIT ?
    `;

    return await this.allQuery(query, [limit]);
  }

  /**
   * Registra log del sistema
   */
  async logSystemEvent(logLevel: string, component: string, message: string, metadata?: any): Promise<void> {
    const query = `
      INSERT INTO system_logs (log_level, component, message, metadata, timestamp)
      VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
    `;

    await this.runQuery(query, [
      logLevel,
      component,
      message,
      metadata ? JSON.stringify(metadata) : null
    ]);
  }

  /**
   * Ejecuta query que devuelve void
   */
  private runQuery(sql: string, params: any[] = []): Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.run(sql, params, function(err) {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      });
    });
  }

  /**
   * Ejecuta query que devuelve un resultado
   */
  private getQuery(sql: string, params: any[] = []): Promise<any> {
    return new Promise((resolve, reject) => {
      this.db.get(sql, params, (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row);
        }
      });
    });
  }

  /**
   * Ejecuta query que devuelve múltiples resultados
   */
  private allQuery(sql: string, params: any[] = []): Promise<any[]> {
    return new Promise((resolve, reject) => {
      this.db.all(sql, params, (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows);
        }
      });
    });
  }

  /**
   * Cierra la conexión a la base de datos
   */
  close(): Promise<void> {
    return new Promise((resolve, reject) => {
      this.db.close((err) => {
        if (err) {
          reject(err);
        } else {
          console.log('🔌 Conexión a base de datos cerrada');
          resolve();
        }
      });
    });
  }
}