import 'package:coffee_app/cubits/order_cubit.dart';
import 'package:coffee_app/repositories/order_repository.dart';
import 'package:coffee_app/ui/home.dart';
import 'package:coffee_app/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return CubitProvider(
      create: (BuildContext context) =>
          OrderCubit(orderRepo: OrderRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CoffeeLand',
        theme: ThemeData.light(),
        home: currentUser == null
            ? LoginScreen()
            : HomePage(
                currentIndex: 0,
              ),
      ),

      //LoginScreen()
      // CubitProvider(
      //   create: (context) =>
      //       LoginCubit(authRepository: AuthenticateRepository()),
      //   child:
      //)
      // SplashScreen(
      //     navigateAfterSeconds: LoginScreen(),
      //     seconds: 3,
      //     routeName: "/",
      //     image: Image.asset("assets/cfland.png"),
      //     backgroundColor: Colors.white,
      //     photoSize: 100.0,
      //     loaderColor: Colors.red,
      //     ),
    );
  }
}

// Route _createRoute() {
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var begin = Offset(0.0, 1.0);
//       var end = Offset.zero;
//       var curve = Curves.easeInOut;

//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }
