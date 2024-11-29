import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/order/model/order_admin.dart';

class OrderController extends GetxController {
  var orders = <OrderAdmin>[].obs; // Danh sách các đơn hàng
  var isLoading = false.obs; // Trạng thái loading
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
      isLoading.value = true; // Bắt đầu loading

      FirebaseFirestore.instance.collection('orders').snapshots().listen((querySnapshot) {
        final List<OrderAdmin> loadedOrders = querySnapshot.docs.map((doc) {
          final data = doc.data();
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
                      imageBase64: item['imageBase64'] ?? '', // Lấy ảnh sản phẩm
                    ))
                .toList(),
            totalPrice: double.parse(data['totalPrice'].toString()),
            paymentMethod: int.parse(data['paymentMethod'].toString()),
            orderStatus: data['orderStatus'] ?? 0, // Lấy trạng thái đơn hàng
          );
        }).toList();

        orders.value = loadedOrders; // Cập nhật danh sách đơn hàng
      }, onError: (e) {
        print("Error listening to orders: $e");
      });
    } catch (e) {
      print("Error initializing order listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  void updateOrderStatus(OrderAdmin order, int newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(order.userId).update({
        'orderStatus': newStatus,
      });
      order.orderStatus = newStatus;
      orders.refresh();
      print("Order status updated successfully");
    } catch (e) {
      print("Error updating order status: $e");
    }
  }
  
}
