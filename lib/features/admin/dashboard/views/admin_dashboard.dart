import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/daily_order_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/daily_revenue_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/line_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/list_item.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/order_status_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/pie_chart.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/widgets/top_item_bar_chart.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WebLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: ListItemCount(),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 400,
                      child: UserRoleChart(),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 400,
                      child: OrderStatusChart(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 400, child: StatisticLineChart()),
            const SizedBox(height: 510, child: TopItemBarChart()),
            SizedBox(height: 500, child: DailyRevenueChart()),
            SizedBox(height: 600, child: DailyOrderChart()),
          ],
        ),
      ),
    );
  }
}
