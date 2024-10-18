import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/layout/listview_layout.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/common/widgets/image/rounded_image.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';
import 'package:laundry_mobile/app/modules/shop/controller/order/order_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';

class WalletTransactionFrom extends StatelessWidget {
  const WalletTransactionFrom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final order = OrderController.instance;
    return Obx(() {
      if (order.isLoading.value) {
        return const Center(
          child: Column(
            children: [
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
              SizedBox(height: 10),
              TShimmerEffect(width: 400, height: 90),
            ],
          ),
        );
      }
      if (order.order.isEmpty) {
        return const Center(child: Text('Data Not found'));
      }
      final ScrollController scrollController = ScrollController();
      return Column(
        children: [
          SizedBox(
            height: 500,
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: TListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: order.order.length,
                itemBuilder: (context, index) {
                  final orderItem = order.order[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 22, right: 22, bottom: 8),
                    child: TRoundedContainer(
                      radius: 5,
                      height: 90,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const TRoundedContainer(
                              padding: EdgeInsets.all(1),
                              child: TRoundedImage(
                                applyImageRadius: false,
                                image: TImages.icoWasher,
                                imageType: ImageType.asset,
                              ),
                            ),
                            title: Text(
                              orderItem.paymentMethod.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .apply(fontSizeDelta: 1),
                            ),
                            subtitle: Text(
                              orderItem.formattedOrderDate,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            trailing: Text(
                              '- ${orderItem.price}\$',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .apply(color: TColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }
}
