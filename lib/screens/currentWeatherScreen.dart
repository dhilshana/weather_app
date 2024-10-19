

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/models/weatherModel.dart';
import 'package:weather_app/services/weatherServices.dart';
import 'package:weather_app/utils/helper.dart';
import 'package:weather_app/widgets/weatherDataWidget.dart';

class CurrentWeatherScreen extends StatefulWidget {
  const CurrentWeatherScreen({super.key});

  @override
  State<CurrentWeatherScreen> createState() => _CurrentWeatherScreenState();
}

class _CurrentWeatherScreenState extends State<CurrentWeatherScreen> {
  Helper dateTime = Helper();
  Position? position;

  Future<void> currentLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {});
    } catch (e) {
      
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Unable to access data.  Please check yor location is enabled')));
    }
  }

  @override
  void initState() {
    super.initState();

    currentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: kBgColor,
            body: position != null
                ? FutureBuilder(
                    future: WeatherServices()
                        .fetchData(position!.latitude, position!.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kPurpleColor,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          snapshot.error.toString(),
                          style: const TextStyle(color: Colors.white),
                        );
                      } else {
                        WeatherModel weather = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
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
                              SizedBox(
                                height: 10.h,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          kPurpleColor.withOpacity(
                                              0.15), // Starting color with opacity
                                          kBgColor.withOpacity(0.10),
                                          // Ending color with opacity
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0.r),
                                        topRight: Radius.circular(30.0.r),
                                      ),
                                      border: const Border(
                                          top:
                                              BorderSide(color: kPurpleColor))),
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 15,
                                    padding: const EdgeInsets.all(15),
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
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: kPurpleColor,
                    ),
                  )));
  }
}
