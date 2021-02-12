import 'package:flutter/material.dart';

class UserOrderInfo extends StatefulWidget {
  String userName;
  String phone;
  String address;

  UserOrderInfo({this.userName, this.phone, this.address});

  @override
  _UserOrderInfoState createState() => _UserOrderInfoState();
}

class _UserOrderInfoState extends State<UserOrderInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
            child: Column(children: [
              InkWell(
                  onTap: () {},
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5.0, top: 5.0, right: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/user2.png',
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              widget.userName,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(112, 170, 48, 1.0),
                                width: 1.0))),
                  )),
              InkWell(
                  onTap: () {},
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5.0, top: 5.0, right: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/telephone.png',
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              widget.phone,
                              maxLines: 3,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(112, 170, 48, 1.0),
                                width: 1.0))),
                  )),
              InkWell(
                  onTap: () {},
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5.0, top: 5.0, right: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/pin.png',
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 25.0),
                            child: Text(
                              widget.address,
                              maxLines: 3,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color.fromRGBO(112, 170, 48, 1.0),
                                width: 1.0))),
                  )),
            ])));
  }
}
