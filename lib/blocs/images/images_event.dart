import 'package:equatable/equatable.dart';

abstract class ImagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchImages extends ImagesEvent {
  final int limit;
  FetchImages({this.limit = 10});
}
