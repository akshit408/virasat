import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/chat/models/chat_message_model.dart';
import '../../providers/artisan_hub_provider.dart';
import '../../services/supabase_service.dart';

class OrderDetailScreen extends StatefulWidget {
  final ArtisanOrder? order;

  const OrderDetailScreen({super.key, this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late ArtisanOrder _activeOrder;
  bool _isPaying = false;

  @override
  void initState() {
    super.initState();
    _activeOrder = widget.order ??
        const ArtisanOrder(
          orderId: 'ORD-89234',
          buyerName: 'Priya Sharma',
          craftName: 'Handcrafted Heritage Item',
          price: '₹ 2,800',
          quantity: 1,
          status: 'Accepted',
          date: 'Today',
          buyerLocation: 'New Delhi, Delhi',
        );
  }

  Future<void> _handlePayment() async {
    setState(() => _isPaying = true);
    await SupabaseService.payOrder(_activeOrder.orderId);
    if (!mounted) return;
    setState(() {
      _isPaying = false;
      _activeOrder = _activeOrder.copyWith(status: 'Processing');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful! Order status updated to Processing.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _activeOrder.status.toLowerCase();

    final isAccepted = ['accepted', 'processing', 'packed', 'shipped', 'delivered'].contains(status);
    final isPaidOrProcessing = ['processing', 'packed', 'shipped', 'delivered'].contains(status);
    final isPacked = ['packed', 'shipped', 'delivered'].contains(status);
    final isShipped = ['shipped', 'delivered'].contains(status);
    final isDelivered = status == 'delivered';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/orders');
            }
          },
        ),
        title: Text(
          'Order Tracking #${_activeOrder.orderId}',
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Order ${_activeOrder.orderId}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          _activeOrder.status.toUpperCase(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        backgroundColor: status == 'rejected' || status == 'cancelled'
                            ? Colors.red.shade700
                            : (status == 'accepted' ? Colors.blue.shade700 : AppColors.secondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Craft: ${_activeOrder.craftName}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  Text('Quantity: ${_activeOrder.quantity} • Total: ${_activeOrder.price}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const Divider(height: 20, color: AppColors.border),
                  const Text('Carrier: India Post Artisan Express', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  Text('Tracking ID: IP-${_activeOrder.orderId.replaceAll('-', '')}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Delivery Address: ${_activeOrder.buyerLocation}',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Proceed to Payment Action Banner if Accepted
            if (status == 'accepted') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3B82F6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF2563EB), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Order Accepted by Artisan!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E40AF)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'The master artisan has reviewed and accepted your custom craft request. Please complete payment to start dispatch.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF1E3A8A)),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: _isPaying ? null : _handlePayment,
                        icon: _isPaying
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.payment_rounded, color: Colors.white, size: 18),
                        label: Text(_isPaying ? 'Processing Payment...' : 'Proceed to Payment (${_activeOrder.price})', style: const TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Live Delivery Tracker Timeline',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            _timelineStep('Order Request Sent', 'Order request registered in Supabase DB', true),
            _timelineStep('Artisan Order Approval', 'Master artisan accepted craft request', isAccepted),
            _timelineStep('Payment Verified & Processing', 'Payment confirmed, artisan packing item', isPaidOrProcessing),
            _timelineStep('Handcrafted & Packed', 'Craft wrapped in eco packaging with GI seal', isPacked),
            _timelineStep('Dispatched via Craft Express', 'In transit via India Post GI Courier', isShipped),
            _timelineStep('Delivered to Destination', 'Handed over directly to buyer', isDelivered),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push(
                    '/artisan-chat',
                    extra: ArtisanChatArgs(
                      artisanId: 'artisan_v1',
                      name: 'Master Artisan Studio',
                      avatar: 'assets/images/crafts/bandhani_01.jpg',
                      craft: _activeOrder.craftName,
                      location: _activeOrder.buyerLocation,
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Contact Artisan directly'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timelineStep(String title, String subtitle, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isCompleted ? const Color(0xFF166534) : AppColors.border,
            child: Icon(isCompleted ? Icons.check : Icons.circle, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isCompleted ? AppColors.textPrimary : AppColors.textLight,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
