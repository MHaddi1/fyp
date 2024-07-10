import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp/payment_configurations.dart';
import 'package:fyp/views/congratulation.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:pay/pay.dart' as pay;
import 'package:pay/pay.dart';
import 'dart:io' show Platform;

class C_DPayment extends StatefulWidget {
  const C_DPayment({super.key, this.amount});

  final dynamic amount;

  @override
  State<C_DPayment> createState() => _C_DPaymentState();
}

class _C_DPaymentState extends State<C_DPayment> {
  Map<String, dynamic>? paymentIntent;
  GooglePayButton? googlePayButton;
  ApplePayButton? applePayButton;

  // Future<void> onGooglePayResult(paymentResult) async {
  //   final response = await createPaymentIntent();
  //   final clientSecret = response['clientSecret'];
  //   final token =
  //       paymentResult['paymentMethodData']['tokenizationData']['token'];
  //   final tokenJson = Map.castFrom(json.decode(token));

  //   final params = PaymentMethodParams.cardFromToken(

  //     paymentMethodData: null,
  //   );
  //   // Confirm Google pay payment method
  //   await Stripe.instance.confirmPayment(
  //     clientSecret,
  //     params,
  //   );
  // }

  makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      var gPage = PaymentSheetGooglePay(
          amount: widget.amount.toString(),
          merchantCountryCode: "US",
          testEnv: true,
          currencyCode: "US");
      var aPay = const PaymentSheetApplePay(
        merchantCountryCode: "US",
        buttonType: PlatformButtonType.buy,
      );
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: "Haddi",
        googlePay: gPage,
        applePay: aPay,
      ));
      displayPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Done");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successful!')),
      );
     await Future.delayed(Duration(seconds: 3)).then((value){
       Get.offAll(()=>Cong());
     });
    } catch (e) {
      print("error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "100",
        "currency": "USD",
        'payment_method_types[]': 'card',
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51PBbZECF5TkBhPkXR0GMYoJpw0YBXfdTT32WTb0D7Gl4BM626aYYrl7ATILCotfwIDSZ0Z7wW7tgpMbOCS4l2SDg00u3TJ2RBl",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      Get.log('on Google Pay Result');
      // loadingDialog();
      Get.log('result:$paymentResult');
      // 2. fetch Intent Client Secret from backend
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      Get.log('token:$tokenJson');
      final response = await createPaymentIntent();
      Get.log('payment intent response: $response');
      final clientSecret = response['client_secret'];
      Get.log('client secret: $clientSecret');
      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: tokenJson['id'],
        ),
      );
      Get.log('params: $params');
      // 3. Confirm Google pay payment method
     await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );
      //print("The Payment ${pay}");
      debugPrint('payment successful');
      //await purchaseTicket();
    } catch (e, trace) {
      Get.log('Error: $e');
      Get.log('trace: $trace');
      Get.back();
      // Get.showSnackbar(Ui.ErrorSnackBar(message: 'Error: $e'));
    }
  }

  @override
  void initState() {
    super.initState();
    print("----------AMOUNT-----------");
    print(widget.amount);
    googlePayButton = pay.GooglePayButton(
      width: Get.width,
      height: 55,
      type: GooglePayButtonType.pay,
      paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
        googlePayPaymentProfile,
      ),
      paymentItems: [
        pay.PaymentItem(
          label: "Product 1",
          amount: "1000",
          status: pay.PaymentItemStatus.final_price,
        )
      ],
      margin: const EdgeInsets.only(top: 15),
      onPaymentResult: onGooglePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      childOnError: const Text(
        'Google Pay is not available in this device',
      ),
      onError: (e) {
        print("-------------------Error-------------------");
        log(1);

        // Get.showSnackbar();
      },
    );
    applePayButton = pay.ApplePayButton(
      width: Get.width,
      height: 55,
      type: pay.ApplePayButtonType.buy,
      paymentConfiguration: pay.PaymentConfiguration.fromJsonString(
        applePayPaymentProfile,
      ),
      paymentItems: [
        pay.PaymentItem(
          label: "Product 1",
          amount: "100",
          status: pay.PaymentItemStatus.final_price,
        )
      ],
      margin: const EdgeInsets.only(top: 15),
      onPaymentResult: onGooglePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
      childOnError: const Text(
        'Apple Pay is not available in this device',
      ),
      onError: (e) {
        print("-------------------Error-------------------");
        log(1);

        // Get.showSnackbar();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          if (Platform.isIOS) applePayButton!,
          if (Platform.isAndroid)
            Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: googlePayButton!),
          Center(
              child: Container(
            height: 56,
            width: 150,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(12.0)),
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Pay",
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () async {
                        await makePayment();
                      },
                      icon: const Icon(Icons.payment, color: Colors.white)),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Future<void> applePayResult(paymentResult) async {
    try {
      //loadingDialog();
      debugPrint('result: $paymentResult');
      // 1. Get Stripe token from payment result
      final token = await Stripe.instance.createApplePayToken(paymentResult);

      // 2. fetch Intent Client Secret from backend
      final response = await createPaymentIntent();
      final clientSecret = response['client_secret'];

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: PaymentMethodDataCardFromToken(
          token: token.id,
        ),
      );

      // 3. Confirm Apple pay payment method
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: params,
      );

      debugPrint('payment successful');
      //await purchaseTicket();
    } catch (e, trace) {
      Get.back();
      debugPrint('error: $e');
      debugPrint('trace: $trace');
      //Get.showSnackbar(Ui.ErrorSnackBar(message: 'Error: $e'));
    }
  }
}
