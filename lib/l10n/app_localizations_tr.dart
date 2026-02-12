// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Lumina Medikal';

  @override
  String get luminaAdmin => 'Lumina Yönetici';

  @override
  String get showMore => 'Daha fazla';

  @override
  String get showLess => 'Daha az';

  @override
  String get search => 'Ara';

  @override
  String get searchPlaceholder => 'Doktor, ilaç veya makale ara...';

  @override
  String get select => 'Seç';

  @override
  String get cancel => 'İptal';

  @override
  String get delete => 'Sil';

  @override
  String get confirm => 'Onayla';

  @override
  String get save => 'Kaydet';

  @override
  String get edit => 'Düzenle';

  @override
  String get finished => 'Tamamlandı';

  @override
  String get confirmed => 'Onaylandı';

  @override
  String get active => 'Aktif:';

  @override
  String get nA => 'Mevcut Değil';

  @override
  String get no => 'Hayır';

  @override
  String get yesCancel => 'Evet, İptal Et';

  @override
  String get keep => 'Vazgeç';

  @override
  String get tryAgain => 'Tekrar Dene';

  @override
  String get actions => 'İşlemler';

  @override
  String get status => 'Durum';

  @override
  String get message => 'Mesaj';

  @override
  String get phoneCall => 'Sesli Arama';

  @override
  String get videoCall => 'Görüntülü Arama';

  @override
  String get videoCallComingSoon => 'Görüntülü görüşme yakında!';

  @override
  String get onlineCall => 'Online Görüşme';

  @override
  String get startVideoCall => 'Görüntülü Görüşme Başlat';

  @override
  String get seeAll => 'Tümü';

  @override
  String get details => 'Detaylar';

  @override
  String get clear => 'Temizle';

  @override
  String get addToList => 'Listeye Ekle';

  @override
  String get resetFilters => 'Filtreleri Sıfırla';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get error => 'Hata';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get unexpectedError => 'Beklenmeyen durum';

  @override
  String get operationFailed => 'İşlem başarısız';

  @override
  String get anErrorHasOccurred => 'Bir hata oluştu';

  @override
  String get theUpdateFailed => 'Güncelleme başarısız';

  @override
  String get saveSuccess => 'Başarıyla Kaydedildi!';

  @override
  String get saveError => 'Kaydedilemedi.';

  @override
  String get dataLoadFailed => 'Veri yükleme başarısız';

  @override
  String get dashboardLoadError => 'Randevular yüklenirken bir hata oluştu.';

  @override
  String get imageUploadServiceError => 'Resim yükleme servisi yanıt vermedi.';

  @override
  String get requiredField => 'Zorunlu';

  @override
  String get requiredFields => 'Zorunlu alanlar';

  @override
  String get fillAllFields => 'Lütfen tüm alanları doldurun.';

  @override
  String get pleaseFillAllFields => 'Lütfen tüm alanları doldurun.';

  @override
  String get fillAllRequiredFields =>
      'Lütfen tüm zorunlu alanları doldurun (İsim, Şifre, E-posta, Branş).';

  @override
  String errorWithDetails(String error) {
    return 'Hata: $error';
  }

  @override
  String get menuDashboard => 'Panel';

  @override
  String get menuDoctors => 'Doktorlar';

  @override
  String get menuAppointments => 'Randevular';

  @override
  String get menuAddBranch => 'Branş Ekle';

  @override
  String get menuSettings => 'Ayarlar';

  @override
  String get menuLogout => 'Çıkış Yap';

  @override
  String get menuPrescriptions => 'Reçetelerim';

  @override
  String get menuMedicalRecords => 'Tıbbi Kayıtlar / Tahliller';

  @override
  String get menuInsurance => 'Sigorta Bilgileri';

  @override
  String get quickActions => 'Hızlı İşlemler';

  @override
  String get accountSettings => 'Hesap Ayarları';

  @override
  String get welcomeTitle => 'Hoş Geldiniz';

  @override
  String get welcomeSubtitle =>
      'Sağlık merkezinize hoş geldiniz.\nDoğru doktoru kolayca bulun,\nVe saniyeler içinde randevu alın.';

  @override
  String get createAccount => 'Hesap Oluştur';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get welcomeBackTitle => 'Tekrar Hoş Geldiniz';

  @override
  String get welcomeBack => 'Tekrar hoşgeldin,';

  @override
  String get hello => 'Merhaba,';

  @override
  String get enterEmail => 'E-posta girin :';

  @override
  String get enterPassword => 'Şifre girin :';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get rememberMe => 'Beni Hatırla';

  @override
  String get forgotPassword => 'Şifremi Unuttum';

  @override
  String get registrationSuccess => 'Kayıt Başarılı! Hoş geldiniz.';

  @override
  String get invalidPhone => 'Lütfen geçerli bir telefon numarası girin';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı? ';

  @override
  String get loginLink => 'Giriş yap';

  @override
  String get changePassword => 'Şifre Değiştir';

  @override
  String get currentPassword => 'Mevcut Şifre';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get passwordChangedSuccess => 'Şifre başarıyla değiştirildi!';

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get doctorDashboard => 'Doktor Paneli';

  @override
  String get totalPatients => 'Toplam Hasta';

  @override
  String get totalDoctors => 'Toplam Doktor';

  @override
  String get totalAppointments => 'Toplam Randevu';

  @override
  String get polyclinics => 'Poliklinikler';

  @override
  String get earnings => 'Kazanç';

  @override
  String get recentAppointments => 'Son Randevular';

  @override
  String get noRecentAppointments => 'Son randevu yok';

  @override
  String get statsDetailTitle => 'İstatistik Detayı';

  @override
  String get statisticsSection => 'İstatistikler';

  @override
  String get earlyDetection => 'Erken Teşhis';

  @override
  String get checkUpPackage => 'Check-up Paketi\n%50 İndirim!';

  @override
  String get appointmentNow => 'Hemen Randevu';

  @override
  String get myProfile => 'Profilim';

  @override
  String get personalInformation => 'Kişisel Bilgiler';

  @override
  String get professionalInformation => 'Mesleki Bilgiler';

  @override
  String get contactInfo => 'İletişim Bilgileri';

  @override
  String get institutionalInfo => 'Kurumsal Bilgiler';

  @override
  String get nationalID => 'TC Kimlik No';

  @override
  String get email => 'E-posta';

  @override
  String get phoneNumber => 'Telefon Numarası';

  @override
  String get temporaryPassword => 'Geçici Şifre';

  @override
  String get genderLabel => 'Cinsiyet';

  @override
  String get genderMale => 'Erkek';

  @override
  String get genderFemale => 'Kadın';

  @override
  String get birthDateLabel => 'Doğum Tarihi';

  @override
  String get selectBirthDateError => 'Lütfen doğum tarihi seçin';

  @override
  String get updatePhotoSuccess => 'Fotoğraf başarıyla güncellendi!';

  @override
  String get profileUpdateSuccess => 'Profil başarıyla güncellendi!';

  @override
  String get profileLoadFailed => 'Profil yüklenemedi.';

  @override
  String profileUpdateFailed(String error) {
    return 'Profil güncellenemedi: $error';
  }

  @override
  String get profileUpdateErrorGeneric =>
      'Profil güncelleme sırasında hata oluştu.';

  @override
  String get adminRoleName => 'Yönetici';

  @override
  String get vitalsTitle => 'Vücut Değerleri';

  @override
  String get editVitalsTitle => 'Değerleri Güncelle';

  @override
  String get heightLabel => 'Boy (cm)';

  @override
  String get weightLabel => 'Kilo (kg)';

  @override
  String get bloodTypeLabel => 'Kan Grubu';

  @override
  String get allergiesLabel => 'Alerjiler';

  @override
  String get chronicDiseasesLabel => 'Kronik Hastalıklar';

  @override
  String get chronicDiseasesHint => 'Kronik Hastalıklar (Virgülle ayırın)';

  @override
  String get allergiesHint => 'Alerjiler (Virgülle ayırın)';

  @override
  String get medicationsHint => 'Düzenli Kullanılan İlaçlar (Virgülle ayırın)';

  @override
  String get noInfoAvailable => 'Bilgi mevcut değil';

  @override
  String get healthIssueOptional => 'Sağlık Sorunu (İsteğe Bağlı)';

  @override
  String get popularDoctors => 'Popüler Doktorlar';

  @override
  String get popularDoctorsTitle => 'Popüler Doktorlar';

  @override
  String get topDoctorsTitle => 'En İyi Doktorlar';

  @override
  String get allDoctors => 'Tüm Doktorlar';

  @override
  String get searchDoctorHint => 'Doktor ara...';

  @override
  String get noDoctorsFound => 'Doktor bulunamadı.';

  @override
  String get doctorsListEmpty => 'Doktor listesi boş.';

  @override
  String get addDoctorTitle => 'Yeni Doktor Ekle';

  @override
  String get editDoctorTitle => 'Doktoru Düzenle';

  @override
  String get selectDoctorToEdit => 'Düzenlenecek Doktoru Seç';

  @override
  String get saveDoctorButton => 'DOKTORU KAYDET';

  @override
  String get updateDoctorButton => 'DOKTORU GÜNCELLE';

  @override
  String get doctorAddedSuccess => 'Doktor Eklendi!';

  @override
  String get doctorUpdateSuccess => 'Doktor Güncellendi!';

  @override
  String get basicInfo => 'Temel Bilgiler';

  @override
  String get fullNameLabel => 'Ad Soyad';

  @override
  String get titleLabel => 'Unvan';

  @override
  String get titleHint => 'Örn. Prof. Dr.';

  @override
  String get diplomaNo => 'Diploma No';

  @override
  String get specialtyLabel => 'Uzmanlık';

  @override
  String get specialtyHint => 'Örn. Kardiyoloji';

  @override
  String get subSpecialties => 'Alt Uzmanlıklar & İlgi Alanları';

  @override
  String get biographyLabel => 'Biyografi';

  @override
  String get experienceYears => 'Deneyim (Yıl)';

  @override
  String get experienceLabel => 'Den. (Yıl)';

  @override
  String get patientsCountLabel => 'Hasta Sayısı';

  @override
  String get reviewsLabel => 'Değerlendirmeler';

  @override
  String get rating => 'Puan';

  @override
  String get contractedInsurances => 'Anlaşmalı Sigortalar';

  @override
  String get professionalExperiences => 'Mesleki Deneyimler';

  @override
  String get educationInformation => 'Eğitim Bilgileri';

  @override
  String get addExperience => 'Deneyim Ekle';

  @override
  String get addEducation => 'Eğitim Ekle';

  @override
  String get addSubSpecialty => 'Alt Uzmanlık Ekle';

  @override
  String get detailListsSection => 'Detay Listeleri';

  @override
  String get profileEditing => 'Profil Düzenleme';

  @override
  String get detailedInfo => 'Detaylı Bilgi';

  @override
  String get educationHistory => 'Eğitim Geçmişi';

  @override
  String get addEducationHint => 'Okul/Eğitim Ekle...';

  @override
  String get addSubSpecialtyHint => 'Uzmanlık Ekle...';

  @override
  String get aboutDoctor => 'Doktor Hakkında';

  @override
  String get careerPath => 'Kariyer Yolu';

  @override
  String get editProfileTooltip => 'Profili Düzenle';

  @override
  String get doctorInfoMissing => 'Doktor bilgisi eksik, ertelenemiyor.';

  @override
  String fetchDoctorError(String error) {
    return 'Doktor bilgileri alınamadı: $error';
  }

  @override
  String get addBranchTitle => 'Yeni Branş Ekle';

  @override
  String get branchLabel => 'Branş';

  @override
  String get selectBranch => 'Branş Seç';

  @override
  String get branchNameLabel => 'Branş Adı';

  @override
  String get branchNameEmpty => 'Branş adı boş olamaz.';

  @override
  String get branchNameHint => 'Örn. Kardiyoloji';

  @override
  String get imageUrlLabel => 'Görsel URL';

  @override
  String get imageUrlHint => 'Simge URL\'sini buraya yapıştırın';

  @override
  String get imageUrlOptional => 'Görsel URL (İsteğe Bağlı)';

  @override
  String get saveBranchButton => 'BRANŞI KAYDET';

  @override
  String get doctorColumn => 'Doktor';

  @override
  String get branchColumn => 'Branş';

  @override
  String get statusColumn => 'Durum';

  @override
  String get patientsLabel => 'Hasta';

  @override
  String get allSpecialties => 'Tüm Uzmanlıklar';

  @override
  String get noBranchesFound => 'Henüz branş bulunamadı.';

  @override
  String get specialists => 'Uzmanlar';

  @override
  String get noSpecialistsFound => 'Uzman bulunamadı';

  @override
  String get noDoctorsInBranch => 'Bu branşta henüz doktor yok.';

  @override
  String get workSchedule => 'Çalışma Takvimi';

  @override
  String get workingHoursSection => 'Çalışma Saatleri';

  @override
  String get noSchedulesAddedYet => 'Henüz program eklenmedi.';

  @override
  String get currentHours => 'Mevcut Saatler';

  @override
  String get noWorkingHoursAdded => 'Henüz çalışma saati eklenmedi.';

  @override
  String get selectDate => 'Tarih Seç';

  @override
  String get selectDay => 'Gün Seç';

  @override
  String get date => 'Tarih';

  @override
  String get time => 'Saat';

  @override
  String get startTime => 'Başlangıç';

  @override
  String get endTime => 'Bitiş';

  @override
  String get dayLabel => 'Gün';

  @override
  String get startLabel => 'Başlangıç';

  @override
  String get endLabel => 'Bitiş';

  @override
  String get profileAndHours => 'Profil & Çalışma Saatleri';

  @override
  String get monday => 'PAZARTESİ';

  @override
  String get tuesday => 'SALI';

  @override
  String get wednesday => 'ÇARŞAMBA';

  @override
  String get thursday => 'PERŞEMBE';

  @override
  String get friday => 'CUMA';

  @override
  String get saturday => 'CUMARTESİ';

  @override
  String get sunday => 'PAZAR';

  @override
  String noScheduleForDay(String day) {
    return '$day için program yok';
  }

  @override
  String get manageAppointmentsTitle => 'Randevuları Yönet';

  @override
  String get upcomingAppointments => 'Yaklaşan Randevular';

  @override
  String get noUpcomingAppointments => 'Yaklaşan randevu bulunamadı.';

  @override
  String get bookAppointment => 'Randevu Al';

  @override
  String get bookNewAppointment => 'Doktorlarımızdan yeni bir randevu alın.';

  @override
  String get createAppointment => 'Randevu Oluştur';

  @override
  String get rescheduleAppointment => 'Randevuyu Ertele';

  @override
  String get confirmAppointment => 'Randevuyu Onayla';

  @override
  String get confirmReschedule => 'Ertelemeyi Onayla';

  @override
  String get confirmBooking => 'Randevuyu Onayla';

  @override
  String get cancelAppointment => 'Randevuyu İptal Et';

  @override
  String get cancelDialogBody =>
      'Bu randevuyu iptal etmek istediğinize emin misiniz?';

  @override
  String get cancelDialogBodyLong =>
      'Bu randevuyu iptal etmek istediğinize emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get appointmentConfirmed => 'Randevu Onaylandı!';

  @override
  String get appointmentConfirmation => 'Randevu Onayı';

  @override
  String get appointmentCanceledSuccessfully =>
      'Randevu başarıyla iptal edildi';

  @override
  String get appointmentCancelFailed => 'İptal işlemi başarısız oldu';

  @override
  String get appointmentRescheduledSuccess => 'Randevu başarıyla ertelendi';

  @override
  String get appointmentUpdated => 'Randevu başarıyla güncellendi';

  @override
  String get appointmentRescheduleFailed => 'Erteleme işlemi başarısız oldu';

  @override
  String get noAppointments => 'Randevu bulunamadı.';

  @override
  String get noSlotsAvailable => 'Müsait saat yok.';

  @override
  String get selectDateFirst => 'Lütfen önce bir tarih seçin.';

  @override
  String get selectConsultationType => 'Görüşme Tipi Seçin';

  @override
  String get consultationType => 'Görüşme Tipi';

  @override
  String get inPerson => 'Yüz Yüze';

  @override
  String get inPersonVisit => 'Ziyaret';

  @override
  String get online => 'Online';

  @override
  String get onlineConsultation => 'Online Görüşme';

  @override
  String get searchPatientHint => 'Hasta Adı Ara...';

  @override
  String get availableTime => 'Müsait Saatler';

  @override
  String get appointmentDetails => 'Randevu Detayları';

  @override
  String get patientComplaintNotes => 'Hasta Şikayeti / Notlar';

  @override
  String get reschedule => 'Ertele';

  @override
  String get myAppointments => 'Randevularım';

  @override
  String get selectDateAndTime => 'Lütfen tarih ve saat seçin';

  @override
  String get filterAppointments => 'Randevuları Filtrele';

  @override
  String get allDates => 'Tüm Tarihler';

  @override
  String get pending => 'Bekliyor';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get cancelled => 'İptal Edildi';

  @override
  String get upcoming => 'Yaklaşan';

  @override
  String get noAppointmentsFound => 'Randevu bulunamadı';

  @override
  String get patientColumn => 'Hasta';

  @override
  String get dateTimeColumn => 'Tarih & Saat';

  @override
  String get typeColumn => 'Tür';

  @override
  String get type => 'Tür';

  @override
  String get appts => 'Rand.';

  @override
  String get actionsColumn => 'İşlemler';

  @override
  String get cancelAppointmentTooltip => 'Randevuyu İptal Et';

  @override
  String get invalidId => 'Geçersiz ID';

  @override
  String get unknownPatient => 'Bilinmeyen Hasta';

  @override
  String get noDetails => 'Detay yok.';

  @override
  String get rateYourExperience => 'Deneyiminizi Puanlayın';

  @override
  String get howWasYourConsultation => 'Görüşmeniz nasıldı?';

  @override
  String get submitReview => 'Değerlendirmeyi Gönder';

  @override
  String get thankYouForRating => 'Puanladığınız için teşekkürler!';
}
