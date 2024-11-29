import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/customer/controller/customer_controller.dart';
import 'customer_detail_page.dart'; // Import trang chi tiết khách hàng
import 'package:qlbh_eco_food_admin/features/register/view/register_customer_page.dart'; // Import trang đăng ký khách hàng

class CustomerPage extends GetView<CustomerController> {
  final CustomerController controller = Get.put(CustomerController());
  CustomerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Danh sách khách hàng',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Điều hướng đến trang đăng ký tài khoản khách hàng mới
              Get.to(() => RegisterCustomerPage());
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.green.shade100, AppColors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.customers.isEmpty) {
            return Center(
                child: Text('Không có khách hàng',
                    style: TextStyle(fontSize: 18.0)));
          }
          return ListView.builder(
            itemCount: controller.customers.length,
            itemBuilder: (context, index) {
              final customer = controller.customers[index];
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(customer.name[0],
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(customer.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () =>
                      Get.to(() => CustomerDetailPage(customer: customer)),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
