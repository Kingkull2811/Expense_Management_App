import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/network/model/limit_expenditure_model.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info_bloc.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info_event.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/limit_info_state.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/seclect_category.dart';
import 'package:viet_wallet/screens/setting/limit_expenditure/limit_info/select_wallets.dart';
import 'package:viet_wallet/utilities/utils.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../../network/model/category_model.dart';
import '../../../../network/model/limit_post_data.dart';
import '../../../../network/model/wallet.dart';
import '../../../../network/provider/limit_provider.dart';
import '../../../../network/response/base_get_response.dart';
import '../../../../utilities/enum/api_error_result.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/shared_preferences_storage.dart';
import '../../../../widgets/primary_button.dart';

class LimitInfoPage extends StatefulWidget {
  final bool isEdit;
  final LimitModel? limitData;

  const LimitInfoPage({
    Key? key,
    this.isEdit = false,
    this.limitData,
  }) : super(key: key);

  @override
  State<LimitInfoPage> createState() => _LimitInfoPageState();
}

class _LimitInfoPageState extends State<LimitInfoPage> {
  final _searchController = TextEditingController();
  final _moneyController = TextEditingController();
  final _nameLimitController = TextEditingController();

  bool _showIconClear = false;

  List<int>? listCategoryIdSelected = [];
  List<CategoryModel>? listSearchResult = [];

  List<Wallet> listWalletSelected = [];

  final String _currency = SharedPreferencesStorage().getCurrency() ?? 'VND';

  late LimitInfoBloc _limitInfoBloc;

  String dateStart = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String? dateEnd;

  final _limitProvider = LimitProvider();

