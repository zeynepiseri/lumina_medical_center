import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lumina Medical'**
  String get appName;

  /// No description provided for @luminaAdmin.
  ///
  /// In en, this message translates to:
  /// **'Lumina Admin'**
  String get luminaAdmin;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search doctor, drugs, articles...'**
  String get searchPlaceholder;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active:'**
  String get active;

  /// No description provided for @nA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get nA;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @keep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keep;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @phoneCall.
  ///
  /// In en, this message translates to:
  /// **'Phone Call'**
  String get phoneCall;

  /// No description provided for @videoCall.
  ///
  /// In en, this message translates to:
  /// **'Video Call'**
  String get videoCall;

  /// No description provided for @videoCallComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Video call coming soon!'**
  String get videoCallComingSoon;

  /// No description provided for @onlineCall.
  ///
  /// In en, this message translates to:
  /// **'Online Call'**
  String get onlineCall;

  /// No description provided for @startVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Start Video Call'**
  String get startVideoCall;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get seeAll;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add to List'**
  String get addToList;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected situation'**
  String get unexpectedError;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed'**
  String get operationFailed;

  /// No description provided for @anErrorHasOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error has occurred'**
  String get anErrorHasOccurred;

  /// No description provided for @theUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'The update failed'**
  String get theUpdateFailed;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved Successfully!'**
  String get saveSuccess;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save.'**
  String get saveError;

  /// No description provided for @dataLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Data load failed'**
  String get dataLoadFailed;

  /// No description provided for @dashboardLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading appointments.'**
  String get dashboardLoadError;

  /// No description provided for @imageUploadServiceError.
  ///
  /// In en, this message translates to:
  /// **'Image upload service did not respond.'**
  String get imageUploadServiceError;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @requiredFields.
  ///
  /// In en, this message translates to:
  /// **'Required fields'**
  String get requiredFields;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields.'**
  String get fillAllFields;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get pleaseFillAllFields;

  /// No description provided for @fillAllRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields (Name, Password, Email, Branch).'**
  String get fillAllRequiredFields;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @menuDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get menuDashboard;

  /// No description provided for @menuDoctors.
  ///
  /// In en, this message translates to:
  /// **'Doctors'**
  String get menuDoctors;

  /// No description provided for @menuAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get menuAppointments;

  /// No description provided for @menuAddBranch.
  ///
  /// In en, this message translates to:
  /// **'Add Branch'**
  String get menuAddBranch;

  /// No description provided for @menuSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get menuSettings;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get menuLogout;

  /// No description provided for @menuPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'My Prescriptions'**
  String get menuPrescriptions;

  /// No description provided for @menuMedicalRecords.
  ///
  /// In en, this message translates to:
  /// **'Medical Records / Lab Results'**
  String get menuMedicalRecords;

  /// No description provided for @menuInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance Information'**
  String get menuInsurance;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your health hub.\nEasily find the right doctor,\nAnd book appointments in seconds.'**
  String get welcomeSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBackTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email :'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password :'**
  String get enterPassword;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration is Successful! Welcome.'**
  String get registrationSuccess;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginLink;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password successfully changed!'**
  String get passwordChangedSuccess;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @doctorDashboard.
  ///
  /// In en, this message translates to:
  /// **'Doctor Dashboard'**
  String get doctorDashboard;

  /// No description provided for @totalPatients.
  ///
  /// In en, this message translates to:
  /// **'Total Patients'**
  String get totalPatients;

  /// No description provided for @totalDoctors.
  ///
  /// In en, this message translates to:
  /// **'Total Doctors'**
  String get totalDoctors;

  /// No description provided for @totalAppointments.
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get totalAppointments;

  /// No description provided for @polyclinics.
  ///
  /// In en, this message translates to:
  /// **'Polyclinics'**
  String get polyclinics;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @recentAppointments.
  ///
  /// In en, this message translates to:
  /// **'Recent Appointments'**
  String get recentAppointments;

  /// No description provided for @noRecentAppointments.
  ///
  /// In en, this message translates to:
  /// **'No recent appointments'**
  String get noRecentAppointments;

  /// No description provided for @statsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics Details'**
  String get statsDetailTitle;

  /// No description provided for @statisticsSection.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsSection;

  /// No description provided for @earlyDetection.
  ///
  /// In en, this message translates to:
  /// **'Early Detection'**
  String get earlyDetection;

  /// No description provided for @checkUpPackage.
  ///
  /// In en, this message translates to:
  /// **'Check-up Package\n50% Discount!'**
  String get checkUpPackage;

  /// No description provided for @appointmentNow.
  ///
  /// In en, this message translates to:
  /// **'Appointment Now'**
  String get appointmentNow;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @professionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Professional Information'**
  String get professionalInformation;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfo;

  /// No description provided for @institutionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Institutional Information'**
  String get institutionalInfo;

  /// No description provided for @nationalID.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalID;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @temporaryPassword.
  ///
  /// In en, this message translates to:
  /// **'Temporary Password'**
  String get temporaryPassword;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @birthDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDateLabel;

  /// No description provided for @selectBirthDateError.
  ///
  /// In en, this message translates to:
  /// **'Please select a birth date'**
  String get selectBirthDateError;

  /// No description provided for @updatePhotoSuccess.
  ///
  /// In en, this message translates to:
  /// **'Photo updated successfully!'**
  String get updatePhotoSuccess;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// No description provided for @profileLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile failed to load.'**
  String get profileLoadFailed;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Profile update failed: {error}'**
  String profileUpdateFailed(String error);

  /// No description provided for @profileUpdateErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during profile update.'**
  String get profileUpdateErrorGeneric;

  /// No description provided for @adminRoleName.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminRoleName;

  /// No description provided for @vitalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Body Vitals'**
  String get vitalsTitle;

  /// No description provided for @editVitalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Vitals'**
  String get editVitalsTitle;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @bloodTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodTypeLabel;

  /// No description provided for @allergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergiesLabel;

  /// No description provided for @chronicDiseasesLabel.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases'**
  String get chronicDiseasesLabel;

  /// No description provided for @chronicDiseasesHint.
  ///
  /// In en, this message translates to:
  /// **'Chronic Diseases (Separate with commas)'**
  String get chronicDiseasesHint;

  /// No description provided for @allergiesHint.
  ///
  /// In en, this message translates to:
  /// **'Allergies (Separate with commas)'**
  String get allergiesHint;

  /// No description provided for @medicationsHint.
  ///
  /// In en, this message translates to:
  /// **'Medications Used Regularly (Separate with commas)'**
  String get medicationsHint;

  /// No description provided for @noInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No information available'**
  String get noInfoAvailable;

  /// No description provided for @healthIssueOptional.
  ///
  /// In en, this message translates to:
  /// **'Health Issue (Optional)'**
  String get healthIssueOptional;

  /// No description provided for @popularDoctors.
  ///
  /// In en, this message translates to:
  /// **'Popular Doctors'**
  String get popularDoctors;

  /// No description provided for @popularDoctorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Doctors'**
  String get popularDoctorsTitle;

  /// No description provided for @topDoctorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Doctors'**
  String get topDoctorsTitle;

  /// No description provided for @allDoctors.
  ///
  /// In en, this message translates to:
  /// **'All Doctors'**
  String get allDoctors;

  /// No description provided for @searchDoctorHint.
  ///
  /// In en, this message translates to:
  /// **'Search doctor...'**
  String get searchDoctorHint;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No doctors found.'**
  String get noDoctorsFound;

  /// No description provided for @doctorsListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Doctors List is empty.'**
  String get doctorsListEmpty;

  /// No description provided for @addDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Doctor'**
  String get addDoctorTitle;

  /// No description provided for @editDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Doctor'**
  String get editDoctorTitle;

  /// No description provided for @selectDoctorToEdit.
  ///
  /// In en, this message translates to:
  /// **'Select Doctor to Edit'**
  String get selectDoctorToEdit;

  /// No description provided for @saveDoctorButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE DOCTOR'**
  String get saveDoctorButton;

  /// No description provided for @updateDoctorButton.
  ///
  /// In en, this message translates to:
  /// **'UPDATE DOCTOR'**
  String get updateDoctorButton;

  /// No description provided for @doctorAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Doctor Added!'**
  String get doctorAddedSuccess;

  /// No description provided for @doctorUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Doctor Updated!'**
  String get doctorUpdateSuccess;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfo;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @titleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleLabel;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Prof. Dr.'**
  String get titleHint;

  /// No description provided for @diplomaNo.
  ///
  /// In en, this message translates to:
  /// **'Diploma No'**
  String get diplomaNo;

  /// No description provided for @specialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialtyLabel;

  /// No description provided for @specialtyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardiology'**
  String get specialtyHint;

  /// No description provided for @subSpecialties.
  ///
  /// In en, this message translates to:
  /// **'Sub Specialties & Interests'**
  String get subSpecialties;

  /// No description provided for @biographyLabel.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biographyLabel;

  /// No description provided for @experienceYears.
  ///
  /// In en, this message translates to:
  /// **'Experience (Years)'**
  String get experienceYears;

  /// No description provided for @experienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Exp. (Years)'**
  String get experienceLabel;

  /// No description provided for @patientsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsCountLabel;

  /// No description provided for @reviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsLabel;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @contractedInsurances.
  ///
  /// In en, this message translates to:
  /// **'Contracted Insurances'**
  String get contractedInsurances;

  /// No description provided for @professionalExperiences.
  ///
  /// In en, this message translates to:
  /// **'Professional Experiences'**
  String get professionalExperiences;

  /// No description provided for @educationInformation.
  ///
  /// In en, this message translates to:
  /// **'Education Information'**
  String get educationInformation;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Work Experience'**
  String get addExperience;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Education'**
  String get addEducation;

  /// No description provided for @addSubSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Add Sub-Specialty'**
  String get addSubSpecialty;

  /// No description provided for @detailListsSection.
  ///
  /// In en, this message translates to:
  /// **'Detail Lists'**
  String get detailListsSection;

  /// No description provided for @profileEditing.
  ///
  /// In en, this message translates to:
  /// **'Profile Editing'**
  String get profileEditing;

  /// No description provided for @detailedInfo.
  ///
  /// In en, this message translates to:
  /// **'Detailed Information'**
  String get detailedInfo;

  /// No description provided for @educationHistory.
  ///
  /// In en, this message translates to:
  /// **'Education History'**
  String get educationHistory;

  /// No description provided for @addEducationHint.
  ///
  /// In en, this message translates to:
  /// **'Add School/Education...'**
  String get addEducationHint;

  /// No description provided for @addSubSpecialtyHint.
  ///
  /// In en, this message translates to:
  /// **'Add Specialty...'**
  String get addSubSpecialtyHint;

  /// No description provided for @aboutDoctor.
  ///
  /// In en, this message translates to:
  /// **'About Doctor'**
  String get aboutDoctor;

  /// No description provided for @careerPath.
  ///
  /// In en, this message translates to:
  /// **'Career Path'**
  String get careerPath;

  /// No description provided for @editProfileTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTooltip;

  /// No description provided for @doctorInfoMissing.
  ///
  /// In en, this message translates to:
  /// **'Doctor info missing, cannot reschedule.'**
  String get doctorInfoMissing;

  /// No description provided for @fetchDoctorError.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch doctor info: {error}'**
  String fetchDoctorError(String error);

  /// No description provided for @addBranchTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Branch'**
  String get addBranchTitle;

  /// No description provided for @branchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchLabel;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select Branch'**
  String get selectBranch;

  /// No description provided for @branchNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchNameLabel;

  /// No description provided for @branchNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Branch name cannot be empty.'**
  String get branchNameEmpty;

  /// No description provided for @branchNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cardiology'**
  String get branchNameHint;

  /// No description provided for @imageUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrlLabel;

  /// No description provided for @imageUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste icon URL here'**
  String get imageUrlHint;

  /// No description provided for @imageUrlOptional.
  ///
  /// In en, this message translates to:
  /// **'Image URL (Optional)'**
  String get imageUrlOptional;

  /// No description provided for @saveBranchButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE BRANCH'**
  String get saveBranchButton;

  /// No description provided for @doctorColumn.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorColumn;

  /// No description provided for @branchColumn.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchColumn;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusColumn;

  /// No description provided for @patientsLabel.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsLabel;

  /// No description provided for @allSpecialties.
  ///
  /// In en, this message translates to:
  /// **'All Specialties'**
  String get allSpecialties;

  /// No description provided for @noBranchesFound.
  ///
  /// In en, this message translates to:
  /// **'No branches found yet.'**
  String get noBranchesFound;

  /// No description provided for @specialists.
  ///
  /// In en, this message translates to:
  /// **'Specialists'**
  String get specialists;

  /// No description provided for @noSpecialistsFound.
  ///
  /// In en, this message translates to:
  /// **'No specialists found'**
  String get noSpecialistsFound;

  /// No description provided for @noDoctorsInBranch.
  ///
  /// In en, this message translates to:
  /// **'There are no doctors in this branch yet.'**
  String get noDoctorsInBranch;

  /// No description provided for @workSchedule.
  ///
  /// In en, this message translates to:
  /// **'Work Schedule'**
  String get workSchedule;

  /// No description provided for @workingHoursSection.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get workingHoursSection;

  /// No description provided for @noSchedulesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No schedules added yet.'**
  String get noSchedulesAddedYet;

  /// No description provided for @currentHours.
  ///
  /// In en, this message translates to:
  /// **'Current Hours'**
  String get currentHours;

  /// No description provided for @noWorkingHoursAdded.
  ///
  /// In en, this message translates to:
  /// **'No working hours added yet.'**
  String get noWorkingHoursAdded;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select Day'**
  String get selectDay;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endTime;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dayLabel;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endLabel;

  /// No description provided for @profileAndHours.
  ///
  /// In en, this message translates to:
  /// **'Profile & Working Hours'**
  String get profileAndHours;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'MONDAY'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'TUESDAY'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'WEDNESDAY'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'THURSDAY'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'FRIDAY'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'SATURDAY'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'SUNDAY'**
  String get sunday;

  /// No description provided for @noScheduleForDay.
  ///
  /// In en, this message translates to:
  /// **'No schedule for {day}'**
  String noScheduleForDay(String day);

  /// No description provided for @manageAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Appointments'**
  String get manageAppointmentsTitle;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments found.'**
  String get noUpcomingAppointments;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @bookNewAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book a new appointment with our doctors.'**
  String get bookNewAppointment;

  /// No description provided for @createAppointment.
  ///
  /// In en, this message translates to:
  /// **'Create Your Appointment'**
  String get createAppointment;

  /// No description provided for @rescheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Appointment'**
  String get rescheduleAppointment;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointment;

  /// No description provided for @confirmReschedule.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reschedule'**
  String get confirmReschedule;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// No description provided for @cancelDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelDialogBody;

  /// No description provided for @cancelDialogBodyLong.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment? This action cannot be undone.'**
  String get cancelDialogBodyLong;

  /// No description provided for @appointmentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmed!'**
  String get appointmentConfirmed;

  /// No description provided for @appointmentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmation'**
  String get appointmentConfirmation;

  /// No description provided for @appointmentCanceledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Appointment canceled successfully'**
  String get appointmentCanceledSuccessfully;

  /// No description provided for @appointmentCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Cancellation failed'**
  String get appointmentCancelFailed;

  /// No description provided for @appointmentRescheduledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment rescheduled successfully'**
  String get appointmentRescheduledSuccess;

  /// No description provided for @appointmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get appointmentUpdated;

  /// No description provided for @appointmentRescheduleFailed.
  ///
  /// In en, this message translates to:
  /// **'Reschedule failed'**
  String get appointmentRescheduleFailed;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments.'**
  String get noAppointments;

  /// No description provided for @noSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No slots available.'**
  String get noSlotsAvailable;

  /// No description provided for @selectDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a date first.'**
  String get selectDateFirst;

  /// No description provided for @selectConsultationType.
  ///
  /// In en, this message translates to:
  /// **'Select Consultation Type'**
  String get selectConsultationType;

  /// No description provided for @consultationType.
  ///
  /// In en, this message translates to:
  /// **'Consultation Type'**
  String get consultationType;

  /// No description provided for @inPerson.
  ///
  /// In en, this message translates to:
  /// **'In-Person'**
  String get inPerson;

  /// No description provided for @inPersonVisit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get inPersonVisit;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @onlineConsultation.
  ///
  /// In en, this message translates to:
  /// **'Online Consultation'**
  String get onlineConsultation;

  /// No description provided for @searchPatientHint.
  ///
  /// In en, this message translates to:
  /// **'Search Patient Name...'**
  String get searchPatientHint;

  /// No description provided for @availableTime.
  ///
  /// In en, this message translates to:
  /// **'Available Time'**
  String get availableTime;

  /// No description provided for @appointmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetails;

  /// No description provided for @patientComplaintNotes.
  ///
  /// In en, this message translates to:
  /// **'Patient Complaint / Notes'**
  String get patientComplaintNotes;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @selectDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get selectDateAndTime;

  /// No description provided for @filterAppointments.
  ///
  /// In en, this message translates to:
  /// **'Filter Appointments'**
  String get filterAppointments;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get allDates;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @noAppointmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get noAppointmentsFound;

  /// No description provided for @patientColumn.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientColumn;

  /// No description provided for @dateTimeColumn.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTimeColumn;

  /// No description provided for @typeColumn.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeColumn;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @appts.
  ///
  /// In en, this message translates to:
  /// **'Appts'**
  String get appts;

  /// No description provided for @actionsColumn.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actionsColumn;

  /// No description provided for @cancelAppointmentTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointmentTooltip;

  /// No description provided for @invalidId.
  ///
  /// In en, this message translates to:
  /// **'Invalid ID'**
  String get invalidId;

  /// No description provided for @unknownPatient.
  ///
  /// In en, this message translates to:
  /// **'Unknown Patient'**
  String get unknownPatient;

  /// No description provided for @noDetails.
  ///
  /// In en, this message translates to:
  /// **'No details.'**
  String get noDetails;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Experience'**
  String get rateYourExperience;

  /// No description provided for @howWasYourConsultation.
  ///
  /// In en, this message translates to:
  /// **'How was your consultation?'**
  String get howWasYourConsultation;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @thankYouForRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouForRating;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
