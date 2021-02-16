import 'package:flutter/material.dart';

class CartHeader extends StatelessWidget {
  final String title;

  const CartHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.5)),
              color: Colors.white),
          padding: EdgeInsets.only(top: 30, left: 20, bottom: 20),
          height: 80,
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    "assets/left_arrow.png",
                    width: 30,
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
