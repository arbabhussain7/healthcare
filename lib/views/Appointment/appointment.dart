import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:healthcare/connect.dart';
import 'package:healthcare/views/Resigtration/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Booking/Book_confirm.dart';
import 'package:svg_icon/svg_icon.dart';

var did;

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  List<dynamic> appointments = [];
  bool isLoading = true;
  int patientId = id; // Example patient ID, you can dynamically pass this

  Future<void> fetchAppointments() async {
    final response =
        await http.get(Uri.parse('${Api.appointment}?patient_id=$patientId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] == 'success') {
        setState(() {
          appointments = responseData['data'];
          did = responseData['id'];
          // Sort appointments by latest first, based on created_at or day
          appointments.sort((a, b) => DateTime.parse(b['created_at'])
              .compareTo(DateTime.parse(a['created_at'])));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          appointments = [];
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAppointments(); // Call the API on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Appointments",
                    style: GoogleFonts.urbanist(
                        color: textColor,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  Container(
                      width: 42.w,
                      height: 42.h,
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: silverColor, shape: BoxShape.circle),
                      child:
                          const SvgIcon("assets/icons/notification-icon.svg")),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    fillColor: silverColor,
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                      color: darkpurpleColor,
                    ),
                    hintText: "Search",
                    hintStyle: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: darkpurpleColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(29.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: silverColor),
                        borderRadius: BorderRadius.circular(29.r))),
              ),
              SizedBox(height: 12.h),
              isLoading
                  ? CircularProgressIndicator()
                  : appointments.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: appointments.length,
                            itemBuilder: (context, index) {
                              final appointment = appointments[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9.w, vertical: 10.h),
                                child: Container(
                                  height: 150.h,
                                  padding: const EdgeInsets.all(12),
                                  width: 335.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(3,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: whiteColor),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Appointment date",
                                                style: GoogleFonts.urbanist(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: textColor),
                                              ),
                                              Text(
                                                appointment['day'],
                                                style: GoogleFonts.urbanist(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: textColor),
                                              ),
                                            ],
                                          ),
                                          const SvgIcon(
                                              "assets/icons/menu-icon.svg"),
                                        ],
                                      ),
                                      const Divider(color: silverColor),
                                      ListTile(
                                          leading: const CircleAvatar(
                                            backgroundImage: AssetImage(
                                              "assets/images/doctor-nirmala.png",
                                            ),
                                          ),
                                          title: Text(
                                            appointment['name'],
                                            style: GoogleFonts.urbanist(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: textColor),
                                          ),
                                          subtitle: Text(
                                            appointment['problem'],
                                            style: GoogleFonts.urbanist(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: greyColor),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              Get.to(() => BookingConfirmation(
                                                    id: appointment[
                                                        'doctor_id'],
                                                  ));
                                            },
                                            child: SvgIcon(
                                              "assets/icons/forward-icon.svg",
                                              width: 15.w,
                                              height: 15.h,
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          'No appointments available',
                          style: GoogleFonts.urbanist(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: textColor),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
