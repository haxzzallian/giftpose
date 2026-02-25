import 'package:giftpose_app/common/widgets/height-spacer.dart';
import 'package:giftpose_app/modules/home/views/bottom-nav.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePreScreenLoader extends StatelessWidget {
  const HomePreScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;
    return Scaffold(
      bottomNavigationBar: BottomNav(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .8,
          child: ListView(
            children: [
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(26, 4, 2, 59),
                highlightColor: const Color.fromARGB(98, 104, 104, 104),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        width: 30,
                      ),
                    ),
                    Container(
                      height: screenHeight * 0.03,
                      width: screenWidth * 0.08,
                    ),
                  ],
                ),
              ),
              const HeightSpacer(0.01),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Shimmer.fromColors(
                      baseColor: const Color.fromARGB(26, 4, 2, 59),
                      highlightColor: const Color.fromARGB(98, 104, 104, 104),
                      child: Container(
                        width: double.infinity,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
              const HeightSpacer(0.02),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(26, 4, 2, 59),
                  highlightColor: const Color.fromARGB(98, 104, 104, 104),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  )),
              const HeightSpacer(0.04),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(26, 4, 2, 59),
                  highlightColor: const Color.fromARGB(98, 104, 104, 104),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  )),
              HeightSpacer(0.03),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(26, 4, 2, 59),
                  highlightColor: const Color.fromARGB(98, 104, 104, 104),
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  )),
              const HeightSpacer(0.01),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(26, 4, 2, 59),
                  highlightColor: const Color.fromARGB(98, 104, 104, 104),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  )),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(26, 4, 2, 59),
                  highlightColor: const Color.fromARGB(98, 104, 104, 104),
                  child: Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
