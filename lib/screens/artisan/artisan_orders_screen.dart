import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../features/chat/models/chat_message_model.dart';
import '../../providers/artisan_hub_provider.dart';

class ArtisanOrdersScreen extends ConsumerWidget {
  const ArtisanOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(artisanOrdersProvider);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
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
                context.go('/artisan-dashboard');
              }
            },
          ),
          title: const Text(
            'Artisan Orders',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLight,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Accepted'),
              Tab(text: 'Packed'),
              Tab(text: 'Shipped'),
              Tab(text: 'Delivered'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersTab(context, ref, orders, 'Pending'),
            _buildOrdersTab(context, ref, orders, 'Accepted'),
            _buildOrdersTab(context, ref, orders, 'Packed'),
            _buildOrdersTab(context, ref, orders, 'Shipped'),
            _buildOrdersTab(context, ref, orders, 'Delivered'),
            _buildOrdersTab(context, ref, orders, 'Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTab(BuildContext context, WidgetRef ref, List<ArtisanOrder> allOrders, String statusFilter) {
    final filtered = allOrders.where((o) => o.status.toLowerCase() == statusFilter.toLowerCase()).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_outlined, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              'No $statusFilter Orders',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, idx) {
        final order = filtered[idx];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.orderId,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                  ),
                  Text(
                    order.date,
                    style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
              const Divider(height: 20, color: AppColors.border),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      order.buyerName.isNotEmpty ? order.buyerName[0] : 'B',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.buyerName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        Text(
                          order.buyerLocation,
                          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.craftName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Qty: ${order.quantity}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      order.price,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Builder(
                builder: (context) {
                  final statusLower = order.status.toLowerCase();
                  return Column(
                    children: [
                      if (statusLower == 'pending') ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ref.read(artisanOrdersProvider.notifier).acceptOrder(order.orderId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Order ${order.orderId} Accepted! Order Confirmed.')),
                                  );
                                },
                                icon: const Icon(Icons.check_circle_rounded, size: 16),
                                label: const Text('Accept Order', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF166534),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ref.read(artisanOrdersProvider.notifier).rejectOrder(order.orderId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Order ${order.orderId} Rejected/Cancelled')),
                                  );
                                },
                                icon: const Icon(Icons.cancel_rounded, size: 16, color: Colors.redAccent),
                                label: const Text('Reject Order', style: TextStyle(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ] else if (statusLower == 'accepted') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref.read(artisanOrdersProvider.notifier).updateOrderStatus(order.orderId, 'Packed');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order ${order.orderId} marked as Packed')),
                              );
                            },
                            icon: const Icon(Icons.inventory_2_outlined, size: 16),
                            label: const Text('Mark as Packed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ] else if (statusLower == 'packed') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref.read(artisanOrdersProvider.notifier).updateOrderStatus(order.orderId, 'Shipped');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order ${order.orderId} marked as Shipped')),
                              );
                            },
                            icon: const Icon(Icons.local_shipping_outlined, size: 16),
                            label: const Text('Mark as Shipped', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ] else if (statusLower == 'shipped') ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ref.read(artisanOrdersProvider.notifier).updateOrderStatus(order.orderId, 'Delivered');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order ${order.orderId} marked as Delivered')),
                              );
                            },
                            icon: const Icon(Icons.verified_outlined, size: 16),
                            label: const Text('Mark as Delivered', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF166534),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.push(
                                  '/artisan-chat',
                                  extra: ArtisanChatArgs(
                                    artisanId: 'artisan_v1',
                                    name: order.buyerName,
                                    avatar: 'assets/images/crafts/bandhani_01.jpg',
                                    craft: order.craftName,
                                    location: order.buyerLocation,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14, color: AppColors.primary),
                              label: const Text('Contact Buyer', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              _showOrderDetailsSheet(context, order);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            ),
                            child: const Text('Details', style: TextStyle(fontSize: 11, color: AppColors.textPrimary)),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderDetailsSheet(BuildContext context, ArtisanOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ${order.orderId}', style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold)),
                  Chip(label: Text(order.status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 16),
              Text('Buyer: ${order.buyerName}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('Address: ${order.buyerLocation}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Divider(height: 24),
              Text('Item: ${order.craftName} (Qty: ${order.quantity})', style: const TextStyle(fontSize: 13)),
              Text('Total Payout: ${order.price}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
