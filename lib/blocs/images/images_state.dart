import 'package:equatable/equatable.dart';
import '../../models/image_model.dart';

abstract class ImagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<ImageModel> images;
  ImagesLoaded(this.images);
  @override
  List<Object?> get props => [images];
}

class ImagesError extends ImagesState {
  final String message;
  ImagesError(this.message);
  @override
  List<Object?> get props => [message];
}
