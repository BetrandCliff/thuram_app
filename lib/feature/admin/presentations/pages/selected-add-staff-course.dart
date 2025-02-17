


import 'package:flutter/material.dart';
import 'package:thuram_app/core/constants/colors.dart';
import 'package:thuram_app/util/widthandheight.dart';

class SelectionDialog extends StatefulWidget {
  @override
  _SelectionDialogState createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  List<Item> items = List.generate(5, (index) {
    return Item('Item ${index + 1}', false);
  });
  List<Item> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = items;
    searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      filteredItems = items
          .where((item) =>
              item.name.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _confirmSelection() {
    List<Item> selectedItems = items.where((item) => item.isSelected).toList();
    // Handle selected items, for example, print or save them
    Navigator.of(context).pop();  // Close the dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected items: ${selectedItems.map((item) => item.name).join(', ')}')),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        // width: width(context),
        height: height(context)/2,
        child: AlertDialog(
          title:  TextField(
            style: Theme.of(context).textTheme.displayMedium,
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Select Cours',
                    // border: In,
                    
                    border:InputBorder.none,
                    suffixIcon: Icon(Icons.search)
                  ),
                ),
          content: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
             
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: filteredItems.map((item) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isSelected = !item.isSelected;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          // padding: EdgeInsets.all(),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                            color: item.isSelected ? AppColors.secondaryColor : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.transparent,
                                side: BorderSide.none,
                                value: item.isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    item.isSelected = value ?? false;
                                  });
                                },
                                
                              ),
                              Expanded(child: Text(item.name,style: Theme.of(context).textTheme.displayMedium!.copyWith(color: item.isSelected?Colors.white:Colors.black),)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without taking action
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _confirmSelection,
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  String name;
  bool isSelected;

  Item(this.name, this.isSelected);
}