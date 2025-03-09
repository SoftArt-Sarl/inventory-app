import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/historiqueModel.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ActionHistoryController extends GetxController {
  static ActionHistoryController instance =  Get.find();
  var actionItems = <ActionItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActionItems();
  }

  Future<void> fetchActionItems() async {
    isLoading.value = true;
    actionItems.value = await apiController.fetchActionItems();
    isLoading.value = false;
  }
}