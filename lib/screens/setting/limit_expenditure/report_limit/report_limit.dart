import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/network/model/limit_expenditure_model.dart';

import '../../../../utilities/shared_preferences_storage.dart';
import '../limit_info/limit_info.dart';
import '../limit_info/limit_info_bloc.dart';
import '../limit_info/limit_info_event.dart';

class ReportLimit extends StatelessWidget {
  final LimitModel limitData;

  const ReportLimit({Key? key, required this.limitData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currency =
        SharedPreferencesStorage().getCurrency() ?? '\$/USD';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          limitData.limitName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<LimitInfoBloc>(
                    create: (context) =>
                        LimitInfoBloc(context)..add(LimitInfoInitEvent()),
                    child: LimitInfoPage(
                      isEdit: true,
                      limitData: limitData,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
              size: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hạn mức',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      '${limitData.amount} $currency',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          '${formatDate(limitData.fromDate)} - ${formatDate(limitData.toDate)}'),
                      Text('${limitData.amount} $currency'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(DateTime? date) =>
      DateFormat('dd/MM').format(date ?? DateTime.now());
}
