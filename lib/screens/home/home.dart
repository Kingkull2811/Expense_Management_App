import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/home/home_bloc.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isShowBalance = false;
  int notificationBadge = 3;
  double balance = 15150169.00;
  final formatter = NumberFormat("#,##0.00", "en_US");

  late HomePageBloc _homePageBloc;

  @override
  void initState() {
    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _homePageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[80],
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _balance(),
          ],
        ),
      ),
    );
  }

  Widget _balance() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _isShowBalance
                          ? '${formatter.format(balance)}  ₫'
                          : '******  ₫',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _isShowBalance = !_isShowBalance;
                          });
                        },
                        child: Icon(
                          _isShowBalance
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 26,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Badge(
                  showBadge: (notificationBadge > 0),
                  badgeContent: Text((notificationBadge.toString()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  badgeStyle: const BadgeStyle(
                    badgeColor: Colors.red,
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                  ),
                  position: BadgePosition.topEnd(top: -3, end: -3),
                  child: const Icon(
                    Icons.notifications,
                    size: 26,
                    color: Colors.black,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
