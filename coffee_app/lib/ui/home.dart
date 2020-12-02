import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username = FirebaseAuth.instance.currentUser.displayName;
  @override
  Widget build(BuildContext context) {
    //var loginCubit = new LoginCubit(authRepository: AuthenticateRepository());
    return Scaffold(
      body: Container(
        child: username != null
            ? Text(
                username,
                style: TextStyle(fontSize: 25),
              )
            : Text("aaa"),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String username = FirebaseAuth.instance.currentUser.displayName;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: username != null
//             ? Text(
//                 username,
//                 style: TextStyle(fontSize: 25),
//               )
//             : Text("aaa"),
//         decoration: BoxDecoration(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
