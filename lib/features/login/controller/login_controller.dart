import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var validateMode = AutovalidateMode.disabled.obs;
  var isObscure = true.obs;
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void toggleEyeIcon() {
    isObscure.value = !isObscure.value;
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    final authService = AuthService();

    // Bắt đầu quá trình đăng nhập, hiển thị loading
    isLoading.value = true;

    try {
      // Xác thực tài khoản người dùng
      User? user = await authService.signInWithEmailPassword(email, password);

      // Kiểm tra xem người dùng đã xác thực email chưa
      if (user != null && user.emailVerified) {
        // Lấy thông tin tài khoản từ Firestore
        DocumentSnapshot accountDoc = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(user.uid)
            .get();

        // Kiểm tra xem có dữ liệu từ Firestore hay không
        if (accountDoc.exists) {
          Map<String, dynamic> accountData =
              accountDoc.data()! as Map<String, dynamic>;
          String role = accountData['role'] ?? 'user';

          // In ra id và role tài khoản (cho mục đích debug)
          print('User ID: ${user.uid}');
          print('Role: $role');

          // Phân quyền dựa trên vai trò của tài khoản
          if (role == 'admin') {
            Get.offAllNamed('/admin_dashboard');
          } else if (role == 'employee') {
            Get.offAllNamed('/employee_dashboard');
          } else {
            Get.offAllNamed('/home_page');
          }

          // Sau khi lấy dữ liệu xong, ẩn loading
          isLoading.value = false;
        } else {
          // Xử lý khi không tìm thấy tài khoản trong Firestore
          isLoading.value = false;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Không tìm thấy dữ liệu tài khoản"),
              content: Text("Không thể tải thông tin tài khoản từ Firestore."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Nếu email chưa xác thực
        isLoading.value = false;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Email chưa được xác thực"),
            content: Text(
                "Vui lòng kiểm tra email của bạn để xác thực tài khoản trước khi đăng nhập."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Xử lý lỗi và ẩn loading
      isLoading.value = false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Đăng nhập thất bại",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            "Email hoặc mật khẩu không đúng",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppColors.green),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    }
  }
}
