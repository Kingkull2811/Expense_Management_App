import 'package:viet_wallet/network/model/frequency_model.dart';
import 'package:viet_wallet/utilities/enum/enum.dart';
import 'package:viet_wallet/utilities/utils.dart';

class RecurringPost {
  final int? walletId;
  final int? categoryId;
  final double? amount;
  final String? description;
  final String? time;
  final List<String>? dayInWeeks;
  final FrequencyType frequencyType;
  final String? transactionType;
  final String? fromDate;
  final String? toDate;
  final bool addToReport;

  RecurringPost({
    this.addToReport = false,
    this.amount,
    this.categoryId,
    this.dayInWeeks,
    this.description,
    this.frequencyType = FrequencyType.daily,
    this.fromDate,
    this.time,
    this.toDate,
    this.transactionType,
    this.walletId,
  });

  factory RecurringPost.fromJson(Map<String, dynamic> json) {
    return RecurringPost(
      walletId: json['walletId'],
      categoryId: json['categoryId'],
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      dayInWeeks: List<String>.from(json['dayInWeeks'] ?? []),
      frequencyType: getFrequencyType(json['frequencyType'] ?? ''),
      transactionType: json['transactionType'] ?? '',
      time: json['time'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      addToReport: json['addToReport'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "addToReport": addToReport,
        "amount": amount,
        "categoryId": categoryId,
        "dayInWeeks": dayInWeeks,
        "description": description,
        "frequencyType": setFrequencyType(frequencyType),
        "fromDate": fromDate,
        "time": time,
        "toDate": toDate,
        "transactionType": transactionType,
        "walletId": walletId
      };

  @override
  String toString() {
    return 'RecurringPost{walletId: $walletId, categoryId: $categoryId, amount: $amount, description: $description, time: $time, dayInWeeks: $dayInWeeks, frequencyType: $frequencyType, transactionType: $transactionType, fromDate: $fromDate, toDate: $toDate, addToReport: $addToReport}';
  }
}

class OptionRepeatData {
  final List<DayOfWeek> dayOfWeeks;
  final Frequency frequency;
  final String fromDate;
  final String toDate;
  final String time;

  OptionRepeatData({
    required this.dayOfWeeks,
    required this.frequency,
    required this.fromDate,
    required this.toDate,
    required this.time,
  });

  @override
  String toString() {
    return 'OptionRepeatData{dayInWeeks: $dayOfWeeks, frequencyType: $frequency, fromDate: $fromDate, toDate: $toDate, time: $time}';
  }

// factory OptionRepeatData.fromJson(Map<String, dynamic> json) {
  //   return OptionRepeatData(
  //     dayInWeeks: List<String>.from(json['dayInWeeks'] ?? []),
  //     frequencyType: json['frequencyType'] ?? '',
  //     transactionType: getFrequencyType(json['transactionType'] ?? ''),
  //     time: json['time'] ?? '',
  //     fromDate: DateTime.parse(json['fromDate'] ?? ''),
  //     toDate: DateTime.parse(json['toDate'] ?? ''),
  //   );
  // }
  //
  // Map<String, dynamic> toJson() => {
  //   "dayInWeeks": dayInWeeks,
  //   "frequencyType": setFrequencyType(frequencyType),
  //   "fromDate": fromDate,
  //   "toDate": toDate,
  //   "transactionType": transactionType,
  //   "time": time,
  // };

}
