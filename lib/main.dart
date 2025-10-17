import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'theme/colors.dart';
import 'services/custom_tab_manager.dart';
import 'services/callback_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomTab',
      theme: CustomTabTheme.lightTheme(),
      darkTheme: CustomTabTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const MainActivity(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Tela principal - Equivalente à MainActivity.kt do Android
class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  // Gerenciadores
  late final CustomTabManager _customTabManager;
  late final CallbackHandler _callbackHandler;

  // Controlador de texto para input da URL
  final TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeManagers();

    // URL de exemplo pré-preenchida (opcional - remova se não quiser)
    _urlController.text = '<sual URL aqui>';
  }

  @override
  void dispose() {
    _customTabManager.cleanup();
    _callbackHandler.dispose();
    _urlController.dispose();
    super.dispose();
  }

  /// Inicializa os gerenciadores
  /// Equivalente ao initializeManagers() do Android
  void _initializeManagers() {
    _customTabManager = CustomTabManager();
    _callbackHandler = CallbackHandler();
    _customTabManager.initialize();
    _callbackHandler.initialize();

    // CALLBACK: Verifica se app foi aberto por deep link
    _callbackHandler.checkInitialLink();
  }

  /// Abre URL no Custom Tab
  /// Equivalente ao openUrl(url: String) do Android
  void _openUrl(String url) {
    if (url.isNotEmpty) {
      _customTabManager.openCustomTab(context, url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                // Logo Unico
                Image.asset(
                  'assets/images/logo_1.png',
                  width: 100,
                  height: 100,
                ),

                const SizedBox(height: 30),

                // Título de boas-vindas
                Text(
                  'Bem-vindo ao by Unico!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 24,
                  ),
                ),

                const SizedBox(height: 30),

                // Instrução
                Text(
                  'Abaixo insira o link gerado:',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                // Campo de texto para URL
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      labelText: 'Insira uma URL aqui',
                      labelStyle: theme.textTheme.bodyMedium,
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(height: 30),

                // Botão Confirmar
                SizedBox(
                  width: 290,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _openUrl(_urlController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: unicoBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'Confirmar',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // CALLBACK: Seção de informações do callback
                ValueListenableBuilder<CallbackInfo>(
                  valueListenable: _callbackHandler.callbackInfo,
                  builder: (context, callbackInfo, child) {
                    if (_callbackHandler.hasCallbackData()) {
                      return _buildCallbackInfoSection(callbackInfo, theme);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói a seção de informações do callback
  /// Equivalente ao CallbackInfoSection() do Android
  Widget _buildCallbackInfoSection(CallbackInfo callbackInfo, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Callback Recebido:',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scheme: ${callbackInfo.scheme}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Host: ${callbackInfo.host}',
            style: theme.textTheme.bodyMedium,
          ),

          // Exibe parâmetros se houver
          if (callbackInfo.parameters.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Parâmetros:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...callbackInfo.parameters.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                child: Text(
                  '  • ${entry.key}: ${entry.value}',
                  style: theme.textTheme.labelSmall,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
