import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qlbh_eco_food_admin/features/register_employee/models/employee_model.dart';

class ProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;


  var isLoading = false.obs; // Trạng thái loading
  late EmployeeModel employee; // Thông tin nhân viên

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();

    loadEmployeeData(); // Tải thông tin nhân viên khi controller được khởi tạo
  }

  // Hàm tải dữ liệu nhân viên từ Firestore
  Future<void> loadEmployeeData() async {
    isLoading.value = true;
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Lấy thông tin nhân viên từ Firestore
      DocumentSnapshot employeeSnapshot = await FirebaseFirestore.instance
          .collection('employees')
          .doc(userId)
          .get();

      if (employeeSnapshot.exists) {
        employee = EmployeeModel.fromFirestore(employeeSnapshot);

        // Cập nhật thông tin vào các TextEditingController
        nameController.text = employee.name;
        phoneController.text = employee.phone;
        // Bạn có thể thay số điện thoại bằng một trường địa chỉ thực tế nếu cần
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải thông tin nhân viên: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Hàm cập nhật thông tin nhân viên
  Future<void> updateEmployee() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng điền đầy đủ thông tin.");
      return;
    }

    try {
      isLoading.value = true;

      // Cập nhật thông tin nhân viên lên Firestore (không cập nhật address vì không có trường address trong model)
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.id)
          .update({
        'name': nameController.text,
        'phone': phoneController.text,
      });

      Get.snackbar(
          "Cập nhật thành công", "Thông tin nhân viên đã được cập nhật!");
    } catch (e) {
      Get.snackbar("Lỗi", "Có lỗi xảy ra khi cập nhật thông tin: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();

    super.onClose();
  }
}
