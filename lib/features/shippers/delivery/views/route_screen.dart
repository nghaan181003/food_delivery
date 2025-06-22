import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/converter/order_to_steps.dart';
import 'package:food_delivery_h2d/features/shippers/delivery/models/delivery_step.dart';
import 'package:food_delivery_h2d/features/shippers/home/models/order_model.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key, required this.orders});

  final List<Order> orders;

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late final List<DeliveryStep> steps;

  @override
  void initState() {
    super.initState();
    steps = convertOrdersToDeliverySteps(widget.orders);
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      appBar: const CustomAppBar(
        title: Text("Lộ trình"),
      ),
      body: ListView.separated(
        itemCount: steps.length,
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final step = steps[index];
          return InkWell(
              onTap: () {
                showStepProgressDialog(
                  context: context,
                  currentStep: 5,
                  totalSteps: 6,
                  minutesLate: 17,
                  onContinue: () {
                    Navigator.pop(context);
                    // Tiếp tục logic sau bước này
                  },
                );
              },
              child: DeliveryStepCard(step: step));
        },
      ),
    );
  }
}

class DeliveryStepCard extends StatelessWidget {
  final DeliveryStep step;

  const DeliveryStepCard({required this.step});

  String getPrefixLabel() {
    return "${step.type.toPrefixLabel}: ";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: step.isActive ? Colors.orange.shade50 : Colors.grey.shade100,
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: step.type.toColor,
            child: Text(step.index.toString())

            // Icon(
            //   step.type.toIconData,
            //   color: Colors.white,
            //   size: 20,
            // ),
            ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              TextSpan(
                  text: "${getPrefixLabel()} ${step.name}  ",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "\nMã: ${step.orderId.replaceRange(5, step.orderId.length - 1, '****')}"),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("** ${step.address}", style: const TextStyle(fontSize: 13)),
            // if (step.note != null)
            //   Padding(
            //     padding: const EdgeInsets.only(top: 4),
            //     child: Text(step.note!,
            //         style: TextStyle(color: Colors.red, fontSize: 12)),
            //   ),
            // Row(
            //   children: [
            //     Icon(Icons.timer, size: 16, color: Colors.grey),
            //     SizedBox(width: 4),
            //     Text("còn ${step.minutesLeft} phút để giao",
            //         style: TextStyle(color: Colors.green)),
            //   ],
            // )
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}

void showStepProgressDialog({
  required BuildContext context,
  required int currentStep,
  required int totalSteps,
  required int minutesLate,
  required VoidCallback onContinue,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🚚 Image or icon
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Icon(Icons.delivery_dining,
                    size: 48, color: Colors.redAccent),
              ),

              // 🔢 Step progress bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSteps, (index) {
                  final step = index + 1;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          step == currentStep ? Colors.red : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$step',
                      style: TextStyle(
                        color:
                            step == currentStep ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // 📄 Step text
              Text(
                "Bạn đã hoàn thành bước số $currentStep",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // ⏱️ Status
              Text(
                "Bạn còn ${totalSteps - currentStep} bước cần hoàn thành. "
                "Bạn đang giao muộn ${minutesLate} phút.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // 🔘 Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text("Tiếp tục", style: TextStyle(fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
