import 'package:flutter_bloc/flutter_bloc.dart';
import 'images_event.dart';
import 'images_state.dart';
import '../../repositories/image_repository.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImageRepository imageRepository;
  ImagesBloc({required this.imageRepository}) : super(ImagesInitial()) {
    on<FetchImages>(_onFetchImages);
  }

  Future<void> _onFetchImages(FetchImages event, Emitter<ImagesState> emit) async {
    emit(ImagesLoading());
    try {
      final images = await imageRepository.fetchImages(limit: event.limit);
      emit(ImagesLoaded(images));
    } catch (e) {
      emit(ImagesError(e.toString()));
    }
  }
}
