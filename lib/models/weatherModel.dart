class WeatherModel {
  double? temp;
  String? description;
  String? place;
  String? weatherIcon;
  String? hourlyForecast;
  int? sunrise;
  int? sunset;
  double? windSpeed;
  int? windDirection;
  Map<String,dynamic>? rainfall;
  int? humidity;
  int? pressure;
  double? feelsLike;

  WeatherModel({
      this.temp,
      this.description,
      this.place,
      this.weatherIcon,
      this.hourlyForecast,
      this.sunrise,
      this.sunset,
      this.windSpeed,
      this.windDirection,
      this.rainfall,
      this.humidity,
      this.pressure,
      this.feelsLike,});

    factory WeatherModel.fromJson(Map<String,dynamic> json){
      
      return WeatherModel(
        temp: json['main']['temp']-273.15, 
        description:json['weather'][0]['description'], 
        place:json['name'], 
        weatherIcon:json['weather'][0]['icon'], 
        hourlyForecast:'empty', 
        sunrise:json['sys']['sunrise'], 
        sunset:json['sys']['sunset'], 
        windSpeed:json['wind']['speed'], 
        windDirection:json['wind']['deg'], 
        rainfall:json['rain'], 
        humidity:json['main']['humidity'], 
        pressure:json['main']['pressure'], 
        feelsLike:json['main']['feels_like']-273.15);
    }
}
