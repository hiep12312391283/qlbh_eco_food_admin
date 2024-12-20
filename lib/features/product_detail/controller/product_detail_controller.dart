import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qlbh_eco_food_admin/features/product/controller/product_controller.dart';
import 'package:qlbh_eco_food_admin/features/product/model/product_model.dart';
import 'package:qlbh_eco_food_admin/features/product_detail/models/comment.dart';
import 'package:qlbh_eco_food_admin/features/users/model/user_model.dart';
class ProductDetailController extends GetxController {
  late Product product;
  var comments = <Comment>[].obs;
  var isLoadingComments = true.obs;
  var userMap = <String, UserModel>{}.obs; // Keyed by userId
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late TextEditingController stockController;
  late TextEditingController expiryDateController;
  late TextEditingController commentController;

  @override
  void onInit() {
    super.onInit();
    commentController = TextEditingController();

    // Lấy sản phẩm từ Get.arguments
    if (Get.arguments != null && Get.arguments is Product) {
      product = Get.arguments as Product;
      print("--${product.id}");
      print("--${product.documentId}");
      // Khởi tạo các controller
      nameController = TextEditingController(text: product.name);
      categoryController = TextEditingController(text: product.categoryId);
      priceController = TextEditingController(text: product.price.toString());
      descriptionController = TextEditingController(text: product.description);
      stockController = TextEditingController(text: product.stock.toString());
      expiryDateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(product.expiryDate),
      );

      // Tải bình luận từ Firestore
      loadComments(product.documentId!); // Sử dụng documentId của sản phẩm
    } else {
      Get.snackbar('Lỗi', 'Không có dữ liệu sản phẩm để chỉnh sửa.');
    }
  }

  void loadComments(String documentId) async {
    try {
      isLoadingComments.value = true;

      // Fetch comments first
      QuerySnapshot snapshot = await _firestore
          .collection('comments')
          .where('productId', isEqualTo: documentId)
          .orderBy('createdAt', descending: true)
          .get();

      comments.clear(); // Clear previous comments

      // Iterate over each comment
      for (var doc in snapshot.docs) {
        var createdAt = doc['createdAt'];
        DateTime createdAtDateTime =
            (createdAt is Timestamp) ? createdAt.toDate() : DateTime.now();

        final comment = Comment(
          id: doc.id,
          userName: doc['userName'] ?? '',
          content: doc['content'] ?? '',
          productId: doc['productId'] ?? '',
          userId: doc['userId'] ?? '',
          createdAt: createdAtDateTime,
        );

        comments.add(comment);

        // Fetch user details if not already fetched
        final userId = comment.userId;
        if (!userMap.containsKey(userId)) {
          await _fetchUserDetails(userId); // Fetch user if not already fetched
        }
      }

      isLoadingComments.value = false;
    } catch (e) {
      isLoadingComments.value = false;
      Get.snackbar('Lỗi', 'Không thể tải bình luận: $e');
    }
  }

  // Function to fetch user details based on userId
  Future<void> _fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        UserModel user = UserModel.fromFirestore(userDoc);
        userMap[userId] = user; // Store the user data in the map
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  // Thêm bình luận mới
  void addComment() {
    if (commentController.text.isNotEmpty) {
      // Kiểm tra xem sản phẩm có documentId hay không
      if (product.documentId != null && product.documentId!.isNotEmpty) {
        final newComment = Comment(
          id: '', // Firestore sẽ tự động tạo id
          userName: 'Admin', // Thay bằng tên người dùng thực tế
          content: commentController.text,
          productId: product.documentId!, // Sử dụng documentId của sản phẩm
          userId: 'userId', // Thay bằng ID người dùng thực tế
          createdAt: DateTime.now(),
        );

        FirebaseFirestore.instance
            .collection('comments')
            .add(newComment.toJson())
            .then((docRef) {
          newComment.id = docRef.id;
          comments.add(newComment); // Thêm bình luận vào danh sách
          commentController.clear(); // Xóa nội dung sau khi thêm bình luận
        }).catchError((e) {
          print("Lỗi khi thêm bình luận vào Firestore: $e");
        });
      } else {
        print("Không có documentId cho sản phẩm");
      }
    } else {
      print("Bình luận rỗng");
    }
  }

  // Cập nhật thông tin sản phẩm
  void updateProduct() async {
    try {
      String documentId = product.documentId?.trim() ?? '';
      if (documentId.isEmpty) {
        Get.snackbar('Lỗi', 'Không thể xác định sản phẩm để chỉnh sửa.');
        return;
      }

      DateTime expiryDate;
      try {
        expiryDate =
            DateFormat('yyyy-MM-dd').parse(expiryDateController.text.trim());
      } catch (e) {
        Get.snackbar('Lỗi', 'Ngày hết hạn không hợp lệ.');
        return;
      }

      final updatedProductData = {
        'name': nameController.text.trim(),
        'category': categoryController.text.trim(),
        'price': double.tryParse(priceController.text.trim()) ?? product.price,
        'description': descriptionController.text.trim(),
        'stock': int.tryParse(stockController.text.trim()) ?? product.stock,
        'expiryDate': Timestamp.fromDate(expiryDate),
        'imageBase64': product.imageBase64,
      };

      await FirebaseFirestore.instance
          .collection('products')
          .doc(documentId)
          .update(updatedProductData);

      final updatedProduct = Product(
        id: product.id,
        name: updatedProductData['name'] as String,
        categoryId: updatedProductData['category'] as String,
        price: updatedProductData['price'] as double,
        description: updatedProductData['description'] as String,
        stock: updatedProductData['stock'] as int,
        expiryDate: expiryDate,
        imageBase64: updatedProductData['imageBase64'] as String,
        documentId: documentId,
      );

      Get.find<ProductController>()
          .updateProductLocally(documentId, updatedProduct);

      Get.back();
      Get.snackbar('Thành công', 'Sản phẩm đã được cập nhật thành công!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể cập nhật sản phẩm: $e');
    }
  }
}
