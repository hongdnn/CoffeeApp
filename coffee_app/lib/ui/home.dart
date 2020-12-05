import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:coffee_app/ui/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final repo = AuthenticateRepository();
  @override
  Widget build(BuildContext context) {
    //var loginCubit = new LoginCubit(authRepository: AuthenticateRepository());
    return Scaffold(
      body: Container(
        child: currentUser != null
            ? Row(
                children: [
                  Text(
                    currentUser.displayName,
                    style: TextStyle(fontSize: 15),
                  ),
                  RaisedButton(
                    child: Text("Log out"),
                    onPressed: () {
                      repo.logOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                    },
                  )
                ],
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
