import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/AIRecommendation/Predicted_diease.dart';
import 'package:healthcare/views/widgets/custom_button.dart';
import 'package:svg_icon/svg_icon.dart';

class AiRecommendation extends StatefulWidget {
  const AiRecommendation({super.key});

  @override
  State<AiRecommendation> createState() => _AiRecommendationState();
}

class _AiRecommendationState extends State<AiRecommendation> {
  bool isSelectedClick = false;
  final selectedController = TextEditingController();
  List<String> storeDiease = [];
  var skills = [
    {"name": 'Headache', 'isCheck': false},
    {"name": 'cough1', 'isCheck': false},
    {"name": 'fever2', 'isCheck': false},
    {"name": 'asthma3', 'isCheck': false},
    {"name": 'cough11', 'isCheck': false},
    {"name": 'fever12', 'isCheck': false},
    {"name": 'asthma13', 'isCheck': false},
    {"name": 'cough4', 'isCheck': false},
    {"name": 'fever7', 'isCheck': false},
    {"name": 'asthma8', 'isCheck': false},
    {"name": 'cough9', 'isCheck': false},
    {"name": 'fever121', 'isCheck': false},
    {"name": 'asthma122', 'isCheck': false},
    {"name": 'heart', 'isCheck': false}
  ].obs;
  var backupSkills = [
    {"name": 'Headache', 'isCheck': false},
    {"name": 'cough1', 'isCheck': false},
    {"name": 'fever2', 'isCheck': false},
    {"name": 'asthma3', 'isCheck': false},
    {"name": 'cough11', 'isCheck': false},
    {"name": 'fever12', 'isCheck': false},
    {"name": 'asthma13', 'isCheck': false},
    {"name": 'cough4', 'isCheck': false},
    {"name": 'fever7', 'isCheck': false},
    {"name": 'asthma8', 'isCheck': false},
    {"name": 'cough9', 'isCheck': false},
    {"name": 'fever121', 'isCheck': false},
    {"name": 'asthma122', 'isCheck': false},
    {"name": 'heart', 'isCheck': false}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/images/patient.png"),
                    ),
                    Container(
                      width: 42.w,
                      padding: const EdgeInsets.all(8),
                      height: 42.h,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border(),
                          color: silverColor),
                      child:
                          const SvgIcon("assets/icons/notification-icon.svg"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Enter your symptoms ",
                style: GoogleFonts.urbanist(
                    fontSize: 22.h,
                    color: blackColor,
                    fontWeight: FontWeight.w700),
              ),
              storeDiease.isNotEmpty
                  ? SizedBox(
                      width: 343.w,
                      height: 20.h,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 125.w, height: 55.h,
                              //padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.r),
                                  color: silverColor),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  skills[index]['name'].toString(),
                                  style: GoogleFonts.urbanist(
                                      fontSize: 15.r,
                                      fontWeight: FontWeight.w500,
                                      color: textColor),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 3.w,
                            );
                          },
                          itemCount: storeDiease.length),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black),
                        // controller: SearchController(),
                        onChanged: (value) {
                          skills.value = backupSkills;
                          skills.value = skills
                              .where((e) => e['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(value))
                              .toList();
                        },

                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: textColor,
                            ),
                            hintStyle: GoogleFonts.urbanist(
                                fontSize: 14, color: textColor),
                            hintText: "Select your Symptoms"),
                      ),
                    ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                  height: 600.h,
                  child: Obx(
                    () => ListView.separated(
                        itemCount: skills.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Obx(() => ListTile(
                              title: Text(skills[index]['name'].toString()),
                              trailing: Checkbox(
                                  activeColor: cyanColor,
                                  value: skills[index]["isCheck"] as bool,
                                  onChanged: (newbool) {
                                    print(newbool!);
                                    skills[index]["isCheck"] = newbool;

                                    ///check here ....
                                    if (storeDiease
                                        .contains(skills[index]['name'])) {
                                      storeDiease.remove(skills[index]['name']);
                                    } else {
                                      storeDiease.add(
                                          skills[index]['name'].toString());
                                    }
                                    setState(() {});
                                    print(skills[index]['name']);
                                  })));
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: silverColor,
                          );
                        }),
                  )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        // color: whiteColor,
        child: CustomButton(
            text: "Submit symptom",
            onPressed: () {
              Get.to(const PredictedDiease());
            }),
      ),
    );
  }
}
