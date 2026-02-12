import 'package:equatable/equatable.dart';

class PersonDebt extends Equatable {
  final String personName;
  final double totalOwed;

  const PersonDebt({
    required this.personName,
    required this.totalOwed,
  });

  @override
  List<Object?> get props => [personName, totalOwed];
}
