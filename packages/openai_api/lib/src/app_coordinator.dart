
// Dùng để chuyển hướng
import 'package:flutter/material.dart';
import 'package:openai_api/src/core/components/constant/constant.dart';
import 'package:openai_api/src/core/components/extensions/context_extensions.dart';

extension AppCoordinator<T> on BuildContext {
  void pop() => Navigator.of(this).pop();

  void popUntil(String nRoute) =>
      Navigator.popUntil(this, ModalRoute.withName(nRoute));
  void popArgs(T? args) => Navigator.of(this).pop(args);
  Future<DateTime?> pickDateTime() async {
    DateTime? date = (await pickDate(DatePickerMode.day));
    if (date == null) {
      return null;
    }
    TimeOfDay? time = await pickTime();
    if (time == null) {
      return null;
    }
    return date.copyWith(hour: time.hour, minute: time.minute);
  }

   Future<TimeOfDay?> pickTime() => showTimePicker(
        context: this,
        initialTime: TimeOfDay(
          hour: Constant.timeNow.hour,
          minute: Constant.timeNow.minute,
        ),
      );

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        style: titleSmall.copyWith(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Theme.of(this).cardColor,
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }


  Future<bool> showAlertDialog(
      {required String header, required String content}) async {
    Widget cancelButton = TextButton(
      child: Text("Hủy",
          style: titleMedium.copyWith(
              fontWeight: FontWeight.w500, color: Theme.of(this).primaryColor)),
      onPressed: () => this.popArgs(false),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Tiếp tục",
        style: titleMedium.copyWith(
            fontWeight: FontWeight.w500, color: Theme.of(this).primaryColor),
      ),
      onPressed: () => this.popArgs(true),
    );
    final show = await showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(
            header,
            style: titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(content, style: titleSmall),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
    if (show is bool) {
      return show;
    }
    return false;
  }

  Future<DateTime?> pickDate(DatePickerMode mode) => showDatePicker(
        initialDatePickerMode: mode,
        context: this,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );


}
