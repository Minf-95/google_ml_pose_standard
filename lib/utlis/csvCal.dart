// CSV 파일을 읽어 훈련 데이터와 레이블을 추출하는 함수
import 'dart:io';

import 'package:csv/csv.dart';

Future<void> loadAndPreprocessData(String filePath) async {
  final file = File(filePath);
  final csvString = await file.readAsString();
  List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvString);

  // 각 행에 대한 처리
  for (var row in rowsAsListOfValues) {
    List<double> featureVector = []; // 랜드마크 데이터를 벡터로 변환
    String label = ""; // 레이블 (푸시업 또는 스쿼트)

    // TODO: 행 데이터에서 특징 벡터와 레이블 추출 로직 구현

    // 특징 벡터와 레이블을 사용하여 KNN 분류기 훈련
    // 예: knn.train(featureVector, label);
  }
}
