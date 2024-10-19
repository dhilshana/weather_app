import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/constants/constants.dart';

class WeatherDataWidget extends StatelessWidget {
  String title;
  String? title2;
  dynamic value;
  dynamic sunset;
  String imagePath;
  String? imagePath2;
  String? unit;
  WeatherDataWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.imagePath,
      this.sunset,
      this.title2,
      this.imagePath2,
      this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kBgColor,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: kPurpleColor.withOpacity(0.6)),
          boxShadow: const [
            BoxShadow(
                offset: Offset(1, 1),
                color: Colors.white10,
                spreadRadius: 1,
                blurRadius: 5)
          ]),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: title2 != null ? 12.sp : 15.sp,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            if (title2 == null)
              SizedBox(
                height: 10.h,
              ),
            Text(
              value.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: title2 != null ? 20.sp : 30.sp,
                  fontWeight: FontWeight.w400),
            ),
            if (title2 != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        imagePath,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        title2.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Text(
                    sunset.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            SizedBox(
              height: 10.h,
            ),
            if (title2 == null)
              Text(
                unit.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              )
          ],
        ),
      ),
    );
  }
}
