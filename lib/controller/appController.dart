
import 'package:flutter_application_1/controller/apiController.dart';
import 'package:flutter_application_1/controller/apptypeController.dart';
import 'package:flutter_application_1/controller/deliveryController.dart';
import 'package:flutter_application_1/controller/historiqueController.dart';
import 'package:flutter_application_1/controller/homeController.dart';
import 'package:flutter_application_1/controller/invoiceController.dart';
import 'package:flutter_application_1/controller/saleController.dart';
import 'package:flutter_application_1/controller/sellerController.dart';
import 'package:flutter_application_1/controller/statisticController.dart';
import 'package:flutter_application_1/controller/userInfo.dart';
import 'package:flutter_application_1/widget/reusableTable.dart';

Userinfo userinfo = Userinfo.instance;
ApiController apiController=ApiController.instance;
ActionHistoryController actionHistoryController=ActionHistoryController.instance;
HomeController homeController=HomeController.instance;
AppTypeController appTypeController=AppTypeController.instance;
Sellercontroller sellerController =Sellercontroller.instance;
InvoiceController invoiceController=InvoiceController.instance;
DeliveryController deliveryController=DeliveryController.instance;
SalesController salesController=SalesController.instance;
StatisticsController statisticsController =StatisticsController.instance;