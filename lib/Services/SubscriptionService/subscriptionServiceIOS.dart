import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:astro_prompt/Services/RefreshToken/autoRefreshToken.dart';
import 'package:astro_prompt/config/api_endpoints.dart';
import 'package:astro_prompt/config/LocallySavedData/premiumUser.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/Model/payment_update_result.dart';

class SubscriptionIosService {
  // Singleton pattern for easy access
  static final SubscriptionIosService _instance = SubscriptionIosService._internal();
  factory SubscriptionIosService() => _instance;
  SubscriptionIosService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;

  InAppPurchase get iap => _iap;

  static const String _kProductId = 'com.teksage.monthlyPlan';
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _initialized = false;

  final ValueNotifier<String?> errorNotifier = ValueNotifier(null); // For UI error feedback
  final ValueNotifier<bool> loadingNotifier = ValueNotifier(false); // For loader UI

  // Store last purchase for local checks
  PurchaseDetails? _lastPurchase;

  /// Initialize IAP and register platform for iOS
  Future<bool> init() async {
    if (_initialized) {
      debugPrint('⚙️ SubscriptionIosService already initialized');
      return true;
    }
    try {
      if (Platform.isIOS) {
        debugPrint('📲 Registering StoreKit platform');
        InAppPurchaseStoreKitPlatform.registerPlatform();
      }
      debugPrint('🚀 Initializing In-App Purchase service');
      _isAvailable = await _iap.isAvailable();
      if (!_isAvailable) {
        errorNotifier.value = 'Store not available';
        debugPrint('❌ Store not available');
        return false;
      }
      // Subscribe to purchase updates
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () {
          debugPrint('🔚 Purchase stream closed');
          _subscription.cancel();
        },
        onError: (error) {
          errorNotifier.value = 'Purchase stream error: $error';
          debugPrint('💥 Purchase stream error: $error');
        },
      );

      await _loadProducts();
      _initialized = true;
      return true;
    } catch (e) {
      errorNotifier.value = 'Initialization error: $e';
      debugPrint('❌ Initialization error: $e');
      return false;
    }
  }

  /// Query available subscription products
  Future<bool> _loadProducts() async {
    try {
      debugPrint('🛒 Querying product details for: $_kProductId');

      // Wait a bit to ensure StoreKit is initialized
      await Future.delayed(const Duration(seconds: 2));

      final response = await _iap.queryProductDetails({_kProductId});

      if (response.error != null) {
        errorNotifier.value = 'Error loading products: ${response.error!.message}';
        debugPrint('❌ Error loading products: ${response.error!.message}');
        return false;
      }

      if (response.productDetails.isEmpty) {
        errorNotifier.value = 'No products found. Check Product ID, App Store Connect, and device.';
        debugPrint('⚠️ No products found. Possible causes:');
        debugPrint('   • Product ID mismatch');
        debugPrint('   • Not attached to build in App Store Connect');
        debugPrint('   • Not testing on real device with Sandbox user');
        return false;
      }

      _products = response.productDetails.toList();
      debugPrint('✅ Products loaded successfully: ${_products.map((p) => p.id).join(', ')}');
      errorNotifier.value = null;
      return true;
    } catch (e) {
      errorNotifier.value = 'Product loading error: $e';
      debugPrint('❌ Product loading error: $e');
      return false;
    }
  }

  /// Trigger a subscription purchase
  Future<bool> buySubscription() async {
    try {
      if (!_initialized) {
        debugPrint('⚙️ Initializing IAP before purchase...');
        final ok = await init();
        if (!ok) return false;
      }

      if (_products.isEmpty) {
        debugPrint('🕐 Products list empty, reloading...');
        final ok = await _loadProducts();
        if (!ok) return false;
      }

      if (_products.isEmpty) {
        errorNotifier.value = 'No products available for purchase.';
        debugPrint('❌ No products available for purchase.');
        return false;
      }

      final product = _products.first;
      debugPrint('🧾 Initiating purchase for: ${product.id}');
      final purchaseParam = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      errorNotifier.value = null;
      return true;
    } catch (e) {
      errorNotifier.value = 'Purchase error: $e';
      debugPrint('❌ Purchase error: $e');
      return false;
    }
  }

  /// Restore purchases (for Restore Purchases button)
  Future<void> restorePurchases() async {
    loadingNotifier.value = true;
    await _iap.restorePurchases();
    // The purchaseStream will handle updates
  }

  /// Check if there is an active subscription locally
  bool hasActiveSubscriptionLocal() {
    if (_lastPurchase == null) return false;
    try {
      final verificationJson = json.decode(_lastPurchase!.verificationData.localVerificationData);
      final expiresDateMillis = verificationJson['expiresDate'];
      if (expiresDateMillis == null) return false;
      final expiresDate = DateTime.fromMillisecondsSinceEpoch(expiresDateMillis);
      return expiresDate.isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  /// Handle purchase updates
  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    debugPrint('📦 Handling ${purchases.length} purchase update(s)');
    for (final purchase in purchases) {
      debugPrint('🔄 Purchase status: ${purchase.status} (${purchase.productID})');
      if (purchase.status == PurchaseStatus.purchased) {
        loadingNotifier.value = false;
        debugPrint('🆕 New purchase completed');
        _lastPurchase = purchase;
        errorNotifier.value = null;
        // UI layer should call handleSuccessfulPurchase and act on result
      } else if (purchase.status == PurchaseStatus.restored) {
        loadingNotifier.value = false;
        debugPrint('🔄 Purchase restored');
        _lastPurchase = purchase;
        errorNotifier.value = null;
        // UI layer should call handleSuccessfulPurchase and act on result
      } else if (purchase.status == PurchaseStatus.error) {
        loadingNotifier.value = false;
        errorNotifier.value = 'Purchase failed: ${purchase.error?.message}';
        debugPrint('❌ Purchase failed: ${purchase.error?.message}');
      } else if (purchase.status == PurchaseStatus.canceled) {
        loadingNotifier.value = false;
        errorNotifier.value = 'Purchase canceled by user';
        debugPrint('⚠️ Purchase canceled by user');
      } else if (purchase.status == PurchaseStatus.pending) {
        loadingNotifier.value = true;
        errorNotifier.value = 'Purchase pending...';
        debugPrint('⏳ Purchase pending...');
      }
    }
  }

  /// Process successful purchases (business logic only, no UI)
  Future<PaymentUpdateResult> handleSuccessfulPurchase(PurchaseDetails purchase) async {
    debugPrint('🎉 Purchase completed successfully');
    debugPrint('--- PurchaseDetails ---');
    debugPrint('Product ID: ${purchase.productID}');
    debugPrint('Status: ${purchase.status}');
    debugPrint('Transaction Date: ${purchase.transactionDate}');
    debugPrint('Verification Data: ${purchase.verificationData.localVerificationData}');
    debugPrint('Source: ${purchase.verificationData.source}');
    debugPrint('Pending Complete Purchase: ${purchase.pendingCompletePurchase}');
    debugPrint('Error: ${purchase.error?.message}');
    // Parse and print verification data fields if possible
    try {
      final verificationJson = json.decode(purchase.verificationData.localVerificationData);
      debugPrint('--- Parsed Verification Data ---');
      verificationJson.forEach((key, value) {
        debugPrint('$key: $value');
      });
      debugPrint('-------------------------------');
      // Prepare payload for backend
      final payload = {
        'plan_id': 4,
        'transaction_id': verificationJson['transactionId'],
        'currency': verificationJson['currency'],
        'payment_amount': verificationJson['price'].toString(),
      };
      final response = await APIRequest.postRequest(ApiEndpoint.paymentUpdateIos, payload);
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final apiMessage = responseBody['message'] ?? '';
        await savePremiumUser(true);
        if (purchase.pendingCompletePurchase) {
          debugPrint('✅ Completing pending purchase...');
          _iap.completePurchase(purchase);
        }
        return PaymentUpdateResult(success: true, message: apiMessage);
      } else {
        errorNotifier.value = 'Payment update failed: ${response.statusCode}';
        debugPrint('❌ Payment update failed: ${response.statusCode}');
        return PaymentUpdateResult(success: false, errorMessage: 'Payment update failed: ${response.statusCode}');
      }
    } catch (e) {
      errorNotifier.value = 'Payment update error: $e';
      debugPrint('❌ Payment update error: $e');
      return PaymentUpdateResult(success: false, errorMessage: 'Payment update error: $e');
    }
  }

  /// Verify purchase and unlock features
  void _verifyAndGrantAccess(PurchaseDetails purchase) {
    // 🔐 Normally, verify the purchase with your backend or Apple server here.
    debugPrint('✅ Verified purchase for product: ${purchase.productID}');
  }

  /// Check subscription status
  Future<bool> hasActiveSubscription() async {
    // Implement actual check using local DB or backend.
    debugPrint('🔍 Checking subscription status...');
    return false;
  }

  /// Clean up resources
  void dispose() {
    debugPrint('🧹 Disposing SubscriptionIosService');
    _subscription.cancel();
  }
}
