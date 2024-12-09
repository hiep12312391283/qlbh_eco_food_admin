import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/features/register/model/account_model.dart';
import 'package:qlbh_eco_food_admin/features/users/model/user_model.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var users = <UserModel>[].obs;
  var accounts = <AccountModel>[].obs;
  var isLoading = false.obs;
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    listenToUsers();
    listenToAccounts();
  }

  void listenToUsers() {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance.collection('users').snapshots().listen(
          (querySnapshot) {
        final List<UserModel> loadedUser = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return UserModel(
            id: doc.id,
            name: data['name'] ?? '',
            phone: data['phone'] ?? '',
            address: data['address'] ?? '',
            email: data['email'] ?? '',
          );
        }).toList();

        users.value = loadedUser; // Cập nhật danh sách người dùng
      }, onError: (e) {
        print("Error listening to users: $e");
      });
    } catch (e) {
      print("Error initializing user listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  void listenToAccounts() {
    try {
      isLoading.value = true;

      // Lọc các tài khoản có role = "user"
      FirebaseFirestore.instance
          .collection('accounts')
          .where('role', isEqualTo: 'user') // Điều kiện lọc role = "user"
          .snapshots()
          .listen(
        (querySnapshot) {
          final List<AccountModel> loadedAccounts =
              querySnapshot.docs.map((doc) {
            final data = doc.data();
            return AccountModel(
              accountId: doc.id,
              email: data['email'] ?? '',
              password: data['password'] ?? '',
              role: data['role'] ?? 'user', // Default role is 'user'
            );
          }).toList();

          accounts.value = loadedAccounts; // Cập nhật danh sách tài khoản
        },
        onError: (e) {
          print("Error listening to accounts: $e");
        },
      );
    } catch (e) {
      print("Error initializing account listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }



  void updateUser(
      String id, String name, String email, String phone, String address) {
    try {
      _firestore.collection('users').doc(id).update({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      }).then((_) {
        print("User updated successfully");
      }).catchError((error) {
        print("Error updating user: $error");
      });
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  void updateAccount(String id, String email, String password, String role) {
    try {
      _firestore.collection('accounts').doc(id).update({
        'email': email,
        'password': password,
        'role': role,
      }).then((_) {
        print("Account updated successfully");
      }).catchError((error) {
        print("Error updating account: $error");
      });
    } catch (e) {
      print("Error updating account: $e");
    }
  }

  void deleteUser(String id) async {
    try {
      isLoading.value = true;

      // Xóa thông tin người dùng trong Firestore
      await _firestore.collection('users').doc(id).delete();
      print("User deleted successfully from Firestore.");

      // Xóa thông tin tài khoản liên quan trong Firestore
      await _firestore.collection('accounts').doc(id).delete();
      print("Account deleted successfully from Firestore.");

      // Nếu là người dùng hiện tại, xóa tài khoản Firebase Authentication
      if (_firestore.collection('users').doc(id).id ==
          _authService.auth.currentUser?.uid) {
        await _authService.deleteAccount();
      }

      // Cập nhật lại danh sách người dùng sau khi xóa
      users.removeWhere((user) => user.id == id);
      accounts.removeWhere((account) => account.accountId == id);
    } catch (e) {
      print("Error deleting user: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
