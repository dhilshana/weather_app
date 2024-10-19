import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/services/weatherServices.dart';
import 'package:weather_app/utils/helper.dart';
import 'package:weather_app/widgets/weatherDataWidget.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  WeatherServices weatherServices = WeatherServices();

  Helper dateTime = Helper();

  Future<WeatherModel?>? _weatherFuture; // Holds the future result

  // Function to search for weather data based on the city
  Future<WeatherModel?> searchLocation(String city) async {
    return await weatherServices.searchByLocation(city); // Fetch the weather data for the city
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Weather',
          style: TextStyle(color: Colors.white, fontSize: 28.sp),
        ),
        titleSpacing: -10,
      ),
      backgroundColor: kBgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent)),
                hintText: 'Search by city',
                hintStyle:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
                fillColor: Colors.black38,
                filled: true,
              ),
              onSubmitted: (value) {
               setState(() {
                    _weatherFuture = searchLocation(value); // Set the future when the user submits
                  });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            if (_weatherFuture != null)
                Expanded(
                  child: FutureBuilder<WeatherModel?>(
                    future: _weatherFuture, // The future to observe
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the data is being fetched
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        // If there was an error
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        // If no data was returned (e.g., invalid city)
                        return const Center(
                          child: Text(
                            'No data found for the city',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        // If data was successfully fetched
                        WeatherModel weather = snapshot.data!;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weather.place.toString(),
                              style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.w500),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${weather.temp!.toStringAsFixed(0)}°C',
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    weather.description.toString(),
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              Expanded(
                                child: GridView.count(crossAxisCount: 2,
                                mainAxisSpacing: 20,
                                    crossAxisSpacing: 15,
                                children: [
                                  WeatherDataWidget(
                                          title: 'PRESSURE',
                                          value: weather.pressure,
                                          imagePath:
                                              'assets/images/barometer.png',
                                          unit: 'hpa',
                                        ),
                                        WeatherDataWidget(
                                          title: 'SUNRISE',
                                          value: dateTime.timeConverter(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                weather.sunrise! * 1000),
                                          ),
                                          title2: 'SUNSET',
                                          sunset: dateTime.timeConverter(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                  weather.sunset! * 1000)),
                                          imagePath: 'assets/images/sunrise1.png',
                                          imagePath2: 'assets/images/sunset1.png',
                                        ),
                                        WeatherDataWidget(
                                          title: 'HUMIDITY',
                                          value: weather.humidity,
                                          imagePath: 'assets/images/humidity.png',
                                          unit: '%',
                                        ),
                                        WeatherDataWidget(
                                          title: 'RAINFALL',
                                          value: (weather.rainfall != null
                                              ? weather.rainfall!.values.first
                                              : 0.0),
                                          imagePath: 'assets/images/rainfall.png',
                                          unit: 'mm/h',
                                        ),
                                        WeatherDataWidget(
                                          title: 'WIND',
                                          value: weather.windSpeed,
                                          imagePath: 'assets/images/wind.png',
                                          unit: 'meter/sec',
                                        ),
                                        WeatherDataWidget(
                                          title: 'FEELS LIKE',
                                          value: weather.feelsLike!
                                              .toStringAsFixed(0),
                                          imagePath:
                                              'assets/images/feelslike.png',
                                          unit: '°C',
                                        )
                                ],
                                ),
                              )
                            
                            
                            
                          ],
                        );
                      }
                    },))
          ],
        ),
      ),
    ));
  }
}
