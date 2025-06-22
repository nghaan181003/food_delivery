import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class CompressImageParams {
  final String filePath;
  final int targetSizeKB;

  CompressImageParams(this.filePath, this.targetSizeKB);
}

Future<String?> compressImage(CompressImageParams params) async {
  try {
    final File file = File(params.filePath);
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) return null;

    int originalSize = await file.length();
    if (originalSize < params.targetSizeKB * 1024 || image.width <= 1024) {
      print("Original image is small enough, skipping compression");
      return params.filePath;
    }

    img.Image resizedImage = img.copyResize(image,
        width: 1024, interpolation: img.Interpolation.average);
    String compressedPath =
        '${params.filePath}_compressed${path.extension(params.filePath)}';
    File compressedFile = File(compressedPath);

    int quality = 70;
    await compressedFile
        .writeAsBytes(img.encodeJpg(resizedImage, quality: quality));

    int compressedSize = await compressedFile.length();
    while (compressedSize > params.targetSizeKB * 1024 && quality > 10) {
      quality -= 10;
      await compressedFile
          .writeAsBytes(img.encodeJpg(resizedImage, quality: quality));
      compressedSize = await compressedFile.length();
    }

    if (compressedSize >= originalSize) {
      print(
          "Compressed size ($compressedSize bytes) is not smaller than original ($originalSize bytes), using original file");
      return params.filePath;
    }

    return compressedFile.path;
  } catch (e) {
    print("Error compressing image: $e");
    return null;
  }
}

Future<void> cleanUpCompressedFile(File file) async {
  try {
    if (await file.exists() && file.path.contains('_compressed')) {
      await file.delete();
      print("Deleted temporary file: ${file.path}");
    }
  } catch (e) {
    print("Error deleting temporary file: ${file.path}, error: $e");
  }
}
