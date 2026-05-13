class ApiEndpoints {
  static const String login = '/login';
  static const String register = '/register';
  static const String me = '/me';
  static const String logout = '/logout';
  static const String refresh = '/refresh';
  static const String sendOtp = '/otp/send';
  static const String verifyOtp = '/otp/verify';

  // Customer profile
  static const String customerProfile = '/customer/profile';
  static const String customerAvatar = '/customer/avatar';

  static const String active = "/type/active";
  static const String activeCategory = "/category/active";

  // Services
  static const String activeServices = "/service/active";

  static String activeByCategory(int categoryId) {
    return "/type/active?category_id=$categoryId";
  }

  static String activeServicesByType(int typeId) {
    return "/service/active?type_id=$typeId";
  }

  static String service(int serviceId) {
    return "/service/$serviceId/serviceId";
  }

  // Booking
  static const String bookingService = "/customer/service-bookings";
  static const String serviceBookings = "/customer/service-bookings";

  static String serviceBookingByBooking(int bookingId) {
    return "$serviceBookings/$bookingId";
  }

  // Coupons
  static const String coupons = "/v1/coupons/show-apply";
  static const String couponUsage = "/v1/coupon-usages";

  // Payment
  static const String payment = "/customer/payments";
  static const String generatePayment = "/generate-payment";
  static const String checkMd5 = "/payments/khqr/check-md5";
  static const String downloadQRcode = "/payments/download-qr";
  static const String paymentsHistory = "/customer/service-bookings/user";

  // Customer addresses
  static const String addresses = "/customer/user-addresses";

  static String addressById(int addressId) {
    return "$addresses/$addressId";
  }

  // Search
  static const String searchActiveServices = "/service/search-active-services";

  // Booking providers
  static const String serviceBookingProviders =
      "/customer/service-booking-providers";

  static String serviceBookingProvidersByBooking(int bookingId) {
    return "$serviceBookingProviders/booking/$bookingId";
  }

  // =========================
  // Wallets
  // =========================

  static const String wallets = "/customer/wallets";

  static String walletById(int walletId) {
    return "$wallets/$walletId";
  }

  static String walletByUserId(int userId) {
    return "$wallets/user/$userId";
  }

  static String topUpWallet(int walletId) {
    return "$wallets/$walletId/top-up";
  }

  static String freezeWallet(int walletId) {
    return "$wallets/$walletId/freeze";
  }

  static String activateWallet(int walletId) {
    return "$wallets/$walletId/activate";
  }

  // =========================
  // Wallet Transactions
  // =========================

  static const String walletTransactions = "/customer/wallet-transactions";

  static String walletTransactionById(int id) {
    return "$walletTransactions/$id";
  }

  static String walletTransactionsByUserId(int userId) {
    return "$walletTransactions/user/$userId";
  }

  static String walletTransactionsByWalletId(int walletId) {
    return "$walletTransactions/wallet/$walletId";
  }
}