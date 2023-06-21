import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class Category {
  final String icon;
  final String title;

  Category({required this.icon, required this.title});
}

List<Category> demoCategories = [
  Category(
    icon: "assets/icons/Location.svg",
    title: "Land",
  ),
  Category(
    icon: "assets/icons/bag_1.svg",
    title: "Vehicle",
  ),
  Category(
    icon: "assets/icons/pants.svg",
    title: "Bicycle",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Books",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Cars",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Cars",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Cars",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Cars",
  ),
  Category(
    icon: "assets/icons/Filter.svg",
    title: "Cars",
  ),
];

class Categories extends StatefulWidget {
  final List<Category> categories;
  final void Function(int) onCategorySelected;

  const Categories({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.categories.length,
          (index) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onCategorySelected(index); // Pass the index here
            },
            child: CategoryCard(
              category: widget.categories[index],
              isSelected: _selectedIndex == index,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final bool isSelected;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: SvgPicture.asset(
            category.icon,
            color: isSelected ? Colors.white : kTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          category.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? kPrimaryColor : kTextColor.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
