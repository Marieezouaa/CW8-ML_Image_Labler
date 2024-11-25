import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';

class ImageLabelingService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  Future<List<Map<String, dynamic>>> labelImage(String imagePath) async {
    try {
     
      final model = await FirebaseModelDownloader.instance.getModel(
        "your_model_name",
        FirebaseModelDownloadType.localModelUpdateInBackground,
      );

      // Log the model file path for verification
      print("Model file path: ${model.file}");

      // Simulated image labeling results (replace with actual ML processing logic)
      return [
        {'label': 'Sample Object', 'confidence': 0.95},
        {'label': 'Another Object', 'confidence': 0.87},
      ];
    } catch (e) {
      throw Exception('Error loading model: $e');
    }
  }
}
