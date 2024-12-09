import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/base/const/app_text_style.dart';
import 'package:qlbh_eco_food_admin/base/const/colors.dart';
import 'package:qlbh_eco_food_admin/features/employee/controller/employee_controller.dart';
import 'package:qlbh_eco_food_admin/features/register_employee/view/register_employee_page.dart';
import 'employee_detail_page.dart'; // Import trang chi tiết nhân viên

class EmployeePage extends GetView<EmployeeController> {
  final EmployeeController controller = Get.put(EmployeeController());
  EmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Danh sách nhân viên',
          style: AppTextStyle.font24Semi.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.green.shade400,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // Điều hướng đến trang đăng ký tài khoản nhân viên mới
              Get.to(() => RegisterEmployeePage());
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
          if (controller.employees.isEmpty) {
            return Center(
                child: Text('Không có nhân viên',
                    style: TextStyle(fontSize: 18.0)));
          }
          return ListView.builder(
            itemCount: controller.employees.length,
            itemBuilder: (context, index) {
              final employee = controller.employees[index];

              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(employee.name[0],
                        style: TextStyle(color: Colors.white)),
                  ),
                  title: Text(employee.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Email: ${employee.email}\nPhone: ${employee.phone}'),
                  onTap: () =>
                      Get.to(() => EmployeeDetailPage(employeeModel: employee)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      controller.deleteEmployee(employee.id);
                    },
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
