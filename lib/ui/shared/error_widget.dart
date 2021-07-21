import 'package:flutter/material.dart';
import 'package:mafcode/ui/shared/error_utils.dart';

class MafcodeErrorWidget extends StatelessWidget {
  final dynamic error;
  final Function onReload;
  final List<Widget> extraWidgets;

  const MafcodeErrorWidget(this.error, {Key key, this.onReload, this.extraWidgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ErrorUtils.getMessage(error),
            style: TextStyle(color: Colors.red),
          ),
          if (onReload != null)
            OutlinedButton(
              onPressed: onReload,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 10),
                  Text("Reload"),
                ],
              ),
            ),
          if (extraWidgets != null) ...extraWidgets,
        ],
      ),
    );
  }
}
