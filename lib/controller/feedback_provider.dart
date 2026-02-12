import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../app_pref.dart';
import '../ai/ai_from_service.dart';
import '../model/feedback_form_model.dart';
import '../model/feedback_model.dart';
import '../view/widgets/custom_toast.dart';

class FeedbackProvider with ChangeNotifier {
  // ===========================================================================
  // 1. STATE PROPERTIES (PRIVATE)
  // ===========================================================================

  static const String _baseUrl = 'https://api.foodchow.com/api/FoodUserMaster';
  final AiFormService _aiFormService = AiFormService();

  // Basic Page Indices
  int _mainPageIndex = 0;
  int _createFeedbackFormPageIndex = 0;

  // Selection & Query
  String _selectedCategory = "All";
  String _dropDownFromData = "All";
  String _query = "";

  // UI Flags
  bool _isAddingField = false;
  bool _isAdding = false;
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _isLoading = false;
  bool _isFromLoading = false;

  // Dashboard Stats
  double _average = 1;
  double _positive = 1;
  double _negative = 1;
  int _all = 1;

  // Loading IDs (Granular States)
  String? _togglingFormId;
  String? _deletingFormId;
  String? _loadingFormId; // Fetching Details
  String? _updatingFormId; // Saving Changes

  // Selected Objects
  FeedbackFormModel? selectedForm;

  // Data Collections
  List<FeedbackModel> feedbackList = [];
  List<FeedbackFormModel> feedbackForms = [];
  List<dynamic> formNameList = [];

  // ===========================================================================
  // 2. GETTERS
  // ===========================================================================

  int get mainPageIndex => _mainPageIndex;
  int get createFeedbackFormPageIndex => _createFeedbackFormPageIndex;

  String get selectedCategory => _selectedCategory;
  String get dropDownFromData => _dropDownFromData;
  String get query => _query;

  bool get isAddingField => _isAddingField;
  bool get isAdding => _isAdding;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get isLoading => _isAdding || _isUpdating || _isDeleting || _isLoading;
  bool get isFromLoading => _isFromLoading;

  double get getAverageRating => _average;
  double get getPositivePercentage => _positive;
  double get getNegativePercentage => _negative;
  int get getAll => _all;

  String? get togglingFormId => _togglingFormId;
  String? get deletingFormId => _deletingFormId;
  String? get loadingFormId => _loadingFormId;
  String? get updatingFormId => _updatingFormId;

  // ===========================================================================
  // 3. SEARCH & FILTERING LOGIC
  // ===========================================================================

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  List<FeedbackModel> get filterList {
    if (_query.isEmpty) {
      return feedbackList;
    }
    return feedbackList.where((e) => (e.userName ?? "").toLowerCase().contains(_query.toLowerCase())).toList();
  }
  // ===========================================================================
  // 4. API: DASHBOARD & LIST FETCHING
  // ===========================================================================

