import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/layout/listview_layout.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/modules/shop/controller/coupons/coupons_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';

class CouponsForm extends StatelessWidget {
  const CouponsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = CouponsController.instance;
    return Obx(
      () {
        if (controller.isLoading.value) {
          return const Column(
            children: [
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
            ],
          );
        } else {
          final ScrollController scrollController = ScrollController();
          return SizedBox(
            height: TDeviceUtils.getScreenHeight() * 0.52,
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: TListView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: controller.couponsTransaction.length,
                  itemBuilder: (context, index) {
                    final couponsItem = controller.couponsTransaction[index];
                    return Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 8),
                        child: TRoundedContainer(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.all(8),
                            leading: const TRoundedContainer(
                                padding: EdgeInsets.all(8),
                                backgroundColor: TColors.lightContainer,
                                child: TRoundedImage(
                                    image: TImages.icoWasher,
                                    applyImageRadius: false,
                                    imageType: ImageType.asset)),
                            title: Text(
                              couponsItem.code.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(fontSizeDelta: 1),
                            ),
                            subtitle: Text(
                              couponsItem.formattedRedeemedDate,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            trailing: Text(
                              '+ ${couponsItem.points}\$',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: TColors.success),
                            ),
                          ),
                        ));
                  }),
            ),
          );
        }
      },
    );
  }
}
