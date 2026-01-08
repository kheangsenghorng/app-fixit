import 'package:fixit/features/user/service_provider_detail/widgets/booking_button.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/booking_header.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/calendar_card.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/show_address_sheet.dart';
import 'package:fixit/features/user/service_provider_detail/widgets/time_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void scheduleBookingSheet(
    BuildContext context,
    Map<String, dynamic> providerData,
    ) {
  final theme = Theme.of(context);

  String selectedTime = ''; // start empty
  DateTime selectedDate = DateTime.now();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BookingHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 15),

                        CalendarCard(
                          selectedDate: selectedDate,
                          onDateSelected: (newDate) {
                            setModalState(() {
                              selectedDate = newDate;
                              selectedTime = ''; // reset invalid time
                            });
                          },
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          "Select Time",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),

                        TimeGrid(
                          label: "Available Times",
                          times: const [
                            "09:00",
                            "10:00",
                            "11:00",
                            "12:00",
                            "14:00",
                            "16:00",
                          ],
                          selectedTime: selectedTime,
                          selectedDate: selectedDate, // ✅ ALWAYS PASS DATE
                          onSelect: (time) {
                            setModalState(() {
                              selectedTime = time;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                BookingButton(
                  onPressed: selectedTime.isEmpty
                      ? null
                      : () {
                    Navigator.pop(context);

                    showAddressSheet(
                      context,
                      name: providerData['name'] ??
                          "Emily Jani",
                      image: providerData['image'] ??
                          'assets/images/providers/img.png',
                      selectedDate: DateFormat(
                          'MMMM dd, yyyy')
                          .format(selectedDate),
                      selectedTime: selectedTime,
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
