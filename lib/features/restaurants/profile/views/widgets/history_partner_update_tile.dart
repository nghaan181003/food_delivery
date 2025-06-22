import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/update_request/models/update_request.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/formatter/formatter.dart';
import 'package:food_delivery_h2d/utils/helpers/status_helper.dart';

class HistoryPartnerUpdateTile extends StatelessWidget {
  final UpdateRequest request;

  const HistoryPartnerUpdateTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: MySizes.sm),
      child: SizedBox(
        child: Card(
          elevation: 2,
          shadowColor: MyColors.darkPrimaryColor,
          child: Padding(
              padding: const EdgeInsets.only(
                  top: MySizes.md,
                  right: MySizes.md,
                  left: MySizes.md,
                  bottom: MySizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(MySizes.borderRadiusLg),
                          color: StatusHelper
                                  .updateRequestStatusColors[request.status] ??
                              MyColors.darkPrimaryTextColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: MySizes.xs,
                              bottom: MySizes.xs,
                              left: MySizes.md,
                              right: MySizes.md),
                          child: Text(
                            StatusHelper.updateRequestStatus[request.status] ??
                                "Không xác định",
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                      ),
                      Text(MyFormatter.formatDateTime(request.createdAt))
                    ],
                  ),
                  const SizedBox(height: MySizes.md),
                  Center(
                    child: Text(
                      "Các thông tin yêu cầu cập nhật",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: MyColors.primaryTextColor),
                    ),
                  ),
                  const SizedBox(
                    height: MySizes.md,
                  ),
                  ...request.updatedFields.entries.map((entry) {
                    if (entry.key == 'avatarUrl' || entry.key == 'storeFront') {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: MySizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _mapFieldName(entry.key),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(color: MyColors.secondaryTextColor),
                            ),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(MySizes.borderRadiusMd),
                              child: CachedNetworkImage(
                                imageUrl: entry.value,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: MySizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _mapFieldName(entry.key),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(color: MyColors.secondaryTextColor),
                            ),
                            Text(
                              entry.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .apply(color: MyColors.secondaryTextColor),
                            ),
                          ],
                        ),
                      );
                    }
                  })
                ],
              )),
        ),
      ),
    );
  }

  String _mapFieldName(String key) {
    switch (key) {
      case 'description':
        return 'Mô tả';
      case 'name':
        return 'Tên quán';
      case 'phone':
        return 'Số điện thoại';
      case 'email':
        return 'Email';
      case 'storeFront':
        return 'Ảnh mặt trước';
      case 'avatarUrl':
        return 'Ảnh đại diện';
      default:
        return key;
    }
  }
}
