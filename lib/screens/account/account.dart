import 'package:flutter/material.dart';
import 'package:viet_wallet/utilities/screen_utilities.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: InkWell(
                onTap: () async{
                  print('logout');
                  logout(context);
                  // await showDialog(context: context, builder: (context){
                  //   return Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     child: AlertDialog(
                  //       title: const Text('Đăng xuất', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red,),),
                  //       content: Text('Bạn có muón đăng xuất tài khoản?'),
                  //       actions: <Widget>[
                  //         Size
                  //       ],
                  //
                  //     ),
                  //   );
                  // });
                },
                child: SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
                          Icons.logout,
                          size: 24,
                          color: Colors.red,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text(
                          'Đăng xuất',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
