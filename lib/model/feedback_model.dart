class FeedbackModel {
  int? id;
  int? formId;
  int? shopId;
  String? formName;
  String? userId;
  String? userName;
  String? createdDate;
  String? review;
  List<CustomerFeedbackType>? custoFeedbackType;

  FeedbackModel({
    this.id,
    this.formId,
    this.shopId,
    this.formName,
    this.userId,
    this.userName,
    this.createdDate,
    this.review,
    this.custoFeedbackType,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      formId: json['form_id'],
      shopId: json['shop_id'],
      formName: json['form_name'],
      userId: json['user_id'],
      userName: json['user_name'],
      createdDate: json['created_date'],
      review: json['review'],
      custoFeedbackType: json['custofeedbacktype'] != null
          ? (json['custofeedbacktype'] as List).map((i) => CustomerFeedbackType.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_id': formId,
      'shop_id': shopId,
      'form_name': formName,
      'user_id': userId,
      'user_name': userName,
      'created_date': createdDate,
      'review': review,
      'custofeedbacktype': custoFeedbackType?.map((e) => e.toJson()).toList(),
    };
  }
}

class CustomerFeedbackType {
  int? id;
  int? customerFeedId;
  int? formId;
  int? ratingType;
  int? typeId;
  String? typeName;
  String? value;
  String? ratingName;

  CustomerFeedbackType({this.id, this.customerFeedId, this.formId, this.ratingType, this.typeId, this.typeName, this.value, this.ratingName});

  factory CustomerFeedbackType.fromJson(Map<String, dynamic> json) {
    return CustomerFeedbackType(
      id: json['id'],
      customerFeedId: json['cutomer_feed_id'],
      formId: json['form_id'],
      ratingType: json['rating_type'],
      typeId: json['type_id'],
      typeName: json['type_name'],
      value: json['value'],
      ratingName: json['rating_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cutomer_feed_id': customerFeedId,
      'form_id': formId,
      'rating_type': ratingType,
      'type_id': typeId,
      'type_name': typeName,
      'value': value,
      'rating_name': ratingName,
    };
  }
}
