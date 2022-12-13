import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  final bool isLoading;
  final String title;
  final IconData? icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: !isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                      ),
                ),
              ],
            )
          : const SizedBox(
              width: 32.0,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3.0,
                ),
              ),
            ),
    );
  }
}
