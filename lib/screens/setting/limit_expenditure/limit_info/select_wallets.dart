import 'package:flutter/material.dart';

import '../../../../network/model/wallet.dart';
import '../../../../utilities/screen_utilities.dart';
import '../../../../utilities/utils.dart';
import '../../../../widgets/search_box.dart';

class SelectWalletsPage extends StatefulWidget {
  final List<Wallet>? listWallet;

  const SelectWalletsPage({Key? key, this.listWallet}) : super(key: key);

  @override
  State<SelectWalletsPage> createState() => _SelectWalletsPageState();
}

class _SelectWalletsPageState extends State<SelectWalletsPage> {
  final _searchController = TextEditingController();

  bool _showClearSearch = false;
  bool _showExSearchResult = false;

  List<WalletState>? listWalletState = [];
  List<WalletState> listSearchState = [];

  final WalletState checkAll = WalletState(
      wallet: Wallet(
    id: null,
    name: 'Chọn tẩt cả',
  ));

  @override
  void initState() {
    _searchController.addListener(() => setState(() {
          _showClearSearch = _searchController.text.isNotEmpty;
          _showExSearchResult = _searchController.text.isNotEmpty;
        }));
    listWalletState = widget.listWallet
            ?.map((wallet) => WalletState(wallet: wallet))
            .toList() ??
        [];
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text(
            'Chọn tài khoản',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                List<Wallet>? listWalletSelected = listWalletState
                    ?.where((walletState) => walletState.value == true)
                    .map((walletState) => walletState.wallet)
                    .toList();
                if (isNullOrEmpty(listWalletSelected)) {
                  showMessage1OptionDialog(
                    context,
                    'Bạn cần chọn ít nhất một tài khoản',
                  );
                } else {
                  Navigator.of(context).pop(listWalletSelected);
                }
              },
              icon: const Icon(
                Icons.check,
                size: 24,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: isNullOrEmpty(listWalletState)
              ? Center(
                  child: Text(
                    'Bạn chưa có tài khoản nào.\nVui lòng tạo tài khoản.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SearchBox(
                        hinText: 'Tìm theo tên tài khoản',
                        controller: _searchController,
                        showClear: _showClearSearch,
                        onChanged: (value) {
                          // search(value, listWalletState);
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 16),
                        height: MediaQuery.of(context).size.height - 170,
                        child: _showExSearchResult
                            ? _resultSearch(listSearchState)
                            : _listWalletView(listWalletState!),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _resultSearch(List<WalletState> listSearchState) {
    return Container();
  }

  Widget _listWalletView(List<WalletState> listState) {
    return ListView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      children: [
        _buildAllCheck(checkAll),
        Divider(height: 0.5, color: Colors.grey.withOpacity(0.2)),
        ...listWalletState!
            .map((walletState) => _buildSingleCheckbox(walletState))
            .toList(),
      ],
    );
  }

  Widget _buildSingleCheckbox(WalletState walletState) => _buildCheckbox(
        walletState: walletState,
        onClicked: () {
          setState(() {
            final newValue = !walletState.value;
            walletState.value = newValue;

            if (!newValue) {
              checkAll.value = false;
            } else {
              final allow = listWalletState?.every(
                (walletState) => walletState.value,
              );
              checkAll.value = allow ?? false;
            }
          });
        },
      );

  Widget _buildAllCheck(WalletState walletState) => _buildCheckbox(
      isAll: true,
      walletState: walletState,
      onClicked: () {
        final newValue = !walletState.value;

        setState(() {
          checkAll.value = newValue;
          listWalletState?.forEach((notification) {
            notification.value = newValue;
          });
        });
      });

  Widget _buildCheckbox({
    required WalletState walletState,
    required VoidCallback onClicked,
    bool isAll = false,
  }) =>
      Container(
        height: isAll ? 50 : 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: isAll ? -4 : 0),
          onTap: onClicked,
          leading: !isAll
              ? Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Icon(
                    getIconWallet(walletType: walletState.wallet.accountType),
                    size: 24,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : const Icon(
                  Icons.playlist_add_check,
                  size: 30,
                  color: Colors.grey,
                ),
          title: Text(
            walletState.wallet.name ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: isAll ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          subtitle: isNotNullOrEmpty(walletState.wallet.accountBalance)
              ? Text(
                  '${walletState.wallet.accountBalance} ${walletState.wallet.currency}',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey.withOpacity(0.6)),
                )
              : null,
          trailing: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Theme.of(context).primaryColor,
            ),
            child: Checkbox(
              activeColor: Theme.of(context).primaryColor,
              value: walletState.value,
              onChanged: (value) => onClicked(),
            ),
          ),
        ),
      );
}

class WalletState {
  Wallet wallet;
  bool value;

  WalletState({required this.wallet, this.value = false});

  @override
  String toString() {
    return 'WalletState{wallet: $wallet, value: $value}';
  }
}
