import 'dart:math';

class PoseKNNClassifier {
  final int k;
  List<List<double>> trainingData;
  List<String> labels;

  PoseKNNClassifier({required this.k, required this.trainingData, required this.labels});

  // 새로운 훈련 데이터와 레이블을 추가하는 메서드
  void train(List<double> featureVector, String label) {
    trainingData.add(featureVector);
    labels.add(label);
  }

  // 입력된 특징 벡터를 기반으로 분류를 수행하는 메서드
  String classify(List<double> input) {
    var distances = _calculateDistances(input);

    // 거리에 따라 오름차순 정렬
    distances.sort((a, b) => a.distance.compareTo(b.distance));

    // 가장 가까운 k개의 이웃 찾기
    var nearestLabels = distances.take(k).map((dl) => dl.label);
    print('nearestLabels : $nearestLabels');

    // 가장 빈번한 레이블을 결과로 반환
    return _majorityVote(nearestLabels);
  }

  // 각 훈련 데이터와 입력 벡터 간의 유클리드 거리를 계산하는 메서드
  double _euclideanDistance(List<double> a, List<double> b) {
    var sum = 0.0;
    for (var i = 0; i < a.length; i++) {
      sum += pow(a[i] - b[i], 2);
    }
    return sqrt(sum);
  }

  // 가장 빈번한 레이블을 결정하는 메서드
  String _majorityVote(Iterable<String> nearestLabels) {
    var frequency = <String, int>{};
    for (var label in nearestLabels) {
      frequency[label] = (frequency[label] ?? 0) + 1;
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // 입력된 특징 벡터에 대해 모든 훈련 데이터와의 거리를 계산하는 메서드
  List<DistanceLabelPair> _calculateDistances(List<double> input) {
    return trainingData.asMap().entries.map((e) {
      var distance = _euclideanDistance(input, e.value);
      return DistanceLabelPair(distance, labels[e.key]);
    }).toList();
  }
}

class DistanceLabelPair {
  double distance;
  String label;

  DistanceLabelPair(this.distance, this.label);
}
