import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/cart_provider.dart';
import '../services/payment_service.dart';
import '../services/poster_api_service.dart';
import '../utils/config.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod? _selectedPaymentMethod;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Order summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ...cart.items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.product.name} x${item.quantity}',
                                  ),
                                ),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(2)} ${AppConfig.currencySymbol}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${cart.totalAmount.toStringAsFixed(2)} ${AppConfig.currencySymbol}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Payment methods
                Text(
                  'Select Payment Method',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _buildPaymentOption(
                  PaymentMethod.applePay,
                  'Apple Pay',
                  Icons.apple,
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  PaymentMethod.googlePay,
                  'Google Pay',
                  Icons.account_balance_wallet,
                ),
                const SizedBox(height: 12),
                _buildPaymentOption(
                  PaymentMethod.liqpay,
                  'LiqPay',
                  Icons.credit_card,
                ),
              ],
            ),
          ),
          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedPaymentMethod == null || _isProcessing
                      ? null
                      : () => _processPayment(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Pay ${cart.totalAmount.toStringAsFixed(2)} ${AppConfig.currencySymbol}',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    PaymentMethod method,
    String title,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context) async {
    if (_selectedPaymentMethod == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final cart = context.read<CartProvider>();
      final paymentService = context.read<PaymentService>();
      final posterApi = context.read<PosterApiService>();

      final orderId = 'order_${DateTime.now().millisecondsSinceEpoch}';

      // Process payment based on selected method
      Map<String, dynamic>? paymentResult;

      switch (_selectedPaymentMethod!) {
        case PaymentMethod.applePay:
          // Check if Apple Pay is available
          final isAvailable = await paymentService.isApplePayAvailable();
          if (!isAvailable) {
            throw Exception('Apple Pay is not available on this device');
          }
          paymentResult = await paymentService.processApplePay(
            amount: cart.totalAmount,
            orderId: orderId,
          );
          break;

        case PaymentMethod.googlePay:
          // Check if Google Pay is available
          final isAvailable = await paymentService.isGooglePayAvailable();
          if (!isAvailable) {
            throw Exception('Google Pay is not available on this device');
          }
          paymentResult = await paymentService.processGooglePay(
            amount: cart.totalAmount,
            orderId: orderId,
          );
          break;

        case PaymentMethod.liqpay:
          // Open LiqPay in WebView
          await _openLiqPayWebView(context, orderId);
          return;
      }

      // If payment successful, create order in Poster
      if (paymentResult != null && paymentResult['success'] == true) {
        await posterApi.createOrder(
          products: cart.toOrderFormat(),
          totalAmount: cart.totalAmount,
          comment: 'Payment via ${_selectedPaymentMethod!.name}',
        );

        // Clear cart and show success
        cart.clear();

        if (context.mounted) {
          _showSuccessDialog(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _openLiqPayWebView(
    BuildContext context,
    String orderId,
  ) async {
    final cart = context.read<CartProvider>();
    final paymentService = context.read<PaymentService>();

    final liqpayUrl = paymentService.generateLiqPayUrl(
      amount: cart.totalAmount,
      orderId: orderId,
      description: 'D.Cafe Order',
    );

    // Open in external browser or WebView
    final uri = Uri.parse(liqpayUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // In production, you'd wait for server callback to confirm payment
      // For now, we'll show a dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Processing'),
            content: const Text(
              'Please complete the payment in your browser. Return here after payment is complete.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _isProcessing = false;
                  });
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // In production, verify payment status with your server
                  final cart = context.read<CartProvider>();
                  final posterApi = context.read<PosterApiService>();

                  try {
                    await posterApi.createOrder(
                      products: cart.toOrderFormat(),
                      totalAmount: cart.totalAmount,
                      comment: 'Payment via LiqPay',
                    );

                    cart.clear();
                    Navigator.pop(context);
                    _showSuccessDialog(context);
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order creation failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Payment Complete'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Order Placed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green[600],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your order has been placed successfully.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Back to Menu'),
          ),
        ],
      ),
    );
  }
}
