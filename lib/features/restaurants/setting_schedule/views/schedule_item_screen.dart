import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/setting_schedule/controllers/schedule_item_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/schedule_helper.dart';
import 'package:get/get.dart';

class ScheduleItemScreen extends StatefulWidget {
  final String id;
  const ScheduleItemScreen({super.key, required this.id});

  @override
  State<ScheduleItemScreen> createState() => _ScheduleItemScreenState();
}

class _ScheduleItemScreenState extends State<ScheduleItemScreen> {
  final scheduleController = Get.put(ScheduleItemController());

  final List<String> allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  Set<String> daysAllDay = {};
  @override
  void initState() {
    super.initState();
    scheduleController.fetchItemById(widget.id).then((_) {
      final item = scheduleController.item.value;
      if (item != null) {
        for (var daySchedule in item.schedule) {
          if (daySchedule.timeSlots.length == 1) {
            final slot = daySchedule.timeSlots.first;
            if (slot.open == "00:00" && slot.close == "23:59") {
              daysAllDay.add(daySchedule.day);
            }
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text("Lịch bán món")),
      body: Obx(() {
        final partner = scheduleController.item.value;

        if (partner == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final mapSchedule = {for (var d in partner.schedule) d.day: d};

        final List<DaySchedule> schedule = allDays.map((day) {
          return mapSchedule[day] ?? DaySchedule(day: day, timeSlots: []);
        }).toList();

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final daySchedule = schedule[index];
                  final isAllDay = daysAllDay.contains(daySchedule.day);

                  return Card(
                    margin: const EdgeInsets.all(MySizes.sm),
                    child: Padding(
                      padding: const EdgeInsets.all(MySizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ScheduleHelper.translateDayToVietnamese(
                                daySchedule.day),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: MySizes.sm),
                          RadioListTile<bool>(
                            title: const Text('Cả ngày'),
                            value: true,
                            groupValue: isAllDay,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  daysAllDay.add(daySchedule.day);
                                }
                              });
                            },
                          ),
                          RadioListTile<bool>(
                            title: const Text('Chọn khung giờ'),
                            value: false,
                            groupValue: isAllDay,
                            onChanged: (val) {
                              setState(() {
                                if (val == false) {
                                  daysAllDay.remove(daySchedule.day);
                                }
                              });
                            },
                          ),
                          const SizedBox(height: MySizes.sm),
                          if (isAllDay)
                            const SizedBox(
                              width: 4,
                            )
                          else if (daySchedule.timeSlots.isEmpty)
                            const Text(
                              "Chưa có khung giờ",
                              style: TextStyle(color: Colors.grey),
                            )
                          else
                            ...daySchedule.timeSlots
                                .asMap()
                                .entries
                                .map((entry) {
                              final slotIndex = entry.key;
                              final slot = entry.value;
                              return Padding(
                                padding: const EdgeInsets.all(MySizes.sm),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final newTime =
                                              await pickTimeCupertino(
                                                  context, slot.open);
                                          if (newTime != null) {
                                            setState(() {
                                              slot.open = newTime;
                                            });
                                          }
                                        },
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                              labelText: 'Giờ mở'),
                                          child: Text(slot.open),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: MySizes.sm),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          final newTime =
                                              await pickTimeCupertino(
                                                  context, slot.close);
                                          if (newTime != null) {
                                            setState(() {
                                              slot.close = newTime;
                                            });
                                          }
                                        },
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                              labelText: 'Giờ đóng'),
                                          child: Text(slot.close),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      onPressed: () {
                                        setState(() {
                                          daySchedule.timeSlots
                                              .removeAt(slotIndex);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          if (!isAllDay)
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () async {
                                  final newSlot =
                                      await showAddTimeSlotDialog(context);
                                  if (newSlot != null) {
                                    setState(() {
                                      final scheduleList = scheduleController
                                          .item.value!.schedule;
                                      final existing =
                                          scheduleList.firstWhereOrNull(
                                              (s) => s.day == daySchedule.day);

                                      if (existing != null) {
                                        existing.timeSlots.add(newSlot);
                                      } else {
                                        scheduleList.add(DaySchedule(
                                            day: daySchedule.day,
                                            timeSlots: [newSlot]));
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Thêm khung giờ"),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Lưu"),
                onPressed: () async {
                  final currentSchedule =
                      scheduleController.item.value?.schedule ?? [];

                  final List<DaySchedule> scheduleToSave = allDays.map((day) {
                    final origin =
                        currentSchedule.firstWhereOrNull((s) => s.day == day);

                    if (daysAllDay.contains(day)) {
                      return DaySchedule(
                          day: day,
                          timeSlots: [TimeSlot(open: "00:00", close: "23:59")]);
                    } else {
                      if (origin != null) {
                        return DaySchedule(
                            day: day, timeSlots: List.from(origin.timeSlots));
                      } else {
                        return DaySchedule(day: day, timeSlots: []);
                      }
                    }
                  }).toList();
                  for (final day in currentSchedule) {
                    if (isOverlapping(day.timeSlots)) {
                      Get.snackbar(
                          isDismissible: true,
                          shouldIconPulse: true,
                          colorText: Colors.white,
                          backgroundColor: MyColors.errorColor,
                          margin: const EdgeInsets.all(10),
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          "Lỗi",
                          "Khung giờ bị chồng lắp (${ScheduleHelper.translateDayToVietnamese(day.day)})");
                      return;
                    }
                  }
                  await scheduleController.updateSchedule(
                      widget.id, scheduleToSave);
                },
              ),
            )
          ],
        );
      }),
    );
  }

  Future<TimeSlot?> showAddTimeSlotDialog(BuildContext context) async {
    DateTime openDateTime = DateTime(0, 0, 0, 7, 0);
    DateTime closeDateTime = DateTime(0, 0, 0, 21, 0);

    return showDialog<TimeSlot>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Chọn khung giờ'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Giờ mở cửa:"),
                      const SizedBox(width: MySizes.md),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.time,
                            initialDateTime: openDateTime,
                            use24hFormat: true,
                            onDateTimeChanged: (DateTime newTime) {
                              openDateTime = newTime;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        const Text("Giờ đóng cửa:"),
                        const SizedBox(width: MySizes.md),
                        Expanded(
                          child: SizedBox(
                            height: 70,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              initialDateTime: closeDateTime,
                              use24hFormat: true,
                              onDateTimeChanged: (DateTime newTime) {
                                closeDateTime = newTime;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (openDateTime.isAfter(closeDateTime) ||
                        openDateTime.isAtSameMomentAs(closeDateTime)) {
                      Get.snackbar(
                          isDismissible: true,
                          shouldIconPulse: true,
                          colorText: Colors.white,
                          backgroundColor: MyColors.errorColor,
                          margin: const EdgeInsets.all(10),
                          icon: const Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          "Lỗi",
                          "Giờ mở phải nhỏ hơn giờ đóng");
                      return;
                    }

                    final open =
                        TimeOfDay.fromDateTime(openDateTime).format(context);
                    final close =
                        TimeOfDay.fromDateTime(closeDateTime).format(context);

                    Navigator.pop(context, TimeSlot(open: open, close: close));
                  },
                  child: const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> pickTimeCupertino(
      BuildContext context, String initialTimeStr) async {
    final parts = initialTimeStr.split(":");
    DateTime initialDateTime =
        DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));

    DateTime selectedTime = initialDateTime;

    return await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Chọn giờ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime,
                  use24hFormat: true,
                  onDateTimeChanged: (DateTime newTime) {
                    selectedTime = newTime;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final formatted =
                      TimeOfDay.fromDateTime(selectedTime).format(context);
                  Navigator.pop(context, formatted);
                },
                child: const Text("Chọn"),
              )
            ],
          ),
        );
      },
    );
  }

  bool isValidTimeSlot(TimeSlot slot) {
    final openParts = slot.open.split(':').map(int.parse).toList();
    final closeParts = slot.close.split(':').map(int.parse).toList();

    final openMinutes = openParts[0] * 60 + openParts[1];
    final closeMinutes = closeParts[0] * 60 + closeParts[1];

    return openMinutes < closeMinutes;
  }

  bool isOverlapping(List<TimeSlot> slots) {
    List<Map<String, int>> times = slots.map((slot) {
      final open = slot.open.split(':').map(int.parse).toList();
      final close = slot.close.split(':').map(int.parse).toList();
      return {
        'start': open[0] * 60 + open[1],
        'end': close[0] * 60 + close[1],
      };
    }).toList();

    times.sort((a, b) => a['start']!.compareTo(b['start']!));

    for (int i = 1; i < times.length; i++) {
      if (times[i]['start']! < times[i - 1]['end']!) {
        return true;
      }
    }

    return false;
  }
}
