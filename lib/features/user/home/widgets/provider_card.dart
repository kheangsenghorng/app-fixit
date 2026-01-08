import 'package:flutter/material.dart';


class ProviderCard extends StatelessWidget {
  final String name;
  final String job;
  const ProviderCard({super.key, required this.name, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Icon(Icons.person, size: 40, color: Colors.blue)),
          ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(job, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const Text(" 4.8", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(50, 25),
                ),
                child: const Text("Details", style: TextStyle(fontSize: 10, color: Colors.white)),
              )
            ],
          )
        ],
      ),
    );
  }
}