import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../utils/config.dart';

class PaymentService {
  /// Generate LiqPay payment URL
  /// LiqPay handles all payment methods including cards, Apple Pay, Google Pay
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

  /// Generate LiqPay payment data for embedding
  /// Returns data and signature for embedding LiqPay button or form
  Map<String, String> generateLiqPayData({
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

    return {
      'data': dataBase64,
      'signature': signature,
    };
  }
}
