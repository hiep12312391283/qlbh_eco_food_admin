import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import thư viện để định dạng tiền tệ
import 'package:qlbh_eco_food_admin/features/order/model/order_admin.dart';

class NewOrderNotification extends StatelessWidget {
  final OrderAdmin order;
  final VoidCallback onTap;

  NewOrderNotification({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Đơn hàng mới'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên người dùng: ${order.userName}'),
            Text(
                'Tổng tiền: ${_formatCurrency(order.totalPrice)}'), // Định dạng tiền tệ
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onTap,
          child: Text('Xem chi tiết'),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    final formatCurrency =
        NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');
    return formatCurrency.format(amount);
  }
}
