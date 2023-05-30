import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clockwisehq/global/global.dart' as global;
import '../provider/provider.dart';

class AddedItemList extends StatefulWidget {
  final List<String> itemTitles;
  final Map<String, List<TimeOfDay>> timeOfDayMap;
  const AddedItemList({super.key, required this.itemTitles, required this.timeOfDayMap});

  @override
  State<AddedItemList> createState() => _AddedItemListState();
}

class _AddedItemListState extends State<AddedItemList> {
  void deleteItem(int index) {
    setState(() {
      String removed = widget.itemTitles.removeAt(index);
      widget.timeOfDayMap.remove(removed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.itemTitles.map((title) {
        return AddedItem(
          title: title,
          onDelete: () => deleteItem(widget.itemTitles.indexOf(title)),
        );
      }).toList(),
    );
  }
}

class AddedItem extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;

  const AddedItem({Key? key, required this.title, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);

    if (provider.isDarkMode == true) {
      global.aColor = Colors.white;
      global.bColor = Colors.black;
    } else {
      global.bColor = Colors.white;
      global.aColor = Colors.black;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        border: Border.all(
          color: global.cColor,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 5,),
          Text(
            title,
            style: TextStyle(color: global.aColor),
          ),
          const SizedBox(width: 11),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: global.cColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                border: Border.all(
                  color: global.cColor,
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.close_sharp,
                  size: 15,
                  color: global.aColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
