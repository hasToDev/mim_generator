import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({
    required this.message,
    required this.code,
  });

  final String message;
  final int code;

  @override
  List<Object> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    required int code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
    required int code,
  }) : super(message: message, code: code);
}
