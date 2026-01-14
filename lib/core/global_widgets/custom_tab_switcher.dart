import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../exports.dart';
import 'custom_badge.dart';
class CustomTabSwitcher extends ConsumerStatefulWidget {
  final List<String> tabs;
  final List<IconData> icons;
  final List<Widget> tabWidgets;
  final StateProvider<int> indexProvider;
  final bool? showDotIndicator;
  const CustomTabSwitcher({
    super.key,
    required this.tabs,
    required this.icons,
    required this.tabWidgets,
    required this.indexProvider,
    this.showDotIndicator = false,
  }) : assert(tabs.length == tabWidgets.length);

  @override
  ConsumerState<CustomTabSwitcher> createState() => _CustomTabSwitcherState();
}

class _CustomTabSwitcherState extends ConsumerState<CustomTabSwitcher> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    final selectedIndex = ref.read(widget.indexProvider);
    pageController = PageController(initialPage: selectedIndex);
  }

  // @override
  // void didUpdateWidget(covariant CustomTabSwitcher oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Ensure pageController stays in sync if provider changes externally
  //   final selectedIndex = ref.read(widget.indexProvider);
  //   if (pageController.hasClients &&
  //       pageController.page?.round() != selectedIndex) {
  //     pageController.jumpToPage(selectedIndex);
  //   }
  // }

  void onTabTapped(int index) {
    ref.read(widget.indexProvider.notifier).state = index;
    HapticFeedback.selectionClick();
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(widget.indexProvider);

    // Whenever selectedIndex changes, animate the page

    // void onPageChanged(int index) {
    //   ref.read(widget.indexProvider.notifier).state = index;
    // }

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(widget.tabs.length, (index) {
              final isSelected = selectedIndex == index;
              // final tabWidth = widget.tabs[index].length * 8.5 + 24;
              // print(tabWidth);
              final tabWidth = (widget.tabs[index].length * 8.5 + 24).clamp(
                56.0,
                84.0,
              );

              return InkWell(
                onTap: () => onTabTapped(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Icon(widget.icons[index], size: 20),
                              Text(
                                widget.tabs[index],
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (index == 1 && (widget.showDotIndicator ?? false))
                          Positioned(
                            right: 4,
                            top: -4,
                            child: CustomBadge(
                              // text: widget.showDotIndicator![true].toString(),
                            ),
                          ),
                      ],
                    ),
                    6.heightBox,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 1.6,
                      width: tabWidth,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.black
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            // onPageChanged: onPageChanged,
            // onPageChanged: (index) =>
            //     ref.read(widget.indexProvider.notifier).state = index,
            children: widget.tabWidgets,
          ),
        ),
      ],
    );
  }
}