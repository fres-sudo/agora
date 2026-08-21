import Flutter
import SumUpSDK
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private static let sumUpChannelName = "space.fres.agora/sumup"
  private var affiliateKey = ""

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: Self.sumUpChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        self?.handleSumUpCall(call, result: result)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleSumUpCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      let arguments = call.arguments as? [String: Any]
      affiliateKey = (arguments?["affiliateKey"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
      if !affiliateKey.isEmpty {
        _ = SumUpSDK.setup(affiliateKey: affiliateKey)
      }
      result(nil)
    case "status":
      result(statusMap())
    case "login":
      login(result: result)
    case "openReaderSettings":
      openReaderSettings(result: result)
    case "logout":
      SumUpSDK.logout { [weak self] _, error in
        result(self?.statusMap(message: error?.localizedDescription))
      }
    case "charge":
      charge(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func login(result: @escaping FlutterResult) {
    guard !affiliateKey.isEmpty else {
      result(statusMap(message: "SumUp affiliate key is not configured."))
      return
    }
    guard let controller = window?.rootViewController else {
      result(flutterError("Unable to present SumUp login."))
      return
    }
    SumUpSDK.presentLogin(from: controller, animated: true) { [weak self] _, error in
      result(self?.statusMap(message: error?.localizedDescription))
    }
  }

  private func openReaderSettings(result: @escaping FlutterResult) {
    guard SumUpSDK.isLoggedIn else {
      result(statusMap(message: "Log in to SumUp first."))
      return
    }
    guard let controller = window?.rootViewController else {
      result(flutterError("Unable to present SumUp reader settings."))
      return
    }
    SumUpSDK.presentCardReaderSettings(from: controller, animated: true) { [weak self] _, error in
      result(self?.statusMap(message: error?.localizedDescription))
    }
  }

  private func charge(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard SumUpSDK.isLoggedIn, let merchant = SumUpSDK.currentMerchant else {
      result(outcomeMap("failed", message: "Log in to SumUp before taking a card payment."))
      return
    }
    guard let controller = window?.rootViewController else {
      result(outcomeMap("failed", message: "Unable to present SumUp checkout."))
      return
    }
    guard
      let arguments = call.arguments as? [String: Any],
      let amountCents = arguments["amountCents"] as? Int,
      amountCents > 0,
      let foreignTransactionId = arguments["foreignTransactionId"] as? String,
      !foreignTransactionId.isEmpty
    else {
      result(outcomeMap("failed", message: "Invalid SumUp checkout parameters."))
      return
    }

    let requestedCurrency = (arguments["currencyCode"] as? String)?.uppercased()
    guard let merchantCurrency = merchant.currencyCode, merchantCurrency == requestedCurrency else {
      result(outcomeMap("failed", message: "Order currency does not match the SumUp merchant currency."))
      return
    }

    let total = NSDecimalNumber(
      mantissa: UInt64(amountCents),
      exponent: -2,
      isNegative: false
    )
    let request = CheckoutRequest(
      total: total,
      title: arguments["title"] as? String,
      currencyCode: merchantCurrency
    )
    request.foreignTransactionID = foreignTransactionId
    request.skipScreenOptions = [.success, .failed]

    SumUpSDK.prepare(forCheckout: nil)
    SumUpSDK.checkout(with: request, from: controller) { checkoutResult, error in
      if let checkoutResult, checkoutResult.success {
        result(
          self.outcomeMap(
            "approved",
            transactionCode: checkoutResult.transactionCode
          )
        )
        return
      }
      if let error {
        let sdkError = error as NSError
        let description = sdkError.localizedDescription
        let isUnknown = sdkError.code == 53 || description.localizedCaseInsensitiveContains("unknown transaction")
        result(self.outcomeMap(isUnknown ? "unknown" : "failed", message: description))
        return
      }
      if checkoutResult != nil {
        result(self.outcomeMap("declined", message: "The card payment was declined."))
      } else {
        result(self.outcomeMap("cancelled"))
      }
    }
  }

  private func statusMap(message: String? = nil) -> [String: Any?] {
    guard !affiliateKey.isEmpty else {
      return [
        "readiness": "notConfigured",
        "readerConnected": false,
        "message": message ?? "SumUp affiliate key is not configured.",
      ]
    }
    guard SumUpSDK.isLoggedIn else {
      return [
        "readiness": "loggedOut",
        "readerConnected": false,
        "message": message,
      ]
    }

    let merchant = SumUpSDK.currentMerchant
    let reader = SumUpSDK.lastReaderStatus
    return [
      "readiness": "ready",
      "merchantCode": merchant?.merchantCode,
      "currencyCode": merchant?.currencyCode,
      "readerModel": reader.map { String(describing: $0.readerType) },
      "readerConnected": reader?.isActive ?? false,
      "message": message,
    ]
  }

  private func outcomeMap(
    _ outcome: String,
    transactionCode: String? = nil,
    message: String? = nil
  ) -> [String: Any?] {
    [
      "outcome": outcome,
      "transactionCode": transactionCode,
      "message": message,
    ]
  }

  private func flutterError(_ message: String) -> FlutterError {
    FlutterError(code: "sumup_error", message: message, details: nil)
  }
}
