import 'package:flutter/material.dart';

import 'tab_event.dart';

class TabSelector extends StatefulWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => TabSelectorState();
}

class TabSelectorState extends State<TabSelector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(widget.activeTab),
      onTap: (index) {
        widget.onTabSelected(AppTab.values[index]);
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: const Icon(
            Icons.home_outlined,
            size: 34,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_balance_wallet,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: const Icon(
            Icons.account_balance_wallet_outlined,
            size: 34,
            color: Colors.black,
          ),
          label: 'My Wallet',
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor,
            ),
            child: const Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
          activeIcon: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Theme.of(context).primaryColor.withOpacity(0.4),
            ),
            child: const Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
          ),
          label: "New Collection",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: const Icon(
            Icons.bar_chart_outlined,
            size: 34,
            color: Colors.black,
          ),
          label: 'Planning',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.grid_view,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          activeIcon: const Icon(
            Icons.grid_view,
            size: 34,
            color: Colors.black,
          ),
          label: 'Menu',
        ),
      ],
      selectedLabelStyle: const TextStyle(
        fontSize: 0,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 0,
        fontWeight: FontWeight.bold,
      ),
      unselectedItemColor: Colors.black,
      selectedItemColor: Theme.of(context).primaryColor.withOpacity(0.65),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
    );
  }
}
