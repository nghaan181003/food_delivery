import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/search/views/widgets/item_search_tile.dart';
import 'package:food_delivery_h2d/features/customers/search/views/widgets/widget_search_bar.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/features/customers/search/controllers/search_items_controller.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    final FocusNode searchFocusNode = FocusNode();
    final SearchItemsController searchItemsController =
        Get.put(SearchItemsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });

    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 65,
        showBackArrow: true,
        title: Row(
          children: [
            Expanded(
              child: WidgetSearchBar(
                controller: searchController,
                focusNode: searchFocusNode,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: MySizes.sm),
            child: IconButton(
              onPressed: () {
                final query = searchController.text.trim();
                if (query.isNotEmpty) {
                  searchItemsController.fetchItemSearch(query);
                }
              },
              icon: const Icon(
                Icons.search,
                size: MySizes.iconMd,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (searchItemsController.isLoading.value && searchItemsController.isSearchCompleted.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (searchItemsController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(searchItemsController.errorMessage.value),
          );
        } else if (searchItemsController.itemSearchList.isEmpty && 
                   searchItemsController.isSearchCompleted.value) {
          return const Center(
            child: Text("Không có món ăn này. Vui lòng tìm món khác"),
          );
        } else {
          return ListView.builder(
            itemCount: searchItemsController.itemSearchList.length,
            itemBuilder: (context, index) {
              final item = searchItemsController.itemSearchList[index];
              return ItemSearchTile(item: item); 
            },
          );
        }
      }),
    );
  }
}
