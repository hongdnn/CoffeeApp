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
      child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(children: [
            InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, top: 5.0, right: 5.0, left: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/user2.png',
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            widget.userName == null ||
                                    widget.userName == 'not yet'
                                ? ''
                                : widget.userName,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.chevron_right,
                            ))
                      ],
                    ),
                  ),
                )),
            InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, top: 5.0, right: 5.0, left: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/telephone.png',
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            widget.phone == null || widget.phone == 'not yet'
                                ? ''
                                : widget.phone,
                            maxLines: 3,
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 1.0))),
                )),
            InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, top: 10.0, right: 5.0, left: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/pin.png',
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text(
                            widget.address == null ||
                                    widget.address == 'not yet'
                                ? ''
                                : widget.address,
                            maxLines: 3,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.chevron_right,
                            ))
                      ],
                    ),
                  ),
                )),
          ])),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(width: 0.2), bottom: BorderSide(width: 0.2))),
    );
  }
}
