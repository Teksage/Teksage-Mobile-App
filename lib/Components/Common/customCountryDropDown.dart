import 'dart:io';

import 'package:astro_prompt/Model/country_model.dart';
import 'package:astro_prompt/Utility/colorConstant.dart';
import 'package:astro_prompt/Utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:astro_prompt/config/Helper/appFont.dart';

class CountryDropdownDialog extends StatefulWidget {
  final List<Country> countries;
  const CountryDropdownDialog({super.key, required this.countries});

  @override
  State<CountryDropdownDialog> createState() => _CountryDropdownDialogState();
}

class _CountryDropdownDialogState extends State<CountryDropdownDialog> {
  List<Country> filtered = [];

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtered = widget.countries;
  }

  @override
  Widget build(BuildContext context) {
    final util = MyUtility(context);

    return AlertDialog(
      title: Text(
        'Select Country Dial Code',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: AppFont.get(FontType.medium),
            fontSize: util.fontSize18,
            color: blackColor.withValues(alpha: 0.6),
            height: util.responsiveHeight(0.0248) /
                util.responsiveFontSize(0.0304)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  final query = value.toLowerCase();
                  filtered = widget.countries
                      .where((c) =>
                          c.dialCode.toLowerCase().contains('+$query') ||
                          c.countryName.toLowerCase().contains(query))
                      .toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search ...',
                hintStyle: TextStyle(
                    fontFamily: AppFont.get(FontType.medium),
                    fontSize: util.fontSize18,
                    color: blackColor.withValues(alpha: 0.6),
                    height: util.responsiveHeight(0.0248) /
                        util.responsiveFontSize(0.0304)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(util.width12),
                  borderSide:
                      BorderSide(color: blackColor.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(util.width12),
                  borderSide: BorderSide(
                      color: (Platform.isAndroid ? mainColor : iosMainColor),
                      width: 2),
                ),
              ),
              style: TextStyle(
                  fontFamily: AppFont.get(FontType.medium),
                  fontSize: util.fontSize18,
                  color: blackColor,
                  height: util.responsiveHeight(0.0248) /
                      util.responsiveFontSize(0.0304)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, index) {
                  final country = filtered[index];
                  return ListTile(
                      leading: Image.network(country.countryFlag,
                          width: 30,
                          height: 20,
                          errorBuilder: (_, __, ___) => const Icon(
                                Icons.flag,
                                size: 20,
                              )),
                      title: Text(
                        '${country.countryName} (${country.dialCode})',
                        style: TextStyle(
                            fontFamily: 'FontSemiBold',
                            fontSize: util.fontSize16,
                            height: util.lineHeight21_6 / util.fontSize16),
                      ),
                      onTap: () {
                        Navigator.pop(context, <String, String>{
                          'countryFlag': country.countryFlag,
                          'dialCode': country.dialCode,
                          'mobileNumberLength':
                              country.mobileNumberLength.toString(),
                        });
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
