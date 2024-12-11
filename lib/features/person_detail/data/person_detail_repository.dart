import 'dart:developer';

import 'package:viovid_app/features/person_detail/data/person_detail_api_service.dart';
import 'package:viovid_app/features/person_detail/dtos/person.dart';
import 'package:viovid_app/features/result_type.dart';

class PersonDetailRepository {
  final PersonDetailApiService personDetailApiService;

  PersonDetailRepository({
    required this.personDetailApiService,
  });

  Future<Result<Person>> getPersonDetail(String personId) async {
    try {
      return Success(await personDetailApiService.getPersonDetail(personId));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
