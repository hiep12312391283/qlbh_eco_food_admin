import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/product_model.dart';

class ProductController extends GetxController {
  // Các controller cho các trường đầu vào
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  final expiryDateController = TextEditingController();
  var isLoadingMore = false.obs; // Trạng thái loading khi cuộn
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  // Các biến RxString để quản lý giá trị của các trường
  final idError = ''.obs;
  final nameError = ''.obs;
  final categoryError = ''.obs;
  final priceError = ''.obs;
  final descriptionError = ''.obs;
  final stockError = ''.obs;

  final formKey = GlobalKey<FormState>();

  var products = <Product>[].obs;
  var selectedImagePath = ''.obs;
  final _image = Rx<File?>(null);
  final picker = ImagePicker();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final isLoading = false.obs; // Trạng thái loading

  // ScrollController để lắng nghe sự kiện cuộn
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchProducts();

    // Lắng nghe sự kiện cuộn
  }

  void addProduct(Product product) {
    products.add(product);
    _firestore.collection('products').add(product.toJson()).catchError((e) {
      print("Lỗi khi thêm vào Firestore: $e");
    });
    _database
        .ref()
        .child('products')
        .child(product.id)
        .set(product.toJson())
        .catchError((e) {
      print("Lỗi khi thêm vào Realtime Database: $e");
    });
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true; // Bắt đầu loading

      final querySnapshot = await _firestore.collection('products').get();
      final List<Product> loadedProducts = querySnapshot.docs.map((doc) {
        final data = doc.data() ?? {};
        return Product(
          id: data['id'] ?? '', // Default to empty string if null
          name: data['name'] ?? '',
          categoryId: data['categoryId'] ?? '',
          price: double.tryParse(data['price']?.toString() ?? '') ?? 0.0,
          description: data['description'] ?? '',
          stock: int.tryParse(data['stock']?.toString() ?? '') ?? 0,
          expiryDate: data['expiryDate'] is Timestamp
              ? (data['expiryDate'] as Timestamp).toDate()
              : DateTime.tryParse(data['expiryDate'] ?? '') ?? DateTime.now(),
          imageBase64: data['imageBase64'] ?? '',
          documentId: doc.id,
        );
      }).toList();

      products.addAll(loadedProducts); // Cập nhật danh sách sản phẩm
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false; // Kết thúc loading
    }
  }

  // Update a specific product
  void updateProductLocally(String documentId, Product updatedProduct) {
    final index = products.indexWhere((p) => p.documentId == documentId);
    if (index != -1) {
      products[index] = updatedProduct;
      products.refresh(); // Refresh the list to trigger UI update
    }
  }

  Future<void> deleteProduct(String documentId) async {
    try {
      // Xóa sản phẩm khỏi Firestore
      await _firestore.collection('products').doc(documentId).delete();

      // Xóa sản phẩm khỏi danh sách
      products.removeWhere((product) => product.documentId == documentId);

      Get.snackbar('Thành công', 'Sản phẩm đã được xóa thành công!');
    } catch (e) {
      Get.snackbar('Lỗi', 'Không thể xóa sản phẩm: $e');
      print('Lỗi khi xóa sản phẩm: $e');
    }
  }

  Future<void> checkAndRequestPermissions() async {
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
      selectedImagePath.value = pickedFile.path;
    } else {
      print("No image selected");
    }
  }

  String encodeImageToBase64(File image) {
    final bytes = image.readAsBytesSync();
    return base64Encode(bytes);
  }

  void clearInputs() {
    idController.clear();
    nameController.clear();
    categoryController.clear();
    priceController.clear();
    descriptionController.clear();
    stockController.clear();
    expiryDateController.clear();
    selectedImagePath.value = '';
  }

  void validateAndAddProduct() async {
    if (formKey.currentState!.validate()) {
      if (idController.text.isEmpty)
        idError.value = 'Mã sản phẩm không được để trống';
      if (nameController.text.isEmpty)
        nameError.value = 'Tên sản phẩm không được để trống';
      if (categoryController.text.isEmpty)
        categoryError.value = 'Loại sản phẩm không được để trống';
      if (priceController.text.isEmpty)
        priceError.value = 'Giá tiền không được để trống';
      if (descriptionController.text.isEmpty)
        descriptionError.value = 'Mô tả không được để trống';
      if (stockController.text.isEmpty)
        stockError.value = 'Số lượng không được để trống';

      DateTime expiryDate =
          DateFormat('dd/MM/yyyy').parse(expiryDateController.text);
      if (!expiryDate.isAfter(DateTime.now())) {
        Get.snackbar("Lỗi", "Ngày hết hạn phải sau ngày hôm nay",
            snackPosition: SnackPosition.BOTTOM);
      } else if (selectedImagePath.value.isEmpty) {
        Get.snackbar("Lỗi", "Ảnh phải được chọn",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        isLoading.value = true;
        try {
          String imageBase64 =
              encodeImageToBase64(File(selectedImagePath.value));
          addProduct(Product(
            id: idController.text,
            name: nameController.text,
            categoryId: categoryController.text,
            price: double.parse(priceController.text),
            description: descriptionController.text,
            stock: int.parse(stockController.text),

            expiryDate: expiryDate,
            imageBase64: imageBase64,
          ));
          clearInputs();
          Navigator.of(Get.context!).pop();
          Get.snackbar("Thành công",
              "Sản phẩm đã được thêm vào Firestore và Realtime Database",
              snackPosition: SnackPosition.BOTTOM);
        } catch (e) {
          Get.snackbar("Lỗi", "Không thể thêm sản phẩm: $e",
              snackPosition: SnackPosition.BOTTOM);
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    products.refresh();
  }
}
