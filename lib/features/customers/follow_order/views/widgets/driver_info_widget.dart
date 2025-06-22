import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/chat/views/chat_customer.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';
import 'package:food_delivery_h2d/features/shippers/rating/controllers/driver_rating_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:get/get.dart';

class DriverInfoWidget extends StatelessWidget {
  final Rx<Order> currentOrder;
  final DriverRatingController ratingController;

  const DriverInfoWidget(
      {super.key, required this.currentOrder, required this.ratingController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey.shade200,
              child: Obx(
                () => ClipOval(
                  child: currentOrder.value.driverProfileUrl != "Unknown" &&
                          currentOrder.value.driverProfileUrl!.isNotEmpty &&
                          currentOrder.value.driverStatus != "waiting"
                      ? Image.network(
                          currentOrder.value.driverProfileUrl!,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                size: 40, color: Colors.grey);
                          },
                        )
                      : const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    currentOrder.value.driverName == "Unknown" ||
                            currentOrder.value.driverStatus == "waiting"
                        ? "Đang tìm tài xế..."
                        : currentOrder.value.driverName.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.star,
                        color: MyColors.warningColor, size: 18),
                    Obx(() {
                      if (ratingController.value.value == 0.0 &&
                          (currentOrder.value.assignedShipperId != null &&
                              currentOrder.value.assignedShipperId != "" &&
                              currentOrder.value.driverStatus != "waiting")) {
                        ratingController.fetchRating(
                            currentOrder.value.assignedShipperId.toString());
                      }
                      return Text(MyFormatter.formatDouble(
                          ratingController.value.value));
                    }),
                    const SizedBox(width: 8.0),
                    Obx(
                      () => Text(
                        currentOrder.value.driverLicensePlate == "Unknown" ||
                                currentOrder.value.driverStatus == "waiting"
                            ? ""
                            : currentOrder.value.driverLicensePlate.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Spacer(),
            Obx(
              () => currentOrder.value.driverStatus == "waiting"
                  ? const SizedBox()
                  : InkWell(
                      onTap: () {
                        print(
                          '${LoginController.instance.currentUser.userId} ${currentOrder.value.assignedShipperId.toString()}',
                        );

                        Get.to(
                          ChatCustomer(
                            customerId:
                                LoginController.instance.currentUser.userId,
                            driverId:
                                currentOrder.value.assignedShipperId.toString(),
                            currentUserId:
                                LoginController.instance.currentUser.userId,
                            driverName:
                                currentOrder.value.driverName.toString(),
                            driverImage:
                                currentOrder.value.driverProfileUrl.toString(),
                            orderId: currentOrder.value.id,
                          ),
                        );
                      },
                      child: Image.asset(
                        MyImagePaths.iconChat,
                        width: 22,
                        height: 22,
                      ),
                    ),
            )
          ],
        ),
      ],
    );
  }
}
