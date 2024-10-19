
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/hourlyForecasteModel.dart';
import 'package:weather_app/models/weatherModel.dart';

class WeatherServices {

  

  Future<WeatherModel> fetchData(double lat,double long)async{
    try{
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$long&appid=b5a8b857b65c220e9bcd2bef32e9d42d');
      final response = await http.get(uri);
      if(response.statusCode == 200){
        final weatherDetails = jsonDecode(response.body);
      
        
        return WeatherModel.fromJson(weatherDetails);
      }
      else{
        throw Exception(response.statusCode);
      }
    }catch(e){
      rethrow;
    }
  }

  Future<List<HourlyForecast>> fetchHourlyData(double lat,double long) async{
    try{
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$long&appid=b5a8b857b65c220e9bcd2bef32e9d42d');
      final response = await http.get(uri);
      if(response.statusCode == 200){
        final hourlyForecast = jsonDecode(response.body);
        final List<dynamic> forecastList = hourlyForecast['list'];

        // var data = [];
        //  forecastList.forEach((e){
        //   data.add(HourlyForecast.fromJson(e));

        //  });
        final List<HourlyForecast> dataList = forecastList.map((e)=>HourlyForecast.fromJson(e)).toList();
        return dataList;
      }
      else{
        throw Exception(response.statusCode);
      }
    }catch(e){
      rethrow;
    }
  }

  Future<WeatherModel> searchByLocation(String city) async{
    try{
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b5a8b857b65c220e9bcd2bef32e9d42d');
      final response = await http.get(uri);
      if(response.statusCode == 200){
        final weatherDetails = jsonDecode(response.body);
        return WeatherModel.fromJson(weatherDetails);
      }
      else{
        final erroeData = jsonDecode(response.body);
        final errormessage = erroeData['message']?? 'an unknown error occured';
        throw Exception(errormessage);
      }
    }catch(e){
      rethrow;
    }
  }

}