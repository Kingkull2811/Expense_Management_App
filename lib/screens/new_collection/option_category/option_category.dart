import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/new_collection/option_category/option_category_bloc.dart';
import 'package:viet_wallet/screens/new_collection/option_category/option_category_event.dart';
import 'package:viet_wallet/screens/new_collection/option_category/option_category_state.dart';
import 'package:viet_wallet/utilities/shared_preferences_storage.dart';
import 'package:viet_wallet/widgets/animation_loading.dart';

import '../../../network/model/category_model.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/screen_utilities.dart';
import '../../../widgets/app_image.dart';
import '../../setting/category_item/category_item.dart';
import '../../setting/category_item/category_item_bloc.dart';

class OptionCategoryPage extends StatefulWidget {
  final int? categoryIdSelected;

  const OptionCategoryPage({Key? key, this.categoryIdSelected})
      : super(key: key);

  @override
  State<OptionCategoryPage> createState() => _OptionCategoryPageState();
}

class _OptionCategoryPageState extends State<OptionCategoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _searchController = TextEditingController();
  bool _showClearSearch = false;

  final Map<int, bool> _isExpandedMapEx = {};
  final Map<int, bool> _isExpandedMapIn = {};

  // final _categoryIdSelected =
  //     SharedPreferencesStorage().getItemCategorySelected().categoryId;

  @override
  void initState() {
    BlocProvider.of<OptionCategoryBloc>(context).add(GetOptionCategoryEvent());
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _showClearSearch = _searchController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Scaffold(
        appBar: _appBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Colors.grey.withOpacity(0.3),
                labelColor: Theme.of(context).primaryColor,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                indicatorWeight: 2,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: const [
                  Tab(
                    text: 'CHI TIỀN',
                  ),
                  Tab(
                    text: 'THU TIỀN',
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocConsumer<OptionCategoryBloc, OptionCategoryState>(
                listenWhen: (preState, curState) {
                  return curState.apiError != ApiError.noError;
                },
                listener: (context, state) {
                  if (state.apiError == ApiError.internalServerError) {
                    showMessage1OptionDialog(
                      context,
                      'Error!',
                      content: 'Internal_server_error',
                    );
                  }
                  if (state.apiError == ApiError.noInternetConnection) {
                    showMessageNoInternetDialog(context);
                  }
                },
                builder: (context, state) {
                  if (state.isNoInternet) {
                    showMessageNoInternetDialog(context);
                  }
                  if (state.isLoading) {
                    return const AnimationLoading();
                  } else {
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        _payTab(state), //expense
                        _collectTab(state), //income
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payTab(OptionCategoryState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _itemSearch(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                itemCount: state.listExpenseCategory?.length,
                itemBuilder: (context, index) {
                  final isExpanded = _isExpandedMapEx[index] ?? true;
                  return Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 0,
                        leading: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpandedMapEx[index] = !isExpanded;
                            });
                          },
                          child: Icon(
                            isExpanded ? Icons.expand_more : Icons.expand_less,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                        title: InkWell(
                          onTap: () async {
                            await SharedPreferencesStorage()
                                .setItemCategorySelected(
                              categoryId: state.listExpenseCategory?[index].id,
                              leading: state
                                  .listExpenseCategory?[index].logoImageUrl,
                              title: state.listExpenseCategory?[index].name,
                            );
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AppImage(
                                    localPathOrUrl: state
                                        .listExpenseCategory?[index]
                                        .logoImageUrl,
                                    errorWidget: const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    state.listExpenseCategory?[index].name ??
                                        '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: (widget.categoryIdSelected ==
                                        state.listExpenseCategory?[index].id)
                                    ? Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        SizedBox(
                          height: 50 *
                              (state.listExpenseCategory?[index].childCategory
                                      ?.length)!
                                  .toDouble(),
                          child: ListView.builder(
                            itemCount: state.listExpenseCategory?[index]
                                .childCategory?.length,
                            itemBuilder: (context, indexx) =>
                                _itemChildCategory(
                              context,
                              state.listExpenseCategory?[index]
                                  .childCategory?[indexx],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _collectTab(OptionCategoryState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _itemSearch(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ListView.builder(
                itemCount: state.listIncomeCategory?.length,
                itemBuilder: (context, index) {
                  final isExpanded = _isExpandedMapIn[index] ?? true;
                  return Column(
                    children: [
                      ListTile(
                        minLeadingWidth: 0,
                        leading: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpandedMapIn[index] = !isExpanded;
                            });
                          },
                          child: Icon(
                            isExpanded ? Icons.expand_more : Icons.expand_less,
                            size: 24,
                            color: Colors.grey,
                          ),
                        ),
                        title: InkWell(
                          onTap: () async {
                            await SharedPreferencesStorage()
                                .setItemCategorySelected(
                              categoryId: state.listIncomeCategory?[index].id,
                              leading:
                                  state.listIncomeCategory?[index].logoImageUrl,
                              title: state.listIncomeCategory?[index].name,
                            );
                            if (mounted) {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AppImage(
                                    localPathOrUrl: state
                                        .listIncomeCategory?[index]
                                        .logoImageUrl,
                                    errorWidget: const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    state.listIncomeCategory?[index].name ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: (widget.categoryIdSelected ==
                                        state.listIncomeCategory?[index].id)
                                    ? Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isExpanded)
                        SizedBox(
                          height: 50 *
                              (state.listIncomeCategory?[index].childCategory
                                      ?.length)!
                                  .toDouble(),
                          child: ListView.builder(
                            itemCount: state.listIncomeCategory?[index]
                                .childCategory?.length,
                            itemBuilder: (context, indexx) =>
                                _itemChildCategory(
                              context,
                              state.listIncomeCategory?[index]
                                  .childCategory?[indexx],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemChildCategory(BuildContext context, CategoryModel? item) {
    return InkWell(
      onTap: () async {
        await SharedPreferencesStorage().setItemCategorySelected(
          categoryId: item?.id,
          leading: item?.logoImageUrl,
          title: item?.name,
        );
        if (mounted) {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(80, 6, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.withOpacity(0.3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AppImage(
                  localPathOrUrl: item?.logoImageUrl,
                  errorWidget: Container(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  item?.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            (widget.categoryIdSelected == item?.id)
                ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _itemSearch() {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              maxLines: 1,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  size: 24,
                  color: Colors.grey,
                ),
                hintText: 'Tìm theo tên hạng mục',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: _showClearSearch
                ? InkWell(
                    onTap: () {
                      _searchController.clear();
                    },
                    child: const Icon(
                      Icons.cancel,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 0,
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
        'Chọn hạng mục',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CategoryItemBloc(context),
                  child: const CategoryItem(),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.edit_note,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
