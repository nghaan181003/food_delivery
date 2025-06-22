import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/common/widgets/images/circular_image.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/mobile_wrapper.dart';
import 'package:food_delivery_h2d/common/widgets/text_field/my_text_filed.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/controller/create_discount_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/dicount_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_type.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/view/applies_to_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/context_extension.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CreateDiscountScreen extends StatefulWidget {
  const CreateDiscountScreen({super.key});

  @override
  State<CreateDiscountScreen> createState() => _CreateDiscountScreenState();
}

class _CreateDiscountScreenState extends State<CreateDiscountScreen> {
  late final _minOrderValue;
  late final _itemPerOrderValue;
  late final _maxItemsPerOrderValue;
  late final _maxItemsPerDay;
  late final _maxPerItemPerUserPerDay;
  late final _discountValue;

  final ValueNotifier<DiscountType> _discountType =
      ValueNotifier<DiscountType>(DiscountType.percentage);

  final ValueNotifier<DiscountAppliesTo> _isAllMenu =
      ValueNotifier<DiscountAppliesTo>(DiscountAppliesTo.specific);

  final ValueNotifier<DateTime?> _startDate = ValueNotifier<DateTime?>(null);

  final ValueNotifier<DateTime?> _fromDate = ValueNotifier<DateTime?>(null);

  late final ValueNotifier<List<String>> _selectProductIdxNotifier;

  final discountController = Get.put(CreateDiscountController());

  @override
  void initState() {
    _minOrderValue = TextEditingController();
    _itemPerOrderValue = TextEditingController();
    _maxItemsPerOrderValue = TextEditingController();
    _maxItemsPerDay = TextEditingController();
    _maxPerItemPerUserPerDay = TextEditingController();
    _discountValue = TextEditingController();
    _selectProductIdxNotifier = ValueNotifier([]); // ? replace to existing idx

    super.initState();
  }

  DiscountModel get toDiscountModel => DiscountModel(
      type: _discountType.value,
      name: "Khuyến mãi gạch giá",
      appliesTo: _isAllMenu.value,
      value: MyFormatter.parseFormattedStringToInt(_discountValue.text),
      startDate: _startDate.value ?? DateTime.now(),
      endDate: _fromDate.value ?? DateTime.now(),
      productIdx: _selectProductIdxNotifier.value);

