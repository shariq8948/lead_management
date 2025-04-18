import 'package:get/route_manager.dart';
import 'package:leads/Masters/Customer_entry/customer_entry_page.dart';
import 'package:leads/Masters/productEntry/productListPage.dart';
import 'package:leads/Masters/productEntry/product_entry_page.dart';
import 'package:leads/Reports/Marketing_reports/monthly_planner/binding.dart';
import 'package:leads/Reports/orders/order_overview/binding.dart';
import 'package:leads/Tabs/homepage/home_page.dart';
import 'package:leads/Tabs/homepage/homepage_binding.dart';
import 'package:leads/excelimport/binding.dart';
import 'package:leads/excelimport/excel_import_page.dart';
import 'package:leads/leads/create_lead/create_lead_page.dart';
import 'package:leads/leads/details/lead_detail_binding.dart';
import 'package:leads/leads/details/lead_details_page.dart';
import 'package:leads/leads/leadlist/lead_list_binding.dart';
import 'package:leads/leads/leadlist/lead_list_page.dart';
import 'package:leads/master-reports/leadlifecycle/drop-off/binding/binding.dart';
import 'package:leads/master-reports/leadlifecycle/drop-off/view/view.dart';
import 'package:leads/orders/bindings/productlist_binding.dart';
import 'package:leads/orderslist/orderslist_page.dart';
import 'package:leads/profilePage/profile_page.dart';
import 'package:leads/profile_pages/details/attendance/attendance_list_view.dart';

import '../Masters/Customer_entry/binding.dart';
import '../Masters/Customer_entry/customer_entry_controller.dart';
import '../Masters/productEntry/productenttry_binding.dart';
import '../Reports/Marketing_reports/monthly_planner/controller.dart';
import '../Reports/Marketing_reports/monthly_planner/monthly_planner_page.dart';
import '../Reports/Marketing_reports/msr/MSR_screen.dart';
import '../Reports/Marketing_reports/msr/binding.dart';
import '../Reports/orders/order_overview/order_view_page.dart';
import '../Reports/payement_report/mr_daily_collection/binding.dart';
import '../Reports/payement_report/mr_daily_collection/mr_daily_colleection_page.dart';
import '../attendance/attendance_page.dart';
import '../attendance/binding.dart';
import '../auth/login/login_binding.dart';
import '../auth/login/login_screen.dart';
import '../contactimport/binding.dart';
import '../contactimport/importpage.dart';
import '../leads/create_lead/binding.dart';
import '../orders/bindings/cart_binding.dart';
import '../orders/views/allproducts.dart';
import '../orders/views/cart_page.dart';
import '../orderslist/binding.dart';
import '../profilePage/binding.dart';
import '../splash/splash_binding.dart';
import '../splash/splash_screen.dart';

class Routes {
  // Route Names
  static const splashRoute = "/";
  static const loginRoute = "/login";
  static const main = "/main";
  static const home = "/home";
  static const addProduct = "/addproduct";
  static const productList = "/productlist";
  static const leadDetail = "/leaddetail";
  static const LEAD_LIST = "/lead-list";
  static const ATTENDANCE = "/attendance";
  static const DDROP_OFF = "/drop-off";
  static const CREATE_LEAD = "/create-lead";
  static const String COLLECTION_REPORT = '/collection-report';
  static const String MSR_REPORT = '/msr-report';
  static const String MONTHLY_PLANNER = '/monthly-planner';
  static const String ORDER_REPORT = '/order-report';
  static const String CONTACT_IMPORT = '/contact-import';
  static const String EXCEL_IMPORT = '/excel-import';
  static const String PRODUCT_ORDERS = '/product-orders';
  static const String PROFILE = '/profile';
  static const String ORDERS_LIST = '/order-list';
  static const String CUSTOMER_ENTRY = '/customer-entry';
  static const CART_PAGE = '/cart-page';

  // Get Pages
  static List<GetPage> routes = [
    // Splash
    GetPage(
      name: splashRoute,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.CART_PAGE,
      page: () => CartPage(),
      binding: ProductCartBinding(),
    ),
    GetPage(
      name: DDROP_OFF,
      page: () => DropoffAnalysisView(),
      binding: DropoffBinding(),
    ),
    GetPage(
      name: PRODUCT_ORDERS,
      page: () => ProductListPageOrder(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: ORDERS_LIST,
      page: () => OrdersDashboard(),
      binding: OrdersListBinding(),
    ),
    GetPage(
      name: addProduct,
      page: () => ProductEntryPage(),
      binding: ProductEntryBinding(),
    ),
    GetPage(
      name: productList,
      page: () => ProductListPage(),
      binding: ProductEntryBinding(),
    ),
    GetPage(
      name: CUSTOMER_ENTRY,
      page: () => CustomerEntryForm(),
      binding: CustomerEntryBinding(),
    ),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: main,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: main,
      page: () => HomeScreen(),
      binding: HomePageBinding(),
    ),

    // Login
    GetPage(
      name: loginRoute,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: leadDetail,
      page: () => LeadDetailsPage(),
      binding: LeadDetailBinding(),
    ),
    GetPage(
      name: CREATE_LEAD,
      page: () => CreateLeadPage(),
      binding: CreateLeadBinding(),
    ),
    GetPage(
      name: LEAD_LIST,
      page: () => LeadListPage(),
      binding: LeadListBinding(),
    ),
    GetPage(
      name: COLLECTION_REPORT,
      page: () => CollectionReportPage(),
      binding: CollectionReportBinding(),
    ),
    GetPage(
      name: MSR_REPORT,
      page: () => MSRReportsScreen(),
      binding: MSRbinding(),
    ),
    GetPage(
      name: MONTHLY_PLANNER,
      page: () => MonthlyPlannerView(),
      binding: MonthlyPlannerBinding(),
    ),
    GetPage(
      name: ORDER_REPORT,
      page: () => OrdersReportView(),
      binding: OrderReportBinding(),
    ),
    GetPage(
      name: CONTACT_IMPORT,
      page: () => ImportContactsPage(),
      binding: ContactImportBinding(),
    ),
    GetPage(
      name: EXCEL_IMPORT,
      page: () => ExcelImportPage(),
      binding: ExcelImportBinding(),
    ),
    GetPage(
      name: ATTENDANCE,
      page: () => AttendancePage(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    // Main Tabs
  ];
}
