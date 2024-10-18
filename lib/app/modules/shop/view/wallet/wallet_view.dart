import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/common/widgets/texts/section_heading.dart';
import 'package:laundry_mobile/app/modules/shop/view/wallet/widgets/wallet_card.dart';
import 'package:laundry_mobile/app/modules/shop/view/wallet/widgets/wallet_transaction_from.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        title: Text('WALLET'),
        showBackArrow: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WalletCard(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: TSectionHeading(
                title: 'Recent Transactions',
                showActionButton: false,
              ),
            ),
            SizedBox(height: 20),
            WalletTransactionFrom(),
          ],
        )),
      ),
    );
  }
}
