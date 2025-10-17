import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'custom_tab_manager.dart';

/// Modelo de dados para informações de callback
/// Equivalente ao data class CallbackInfo do Android
class CallbackInfo {
  final String scheme;
  final String host;
  final Map<String, String> parameters;

  const CallbackInfo({
    this.scheme = '',
    this.host = '',
    this.parameters = const {},
  });

  bool get isEmpty => scheme.isEmpty && host.isEmpty;
  bool get isNotEmpty => !isEmpty;
}

/// Gerenciador de callbacks de deep links
/// Equivalente à classe CallbackHandler do Android
class CallbackHandler {
  // Instância do AppLinks
  final AppLinks _appLinks = AppLinks();

  // Stream para receber deep links
  StreamSubscription? _linkSubscription;

  // Estado reativo para informações de callback
  final ValueNotifier<CallbackInfo> _callbackInfo = ValueNotifier(const CallbackInfo());

  // Referência ao CustomTabManager para fechar no iOS
  final CustomTabManager _customTabManager = CustomTabManager();

  ValueNotifier<CallbackInfo> get callbackInfo => _callbackInfo;

  /// Inicializa o listener de deep links
  /// CALLBACK: Configuração para receber URLs de retorno do Custom Tab
  void initialize() {
    debugPrint('🔧 CallbackHandler inicializado');
    debugPrint('🔧 Iniciando listener de deep links...');
    _startListening();
  }

  /// Inicia escuta de deep links
  void _startListening() {
    // CALLBACK: Stream que recebe deep links enquanto app está ativo
    debugPrint('🔧 Configurando listener de uriLinkStream...');
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        debugPrint('🔥 STREAM RECEBEU URI: $uri');
        _processCallback(uri);
      },
      onError: (err) {
        debugPrint('❌ Erro ao receber deep link: $err');
      },
    );
    debugPrint('🔧 Listener configurado com sucesso!');
  }

  /// Processa o callback recebido
  /// Equivalente ao processCallback(intent: Intent) do Android
  void _processCallback(Uri uri) {
    // CALLBACK: Processamento da URL de retorno do Custom Tab
    debugPrint('=== CALLBACK RECEBIDO ===');
    _logUriInfo(uri);
    _updateCallbackInfo(uri);

    // IMPORTANTE: Fecha o Custom Tab/Safari View Controller
    // Android: Fecha automaticamente devido às flags no MainActivity.kt
    // iOS: Precisa fechar manualmente o Safari View Controller
    if (Platform.isIOS) {
      debugPrint('📱 iOS detectado - fechando Safari View Controller...');
      _customTabManager.closeCustomTab();
    } else {
      debugPrint('🤖 Android detectado - Custom Tab fecha automaticamente');
    }

    debugPrint('✅ Callback processado com sucesso!');
    debugPrint('========================');
  }

  /// Registra informações detalhadas da URI
  /// Equivalente ao logUriInfo(uri: Uri) do Android
  void _logUriInfo(Uri uri) {
    // CALLBACK: Log detalhado dos dados recebidos
    debugPrint('URI completo: $uri');
    debugPrint('Scheme: ${uri.scheme}');
    debugPrint('Host: ${uri.host}');
    debugPrint('Path: ${uri.path}');
    debugPrint('Query: ${uri.query}');

    uri.queryParameters.forEach((key, value) {
      debugPrint('Parâmetro: $key = $value');
    });
  }

  /// Atualiza o estado com as informações do callback
  /// Equivalente ao updateCallbackInfo(uri: Uri) do Android
  void _updateCallbackInfo(Uri uri) {
    final parameters = Map<String, String>.from(uri.queryParameters);

    // CALLBACK: Atualiza estado com dados recebidos
    _callbackInfo.value = CallbackInfo(
      scheme: uri.scheme,
      host: uri.host,
      parameters: parameters,
    );
  }

  /// Verifica o deep link inicial (quando app é aberto pelo link)
  /// CALLBACK: Importante para capturar link quando app estava fechado
  Future<void> checkInitialLink() async {
    try {
      debugPrint('🔧 Verificando deep link inicial...');
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('🔥 Deep link inicial detectado: $initialUri');
        _processCallback(initialUri);
      } else {
        debugPrint('🔧 Nenhum deep link inicial encontrado');
      }
    } catch (e) {
      debugPrint('❌ Erro ao verificar deep link inicial: $e');
    }
  }

  /// Limpa os dados do callback
  /// Equivalente ao clearCallback() do Android
  void clearCallback() {
    _callbackInfo.value = const CallbackInfo();
  }

  /// Verifica se há dados de callback
  /// Equivalente ao hasCallbackData() do Android
  bool hasCallbackData() {
    return _callbackInfo.value.isNotEmpty;
  }

  /// Obtém um parâmetro específico
  /// Equivalente ao getParameter(key: String) do Android
  String? getParameter(String key) {
    return _callbackInfo.value.parameters[key];
  }

  /// Obtém todos os parâmetros
  /// Equivalente ao getAllParameters() do Android
  Map<String, String> getAllParameters() {
    return _callbackInfo.value.parameters;
  }

  /// Libera recursos
  /// CALLBACK: Cancela subscription quando não mais necessário
  void dispose() {
    _linkSubscription?.cancel();
    _callbackInfo.dispose();
    debugPrint('CallbackHandler finalizado');
  }
}
