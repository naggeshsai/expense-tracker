import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final double amount;
  final String categoryId;
  final String? note;
  final DateTime date;
  final String paymentMethod;
  final bool isRecurring;
  final bool isForOther;
  final String? paidForPerson;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    this.note,
    required this.date,
    required this.paymentMethod,
    required this.isRecurring,
    this.isForOther = false,
    this.paidForPerson,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        categoryId,
        note,
        date,
        paymentMethod,
        isRecurring,
        isForOther,
        paidForPerson,
        createdAt,
        updatedAt,
        isSynced,
      ];

  Expense copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? note,
    DateTime? date,
    String? paymentMethod,
    bool? isRecurring,
    bool? isForOther,
    String? paidForPerson,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isRecurring: isRecurring ?? this.isRecurring,
      isForOther: isForOther ?? this.isForOther,
      paidForPerson: paidForPerson ?? this.paidForPerson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
