/// Event Planner (Muhurtha) constants — mirrors web `muhurtha-screen.ts`.
class EventPlannerConfig {
  static const storagePrefix = 'teksage_event_planner_v3';
  static const ttlDays = 10;
  static const maxStartDaysAhead = 30;

  static const eventTypes = [
    'Job Interview',
    'Financial Investment',
    'Learning New Skill',
    'Vehicle Purchase',
    'Travel',
    'Business Decisions',
  ];

  static const reasonCodes = [
    'nakshatra_not_suitable',
    'weekday_excluded',
    'thithi_excluded',
    'yoga_excluded',
    'thara_bala_excluded',
    'chandra_bala_excluded',
    'no_auspicious_window',
  ];
}
