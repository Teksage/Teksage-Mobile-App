import 'package:astro_prompt/Components/Horoscope/horoscopeChart.dart';
import 'package:astro_prompt/Model/horoscope_model.dart';
import 'package:astro_prompt/Services/HoroscopeService/horoscopeService.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';
import 'package:flutter/material.dart';

class DivisionalChartPicker extends StatefulWidget {
  final Horoscope horoscope;

  const DivisionalChartPicker({super.key, required this.horoscope});

  @override
  State<DivisionalChartPicker> createState() => _DivisionalChartPickerState();
}

class _DivisionalChartPickerState extends State<DivisionalChartPicker> {
  late List<HoroscopeDivisionalChart> _charts;
  String _selectedId = 'd1';

  @override
  void initState() {
    super.initState();
    _charts = fallbackDivisionalCharts(widget.horoscope);
    if (_charts.isNotEmpty) {
      _selectedId = _charts.first.id;
    }
    _loadCharts();
  }

  Future<void> _loadCharts() async {
    try {
      final next = await HoroscopeService().getHoroscopeCharts();
      if (!mounted || next.isEmpty) return;
      setState(() {
        _charts = next;
        if (!_charts.any((c) => c.id == _selectedId)) {
          _selectedId = _charts.first.id;
        }
      });
    } catch (_) {
      /* keep D1/D9 from the main horoscope payload */
    }
  }

  HoroscopeDivisionalChart? get _current {
    for (final chart in _charts) {
      if (chart.id == _selectedId) return chart;
    }
    return _charts.isEmpty ? null : _charts.first;
  }

  void _go(int delta) {
    if (_charts.isEmpty) return;
    final index = _charts.indexWhere((c) => c.id == _selectedId);
    final safe = index < 0 ? 0 : index;
    final next = (safe + delta + _charts.length) % _charts.length;
    setState(() => _selectedId = _charts[next].id);
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);
    final current = _current;
    if (current == null) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: util.height20),
        Container(
          width: util.width,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: mainColor.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _go(-1),
                icon: const Icon(Icons.chevron_left, color: panchangHeading),
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: current.id,
                    iconEnabledColor: panchangHeading,
                    items: _charts
                        .map(
                          (chart) => DropdownMenuItem(
                            value: chart.id,
                            child: Text(
                              chart.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    selectedItemBuilder: (context) => _charts
                        .map(
                          (chart) => Center(
                            child: Text(
                              chart.label.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: AppFont.get(FontType.semiBold),
                                fontSize: util.fontSize14,
                                color: panchangHeading,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      if (id == null) return;
                      setState(() => _selectedId = id);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _go(1),
                icon: const Icon(Icons.chevron_right, color: panchangHeading),
              ),
            ],
          ),
        ),
        SizedBox(height: util.height20),
        ChartWidget(htmlChart: current.html),
      ],
    );
  }
}
