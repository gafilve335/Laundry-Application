import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: TColors.primary),
        backgroundColor: isDark ? TColors.black : TColors.white,
        automaticallyImplyLeading: true,
        title: Text('Privacy & Policy',
            style: Theme.of(context).textTheme.headlineSmall),
        centerTitle: false,
      ),
      body: FutureBuilder(
        future: rootBundle.loadString('assets/privacy_md/privacy_policy.md'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final privacyPolicyText = snapshot.data;
            if (privacyPolicyText != null) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(TSizes.md),
                child: Text(privacyPolicyText),
              );
            } else {
              return const Center(
                  child: Text('Privacy Policy is not available.'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
