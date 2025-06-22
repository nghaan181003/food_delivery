import 'dart:convert';

import 'package:food_delivery_h2d/features/authentication/models/CommuneModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/DistrictModel.dart';
import 'package:food_delivery_h2d/features/authentication/models/ProvinceModel.dart';

import 'package:http/http.dart' as http;

class AddressRepository {
  final String _baseUrl = "https://esgoo.net/api-tinhthanh";
  final String _provinces = "/1/0.htm";

  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + _provinces));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        if (decodedJson['error'] == 0 && decodedJson['data'] != null) {
          final List<dynamic> data = decodedJson['data'];

          return data.map((json) => ProvinceModel.fromJson(json)).toList();
        } else {
          throw Exception(
              "Failed to load provinces. Error: ${decodedJson['error_text']}");
        }
      } else {
        throw Exception(
            "Failed to load provinces. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch provinces: $e");
    }
  }

  Future<ProvinceModel> getProvinceById(String? id) async {
    try {
      final provinces = await getProvinces();
      var province = provinces.firstWhere(
        (province) => province.id == id,
      );
      return province;
    } catch (e) {
      throw Exception("Failed to fetch province by ID: $e");
    }
  }

  Future<List<DistrictModel>> getDistrict(String idProvince) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/2/$idProvince.htm"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        if (decodedJson['error'] == 0 && decodedJson['data'] != null) {
          final List<dynamic> data = decodedJson['data'];

          return data.map((json) => DistrictModel.fromJson(json)).toList();
        } else {
          throw Exception(
              "Failed to load districts. Error: ${decodedJson['error_text']}");
        }
      } else {
        throw Exception(
            "Failed to load provinces. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch districts: $e");
    }
  }

  Future<List<CommuneModel>> getCommunes(String idDistrict) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/3/$idDistrict.htm"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body);

        if (decodedJson['error'] == 0 && decodedJson['data'] != null) {
          final List<dynamic> data = decodedJson['data'];

          return data.map((json) => CommuneModel.fromJson(json)).toList();
        } else {
          throw Exception(
              "Failed to load communes. Error: ${decodedJson['error_text']}");
        }
      } else {
        throw Exception(
            "Failed to load communes. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch communes: $e");
    }
  }
}
