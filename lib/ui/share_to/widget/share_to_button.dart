import 'package:flutter/material.dart';

class ShareToButton extends StatelessWidget {
  const ShareToButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      margin: const EdgeInsets.only(bottom: 6.0, left: 6.0, right: 6.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
