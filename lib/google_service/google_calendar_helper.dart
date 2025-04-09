import 'dart:async';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/calendar',
  ], // Request calendar scope
);

// Method to get the authenticated client for Google Calendar API
Future<AuthClient?> getGoogleAuthClient() async {
  try {
    // First, attempt silent sign-in
    final GoogleSignInAccount? googleUser =
        await _googleSignIn.signInSilently();

    // If no user is signed in, attempt the sign-in flow
    if (googleUser == null) {
      print("Google User not signed in. Attempting to sign in...");
      final GoogleSignInAccount? newGoogleUser = await _googleSignIn.signIn();
      if (newGoogleUser == null) {
        print("Google Sign-In failed or was canceled.");
        return null; // User canceled sign-in or failed to sign in
      }
      return await getAuthClientFromGoogleUser(newGoogleUser);
    }

    // If user is signed in, proceed to get the client
    print("Google User signed in successfully.");
    return await getAuthClientFromGoogleUser(googleUser);
  } catch (e) {
    print("Error in sign-in process: $e");
    return null;
  }
}

// Helper method to extract AuthClient from the signed-in Google User
Future<AuthClient?> getAuthClientFromGoogleUser(
    GoogleSignInAccount googleUser) async {
  try {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    print("Google Authentication Access Token: ${googleAuth.accessToken}");
    print("Google Authentication ID Token: ${googleAuth.idToken}");

    // Check if authentication tokens are available
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      print("Error: Missing Google Auth Tokens");
      return null;
    }

    // Ensure expiry time is in UTC
    final expiryDate = DateTime.now().toUtc().add(Duration(hours: 1));

    // Authenticate client for Calendar API
    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          "Bearer",
          googleAuth.accessToken!,
          expiryDate, // Use UTC expiry time
        ),
        googleAuth.idToken!,
        ['https://www.googleapis.com/auth/calendar'],
      ),
    );
    return authClient;
  } catch (e) {
    print("Error obtaining Google Auth client: $e");
    return null;
  }
}

// Method to create an event in Google Calendar
Future<void> createEvent(AuthClient client) async {
  try {
    final calendarApi = calendar.CalendarApi(client);

    final event = calendar.Event(
      summary: 'My Test Task',
      location: 'Firebase App Location',
      description:
          'This task was scheduled by shariq for the test of the task to google calender',
      start: calendar.EventDateTime(
        dateTime: DateTime.now().add(Duration(hours: 1)), // Start time
        timeZone: 'GMT',
      ),
      end: calendar.EventDateTime(
        dateTime: DateTime.now().add(Duration(hours: 2)), // End time
        timeZone: 'GMT',
      ),
    );

    final calendarEvent = await calendarApi.events.insert(event, 'primary');
    print('Event created: ${calendarEvent.summary}');
  } catch (e) {
    print('Error creating event: $e');
  }
}
