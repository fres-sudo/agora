package com.example.agora

import android.app.Activity
import android.content.Intent
import com.sumup.merchant.reader.api.SumUpAPI
import com.sumup.merchant.reader.api.SumUpLogin
import com.sumup.merchant.reader.api.SumUpPayment
import com.sumup.merchant.reader.models.SavedCardReaderDetailsResult
import com.sumup.reader.sdk.api.SumUpState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.math.BigDecimal

class MainActivity : FlutterActivity() {
    private var affiliateKey = ""
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler(::handleMethodCall)
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                affiliateKey = call.argument<String>("affiliateKey")?.trim().orEmpty()
                if (affiliateKey.isNotEmpty()) SumUpState.init(applicationContext)
                result.success(null)
            }
            "status" -> result.success(statusMap())
            "login" -> launch(result) {
                if (affiliateKey.isEmpty()) {
                    finishPending(statusMap(message = "SumUp affiliate key is not configured."))
                    return@launch
                }
                val login = SumUpLogin.builder(affiliateKey).build()
                SumUpAPI.openLoginActivity(this, login, REQUEST_LOGIN)
            }
            "openReaderSettings" -> launch(result) {
                if (!SumUpAPI.isLoggedIn()) {
                    finishPending(statusMap(message = "Log in to SumUp first."))
                    return@launch
                }
                SumUpAPI.openCardReaderPage(this, REQUEST_READER_SETTINGS)
            }
            "logout" -> {
                SumUpAPI.logout()
                result.success(statusMap())
            }
            "charge" -> launch(result) {
                startCheckout(call)
            }
            else -> result.notImplemented()
        }
    }

    private fun launch(
        result: MethodChannel.Result,
        action: () -> Unit,
    ) {
        if (pendingResult != null) {
            result.error("busy", "Another SumUp operation is already running.", null)
            return
        }
        pendingResult = result
        try {
            action()
        } catch (error: Throwable) {
            finishPendingWithError(error)
        }
    }

    private fun startCheckout(call: MethodCall) {
        if (!SumUpAPI.isLoggedIn()) {
            finishPending(
                outcomeMap("failed", message = "Log in to SumUp before taking a card payment."),
            )
            return
        }

        val amountCents = call.argument<Number>("amountCents")?.toLong()
            ?: error("Missing amountCents")
        require(amountCents > 0) { "amountCents must be greater than zero" }
        val currencyCode = call.argument<String>("currencyCode")
            ?: error("Missing currencyCode")
        val currency = SumUpPayment.Currency.valueOf(currencyCode.uppercase())
        val title = call.argument<String>("title").orEmpty()
        val foreignTransactionId = call.argument<String>("foreignTransactionId")
            ?: error("Missing foreignTransactionId")

        val payment = SumUpPayment.builder()
            .total(BigDecimal.valueOf(amountCents, 2))
            .currency(currency)
            .title(title)
            .foreignTransactionId(foreignTransactionId)
            .skipSuccessScreen()
            .skipFailedScreen()
            .configureRetryPolicy(2_000L, 60_000L, true)
            .build()

        SumUpAPI.prepareForCheckout()
        SumUpAPI.checkout(this, payment, REQUEST_CHECKOUT)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        when (requestCode) {
            REQUEST_LOGIN, REQUEST_READER_SETTINGS -> {
                finishPending(statusMap(message = responseMessage(data)))
            }
            REQUEST_CHECKOUT -> finishPending(checkoutResult(resultCode, data))
        }
    }

    private fun checkoutResult(activityResultCode: Int, data: Intent?): Map<String, Any?> {
        if (activityResultCode == Activity.RESULT_CANCELED || data == null) {
            return outcomeMap("cancelled")
        }
        val code = data.getIntExtra(SumUpAPI.Response.RESULT_CODE, Int.MIN_VALUE)
        val message = responseMessage(data)
        return when (code) {
            SumUpAPI.Response.ResultCode.SUCCESSFUL -> outcomeMap(
                "approved",
                transactionCode = data.getStringExtra(SumUpAPI.Response.TX_CODE),
            )
            SumUpAPI.Response.ResultCode.ERROR_TRANSACTION_FAILED ->
                outcomeMap("declined", message = message)
            SumUpAPI.Response.ResultCode.ERROR_UNKNOWN_TRANSACTION_STATUS,
            SumUpAPI.Response.ResultCode.ERROR_DUPLICATE_FOREIGN_TX_ID,
            -> outcomeMap("unknown", message = message)
            else -> outcomeMap("failed", message = message ?: "SumUp checkout failed (code $code).")
        }
    }

    private fun responseMessage(data: Intent?): String? =
        data?.getStringExtra(SumUpAPI.Response.MESSAGE)?.takeIf { it.isNotBlank() }

    private fun statusMap(message: String? = null): Map<String, Any?> {
        if (affiliateKey.isEmpty()) {
            return mapOf(
                "readiness" to "notConfigured",
                "readerConnected" to false,
                "message" to (message ?: "SumUp affiliate key is not configured."),
            )
        }
        if (!SumUpAPI.isLoggedIn()) {
            return mapOf(
                "readiness" to "loggedOut",
                "readerConnected" to false,
                "message" to message,
            )
        }

        val merchant = SumUpAPI.getCurrentMerchant()
        val savedReader = SumUpAPI.getSavedCardReaderDetails()
        val readerModel = when (savedReader) {
            is SavedCardReaderDetailsResult.SavedCardReaderDetails ->
                savedReader.readerType.toString()
            else -> null
        }
        return mapOf(
            "readiness" to "ready",
            "merchantCode" to merchant?.merchantCode,
            "currencyCode" to merchant?.currency?.isoCode,
            "readerModel" to readerModel,
            "readerConnected" to SumUpAPI.isCardReaderConnected(),
            "message" to message,
        )
    }

    private fun outcomeMap(
        outcome: String,
        transactionCode: String? = null,
        message: String? = null,
    ): Map<String, Any?> = mapOf(
        "outcome" to outcome,
        "transactionCode" to transactionCode,
        "message" to message,
    )

    private fun finishPending(value: Any?) {
        pendingResult?.success(value)
        pendingResult = null
    }

    private fun finishPendingWithError(error: Throwable) {
        pendingResult?.error("sumup_error", error.message ?: "SumUp operation failed.", null)
        pendingResult = null
    }

    companion object {
        private const val CHANNEL_NAME = "space.fres.agora/sumup"
        private const val REQUEST_LOGIN = 5_101
        private const val REQUEST_READER_SETTINGS = 5_102
        private const val REQUEST_CHECKOUT = 5_103
    }
}
