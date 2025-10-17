import Flutter
import UIKit
import SafariServices

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var safariViewController: SFSafariViewController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    let customTabChannel = FlutterMethodChannel(
      name: "custom_tab_channel",
      binaryMessenger: controller.binaryMessenger
    )

    customTabChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }

      switch call.method {
      case "initializeCustomTabs":
        // iOS não precisa de inicialização especial
        print("🔧 Custom Tabs inicializado no iOS (SFSafariViewController)")
        result(true)

      case "openCustomTab":
        if let args = call.arguments as? [String: Any],
           let urlString = args["url"] as? String,
           let url = URL(string: urlString) {
          self.openSafariViewController(url: url, controller: controller)
          result(true)
        } else {
          result(FlutterError(code: "INVALID_URL", message: "URL inválida", details: nil))
        }

      case "closeCustomTab":
        // Fecha o Safari View Controller quando o callback é recebido
        self.closeSafariViewController(controller: controller)
        result(true)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func openSafariViewController(url: URL, controller: FlutterViewController) {
    print("🚀 Abrindo Safari View Controller: \(url)")

    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = false
    config.barCollapsingEnabled = true

    let safariVC = SFSafariViewController(url: url, configuration: config)
    safariVC.preferredBarTintColor = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0) // #007BFF
    safariVC.preferredControlTintColor = .white
    safariVC.dismissButtonStyle = .close

    self.safariViewController = safariVC
    controller.present(safariVC, animated: true) {
      print("✅ Safari View Controller apresentado")
    }
  }

  private func closeSafariViewController(controller: FlutterViewController) {
    print("🔒 Fechando Safari View Controller automaticamente...")

    if let safariVC = self.safariViewController {
      safariVC.dismiss(animated: true) {
        print("✅ Safari View Controller fechado com sucesso")
        self.safariViewController = nil
      }
    } else {
      print("⚠️ Nenhum Safari View Controller para fechar")
    }
  }
}
