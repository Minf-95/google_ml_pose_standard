import 'package:flutter/material.dart';
import 'package:ml_knn_app/utlis/knnClassifier.dart';

class KnnView extends StatefulWidget {
  const KnnView({super.key});

  @override
  State<KnnView> createState() => _KnnViewState();
}

class _KnnViewState extends State<KnnView> {
  List<DistanceLabelPair> distances = [];
  double probability = 0;
  KNNClassifier knn = KNNClassifier(3, [
    [255.0, 0.0, 0.0], // 빨강
    [0.0, 255.0, 0.0], // 녹색
    [0.0, 0.0, 255.0], // 파랑
    [255.0, 255.0, 0.0], // 노랑
    [0.0, 255.0, 255.0], // 청록
    [255.0, 0.0, 255.0], // 자주
    // ... 추가 색상 데이터 ...
  ], [
    "빨강",
    "녹색",
    "파랑",
    "노랑",
    "청록",
    "자주",
    // ... 추가 레이블 ...
  ]);

  Color selectedColor = Colors.white;
  String colorLabel = "";

  void classifyColor(Color color) {
    var rgb = [color.red.toDouble(), color.green.toDouble(), color.blue.toDouble()];
    print('rgb : $rgb');
    distances = knn.calculateDistances(rgb);
    distances.sort((a, b) => a.distance.compareTo(b.distance));
    var label = knn.classify(rgb);

    // 거리를 확률로 변환 (간단한 방법)
    probability = distances.isEmpty ? 0.0 : 1.0 - (distances[0].distance / distances.last.distance);

    setState(() {
      colorLabel = label;
      probability = probability * 100; // 백분율로 변환
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('색상 분류기'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('선택한 색상: $colorLabel', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              Text('확률: ${probability.toStringAsFixed(2)}%', style: const TextStyle(fontSize: 24)),

              // 색상 선택 UI
              // 예시로 단순한 버튼을 사용합니다.
              ElevatedButton(
                onPressed: () => classifyColor(Colors.red),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('빨강 선택'),
              ),
              ElevatedButton(
                onPressed: () => classifyColor(Colors.green),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('녹색 선택'),
              ),
              ElevatedButton(
                onPressed: () => classifyColor(Colors.blue),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('파랑 선택'),
              ),
              ElevatedButton(
                onPressed: () => classifyColor(const Color.fromARGB(255, 79, 243, 33)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 79, 243, 33)),
                child: const Text('랜덤 색상'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
