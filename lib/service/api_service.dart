import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:notetaker/model/model.dart';

class ApiSercice {
  Dio dio = Dio();
  var endpointUrl = 'https://65618241dcd355c08323e66b.mockapi.io/notes';

  Future<List<NoteModel>> getNotes() async {
    try {
      Response response = await dio.get(endpointUrl);
      if (response.statusCode == 200) {
        var jsonList = response.data as List;
        List<NoteModel> notes = jsonList.map((json) {
          return NoteModel.fromJson(json);
        }).toList();

        return notes;
      } else {
        throw Exception('Failed to load notes');
      }
    } catch (error) {
      throw Exception('Failed to load notes: $error');
    }
  }
}
