import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/utils/our_themes.dart';

import 'consts/images.dart';
import 'consts/strings.dart';
import 'controllers/main_controller.dart';
import 'models/weather_model.dart';

main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
      title: "Weather App",
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: date.text.color(theme.primaryColor).make(),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {
                controller.changeTheme();
              },
              icon: Icon(
                controller.isDark.value ? Icons.light_mode : Icons.dark_mode,
                color: theme.iconTheme.color,
              ),
            ),
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.more_vert, color: theme.iconTheme.color))
        ],
      ),
      body: Obx(
        () => controller.isloaded.value == true
            ? Container(
                padding: const EdgeInsets.all(10),
                child: FutureBuilder(
                  future: controller.weatherData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      WeatherData data = snapshot.data;
                      // var sunrise = DateFormat.jm().format(
                      //   DateTime.fromMillisecondsSinceEpoch(
                      //     data.current!.sunrise!.toInt() * 1000,
                      //   ),
                      // );
                      // var sunset = DateFormat.jm().format(
                      //   DateTime.fromMillisecondsSinceEpoch(
                      //     data.current!.sunset!.toInt() * 1000,
                      //   ),
                      // );

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(children: [
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.only(
                                      topStart: Radius.circular(10),
                                      topEnd: Radius.circular(10),
                                      bottomEnd: Radius.circular(50),
                                      bottomStart: Radius.circular(50),
                                    ),
                                    color: Colors.lightBlueAccent),
                                height: 200,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "${controller.address}"
                                        // "${data.name}"
                                        .text
                                        .uppercase
                                        .fontFamily("poppins_bold")
                                        .size(30)
                                        .letterSpacing(3)
                                        .color(theme.primaryColor)
                                        .make(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "${data.current!.temp}",
                                                style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontSize: 48,
                                                  fontFamily: "poppins",
                                                ),
                                              ),
                                              TextSpan(
                                                text: degree,
                                                style: TextStyle(
                                                  color: theme.primaryColor,
                                                  fontSize: 24,
                                                  fontFamily: "poppins",
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    "  ${data.current!.weather![0].description}",
                                                style: TextStyle(
                                                  color: theme.primaryColor,
                                                  letterSpacing: 3,
                                                  fontSize: 12,
                                                  fontFamily: "poppins",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Image.asset(
                                          "assets/weather/${data.current!.weather![0].icon}.png",
                                          width: 80,
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                "feels like: ${data.current!.feelsLike}$degree",
                                            style: TextStyle(
                                              letterSpacing: 2,
                                              color: theme.primaryColor,
                                              fontSize: 12,
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            TextButton.icon(
                                                onPressed: null,
                                                icon: Icon(
                                                    Icons
                                                        .keyboard_arrow_up_rounded,
                                                    color:
                                                        theme.iconTheme.color),
                                                label:
                                                    "${data.daily![0].temp!.max}$degree"
                                                        .text
                                                        .color(theme
                                                            .iconTheme.color)
                                                        .size(12)
                                                        .make()),
                                            TextButton.icon(
                                              onPressed: null,
                                              icon: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: theme.iconTheme.color),
                                              label:
                                                  "${data.daily![0].temp!.min}$degree"
                                                      .text
                                                      .color(
                                                          theme.iconTheme.color)
                                                      .size(12)
                                                      .make(),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(3, (index) {
                                var name = ['clouds', 'wind', 'humidity'];
                                var iconsList = [clouds, windspeed, humidity];
                                var values = [
                                  "${data.current!.clouds} %",
                                  "${data.current!.windSpeed} km/h",
                                  "${data.current!.humidity} %",
                                ];
                                return Column(
                                  children: [
                                    Image.asset(
                                      iconsList[index],
                                      width: 50,
                                      height: 50,
                                    )
                                        .box
                                        .gray200
                                        .padding(const EdgeInsets.all(8))
                                        .roundedSM
                                        .make(),
                                    10.heightBox,
                                    name[index].text.blue400.make(),
                                    values[index].text.gray400.make(),
                                  ],
                                );
                              }),
                            ),
                            10.heightBox,
                            const Divider(),
                            // 10.heightBox,
                            // FutureBuilder(
                            //   future: controller.hourlyWeatherData,
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot snapshot) {
                            //     if (snapshot.hasData) {
                            //       HourlyWeatherData hourlyData = snapshot.data;

                            //       return SizedBox(
                            //         height: 160,
                            //         child: ListView.builder(
                            //           physics: const BouncingScrollPhysics(),
                            //           scrollDirection: Axis.horizontal,
                            //           shrinkWrap: true,
                            //           itemCount: hourlyData.list!.length > 6
                            //               ? 6
                            //               : hourlyData.list!.length,
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             var time = DateFormat.jm().format(
                            //               DateTime.fromMillisecondsSinceEpoch(
                            //                 hourlyData.list![index].dt!
                            //                         .toInt() *
                            //                     1000,
                            //               ),
                            //             );

                            //             return Container(
                            //               padding: const EdgeInsets.all(8),
                            //               margin:
                            //                   const EdgeInsets.only(right: 8),
                            //               decoration: BoxDecoration(
                            //                 color: Vx.gray200,
                            //                 borderRadius:
                            //                     BorderRadius.circular(15),
                            //               ),
                            //               child: Column(
                            //                 children: [
                            //                   time.text.make(),
                            //                   Expanded(
                            //                     child: Image.asset(
                            //                       "assets/weather/${hourlyData.list![index].weather![0].icon}.png",
                            //                       width: 70,
                            //                     ),
                            //                   ),
                            //                   10.heightBox,
                            //                   "${hourlyData.list![index].main!.temp}$degree"
                            //                       .text
                            //                       .make(),
                            //                 ],
                            //               ),
                            //             );
                            //           },
                            //         ),
                            //       );
                            //     }
                            //     return const Center(
                            //       child: CircularProgressIndicator(),
                            //     );
                            //   },
                            // ),
                            // 10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Next 24 Hours"
                                    .text
                                    .semiBold
                                    .size(16)
                                    .color(theme.primaryColor)
                                    .make(),
                                TextButton(
                                    onPressed: () {},
                                    child: "More".text.make()),
                              ],
                            ),
                            FutureBuilder(
                              future: controller.weatherData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  WeatherData weatherData = snapshot.data;

                                  return SizedBox(
                                    height: 160,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: weatherData.hourly!.length > 24
                                          ? 24
                                          : weatherData.hourly!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var time = DateFormat.jm().format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            weatherData.hourly![index + 1].dt!
                                                    .toInt() *
                                                1000,
                                          ),
                                        );

                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          decoration: BoxDecoration(
                                            color: Vx.gray200,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              time.text.make(),
                                              Expanded(
                                                child: Image.asset(
                                                  "assets/weather/${weatherData.hourly![index + 1].weather![0].icon}.png",
                                                  width: 70,
                                                ),
                                              ),
                                              10.heightBox,
                                              "${weatherData.hourly![index + 1].temp}$degree"
                                                  .text
                                                  .make(),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            10.heightBox,
                            const Divider(),
                            10.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Next 7 Days"
                                    .text
                                    .semiBold
                                    .size(16)
                                    .color(theme.primaryColor)
                                    .make(),
                                TextButton(
                                    onPressed: () {},
                                    child: "View All".text.make()),
                              ],
                            ),
                            FutureBuilder(
                              future: controller.weatherData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  WeatherData weatherData = snapshot.data;

                                  return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 7,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var day = DateFormat("EEEE").format(
                                        DateTime.now().add(
                                          Duration(days: index + 1),
                                        ),
                                      );

                                      return Card(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: day.text.semiBold
                                                    .color(theme.primaryColor)
                                                    .size(16)
                                                    .make(),
                                              ),
                                              Expanded(
                                                child: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Image.asset(
                                                      "assets/weather/${weatherData.daily![index + 1].weather![0].icon}.png",
                                                      width: 40),
                                                  label:
                                                      "${weatherData.daily![index + 1].temp!.day}$degree"
                                                          .text
                                                          .size(16)
                                                          .color(theme
                                                              .primaryColor)
                                                          .make(),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "${weatherData.daily![index + 1].temp!.max}° /",
                                                        style: TextStyle(
                                                          color: theme
                                                              .primaryColor,
                                                          fontFamily: "poppins",
                                                          fontSize: 16,
                                                        )),
                                                    TextSpan(
                                                        text:
                                                            " ${weatherData.daily![index + 1].temp!.min}°",
                                                        style: TextStyle(
                                                          color: theme
                                                              .iconTheme.color,
                                                          fontFamily: "poppins",
                                                          fontSize: 16,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            ),
                            // ListView.builder(
                            //   physics: const NeverScrollableScrollPhysics(),
                            //   shrinkWrap: true,
                            //   itemCount: 7,
                            //   itemBuilder: (BuildContext context, int index) {
                            //     var day = DateFormat("EEEE").format(
                            //       DateTime.now().add(
                            //         Duration(days: index + 1),
                            //       ),
                            //     );
                            //     return Card(
                            //       child: Container(
                            //         padding: const EdgeInsets.symmetric(
                            //             horizontal: 8, vertical: 12),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Expanded(
                            //                 child: day.text.semiBold
                            //                     .color(theme.primaryColor)
                            //                     .make()),
                            //             Expanded(
                            //               child: TextButton.icon(
                            //                   onPressed: null,
                            //                   icon: Image.asset(
                            //                       "assets/weather/50n.png",
                            //                       width: 40),
                            //                   label: "26$degree"
                            //                       .text
                            //                       .size(16)
                            //                       .color(theme.primaryColor)
                            //                       .make()),
                            //             ),
                            //             RichText(
                            //               text: TextSpan(
                            //                 children: [
                            //                   TextSpan(
                            //                       text: "37° /",
                            //                       style: TextStyle(
                            //                         color: theme.primaryColor,
                            //                         fontFamily: "poppins",
                            //                         fontSize: 16,
                            //                       )),
                            //                   TextSpan(
                            //                       text: " 26°",
                            //                       style: TextStyle(
                            //                         color:
                            //                             theme.iconTheme.color,
                            //                         fontFamily: "poppins",
                            //                         fontSize: 16,
                            //                       )),
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
