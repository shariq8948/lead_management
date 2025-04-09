import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:leads/data/models/product.dart';

import '../../data/api/api_client.dart';
import '../../data/models/apiResponse.dart';
import '../../data/models/categorymodel.dart';
import '../../data/models/dropdown_list.model.dart';
import '../../data/models/produc_detail_model.dart';
import '../../utils/api_endpoints.dart';
import '../../widgets/custom_select.dart';
import '../../widgets/custom_snckbar.dart';
import 'package:http/http.dart' as http;

class Productlistcontroller extends GetxController {
  final minPrice = 0.0.obs;
  final maxPrice = 0.0.obs;
  var isSaving = false.obs; // For showing saving status
  var isEdit = false.obs;
  var productDetails = <ProductDetailModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var bannerImageBase64 = RxString(""); // To store banner image base64
  var iconImageBase64 = RxString(""); // To store icon image base64

  final formKey = GlobalKey<FormState>();
  final categories = <String>[].obs;
  final gstRates = <String>[].obs;
  final selectedCategory = ''.obs;
  final selectedGst = ''.obs;
  final minAvailablePrice = 0.0.obs;
  final maxAvailablePrice = 10000.0.obs;
  final currentPriceRange = RangeValues(0.0, 10000.0).obs;
  final filteredProducts = <Products1>[].obs;
  final searchQuery = ''.obs;
  final hasActiveFilters = false.obs;
  final hasPriceFilter = false.obs;
  RxBool isFetching = false.obs;
  RxBool isAddingProduct = false.obs;
  Future<void> handleImageUpdate({
    required String currentImageUrl,
    String? newBase64Image,
  }) async {
    if (newBase64Image != null && newBase64Image.isNotEmpty) {
      // If new image is selected, use that
      bannerImageBase64.value = newBase64Image;
    } else if (currentImageUrl.isNotEmpty) {
      // If using existing image from server
      if (currentImageUrl.startsWith('data:image')) {
        // Already in base64 format
        bannerImageBase64.value = currentImageUrl;
      } else {
        // Convert URL to base64
        bannerImageBase64.value = await urlToBase64(currentImageUrl);
      }
    }
  }

