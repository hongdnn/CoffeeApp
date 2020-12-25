import 'package:coffee_app/cubits/login_cubit.dart';
import 'package:coffee_app/cubits/login_state.dart';
import 'package:coffee_app/repositories/authenticate_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final authrepo = AuthenticateRepository();
  final loginCubit = LoginCubit(authRepository: AuthenticateRepository());

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return CubitProvider(
      create: (BuildContext context) =>
          LoginCubit(authRepository: AuthenticateRepository()),
      child: CubitBuilder<LoginCubit, LoginState>(builder: (context, state) {
        if (state is LogoutSuccess) {
          return ProfileContent(state.user);
        } else if (state is LogoutFailure) {
          return ProfileContent(state.user);
        }
        return ProfileContent(currentUser);
      }),
    );
  }
}

class ProfileContent extends StatelessWidget {
  final User currentUser;

  ProfileContent(this.currentUser);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          height: 100,
          child: Row(children: [
            Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: currentUser != null
                      ? currentUser.photoURL != null
                          ? Image.network(
                              currentUser.photoURL,
                              width: 50,
                            )
                          : Image.asset(
                              "assets/user.png",
                              width: 50,
                            )
                      : Image.asset(
                          "assets/user.png",
                          width: 50,
                        ),
                )),
            Padding(
              padding: EdgeInsets.only(left: 10.0, bottom: 20.0),
              child: currentUser != null
                  ? Text(
                      currentUser.displayName,
                      style: TextStyle(fontSize: 25),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        color: Color.fromRGBO(112, 170, 48, 1.0),
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
            ),
          ]),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          margin: EdgeInsets.only(bottom: 30.0),
        ),
        Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Column(
              children: [
                InkWell(
                    onTap: () {},
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/user2.png',
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                'Thông tin tài khoản',
                                style: TextStyle(fontSize: 25),
                              ),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(112, 170, 48, 1.0),
                                  width: 3.0))),
                    )),
                InkWell(
                    onTap: () {},
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/invoice.png',
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                'Lịch sử đơn hàng',
                                style: TextStyle(fontSize: 25),
                              ),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(112, 170, 48, 1.0),
                                  width: 3.0))),
                    )),
                InkWell(
                    onTap: () {},
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/pin.png',
                              height: 30,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                'Địa chỉ giao hàng',
                                style: TextStyle(fontSize: 25),
                              ),
                            )
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(112, 170, 48, 1.0),
                                  width: 3.0))),
                    )),
                currentUser != null
                    ? InkWell(
                        onTap: () {
                          context.read<LoginCubit>().logOut();
                        },
                        child: Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Image.asset(
                                    'assets/log_out.png',
                                    height: 30,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text(
                                    'Đăng xuất',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                )
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color.fromRGBO(112, 170, 48, 1.0),
                                      width: 3.0))),
                        ))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
