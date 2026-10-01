import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/artisan_hub_provider.dart';
import '../../services/supabase_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  String _paymentMethod = 'upi';
  String _deliveryOption = 'standard';
  bool _isProcessingOrder = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).user;
      if (user.isAuthenticated) {
        if (_nameController.text.isEmpty && user.name.isNotEmpty) {
          _nameController.text = user.name;
        }
        if (_phoneController.text.isEmpty && user.phone.isNotEmpty) {
          _phoneController.text = user.phone;
        }
        if (_cityController.text.isEmpty && (user.district?.isNotEmpty ?? false)) {
          _cityController.text = user.district!;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> _requestOrder(double totalAmount, List items) async {
    setState(() => _isProcessingOrder = true);

    final authUser = ref.read(authProvider).user;
    final buyerId = SupabaseService.client.auth.currentUser?.id ??
        (authUser.isAuthenticated ? authUser.id : '9af21e46-2791-43f2-bab8-67b3e87425c3');
    final orderId = 'VIR-${Random().nextInt(89999) + 10000}';
    final fullAddress = '${_addressController.text}, ${_cityController.text} ${_pincodeController.text}';

    for (var item in items) {
      final artisanOrder = ArtisanOrder(
        orderId: orderId,
        buyerName: _nameController.text.isNotEmpty ? _nameController.text : 'Verified Buyer',
        craftName: item.product.name,
        price: '₹ ${item.totalPrice.round()}',
        quantity: item.quantity,
        status: 'Pending',
        date: DateTime.now().toIso8601String().split('T').first,
        buyerLocation: fullAddress,
        buyerId: buyerId,
      );

      ref.read(artisanOrdersProvider.notifier).addOrder(artisanOrder);

      await SupabaseService.createOrder(
        orderNumber: orderId,
        buyerId: buyerId,
        product: item.product,
        artisanId: item.product.artisanId.isNotEmpty ? item.product.artisanId : null,
        quantity: item.quantity,
        totalAmount: item.totalPrice,
        shippingAddress: fullAddress,
      );
    }

    ref.read(cartProvider.notifier).clearCart();

    if (!mounted) return;
    setState(() => _isProcessingOrder = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.green,
                size: 42,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Request Sent! 📩',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order #$orderId',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your order request has been sent directly to the master artisan. Once accepted, you will be notified to complete payment and start delivery tracking.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.terracottaLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.volunteer_activism_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '₹ ${(totalAmount * 0.84).round()} reserved directly for the artisan.',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.go('/orders');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Track Order Approval Status', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalAmount = ref.watch(cartProvider.notifier).totalAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Request Order',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _isProcessingOrder
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
                  SizedBox(height: 20),
                  Text(
                    'Submitting Order Request to Artisan...',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Recording request in Supabase Database',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            )
          : Stepper(
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: () {
                if (_currentStep < 3) {
                  setState(() => _currentStep += 1);
                } else {
                  _requestOrder(totalAmount, cartItems);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              controlsBuilder: (context, details) {
                return Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: details.onStepContinue,
                            icon: Icon(_currentStep == 3 ? Icons.send_rounded : Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            label: Text(
                              _currentStep == 3 ? 'Send Order Request (₹ ${totalAmount.round()})' : 'Continue',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Back'),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: [
                // Step 1: Delivery Address
                Step(
                  title: const Text('Address', style: TextStyle(fontSize: 11)),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.editing,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Address',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Phone Number',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Street Address / Village / Landmark',
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText: 'City / District',
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _pincodeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Pincode',
                                filled: true,
                                fillColor: AppColors.surface,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Step 2: Delivery Speed
                Step(
                  title: const Text('Delivery', style: TextStyle(fontSize: 11)),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.editing,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shipping & Eco-Packaging',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      RadioListTile<String>(
                        value: 'standard',
                        groupValue: _deliveryOption,
                        activeColor: AppColors.primary,
                        title: const Text('Standard Eco Delivery (Free GI Certificate)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Delivered in 4 - 7 business days via India Post Craft Courier'),
                        onChanged: (val) => setState(() => _deliveryOption = val!),
                      ),
                      RadioListTile<String>(
                        value: 'express',
                        groupValue: _deliveryOption,
                        activeColor: AppColors.primary,
                        title: const Text('Express Artisan Direct Delivery (+ ₹150)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Delivered in 2 - 3 business days with special gift box'),
                        onChanged: (val) => setState(() => _deliveryOption = val!),
                      ),
                    ],
                  ),
                ),

                // Step 3: Payment Options
                Step(
                  title: const Text('Payment', style: TextStyle(fontSize: 11)),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.editing,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      RadioListTile<String>(
                        value: 'upi',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primary,
                        title: const Text('BHIM UPI / Google Pay / PhonePe', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Zero fee instant transfer'),
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                      if (_paymentMethod == 'upi') ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          child: TextField(
                            controller: _upiIdController,
                            decoration: InputDecoration(
                              labelText: 'UPI VPA ID (e.g. name@okaxis)',
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                      RadioListTile<String>(
                        value: 'card',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primary,
                        title: const Text('Credit / Debit Card', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Visa, Mastercard, RuPay, Amex'),
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                      RadioListTile<String>(
                        value: 'netbanking',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primary,
                        title: const Text('Net Banking', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('SBI, HDFC, ICICI, Axis & 50+ Banks'),
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                      RadioListTile<String>(
                        value: 'wallet',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primary,
                        title: const Text('Wallets', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Paytm, Amazon Pay, Mobikwik'),
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                      RadioListTile<String>(
                        value: 'cod',
                        groupValue: _paymentMethod,
                        activeColor: AppColors.primary,
                        title: const Text('Cash on Delivery (COD)', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Pay upon delivery to artisan courier'),
                        onChanged: (val) => setState(() => _paymentMethod = val!),
                      ),
                    ],
                  ),
                ),

                // Step 4: Order Review
                Step(
                  title: const Text('Review', style: TextStyle(fontSize: 11)),
                  isActive: _currentStep >= 3,
                  state: StepState.editing,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Review & Send Order Request',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Items:', style: TextStyle(color: AppColors.textSecondary)),
                                Text('${cartItems.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Speed:', style: TextStyle(color: AppColors.textSecondary)),
                                Text(_deliveryOption.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Payment Mode:', style: TextStyle(color: AppColors.textSecondary)),
                                Text(_paymentMethod.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('₹ ${totalAmount.round()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
