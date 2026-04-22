class ApiEndpoints {
  static const login = '/login';
  static const register = '/register';
  static const me = '/me';
  static const logout = '/logout';
  static const refresh = '/refresh';
  static const sendOtp = '/otp/send';
  static const verifyOtp = '/otp/verify';

  // Customer profile
  static const customerProfile = '/customer/profile';
  static const customerAvatar = '/customer/avatar';

  static const active = "/type/active";

  static const activeCategory = "/category/active";

  // get all services
  static const activeServices = "/service/active";

  static String activeByCategory(int categoryId) {
    return "/type/active?category_id=$categoryId";
  }

  // Get service by id types
  static String activeServicesByType(int typeId){
     return "/service/active?type_id=$typeId";
  }
  // get by id service
  static String service(int serviceId) {
    return "/service/$serviceId/serviceId";
  }

  static String bookingService = "/customer/service-bookings";

  static String coupons = "/v1/coupons/show-apply";
  static String couponUsage = "/v1/coupon-usages";

  static String payment = "/customer/payments";

  static String generatePayment = "/generate-payment";

  static String checkMd5 = "/payments/khqr/check-md5";

  static String downloadQRcode = "/payments/download-qr";
}
