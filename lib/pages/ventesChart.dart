import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/models.dart/invoiceModel.dart';
import 'package:flutter_application_1/pages/facturePage.dart';
import 'package:get/get.dart';
import '../controller/invoiceController.dart';

class MonthlySalesChart extends StatelessWidget {
  bool? isFromDashbord;
  MonthlySalesChart({super.key, this.isFromDashbord});

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(isFromDashbord! ? 10 : 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (isFromDashbord!)
                  const Text(
                    'Sales of the month',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                if (isFromDashbord!) const Spacer(),
                if (!isFromDashbord! && appTypeController.isDesktop.value)
                  _buildYearMonthDayPickers(),
                if (isFromDashbord!)
                  IconButton(
                      onPressed: () {
                        homeController.changeIndex(4);
                      },
                      icon: const Icon(
                        Icons.zoom_out_map_outlined,
                        color: Colors.blue,
                      )),
              ],
            ),
            if (!isFromDashbord!) const SizedBox(height: 0),
            if (!appTypeController.isDesktop.value && !isFromDashbord!)
              _buildYearMonthDayPickers(),
            if (!isFromDashbord!)
              const SizedBox(
                height: 10,
              ),
            Expanded(child: _buildSalesChart(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildYearMonthDayPickers() {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildDropdown(
                  "Year",
                  statisticsController.selectedYear,
                  List.generate(5, (index) => DateTime.now().year - index),
                  statisticsController.setYear),
              if (statisticsController.isAnnualMode.isFalse) ...[
                _buildDropdown(
                    "Month",
                    statisticsController.selectedMonth,
                    List.generate(12, (index) => index + 1),
                    statisticsController.setMonth),
                _buildDropdown(
                    "Jour",
                    statisticsController.selectedDay,
                    [0, ...List.generate(31, (index) => index + 1)],
                    statisticsController.setDay),
              ],
              Card(
                elevation: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Per year"),
                    Obx(() => Card(
                          elevation: 0,
                          color: Colors.grey[200],
                          child: Switch(
                            value: statisticsController.isAnnualMode.value,
                            onChanged: (val) =>
                                statisticsController.toggleAnnualMode(),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildDropdown(String label, RxInt selectedValue, List<int> values,
      Function(int) onChanged) {
    return Card(
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Obx(() => Card(
                elevation: 0,
                color: Colors.grey[200],
                child: DropdownButton<int>(
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  focusColor: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  value: selectedValue.value,
                  onChanged: (value) => onChanged(value!),
                  items: values
                      .map((v) => DropdownMenuItem<int>(
                            value: v,
                            child: Text(v == 0 ? "Tous" : "$v"),
                          ))
                      .toList(),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSalesChart(BuildContext context) {
    return Obx(() {
      if (statisticsController.isAnnualMode.value && !isFromDashbord!) {
        return _buildAnnualChart();
      } else {
        return _buildMonthlyChart(context);
      }
    });
  }

  Widget _buildAnnualChart() {
    Map<int, double> salesByMonth = statisticsController.getSalesByMonth();
    List<BarChartGroupData> barGroups = List.generate(12, (index) {
      int month = index + 1;
      return BarChartGroupData(
        x: month,
        // showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
            toY: salesByMonth[month] ?? 0,
            width: isFromDashbord! ? 10 : 16,
            color: salesByMonth[month] != null ? Colors.orange : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    return Obx(() {
      bool isDesktop = appTypeController.isDesktop.value;
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: isFromDashbord!  ? false : false,
                        reservedSize: 40)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: isDesktop,
                        reservedSize: isDesktop ? 60 : 40)),
                rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: isFromDashbord! ? false : false,
                        reservedSize: 60)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      List<String> months = [
                        "Jan",
                        "Fév",
                        "Mar",
                        "Avr",
                        "Mai",
                        "Jui",
                        "Jui",
                        "Aoû",
                        "Sep",
                        "Oct",
                        "Nov",
                        "Déc"
                      ];

                      if (!isDesktop && (value.toInt() % 2 == 0)) {
                        return Text('');
                      }
                      return Text(months[value.toInt() - 1]);
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: isFromDashbord! ? false : false),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMonthlyChart(BuildContext context) {
    Map<int, double> salesByDay = statisticsController.getSalesByDay();
    Map<int, List<Invoice>> invoicesByDay =
        statisticsController.getInvoicesByDay();

    if (salesByDay.isEmpty) {
      return const Center(
        child: Text("Aucune donnée disponible pour ce mois."),
      );
    }

    bool isDesktop = appTypeController.isDesktop.value;

    if (statisticsController.selectedDay.value != 0) {
      int selectedDay = statisticsController.selectedDay.value;
      Map<int, double> salesByHour =
          statisticsController.getSalesByHour(selectedDay);
      List<FlSpot> spots = List.generate(24, (index) {
        double value =
            salesByHour.containsKey(index) ? salesByHour[index]! : 0.0;
        return FlSpot(index.toDouble(), value);
      });

      return Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: Colors.orange,
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.orange.withOpacity(0.2),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      int day = spot.x.toInt();
                      double sales = spot.y;
                      int invoicesCount = invoicesByDay[day]?.length ?? 0;

                      return LineTooltipItem(
                        "Jour: $day\nVentes: ${sales.toStringAsFixed(0)}\nFactures: $invoicesCount",
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (event is FlTapUpEvent && response != null) {
                    final tappedSpot = response.lineBarSpots?.first;
                    if (tappedSpot != null) {
                      int tappedDay = tappedSpot.x.toInt();
                      List<Invoice> selectedInvoices =
                          invoicesByDay[tappedDay] ?? [];
                      if (selectedInvoices.isNotEmpty) {
                        showInvoiceDialogOrBottomSheet(
                          context: context,
                          tappedDay: tappedDay,
                          selectedInvoices: selectedInvoices,
                          sales: tappedSpot.y, // Ajout du paramètre sales
                        );
                      }
                    }
                  }
                },
                handleBuiltInTouches: true,
              ),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles:
                          !isFromDashbord! && appTypeController.isDesktop.value,
                      reservedSize: !isFromDashbord! ? 60 : 0),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: !isFromDashbord! ? 40 : 25),
                ),
              ),
              gridData: FlGridData(show: isFromDashbord! ? false : true),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      );
    }

    List<FlSpot> spots = salesByDay.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.orange,
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.orange.withOpacity(0.2),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    int day = spot.x.toInt();
                    double sales = spot.y;
                    int invoicesCount = invoicesByDay[day]?.length ?? 0;

                    return LineTooltipItem(
                      "Jour: $day\nVentes: ${sales.toStringAsFixed(0)}\nFactures: $invoicesCount",
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
              touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                if (event is FlTapUpEvent && response != null) {
                  final tappedSpot = response.lineBarSpots?.first;
                  if (tappedSpot != null) {
                    int tappedDay = tappedSpot.x.toInt();
                    List<Invoice> selectedInvoices =
                        invoicesByDay[tappedDay] ?? [];
                       double sales = tappedSpot.y;
                    if (selectedInvoices.isNotEmpty) {
                      showInvoiceDialogOrBottomSheet(
                        context: context, // Passe le contexte de la page
                        tappedDay: tappedDay, // Passe le jour sélectionné
                        selectedInvoices:
                            selectedInvoices, // Passe la liste des factures
                        sales: sales, // Ajout du paramètre sales
                      );
                    }
                  }
                }
              },
              handleBuiltInTouches: true,
            ),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: !isFromDashbord!,
                    reservedSize: !isFromDashbord! ? 60 : 0),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, reservedSize: !isFromDashbord! ? 40 : 25),
              ),
            ),
            gridData: FlGridData(show: isFromDashbord! ? false : true),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}

void showInvoiceDialogOrBottomSheet({
  required BuildContext context,
  required int tappedDay,
  required List<Invoice> selectedInvoices,
  required double sales, // Ajout du paramètre sales
}) {
  final InvoiceController invoiceController = Get.find();

  // Formatage de la date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Contenu partagé entre Dialog et BottomSheet
  Widget buildInvoiceContent() {
    return Obx(() => SizedBox(
          width: appTypeController.isDesktop.value ? 500 : double.infinity,
          child: invoiceController.selectedInvoice.value != null
              ? InvoicePagee(
                  invoice: invoiceController.selectedInvoice.value!,
                  isDeliveryPage: false,
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: selectedInvoices.map((invoice) {
                      int index = selectedInvoices.indexOf(invoice);
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          onTap: () {
                            invoiceController.selectedInvoice.value = invoice;
                          },
                          title: Row(
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "N°${index + 1}: ${invoice.sale.custumerName}",
                                  overflow: TextOverflow.ellipsis, // Gère le débordement
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              
                              
                            ],
                          ),
                          subtitle: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text(
                                  "Montant: ${invoice.finalAmount.toStringAsFixed(0)} FCFA",
                                  // overflow: TextOverflow.ellipsis, // Gère le débordement
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              // Spacer(),
                              Flexible(
                                flex: 2,
                                child: Text(
                                  _formatDate(invoice.createdAt),
                                  // overflow: TextOverflow.ellipsis, // Gère le débordement
                                  style: const TextStyle(fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ));
  }

  // Affichage du Dialog pour bureau
  if (appTypeController.isDesktop.value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(
            "Factures du jour $tappedDay\nMontant total des ventes : ${sales.toStringAsFixed(0)} FCFA",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: buildInvoiceContent(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    ).then((_) {
      // Réinitialiser selectedInvoice lorsque le Dialog se ferme
      invoiceController.selectedInvoice.value = null;
    });
  } else {
    // Affichage du BottomSheet pour mobile
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.only(top: 50), // Ajout de la marge en haut
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20), // Bordure arrondie en haut
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône de drag
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              "Le $tappedDay\nMontant total des ventes : ${sales.toStringAsFixed(0)} FCFA",
              style: const TextStyle(fontSize: 15,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(child: buildInvoiceContent()),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Fermer"),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      // Réinitialiser selectedInvoice lorsque le BottomSheet se ferme
      invoiceController.selectedInvoice.value = null;
    });
  }
}
