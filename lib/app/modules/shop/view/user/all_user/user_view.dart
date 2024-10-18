import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/user/all_user/widgets/user_all_form.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('USER'),
      ),
      body: SingleChildScrollView(
        child: UserAllForm(),
      ),
    );
  }
}
