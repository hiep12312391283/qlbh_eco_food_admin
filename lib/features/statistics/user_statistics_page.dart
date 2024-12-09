import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlbh_eco_food_admin/features/users/controller/user_controller.dart';

class UserStatisticsPage extends StatelessWidget {
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Thống Kê Khách Hàng'),
        backgroundColor: Colors.green.shade400,
      ),
      body: Obx(() {
        final totalAccounts = controller.accounts.length; // Tổng số tài khoản
        final accounts = controller.accounts;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị tổng số tài khoản khách hàng
              Text(
                'Tổng số tài khoản khách hàng: $totalAccounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Hiển thị danh sách tài khoản (email và role)
              Text(
                'Danh sách tài khoản khách hàng:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(
                          account.email,
                          style: TextStyle(fontSize: 16),
                        ),
                        // subtitle: Text(
                        //   'Role: ${account.role}',
                        //   style: TextStyle(fontSize: 14, color: Colors.grey),
                        // ),
                        trailing: Icon(Icons.person),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
