import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/images/images_bloc.dart';
import '../blocs/images/images_event.dart';
import '../blocs/images/images_state.dart';
import '../models/image_model.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ImagesBloc>().add(FetchImages(limit: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Picsum Images'),
      ),
      body: BlocBuilder<ImagesBloc, ImagesState>(
        builder: (context, state) {
          if (state is ImagesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ImagesLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              itemCount: state.images.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _ImageCell(image: state.images[index]);
              },
            );
          } else if (state is ImagesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _ImageCell extends StatelessWidget {
  final ImageModel image;
  const _ImageCell({required this.image});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // compute height based on aspect ratio from response
    final height = (screenWidth * image.height) / (image.width == 0 ? 1 : image.width);

    // Use Picsum's image URL but set width equal to screen width to optimize
    final imageUrl = 'https://picsum.photos/id/${image.id}/${screenWidth.toInt()}/${math.max(1, height.toInt())}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // image full width, dynamic height
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: screenWidth,
            height: height,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return SizedBox(
                width: screenWidth,
                height: height,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (ctx, e, st) => Container(
              width: screenWidth,
              height: 200,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.broken_image)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Author: ${image.author}',
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Image ID: ${image.id}. Original size: ${image.width}x${image.height}',
          style: TextStyle(color: Colors.grey[700]),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
