abstract class AppScreens {
  static const String navigationMenu = '/navigationmenu';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgotpassword';
  static const String forgotPasswordDone = '/forgotpassworddone';
  static const String mailVerification = '/mailverification';

  static const String profile = '/profile';
  static const String updateName = '/updatename';
  static const String updateEmail = '/updateemail';
  static const String updatePhone = '/updatePhone';
  static const String updateUserName = '/updateUserName';

  static const String account = '/account';
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsOfUseView = '/termsOfuseView';
  static const String wallet = '/wallet';
  static const String checkOut = '/checkOut';
  static const String qrcode = '/qrcode';
  static const String order = '/order';
  static const String orderStatement = '/orderStatement';

  static const String coupons = '/coupons';
  static const String createCoupons = "/createCoupons";

  static const String support = '/support';
  static const String supportDetail = "/supportDetail";

  static const String loadData = '/loadData';

  static const String createBanner = '/createBanner';
  static const String allBanner = '/allBanner';
  static const String editBanner = '/editBanner';

  static const String allPopular = '/allPopular';
  static const String createPopular = '/createPopular';
  static const String editPopular = '/editPopular';

  static const String allProduct = '/allProduct';
  static const String createProduct = '/createProduct';
  static const String editProduct = '/editProduct';

  static const String customers = '/customers';
  static const String userDetails = '/userDetails';

  // Map of all routes
  static List<String> allAppScreenItems = [
    navigationMenu,
    home,
    splash,
    login,
    signup,
    forgotPassword,
    forgotPasswordDone,
    mailVerification,
    profile,
    updateName,
    updateEmail,
    updatePhone,
    updateUserName,
    account,
    privacyPolicy,
    termsOfUseView,
    wallet,
    checkOut,
    qrcode,
    order,
    orderStatement,
    coupons,
    support,
    createBanner,
    loadData,
    allBanner,
    editBanner,
    allPopular,
    createPopular,
    editPopular,
    createProduct,
    allProduct,
    editProduct,
    customers,
    userDetails,
    createCoupons
  ];
}
