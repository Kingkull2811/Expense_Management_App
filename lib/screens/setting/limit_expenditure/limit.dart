import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_bloc.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info_bloc.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info_event.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_state.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/report_limit/report_limit.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/utilities/utils.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../network/model/limit_expenditure_model.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import 'limit_event.dart';

class LimitPage extends StatefulWidget {
  const LimitPage({Key? key}) : super(key: key);

  @override
  State<LimitPage> createState() => _LimitPageState();
}

class _LimitPageState extends State<LimitPage> {
  final String currency = SharedPreferencesStorage().getCurrency() ?? '\$/USD';

  late LimitBloc _limitBloc;

  @override
  void initState() {
    _limitBloc = BlocProvider.of<LimitBloc>(context)..add(GetListLimitEvent());
    super.initState();
  }

  @override
  void dispose() {
    _limitBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LimitBloc, LimitState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, state) {
        if (state.apiError == ApiError.internalServerError) {
          showMessage1OptionDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (state.apiError == ApiError.noInternetConnection) {
          showMessageNoInternetDialog(context);
        }
      },
      builder: (context, state) {
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
            title: const Text(
              'Hạn mức chi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<LimitInfoBloc>(
                        create: (context) =>
                            LimitInfoBloc(context)..add(LimitInfoInitEvent()),
                        child: const LimitInfoPage(),
                      ),
                    ),
                  );

                  if (result) {
                    _limitBloc.add(GetListLimitEvent());
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.add,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: state.isLoading
              ? const AnimationLoading()
              : _body(context, state.listLimit),
        );
      },
    );
  }

  String formatDate(DateTime? date) =>
      DateFormat('dd/MM').format(date ?? DateTime.now());

  double overAmount(double actual, double amount) => (actual - amount);

  Widget _body(BuildContext context, List<LimitModel>? listLimit) {
    if (isNullOrEmpty(listLimit)) {
      return Center(
        child: Text(
          'Chưa có hạn mức chi.\nVui lòng thêm hạn mức.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: listLimit!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () async {
                final bool result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportLimit(
                      limitData: listLimit[index],
                    ),
                  ),
                );
                if (result) {
                  _limitBloc.add(GetListLimitEvent());
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listLimit[index].limitName ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    '${formatDate(listLimit[index].fromDate)} - ${formatDate(listLimit[index].toDate)}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chi: ${listLimit[index].actualAmount} $currency',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.red),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Hạn mức: ${listLimit[index].amount} $currency',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isNullOrEmpty(listLimit[index].toDate)
                                  ? ''
                                  : (DateTime.now()
                                          .isBefore(listLimit[index].toDate!))
                                      ? '(còn ${(listLimit[index].toDate?.difference(DateTime.now()))?.inDays} ngày)'
                                      : '(đã hết hạn)',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            (overAmount(listLimit[index].actualAmount!,
                                        listLimit[index].amount!) >
                                    0.0)
                                ? Text(
                                    'Vượt hạn mức: ${overAmount(listLimit[index].actualAmount!, listLimit[index].amount!)} $currency',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  )
                                : Text(
                                    'Vượt hạn mức: --- $currency',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.red),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
