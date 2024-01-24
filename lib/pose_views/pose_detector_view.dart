import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:ml_knn_app/painters/pose_painter.dart';
import 'package:ml_knn_app/pose_views/detector_view.dart';
import 'package:ml_knn_app/utlis/poseKnnClassifier.dart';
// CSV 데이터 로딩을 위한 추가 import가 필요할 수 있습니다.

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;
  late PoseKNNClassifier classifier;

  @override
  void initState() {
    super.initState();
    classifier = PoseKNNClassifier(
      k: 3,
      trainingData: [],
      labels: [],
    );
    // CSV 데이터 로딩 및 분류기 학습
    loadCsvData(classifier, 'assets/datasets/fitness_pose_samples.csv');
  }

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DetectorView(
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: _processImage,
      initialCameraLensDirection: _cameraLensDirection,
      onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;
    final poses = await _poseDetector.processImage(inputImage);

    // 포즈 분류 및 로깅
    if (poses.isNotEmpty) {
      // 포즈 랜드마크를 특징 벡터로 변환하는 로직이 필요
      List<double> features = extractFeaturesFromPose(poses.first);
      String poseLabel = classifier.classify(features);
      print('Pose Classification: $poseLabel');
    }

    if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
      _customPaint = CustomPaint(
        painter: PosePainter(
          classifier,
          poses,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        ),
      );
    } else {
      _customPaint = null;
      _text = 'Poses found: ${poses.length}\n\n';
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> loadCsvData(PoseKNNClassifier classifier, String filePath) async {
    final input = File(filePath).openRead();
    final fields = await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();

    for (var row in fields) {
      // CSV 형식이 feature1, feature2, ..., featureN, label인 것으로 가정
      List<double> features = row.sublist(0, row.length - 1).cast<double>();
      String label = row.last.toString();
      classifier.train(features, label);
      print("1234 label $label");
      print("1234 row $row");
    }
  }

  List<double> extractFeaturesFromPose(Pose pose) {
    // 포즈 랜드마크에서 특징 추출
    // CSV 데이터용 특징 추출 로직과 일치해야 함
    List<double> features = [];
    // ... 추출 로직 ...
    return features;
  }
}
