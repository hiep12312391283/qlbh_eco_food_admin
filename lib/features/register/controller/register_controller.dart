import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/auth/auth_service.dart';
import 'package:qlbh_eco_food_admin/features/register/model/account_model.dart';
import 'package:qlbh_eco_food_admin/features/users/model/user_model.dart';
import 'package:qlbh_eco_food_admin/features/home_page/home_page_view.dart';

class RegisterController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  var users = <UserModel>[].obs;
  // final formKey = GlobalKey<FormState>();

  final isLoading = false.obs; // Trạng thái loading
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phương thức để đăng ký và thêm người dùng và tài khoản vào Firestore
  Future<void> validateAndAddUser(BuildContext context) async {
    print("Bắt đầu validateAndAddUser");

    if (passwordController.text == confirmPasswordController.text) {
      try {
        print("Bắt đầu đăng ký tài khoản");
        final authService = AuthService();

        // Đăng ký tài khoản với email và password
        await authService.signUpWithEmailPassword(
            emailController.text, passwordController.text);
        print("Đăng ký thành công với email: ${emailController.text}");

        // Gửi email xác nhận
        FirebaseAuth.instance.currentUser?.sendEmailVerification();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Xác nhận email"),
            content: Text(
                "Một email xác nhận đã được gửi tới ${emailController.text}. Vui lòng kiểm tra hộp thư của bạn để xác nhận."),
            actions: [
              TextButton(
                onPressed: () async {
                  Get.off(() => HomePageView());
                  await _checkEmailVerificationStatus(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      } catch (e) {
        print("Lỗi khi đăng ký: $e");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Đăng ký thất bại"),
            content: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Mật khẩu không giống nhau"),
        ),
      );
    }
  }

// Kiểm tra xem email đã được xác thực hay chưa
  Future<void> _checkEmailVerificationStatus(BuildContext context) async {
    bool emailVerified = false;

    while (!emailVerified) {
      await FirebaseAuth.instance.currentUser?.reload();
      emailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      if (emailVerified) {
        UserModel user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          email: emailController.text,
          phone: phoneController.text,
          name: nameController.text,
          address: addressController.text,
        );

        AccountModel account = AccountModel(
          accountId: FirebaseAuth.instance.currentUser!.uid,
          email: emailController.text,
          password: passwordController.text,
          role: 'user', // Vai trò mặc định là 'user'
        );

        addUser(user); // Thêm người dùng vào Firestore
        addAccount(account); // Thêm tài khoản vào Firestore
        print("Lưu thông tin người dùng và tài khoản thành công");
        Get.to(HomePageView());
        break;
      } else {
        print("Email chưa được xác thực, thử lại...");
        // Có thể thêm một khoảng delay (ví dụ 3 giây) để kiểm tra lại
        await Future.delayed(Duration(seconds: 3));
      }
    }
  }

// Thêm thông tin người dùng vào Firestore
  void addUser(UserModel user) {
    _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });
  }

  // Thêm thông tin tài khoản vào Firestore
  void addAccount(AccountModel account) {
    _firestore
        .collection('accounts')
        .doc(account.accountId)
        .set(account.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });
  }
}
