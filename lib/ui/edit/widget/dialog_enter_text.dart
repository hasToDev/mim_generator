import 'package:flutter/material.dart';

class DialogEnterText extends StatelessWidget {
  const DialogEnterText({
    Key? key,
    required this.onChanged,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  final Function(String) onChanged;
  final Function() onCancel;
  final Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Enter Text',
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
          scrollPadding: const EdgeInsets.all(4.0),
        ),
        const SizedBox(height: 6.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onCancel,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: onConfirm,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: Text(
                'Confirm',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
