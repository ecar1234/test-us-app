import 'package:in_app_purchase/in_app_purchase.dart';

class ProductEntity {
  String? id; // UI 식별자 (AOS: basePlanId / iOS: productId)
  String? groupId; // 그룹 식별자 (AOS: 'purchase' / iOS: 보통 동일)
  String? title; // 상품명 (예: "프리미엄 1개월")
  String? description; // 상품 설명
  String? price; // 포맷팅된 가격 (예: "₩5,000")
  double? rawPrice; // 계산용 숫자 가격 (예: 5000.0)
  String? currencyCode; // 통화 코드 (예: "KRW")
  String? period; // 결제 주기 (ISO 8601 기준, 예: "P1M")

  // 플랫폼별 결제 실행을 위한 핵심 데이터 (숨김 처리 권장)
  final dynamic _originProduct; // ProductDetails 원본
  final String? _offerToken; // Android 전용 (결제 시 필수)

  ProductEntity({
    this.id,
    this.groupId,
    this.title,
    this.description,
    this.price,
    this.rawPrice,
    this.currencyCode,
    this.period,
    dynamic originProduct,
    String? offerToken,
  })  : _originProduct = originProduct,
        _offerToken = offerToken;

  dynamic get originProduct => _originProduct;

  String? get offerToken => _offerToken!;
}
