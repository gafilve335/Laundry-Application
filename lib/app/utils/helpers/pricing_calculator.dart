class TPricingCalculator {
  // ฟังก์ชันคำนวนส่วนลด
  static double calculatePriceAfterDiscount(
      double productPrice, double discountPercentage) {
    double discountAmount = (discountPercentage / 100.0) * productPrice;
    double priceAfterDiscount = productPrice - discountAmount;
    return priceAfterDiscount;
  }
}
