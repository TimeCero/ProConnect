import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  const SearchBar({Key? key, required this.onChanged, this.hint = 'Buscar...'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
