// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:zoomer/global/global_variable.dart';

// class StripeServices {
//   StripeServices._();
//   static final StripeServices instance = StripeServices._();
//   Future<void> makePayment() async {
//     try {
//       Stripe.publishableKey = stripePublishableKey;
//       String? paymentIntentClientSecret = await _createPaymentIntent(10, 'usd');
//       if (paymentIntentClientSecret == null) return;
//       await Stripe.instance.initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: paymentIntentClientSecret,
//               merchantDisplayName: "jincy kp"));
//       await _processPaymet();
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<String?> _createPaymentIntent(int amount, String currency) async {
//     try {
//       final Dio dio = Dio();
//       Map<String, dynamic> data = {
//         "amount": _calculateAmount(amount),
//         "currency": currency,
//       };
//       var response = await dio.post(
//         'https://api.stripe.com/v1/payment_intents',
//         data: data,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             "Authorization": "Bearer $stripeScretKey", // Corrected
//             "Content-Type": 'application/x-www-form-urlencoded'
//           },
//         ),
//       );

//       if (response.data != null) {
//         print("RESPONSE = ${response.data}");
//         return response.data["client_secret"];
//       }
//       return null;
//     } catch (e) {
//       print("Error creating payment intent: $e");
//       return null;
//     }
//   }

//   Future<void> _processPaymet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet();
//       await Stripe.instance.confirmPaymentSheetPayment();
//     } catch (e) {
//       print(e);
//     }
//   }

//   String _calculateAmount(int amount) {
//     final calculatedAmount = amount * 100;
//     return calculatedAmount.toString();
//   }
// }
