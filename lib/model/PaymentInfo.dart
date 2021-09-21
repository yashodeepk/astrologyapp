// To parse this JSON data, do
//
//     final paymentInfo = paymentInfoFromJson(jsonString);

import 'dart:convert';

PaymentInfo paymentInfoFromJson(String str) =>
    PaymentInfo.fromJson(json.decode(str));

String paymentInfoToJson(PaymentInfo data) => json.encode(data.toJson());

class PaymentInfo {
  PaymentInfo({
    required this.id,
    required this.entity,
    required this.amount,
    required this.currency,
    required this.status,
    required this.orderId,
    required this.invoiceId,
    required this.international,
    required this.method,
    required this.amountRefunded,
    required this.refundStatus,
    required this.captured,
    required this.description,
    required this.cardId,
    required this.bank,
    required this.wallet,
    required this.vpa,
    required this.email,
    required this.contact,
    required this.notes,
    required this.fee,
    required this.tax,
    required this.errorCode,
    required this.errorDescription,
    required this.errorSource,
    required this.errorStep,
    required this.errorReason,
    required this.acquirerData,
    required this.createdAt,
  });

  final String id;
  final String entity;
  final int amount;
  final String currency;
  final String status;
  final dynamic orderId;
  final dynamic invoiceId;
  final bool international;
  final String method;
  final int amountRefunded;
  final dynamic refundStatus;
  final bool captured;
  final String description;
  final dynamic cardId;
  final String bank;
  final dynamic wallet;
  final dynamic vpa;
  final String email;
  final String contact;
  final List<dynamic> notes;
  final dynamic fee;
  final dynamic tax;
  final dynamic errorCode;
  final dynamic errorDescription;
  final dynamic errorSource;
  final dynamic errorStep;
  final dynamic errorReason;
  final AcquirerData acquirerData;
  final int createdAt;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        currency: json["currency"],
        status: json["status"],
        orderId: json["order_id"],
        invoiceId: json["invoice_id"],
        international: json["international"],
        method: json["method"],
        amountRefunded: json["amount_refunded"],
        refundStatus: json["refund_status"],
        captured: json["captured"],
        description: json["description"],
        cardId: json["card_id"],
        bank: json["bank"], //Error for Debit card null is not subtype of string
        wallet: json["wallet"],
        vpa: json["vpa"],
        email: json["email"],
        contact: json["contact"],
        notes: List<dynamic>.from(json["notes"].map((x) => x)),
        fee: json["fee"],
        tax: json["tax"],
        errorCode: json["error_code"],
        errorDescription: json["error_description"],
        errorSource: json["error_source"],
        errorStep: json["error_step"],
        errorReason: json["error_reason"],
        acquirerData: AcquirerData.fromJson(json["acquirer_data"]),
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "currency": currency,
        "status": status,
        "order_id": orderId,
        "invoice_id": invoiceId,
        "international": international,
        "method": method,
        "amount_refunded": amountRefunded,
        "refund_status": refundStatus,
        "captured": captured,
        "description": description,
        "card_id": cardId,
        "bank": bank,
        "wallet": wallet,
        "vpa": vpa,
        "email": email,
        "contact": contact,
        "notes": List<dynamic>.from(notes.map((x) => x)),
        "fee": fee,
        "tax": tax,
        "error_code": errorCode,
        "error_description": errorDescription,
        "error_source": errorSource,
        "error_step": errorStep,
        "error_reason": errorReason,
        "acquirer_data": acquirerData.toJson(),
        "created_at": createdAt,
      };
}

class AcquirerData {
  AcquirerData({
    required this.bankTransactionId,
  });

  final String bankTransactionId;

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
        bankTransactionId: json["bank_transaction_id"],
      );

  Map<String, dynamic> toJson() => {
        "bank_transaction_id": bankTransactionId,
      };
}
