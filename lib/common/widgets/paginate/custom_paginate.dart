import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/paginate/paginate.dart';

class CustomPaginate extends StatefulWidget {
  final Widget body;
  final Function() fetchFirstData;
  final Function() fetchNextData;
  final XPaginate paginate;

  const CustomPaginate({
    super.key,
    required this.fetchFirstData,
    required this.fetchNextData,
    required this.paginate,
    required this.body,
  });

  @override
  State<CustomPaginate> createState() => _CustomPaginateState();
}

class _CustomPaginateState extends State<CustomPaginate> {
  late final ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();
    controller.addListener(_scrollListener);
    widget.fetchFirstData();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      widget.fetchNextData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paginate = widget.paginate;

    if (paginate.isInitial) {
      return const Text("Khởi tạo...");
    }

    if (paginate.isError) {
      return Text("Vui lòng thử lại sau");
    }

    return RefreshIndicator(
      onRefresh: () async => widget.fetchFirstData(),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if ((paginate.data ?? []).isEmpty) const SizedBox() else widget.body,
          if (paginate.isLoading)
            const Text(
              'Loading',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
            ),
        ],
      ),
    );
  }
}
