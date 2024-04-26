import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'detector_view.dart';
import 'painters/label_detector_painter.dart';

class ImageLabelView extends StatefulWidget {
  @override
  State<ImageLabelView> createState() => _ImageLabelViewState();
}

class _ImageLabelViewState extends State<ImageLabelView> {
  late ImageLabeler _imageLabeler;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void initState() {
    super.initState();

    _initializeLabeler();
  }

  @override
  void dispose() {
    _canProcess = false;
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Image Labeler',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
    );
  }

  void _initializeLabeler() async {
    _imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    _canProcess = true;
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final labels = await _imageLabeler.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = LabelDetectorPainter(labels);
      _customPaint = CustomPaint(painter: painter);
    } else {
      // String text = 'Labels found: ${labels.length}\n\n';
      // for (final label in labels) {
      //   text += 'Label: ${label.label}, '
      //       'Confidence: ${label.confidence.toStringAsFixed(2)}\n\n';
      // }
      String text =
          'Label: ${labels[0].label}, Confidence: ${labels[0].confidence.toStringAsFixed(2)}';
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
