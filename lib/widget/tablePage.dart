import 'package:flutter/material.dart';
import 'package:flutter_application_1/controller/appController.dart';

class TablePage extends StatelessWidget {
  final Widget searchBar;
  final Widget header;
  final Widget productList;
  // final Widget pagination;

  const TablePage({
    super.key,
    required this.searchBar,
    required this.header,
    required this.productList,
    // required this.pagination,
  });

  @override
  Widget build(BuildContext context) {
    appTypeController.checkScreenType(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding:  EdgeInsets.all(appTypeController.isDesktop.value? 16.0:0),
        child: Column(
          children: [
            searchBar,
           appTypeController.isDesktop.value? const SizedBox(height: 16):const SizedBox.shrink(),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    header,
                    Expanded(child: productList),
                    // pagination,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
