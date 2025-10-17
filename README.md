# Unico Custom Tab Flutter

POC de Custom Tabs (Android) e Safari View Controller (iOS) em Flutter - Portado do projeto Android Kotlin original.

## 📱 Descrição

Este projeto é uma implementação Flutter.
Demonstra o uso de Custom Tabs para abrir URLs de forma nativa e gerenciar callbacks através de deep links, com **fechamento automático** do Custom Tab/Safari quando o callback é recebido.

## ✨ Funcionalidades

- ✅ Abertura de URLs em Custom Tab (Android) / Safari View Controller (iOS)
- ✅ **Fechamento automático** do Custom Tab/Safari ao receber callback
- ✅ Personalização de cores da toolbar (Unico Blue #007BFF)
- ✅ Recepção de callbacks via deep links
- ✅ Suporte a múltiplos esquemas de URL (foobar:// e https://)
- ✅ Interface idêntica ao projeto Android original
- ✅ Implementação nativa (MethodChannel) para controle total
- ✅ Mesmas fontes e logo do projeto original

## 🚀 Como Executar

```bash
flutter pub get
flutter run
```

## 🔗 Deep Links Configurados

### Android & iOS
- **Custom Scheme**: `foobar://success`
- **App Link (Android)**: `https://customtab.test.io/callback`
- **Universal Link (iOS)**: `https://customtab.test.io/callback`

## 🧪 Testando Callbacks

### ⚠️ Requisito Importante: Configuração do `callbackUri`

Para que o Custom Tab/Safari feche automaticamente, **é obrigatório** que a URL de processo seja criada com o parâmetro `callbackUri` configurado corretamente.

**Exemplo de criação do processo:**
```json
{
  "callbackUri": "foobar://success?token=abc123&status=ok"
}
```

### Fluxo de Teste:

1. Configure o processo com o `callbackUri` apontando para `foobar://success`
2. Abra o app e insira a URL do processo
3. O Custom Tab/Safari será aberto
4. Quando o processo redirecionar para `foobar://success`, o Custom Tab/Safari **fecha automaticamente**
5. O app exibe as informações do callback na tela

### URL de Teste:
```
https://cadastro.uat.unico.app/process/{process-id}
```

**Nota**: O processo deve estar configurado com `callbackUri: "foobar://success?..."` para que o redirecionamento funcione.

## 📦 Estrutura

```
lib/
├── main.dart                      # MainActivity equivalente
├── services/
│   ├── custom_tab_manager.dart   # Gerenciador de Custom Tabs (MethodChannel)
│   └── callback_handler.dart     # Gerenciador de callbacks (app_links)
└── theme/
    ├── colors.dart               # Cores Unico
    └── theme.dart                # Tema da aplicação

android/app/src/main/kotlin/.../MainActivity.kt
├── Custom Tab nativo com flags específicas
├── MethodChannel: custom_tab_channel
└── Flags: user_opt_out_from_session = false (fechamento automático)

ios/Runner/AppDelegate.swift
├── Safari View Controller
├── MethodChannel: custom_tab_channel
└── Fechamento programático ao receber callback
```

## 🔧 Implementação Técnica

### Android (Custom Tabs)

O projeto utiliza implementação **nativa** do Custom Tabs via `MainActivity.kt` com `MethodChannel`:

**Flags Críticas para Fechamento Automático:**
```kotlin
putExtra("android.support.customtabs.extra.user_opt_out_from_session", false)
putExtra("androidx.browser.customtabs.extra.user_opt_out_from_session", false)
addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
```

**AndroidManifest.xml:**
- `android:launchMode="singleTop"` - Essencial para receber callbacks
- Intent filters para `foobar://` e `https://customtab.test.io`

### iOS (Safari View Controller)

**AppDelegate.swift:**
- Implementação via `SFSafariViewController`
- Fechamento programático quando callback é recebido
- MethodChannel para comunicação Flutter ↔ Native

### Deep Links (app_links)

**Callback Handler:**
- Detecta automaticamente a plataforma (iOS/Android)
- iOS: Fecha o Safari VC programaticamente
- Android: Custom Tab fecha automaticamente (devido às flags)

```dart
if (Platform.isIOS) {
  _customTabManager.closeCustomTab();  // Fecha manualmente
} else {
  // Android fecha automaticamente
}
```

## 🎯 Por Que Implementação Nativa?

O plugin `flutter_custom_tabs` **não expõe** as flags necessárias para fechamento automático no Android:
- `user_opt_out_from_session`
- Intent flags específicas

Por isso, implementamos:
- ✅ `MethodChannel` customizado
- ✅ Controle total das flags no Android
- ✅ Controle programático no iOS
- ✅ Comportamento idêntico ao projeto Kotlin original

## 📱 Diferenças entre Plataformas

| Recurso | Android | iOS |
|---------|---------|-----|
| Custom Tab/Safari | Custom Tabs | Safari View Controller |
| Fechamento | Automático (flags) | Programático (dismiss) |
| Deep Links | Intent filters | URL Schemes + Universal Links |
| Cores toolbar | Suportado | Suportado |
| Animações | Slide in/out | Padrão iOS |
# unico-cbu-poc-flutter
