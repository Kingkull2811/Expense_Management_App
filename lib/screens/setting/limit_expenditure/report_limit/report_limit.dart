import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/network/model/limit_expenditure_model.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/report_limit/report_limit_bloc.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/report_limit/report_limit_event.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/report_limit/report_limit_state.dart';
import 'package:viet_wallet/utilities/utils.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/shared_preferences_storage.dart';
import '../limit_info/limit_info.dart';
import '../limit_info/limit_info_bloc.dart';
import '../limit_info/limit_info_event.dart';

class ReportLimit extends StatefulWidget {
  final int limitID;

  const ReportLimit({Key? key, required this.limitID}) : super(key: key);

  @override
  State<ReportLimit> createState() => _ReportLimitState();
}

class _ReportLimitState extends State<ReportLimit> {
  late ReportLimitBloc _reportLimitBloc;

  String currency = SharedPreferencesStorage().getCurrency() ?? '\$/USD';

  @override
  void initState() {
    _reportLimitBloc = BlocProvider.of<ReportLimitBloc>(context)
      ..add(
        Initial(reportLimitId: widget.limitID),
      );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _reportLimitBloc.close();
  }

  void _reloadPage() {
    _reportLimitBloc = BlocProvider.of<ReportLimitBloc>(context)
      ..add(
        Initial(reportLimitId: widget.limitID),
      );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportLimitBloc, ReportLimitState>(
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
            title: Text(
              state.limitData?.limitName ?? '',
              style: const TextStyle(
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
                        child: LimitInfoPage(
                          isEdit: true,
                          limitData: state.limitData,
                        ),
                      ),
                    ),
                  );

                  if (result) {
                    _reloadPage();
                  } else {
                    return;
                  }
                },
                icon: const Icon(
                  Icons.edit,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: state.isLoading
              ? const AnimationLoading()
              : _body(context, state.limitData),
        );
      },
    );
  }

  Widget _body(BuildContext context, LimitModel? limitData) {
    if (isNullOrEmpty(limitData)) {
      return const Center(
        child: Text(
          'Không tìm thấy hạn mức này',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hạn mức',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    '${limitData?.amount} $currency',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${formatDate(limitData?.fromDate)} - ${formatDate(limitData?.toDate)}'),
                    Text('${limitData?.amount} $currency'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return '_';
    } else {
      return DateFormat('dd/MM').format(date);
    }
  }
}