  Future<void> calculate() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.foodchow.com/api/FoodUserMaster/GetCustomFeedbackDashboard?shop_id=${AppPref().getShopId()}"),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        _average = (decoded["data"]["dt1"][0]["average"] ?? 0).toDouble();
        _positive = (decoded["data"]["dt1"][0]["positive"] ?? 0).toDouble();
        _negative = (decoded["data"]["dt1"][0]["negative"] ?? 0).toDouble();
        _all = (decoded["data"]["dt1"][0]["total"] ?? 0).toInt();
        if (decoded["data"]["dt"] != null) {
          formNameList = (decoded["data"]["dt"] as List<dynamic>);
        }
        notifyListeners();
        await fetchFeedbackList();
      }
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
    }
  }

  Future<void> fetchFeedbackList() async {
    _isLoading = true;
    notifyListeners();

    String filter = "all";
    if (_selectedCategory == "5 Stars") {
      filter = "5_star";
    } else if (_selectedCategory == "Positive") {
      filter = "positive";
    } else if (_selectedCategory == "Negative") {
      filter = "negative";
    }

    String formId = "all";
    if (_dropDownFromData == "All") {
      formId = "all";
    } else {
      formId = _dropDownFromData;
    }

    final String url = '$_baseUrl/GetCustomFeedbackOfCustomer?shop_id=${AppPref().getShopId()}&form_id=$formId&filter=$filter';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['data'] != null && decoded['data'] is List) {
          List<dynamic> data = decoded['data'];
          feedbackList = data.map((e) => FeedbackModel.fromJson(e)).toList();
        } else {
          feedbackList = [];
        }
      }
    } catch (e) {
      log("Error fetching feedback: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // 5. NAVIGATION & VIEW STATE METHODS
  // ===========================================================================

  void setMainPageIndex(int value) {
    _mainPageIndex = value;
    notifyListeners();
  }

  void setSelectedCategory(String value) {
    if (isLoading || _selectedCategory == value) return;
    _selectedCategory = value;
    fetchFeedbackList();
    notifyListeners();
  }

  void setCreateFeedbackFormPageIndex(int value) {
    _createFeedbackFormPageIndex = value;
    notifyListeners();
  }

  void setIsAddingField(bool value) {
    _isAddingField = value;
    notifyListeners();
  }

  void setDropDownFromData(String value) {
    if (isLoading || _dropDownFromData == value) return;
    _dropDownFromData = value;
    fetchFeedbackList();
    notifyListeners();
  }

  // ===========================================================================
  // 6. FORM MANAGEMENT (CRUD)
  // ===========================================================================

  void setDataToTheSelecteeForm(FeedbackFormModel value) {
    selectedForm = value;
    notifyListeners();
  }

  Future<bool> setSelectedForm(String? formId) async {
    if (formId == null) {
      selectedForm = null;
      notifyListeners();
      return true;
    }

    _isUpdating = true;
    _loadingFormId = formId;
    notifyListeners();

    try {
      final url = '$_baseUrl/GetShopCustomFeedbackByShopId?shop_id=${AppPref().getShopId()}&id=$formId';
      final response = await http.get(Uri.parse(url));
      log("Response: $url");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['data'] != null) {
          final dynamic data = decoded['data'];
          FeedbackFormModel? form;

          if (data is List && data.isNotEmpty) {
            form = FeedbackFormModel.fromJson(data[0]);
          } else if (data is Map<String, dynamic>) {
            form = FeedbackFormModel.fromJson(data);
          }

          if (form != null) {
            selectedForm = form;
            return true;
          }
        }
      } else {
        log("API Error (setSelectedForm): ${response.statusCode} -> ${response.body}");
      }
      CustomeToast.showError("Form data not found on server");
      return false;
    } catch (e, stack) {
      log("Exception in setSelectedForm: $e", stackTrace: stack);
      return false;
    } finally {
      _isUpdating = false;
      _loadingFormId = null;
      notifyListeners();
    }
  }

  Future<void> toggleFormStatus(String formId, int currentStatus, String shopId) async {
    _isUpdating = true;
    _togglingFormId = formId;
    notifyListeners();
    final url = '$_baseUrl/UpdateShopCustomFeedbackStatus?id=$formId&shop_id=$shopId&status=$currentStatus';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        CustomeToast.showSuccess("Form updated successfully");
        await getFeedbackForms();
      } else {
        log("API Error (toggleFormStatus): ${response.statusCode} -> ${response.body}");
      }
    } catch (e) {
      log("Exception in toggleFormStatus: $e");
      CustomeToast.showError("Error updating status");
    } finally {
      _togglingFormId = null;
      _isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> updateFormList() async {
    if (selectedForm == null) return false;

    bool success = false;
    final index = feedbackForms.indexWhere((form) => form.formId == selectedForm!.formId);

    if (index != -1 && selectedForm!.formId != null) {
      success = await updateFeedbackForm(selectedForm!.formId!, selectedForm!);
    } else {
      success = await addFeedbackForm(selectedForm!);
    }

    return success;
  }

  Future<void> getFeedbackForms({bool isFirstTime = false}) async {
    if (isFirstTime) _isFromLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('$_baseUrl/GetShopCustomFeedback?shop_id=${AppPref().getShopId()}'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'] ?? [];
        feedbackForms = data.map((e) => FeedbackFormModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        log("API Error (getFeedbackForms): ${response.statusCode} -> ${response.body}");
      }
    } catch (e) {
      CustomeToast.showError("Error: $e");
      log("Exception in getFeedbackForms: $e");
    } finally {
      _isFromLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addFeedbackForm(FeedbackFormModel form) async {
    _isAdding = true;
    _updatingFormId = form.formId;
    notifyListeners();

    form.status ??= 1;
    String requestBody = jsonEncode(form.toAddJson());

    log("add requestBody: $requestBody");

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/AddShopCustomFeedback'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['status'] == 1 || decoded['success'] == true || decoded['responseCode'] == 1) {
          // CustomeToast.showSuccess("Form added successfully");
          await getFeedbackForms();
          return true;
        } else {
          CustomeToast.showError(decoded['message'] ?? "Failed to add form");
          return false;
        }
      } else {
        log("API Error (addFeedbackForm): ${response.statusCode} -> ${response.body}");
        CustomeToast.showError("Server Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Exception in addFeedbackForm: $e");
      CustomeToast.showError("Error: $e");
      return false;
    } finally {
      _isAdding = false;
      _updatingFormId = null;
      notifyListeners();
    }
  }

  Future<bool> updateFeedbackForm(String id, FeedbackFormModel form) async {
    _isUpdating = true;
    _updatingFormId = id;
    notifyListeners();

    String requestBody = jsonEncode(form.toUpdateJson());
    log("update requestBody: $requestBody");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/UpdateShopCustomFeedback'),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['status'] == 1 || decoded['success'] == true || decoded['responseCode'] == 1) {
          // CustomeToast.showSuccess("Form updated successfully");
          await getFeedbackForms();
          return true;
        } else {
          CustomeToast.showError(decoded['message'] ?? "Failed to update form");
          log("API Error (updateFeedbackForm): ${response.statusCode} -> ${response.body}");
          return false;
        }
      } else {
        log("API Error (updateFeedbackForm): ${response.statusCode} -> ${response.body}");
        CustomeToast.showError("Server Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Exception in updateFeedbackForm: $e");
      CustomeToast.showError("Error: $e");
      return false;
    } finally {
      _isUpdating = false;
      _updatingFormId = null;
      notifyListeners();
    }
  }

  Future<void> deleteFeedbackForm(int id, String shopId) async {
    _isDeleting = true;
    _deletingFormId = id.toString();
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/DeleteCustomFeedbackForm?form_id=$id&shop_id=$shopId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['status'] == 1 || decoded['success'] == true) {
          CustomeToast.showSuccess("Form deleted successfully");
          await getFeedbackForms();
        } else {
          CustomeToast.showError(decoded['message'] ?? "Failed to delete form");
        }
      } else {
        log("API Error (deleteFeedbackForm): ${response.statusCode} -> ${response.body}");
        CustomeToast.showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Exception in deleteFeedbackForm: $e");
      CustomeToast.showError("Error: $e");
    } finally {
      _isDeleting = false;
      _deletingFormId = null;
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(int id, int typeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/DeleteCustomFeedbackFormsType?form_id=$id&type_id=$typeId'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);
        if (decoded['status'] == 1 || decoded['success'] == true) {
          await getFeedbackForms();
        } else {
          CustomeToast.showError(decoded['message'] ?? "Failed to delete form");
        }
      } else {
        log("API Error (deleteQuestion): ${response.statusCode} -> ${response.body}");
        CustomeToast.showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      log("Exception in deleteQuestion: $e");
      CustomeToast.showError("Error: $e");
    } finally {
      notifyListeners();
    }
  }

  // ===========================================================================
  // 7. HELPER METHODS (SEARCH & FIELD RETRIEVAL)
  // ===========================================================================

  int getContactFieldIndex(String name) {
    if (selectedForm == null || selectedForm!.customerFeedback == null) {
      return -1;
    }
    return selectedForm!.customerFeedback!.indexWhere((form) => form.fieldName == name);
  }

  void removeContactField(int index) {
    if (selectedForm?.customerFeedback != null) {
      final updatedList = List<CustomerFeedback>.from(selectedForm!.customerFeedback!);
      updatedList.removeAt(index);
      setDataToTheSelecteeForm(selectedForm!.copyWith(customerFeedback: updatedList));
    }
  }

  Future<String> generateAndDownloadQR(String link, String name) async {
    try {
      final screenshot = ScreenshotController();
      Widget qrWidget = Screenshot(
        controller: screenshot,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: QrImageView(data: link, size: 220),
        ),
      );

      final img = await screenshot.captureFromWidget(qrWidget);
      Directory? downloads = await getDownloadsDirectory();

      if (downloads == null) {
        if (Platform.isWindows) {
          downloads = Directory("${Platform.environment['USERPROFILE']}\\Downloads");
        } else {
          downloads = Directory("${Platform.environment['HOME']}/Downloads");
        }
      }

      final file = File("${downloads.path}/QR_${name}_${DateTime.now().millisecondsSinceEpoch}.png");
      await file.writeAsBytes(img);
      return file.path;
    } catch (e) {
      CustomeToast.showError("Error: $e");
      return "error: $e";
    }
  }

  Future<bool> generateAndShareQR(String link) async {
    try {
      final screenshot = ScreenshotController();
      Widget qrWidget = Screenshot(
        controller: screenshot,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: QrImageView(data: link, size: 220),
        ),
      );

      final img = await screenshot.captureFromWidget(qrWidget);
      final file = File("${Directory.systemTemp.path}\\qr_temp.png");
      await file.writeAsBytes(img);

      await SharePlus.instance.share(
        ShareParams(text: 'Scan this QR Code to give feedback!', subject: 'Feedback QR Code', files: [XFile(file.path)]),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // 9. AI FORM GENERATION (GROQ API)
  // ===========================================================================

  Future<List<FeedbackType>> generateAiForm(String topic) async {
    _isAdding = true;
    notifyListeners();

    try {
      return await _aiFormService.generateAiForm(topic);
    } catch (e) {
      log("ERROR in generateAiForm: $e");
      rethrow;
    } finally {
      _isAdding = false;
      notifyListeners();
    }
  }
}
