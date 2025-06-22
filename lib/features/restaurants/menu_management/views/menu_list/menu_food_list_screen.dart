import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/order/views/order_list/widgets/tab_item.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/update_menu_food_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/category_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/arrange_category/arrange_category_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/category_list/category_list_screen.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_food_detail/menu_food_detail.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/widgets/menu_food_tile.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/views/menu_list/widgets/menu_search_bar.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/controller/topping_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/view/topping_group_list.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/controllers/menu_food_controller.dart';

class MenuFoodListScreen extends StatefulWidget {
  const MenuFoodListScreen({super.key});

  @override
  State<MenuFoodListScreen> createState() => _MenuFoodListScreenState();
}

class _MenuFoodListScreenState extends State<MenuFoodListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuFoodController = Get.put(MenuFoodController());
    final updateMenuFoodController = Get.put(UpdateMenuFoodController());

    Get.lazyPut<ToppingController>(() => ToppingController(), fenix: true);

    Future<void> reloadPage() async {
      menuFoodController.reload();
    }

    Widget _buildItemManagement() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: MySizes.md - 2),
                child: PopupMenuButton(
                    child: const Text("Danh mục món ăn",
                        style: TextStyle(
                          color: MyColors.darkPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.to(const ArrangeCategoryScreen());
                                },
                                child: const Text("Sắp xếp vị trí danh mục")),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.to(const CategoryListScreen());
                                },
                                child: const Text("Chỉnh sửa danh mục")),
                          )
                        ]),
              ),
              TextButton(
                  onPressed: () {
                    updateMenuFoodController.isAdd.value = true;
                    updateMenuFoodController.isEditting.value = false;
                    Get.to(MenuFoodDetailScreen(
                      selectedItem: Item(),
                    ));
                  },
                  child: const Text("Thêm món mới")),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
            child: Divider(
              color: MyColors.dividerColor,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await reloadPage();
              },
              child: Obx(
                () => menuFoodController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: menuFoodController.allCategories.length,
                        itemBuilder: (context, index) {
                          Category category =
                              menuFoodController.allCategories[index];
                          List<Item> categoryItems = menuFoodController
                              .getItemsForCategory(category.categoryId);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: MySizes.sm, left: MySizes.md),
                                child: Text(category.categoryName,
                                    style: const TextStyle(
                                      color: MyColors.darkPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )),
                              ),
                              Column(
                                children: List.generate(categoryItems.length,
                                    (itemIndex) {
                                  Item item = categoryItems[itemIndex];
                                  return MenuFoodTile(item: item);
                                }),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: MySizes.sm,
                                    left: MySizes.sm,
                                    right: MySizes.sm),
                                child: Divider(
                                    color: MyColors.primaryBackgroundColor),
                              )
                            ],
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text('Thực đơn'),
        ),
        body: Column(
          children: [
            // const MenuSearchBar(),
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding:
                  const EdgeInsets.only(left: MySizes.sm, right: MySizes.sm),
              tabs: const [
                TabItem(title: "Món"),
                TabItem(title: "Nhóm Topping"),
              ],
            ),
            Expanded(
                child: TabBarView(controller: _tabController, children: [
              _buildItemManagement(),
              _buildToppingManagementTab()
            ])),
          ],
        ),
      ),
    );
  }

  Widget _buildToppingManagementTab() {
    if (!Get.isRegistered<ToppingController>()) {
      Get.put(ToppingController());
    }
    return ToppingGroupList();
  }
}
