int marathonInt(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;

/// Slot ids the signed-in user already booked for this event.
/// Older bookings without a slot id are matched by start time.
Set<int> marathonBookedSlotIds(Map<String, dynamic>? event, List<Map<String, dynamic>> rows) {
  final ids = <int>{};
  if (event == null) return ids;
  final slots = List<Map<String, dynamic>>.from(event['slots'] ?? []);
  for (final row in rows) {
    if (row['marathon_id'] != null && marathonInt(row['marathon_id']) != marathonInt(event['id'])) continue;
    final id = marathonInt(row['slot_id']);
    if (id > 0) {
      ids.add(id);
      continue;
    }
    final start = DateTime.tryParse('${row['starts_at'] ?? ''}');
    if (start == null) continue;
    for (final slot in slots) {
      final slotStart = DateTime.tryParse('${slot['starts_at'] ?? ''}');
      if (slotStart != null && slotStart.toUtc() == start.toUtc()) ids.add(marathonInt(slot['id']));
    }
  }
  return ids;
}

/// First slot with seats left that the user has not booked. Null when none.
int? marathonFirstOpenSlot(Map<String, dynamic> event, List<Map<String, dynamic>> rows) {
  if (event['booking_open'] != true || event['admin_ended'] == true) return null;
  final taken = marathonBookedSlotIds(event, rows);
  final slots = List<Map<String, dynamic>>.from(event['slots'] ?? []);
  for (final slot in slots) {
    final id = marathonInt(slot['id']);
    if (id > 0 && !taken.contains(id) && marathonInt(slot['seats_left']) > 0) return id;
  }
  return null;
}
