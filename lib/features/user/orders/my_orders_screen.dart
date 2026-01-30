import 'package:fixit/features/user/orders/widgets/content_sheet_wrapper.dart';
import 'package:fixit/features/user/orders/widgets/order_list_view.dart';
import 'package:fixit/features/user/orders/widgets/order_tab_switcher.dart';
import 'package:flutter/material.dart';
import 'widgets/blurred_app_bar.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const BlurredAppBar(title: "My Orders"),
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 70),
          /// 1. Navigation Section
          OrderTabSwitcher(
            selectedTab: selectedTab,
            onTabChanged: (index) {
              setState(() => selectedTab = index);
            },
          ),
          const SizedBox(height: 20),
          // 2. Content Section (The "Cut" Component)
          ContentSheetWrapper(
            child: OrderListView(selectedTab: selectedTab),
          ),
        ],
      ),
    );
  }
}