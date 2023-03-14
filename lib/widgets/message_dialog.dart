import 'package:flutter/cupertino.dart';

class MessageDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final Function()? onClose;
  final String? buttonLabel;

  const MessageDialog({
    Key? key,
    this.title,
    this.content,
    this.onClose,
    this.buttonLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title == null? null : Text(title!),
      content: content == null ? null : Text(content!),
      actions: <Widget>[
        CupertinoDialogAction(
            onPressed: (){
              Navigator.pop(context);
              if(onClose !=null){
                onClose!();
              }
            },
            child: Text(buttonLabel ?? 'OK')),
      ],
    );
  }
}
