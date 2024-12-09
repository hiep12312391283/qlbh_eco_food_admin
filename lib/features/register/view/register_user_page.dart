import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/register/controller/register_controller.dart';

class RegisterUserPage extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Đăng ký khách hàng mới',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Các trường nhập liệu
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    txtFormField(
                        text: "Họ và tên",
                        controller: controller.nameController),
                    txtFormField(
                        text: "Email", controller: controller.emailController),
                    txtFormField(
                        text: "Số điện thoại",
                        controller: controller.phoneController),
                    txtFormField(
                        text: "Địa chỉ giao hàng",
                        controller: controller.addressController),
                    txtFormField(
                        text: "Mật khẩu",
                        controller: controller.passwordController),
                    txtFormField(
                        text: "Xác nhận mật khẩu",
                        controller: controller.confirmPasswordController),
                  ],
                ),
              ),
            ),

            // Nút Đăng ký sẽ luôn nằm dưới cùng
            GestureDetector(
              onTap: () {
                controller.validateAndAddUser(context);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.green.shade400,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Đăng ký',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget txtFormField({
  TextEditingController? controller,
  required String text,
}) {
  return Column(
    children: [
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  ).paddingSymmetric(vertical: 4);
}
