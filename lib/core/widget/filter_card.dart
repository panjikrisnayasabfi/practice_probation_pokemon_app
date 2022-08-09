import 'package:flutter/material.dart';

class FilterCard extends StatelessWidget {
  final String filterName;
  final Function onTap;
  final bool isSelected;

  const FilterCard({
    Key key,
    @required this.filterName,
    @required this.onTap,
    @required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Card(
          color: isSelected ? Colors.red[200] : null,
          child: Center(
            child: Text(filterName),
          ),
        ),
      ),
    );
  }
}
