String extractCityName(String location) {
  if (location.isEmpty) return '';
  return location.split(',').first.trim();
}
