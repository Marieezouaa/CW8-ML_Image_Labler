import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cw8/image_labeling_service.dart';

class ImageLabelingPage extends StatefulWidget {
  @override
  _ImageLabelingPageState createState() => _ImageLabelingPageState();
}

class _ImageLabelingPageState extends State<ImageLabelingPage> {
  final ImageLabelingService _service = ImageLabelingService();
  String? _imagePath;
  List<Map<String, dynamic>> _labels = [];
  bool _isLoading = false;

  void _pickImage() async {
    setState(() => _isLoading = true);
    try {
      String? imagePath = await _service.pickImage();
      if (imagePath != null) {
        setState(() => _imagePath = imagePath);
        List<Map<String, dynamic>> labels = await _service.labelImage(imagePath);
        setState(() => _labels = labels);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking or labeling image: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Labeling App')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imagePath == null)
                  Center(child: Text('No image selected.', style: TextStyle(fontSize: 16))),
                if (_imagePath != null)
                  Image.file(File(_imagePath!), height: 300, fit: BoxFit.cover),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _pickImage, child: Text('Pick Image')),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _labels.length,
                    itemBuilder: (context, index) {
                      final label = _labels[index];
                      return ListTile(
                        title: Text(label['label']),
                        subtitle: Text('Confidence: ${(label['confidence'] * 100).toStringAsFixed(2)}%'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
