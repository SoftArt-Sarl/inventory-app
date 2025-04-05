import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_1/controller/appController.dart';
import 'package:flutter_application_1/controller/statisticController.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
class SalesDistributionChart extends StatefulWidget {
  bool? isFromDashbord;
  SalesDistributionChart({super.key, this.isFromDashbord});

  @override
  _SalesDistributionChartState createState() => _SalesDistributionChartState();
}

class _SalesDistributionChartState extends State<SalesDistributionChart> {
  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.only(
            left: widget.isFromDashbord! ? 10 : 16,
            bottom: 16,
            right: widget.isFromDashbord! ? 10 : 16,
            top: widget.isFromDashbord! ? 10 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isFromDashbord!) const SizedBox(height: 10),
            // Ajout des filtres en haut

            if (appTypeController.isDesktop.value || widget.isFromDashbord!)
              Row(
                children: [
                  const Text(
                    'Most saled',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        homeController.changeIndex(3);
                      },
                      icon: const Icon(
                        Icons.zoom_out_map_outlined,
                        color: Colors.blue,
                      ))
                ],
              ),
            // if (appTypeController.isDesktop.value && widget.isFromDashbord!)
            //   const Divider(),
            if (!widget.isFromDashbord!) _buildYearMonthDayPickers(),

            if (!widget.isFromDashbord!)
              const SizedBox(
                height: 10,
              ),
            // Affiche _buildBarChartOrTimeline() si le mode jour est activé
            Obx(() {
              if (statisticsController.isDailyMode.value) {
                return _buildBarChartOrTimeline();
              } else {
                return _buildBarChart();
              }
            }),
          ],
        ),
      ),
    );
  }

  // Filtre pour choisir une catégorie
  Widget _buildYearMonthDayPickers() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDropdown(
                "Année",
                statisticsController.selectedYear,
                List.generate(5, (index) => DateTime.now().year - index),
                statisticsController.setYear),
            if (!statisticsController.isAnnualMode.value) ...[
              _buildDropdown(
                  "Mois",
                  statisticsController.selectedMonth,
                  List.generate(12, (index) => index + 1),
                  statisticsController.setMonth),
              if (statisticsController.isDailyMode.value)
                _buildDropdown(
                    "Jour",
                    statisticsController.selectedDay,
                    [0, ...List.generate(31, (index) => index + 1)],
                    statisticsController.setDay),
            ],
            if (!statisticsController.isDailyMode.value)
              Card(
                elevation: 0,
                child: Column(
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
            if (!statisticsController.isAnnualMode.value)
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    const Text("Per day"),
                    Obx(() => Card(
                          elevation: 0,
                          color: Colors.grey[200],
                          child: Switch(
                            value: statisticsController.isDailyMode.value,
                            onChanged: (val) =>
                                statisticsController.toggleDailyMode(),
                          ),
                        )),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  // Widget de Dropdown pour sélectionner l'année, le mois ou le jour
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

  // Widget pour afficher le graphique à barres
  Widget _buildBarChart() {
    return Obx(() {
      // Applique les filtres sur les données
      Map<String, double> topSellingProducts =
          statisticsController.getTopSellingProducts();

      // Si aucun produit n'est vendu, afficher un texte
      if (topSellingProducts.isEmpty) {
        return const Expanded(
          child: Center(
            child: SizedBox(height: 20,width:20 ,child: CircularProgressIndicator()),
          ),
        );
      }

      List<BarChartGroupData> barGroups = [];
      int index = 0;

      topSellingProducts.forEach((category, value) {
        barGroups.add(
          BarChartGroupData(
            showingTooltipIndicators: [3, 0],
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: Colors.orange,
                width: 12,
                borderRadius: BorderRadius.circular(0),
              ),
            ],
          ),
        );
        index++;
      });

      return Expanded(
        child: SingleChildScrollView(
          physics: widget.isFromDashbord!
              ? const NeverScrollableScrollPhysics()
              : const ScrollPhysics(),
          child: Container(
            height: topSellingProducts.length * 30,
            padding: EdgeInsets.all(widget.isFromDashbord! ? 0 : 0),
            child: BarChart(
              BarChartData(
                rotationQuarterTurns: 5,
                barGroups: barGroups,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    direction: TooltipDirection.auto,
                    getTooltipColor: (group) => Colors.transparent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      rod.toY.toStringAsFixed(0),
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 30),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < topSellingProducts.keys.length) {
                          return Transform.rotate(
                            angle: -1.57,
                            child: Center(
                              child: Text(
                                topSellingProducts.keys
                                    .elementAt(value.toInt()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 90,
                    ),
                  ),
                ),
                gridData:
                    FlGridData(show: widget.isFromDashbord! ? false : true),
              ),
            ),
          ),
        ),
      );
    });
  }

Widget _buildBarChartOrTimeline() {
  return Obx(() {
    if (statisticsController.selectedDay.value == 0) {
      // Récupère les ventes pour tous les jours du mois
      Map<int, Map<String, double>> salesByDay = statisticsController.getSalesByDayForMonth(
        statisticsController.selectedYear.value,
        statisticsController.selectedMonth.value,
      );

      // Filtre les jours ayant des ventes
      List<int> daysWithSales = salesByDay.keys.toList();

      if (daysWithSales.isEmpty) {
        return const Center(
          child: Text(
            "Aucune vente pour ce mois",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }

      // Affiche un Timeline avec un _buildBarChart pour chaque jour
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: daysWithSales.map((day) {
              return TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: day == daysWithSales.first,
                isLast: day == daysWithSales.last,
                beforeLineStyle: const LineStyle(color: Colors.grey, thickness: 2),
                afterLineStyle: const LineStyle(color: Colors.grey, thickness: 2),
                indicatorStyle: IndicatorStyle(
                  width: 20,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(6),
                ),
                endChild: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jour $day",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Text(salesByDay[day].toString()),
                      _buildBarChartForDay(salesByDay[day]!),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    } else {
      // Si un jour spécifique est sélectionné, affiche un seul _buildBarChart
      Map<String, double> salesForDay = statisticsController.getTopSellingProductsForDay();

      if (salesForDay.isEmpty) {
        return const Center(
          child: Text(
            "Aucune vente pour ce jour",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      }

      return _buildBarChartForDay(salesForDay);
    }
  });
}
Widget _buildBarChartForDay(Map<String, double> salesData) {
  List<BarChartGroupData> barGroups = [];
  int index = 0;

  salesData.forEach((category, value) {
    barGroups.add(
      BarChartGroupData(
        showingTooltipIndicators: [3, 0],
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: Colors.orange,
            width: 12,
            borderRadius: BorderRadius.circular(0),
          ),
        ],
      ),
    );
    index++;
  });

  return Container(
    height: salesData.length * 50, // Ajuste la hauteur en fonction des données
    padding: const EdgeInsets.all(8.0),
    child: BarChart(
      BarChartData(rotationQuarterTurns: 5,
        barGroups: barGroups,barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    // direction: TooltipDirection.bottom,
                    getTooltipColor: (group) => Colors.transparent,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      rod.toY.toStringAsFixed(0),
                      const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < salesData.keys.length) {
                  return Transform.rotate(
                    angle: -1.57,
                    child: Center(
                      child: Text(
                        salesData.keys.elementAt(value.toInt()),
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 90,
            ),
          ),
        ),
        gridData: const FlGridData(show: true),
      ),
    ),
  );
}
  Color _getColor(String category) {
    final List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent
    ];
    return colors[category.hashCode % colors.length];
  }
}
