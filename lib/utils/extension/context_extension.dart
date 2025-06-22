import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

extension ContextExt on BuildContext {
  Future<DateTime?> showModalSelectDateTime({
    required String dateTitle,
    required String timeTitle,
    DateTime? initialDateTime,
  }) async {
    DateTime selectedDate = initialDateTime ?? DateTime.now();

    // Pick Date
    final bool? proceed = await showCupertinoModalPopup<bool>(
      context: this,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(this),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child:
                      const Text("Hủy", style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.pop(this, null),
                ),
                Text(dateTitle, style: Theme.of(this).textTheme.titleMedium),
                CupertinoButton(
                  child: const Text("Tiếp tục"),
                  onPressed: () => Navigator.pop(this, true),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime date) {
                  selectedDate = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    selectedDate.hour,
                    selectedDate.minute,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (proceed != true) return null;

    // Pick Time
    final bool? confirmed = await showCupertinoModalPopup<bool>(
      context: this,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(this),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child:
                      const Text("Hủy", style: TextStyle(color: Colors.grey)),
                  onPressed: () => Navigator.pop(this, null),
                ),
                Text(timeTitle, style: Theme.of(this).textTheme.titleMedium),
                CupertinoButton(
                  child: const Text("Xong"),
                  onPressed: () => Navigator.pop(this, true),
                ),
              ],
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: selectedDate,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                onDateTimeChanged: (DateTime time) {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    time.hour,
                    time.minute,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      return selectedDate;
    }

    return null;
  }

  Future<bool> showDeleteConfirmationDialog({
    required String title,
    required String message,
  }) async {
    return await Get.defaultDialog(
      contentPadding: const EdgeInsets.all(16),
      title: title,
      middleText: message,
      barrierDismissible: false,
      confirm: ElevatedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(true),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Text("Xóa"),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(false),
        child: const Text("Quay lại"),
      ),
    ).then((value) => value == true);
  }
}
