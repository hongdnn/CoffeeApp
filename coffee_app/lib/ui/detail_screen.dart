import 'package:flutter/material.dart';
import 'package:coffee_app/model/product.dart';
import 'package:coffee_app/model/size.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  final Size size;

  const DetailScreen({this.product, this.size});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String displayPrice;
  String displaySize;
  int numOfProduct;

  callback(String newPrice) {
    setState(() {
      displayPrice = newPrice;
    });
  }

  @override
  void initState() {
    super.initState();
    numOfProduct = 1;
    widget.size.priceOfSizeS != null
        ? displayPrice = widget.size.priceOfSizeS.toString()
        : widget.size.priceOfSizeM != null
            ? displayPrice = widget.size.priceOfSizeM.toString()
            : displayPrice = widget.size.priceOfSizeL.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        // ignore: missing_return
        onWillPop: () {
          Navigator.pop(context);
        },
        child: Scaffold(
            body: Stack(children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
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
                            widget.product.productName,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Hero(
                      tag: widget.product.image,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.network(
                          widget.product.image,
                          width: MediaQuery.of(context).size.width - 60,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.fill,
                        ),
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height/8.6,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: MediaQuery.of(context).size.width / 26),
                            child: Text(
                              displayPrice + ' đ',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(112, 170, 48, 1.0)),
                            ),
                          ),
                          widget.size.priceOfSizeS != null
                              ? SizeButton(
                                  'S',
                                  widget.size.priceOfSizeS.toString(),
                                  displayPrice,
                                  callback)
                              : SizedBox(),
                          widget.size.priceOfSizeM != null
                              ? SizeButton(
                                  'M',
                                  widget.size.priceOfSizeM.toString(),
                                  displayPrice,
                                  callback)
                              : SizedBox(),
                          widget.size.priceOfSizeL != null
                              ? SizeButton(
                                  'L',
                                  widget.size.priceOfSizeL.toString(),
                                  displayPrice,
                                  callback)
                              : SizedBox(),
                        ],
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 20),
                  child: Text(
                    'Giới thiệu món',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Text(
                    widget.product.description != null
                        ? widget.product.description
                        : '',
                    maxLines: 5,
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                widget.product.description != null ? Container(height: MediaQuery.of(context).size.height/4,) : SizedBox()
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  height: MediaQuery.of(context).size.height/4.2,
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height/8.6,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Text(
                                  'Số lượng',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  if (numOfProduct > 1) {
                                    setState(() {
                                      numOfProduct--;
                                    });
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 9,
                                  height: MediaQuery.of(context).size.width / 9,
                                  margin: const EdgeInsets.only(
                                    left: 7,
                                    right: 7,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color:
                                              Color.fromRGBO(112, 170, 48, 1.0),
                                          width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 7,
                                height: MediaQuery.of(context).size.width / 9,
                                margin: const EdgeInsets.only(
                                  left: 7,
                                  right: 7,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  numOfProduct.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    if (numOfProduct < 20) {
                                      setState(() {
                                        numOfProduct++;
                                      });
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 9,
                                    height:
                                        MediaQuery.of(context).size.width / 9,
                                    margin: const EdgeInsets.only(
                                      left: 7,
                                      right: 20,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                112, 170, 48, 1.0),
                                            width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height/10,
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(112, 170, 48, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                (int.parse(displayPrice)*numOfProduct).toString()+' đ',
                                style: TextStyle(
                                  color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold)
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                'Thêm vào giỏ',
                                style: TextStyle(
                                  color: Colors.white,
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold)
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )))
        ])));
  }
}

class SizeButton extends StatefulWidget {
  final String label;
  final String price;
  final displayPrice;
  final Function(String) callback;

  SizeButton(this.label, this.price, this.displayPrice, this.callback);

  @override
  _SizeButtonState createState() => _SizeButtonState();
}

class _SizeButtonState extends State<SizeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callback(widget.price);
      },
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 6.5,
        height: MediaQuery.of(context).size.width / 6.5,
        margin: const EdgeInsets.only(left: 7, right: 7),
        decoration: BoxDecoration(
            color: widget.displayPrice == widget.price
                ? Color.fromRGBO(112, 170, 48, 1.0)
                : Colors.white,
            border: Border.all(
                color: widget.displayPrice == widget.price
                    ? Color.fromRGBO(112, 170, 48, 1.0)
                    : Colors.black,
                width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 25,
            color: widget.displayPrice == widget.price
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
