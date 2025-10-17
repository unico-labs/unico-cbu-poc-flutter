package io.test.unico_customtab_flutter

import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.browser.customtabs.CustomTabsCallback
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsServiceConnection
import androidx.browser.customtabs.CustomTabsSession
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val CHANNEL = "custom_tab_channel"
        private const val UNICO_PRIMARY_COLOR = 0xFF007BFF.toInt()
        private const val UNICO_SECONDARY_COLOR = 0xFFE3F2FD.toInt()
    }

    private var customTabsClient: CustomTabsClient? = null
    private var customTabsSession: CustomTabsSession? = null
    private var methodChannel: MethodChannel? = null

    private val customTabsServiceConnection = object : CustomTabsServiceConnection() {
        override fun onCustomTabsServiceConnected(name: ComponentName, client: CustomTabsClient) {
            customTabsClient = client
            customTabsClient?.warmup(0L)
            customTabsSession = customTabsClient?.newSession(object : CustomTabsCallback() {
                override fun onNavigationEvent(navigationEvent: Int, extras: Bundle?) {
                    super.onNavigationEvent(navigationEvent, extras)
                    if (navigationEvent == NAVIGATION_FINISHED) {
                        Log.d(TAG, "Custom Tab: Navegação finalizada")
                    }
                }
            })
            Log.d(TAG, "Custom Tabs Service conectado")
        }

        override fun onServiceDisconnected(name: ComponentName) {
            customTabsClient = null
            customTabsSession = null
            Log.d(TAG, "Custom Tabs Service desconectado")
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "openCustomTab" -> {
                    val url = call.argument<String>("url")
                    if (url != null) {
                        openCustomTab(url)
                        result.success(true)
                    } else {
                        result.error("INVALID_URL", "URL não fornecida", null)
                    }
                }
                "initializeCustomTabs" -> {
                    bindCustomTabsService()
                    result.success(true)
                }
                "closeCustomTab" -> {
                    // Android: Custom Tab fecha automaticamente com as flags corretas
                    // Este método existe apenas para compatibilidade com iOS
                    Log.d(TAG, "closeCustomTab chamado (não necessário no Android)")
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        // CALLBACK: Log detalhado quando recebe intent
        Log.d(TAG, "=== onNewIntent CHAMADO ===")
        Log.d(TAG, "Action: ${intent.action}")
        Log.d(TAG, "Data: ${intent.data}")
        Log.d(TAG, "Scheme: ${intent.data?.scheme}")
        Log.d(TAG, "Host: ${intent.data?.host}")

        // Importante: Atualiza o intent da activity para que o plugin app_links possa processá-lo
        setIntent(intent)

        Log.d(TAG, "Intent atualizado e pronto para processamento")
        Log.d(TAG, "===========================")
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            unbindService(customTabsServiceConnection)
        } catch (e: Exception) {
            Log.d(TAG, "Service já desconectado")
        }
    }

    private fun bindCustomTabsService() {
        val packageName = CustomTabsClient.getPackageName(this, emptyList())
        if (packageName != null) {
            CustomTabsClient.bindCustomTabsService(this, packageName, customTabsServiceConnection)
            Log.d(TAG, "Binding Custom Tabs Service: $packageName")
        } else {
            Log.w(TAG, "Nenhum Custom Tabs Service disponível")
        }
    }

    private fun openCustomTab(url: String) {
        try {
            val uri = Uri.parse(url)
            customTabsSession?.mayLaunchUrl(uri, null, null)

            val customTabsIntent = createCustomTabsIntent()
            customTabsIntent.launchUrl(this, uri)

            Log.d(TAG, "Custom Tab aberto: $url")
        } catch (e: Exception) {
            Log.e(TAG, "Erro ao abrir Custom Tab: ${e.message}")
        }
    }

    private fun createCustomTabsIntent(): CustomTabsIntent {
        return CustomTabsIntent.Builder(customTabsSession).apply {
            setShowTitle(true)
            setUrlBarHidingEnabled(true)
            setToolbarColor(UNICO_PRIMARY_COLOR)
            setSecondaryToolbarColor(UNICO_SECONDARY_COLOR)
            setStartAnimations(this@MainActivity, android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            setExitAnimations(this@MainActivity, android.R.anim.slide_in_left, android.R.anim.slide_out_right)
            setInstantAppsEnabled(false)
        }.build().apply {
            intent.apply {
                putExtra(Intent.EXTRA_REFERRER, Uri.parse("android-app://${packageName}"))

                // CALLBACK: Configurações críticas para retorno automático ao app
                putExtra("android.support.customtabs.extra.user_opt_out_from_session", false)
                putExtra("androidx.browser.customtabs.extra.user_opt_out_from_session", false)

                addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)

                putExtra("com.android.browser.application_id", packageName)
            }
        }
    }
}
