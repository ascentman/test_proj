import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pay/pay.dart';
import 'package:crypto/crypto.dart';
import '../utils/config.dart';

enum PaymentMethod {
  applePay,
  googlePay,
  liqpay,
}

class PaymentService {
  /// Check if Apple Pay is available on this device
  Future<bool> isApplePayAvailable() async {
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString(
        _getApplePayConfig(),
      );
      // Note: Actual availability check would require platform-specific code
      return !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    } catch (e) {
      return false;
    }
  }

  /// Check if Google Pay is available on this device
  Future<bool> isGooglePayAvailable() async {
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString(
        _getGooglePayConfig(),
      );
      // Note: Actual availability check would require platform-specific code
      return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    } catch (e) {
      return false;
    }
  }

  /// Process Apple Pay payment
  Future<Map<String, dynamic>> processApplePay({
    required double amount,
    required String orderId,
  }) async {
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString(
        _getApplePayConfig(),
      );

      final paymentItems = [
        PaymentItem(
          label: 'D.Cafe Order',
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // This would trigger Apple Pay sheet
      // In production, you'd handle the payment token and send to your backend
      return {
        'success': true,
        'method': 'apple_pay',
        'order_id': orderId,
      };
    } catch (e) {
      throw Exception('Apple Pay failed: $e');
    }
  }

  /// Process Google Pay payment
  Future<Map<String, dynamic>> processGooglePay({
    required double amount,
    required String orderId,
  }) async {
    try {
      final paymentConfiguration = PaymentConfiguration.fromJsonString(
        _getGooglePayConfig(),
      );

      final paymentItems = [
        PaymentItem(
          label: 'D.Cafe Order',
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ];

      // This would trigger Google Pay sheet
      // In production, you'd handle the payment token and send to your backend
      return {
        'success': true,
        'method': 'google_pay',
        'order_id': orderId,
      };
    } catch (e) {
      throw Exception('Google Pay failed: $e');
    }
  }

  /// Generate LiqPay payment URL
  /// LiqPay requires server-side signature generation for security
  String generateLiqPayUrl({
    required double amount,
    required String orderId,
    required String description,
  }) {
    final data = {
      'version': '3',
      'public_key': AppConfig.liqpayPublicKey,
      'action': 'pay',
      'amount': amount.toStringAsFixed(2),
      'currency': AppConfig.currency,
      'description': description,
      'order_id': orderId,
      'result_url': 'dcafe://payment/success',
      'server_url': 'YOUR_SERVER_CALLBACK_URL', // TODO: Add your server URL
    };

    final dataJson = jsonEncode(data);
    final dataBase64 = base64.encode(utf8.encode(dataJson));

    // Generate signature: base64(sha1(private_key + data + private_key))
    final signString =
        '${AppConfig.liqpayPrivateKey}$dataBase64${AppConfig.liqpayPrivateKey}';
    final signBytes = utf8.encode(signString);
    final signature = base64.encode(sha1.convert(signBytes).bytes);

    return 'https://www.liqpay.ua/api/3/checkout?data=$dataBase64&signature=$signature';
  }

  /// Apple Pay configuration
  String _getApplePayConfig() {
    return '''{
      "provider": "apple_pay",
      "data": {
        "merchantIdentifier": "merchant.com.dcafe.app",
        "displayName": "D.Cafe",
        "merchantCapabilities": ["3DS", "debit", "credit"],
        "supportedNetworks": ["visa", "masterCard"],
        "countryCode": "UA",
        "currencyCode": "${AppConfig.currency}"
      }
    }''';
  }

  /// Google Pay configuration
  String _getGooglePayConfig() {
    return '''{
      "provider": "google_pay",
      "data": {
        "environment": "TEST",
        "apiVersion": 2,
        "apiVersionMinor": 0,
        "allowedPaymentMethods": [
          {
            "type": "CARD",
            "tokenizationSpecification": {
              "type": "PAYMENT_GATEWAY",
              "parameters": {
                "gateway": "example",
                "gatewayMerchantId": "YOUR_GATEWAY_MERCHANT_ID"
              }
            },
            "parameters": {
              "allowedCardNetworks": ["VISA", "MASTERCARD"],
              "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
              "billingAddressRequired": false
            }
          }
        ],
        "merchantInfo": {
          "merchantName": "D.Cafe"
        },
        "transactionInfo": {
          "countryCode": "UA",
          "currencyCode": "${AppConfig.currency}"
        }
      }
    }''';
  }
}
