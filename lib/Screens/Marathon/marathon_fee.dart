class MarathonFeeParts {
  const MarathonFeeParts({
    required this.base,
    required this.cgst,
    required this.sgst,
    required this.total,
    required this.cgstPct,
    required this.sgstPct,
  });

  final double base;
  final double cgst;
  final double sgst;
  final double total;
  final int cgstPct;
  final int sgstPct;

  bool get taxed => cgstPct > 0 || sgstPct > 0;
}

double _round2(double value) {
  final scaled = value * 100;
  final bumped = scaled + (scaled.isNegative ? -1e-8 : 1e-8);
  return bumped.roundToDouble() / 100;
}

/// Event fee is pre-tax. INR adds 9% CGST and 9% SGST, same as a single query.
MarathonFeeParts marathonFeeAdded(num fee, String currency) {
  final base = _round2(fee.toDouble());
  if (currency.toUpperCase() != 'INR') {
    return MarathonFeeParts(base: base, cgst: 0, sgst: 0, total: base, cgstPct: 0, sgstPct: 0);
  }
  const cgstPct = 9;
  const sgstPct = 9;
  final cgst = _round2(base * cgstPct / 100);
  final sgst = _round2(base * sgstPct / 100);
  return MarathonFeeParts(
    base: base,
    cgst: cgst,
    sgst: sgst,
    total: _round2(base + cgst + sgst),
    cgstPct: cgstPct,
    sgstPct: sgstPct,
  );
}

/// Split a collected total that already includes GST.
MarathonFeeParts marathonFeeIncluded(num paid, String currency) {
  final total = _round2(paid.toDouble());
  if (currency.toUpperCase() != 'INR') {
    return MarathonFeeParts(base: total, cgst: 0, sgst: 0, total: total, cgstPct: 0, sgstPct: 0);
  }
  const cgstPct = 9;
  const sgstPct = 9;
  final base = _round2(total / (1 + (cgstPct + sgstPct) / 100));
  final gst = _round2(total - base);
  final cgst = _round2(gst / 2);
  final sgst = _round2(gst - cgst);
  return MarathonFeeParts(
    base: base,
    cgst: cgst,
    sgst: sgst,
    total: total,
    cgstPct: cgstPct,
    sgstPct: sgstPct,
  );
}
