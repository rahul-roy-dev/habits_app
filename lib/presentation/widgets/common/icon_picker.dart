import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:habits_app/core/constants/app_dimensions.dart';
import 'package:habits_app/core/constants/lucide_icons_list.dart';

class IconPickerResult {
  final String name;
  final IconData icon;
  const IconPickerResult(this.name, this.icon);
}

Future<IconPickerResult?> showIconPicker(
  BuildContext context, {
  Color? accentColor,
  IconData? initialIcon,
}) {
  return showModalBottomSheet<IconPickerResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => IconPickerSheet(
      accentColor: accentColor ?? Theme.of(context).colorScheme.primary,
      initialIcon: initialIcon,
    ),
  );
}

class IconPickerSheet extends StatefulWidget {
  final Color accentColor;
  final IconData? initialIcon;

  const IconPickerSheet({
    super.key,
    required this.accentColor,
    this.initialIcon,
  });

  @override
  State<IconPickerSheet> createState() => _IconPickerSheetState();
}

const int _crossAxisCount = 6;
const int _rowsPerPage = 8;
const int _iconsPerPage = _crossAxisCount * _rowsPerPage;

class _IconPickerSheetState extends State<IconPickerSheet> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  late PageController _pageCtrl;
  late IconData? _selected;

  late List<MapEntry<String, IconData>> _allIcons;
  List<MapEntry<String, IconData>> _filtered = [];
  List<List<MapEntry<String, IconData>>> _pages = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _selected = widget.initialIcon;

    _allIcons = getLucideIconList();
    _filtered = _allIcons;
    _updatePages();

    _searchCtrl.addListener(_onSearch);
  }

  void _updatePages() {
    _pages = [];
    for (var i = 0; i < _filtered.length; i += _iconsPerPage) {
      _pages.add(_filtered.sublist(i, (i + _iconsPerPage).clamp(0, _filtered.length)));
    }
    if (_pages.isEmpty) _pages.add([]);
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _allIcons
          : _allIcons
              .where((e) => e.key.toLowerCase().contains(q))
              .toList();
      _updatePages();
      _currentPage = 0;
      if (_pageCtrl.hasClients) _pageCtrl.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _pick(MapEntry<String, IconData> entry) {
    setState(() => _selected = entry.value);
    Navigator.of(context).pop(IconPickerResult(entry.key, entry.value));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.accentColor;

    return DraggableScrollableSheet(
      initialChildSize: AppDimensions.iconPickerInitialChildSize,
      minChildSize: AppDimensions.iconPickerMinChildSize,
      maxChildSize: AppDimensions.iconPickerMaxChildSize,
      snap: true,
      snapSizes: AppDimensions.iconPickerSnapSizes,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.iconPickerSheetBorderRadius),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: AppDimensions.spacingSm,
                  bottom: AppDimensions.spacingXs,
                ),
                child: Container(
                  width: AppDimensions.iconPickerHandleWidth,
                  height: AppDimensions.iconPickerHandleHeight,
                  decoration: BoxDecoration(
                    color: scheme.onSurface
                        .withValues(alpha: AppDimensions.iconPickerHandleOpacity),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.iconPickerHandleBorderRadius,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingLg),
                child: Row(
                  children: [
                    Text(
                      'Choose icon',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeXl,
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_filtered.length} icons',
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeSm,
                        color: scheme.onSurface.withValues(
                            alpha: AppDimensions.iconPickerPrefixIconOpacity),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingMd),
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _focusNode,
                  autofocus: false,
                  style: TextStyle(
                      fontSize: AppDimensions.fontSizeLg,
                      color: scheme.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Search icons…',
                    hintStyle: TextStyle(
                      fontSize: AppDimensions.fontSizeLg,
                      color: scheme.onSurface.withValues(
                          alpha: AppDimensions.iconPickerHintOpacity),
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      size: AppDimensions.iconPickerSearchIconSize,
                      color: scheme.onSurface.withValues(
                          alpha: AppDimensions.iconPickerPrefixIconOpacity),
                    ),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              _focusNode.unfocus();
                            },
                            child: Icon(
                              LucideIcons.x,
                              size: AppDimensions.iconPickerClearIconSize,
                              color: scheme.onSurface.withValues(
                                  alpha: AppDimensions.iconPickerPrefixIconOpacity),
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: scheme.onSurface.withValues(
                        alpha: AppDimensions.iconPickerFillOpacity),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.iconPickerSearchContentPaddingH,
                      vertical: AppDimensions.iconPickerSearchContentPaddingV,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingSm),
              Expanded(
                child: _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.search_x,
                              size: AppDimensions.iconPickerEmptyStateIconSize,
                              color: scheme.onSurface.withValues(
                                  alpha: AppDimensions.iconPickerEmptyOpacity),
                            ),
                            const SizedBox(height: AppDimensions.spacingXs),
                            Text(
                              'No icons match "${_searchCtrl.text}"',
                              style: TextStyle(
                                fontSize: AppDimensions.fontSizeMd,
                                color: scheme.onSurface.withValues(
                                    alpha: AppDimensions.iconPickerHintOpacity),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingMd),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.chevron_left,
                                  size: AppDimensions.iconPickerSearchIconSize,
                                  color: scheme.onSurface
                                      .withValues(alpha: AppDimensions.opacityHalf),
                                ),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Text(
                                  '${_currentPage + 1} / ${_pages.length}',
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontSizeSm,
                                    color: scheme.onSurface
                                        .withValues(alpha: AppDimensions.opacityHalf),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.spacingXs),
                                Icon(
                                  LucideIcons.chevron_right,
                                  size: AppDimensions.iconPickerSearchIconSize,
                                  color: scheme.onSurface
                                      .withValues(alpha: AppDimensions.opacityHalf),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacingXs),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageCtrl,
                              itemCount: _pages.length,
                              onPageChanged: (p) => setState(() => _currentPage = p),
                              itemBuilder: (_, pageIndex) {
                                final pageIcons = _pages[pageIndex];
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    AppDimensions.spacingMd,
                                    0,
                                    AppDimensions.spacingMd,
                                    AppDimensions.spacingMd,
                                  ),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount,
                                      mainAxisSpacing:
                                          AppDimensions.iconPickerGridSpacing,
                                      crossAxisSpacing:
                                          AppDimensions.iconPickerGridSpacing,
                                      childAspectRatio: 1,
                                    ),
                                    itemCount: pageIcons.length,
                                    itemBuilder: (__, i) {
                                      final entry = pageIcons[i];
                                      final isSelected = _selected == entry.value;

                                      return Tooltip(
                                        message: entry.key,
                                        waitDuration: const Duration(
                                            milliseconds: AppDimensions
                                                .iconPickerTooltipWaitMs),
                                        child: GestureDetector(
                                          onTap: () => _pick(entry),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: AppDimensions
                                                    .iconPickerSelectionAnimationMs),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? accent.withValues(alpha:
                                                      AppDimensions
                                                          .iconPickerSelectedBgOpacity)
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: isSelected
                                                    ? accent
                                                    : scheme.onSurface
                                                        .withValues(alpha:
                                                            AppDimensions
                                                                .iconPickerBorderOpacity),
                                                width: isSelected
                                                    ? AppDimensions
                                                        .iconPickerSelectedBorderWidth
                                                    : AppDimensions
                                                        .iconPickerUnselectedBorderWidth,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppDimensions
                                                          .iconPickerGridItemRadius),
                                            ),
                                            child: Icon(
                                              entry.value,
                                              size: AppDimensions
                                                  .iconPickerGridIconSize,
                                              color: isSelected
                                                  ? accent
                                                  : scheme.onSurface
                                                      .withValues(alpha:
                                                          AppDimensions
                                                              .iconPickerIconOpacity),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
