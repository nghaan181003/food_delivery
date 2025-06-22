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
import 'package:food_delivery_h2d/features/restaurants/voucher_management/controller/create_voucher_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_applies_to.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_public.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_type.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/extension/context_extension.dart';
import 'package:food_delivery_h2d/utils/extension/date_extension.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

import 'package:food_delivery_h2d/utils/formatter/currency.dart';

class CreateVoucherScreen extends StatefulWidget {
  const CreateVoucherScreen({super.key, this.voucher});

  final VoucherModel? voucher;

  @override
  State<CreateVoucherScreen> createState() => _CreateVoucherScreenState();
}

class _CreateVoucherScreenState extends State<CreateVoucherScreen> {
  late final _minOrderValue;
  late final _discountValue;
  late final _name;
  late final _code;
  late final _quantity;
  late final _maxUsersPerUser;

  late final ValueNotifier<VoucherType> _voucherType;

  late final ValueNotifier<VoucherAppliesTo> _isAllMenu;

  late final ValueNotifier<DateTime?> _startDate;
  late final ValueNotifier<DateTime?> _fromDate;
  late final ValueNotifier<List<String>> _selectProductIdxNotifier;

  final voucherController = Get.put(CreateVoucherController());

  late final ValueNotifier<VoucherPublic> _isPublic;

  @override
  void initState() {
    _minOrderValue =
        TextEditingController(text: widget.voucher?.minOrdervalue?.toString());
    _discountValue =
        TextEditingController(text: widget.voucher?.value?.toString());
    _selectProductIdxNotifier = ValueNotifier(
        widget.voucher?.productIdx ?? []); // ? replace to existing idx
    _name = TextEditingController(text: widget.voucher?.name ?? "");
    _code = TextEditingController(text: widget.voucher?.code);
    _quantity =
        TextEditingController(text: widget.voucher?.quantity?.toString());
    _maxUsersPerUser = TextEditingController(
        text: widget.voucher?.maxUsersPerUser?.toString() ?? "");
    _isPublic = ValueNotifier<VoucherPublic>(
      (widget.voucher?.isPublic ?? false)
          ? VoucherPublic.yes
          : VoucherPublic.no,
    );
    _startDate = ValueNotifier<DateTime?>(widget.voucher?.startDate);
    _fromDate = ValueNotifier<DateTime?>(widget.voucher?.endDate);
    _voucherType = ValueNotifier<VoucherType>(
        widget.voucher?.type ?? VoucherType.percentage);
    _isAllMenu = ValueNotifier<VoucherAppliesTo>(
        widget.voucher?.appliesTo ?? VoucherAppliesTo.all);

    super.initState();
  }

  bool get isEditMode => widget.voucher != null;

  VoucherModel get toVoucherModel {
    return VoucherModel(
      id: widget.voucher?.id,
      type: _voucherType.value,
      name: _name.text,
      code: _code.text,
      minOrdervalue: MyFormatter.parseFormattedStringToInt(_minOrderValue.text),
      maxUsersPerUser:
          MyFormatter.parseFormattedStringToInt(_maxUsersPerUser.text),
      quantity: MyFormatter.parseFormattedStringToInt(_quantity.text),
      appliesTo: _isAllMenu.value,
      value: MyFormatter.parseFormattedStringToInt(_discountValue.text),
      startDate: _startDate.value ?? DateTime.now(),
      endDate: _fromDate.value ?? DateTime.now(),
      productIdx: _selectProductIdxNotifier.value,
      isPublic: _isPublic.value.toDbBool,
    );
  }

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

  Widget _builVoucherDate() {
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

  Widget _buildVoucherInfor() {
    return _buildContainer(
        child: Column(
      children: [
        // _buidRowWithLabel(
        //     title: "Tên khuyến mãi", child: const Text("Khuyến mãi gạch giá")),

        _buidRowWithLabel(
            title: "Tên voucher *",
            child: Expanded(
                child: MyTextFiled(
                    textController: _name, hintText: "Nhập tên voucher"))),

        _buidRowWithLabel(
            title: "Mã voucher *",
            child: Expanded(
                child: MyTextFiled(
                    textController: _code, hintText: "VD: voucher123"))),
        _buidRowWithLabel(
            title: "Loại voucher",
            child: ValueListenableBuilder(
              valueListenable: _voucherType,
              builder:
                  (BuildContext context, VoucherType value, Widget? child) {
                return Row(
                  children: VoucherType.values
                      .map(
                        (e) => e.toWidget(
                            groupValue: _voucherType.value,
                            onChanged: (value) {
                              if (value != null) {
                                _voucherType.value = value;
                                _discountValue.text = "";
                              }
                            }),
                      )
                      .toList(),
                );
              },
            )),
        ValueListenableBuilder(
          valueListenable: _voucherType,
          builder: (BuildContext context, VoucherType value, Widget? child) {
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
                        useThousandsFormatter: false,
                        textController: _discountValue,
                        hintText: value.ispercentage ? "0%" : "0 VND",
                      ),
                    ),
                  ),
                ]);
          },
        ),
        _buidRowWithLabel(
            title: "Giá trị đơn hàng tối thiểu",
            child: Expanded(
                child: MyTextFiled(
                    isNumberType: true,
                    textController: _minOrderValue,
                    hintText: "0 VND"))),
        _buidRowWithLabel(
            title: "Tổng lượt sử dụng tối đa",
            child: Expanded(
                child: MyTextFiled(
                    isNumberType: true,
                    useThousandsFormatter: false,
                    textController: _quantity,
                    hintText: "VD: 0"))),

        _buidRowWithLabel(
            title: "Lượt sử dụng tối đa/khách",
            child: Expanded(
                child: MyTextFiled(
                    isNumberType: true,
                    useThousandsFormatter: false,
                    textController: _maxUsersPerUser,
                    hintText: "VD: 0"))),

        _buidRowWithLabel(
            title: "Thiết lập hiển thị",
            child: ValueListenableBuilder(
              valueListenable: _isPublic,
              builder:
                  (BuildContext context, VoucherPublic value, Widget? child) {
                return Row(
                  children: VoucherPublic.values
                      .map(
                        (e) => e.toWidget(
                            groupValue: _isPublic.value,
                            onChanged: (value) {
                              if (value != null) {
                                _isPublic.value = value;
                              }
                            }),
                      )
                      .toList(),
                );
              },
            )),
      ]
          .expand((e) =>
              [e, const Divider(color: MyColors.dividerColor, thickness: 0.1)])
          .toList()
        ..removeLast(),
    ));
  }

  Widget _buildVoucherSetting() {
    return _buildContainer(
      child: ValueListenableBuilder(
        valueListenable: _isAllMenu,
        builder: (BuildContext context, VoucherAppliesTo value, Widget? child) {
          return Column(
            children: [
              _buidRowWithLabel(
                title: "Áp dụng toàn menu",
                child: Row(
                  children: VoucherAppliesTo.values
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
    final appBarTitleText = isEditMode ? "Chỉnh sửa voucher" : "Tạo voucher";
    return MobileWrapper(
      appBar: CustomAppBar(
        title: Text(appBarTitleText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.sm),
          child: Column(
            children: [
              _buildPromotionInstruction(),
              _builVoucherDate(),
              _buildVoucherInfor(),
              _buildVoucherSetting()
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
                await voucherController.createVoucher(toVoucherModel);

            if (result) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("Lưu")),
    );
  }
}