  Future<void> initializeEditMode(String productId) async {
    try {
      isLoading.value = true;
      await fetchProductDetails(productId);

      if (productDetails.isEmpty) {
        throw Exception('No product details found');
      }

      final details = productDetails[0];

      // Handle Images
      if (details.imagepath != null && details.imagepath!.isNotEmpty) {
        String imageUrl = details.imagepath!.startsWith('http')
            ? details.imagepath!
            : "https://lead.mumbaicrm.com/${details.imagepath}";

        // Store URL for display
        bannerImageBase64.value = imageUrl;
      }

      if (details.appimagepath != null && details.appimagepath!.isNotEmpty) {
        String iconUrl = details.appimagepath!.startsWith('http')
            ? details.appimagepath!
            : "https://lead.mumbaicrm.com/${details.appimagepath}";

        // Store URL for display
        iconImageBase64.value = iconUrl;
      }

      // Basic Information
      nameController.text = details.iname ?? '';
      unitController.text = details.unitId ?? '';
      showUnitController.text = details.unit ?? '';
      titleController.text = details.property ?? '';

      // Pricing Details
      saleRateController.text = details.rate1 ?? '';
      mrpController.text = details.mrp ?? '';
      discountController.text = details.rate12 ?? '';

      // Tax Information
      showsgstController.text = details.stax ?? '';
      sgstController.text = details.staxId ?? '';
      showpgstController.text = details.ptax ?? '';
      pgstController.text = details.pTaxId ?? '';
      showhsnController.text = details.sname ?? '00';
      hsnController.text = details.hsnId ?? '';

      // Classification
      showCompanyController.text = details.company ?? '';
      comapnyController.text = details.companyId ?? '';
      showCategoryController.text = details.igroup ?? '';
      categoryController.text = details.igroupId ?? '';

      // Inventory Management
      barcodeController.text = details.barcode ?? '';
      sizeController.text = details.ssize ?? '';
      minQtyController.text = details.minorderqty ?? '';
      maxQtyController.text = details.maxorderqty ?? '';
      minLevelController.text = details.minqty ?? '';
      maxLevelController.text = details.maxqty ?? '';

      // Additional Information
      remark1Controller.text = details.remark1 ?? '';
      remark2Controller.text = details.remark2 ?? '';
      remark3Controller.text = details.remark3 ?? '';
      remark4Controller.text = details.remark4 ?? '';
      remark5Controller.text = details.remark5 ?? '';
      descriptionController.text = details.itemdisc ?? '';
    } catch (e) {
      print("Error initializing edit mode: $e");
      CustomSnack.show(
        content: "Failed to load product details: $e",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      CustomSnack.show(
        content: "Please fill all required fields correctly",
        snackType: SnackType.warning,
        behavior: SnackBarBehavior.fixed,
      );
      return;
    }

    try {
      isAddingProduct.value = true;

      // Handle banner image
      String bannerBase64 = '';
      if (bannerImageBase64.value.isNotEmpty) {
        if (bannerImageBase64.value.startsWith('http')) {
          // Convert URL to base64
          bannerBase64 = await urlToBase64(bannerImageBase64.value);
          print(bannerBase64);
        } else if (bannerImageBase64.value.startsWith('data:image') ||
            bannerImageBase64.value.startsWith('/9j/')) {
          // Already in base64 format
          bannerBase64 = bannerImageBase64.value;
        }
      }

      // Handle icon image
      String iconBase64 = '';
      if (iconImageBase64.value.isNotEmpty) {
        if (iconImageBase64.value.startsWith('http')) {
          // Convert URL to base64
          iconBase64 = await urlToBase64(iconImageBase64.value);
        } else if (iconImageBase64.value.startsWith('data:image') ||
            iconImageBase64.value.startsWith('/9j/')) {
          // Already in base64 format
          iconBase64 = iconImageBase64.value;
        }
      }

      if (productDetails.isEmpty) {
        throw Exception('No product details found for update');
      }

      final ApiResponse response = await ApiClient().updateProduct(
        endPoint: ApiEndpoints.UpdateProduct,
        id: productDetails[0].id!,
        name: nameController.text,
        mrp: mrpController.text,
        unitId: unitController.text,
        packagingId: unitController.text,
        boxSize: "", // Consider adding a controller for this if needed
        comapnyId: comapnyController.text,
        stax: sgstController.text,
        ptax: pgstController.text,
        minQty: minQtyController.text,
        maxQty: maxQtyController.text,
        category: categoryController.text,
        hsn: hsnController.text,
        size: sizeController.text,
        property: titleController.text,
        remark1: remark1Controller.text,
        remark2: remark2Controller.text,
        remark3: remark3Controller.text,
        remark4: remark4Controller.text,
        remark5: remark5Controller.text,
        remark6: '', // Consider adding a controller if needed
        minOrder: minLevelController.text,
        maxOrder: maxLevelController.text,
        barcode: barcodeController.text,
        banner: bannerBase64,
        icon: iconBase64,
        saleRate: saleRateController.text,
        discount: discountController.text,
        desc: descriptionController.text,
      );

      if (response.isSuccess) {
        currentPage.value = 0;
        clearform();
        await fetchProducts();
        Get.back();
        CustomSnack.show(
          content: response.message ?? "Product updated successfully",
          snackType: SnackType.success,
          behavior: SnackBarBehavior.fixed,
        );
      } else {
        throw Exception(response.message ?? 'Failed to update product');
      }
    } catch (e) {
      print("Error updating product: $e");
      CustomSnack.show(
        content: "Failed to update product: $e",
        snackType: SnackType.error,
        behavior: SnackBarBehavior.fixed,
      );
    } finally {
      isAddingProduct.value = false;
    }
  }

  Future<String> urlToBase64(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return "data:image/jpeg;base64,${base64Encode(response.bodyBytes)}";
      }
      throw Exception('Failed to load image');
    } catch (e) {
      print('Error converting image to base64: $e');
      return '';
    }
  }

  Future<void> addProduct() async {
    // Ensure form is valid before submitting
    if (formKey.currentState?.validate() ?? false) {
      try {
        isAddingProduct.value = true; // Start loading

        // Gather the data from your form
        final name = nameController.text;
        final unitId = unitController.text;
        final packagingId = unitController.text; // Adjust as needed
        final boxSize = ""; // Adjust this as per your form
        final companyId = comapnyController.text;
        final stax = sgstController.text;
        final ptax = pgstController.text;
        final minQty = minQtyController.text;
        final maxQty = maxQtyController.text;
        final category = categoryController.text;
        final hsn = hsnController.text;
        final size = sizeController.text;
        final property = remark1Controller.text;
        final remark1 = remark1Controller.text;
        final remark2 = remark2Controller.text;
        final remark3 = remark3Controller.text;
        final remark4 = remark4Controller.text;
        final remark5 = remark5Controller.text;
        final remark6 = ''; // Keeping it consistent
        final minOrder = minLevelController.text;
        final maxOrder = maxLevelController.text;
        final barcode = barcodeController.text;
        final mrp = mrpController.text;
        final salerate = saleRateController.text;
        final desc = descriptionController.text;
        final dis = discountController.text;
        final banner = bannerImageBase64.value;
        final icon = iconImageBase64.value;
        print(icon);
        print("this is the ${banner}");
        // Call the addProduct function
        final ApiResponse response = await ApiClient().addProduct(
          endPoint: ApiEndpoints.AddProduct,
          name: name,
          mrp: mrp,
          unitId: unitId,
          packagingId: packagingId,
          boxSize: boxSize,
          comapnyId: companyId,
          stax: stax,
          ptax: ptax,
          minQty: minQty,
          maxQty: maxQty,
          category: category,
          hsn: hsn,
          size: size,
          property: property,
          remark1: remark1,
          remark2: remark2,
          remark3: remark3,
          remark4: remark4,
          remark5: remark5,
          remark6: remark6,
          minOrder: minOrder,
          maxOrder: maxOrder,
          barcode: barcode,
          banner: banner,
          icon: icon,
          description: desc,
          saleRate: salerate,
          discount: dis,
        );

        if (response.isSuccess) {
          currentPage = 0.obs;
          clearform();
          fetchProducts();
          Get.back();
          CustomSnack.show(
            content: "Product successfully added! ID: ${response.data}",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed,
          );
        } else {
          // Display detailed error message from API response
          CustomSnack.show(
            content: "Failed to add product: ${response.message}",
            snackType: SnackType.error,
            behavior: SnackBarBehavior.fixed,
          );
        }
      } catch (e) {
        print("Error adding product: $e");
        CustomSnack.show(
          content: "An unexpected error occurred: $e",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.fixed,
        );
      } finally {
        isAddingProduct.value = false; // Stop loading
      }
    } else {
      // Handle form validation errors
      CustomSnack.show(
        content: "Validation error, please check your inputs.",
        snackType: SnackType.warning,
        behavior: SnackBarBehavior.fixed,
      );
    }
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final details =
          await ApiClient().getProductDetail(ApiEndpoints.ProductDetail, id);
      if (details.isNotEmpty) {
        productDetails.value = details;
      } else {
        errorMessage.value = "No product details found.";
      }
    } catch (e) {
      errorMessage.value = "Failed to fetch product details. Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  var filteredItemData = <Map<String, String>>[].obs;
  var itemData = <Map<String, String>>[].obs;
  final qtyController = TextEditingController();
  final seacrchController = TextEditingController();
  RxInt qty = 1.obs;
  RxInt totalAmnt = 0.obs;
  final customerSearchController = TextEditingController();

  RxList<Products1> itemsList = <Products1>[].obs;

  RxList<Products1> productList = <Products1>[].obs;
  RxBool isFetchingMore = false.obs;
  RxInt currentPage = 0.obs; // Track the current page number
  RxBool hasMoreLeads =
      true.obs; // Flag to track if there are more leads to load
  var Unit = [
    "Regular",
    "Dimension",
    "Size And Colour.",
    "Serial Number.",
    "Batch.",
  ];
  var size = [
    "Small",
    "Medium",
    "Large.",
  ];
  RxList<UnitList> units = <UnitList>[].obs;
  RxList<SGST> sgst = <SGST>[].obs;
  RxList<HSN> hsn = <HSN>[].obs;
  RxList<CompanyName> company = <CompanyName>[].obs;
  RxList<PurchaseGst> pgst = <PurchaseGst>[].obs;
  RxList<CategoryList> category = <CategoryList>[].obs;
  var box = GetStorage();
  late var nameController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final sizeController = TextEditingController();
  final unitController = TextEditingController();
  final showUnitController = TextEditingController();
  final sgstController = TextEditingController();
  final showsgstController = TextEditingController();
  final pgstController = TextEditingController();
  final showpgstController = TextEditingController();
  final hsnController = TextEditingController();
  final showhsnController = TextEditingController();
  final comapnyController = TextEditingController();
  final showCompanyController = TextEditingController();
  final categoryController = TextEditingController();
  final showCategoryController = TextEditingController();
  final barcodeController = TextEditingController();
  final discountController = TextEditingController();
  final minQtyController = TextEditingController();
  final maxQtyController = TextEditingController();
  final maxLevelController = TextEditingController();
  final minLevelController = TextEditingController();
  final remark1Controller = TextEditingController();
  final remark2Controller = TextEditingController();
  final remark3Controller = TextEditingController();
  final remark4Controller = TextEditingController();
  final remark5Controller = TextEditingController();
  final remarkC6ontroller = TextEditingController();
  final mrpController = TextEditingController();
  final saleRateController = TextEditingController();

  List<CustomSelectItem> get titleItems {
    return List<CustomSelectItem>.generate(
      Unit.length,
      (index) => CustomSelectItem(id: index.toString(), value: Unit[index]),
    );
  }

  List<CustomSelectItem> get sizecategoryItems {
    return List<CustomSelectItem>.generate(
      size.length,
      (index) => CustomSelectItem(id: index.toString(), value: size[index]),
    );
  }

  @override
  void onInit() async {
    fetchProducts();

    // TODO: implement onInit
    fetchUnits();
    fetchCategory();
    fetchComapny();
    fetchHsn();
    fetchPurchaseGst();
    fetchsgst();
    _initializeFilters();
    ever(productList, (_) => _updateFilterOptions());
    ever(searchQuery, (_) => applyFilters());
    ever(selectedCategory, (_) => applyFilters());
    ever(selectedGst, (_) => applyFilters());
    ever(currentPriceRange, (_) => applyFilters());
    print("edit");

    final arguments = Get.arguments;
    final bool isEdit = arguments != null && arguments['isEdit'] == true;
    final String? productId = arguments?['productId'];

    super.onInit();
  }

  void _initializeFilters() {
    filteredProducts.assignAll(productList);
  }

  void _updateFilterOptions() {
    // Extract unique categories from products
    final uniqueCategories = productList
        .map((product) => product.igroup)
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
    categories.assignAll(uniqueCategories);

    // Extract unique GST rates
    final uniqueGstRates = productList
        .map((product) => product.stax)
        .where((gst) => gst.isNotEmpty)
        .toSet()
        .toList();
    gstRates.assignAll(uniqueGstRates);

    // Update price range
    double minPriceValue = double.infinity;
    double maxPriceValue = 0.0;

    for (var product in productList) {
      final price = double.tryParse(product.rate1) ?? 0.0;
      if (price < minPriceValue) minPriceValue = price;
      if (price > maxPriceValue) maxPriceValue = price;
    }

    minAvailablePrice.value = minPriceValue;
    maxAvailablePrice.value = maxPriceValue;
    currentPriceRange.value = RangeValues(minPriceValue, maxPriceValue);

    // Update the display values
    minPrice.value = currentPriceRange.value.start;
    maxPrice.value = currentPriceRange.value.end;
  }

  void searchProducts(String query) {
    searchQuery.value = query;
  }

  void applyFilters() {
    List<Products1> filtered = List<Products1>.from(productList);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((product) => product.iname
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered
          .where((product) => product.igroup == selectedCategory.value)
          .toList();
    }

    // Apply GST filter
    if (selectedGst.value.isNotEmpty) {
      filtered = filtered
          .where((product) => product.stax == selectedGst.value)
          .toList();
    }

    // Apply price range filter
    filtered = filtered.where((product) {
      final price = double.tryParse(product.rate1) ?? 0.0;
      return price >= currentPriceRange.value.start &&
          price <= currentPriceRange.value.end;
    }).toList();

    // Update filtered products
    filteredProducts.assignAll(filtered);
    minPrice.value = currentPriceRange.value.start;
    maxPrice.value = currentPriceRange.value.end;
    // Update active filters status
    hasActiveFilters.value = selectedCategory.value.isNotEmpty ||
        selectedGst.value.isNotEmpty ||
        searchQuery.value.isNotEmpty ||
        currentPriceRange.value.start != minAvailablePrice.value ||
        currentPriceRange.value.end != maxAvailablePrice.value;

    hasPriceFilter.value =
        currentPriceRange.value.start != minAvailablePrice.value ||
            currentPriceRange.value.end != maxAvailablePrice.value;
  }

  void clearFilters() {
    selectedCategory.value = '';
    selectedGst.value = '';
    searchQuery.value = '';
    currentPriceRange.value = RangeValues(
      minAvailablePrice.value,
      maxAvailablePrice.value,
    );
    minPrice.value = minAvailablePrice.value;
    maxPrice.value = maxAvailablePrice.value;
    applyFilters();
  }

  void clearCategoryFilter() {
    selectedCategory.value = '';
  }

  void clearGstFilter() {
    selectedGst.value = '';
  }

  void clearPriceFilter() {
    currentPriceRange.value = RangeValues(
      minAvailablePrice.value,
      maxAvailablePrice.value,
    );
  }

  // Fetch UnitList data using getUnitList helper function
  Future<void> fetchUnits() async {
    await _fetchData(
      apiCall: () =>
          ApiClient().getUnitList(box.read("userId"), ApiEndpoints.Unitlist),
      dataList: units,
      isFetchingState: isFetching,
    );
  }

  Future<void> fetchCategory() async {
    await _fetchData(
      apiCall: () => ApiClient()
          .getcategoryList(box.read("userId"), ApiEndpoints.categoryList),
      dataList: category,
      isFetchingState: isFetching,
    );
  }

  Future<void> fetchComapny() async {
    await _fetchData(
      apiCall: () =>
          ApiClient().getComapny(box.read("userId"), ApiEndpoints.ComapnyName),
      dataList: company,
      isFetchingState: isFetching,
    );
  }

  Future<void> fetchsgst() async {
    await _fetchData(
      apiCall: () =>
          ApiClient().getSaleGst(box.read("userId"), ApiEndpoints.SaleGst),
      dataList: sgst,
      isFetchingState: isFetching,
    );
  }

  Future<void> deleteProducts(String id) async {
    print(id);

    try {
      isAddingProduct.value = true; // Start loading

      bool isSuccess = await ApiClient().deleteProduct(
        endPoint: ApiEndpoints.DeleteProduct, // Ensure to define this endpoint
        id: id,
      );

      if (isSuccess) {
        currentPage.value = 0;
        productList.clear();
        await fetchProducts(isInitialFetch: true);
        CustomSnack.show(
            content: "Successfully Deleted",
            snackType: SnackType.success,
            behavior: SnackBarBehavior.fixed);
        // Handle success (you can show a success message or navigate to another page)
      }
    } catch (e) {
      print("Error deleting product: $e");
      CustomSnack.show(
          content: "Failed To delete product",
          snackType: SnackType.error,
          behavior: SnackBarBehavior.fixed);
    } finally {
      isAddingProduct.value = false; // Stop loading
    }
  }

  Future<void> fetchPurchaseGst() async {
    await _fetchData(
      apiCall: () =>
          ApiClient().getPGST(box.read("userId"), ApiEndpoints.Purchasegst),
      dataList: pgst,
      isFetchingState: isFetching,
    );
  }

  Future<void> fetchHsn() async {
    await _fetchData(
      apiCall: () =>
          ApiClient().getHSN(box.read("userId"), ApiEndpoints.HsnCode),
      dataList: hsn,
      isFetchingState: isFetching,
    );
  }

  // Shared function for API calls
  Future<void> _fetchData({
    required Future<List<dynamic>> Function() apiCall,
    required RxList<dynamic> dataList,
    required RxBool isFetchingState,
  }) async {
    try {
      isFetchingState.value = true;
      final data = await apiCall();
      if (data.isNotEmpty) {
        dataList.assignAll(data);
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isFetchingState.value = false;
    }
  }

  Future<void> fetchProducts({bool isInitialFetch = true}) async {
    const String endpoint = ApiEndpoints.allProductsList;
    final String userId = box.read("userId");
    const String pageSize = "10"; // Number of items per page
    final String pageNumber =
        currentPage.value.toString(); // Current page number
    const String isPagination = "0";

    try {
      if (isInitialFetch) {
        isLoading.value = true; // Show loading indicator for initial fetch
      } else {
        isFetchingMore.value = true; // Show loading indicator for more data
      }

      final newProducts = await ApiClient().getAllProductList(
        endPoint: endpoint,
        userId: userId,
        isPagination: isPagination,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );

      if (newProducts.isNotEmpty) {
        if (isInitialFetch) {
          currentPage.value = 0;
          productList.clear();
          productList.assignAll(newProducts); // Load the initial data
        } else {
          productList
              .addAll(newProducts); // Add more data for subsequent fetches
        }

        currentPage.value++; // Increment the current page number
        if (newProducts.length < int.parse(pageSize)) {
          hasMoreLeads.value = false; // No more data to load
        }
      } else {
        hasMoreLeads.value = false; // No more data to load
      }
    } catch (e) {
      print("An error occurred while fetching products: $e");
      Get.snackbar("Error", "Failed to fetch products. Please try again.");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
    }
  }

  void clearform() {
    nameController.clear();
    mrpController.clear();
    titleController.clear();
    sizeController.clear();
    unitController.clear();
    showUnitController.clear();
    sgstController.clear();
    showsgstController.clear();
    pgstController.clear();
    showpgstController.clear();
    hsnController.clear();
    showhsnController.clear();
    comapnyController.clear();
    showCompanyController.clear();
    categoryController.clear();
    showCategoryController.clear();
    barcodeController.clear();
    discountController.clear();
    minQtyController.clear();
    maxQtyController.clear();
    maxLevelController.clear();
    minLevelController.clear();
    remark1Controller.clear();
    remark2Controller.clear();
    remark3Controller.clear();
    remark4Controller.clear();
    remark5Controller.clear();
    remarkC6ontroller.clear();
    iconImageBase64.value = "";
    bannerImageBase64.value = "";
    saleRateController.clear();
  }

  @override
  void onClose() {
    clearform();
    super.onClose();
    dispose();
  }
}
