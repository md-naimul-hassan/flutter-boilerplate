import 'package:flutter_dotenv/flutter_dotenv.dart';

class SecretKey {
  static final String publishableKey = dotenv.env['STRIPEPUBLISHABLEKEY'] ?? '';
  static final String secretKey = dotenv.env['STRIPESCERETKEY'] ?? '';
  static final String paymentIntent = dotenv.env['STRIPEPAYMENTINTENT'] ?? '';
}
