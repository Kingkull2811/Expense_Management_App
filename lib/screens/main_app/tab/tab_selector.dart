import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import 'tab_event.dart';

class TabSelector extends StatefulWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;
  final int newChatsBadgeNumber;
  final int newsBadgeNumber;
  final int newTranscriptBadgeNumber;

  const TabSelector({
    Key? key,
    required this.activeTab,
    required this.onTabSelected,
    required this.newChatsBadgeNumber,
    required this.newsBadgeNumber,
    required this.newTranscriptBadgeNumber,
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
          icon: Badge(
            showBadge: (widget.newChatsBadgeNumber > 0),
            badgeContent: Text((widget.newChatsBadgeNumber.toString()),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child: Image.asset(
              'assets/images/ic_chat.png',
              width: 30,
              height: 30,
            ),
          ),
          activeIcon: Badge(
            showBadge: (widget.newChatsBadgeNumber > 0),
            badgeContent: Text(
              (widget.newChatsBadgeNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child: Image.asset(
              'assets/images/ic_chat.png',
              width: 30,
              height: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            showBadge: (widget.newsBadgeNumber > 0),
            badgeContent: Text(
              (widget.newsBadgeNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child: Image.asset('assets/images/ic_news.png', width: 30, height: 30),
          ),
          activeIcon: Badge(
            showBadge: (widget.newsBadgeNumber > 0),
            badgeContent: Text(
              (widget.newsBadgeNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child: Image.asset(
              'assets/images/ic_news.png',
              width: 30,
              height: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            showBadge: (widget.newTranscriptBadgeNumber > 0),
            badgeContent: Text(
              (widget.newTranscriptBadgeNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child:
                Image.asset('assets/images/ic_transcript.png', width: 30, height: 30),
          ),
          activeIcon: Badge(
            showBadge: (widget.newTranscriptBadgeNumber > 0),
            badgeContent: Text(
              (widget.newTranscriptBadgeNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            badgeStyle: const BadgeStyle(
              badgeColor: Colors.red,
              padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
            ),
            position: BadgePosition.topStart(top: -3, start: -8),
            child: Image.asset(
              'assets/images/ic_transcript.png',
              width: 30,
              height: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          label: 'Transcript',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/ic_profile.png', width: 30, height: 30),
          activeIcon: Image.asset(
            'assets/images/ic_profile.png',
            width: 30,
            height: 30,
            color: Theme.of(context).primaryColor,
          ),
          label: 'Profile',
        ),
      ],
      selectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      unselectedItemColor: Colors.black,
      selectedItemColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
    );
  }
}
