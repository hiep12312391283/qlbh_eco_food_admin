import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/order/model/order_admin.dart';
import 'package:qlbh_eco_food_admin/features/order/view/notification_new_order.dart';
import 'package:qlbh_eco_food_admin/features/order/view/order_detail_page.dart';

class OrderController extends GetxController {
  var orders = <OrderAdmin>[].obs;
  var isLoading = false.obs;

  int get totalOrders {
    return orders.length;
  }

  int get processingOrders {
    return orders
        .where((order) =>
            order.orderStatus == 0 ||
            order.orderStatus == 1 ||
            order.orderStatus == 2)
        .length;
  }

  int get completedOrders {
    return orders.where((order) => order.orderStatus == 3).length;
  }

  @override
  void onInit() {
    super.onInit();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title!,
          message.notification!.body!,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 5),
        );
      }
    });
    listenToOrders();
  }

  void listenToOrders() {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance.collection('orders').snapshots().listen(
        (querySnapshot) {
          final List<OrderAdmin> loadedOrders = querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return OrderAdmin(
              userId: doc.id,
              userName: data['userName'],
              userPhone: data['userPhone'],
              userAddress: data['userAddress'],
              orderDate: data['orderDate'] is Timestamp
                  ? (data['orderDate'] as Timestamp).toDate()
                  : DateTime.parse(data['orderDate']),
              products: (data['products'] as List)
                  .map((item) => OrderItemAdmin(
                        productId: item['productId'],
                        productName: item['productName'],
                        quantity: int.parse(item['quantity'].toString()),
                        price: double.parse(item['price'].toString()),
                        imageBase64: item['imageBase64'] ?? '',
                      ))
                  .toList(),
              totalPrice: double.parse(data['totalPrice'].toString()),
              paymentMethod: int.parse(data['paymentMethod'].toString()),
              orderStatus: data['orderStatus'] ?? 0,
            );
          }).toList();

          // Kiểm tra và hiển thị các đơn hàng mới
          if (orders.isNotEmpty) {
            final newOrders = loadedOrders.where((newOrder) {
              return !orders.any((order) => order.userId == newOrder.userId);
            }).toList();

            for (var newOrder in newOrders) {
              Get.dialog(
                NewOrderNotification(
                  order: newOrder,
                  onTap: () {
                    Get.back();
                    Get.to(() => OrderDetailPage(order: newOrder));
                  },
                ),
              );
            }
          }

          orders.value = loadedOrders;
        },
        onError: (e) {
          print("Lỗi khi lắng nghe đơn hàng: $e");
        },
      );
    } catch (e) {
      print("Lỗi khi khởi tạo bộ lắng nghe đơn hàng: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm cập nhật số lượng sản phẩm trong kho
  Future<void> updateProductStock(OrderAdmin order) async {
    try {
      for (var orderItem in order.products) {
        // Lấy sản phẩm từ Firestore
        DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(orderItem.productId)
            .get();

        if (productSnapshot.exists) {
          var productData = productSnapshot.data() as Map<String, dynamic>;

          int currentStock = productData['stock'] ?? 0;
          int newStock = currentStock - orderItem.quantity;

          // Cập nhật lại số lượng sản phẩm trong Firestore
          await FirebaseFirestore.instance
              .collection('products')
              .doc(orderItem.productId)
              .update({
            'stock': newStock,
          });

          print('Updated stock for ${orderItem.productName}: $newStock');
        }
      }
    } catch (e) {
      print("Lỗi khi cập nhật số lượng sản phẩm: $e");
    }
  }

  // Cập nhật trạng thái đơn hàng và gọi hàm updateProductStock
  void updateOrderStatus(OrderAdmin order, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.userId)
          .update({
        'orderStatus': newStatus,
      });
      order.orderStatus = newStatus;

      if (newStatus == 3) {
        // Nếu đơn hàng hoàn thành, cập nhật số lượng sản phẩm
        await updateProductStock(order);
      }

      orders.refresh();
      print("Order status updated successfully");
    } catch (e) {
      print("Error updating order status: $e");
    }
  }
}
