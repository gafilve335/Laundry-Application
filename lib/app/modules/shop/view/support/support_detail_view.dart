import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/container/rounded_container.dart';
import 'package:laundry_mobile/app/modules/shop/controller/support/support_controller.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';

class SupportDetailView extends StatelessWidget {
  const SupportDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SupportController());

    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          "Support Detail".toUpperCase(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Issues'.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.supportData.isEmpty) {
                return const Center(child: Text('Data Not found'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.supportData.length,
                    padding: const EdgeInsets.only(top: 8),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final supportItem = controller.supportData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          child: TRoundedContainer(
                            backgroundColor: Colors.white,
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: TColors.primary,
                                    child: Icon(
                                      Icons.support_agent,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          supportItem.brand,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          supportItem.fingerprint,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: TColors.primary,
                                    ),
                                    onPressed: () {
                                      // เปิด Modal Bottom Sheet แสดงรายละเอียด support item
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return DraggableScrollableSheet(
                                            expand: false,
                                            initialChildSize: 0.7,
                                            maxChildSize: 0.9,
                                            minChildSize: 0.5,
                                            builder:
                                                (context, scrollController) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SingleChildScrollView(
                                                  controller: scrollController,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        supportItem.brand
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Text(
                                                          'Report:'
                                                              .toUpperCase(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        supportItem.report,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Text(
                                                          'Fingerprint:'
                                                              .toUpperCase(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        supportItem.fingerprint,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                          'Date:'.toUpperCase(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        supportItem.reportDate
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
