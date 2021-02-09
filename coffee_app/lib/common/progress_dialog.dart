import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

ProgressDialog dialog;

void setUpProgressDialog(context) {
  dialog = ProgressDialog(context);
  dialog.style(
      progressWidget: CircularProgressIndicator(), padding: EdgeInsets.all(20));
}
