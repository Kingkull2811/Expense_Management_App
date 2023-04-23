import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:viet_wallet/screens/new_collection/new_collection_bloc.dart';
import 'package:viet_wallet/screens/new_collection/option_category/option_category_bloc.dart';
import 'package:viet_wallet/widgets/app_image.dart';
import 'package:viet_wallet/widgets/primary_button.dart';

import '../../utilities/enum/api_error_result.dart';
import '../../utilities/screen_utilities.dart';
import '../../utilities/shared_preferences_storage.dart';
import 'new_collection_state.dart';
import 'option_category/option_category.dart';

class NewCollectionPage extends StatefulWidget {
  const NewCollectionPage({Key? key}) : super(key: key);

  @override
  State<NewCollectionPage> createState() => _NewCollectionPageState();
}

class _NewCollectionPageState extends State<NewCollectionPage> {
  final _moneyController = TextEditingController();
  final _noteController = TextEditingController();
  bool _showIconClear = false;
  bool _isSeeDetails = false;

  String optionTitle = 'Chi tiền';
  ItemCategory itemCategorySelected = ItemCategory(
    categoryId: null,
    title: "Chọn hạng mục",
    leading: '',
  );

  String datePicker = formatToLocaleVietnam(DateTime.now());
  String timePicker = DateFormat.Hms().format(DateTime.now());

  @override
  void initState() {
    _noteController.addListener(() {
      setState(() {
        _showIconClear = _noteController.text.isNotEmpty;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _moneyController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewCollectionBloc, NewCollectionState>(
      listenWhen: (preState, curState) {
        return curState.apiError != ApiError.noError;
      },
      listener: (context, curState) {
        if (curState.apiError == ApiError.internalServerError) {
          showCupertinoMessageDialog(context, 'Error!',
              content: 'Internal_server_error');
        }
        if (curState.apiError == ApiError.noInternetConnection) {
          showCupertinoMessageDialog(context, 'Error!',
              content: 'No_internet_connection');
        }
      },
      builder: (context, curState) {
        return _body(context, curState);
      },
    );
  }

  Widget _body(BuildContext context, NewCollectionState state) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: InkWell(
          onTap: () {},
          child: const Icon(
            Icons.history,
            size: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: GestureDetector(
          onTap: () async {
            await showDialog(
              context: context,
              builder: (context) => _buildOptionDialog(context),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  optionTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {},
              child: const SizedBox(
                width: 24,
              ),
              // const Icon(
              //   Icons.check,
              //   color: Colors.white,
              //   size: 24,
              // ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _money(),
              _select(state),
              _details(state),
              _buttonSeeDetails(),
              _buttonSave(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonSave() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: PrimaryButton(
        text: 'Lưu',
        onTap: () {},
      ),
    );
  }

  Widget _details(NewCollectionState state) {
    return _isSeeDetails
        ? Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buttonSeeDetails() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isSeeDetails = !_isSeeDetails;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _isSeeDetails ? 'Ẩn chi tiết' : 'Thêm chi tiết',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Icon(
              _isSeeDetails ? Icons.expand_less : Icons.expand_more,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _select(NewCollectionState state) {
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
            _selectCategory(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _noteHandle(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _pickDateTime(),
            Divider(
              height: 0.5,
              color: Colors.grey.withOpacity(0.3),
            ),
            _selectWallet(),
          ],
        ),
      ),
    );
  }

  Widget _selectCategory() {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BlocProvider(
            create: (context) => OptionCategoryBloc(context),
            child: OptionCategoryPage(
              categoryIdSelected: itemCategorySelected.categoryId,
            ),
          ),
        ).whenComplete(() {
          setState(() {
            itemCategorySelected =
                SharedPreferencesStorage().getItemCategorySelected();
          });
        });
      },
      dense: false,
      horizontalTitleGap: 6,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AppImage(
          localPathOrUrl: itemCategorySelected.leading,
          width: 40,
          height: 40,
          boxFit: BoxFit.cover,
          alignment: Alignment.center,
          errorWidget: const Icon(
            Icons.help_outline,
            color: Colors.grey,
            size: 40,
          ),
        ),
      ),
      title: Text(
        itemCategorySelected.title ?? '',
        style: const TextStyle(
          fontSize: 20,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _noteHandle() {
    return TextField(
      maxLines: null,
      controller: _noteController,
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
        hintText: 'Ghi chú',
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(
            Icons.event_note,
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
                      _noteController.clear();
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
    );
  }

  Widget _pickDateTime() {
    return ListTile(
      dense: false,
      horizontalTitleGap: 6,
      leading: const Icon(
        Icons.calendar_month,
        size: 30,
        color: Colors.grey,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(2000, 01, 01),
                maxTime: DateTime(2025, 12, 30),
                locale: LocaleType.vi,
                currentTime: DateTime.now(),
                onChanged: (date) {
                  setState(() {
                    datePicker = formatToLocaleVietnam(date);
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    datePicker = formatToLocaleVietnam(date);
                  });
                },
                onCancel: () {
                  setState(() {});
                },
              );
            },
            child: Text(datePicker),
          ),
          InkWell(
            onTap: () {
              DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                currentTime: DateTime.now(),
                locale: LocaleType.vi,
                onChanged: (time) {
                  setState(() {
                    timePicker = DateFormat.Hms().format(time);
                  });
                },
                onConfirm: (time) {
                  setState(() {
                    timePicker = DateFormat.Hms().format(time);
                  });
                },
                onCancel: () {
                  setState(() {});
                },
              );
            },
            child: Text(timePicker),
          ),
        ],
      ),
    );
  }

  Widget _selectWallet() {
    return ListTile(
      onTap: () {},
      dense: false,
      horizontalTitleGap: 6,
      leading: const Icon(
        Icons.wallet,
        size: 30,
        color: Colors.grey,
      ),
      title: const Text('Ví tiền mặt'),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
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
                      '.00 VND',
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

  Widget _buildOptionDialog(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(8),
      content: Container(
        height: 300,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListView.builder(
          itemCount: itemOption.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  optionTitle = itemOption[index].title;
                });
                Navigator.pop(context);
              },
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: ListTile(
                      dense: false,
                      visualDensity:
                          const VisualDensity(vertical: -4, horizontal: 0),
                      horizontalTitleGap: 0,
                      minVerticalPadding: -4,
                      selectedColor: Colors.grey.withOpacity(0.3),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              itemOption[index].icon,
                              size: 24,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              itemOption[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: (itemOption[index].title == optionTitle)
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String formatToLocaleVietnam(DateTime date) {
  return '${DateFormat.EEEE('vi').format(date)} - ${DateFormat('dd/MM/yyyy').format(date)}';
}

class ItemCategory {
  final int? categoryId;
  final String? title;
  final String? leading;

  ItemCategory({
    this.categoryId,
    this.title,
    this.leading,
  });
}

class ItemOption {
  final String title;
  final IconData icon;

  ItemOption({
    required this.title,
    required this.icon,
  });
}

List<ItemOption> itemOption = [
  ItemOption(title: 'Chi tiền', icon: Icons.remove),
  ItemOption(title: 'Thu tiền', icon: Icons.add),
  ItemOption(title: 'Cho vay', icon: Icons.payment),
  ItemOption(title: 'Đi vay', icon: Icons.currency_exchange),
  ItemOption(title: 'Chuyển khoản', icon: Icons.swap_horiz_outlined),
  ItemOption(title: 'Điều chỉnh số dư', icon: Icons.low_priority),
];
