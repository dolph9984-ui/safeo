// lib/services/security/audit_service.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Module 3, page 97
class AuditService {
  static final AuditService _instance = AuditService._internal();
  factory AuditService() => _instance;
  AuditService._internal();

  static const String _hmacSecretKey = 'safeo_audit_secret_2024';

  Future<void> logSecurityEvent({
    required String event,
    required String userId,
    String? details,
    Map<String, dynamic>? metadata,
  }) async {
    final timestamp = DateTime.now().toIso8601String();
    final hmac = _generateHMAC(event, userId, timestamp);
    
    final logEntry = {
      'timestamp': timestamp,
      'event': event,
      'userId': userId,
      'details': details,
      'metadata': metadata,
      'hmac': hmac,
    };

    print('📋 [AUDIT] $event | User: $userId | Time: $timestamp');
    if (details != null) {
      print('   Details: $details');
    }
  }

  String _generateHMAC(String event, String userId, String timestamp) {
    final key = utf8.encode(_hmacSecretKey);
    final bytes = utf8.encode('$event|$userId|$timestamp');
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString();
  }

  Future<void> logLogin(String userId) async {
    await logSecurityEvent(
      event: 'USER_LOGIN',
      userId: userId,
      details: 'Connexion réussie',
    );
  }

  Future<void> logFailedLogin(String email) async {
    await logSecurityEvent(
      event: 'FAILED_LOGIN',
      userId: email,
      details: 'Tentative de connexion échouée',
    );
  }

  Future<void> logLogout(String userId) async {
    await logSecurityEvent(
      event: 'USER_LOGOUT',
      userId: userId,
      details: 'Déconnexion',
    );
  }

  Future<void> logAccountLockout(String userId) async {
    await logSecurityEvent(
      event: 'ACCOUNT_LOCKED',
      userId: userId,
      details: 'Compte verrouillé après plusieurs tentatives',
    );
  }

  Future<void> logBiometricAuth({
    required String userId,
    required bool success,
  }) async {
    await logSecurityEvent(
      event: success ? 'BIOMETRIC_AUTH_SUCCESS' : 'BIOMETRIC_AUTH_FAILED',
      userId: userId,
      details: success 
          ? 'Authentification biométrique réussie' 
          : 'Authentification biométrique échouée',
    );
  }

  Future<void> logDocumentAccess({
    required String userId,
    required String documentId,
    required String action,
  }) async {
    await logSecurityEvent(
      event: 'DOCUMENT_ACCESS',
      userId: userId,
      details: '$action sur document $documentId',
      metadata: {
        'documentId': documentId,
        'action': action,
      },
    );
  }
}