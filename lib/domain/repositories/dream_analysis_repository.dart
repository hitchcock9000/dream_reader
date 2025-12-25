import 'package:dream_reader/domain/entities/dream_response.dart';

abstract class DreamAnalysisRepository {
  Future<DreamResponse> analyzeDream(String dreamText);
}
