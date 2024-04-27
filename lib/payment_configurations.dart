import 'package:flutter/foundation.dart';

String get googlePayPaymentProfile => """{
  "provider": "google_pay",
  "data": {
    "environment": "${kDebugMode ? "TEST" : "PRODUCTION"}",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "stripe",
            "stripe:version": "2023-10-16",
            "stripe:publishableKey": "pk_test_51P29RKJd5Hj3kQdBXWGvzYfAmkrHpIDA4KZVnyK2BJGoG1yAsGl8I5GDV2S0WymnApKXWyCtNleEDO9dMyFUCOfM00gy22LQtI"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": false,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "BCR2DN4TQGK3HORL", 
      "merchantName": "BCR2DN4TQGK3HORL"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "PKR"
    }
  }
}""";

String get applePayPaymentProfile => """{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "BCR2DN4TQGK3HORL",
    "displayName": "Haddi",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber"],
    "requiredShippingContactFields": [],
    "shippingMethods": [] 
  }
}""";
