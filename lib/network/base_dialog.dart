import 'package:flutter/material.dart';
import 'package:get/get.dart';


showBaseDialog() {
  Get.dialog(
    // barrierColor: Colors.transparent,
      barrierDismissible: false,
      AlertDialog(
        // title: Text("Please wait.."),
        backgroundColor: Colors.transparent,
        content: Center(child: CircularProgressIndicator(),),
      ));
}


hideBaseLoading(){

  if(Get.isDialogOpen??false){
    Get.back();
  }
}
