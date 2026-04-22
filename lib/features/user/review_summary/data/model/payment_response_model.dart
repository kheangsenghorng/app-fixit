class PaymentResponse {
  final bool success;
  final String message;
  final PaymentData data;

  PaymentResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PaymentData.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentData {
  final Map<String, dynamic>? payload;
  final String? qrString;
  final String? md5;
  final DeeplinkData? deeplink;
  final ImageData? image;

  PaymentData({
    this.payload,
    this.qrString,
    this.md5,
    this.deeplink,
    this.image,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      payload: json['payload'],
      qrString: json['qr_string'],
      md5: json['md5'],
      deeplink: json['deeplink'] != null
          ? DeeplinkData.fromJson(json['deeplink'])
          : null,
      image: json['image'] != null
          ? ImageData.fromJson(json['image'])
          : null,
    );
  }
}

class DeeplinkData {
  final bool success;
  final int status;
  final String? shortLink;

  DeeplinkData({
    required this.success,
    required this.status,
    this.shortLink,
  });

  factory DeeplinkData.fromJson(Map<String, dynamic> json) {
    return DeeplinkData(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      shortLink: json['data']?['data']?['shortLink'],
    );
  }
}

class ImageData {
  final bool success;
  final int status;
  final String? imageBase64;
  final String? mimeType;
  final String? merchantName;
  final String? amount;
  final String? currency;

  ImageData({
    required this.success,
    required this.status,
    this.imageBase64,
    this.mimeType,
    this.merchantName,
    this.amount,
    this.currency,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    final imageData = json['data']?['data'];

    return ImageData(
      success: json['success'] ?? false,
      status: json['status'] ?? 0,
      imageBase64: imageData?['image'],
      mimeType: imageData?['mimeType'],
      merchantName: imageData?['merchantName'],
      amount: imageData?['amount'],
      currency: imageData?['currency'],
    );
  }
}