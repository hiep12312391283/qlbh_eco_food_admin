import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/users/controller/user_controller.dart';
import 'package:qlbh_eco_food_admin/features/users/model/user_model.dart';

class UserDetailPage extends StatefulWidget {
  final UserModel userModel;

  UserDetailPage({required this.userModel});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  final UserController controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with user data
    nameController = TextEditingController(text: widget.userModel.name);
    phoneController = TextEditingController(text: widget.userModel.phone);
    addressController = TextEditingController(text: widget.userModel.address);
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.green.shade400),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title,
      String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTextStyle.font24Semi.copyWith(color: Colors.black87),
          ),
          content: Text(
            content,
            style: AppTextStyle.font18Re.copyWith(color: Colors.black54),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Không',
                style: AppTextStyle.font18Re
                    .copyWith(color: AppColors.green.shade300),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Có',
                style: AppTextStyle.font18Re.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Thông tin người dùng',
            style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.green.shade400,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Họ và tên',
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              TextField(
                controller: nameController,
                decoration: _buildInputDecoration(),
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 10),
              Text(
                'Email',
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  widget.userModel.email,
                  style: AppTextStyle.font18Re
                      .copyWith(color: Colors.grey.shade700),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Số điện thoại',
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              TextField(
                controller: phoneController,
                decoration: _buildInputDecoration(),
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 10),
              Text(
                'Địa chỉ giao hàng',
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              TextField(
                controller: addressController,
                decoration: _buildInputDecoration(),
                style:
                    AppTextStyle.font18Re.copyWith(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(
                      context,
                      'Xác nhận cập nhật',
                      'Bạn có chắc chắn muốn cập nhật thông tin người dùng?',
                      () {
                        controller.updateUser(
                          widget.userModel.id,
                          nameController.text,
                          widget.userModel.email,
                          phoneController.text,
                          addressController.text,
                        );
                        Get.back(); // Quay lại màn hình trước
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: AppColors.green.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(
                      context,
                      'Xác nhận xóa',
                      'Bạn có chắc chắn muốn xóa người dùng này?',
                      () {
                        controller.deleteUser(widget.userModel.id);
                        Get.back(); // Quay lại màn hình trước
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    backgroundColor: AppColors.green.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Xóa',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
