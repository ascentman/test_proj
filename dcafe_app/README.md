# D.Cafe - Flutter Mobile & Web App

A modern Flutter application for D.Cafe that integrates with the Poster POS system API to display menu items and process payments through Apple Pay, Google Pay, and LiqPay.

## Features

- **Multi-platform Support**: iOS, Android, and Web
- **Menu Display**: Browse cafe menu organized by categories
- **Shopping Cart**: Add items, adjust quantities, and review orders
- **Multiple Payment Methods**:
  - Apple Pay (iOS)
  - Google Pay (Android)
  - LiqPay (Web & Mobile)
- **Real-time Sync**: Menu data synced with Poster POS system
- **Order Management**: Orders automatically sent to Poster system

## Screenshots

[Add your app screenshots here]

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Poster Account with API access
- LiqPay merchant account
- Apple Developer Account (for Apple Pay)
- Google Pay API access (for Google Pay)

## Installation

### 1. Clone the Repository

```bash
git clone <your-repo-url>
cd dcafe_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure API Credentials

Edit `lib/utils/config.dart` and add your credentials:

```dart
// Poster API Configuration
static const String posterAccountName = 'your_account_name';
static const String posterApplicationId = 'your_application_id';
static const String posterApplicationSecret = 'your_application_secret';

// LiqPay Configuration
static const String liqpayPublicKey = 'your_liqpay_public_key';
static const String liqpayPrivateKey = 'your_liqpay_private_key';
```

### 4. Set Poster API Access Token

In `lib/main.dart`, uncomment and set your access token:

```dart
posterApiService.setAccessToken('YOUR_ACCESS_TOKEN_HERE');
```

## Getting Poster API Credentials

1. Log in to your Poster account
2. Go to **Settings** → **Integration** → **API**
3. Create a new application or use existing one
4. Get your **Application ID**, **Application Secret**, and **Access Token**
5. Documentation: https://dev.joinposter.com/en/docs/v3/start/index

### Poster API Endpoints Used

- `menu.getCategories` - Fetch menu categories
- `menu.getProducts` - Fetch all products
- `incomingOrders.createIncomingOrder` - Create new order

## Payment Setup

### Apple Pay (iOS)

1. Enroll in Apple Developer Program
2. Configure Apple Pay in your Apple Developer account
3. Create a Merchant ID
4. Update `lib/services/payment_service.dart` with your Merchant ID:
   ```dart
   "merchantIdentifier": "merchant.com.dcafe.app"
   ```
5. Add Apple Pay capability in Xcode

### Google Pay (Android)

1. Register for Google Pay API
2. Get your Gateway Merchant ID
3. Update `lib/services/payment_service.dart`:
   ```dart
   "gatewayMerchantId": "YOUR_GATEWAY_MERCHANT_ID"
   ```
4. Test in TEST environment first

### LiqPay

1. Register at https://www.liqpay.ua/
2. Get Public and Private keys from your account
3. Add keys to `lib/utils/config.dart`
4. Set up server callback URL for payment verification

## Running the App

### iOS

```bash
flutter run -d ios
```

### Android

```bash
flutter run -d android
```

### Web

```bash
flutter run -d chrome
```

## Building for Production

### iOS

```bash
flutter build ios --release
```

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### Web

```bash
flutter build web --release
```

## Project Structure

```
dcafe_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── category.dart
│   │   ├── product.dart
│   │   └── cart_item.dart
│   ├── providers/                # State management
│   │   ├── cart_provider.dart
│   │   └── menu_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart
│   │   ├── cart_screen.dart
│   │   └── checkout_screen.dart
│   ├── services/                 # Business logic
│   │   ├── poster_api_service.dart
│   │   └── payment_service.dart
│   ├── widgets/                  # Reusable widgets
│   │   ├── category_tabs.dart
│   │   └── product_grid.dart
│   └── utils/                    # Utilities & config
│       └── config.dart
├── assets/                       # Images, fonts, etc.
├── pubspec.yaml                  # Dependencies
└── README.md
```

## Key Dependencies

- **provider**: State management
- **dio**: HTTP client for API calls
- **pay**: Apple Pay & Google Pay integration
- **webview_flutter**: LiqPay payment webview
- **cached_network_image**: Image caching
- **json_annotation**: JSON serialization

## Configuration Notes

### Currency

The app is configured for Ukrainian Hryvnia (UAH). To change:

```dart
// In lib/utils/config.dart
static const String currency = 'UAH';
static const String currencySymbol = '₴';
```

### API Base URL

If you need to change the API endpoint:

```dart
// In lib/utils/config.dart
static const String posterApiBaseUrl = 'https://joinposter.com/api';
```

## Testing

Run unit tests:

```bash
flutter test
```

## Troubleshooting

### Issue: Menu not loading

- Check your Poster API credentials
- Verify access token is set correctly
- Check network connectivity
- Review API response in debug logs

### Issue: Payment not working

- Verify payment provider credentials
- Check platform-specific setup (Apple Pay, Google Pay)
- Test in sandbox/test mode first
- Review payment provider documentation

### Issue: Build errors

```bash
flutter clean
flutter pub get
flutter run
```

## Security Notes

1. **Never commit API keys** to version control
2. Store sensitive credentials in environment variables
3. Use server-side verification for payment callbacks
4. Implement proper authentication for production
5. Enable HTTPS for all API calls

## Future Enhancements

- [ ] User authentication
- [ ] Order history
- [ ] Push notifications for order status
- [ ] Loyalty program integration
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Order customization (add notes, special requests)
- [ ] Table reservation system

## Support

For issues and questions:
- Poster API: https://dev.joinposter.com/en/docs
- LiqPay: https://www.liqpay.ua/documentation
- Flutter: https://docs.flutter.dev

## License

[Your License Here]

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

---

Made with ❤️ for D.Cafe
