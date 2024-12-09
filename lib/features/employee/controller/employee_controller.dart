import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/features/register/model/account_model.dart';
import 'package:qlbh_eco_food_admin/features/register_employee/models/employee_model.dart';

class EmployeeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var employees = <EmployeeModel>[].obs;
  var accounts = <AccountModel>[].obs;
  var isLoading = false.obs;
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    listenToEmployees();
    listenToAccounts();
  }

  void listenToEmployees() {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance.collection('employees').snapshots().listen(
          (querySnapshot) {
        final List<EmployeeModel> loadedEmployees =
            querySnapshot.docs.map((doc) {
          final data = doc.data();
          return EmployeeModel(
            id: doc.id,
            name: data['name'] ?? '',
            phone: data['phone'] ?? '',
            email: data['email'] ?? '',
            documentId: doc.id,
          );
        }).toList();

        employees.value = loadedEmployees; // Cập nhật danh sách nhân viên
      }, onError: (e) {
        print("Error listening to employees: $e");
      });
    } catch (e) {
      print("Error initializing employee listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  void listenToAccounts() {
    try {
      isLoading.value = true;

      FirebaseFirestore.instance.collection('accounts').snapshots().listen(
          (querySnapshot) {
        final List<AccountModel> loadedAccounts = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return AccountModel(
            accountId: doc.id,
            email: data['email'] ?? '',
            password: data['password'] ?? '',
            role: data['role'] ?? 'user',
          );
        }).toList();

        accounts.value = loadedAccounts; // Cập nhật danh sách tài khoản
      }, onError: (e) {
        print("Error listening to accounts: $e");
      });
    } catch (e) {
      print("Error initializing account listener: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  void updateEmployee(String id, String name, String email, String phone) {
    try {
      _firestore.collection('employees').doc(id).update({
        'name': name,
        'email': email,
        'phone': phone,
      }).then((_) {
        print("Employee updated successfully");
      }).catchError((error) {
        print("Error updating employee: $error");
      });
    } catch (e) {
      print("Error updating employee: $e");
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

  void deleteEmployee(String id) async {
    try {
      isLoading.value = true;

      // Xóa thông tin nhân viên trong Firestore
      await _firestore.collection('employees').doc(id).delete();
      print("Employee deleted successfully from Firestore.");

      // Xóa thông tin tài khoản liên quan trong Firestore
      await _firestore.collection('accounts').doc(id).delete();
      print("Account deleted successfully from Firestore.");

      // Nếu là người dùng hiện tại, xóa tài khoản Firebase Authentication
      if (_firestore.collection('employees').doc(id).id ==
          _authService.auth.currentUser?.uid) {
        await _authService.deleteAccount();
      }

      // Cập nhật lại danh sách nhân viên sau khi xóa
      employees.removeWhere((employee) => employee.id == id);
      accounts.removeWhere((account) => account.accountId == id);
    } catch (e) {
      print("Error deleting employee: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
