import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:get/get.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:intl/intl.dart';

class SalesController extends GetxController {
  static SalesController instance = Get.find();

  Rxn<DateRange?> selectedRange = Rxn<DateRange?>(null);
  RxString totalSales = 'No result'.obs; 
  RxBool isLoading = false.obs;

  final Dio dio = Dio();
  final String url = 'https://inventory-app-five-ebon.vercel.app/sales/total-sales';

  @override
  void onInit() {
    super.onInit();
    selectedRange.value = DateRange(
      DateTime.now().subtract(const Duration(days: 30)),
      DateTime.now(),
    );
    fetchTotalSales();
  }

  // Fonction pour récupérer les ventes en fonction de la plage de dates
  Future<void> fetchTotalSales() async {
    if (selectedRange.value == null || isLoading.value) return;

    final token = userinfo.authmodel.value?.access_token;
    if (token == null) {
      totalSales.value = 'No result';
      return;
    }

    isLoading.value = true;

    final DateTime startDate = selectedRange.value!.start;
    final DateTime endDate = selectedRange.value!.end.add(const Duration(days: 1)); // ✅ Inclure la dernière date

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'startDate': DateFormat('yyyy-MM-dd').format(startDate),
          'endDate': DateFormat('yyyy-MM-dd').format(endDate),
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['totalSales'] != null) {
        totalSales.value = '${response.data['totalSales']} FCFA';
      } else {
        totalSales.value = 'No result';
      }
    } catch (e) {
      totalSales.value = 'No result';
      debugPrint('Something went wrong : $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Fonction pour afficher le sélecteur de plage de dates
  Future<void> pickDateRange(BuildContext context) async {
    if (isLoading.value) return;

    showDateRangePickerDialog(
      context: context,
      builder: (context, onDateRangeChanged) {
        return DateRangePickerWidget(
          initialDateRange: selectedRange.value,
          onDateRangeChanged: (DateRange? dateRange) {
            if (dateRange != null) {
              onDateRangeChanged(dateRange);
              selectedRange.value = dateRange;
              fetchTotalSales();
            }
          },
        );
      },
    );
  }

  DateRange convertToDateRange(DateTimeRange range) {
    return DateRange(range.start, range.end);
  }
}