  @override
  void initState() {
    _limitInfoBloc = BlocProvider.of<LimitInfoBloc>(context)
      ..add(LimitInfoInitEvent());
    _nameLimitController.addListener(() =>
        setState(() => _showIconClear = _nameLimitController.text.isNotEmpty));

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _moneyController.dispose();
    _nameLimitController.dispose();
    _limitInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Thêm hạn mức chi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<LimitInfoBloc, LimitInfoState>(
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
          return state.isLoading
              ? const AnimationLoading()
              : _body(context, state);
        },
      ),
    );
  }

  Widget _body(BuildContext context, LimitInfoState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _money(),
            _select(state),
            _buttonSave(context),
          ],
        ),
      ),
    );
  }

  Widget _buttonSave(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: PrimaryButton(
        text: 'Lưu',
        onTap: () async {
          if (_moneyController.text.isEmpty) {
            showMessage1OptionDialog(context, 'Bạn chưa nhập số tiền');
          } else if (_nameLimitController.text.isEmpty) {
            showMessage1OptionDialog(context, 'Chưa nhập tên hạn mức');
          } else if (isNullOrEmpty(listCategoryIdSelected)) {
            showMessage1OptionDialog(
                context, 'Phải chọn ít nhất 1 hạng mục chi');
          } else if (isNullOrEmpty(listWalletSelected)) {
            showMessage1OptionDialog(context, 'Phải chọn ít nhất 1 tài khoản');
          } else if (isNullOrEmpty(dateEnd)) {
            showMessage1OptionDialog(context, 'Bạn chưa chọn ngày kết thúc');
          } else {
            List<int> listWalledIdSelected = [];

            for (var wallet in listWalletSelected) {
              listWalledIdSelected.add(wallet.id!);
            }

            final Map<String, dynamic> data = {
              "amount": int.tryParse(_moneyController.text.trim()),
              "categoryIds": listCategoryIdSelected,
              "fromDate": dateStart,
              "limitName": _nameLimitController.text.trim(),
              "toDate": dateEnd,
              "walletIds": listWalledIdSelected
            };
            final response = await _limitProvider.addLimit(data: data);
            if (response is LimitData) {
              showMessage1OptionDialog(
                this.context,
                'Thêm hạn mức thành công',
                onClose: () {
                  setState(() {
                    _moneyController.clear();
                    _nameLimitController.clear();
                    listCategoryIdSelected = [];
                    listWalletSelected = [];
                    dateEnd = null;
                  });
                },
              );
            } else if (response is ExpiredTokenGetResponse) {
              logoutIfNeed(this.context);
            } else {
              showMessage1OptionDialog(this.context, 'Thêm hạn mức thất bại');
            }
          }
        },
      ),
    );
  }

  Widget _select(LimitInfoState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _nameLimit(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _selectCategory(state),
            // _noteHandle(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _selectWallet(state),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _selectDateStart(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _selectDateEnd(),
          ],
        ),
      ),
    );
  }

  Widget _selectWallet(LimitInfoState state) {
    String walletsName = '';
    for (var wallet in listWalletSelected) {
      if (listWalletSelected.length == 1) {
        walletsName = '${wallet.name}';
      } else {
        walletsName = '$walletsName, ${wallet.name}';
      }
    }

    return ListTile(
      onTap: () async {
        final List<Wallet>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectWalletsPage(
              listWallet: state.listWallet,
            ),
          ),
        );
        setState(() {
          listWalletSelected = result ?? [];
        });
      },
      dense: false,
      horizontalTitleGap: 10,
      leading: const Icon(
        Icons.wallet,
        size: 30,
        color: Colors.grey,
      ),
      title: Text(
        isNullOrEmpty(listWalletSelected)
            ? 'Chọn tài khoản'
            : listWalletSelected.length == state.listWallet?.length
                ? 'Tất cả tài khoản'
                : walletsName,
        style: TextStyle(
          fontSize: 16,
          color: isNullOrEmpty(listWalletSelected) ? Colors.grey : Colors.black,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  void search(String query, List<CategoryModel> listCate) {
    if (query.isEmpty) {
      setState(() {
        listSearchResult = listCate;
      });
    }
    final suggestion = listCate
        .where(
          (category) =>
              category.name!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    setState(() {
      listSearchResult = suggestion;
    });
  }

  Widget _selectCategory(LimitInfoState state) {
    return ListTile(
      onTap: () async {
        final List<int>? result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectCategory(
              listCategory: state.listExCategory,
            ),
          ),
        );
        setState(() {
          listCategoryIdSelected = result ?? [];
        });
      },
      dense: false,
      horizontalTitleGap: 10,
      leading: const Icon(
        Icons.category_outlined,
        size: 30,
        color: Colors.grey,
      ),
      title: Text(
        isNullOrEmpty(listCategoryIdSelected)
            ? 'Chọn hạng mục'
            : '${listCategoryIdSelected!.length} hạng mục',
        style: TextStyle(
          fontSize: 16,
          color: isNotNullOrEmpty(listCategoryIdSelected)
              ? Colors.black
              : Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _selectDateStart() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: ListTile(
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(2000, 01, 01),
            maxTime: DateTime(2025, 12, 30),
            locale: LocaleType.vi,
            currentTime: DateTime.now(),
            onConfirm: (date) {
              setState(() {
                // dateStart = DateFormat('dd/MM/yyyy').format(date);
                dateStart = DateFormat('yyyy-MM-dd').format(date);
              });
            },
            onCancel: () {
              setState(() {});
            },
          );
        },
        dense: false,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: const Icon(
          Icons.calendar_month,
          size: 30,
          color: Colors.grey,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ngày bắt đầu',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
            Text(
              dateStart,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _selectDateEnd() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: ListTile(
        onTap: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(2000, 01, 01),
            maxTime: DateTime(2025, 12, 30),
            locale: LocaleType.vi,
            currentTime: DateTime.now(),
            onConfirm: (date) {
              setState(() {
                dateEnd = DateFormat('yyyy-MM-dd').format(date);
              });
            },
            onCancel: () {
              setState(() {});
            },
          );
        },
        dense: false,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: const Icon(
          Icons.calendar_month,
          size: 30,
          color: Colors.grey,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ngày kêt thúc',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.4),
              ),
            ),
            Text(
              dateEnd ?? 'Không xác định',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _nameLimit() {
    return Container(
      height: 60,
      alignment: Alignment.center,
      child: TextField(
        maxLines: null,
        controller: _nameLimitController,
        textAlign: TextAlign.start,
        onChanged: (_) {},
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          hintText: 'Tên hạn mức',
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.card_membership,
              size: 30,
              color: Colors.grey,
            ),
          ),
          suffixIcon: _showIconClear
              ? Padding(
                  padding: const EdgeInsets.only(left: 6, right: 16),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _nameLimitController.clear();
                      });
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget _money() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Số tiền:',
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: TextFormField(
                        controller: _moneyController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                        // inputFormatters: [InputFormatter()],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '.00 $_currency',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
