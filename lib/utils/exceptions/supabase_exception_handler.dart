import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseExceptionHandler {
  static String parse(Object error) {
    final errorString = error.toString().toLowerCase();
    debugPrint("🧨 Raw Error Type: ${error.runtimeType}");
    debugPrint("🧨 Raw Error: $error");

    // 🔐 AuthException (like wrong credentials or unverified email)
    if (error is AuthException) {
      final message = error.message.toLowerCase();

      if (message.contains('invalid login credentials')) {
        return "Incorrect email or password. Please try again.";
      } else if (message.contains('email not confirmed')) {
        return "Your email is not confirmed yet. Please verify your email.";
      } else if (message.contains('user already registered')) {
        return "This email is already registered.";
      } else if (message.contains('invalid email')) {
        return "The email address is invalid.";
      }

      return error.message;
    }

    // 🗃️ Supabase DB policy or constraint issues
    if (error is PostgrestException) {
      final code = error.code;
      final message = (error.message).toLowerCase();

      if (code == '42501' || message.contains('rls')) {
        return "Permission denied: RLS policy blocked this action.";
      } else if (code == '23505' || message.contains('duplicate')) {
        return "Duplicate entry found. Please check your data.";
      } else if (code == '22003' || message.contains('out of range')) {
        return "Data value is out of range.";
      }

      return error.message;
    }

    // 🔁 Catch manually for string-based Postgrest-like errors
    if (errorString.contains("rls") || errorString.contains("row-level security")) {
      return "Row Level Security policy prevented this action. Make sure 'user_id' is included and policies allow this.";
    }

    if (errorString.contains("duplicate")) {
      return "Duplicate entry found. Please check your data.";
    }

    if (errorString.contains("out of range")) {
      return "A field has an invalid or too large value.";
    }

    // 🌐 Network issues
    if (errorString.contains("socketexception")) {
      return "No internet connection. Please check your network.";
    }

    // 🔄 Unknown fallback
    return "Unexpected error occurred: ${error.toString()}";
  }
}
