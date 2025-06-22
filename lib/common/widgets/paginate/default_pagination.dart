// import 'dart:async';

// import 'package:flutter/material.dart';

// class DefaultPagination<T> extends StatefulWidget {
//   final Widget Function(BuildContext context, int index) itemBuilder;
//   final List<T> items;
//   final bool loading;
//   final Function() listenScrollBottom;
//   final Widget? skeleton;

//   final ScrollPhysics? physics;
//   final Widget? loadingWidget;

//   final Widget? separator;

//   const DefaultPagination({
//     super.key,
//     this.physics,
//     this.loadingWidget,
//     this.skeleton,
//     this.separator,
//     required this.items,
//     required this.loading,
//     required this.itemBuilder,
//     required this.listenScrollBottom,
//   });

//   @override
//   State<DefaultPagination<T>> createState() => _DefaultPaginationState<T>();
// }

// class _DefaultPaginationState<T> extends State<DefaultPagination<T>> {
//   ScrollController? _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController?.addListener(_listenScroll);
//   }

//   void _listenScroll() {
//     if (_scrollController!.position.atEdge) {
//       if (_scrollController!.position.pixels != 0) {
//         widget.listenScrollBottom();
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _scrollController?.removeListener(_listenScroll);
//     _scrollController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       physics: widget.physics ??
//           const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
//       controller: _scrollController,
//       itemCount: widget.items.length + 1,
//       itemBuilder: (context, index) {
//         if (index < widget.items.length) {
//           return widget.itemBuilder(context, index);
//         }
//         // if (index >= widget.items.length && (widget.loading)) {
//         //   Timer(const Duration(milliseconds: 30), () {
//         //     _scrollController!.jumpTo(
//         //       _scrollController!.position.maxScrollExtent,
//         //     );
//         //   });
//         //   return Padding(
//         //     padding: const EdgeInsets.symmetric(vertical: 20.0),
//         //     child: widget.loadingWidget ??
//         //         Center(child: CircularProgressIndicator()),
//         //   );
//         // }
//         return const SizedBox();
//       },
//       separatorBuilder: (BuildContext context, int index) =>
//           widget.separator ?? const SizedBox(),
//     );
//   }
// }

import 'package:flutter/material.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item, int index);

class PaginatedList<T> extends StatefulWidget {
  final Function() fetchFirstData; // Hàm gọi để lấy dữ liệu lần đầu
  final Function() fetchNextData; // Hàm gọi để lấy dữ liệu khi load thêm
  final List<T> items; // Danh sách dữ liệu
  final ItemBuilder<T> itemBuilder; // Hàm tạo widget cho từng item
  final bool isLoading; // Trạng thái loading
  final bool isError; // Trạng thái lỗi

  const PaginatedList({
    super.key,
    required this.fetchFirstData,
    required this.fetchNextData,
    required this.items,
    required this.itemBuilder,
    required this.isLoading,
    required this.isError,
  });

  @override
  _PaginatedListState<T> createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList<T>> {
  late final ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(_scrollListener);
    widget.fetchFirstData();
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
    if (widget.isError) {
      return Center(child: Text('Vui lòng thử lại sau.'));
    }

    return RefreshIndicator(
      onRefresh: () async => widget.fetchFirstData(),
      child: ListView.builder(
        controller: controller,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.items.length + (widget.isLoading ? 1 : 0), // Thêm 1 item cho loading indicator
        itemBuilder: (context, index) {
          if (index < widget.items.length) {
            return widget.itemBuilder(context, widget.items[index], index);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}

