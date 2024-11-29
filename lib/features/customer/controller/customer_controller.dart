import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/features/customer/model/customer_model.dart';

class CustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var customers = <Customer>[].obs;
  var isLoading = false.obs;
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    listenToCustomers();
  }

  void listenToCustomers() {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance.collection('users').snapshots().listen(
          (querySnapshot) {
        final List<Customer> loadedCustomers = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return Customer(
            id: doc.id,
            name: data['name'] ?? '',
            phone: data['phone'] ?? '',
            address: data['address'] ?? '',
            email: data['email'] ?? '',
          );
        }).toList();

        customers.value = loadedCustomers; // Cập nhật danh sách khách hàng
      }, onError: (e) {
        print("Error listening to customers: $e");
      });
    } catch (e) {
      print("Error initializing customer listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  void updateCustomer(
      String id, String name, String email, String phone, String address) {
    try {
      _firestore.collection('users').doc(id).update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      }).then((_) {
        print("Customer updated successfully");
      }).catchError((error) {
        print("Error updating customer: $error");
      });
    } catch (e) {
      print("Error updating customer: $e");
    }
  }


  void deleteCustomer(String id) async {
    try {
      isLoading.value = true;

      // Xóa thông tin khách hàng trong Firestore
      await _firestore.collection('users').doc(id).delete();
      print("Customer deleted successfully from Firestore.");

      // Nếu là người dùng hiện tại, xóa tài khoản Firebase Authentication
      if (_firestore.collection('users').doc(id).id ==
          _authService.auth.currentUser?.uid) {
        await _authService.deleteAccount();
      }

      // Cập nhật lại danh sách khách hàng sau khi xóa
      customers.removeWhere((customer) => customer.id == id);
    } catch (e) {
      print("Error deleting customer: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
