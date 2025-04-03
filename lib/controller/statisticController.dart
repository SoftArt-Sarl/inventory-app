import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  static StatisticsController instance = Get.find();

  // Variables observables
  var selectedYear = DateTime.now().year.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedDay = 0.obs;
  var isDailyMode = false.obs; // Mode jour/heure
  var isAnnualMode = false.obs; // Mode annuel
  void setYear(int year) {
    selectedYear.value = year;
  }

  void setMonth(int month) {
    selectedMonth.value = month;
  }

  void setDay(int day) {
    selectedDay.value = day;
  }

  void toggleFilterMode() {
    isDailyMode.value = !isDailyMode.value;
  }

  void toggleAnnualMode() {
    isAnnualMode.value = !isAnnualMode.value;
    if (isAnnualMode.value) {
      isDailyMode.value = false;
    }
  }

  void toggleDailyMode() {
    isDailyMode.value = !isDailyMode.value;
    if (isDailyMode.value) {
      isAnnualMode.value = false;
    }
  }

  // Récupérer les ventes par catégorie
  Map<String, double> getSalesByCategory() {
    Map<String, double> salesByCategory = {};

    for (var invoice in invoiceController.invoicesList) {
      for (var item in invoice.sale.items) {
        if (item.quantity > 0) {
          salesByCategory[item.item.name] =
              (salesByCategory[item.item.name] ?? 0) + item.quantity;
        }
      }
    }

    salesByCategory.removeWhere((key, value) => value == 0);
    return salesByCategory;
  }

  // Méthode pour récupérer les produits les plus vendus pour l'année, le mois et le jour sélectionnés
  Map<String, double> getTopSellingProducts() {
    if (isDailyMode.value) {
      return getTopSellingProductsForDay();
    } else if (isAnnualMode.value) {
      return getTopSellingProductsForYear();
    } else {
      return getTopSellingProductsForMonth();
    }
  }

  // Récupérer les produits les plus vendus du mois sélectionné
  Map<String, double> getTopSellingProductsForMonth() {
    var selectedYear = this.selectedYear.value;
    var selectedMonth = this.selectedMonth.value;

    Map<String, double> salesByProduct = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear &&
          invoice.createdAt.month == selectedMonth) {
        for (var item in invoice.sale.items) {
          // if (item.quantity > 0) {
          String productName = item.item.name;
          salesByProduct[productName] =
              (salesByProduct[productName] ?? 0) + item.quantity;
          // }
        }
      }
    }

    return _sortSalesByQuantity(salesByProduct);
  }

  // Récupérer les produits les plus vendus du jour sélectionné
  Map<String, double> getTopSellingProductsForDay() {
    var selectedYear = this.selectedYear.value;
    var selectedMonth = this.selectedMonth.value;
    var selectedDay = this.selectedDay.value;

    Map<String, double> salesByProduct = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear &&
          invoice.createdAt.month == selectedMonth &&
          invoice.createdAt.day == selectedDay) {
        for (var item in invoice.sale.items) {
          // if (item.quantity > 0) {
          String productName = item.item.name;
          salesByProduct[productName] =
              (salesByProduct[productName] ?? 0) + item.quantity;
          // }
        }
      }
    }

    return _sortSalesByQuantity(salesByProduct);
  }

  // Récupérer les produits les plus vendus de l'année sélectionnée
  Map<String, double> getTopSellingProductsForYear() {
    var selectedYear = this.selectedYear.value;

    Map<String, double> salesByProduct = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear) {
        for (var item in invoice.sale.items) {
          // if (item.quantity > 0) {
          String productName = item.item.name;
          salesByProduct[productName] =
              (salesByProduct[productName] ?? 0) + item.quantity;
          // }
        }
      }
    }

    return _sortSalesByQuantity(salesByProduct);
  }

  // Trier les produits par quantité vendue (ordre décroissant)
  Map<String, double> _sortSalesByQuantity(Map<String, double> salesByProduct) {
    var sortedEntries = salesByProduct.entries
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedEntries);
  }

  // 🔹 Fonction pour récupérer les factures par jour
   Map<int, List<Invoice>> getInvoicesByDay() {
    var selectedYear = this.selectedYear.value;
    var selectedMonth = this.selectedMonth.value;
    var currentDate = DateTime.now();

    if (selectedYear > currentDate.year ||
        (selectedYear == currentDate.year &&
            selectedMonth > currentDate.month)) {
      print("Le mois sélectionné est dans le futur.");
      return {}; // Retourne une carte vide
    }

    Map<int, List<Invoice>> invoicesByDay = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear &&
          invoice.createdAt.month == selectedMonth) {
        int day = invoice.createdAt.day;
        invoicesByDay.putIfAbsent(day, () => []).add(invoice);
      }
    }

    return invoicesByDay;
  }

  // 🔹 Fonction pour récupérer les factures par heure
  Map<int, List<Invoice>> getInvoicesByHour(int selectedDay) {
    var selectedYear = this.selectedYear.value;
    var selectedMonth = this.selectedMonth.value;
    var currentDate = DateTime.now();

    if (selectedYear > currentDate.year ||
        (selectedYear == currentDate.year &&
            selectedMonth > currentDate.month) ||
        (selectedYear == currentDate.year &&
            selectedMonth == currentDate.month &&
            selectedDay > currentDate.day)) {
      print("Le jour sélectionné est dans le futur.");
      return {}; // Retourne une carte vide
    }

    Map<int, List<Invoice>> invoicesByHour = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear &&
          invoice.createdAt.month == selectedMonth &&
          invoice.createdAt.day == selectedDay) {
        int hour = invoice.createdAt.hour;
        invoicesByHour.putIfAbsent(hour, () => []).add(invoice);
      }
    }

    return invoicesByHour;
  }

  // 🔹 Fonction pour récupérer les factures par mois
  Map<int, List<Invoice>> getInvoicesByMonth() {
    var selectedYear = this.selectedYear.value;
    Map<int, List<Invoice>> invoicesByMonth = {};

    for (var invoice in invoiceController.invoicesList) {
      if (invoice.createdAt.year == selectedYear) {
        int month = invoice.createdAt.month;
        invoicesByMonth.putIfAbsent(month, () => []).add(invoice);
      }
    }

    return invoicesByMonth;
  }

  // 🔹 Montant total des ventes par jour
  Map<int, double> getSalesByDay() {
    var invoicesByDay = getInvoicesByDay();
    return invoicesByDay.map((day, invoices) => MapEntry(
        day, invoices.fold(0.0, (sum, invoice) => sum + invoice.finalAmount)));
  }

  // 🔹 Montant total des ventes par heure
  Map<int, double> getSalesByHour(int selectedDay) {
    var invoicesByHour = getInvoicesByHour(selectedDay);
    return invoicesByHour.map((hour, invoices) => MapEntry(
        hour, invoices.fold(0.0, (sum, invoice) => sum + invoice.finalAmount)));
  }

  // 🔹 Montant total des ventes par mois
  Map<int, double> getSalesByMonth() {
    var invoicesByMonth = getInvoicesByMonth();
    return invoicesByMonth.map((month, invoices) => MapEntry(month,
        invoices.fold(0.0, (sum, invoice) => sum + invoice.finalAmount)));
  }

  // 🔹 Nombre total de factures par jour
  Map<int, int> getInvoiceCountByDay() {
    var invoicesByDay = getInvoicesByDay();
    return invoicesByDay.map((day, invoices) => MapEntry(day, invoices.length));
  }

  // 🔹 Nombre total de factures par heure
  Map<int, int> getInvoiceCountByHour(int selectedDay) {
    var invoicesByHour = getInvoicesByHour(selectedDay);
    return invoicesByHour
        .map((hour, invoices) => MapEntry(hour, invoices.length));
  }

  // 🔹 Nombre total de factures par mois
  Map<int, int> getInvoiceCountByMonth() {
    var invoicesByMonth = getInvoicesByMonth();
    return invoicesByMonth
        .map((month, invoices) => MapEntry(month, invoices.length));
  }

  // 🔹 Fonction pour récupérer les ventes par jour pour un mois donné
  Map<int, Map<String, double>> getSalesByDayForMonth(int year, int month) {
    // Initialisation d'une carte pour stocker les ventes par jour
    Map<int, Map<String, double>> salesByDay = {};

    // Parcours des factures
    for (var invoice in invoiceController.invoicesList) {
      // Vérifie si la facture appartient à l'année et au mois sélectionnés
      if (invoice.createdAt.year == year && invoice.createdAt.month == month) {
        int day = invoice.createdAt.day;

        // Initialise les ventes pour ce jour si elles n'existent pas encore
        salesByDay.putIfAbsent(day, () => {});

        // Parcours des articles de la facture
        for (var item in invoice.sale.items) {
          String productName = item.item.name;

          // Ajoute la quantité vendue pour chaque produit
          salesByDay[day]![productName] =
              (salesByDay[day]![productName] ?? 0) + item.quantity;
        }
      }
    }

    // Trie les produits pour chaque jour
    salesByDay.forEach((day, sales) {
      salesByDay[day] = _sortSalesByQuantity(sales);
    });

    // Retourne les ventes par jour
    return salesByDay;
  }
}
