import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/modules/shop/controller/order/order_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/device/device_utility.dart';
import 'package:laundry_mobile/app/common/widgets/shimmers/shimmer_effect.dart';

class OrderSingleForm extends StatelessWidget {
  const OrderSingleForm({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = OrderController.instance;
    controller.fetchUserSingleOrders(user.id!);

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Obx(() {
        if (controller.isLoadingFetchAll.value) {
          return TShimmerEffect(
            width: TDeviceUtils.getScreenWidth(context) * 0.89,
            height: TDeviceUtils.getScreenHeight() * 0.4,
          );
        }

        final userOrders =
            controller.order.where((order) => order.userId == user.id).toList();

        if (userOrders.isEmpty) {
          return const Center(child: Text('No orders found for this user'));
        }

        final pageCount = (userOrders.length / controller.rowsPerPage).ceil();
        final pagedOrders = userOrders
            .skip(controller.currentPage.value * controller.rowsPerPage)
            .take(controller.rowsPerPage)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 24.0,
                headingRowHeight: 60.0,
                dividerThickness: 0,
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => TColors.white),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: TColors.black,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: TColors.grey,
                    width: 1.0,
                  ),
                ),
                columns: [
                  DataColumn(label: Text('Order ID'.toUpperCase())),
                  DataColumn(label: Text('Date'.toUpperCase())),
                  DataColumn(label: Text('Product'.toUpperCase())),
                  DataColumn(label: Text('Price'.toUpperCase())),
                ],
                rows: pagedOrders.map((order) {
                  return DataRow(
                    cells: [
                      DataCell(Text(order.id)),
                      DataCell(Text(order.formattedOrderDate)),
                      DataCell(Text(order.name)),
                      DataCell(Text(order.price.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: controller.currentPage.value > 0
                      ? () => controller.currentPage.value--
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Previous'),
                ),
                const SizedBox(width: 16.0),
                Text(
                  'Page ${controller.currentPage.value + 1} of $pageCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 16.0),
                TextButton(
                  onPressed: controller.currentPage.value < pageCount - 1
                      ? () => controller.currentPage.value++
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
