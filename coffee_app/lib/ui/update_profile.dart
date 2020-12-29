import 'dart:io';

import 'package:coffee_app/model/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:string_validator/string_validator.dart';
import 'package:coffee_app/repositories/update_profile_repository.dart';
import 'package:coffee_app/repositories/load_data_repository.dart';
import 'package:coffee_app/ui/home.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final picker = ImagePicker();
  File selectedImage;
  var currentUser = FirebaseAuth.instance.currentUser;
  final repo = UpdateProfileRepository();
  final loadRepo = LoadDataRepository();
  ProgressDialog progressDialog;
  MyUser userInfo;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    await loadRepo
        .loadUserInfo(currentUser.uid)
        .then((user) => userInfo = user);
    if (userInfo != null && userInfo.phone != null) {
      phoneController.text = userInfo.phone;
    } else {
      phoneController.text = "";
    }
    nameController.text = currentUser.displayName;
  }

  @override
  void dispose() {
    selectedImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context);
    progressDialog.style(
        message: 'Đang cập nhật',
        progressWidget: CircularProgressIndicator(),
        padding: EdgeInsets.all(20));
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => HomePage(currentIndex: 2,)), (route) => false);
      },
          child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 20),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => HomePage(currentIndex: 2,)), (route) => false);
                },
                            child: Image.asset(
                  "assets/left_arrow.png",
                  width: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Stack(children: [
                    ClipOval(
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                          : currentUser != null
                              ? currentUser.photoURL != null
                                  ? currentUser.photoURL.contains('image_picker')
                                      ? Image.file(
                                          File(currentUser.photoURL),
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          currentUser.photoURL,
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        )
                                  : Image.asset(
                                      "assets/user.png",
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  "assets/user.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border:
                                  Border.all(width: 1.0, color: Colors.black)),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )),
                    ),
                  ]),
                ),
              ),
            ),
            Center(
              child: Text(
                currentUser.displayName,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: TextFormField(
                autofocus: false,
                controller: nameController,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: InputBorder.none,
                  errorStyle: TextStyle(fontSize: 25.0),
                  labelText: "Tên",
                  labelStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                ),
                validator: (value) {
                  if (value.trim().isEmpty ||
                      matches(value, new RegExp(r'[A-Za-z ]'))) {
                    return "Vui lòng nhập lại tên";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: TextFormField(
                controller: phoneController,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.04,
                ),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: InputBorder.none,
                  errorStyle: TextStyle(fontSize: 25.0),
                  labelText: "Số điện thoại",
                  labelStyle: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                ),
                validator: (value) {
                  if (value.trim().isEmpty || !isInt(value)) {
                    return "Vui lòng nhập lại số điện thoại";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 80,
                    child: RaisedButton(
                      child: Text(
                        "Lưu thay đổi",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.04),
                      ),
                      color: Color.fromRGBO(112, 170, 48, 1.0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                        updateUserProfile();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getImage() async {
    await picker.getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        selectedImage = File(image.path);
      });
    });
  }

  void updateUserProfile() async {
    progressDialog.show();
    String newImage;
    if (selectedImage != null) {
      newImage = selectedImage.path;
    } else {
      newImage = currentUser.photoURL;
    }
    await currentUser.updateProfile(
        displayName: nameController.text.trim(), photoURL: newImage);
    await currentUser.reload();
    await repo.updateUser(currentUser.uid, newImage, nameController.text.trim(),
        phoneController.text.trim());
    //Future.delayed(Duration(seconds: 1)).then((value) {
    setState(() {
      currentUser = FirebaseAuth.instance.currentUser;
    });
    progressDialog.hide();
    // });
  }
}
