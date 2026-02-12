import 'dart:developer';

import 'package:feedback_system/color.dart';
import 'package:feedback_system/view/widgets/feedback_screen_action_button.dart';

import 'package:feedback_system/view/widgets/feedback_type_container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../controller/feedback_provider.dart';
import '../../model/feedback_model.dart';
import '../widgets/feedback_card.dart';

class FeedbackDashboard extends StatefulWidget {
  const FeedbackDashboard({super.key});

  @override
  State<FeedbackDashboard> createState() => _FeedbackDashboardState();
}

class _FeedbackDashboardState extends State<FeedbackDashboard> {
  final TextEditingController _searchController = TextEditingController();

  void _emptySearch() {
    _searchController.clear();
    context.read<FeedbackProvider>().setQuery("");
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedbackProvider>().calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width <= 1000;
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          size
              ? Column(
                  children: [
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Selector<FeedbackProvider, int>(
                            selector: (_, p) => p.getAll,
                            builder: (_, value, _) =>
                                FeedbackTypeContainer(title: "Total Feedback", svg: "assets/svg/total_rating.svg", text: "$value"),
                          ),
                        ),
                        Expanded(
                          child: Selector<FeedbackProvider, double>(
                            selector: (_, p) => p.getAverageRating,
                            builder: (_, value, _) =>
                                FeedbackTypeContainer(text: "$value", title: "Average Rating", svg: "assets/svg/avg_rating.svg"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Selector<FeedbackProvider, double>(
                            selector: (_, p) => p.getPositivePercentage,
                            builder: (_, value, _) => FeedbackTypeContainer(
                              text: "$value%",
                              title: "Positive%",
                              svg: "assets/svg/positive_rating.svg",
                              textColor: Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Selector<FeedbackProvider, double>(
                            selector: (_, p) => p.getNegativePercentage,
                            builder: (_, value, _) => FeedbackTypeContainer(
                              text: "$value%",
                              title: "Negative%",
                              svg: "assets/svg/negative_rating.svg",
                              textColor: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Selector<FeedbackProvider, int>(
                        selector: (_, p) => p.getAll,
                        builder: (_, value, _) => FeedbackTypeContainer(title: "Total Feedback", svg: "assets/svg/total_rating.svg", text: "$value"),
                      ),
                    ),
                    Expanded(
                      child: Selector<FeedbackProvider, double>(
                        selector: (_, p) => p.getAverageRating,
                        builder: (_, value, _) => FeedbackTypeContainer(text: "$value", title: "Average Rating", svg: "assets/svg/avg_rating.svg"),
                      ),
                    ),
                    Expanded(
                      child: Selector<FeedbackProvider, double>(
                        selector: (_, p) => p.getPositivePercentage,
                        builder: (_, value, _) => FeedbackTypeContainer(
                          text: "$value%",
                          title: "Positive%",
                          svg: "assets/svg/positive_rating.svg",
                          textColor: Colors.green,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Selector<FeedbackProvider, double>(
                        selector: (_, p) => p.getNegativePercentage,
                        builder: (_, value, _) =>
                            FeedbackTypeContainer(text: "$value%", title: "Negative%", svg: "assets/svg/negative_rating.svg", textColor: Colors.red),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 6,
                child: Selector<FeedbackProvider, (String, List<dynamic>)>(
                  selector: (_, p) => (p.dropDownFromData, p.formNameList),
                  builder: (context, data, _) {
                    final dropDownFromData = data.$1;
                    final formNameList = data.$2;
                    log(dropDownFromData.toString());
                    return DropdownButtonFormField(
                      initialValue: dropDownFromData,
                      decoration: InputDecoration(
                        label: Text(
                          "Select From",
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.black, width: 0.5),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      items: [
                        DropdownMenuItem<String>(value: "All", child: Text("All")),
                        ...formNameList.map((e) {
                          return DropdownMenuItem<String>(value: e["form_id"].toString(), child: Text(e["form_name"]));
                        }),
                      ],
                      onChanged: (val) {
                        context.read<FeedbackProvider>().setDropDownFromData(val!);
                      },
                    );
                  },
                ),
              ),

              Selector<FeedbackProvider, String>(
                selector: (_, p) => p.selectedCategory,
                builder: (context, selectedCategory, child) {
                  return Expanded(
                    flex: 2,
                    child: FeedbackScreenActionButton(
                      text: "All",
                      isSelected: selectedCategory == "All",
                      onTap: () {
                        context.read<FeedbackProvider>().setSelectedCategory("All");
                        _emptySearch();
                      },
                      backgournd: ColorClass.white,
                      textSize: 15,
                    ),
                  );
                },
              ),
              Selector<FeedbackProvider, String>(
                selector: (_, p) => p.selectedCategory,
                builder: (context, selectedCategory, child) {
                  return Expanded(
                    flex: 3,
                    child: FeedbackScreenActionButton(
                      text: "5 Stars",
                      isSelected: selectedCategory == "5 Stars",
                      onTap: () {
                        context.read<FeedbackProvider>().setSelectedCategory("5 Stars");
                        _emptySearch();
                      },
                      backgournd: ColorClass.white,
                      textSize: 15,
                    ),
                  );
                },
              ),
              Selector<FeedbackProvider, String>(
                selector: (_, p) => p.selectedCategory,
                builder: (context, selectedCategory, child) {
                  return Expanded(
                    flex: 3,
                    child: FeedbackScreenActionButton(
                      text: "Positive",
                      isSelected: selectedCategory == "Positive",
                      onTap: () {
                        context.read<FeedbackProvider>().setSelectedCategory("Positive");
                        _emptySearch();
                      },
                      backgournd: ColorClass.white,
                      textSize: 15,
                    ),
                  );
                },
              ),
              Selector<FeedbackProvider, String>(
                selector: (_, p) => p.selectedCategory,
                builder: (context, selectedCategory, child) {
                  return Expanded(
                    flex: 3,
                    child: FeedbackScreenActionButton(
                      text: "Negative",
                      isSelected: selectedCategory == "Negative",
                      onTap: () {
                        context.read<FeedbackProvider>().setSelectedCategory("Negative");
                        _emptySearch();
                      },
                      backgournd: ColorClass.white,
                      textSize: 15,
                    ),
                  );
                },
              ),
              Expanded(
                flex: 4,
                child: Selector<FeedbackProvider, String>(
                  selector: (_, p) => p.query,
                  builder: (context, query, child) {
                    return TextField(
                      onChanged: (val) {
                        context.read<FeedbackProvider>().setQuery(val);
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search Name",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: query.isNotEmpty ? IconButton(onPressed: _emptySearch, icon: const Icon(Icons.clear)) : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: ColorClass.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: ColorClass.divider),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Selector<FeedbackProvider, (bool, List<FeedbackModel>)>(
            selector: (_, p) => (p.isLoading, p.filterList),
            builder: (context, data, child) {
              final isLoading = data.$1;
              final filterList = data.$2;
              return Expanded(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorClass.divider, width: 0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filterList.isEmpty
                        ? const Center(child: Text("No Data"))
                        : ListView.builder(
                            itemCount: filterList.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return FeedbackCard(fb: filterList[index]);
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