  Widget _buildContainer({Widget? child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(MySizes.sm),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1))
          ]),
      child: child,
    );
  }

  Widget _buildPromotionInstruction() {
    return Container(
      padding: const EdgeInsets.all(MySizes.sm),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MySizes.borderRadiusSm),
          color: MyColors.accentColor.withOpacity(0.3)),
      child: const Row(
        children: [
          MyCircularImage(
            width: 40,
            height: 40,
            image: MyImagePaths.notiIcon,
          ),
          SizedBox(
            width: MySizes.sm,
          ),
          Expanded(
            child: Text(
                textAlign: TextAlign.justify,
                "Cài đặt khuyến mãi theo phần trăm hay số tiền cho các món, Bạn có thể áp dụng khuyến mãi cho cả menu hoặc không"),
          ),
        ],
      ),
    );
  }

  Widget _buidRowWithLabel({required String title, required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        child
      ],
    );
  }

  Widget _builDiscountDate() {
    return _buildContainer(
        child: Column(
      children: [
        InkWell(
          onTap: () async {
            final date = await context.showModalSelectDateTime(
                dateTitle: 'Ngày bắt đầu',
                timeTitle: 'Thời gian bắt đầu',
                initialDateTime: _startDate.value);
            _startDate.value = date;
          },
          child: ValueListenableBuilder(
            valueListenable: _startDate,
            builder: (context, value, child) => _buidRowWithLabel(
                title: "Thời gian bắt đầu *",
                child: value != null
                    ? Text(value.formatDMY_HM)
                    : const Row(
                        children: [
                          Text("Thời gian bắt đầu"),
                          SizedBox(
                            width: MySizes.sm,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: MyColors.dividerColor,
                          )
                        ],
                      )),
          ),
        ),
        InkWell(
          onTap: () async {
            final date = await context.showModalSelectDateTime(
                dateTitle: 'Ngày kết thúc',
                timeTitle: 'Thời gian kết thúc',
                initialDateTime: _fromDate.value);
            _fromDate.value = date;
          },
          child: ValueListenableBuilder(
            valueListenable: _fromDate,
            builder: (context, value, child) => _buidRowWithLabel(
                title: "Thời gian kết thúc *",
                child: value != null
                    ? Text(value.formatDMY_HM)
                    : const Row(
                        children: [
                          Text("Thời gian kết thúc"),
                          SizedBox(
                            width: MySizes.sm,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: MyColors.dividerColor,
                          )
                        ],
                      )),
          ),
        )
      ]
          .expand((e) =>
              [e, const Divider(color: MyColors.dividerColor, thickness: 0.1)])
          .toList()
        ..removeLast(),
    ));
  }

  Widget _buildDiscountInfor() {
    return _buildContainer(
        child: Column(
      children: [
        _buidRowWithLabel(
            title: "Tên khuyến mãi", child: const Text("Khuyến mãi gạch giá")),
        _buidRowWithLabel(
            title: "Loại khuyến mãi",
            child: ValueListenableBuilder(
              valueListenable: _discountType,
              builder:
                  (BuildContext context, DiscountType value, Widget? child) {
                return Row(
                  children: DiscountType.values
                      .map(
                        (e) => e.toWidget(
                            groupValue: _discountType.value,
                            onChanged: (value) {
                              if (value != null) {
                                _discountType.value = value;
                                _discountValue.text = "";
                              }
                            }),
                      )
                      .toList(),
                );
              },
            )),
        ValueListenableBuilder(
          valueListenable: _discountType,
          builder: (BuildContext context, DiscountType value, Widget? child) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (value.ispercentage)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        spacing: 20,
                        children: [5, 10, 15, 20, 25].map((percent) {
                          return GestureDetector(
                            onTap: () {
                              _discountValue.text = percent.toString();
                            },
                            child: Chip(
                              label: Text("$percent%"),
                              side: const BorderSide(
                                  color: MyColors.dividerColor),
                              backgroundColor:
                                  MyColors.lightPrimaryColor.withOpacity(0.1),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  _buidRowWithLabel(
                    title: value.ispercentage
                        ? "Phần trăm chiết khấu (%)"
                        : "Giá trị sau giảm (VND)",
                    child: Expanded(
                      child: MyTextFiled(
                        isNumberType: true,
                        textController: _discountValue,
                        hintText: value.ispercentage ? "0%" : "0 VND",
                      ),
                    ),
                  ),
                ]);
          },
        ),
      ]
          .expand((e) =>
              [e, const Divider(color: MyColors.dividerColor, thickness: 0.1)])
          .toList()
        ..removeLast(),
    ));
  }

  Widget _buildDiscountSetting() {
    return _buildContainer(
      child: ValueListenableBuilder(
        valueListenable: _isAllMenu,
        builder:
            (BuildContext context, DiscountAppliesTo value, Widget? child) {
          return Column(
            children: [
              _buidRowWithLabel(
                title: "Áp dụng toàn menu",
                child: Row(
                  children: DiscountAppliesTo.values
                      .map(
                        (e) => e.toWidget(
                          groupValue: value,
                          onChanged: (selectedValue) {
                            if (selectedValue != null) {
                              _isAllMenu.value = selectedValue;
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(
                height: MySizes.sm,
              ),
              if (value.isSpecific)
                InkWell(
                  onTap: () async {
                    final selectedProduct = await Get.to(() => AppliesToScreen(
                          selectProductIdx: _selectProductIdxNotifier.value,
                        ));

                    if (selectedProduct is List<String>) {
                      _selectProductIdxNotifier.value = selectedProduct;
                    }
                  },
                  child: ValueListenableBuilder<List<String>>(
                      valueListenable: _selectProductIdxNotifier,
                      builder: (context, selectedProduct, _) {
                        final title = selectedProduct.isNotEmpty
                            ? "Đã chọn ${selectedProduct.length}"
                            : "Chọn món để áp dụng";
                        return _buidRowWithLabel(
                          title: "Chọn món để áp dụng",
                          child: Row(
                            children: [
                              Text(title),
                              const SizedBox(width: MySizes.sm),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: MyColors.dividerColor,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      appBar: const CustomAppBar(
        title: Text("Khuyến mãi gạch giá"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.sm),
          child: Column(
            children: [
              _buildPromotionInstruction(),
              _builDiscountDate(),
              _buildDiscountInfor(),
              _buildDiscountSetting()
            ]
                .expand((e) => [
                      e,
                      const SizedBox(
                        height: MySizes.md,
                      )
                    ])
                .toList(),
          ),
        ),
      ),
      bottom: ElevatedButton(
          onPressed: () async {
            if (_startDate.value == null) {
              Loaders.errorSnackBar(
                  title: "Thất bại!",
                  message: "Vui lòng chọn Thời gian bắt đầu");
              return;
            }
            if (_fromDate.value == null) {
              Loaders.errorSnackBar(
                  title: "Thất bại!",
                  message: "Vui lòng chọn Thời gian kết thúc");
              return;
            }
            final result =
                await discountController.createDiscount(toDiscountModel);

            if (result) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("Tạo khuyến mãi")),
    );
  }
}
