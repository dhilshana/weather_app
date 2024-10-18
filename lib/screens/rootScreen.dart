import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/models/hourlyForecasteModel.dart';
import 'package:weather_app/screens/homeScreen.dart';
import 'package:weather_app/services/weatherServices.dart';
import 'package:weather_app/utils/helper.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
Helper dateTime = Helper();
Position? position;

  List<Widget> screens = const [HomeScreen(), SizedBox(), Scaffold()];

  int selectedIndex = 0;

  Future<void> currentPosition() async{
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {});
    } catch (e) {
      print("Error getting location: $e");
      // Handle the error or show a message to the user
    }
    return;
  }

  void onTabTapped(int index) {
    if (index == 1) {
      setState(() {
        selectedIndex = 0;
      });

      showModalBottomSheet(
        context: context,
        backgroundColor:
            Colors.transparent, // Ensure the modal background is transparent
        builder: (context) {
          return Container(
            height: 330.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  kBgColor.withOpacity(0.8), // Starting color with opacity
                  kPurpleColor.withOpacity(0.8), // Ending color with opacity
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0.r),
                topRight: Radius.circular(30.0.r),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Hourly Forecast',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            color: Colors.white)
                      ],
                      border: Border.all(
                        color: kPurpleColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  FutureBuilder(
                    future: WeatherServices().fetchHourlyData(position!.latitude, position!.longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
              
                        return Text(snapshot.error.toString(),style: TextStyle(
                          color: Colors.white
                        ),);
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              List<HourlyForecast> hourlyForecast = snapshot.data!;
                
                        List<Weather>? weather = hourlyForecast[index].weather;
                        dynamic rain = hourlyForecast[index].rain?.d3h;
                        dynamic temp = hourlyForecast[index].main?.temp;

              
                        String? iconCode = weather![0].icon;

                        final iconUrl = 'http://openweathermap.org/img/wn/$iconCode@2x.png';
                              return Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
                                width: 100.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.r),
                                    color: kPurpleColor,
                                    gradient: LinearGradient(
                                      colors: [
                                        kBgColor.withOpacity(
                                            0.8), // Starting color with opacity
                                        kPurpleColor.withOpacity(
                                            0.8), // Ending color with opacity
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    border: Border.all(color: kPurpleColor)),
                                    child: Column(
                                        children: [
                                          Text(dateTime.timeConverter(DateTime.fromMillisecondsSinceEpoch(hourlyForecast[index].dt! * 1000)),style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),),
                                          Image.network(iconUrl),
                                          Text(rain != null ? '${rain.toStringAsFixed(1)}%':'',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),),

                                          Text('${temp.toStringAsFixed(0)}°C',style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                          ),),
                                        ],
                                    ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: ConvexAppBar(
          style: TabStyle.custom,
          backgroundColor: kBgColor,
          activeColor: kPurpleColor,
          shadowColor: kPurpleColor,
          curveSize: 100.r,
          height: 50.h,
          elevation: 10,
          items: const [
            TabItem(
              icon: Icon(
                Icons.place,
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
            ),
            TabItem(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            )
          ],
          initialActiveIndex: 0,
          onTap: onTabTapped),
    ));
  }
}
