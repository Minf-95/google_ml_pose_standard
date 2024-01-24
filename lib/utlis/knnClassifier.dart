import 'dart:math';

class KNNClassifier {
  final int k;
  List<List<double>> trainingData;
  List<String> labels;

  KNNClassifier(this.k, this.trainingData, this.labels);

  String classify(List<double> input) {
    var distances = <DistanceLabelPair>[];

    for (var i = 0; i < trainingData.length; i++) {
      var distance = _euclideanDistance(input, trainingData[i]);
      distances.add(DistanceLabelPair(distance, labels[i]));
    }

    // 거리에 따라 오름차순 정렬
    distances.sort((a, b) => a.distance.compareTo(b.distance));

    // 가장 가까운 이웃의 레이블을 반환 (k가 1인 경우)
    return distances.first.label;
  }

  double _euclideanDistance(List<double> a, List<double> b) {
    var sum = 0.0;
    for (var i = 0; i < a.length; i++) {
      sum += pow(a[i] - b[i], 2);
    }
    return sqrt(sum);
  }

  String _majorityVote(Iterable<String> labels) {
    var frequency = <String, int>{};
    for (var label in labels) {
      frequency[label] = (frequency[label] ?? 0) + 1;
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // 각 훈련 데이터와의 거리를 계산합니다.
  List<DistanceLabelPair> calculateDistances(List<double> input) {
    var distances = <DistanceLabelPair>[];

    for (var i = 0; i < trainingData.length; i++) {
      var distance = _euclideanDistance(input, trainingData[i]);
      distances.add(DistanceLabelPair(distance, labels[i]));
    }

    return distances;
  }
}

class DistanceLabelPair {
  double distance;
  String label;

  DistanceLabelPair(this.distance, this.label);
}
