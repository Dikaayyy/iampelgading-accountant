import 'package:flutter/material.dart';

class AppTextStyles {
  // Dashboard specific text styles
  static const TextStyle dashboardTitle = TextStyle(
    color: Color(0xFF202D41),
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
  );

  static const TextStyle balanceAmount = TextStyle(
    color: Color(0xFF202D41),
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.50,
    fontFamily: 'Poppins',
  );

  static const TextStyle balanceLabel = TextStyle(
    color: Color(0xFF202D41),
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle incomeExpenseAmount = TextStyle(
    color: Color(0xFF202D41),
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    fontFamily: 'Poppins',
  );

  static const TextStyle incomeExpenseLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.80,
    fontFamily: 'Poppins',
  );

  // Transaction specific text styles
  static const TextStyle transactionTitle = TextStyle(
    color: Color(0xFF1F2C40),
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  static const TextStyle transactionTime = TextStyle(
    color: Color(0xFF6A788C),
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
  );

  static const TextStyle transactionAmount = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
  );

  // Header text styles
  static const TextStyle headerGreeting = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.80,
    fontFamily: 'Poppins',
  );

  static const TextStyle headerUserName = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    fontFamily: 'Poppins',
  );

  // Button text styles
  static const TextStyle viewAllButton = TextStyle(
    color: Color(0xFF64B5F6),
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  // Tab bar text styles
  static const TextStyle tabBarSelected = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabBarUnselected = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  // Financial page header
  static const TextStyle financialPageTitle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
    fontFamily: 'Poppins',
  );
}
