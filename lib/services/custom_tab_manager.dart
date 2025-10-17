import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTabManager {
  // MethodChannel para comunicação com código nativo
  static const _channel = MethodChannel('custom_tab_channel');

  /// Inicializa o Custom Tab Manager
  /// Equivalente ao initialize() do Android
  Future<void> initialize() async {
    debugPrint('🔧 CustomTabManager inicializado');
    try {
      await _channel.invokeMethod('initializeCustomTabs');
      debugPrint('🔧 Custom Tabs Service inicializado no Android');
    } catch (e) {
      debugPrint('⚠️ Erro ao inicializar Custom Tabs: $e');
    }
  }

  /// Limpa recursos quando não mais necessário
  /// Equivalente ao cleanup() do Android
  void cleanup() {
    debugPrint('CustomTabManager finalizado');
  }

  /// Abre uma URL no Custom Tab usando implementação nativa
  /// Equivalente ao openCustomTab(url: String) do Android
  Future<void> openCustomTab(BuildContext context, String url) async {
    if (url.isEmpty) {
      debugPrint('⚠️ URL vazia, abortando abertura do Custom Tab');
      return;
    }

    try {
      debugPrint('🚀 Abrindo Custom Tab: $url');
      final result = await _channel.invokeMethod('openCustomTab', {'url': url});
      if (result == true) {
        debugPrint('✅ Custom Tab aberto com sucesso');
      }
    } catch (e) {
      debugPrint('❌ Erro ao abrir Custom Tab: $e');
    }
  }

  /// Fecha o Custom Tab/Safari View Controller
  /// No Android, não é necessário (fecha automaticamente)
  /// No iOS, fecha o Safari View Controller programaticamente
  Future<void> closeCustomTab() async {
    try {
      debugPrint('🔒 Fechando Custom Tab...');
      await _channel.invokeMethod('closeCustomTab');
      debugPrint('✅ Custom Tab fechado');
    } catch (e) {
      debugPrint('⚠️ Erro ao fechar Custom Tab: $e');
    }
  }
}
