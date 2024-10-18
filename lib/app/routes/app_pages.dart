import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/all_banner/banner_all_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/create_banner/create_banner_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/banner/edit_banner/edit_banner_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/coupons/coupons_create/coupons_create_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/home/home_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/load_data/load_data_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/order/widgets/order_statement.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/all_popular/popular_all_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/create_popular/create_popular_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/popular/edit_popular/edit_popular_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/all_product/product_all_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/create_product/create_product_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/product/edit_product/edit_product_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/support/support_detail_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/updateprofile/update_email/update_email_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/updateprofile/update_phone/phone_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/updateprofile/update_username/updateusername_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/user/all_user/user_view.dart';
import 'package:laundry_mobile/app/modules/shop/view/user/user_details/user_details_view.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import '../../navigation_menu.dart';
import '../modules/shop/view/account/account_view.dart';
import '../modules/shop/view/coupons/coupons_user/coupons_view.dart';
import '../modules/authentication/view/fogotpassword/forgotpassword_view.dart';
import '../modules/authentication/view/fogotpassword/widgets/forgotpassword_done.dart';
import '../modules/authentication/view/login/login_view.dart';
import '../modules/authentication/view/mailverification/mailverification_view.dart';
import '../modules/shop/view/order/order_view.dart';
import '../modules/shop/view/checkout/checkout_view.dart';
import '../modules/shop/view/privacy_policy/policy_dialog.dart';
import '../modules/shop/view/privacy_policy/terms_of_use.dart';
import '../modules/shop/view/profile/profile_view.dart';
import '../modules/shop/view/qrcode/qrcode_view.dart';
import '../modules/authentication/view/signup/signup_view.dart';
import '../modules/shop/view/splash/splash_view.dart';
import '../modules/shop/view/support/support_view.dart';
import '../modules/shop/view/updateprofile/update_name/updatename_view.dart';
import '../modules/shop/view/wallet/wallet_view.dart';

class TAppRoute {
  static const inital = AppScreens.splash;

  static final List<GetPage> pages = [
    // AUTHENTICATION
    GetPage(
      name: AppScreens.login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: AppScreens.signup,
      page: () => const SignupView(),
    ),
    GetPage(
      name: AppScreens.forgotPassword,
      page: () => const ForgotpasswordView(),
    ),

    GetPage(
      name: AppScreens.mailVerification,
      page: () => const MailverificationView(),
    ),

    GetPage(
      name: AppScreens.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppScreens.privacyPolicy,
      page: () => const PrivacyPolicyView(),
    ),
    GetPage(
      name: AppScreens.termsOfUseView,
      page: () => const TermsOfuseView(),
    ),

    // SHOP
    GetPage(
        name: AppScreens.home,
        page: () => const HomeView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.navigationMenu,
        page: () => const NavigationMenu(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: AppScreens.forgotPasswordDone,
        page: () => const ForgorPasswordDone(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.profile,
        page: () => const ProfileView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.updateName,
        page: () => const UpdatenameView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.updateEmail,
        page: () => const UpdateEmailView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.updateUserName,
        page: () => const UpdateUserNameView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.updatePhone,
        page: () => const UpdatePhoneView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.account,
        page: () => const AccountView(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: AppScreens.wallet,
        page: () => const WalletView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.checkOut,
        page: () => const CheckOutView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.qrcode,
        page: () => const QrcodeView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.order,
        page: () => const OrderView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.orderStatement,
        page: () => const OrderStatement(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.coupons,
        page: () => const CouponsView(),
        middlewares: [TRouteMiddleware()]),

    GetPage(
        name: AppScreens.createCoupons,
        page: () => const CouponsCreateView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.support,
        page: () => const SupportView(),
        middlewares: [TRouteMiddleware()]),
    GetPage(
        name: AppScreens.supportDetail,
        page: () => const SupportDetailView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.loadData,
        page: () => const LoadDataView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.createBanner,
        page: () => const CreateBannerView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.allBanner,
        page: () => const BannerAllView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.editBanner,
        page: () => const EditBannerView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.allPopular,
        page: () => const PopularAllView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.createPopular,
        page: () => const CreatePopularView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.editPopular,
        page: () => const EditPopularView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.allProduct,
        page: () => const ProductAllView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.createProduct,
        page: () => const CreateProductView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.editProduct,
        page: () => const EditProductView(),
        middlewares: [AdminMiddleware()]),

    GetPage(
        name: AppScreens.customers,
        page: () => const UserView(),
        middlewares: [AdminMiddleware()]),
    GetPage(
        name: AppScreens.userDetails,
        page: () => const UserDetailsView(),
        middlewares: [AdminMiddleware()]),
  ];
}

class TRouteMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated
        ? null
        : const RouteSettings(name: AppScreens.splash);
  }
}

class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return AuthenticationRepository.instance.isAuthenticated &&
            ProfileController.instance.user.value.role == AppRole.admin
        ? null
        : const RouteSettings(name: AppScreens.splash);
  }
}
