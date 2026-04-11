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

  DateTime selectedDate = DateTime.now();
  String selectedTime = '';

  const availableTimes = [
    "08:30 AM",
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "14:00 PM",
    "16:00 PM",
  ];


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
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        CalendarCard(
                          selectedDate: selectedDate,
                          onDateSelected: (newDate) {
                            setModalState(() {
                              selectedDate = DateTime(
                                newDate.year,
                                newDate.month,
                                newDate.day,
                              );
                              selectedTime = '';
                            });
                          },
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Selected: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Select Time",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TimeGrid(
                          label: "Available Times",
                          times: availableTimes,
                          selectedTime: selectedTime,
                          selectedDate: selectedDate,
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

                    final images = providerData['images'];
                    final image = (images is List && images.isNotEmpty)
                        ? images.first.toString()
                        : 'assets/images/providers/img.png';

                    showAddressSheet(
                      context,
                      providerData: providerData,
                      id:providerData['id'],
                      name: providerData['title']?.toString() ?? "Service",
                      image: image,
                      selectedDate:
                      DateFormat('MMMM dd, yyyy').format(selectedDate),
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