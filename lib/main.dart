import 'package:collage_project/auth/logIn/view/login_screen.dart';
import 'package:collage_project/auth/no_internet/view/no_internet_screen.dart';
import 'package:collage_project/auth/signup/view/signup_screen.dart';
import 'package:collage_project/auth/splash/view/splash_screen.dart';
import 'package:collage_project/auth/user_details/view/add_user_details_screen.dart';
import 'package:collage_project/user/bright_gallery/view/bright_gallery_screen.dart';
import 'package:collage_project/user/bright_gallery/view/image_view_screen.dart';
import 'package:collage_project/user/home/view/home_screen.dart';
import 'package:collage_project/user/home_work/view/home_work_screen.dart';
import 'package:collage_project/user/leave/view/add_leave_screen.dart';
import 'package:collage_project/user/leave/view/leave_screen.dart';
import 'package:collage_project/user/message/view/message_screen.dart';
import 'package:collage_project/user/result/view/result_screen.dart';
import 'package:collage_project/user/time_table/view/time_table_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: GetMaterialApp(
        theme: ThemeData(useMaterial3: true),
        getPages: [
          GetPage(
            name: '/',
            page: () => const SplashScreen(),
          ),
          GetPage(
            name: '/no_internet_screen',
            page: () => const NoInterNetScreen(),
          ),
          GetPage(
            name: '/login_screen',
            page: () => const LogInScreen(),
          ),
          GetPage(
            name: '/signup_screen',
            page: () => const SignUpScreen(),
          ),
          GetPage(
            name: '/add_user_detail_screen',
            page: () => const AddUserDetailsScreen(),
          ),
          GetPage(
            name: '/home_screen',
            page: () => const HomeScreen(),
          ),
          GetPage(
            name: '/home_work_screen',
            page: () => const HomeWorkScreen(),
          ),
          GetPage(
            name: '/leave_screen',
            page: () => const LeaveScreen(),
          ),
          GetPage(
            name: '/add_leave_screen',
            page: () => const AddLeaveScreen(),
          ),
          GetPage(
            name: '/time_table_screen',
            page: () => const TimeTableScreen(),
          ),
          GetPage(
            name: '/result_screen',
            page: () => const ResultScreen(),
          ),
          GetPage(
            name: '/bright_gallery_screen',
            page: () => const BrightGalleryScreen(),
          ),
          GetPage(
            name: '/image_view_screen',
            page: () => const ImageViewScreen(),
          ),
          GetPage(
            name: '/message_screen',
            page: () => const MessageScreen(),
          ),
        ],
      ),
    );
  }
}
