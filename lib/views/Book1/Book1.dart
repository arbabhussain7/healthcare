import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:healthcare/connect.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:healthcare/constant/colors_const.dart';
import 'package:healthcare/views/Book1/Book2.dart';

var did;
var dname;
var dspecial;
var fees;

class Bookingstepone extends StatefulWidget {
  const Bookingstepone({super.key});

  @override
  State<Bookingstepone> createState() => _BookingsteponeState();
}

class _BookingsteponeState extends State<Bookingstepone> {
  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<String?> fetchDoctorFees(int doctorId) async {
    final String apiUrl = '${Api.fetch_fees}?doctor_id=$doctorId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['fees'];
        } else {
          print('Error: ${data['message']}');
          return null;
        }
      } else {
        print('Server error: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching doctor fees: $error');
      return null;
    }
  }

  // Fetch doctors from the API
  Future<void> fetchDoctors() async {
    final response = await http.get(Uri.parse(Api.fetchdoctor));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedDoctors = json.decode(response.body)['data'];
      List<dynamic> doctorsWithFees = [];

      // Fetch fees for each doctor asynchronously
      for (var doctor in fetchedDoctors) {
        int doctorId =
            int.parse(doctor['id'].toString()); // Ensure ID is an integer
        String? fee =
            await fetchDoctorFees(doctorId); // Fetch the fee using the function

        // Add the fee to the doctor data
        doctor['fees'] = fee;
        print(doctor['fees']); // Set 'N/A' if fee is null
        doctorsWithFees.add(doctor);
      }

      setState(() {
        doctors =
            doctorsWithFees; // Update the list with doctors and their fees
        filteredDoctors = doctors; // Initially, all doctors are shown
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error or show a message
    }
  }

  // Function to filter the doctors list based on search query
  void filterDoctors(String query) {
    List<dynamic> results = [];
    if (query.isEmpty) {
      results = doctors; // If search is empty, show all doctors
    } else {
      results = doctors.where((doctor) {
        final doctorName = doctor['full_name'].toLowerCase();
        final doctorSpecialty = doctor['specialty'].toLowerCase();
        final input = query.toLowerCase();

        return doctorName.contains(input) || doctorSpecialty.contains(input);
      }).toList();
    }

    setState(() {
      searchQuery = query;
      filteredDoctors = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 22.h,
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                    )),
                SizedBox(
                  height: 12.h,
                ),
                Text(
                  "Booking Appointment",
                  style: GoogleFonts.urbanist(
                      color: textColor,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 57,
                ),
                Text(
                  "Choose Doctor",
                  style: GoogleFonts.urbanist(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextFormField(
                    onChanged: (value) => filterDoctors(value),
                    style: GoogleFonts.urbanist(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor),
                    decoration: InputDecoration(
                        hintText: "Search doctor",
                        focusColor: cyanColor,
                        hintStyle: GoogleFonts.urbanist(
                            fontSize: 14.sp,
                            color: greyColor,
                            fontWeight: FontWeight.w400),
                        prefixIcon: const Icon(Icons.search)),
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredDoctors.isEmpty
                        ? Center(child: Text("No doctors found"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = filteredDoctors[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: doctor['avatar'] != null
                                          ? NetworkImage(doctor['avatar'])
                                          : AssetImage("assets/placeholder.png")
                                              as ImageProvider,
                                      radius: 30,
                                    ),
                                    title: Text(
                                      doctor['full_name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    subtitle: Text(
                                      doctor['specialty'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: Text(
                                      "Rs.${doctor['fees'] ?? 'N/A'}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        did = doctor['id'];
                                        dname = doctor['full_name'];
                                        dspecial = doctor['specialty'];
                                        fees = doctor['fees'];
                                      });
                                      print(did);
                                      Get.to(() => const BookingStepTwo());
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 19, bottom: 12),
                                    child: Divider(
                                      endIndent: 33,
                                      color: Color.fromRGBO(233, 236, 242, 1),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
