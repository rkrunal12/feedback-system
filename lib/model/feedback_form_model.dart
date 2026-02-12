import 'dart:convert';

class FeedbackFormModel {
  String? shopId;
  String? formId;
  String? formName;
  String? formTitle;
  String? formSubtitle;
  String? reviewTitle;
  String? reviewPlaceholder;
  String? button;
  int? reviewStatus;
  int? status;
  String? feedbackPageLink;
  List<FeedbackType>? feedbackType;
  List<CustomerFeedback>? customerFeedback;
  List<ResponseFeedback>? responseFeedback;
  int? imageReview;
  int? videoReview;
  String? image;

  FeedbackFormModel({
    this.shopId,
    this.formId,
    this.formName,
    this.formTitle,
    this.formSubtitle,
    this.reviewTitle,
    this.reviewPlaceholder,
    this.button,
    this.reviewStatus,
    this.status,
    this.feedbackPageLink,
    this.feedbackType,
    this.customerFeedback,
    this.responseFeedback,
    this.imageReview,
    this.videoReview,
    this.image,
  });

  FeedbackFormModel copyWith({
    String? shopId,
    String? formId,
    String? formName,
    String? formTitle,
    String? formSubtitle,
    String? reviewTitle,
    String? reviewPlaceholder,
    String? button,
    int? reviewStatus,
    int? status,
    String? feedbackPageLink,
    List<FeedbackType>? feedbackType,
    List<CustomerFeedback>? customerFeedback,
    List<ResponseFeedback>? responseFeedback,
    int? imageReview,
    int? videoReview,
    String? image,
  }) {
    return FeedbackFormModel(
      shopId: shopId ?? this.shopId,
      formId: formId ?? this.formId,
      formName: formName ?? this.formName,
      formTitle: formTitle ?? this.formTitle,
      formSubtitle: formSubtitle ?? this.formSubtitle,
      reviewTitle: reviewTitle ?? this.reviewTitle,
      reviewPlaceholder: reviewPlaceholder ?? this.reviewPlaceholder,
      button: button ?? this.button,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      status: status ?? this.status,
      feedbackPageLink: feedbackPageLink ?? this.feedbackPageLink,
      feedbackType: feedbackType ?? this.feedbackType,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      responseFeedback: responseFeedback ?? this.responseFeedback,
      imageReview: imageReview ?? this.imageReview,
      videoReview: videoReview ?? this.videoReview,
      image: image ?? this.image,
    );
  }

