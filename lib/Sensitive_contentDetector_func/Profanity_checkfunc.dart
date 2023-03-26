import 'package:profanity_filter/profanity_filter.dart';
import 'package:flutter/material.dart';

bool profanity_detector(String input) {
  final filter = ProfanityFilter();
  final filteredInput = filter.censor(input);
  return filteredInput != input;
}
