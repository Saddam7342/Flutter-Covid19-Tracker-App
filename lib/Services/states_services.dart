import 'dart:convert';
import 'package:flutter_covid19_tracker_app/Services/utilities/app_urls.dart';
import 'package:http/http.dart' as http;
import 'Model/WorldStatesModel.dart';


class StatesServices {
  Future<WorldStatesModel> fetchWorldStatesRecords () async {
    final response = await http.get(Uri.parse(AppUrls.worldStatesApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);

    }else{
      throw Exception('error');
    }
  }


  Future<List<dynamic>> countriesListApi () async {
    var data ;
    final response = await http.get(Uri.parse(AppUrls.countriesList));
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;

    }else{
      throw Exception('error');
    }
  }
}