  factory FeedbackFormModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return FeedbackFormModel(
      shopId: (json['shop_id'] ?? json['shopid'])?.toString(),
      formId: (json['id'])?.toString(),
      formName: (json['form_name'] ?? json['formname'])?.toString(),
      formTitle: (json['form_title'] ?? json['formtitle'])?.toString(),
      formSubtitle: (json['form_subtitle'] ?? json['formsubtitle'])?.toString(),
      reviewTitle: (json['review_title'] ?? json['reviewtitle'])?.toString(),
      reviewPlaceholder: (json['review_placeholder'] ?? json['reviewplaceholder'])?.toString(),
      button: json['button']?.toString(),
      reviewStatus: toInt(json['review_status'] ?? json['reviewstatus']),
      status: toInt(json['status']),
      feedbackPageLink: (json['feedback_page_link'] ?? json['feedbackpagelink'])?.toString(),
      feedbackType: (json['feedback_type'] ?? json['feedbacktype']) is List
          ? (json['feedback_type'] ?? json['feedbacktype'] as List)
                .map<FeedbackType>((e) => FeedbackType.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <FeedbackType>[],
      customerFeedback: (json['customer_feedback'] ?? json['customerfeedback']) is List
          ? (json['customer_feedback'] ?? json['customerfeedback'] as List)
                .map<CustomerFeedback>((e) => CustomerFeedback.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <CustomerFeedback>[],
      responseFeedback: (json['response_feedback'] ?? json['responsefeedback']) is List
          ? (json['response_feedback'] ?? json['responsefeedback'] as List)
                .map<ResponseFeedback>((e) => ResponseFeedback.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <ResponseFeedback>[],
      imageReview: toInt(json['image_review'] ?? json['imagereview']),
      videoReview: toInt(json['video_review'] ?? json['videoreview']),
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'shop_id': shopId,
      'form_name': formName,
      'form_title': formTitle,
      'form_subtitle': formSubtitle,
      'review_title': reviewTitle,
      'review_placeholder': reviewPlaceholder,
      'button': button,
      'review_status': reviewStatus,
      'status': status,
      'feedbacktype': feedbackType?.map((e) => e.toAddJson()).toList(),
      'customerfeedback': customerFeedback?.map((e) => e.toAddJson()).toList(),
      'responsefeedback': responseFeedback?.map((e) => e.toAddJson()).toList(),
      'image_review': imageReview,
      'video_review': videoReview,
      'image': image,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'shop_id': shopId,
      'id': formId,
      'form_name': formName,
      'form_title': formTitle,
      'form_subtitle': formSubtitle,
      'review_title': reviewTitle,
      'review_placeholder': reviewPlaceholder,
      'button': button,
      'review_status': reviewStatus,
      'status': status,
      'feedbacktype': feedbackType?.map((e) {
        var json = e.toUpdateJson();
        if (formId != null) json['feedback_id'] = formId;
        return json;
      }).toList(),
      'customerfeedback': customerFeedback?.map((e) {
        var json = e.toUpdateJson();
        if (formId != null) json['feedback_id'] = formId;
        return json;
      }).toList(),
      'responsefeedback': responseFeedback?.map((e) {
        var json = e.toUpdateJson();
        if (formId != null) json['feedback_id'] = formId;
        return json;
      }).toList(),
      'image_review': imageReview,
      'video_review': videoReview,
      'image': image,
    };
  }

  @override
  String toString() => jsonEncode(toUpdateJson());
}

class FeedbackType {
  int? id;
  int? feedbackId;
  String? ratingName;
  String? ratingTitle;
  int? ratingType;
  int? status;
  List<FeedbackOption>? feedbackOption;
  dynamic ratingValue;
  String? image;
  String? ratingImage;

  FeedbackType({
    this.id,
    this.feedbackId,
    this.ratingName,
    this.ratingTitle,
    this.ratingType,
    this.status,
    this.feedbackOption,
    this.ratingValue,
    this.image,
    this.ratingImage,
  });

  FeedbackType copyWith({
    int? id,
    int? feedbackId,
    String? ratingName,
    String? ratingTitle,
    int? ratingType,
    int? status,
    List<FeedbackOption>? feedbackOption,
    dynamic ratingValue,
    String? image,
    String? ratingImage,
  }) {
    return FeedbackType(
      id: id ?? this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      ratingName: ratingName ?? this.ratingName,
      ratingTitle: ratingTitle ?? this.ratingTitle,
      ratingType: ratingType ?? this.ratingType,
      status: status ?? this.status,
      feedbackOption: feedbackOption ?? this.feedbackOption,
      ratingValue: ratingValue ?? this.ratingValue,
      image: image ?? this.image,
      ratingImage: ratingImage ?? this.ratingImage,
    );
  }

  factory FeedbackType.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return FeedbackType(
      id: toInt(json['id']),
      image: (json['image'] ?? json['image'])?.toString(),
      feedbackId: toInt(json['feedback_id'] ?? json['feedbackid']),
      ratingName: (json['rating_name'] ?? json['ratingname'])?.toString(),
      ratingTitle: (json['rating_title'] ?? json['ratingtitle'])?.toString(),
      ratingType: toInt(json['rating_type'] ?? json['ratingtype']),
      status: toInt(json['status']),
      ratingImage: (json['rating_image'] ?? json['ratingimage'])?.toString(),
      feedbackOption: (json['feedback_option'] ?? json['feedbackoption']) is List
          ? (json['feedback_option'] ?? json['feedbackoption'] as List)
                .map<FeedbackOption>((e) => FeedbackOption.fromJson(Map<String, dynamic>.from(e)))
                .toList()
          : <FeedbackOption>[],
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'rating_name': ratingName,
      'rating_title': ratingTitle,
      'rating_type': ratingType,
      'status': status,
      'rating_image': ratingImage,
      'feedbackoption': feedbackOption?.map((e) => e.toAddJson()).toList(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id ?? 0,
      'feedback_id': feedbackId,
      'rating_name': ratingName,
      'rating_title': ratingTitle,
      'rating_type': ratingType,
      'status': status,
      'rating_image': ratingImage,
      'feedbackoption': feedbackOption?.map((e) {
        var json = e.toUpdateJson();
        if (id != null) json['feedback_type_id'] = id;
        return json;
      }).toList(),
    };
  }
}

class FeedbackOption {
  int? id;
  int? feedbackTypeId;
  String? optionName;
  int? status;
  int? position;

  FeedbackOption({this.id, this.feedbackTypeId, this.optionName, this.status, this.position});

  FeedbackOption copyWith({int? id, int? feedbackTypeId, String? optionName, int? status, int? position}) {
    return FeedbackOption(
      id: id ?? this.id,
      feedbackTypeId: feedbackTypeId ?? this.feedbackTypeId,
      optionName: optionName ?? this.optionName,
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }

  factory FeedbackOption.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return FeedbackOption(
      id: toInt(json['id']),
      optionName: (json['option_name'] ?? json['optionname'])?.toString(),
      status: toInt(json['status']),
      position: toInt(json['position']),
    );
  }

  Map<String, dynamic> toAddJson() {
    return {'option_name': optionName, 'status': status};
  }

  Map<String, dynamic> toUpdateJson() {
    return {'id': id, 'option_name': optionName, 'status': status};
  }
}

class CustomerFeedback {
  int? id;
  int? feedbackId;
  String? fieldName;
  int? isMandatory;
  int? status;
  int? customerInfoStatus;
  int? customerInfo;
  bool isEditing;

  CustomerFeedback({
    this.id,
    this.feedbackId,
    this.fieldName,
    this.isMandatory,
    this.status,
    this.customerInfoStatus,
    this.customerInfo,
    this.isEditing = false,
  });

  CustomerFeedback copyWith({
    int? id,
    int? feedbackId,
    String? fieldName,
    int? isMandatory,
    int? status,
    int? customerInfoStatus,
    int? customerInfo,
    bool? isEditing,
  }) {
    return CustomerFeedback(
      id: id ?? this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      fieldName: fieldName ?? this.fieldName,
      isMandatory: isMandatory ?? this.isMandatory,
      status: status ?? this.status,
      customerInfoStatus: customerInfoStatus ?? this.customerInfoStatus,
      customerInfo: customerInfo ?? this.customerInfo,
      isEditing: isEditing ?? this.isEditing,
    );
  }

  factory CustomerFeedback.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return CustomerFeedback(
      id: toInt(json['id']),
      feedbackId: toInt(json['feedback_id'] ?? json['feedbackid']),
      fieldName: (json['field_name'] ?? json['fieldname'])?.toString(),
      isMandatory: toInt(json['is_mandatory'] ?? json['ismandatory']),
      status: toInt(json['status']),
      customerInfoStatus: toInt(json['customer_info_status'] ?? json['customerinfostatus']),
      customerInfo: toInt(json['customer_info'] ?? json['customerinfo']),
      isEditing: false,
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'feedback_id': feedbackId,
      'field_name': fieldName,
      'is_mandatory': isMandatory,
      'status': status,
      'customer_info_status': customerInfoStatus,
      'customer_info': customerInfo,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'id': id,
      'feedback_id': feedbackId,
      'field_name': fieldName,
      'is_mandatory': isMandatory,
      'status': status,
      'customer_info_status': customerInfoStatus,
      'customer_info': customerInfo,
    };
  }
}

class ResponseFeedback {
  int? id;
  int? feedbackId;
  String? message;
  String? button;

  ResponseFeedback({this.id, this.feedbackId, this.message, this.button});

  ResponseFeedback copyWith({int? id, int? feedbackId, String? message, String? button}) {
    return ResponseFeedback(
      id: id ?? this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      message: message ?? this.message,
      button: button ?? this.button,
    );
  }

  factory ResponseFeedback.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    return ResponseFeedback(
      id: toInt(json['id']),
      feedbackId: toInt(json['feedback_id'] ?? json['feedbackid']),
      message: json['message']?.toString(),
      button: json['button']?.toString(),
    );
  }

  Map<String, dynamic> toAddJson() {
    return {'message': message, 'button': button};
  }

  Map<String, dynamic> toUpdateJson() {
    return {'id': id, 'feedback_id': feedbackId, 'message': message, 'button': button};
  }
}
