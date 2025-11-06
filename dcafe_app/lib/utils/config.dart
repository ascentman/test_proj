/// Configuration file for D.Cafe app
class AppConfig {
  // Poster API Configuration
  static const String posterApiBaseUrl = 'https://joinposter.com/api';

  // TODO: Add your Poster API credentials here
  // Get these from your Poster account at: https://joinposter.com/manage/integration
  static const String posterAccountName = 'YOUR_ACCOUNT_NAME';
  static const String posterApplicationId = 'YOUR_APPLICATION_ID';
  static const String posterApplicationSecret = 'YOUR_APPLICATION_SECRET';

  // LiqPay Configuration
  // Get these from: https://www.liqpay.ua/
  static const String liqpayPublicKey = 'YOUR_LIQPAY_PUBLIC_KEY';
  static const String liqpayPrivateKey = 'YOUR_LIQPAY_PRIVATE_KEY';

  // App Configuration
  static const String appName = 'D.Cafe';
  static const String currency = 'UAH'; // Ukrainian Hryvnia
  static const String currencySymbol = '₴';

  // API Endpoints
  static const String menuEndpoint = '/menu.getProducts';
  static const String categoriesEndpoint = '/menu.getCategories';
  static const String createOrderEndpoint = '/incomingOrders.createIncomingOrder';
}
