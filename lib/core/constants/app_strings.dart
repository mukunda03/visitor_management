class AppStrings {
  AppStrings._();

  static const String appName = 'Visitors Management';

  static const String dashboard = 'Dashboard';
  static const String visitors = 'Visitors';
  static const String scan = 'Scan';

  static const String totalVisitorsToday = 'Total Visitors Today';
  static const String currentlyCheckedIn = 'Currently Checked In';
  static const String checkedOutToday = 'Checked Out Today';
  static const String registerVisitor = 'Register Visitor';
  static const String scanQrCode = 'Scan QR Code';
  static const String visitorList = 'Visitor List';

  //vistor form fields
  static const String editVisitor = 'Edit Visitor';
  static const String visitorName = 'Visitor Name';
  static const String mobileNumber = 'Mobile Number';
  static const String email = 'Email (optional)';
  static const String visitorType = 'Visitor Type';
  static const String project = 'Project';
  static const String purposeOfVisit = 'Purpose of Visit';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  //detail screen fields
  static const String visitorDetails = 'Visitor Details';
  static const String checkIn = 'Check In';
  static const String checkOut = 'Check Out';
  static const String checkInTime = 'Check-in';
  static const String checkOutTime = 'Check-out';
  static const String notAvailable = '—';

  static const String searchHint = 'Search by name or mobile';
  static const String noVisitors = 'No visitors found';
  static const String noVisitorsHint = 'Register a visitor to get started.';

  static const String scanTitle = 'Scan QR Code';
  static const String scanHint = 'Point the camera at a visitor QR code';
  static const String cameraPermissionDenied =
      'Camera permission is required to scan QR codes.';
  static const String invalidQr = 'Invalid QR code';
  static const String visitorNotFound = 'Visitor does not exist';

  static const List<String> visitorTypes = ['Customer', 'Vendor', 'Other'];
  static const List<String> projects = ['Project A', 'Project B', 'Project C'];

  static const String statusRegistered = 'Registered';
  static const String statusCheckedIn = 'Checked In';
  static const String statusCheckedOut = 'Checked Out';

  static const String nameRequired = 'Visitor name is required';
  static const String mobileRequired = 'Mobile number is required';
  static const String mobileInvalid = 'Enter a valid 10-digit mobile number';
  static const String emailInvalid = 'Enter a valid email address';
  static const String purposeRequired = 'Purpose of visit is required';

  static const String visitorRegistered = 'Visitor registered successfully';
  static const String visitorUpdated = 'Visitor updated successfully';
  static const String visitorDeleted = 'Visitor deleted';
  static const String checkedInSuccess = 'Visitor checked in';
  static const String checkedOutSuccess = 'Visitor checked out';
  static const String deleteConfirmTitle = 'Delete visitor?';
  static const String deleteConfirmMessage = 'This action cannot be undone.';

  static const String somethingWentWrong = 'Something went wrong. Try again.';
  static const String noInternet = 'No internet connection.';
  static const String timeout = 'Request timed out. Try again.';
  static const String serverError = 'Server error. Try again later.';
  static const String alreadyCheckedIn = 'Visitor is already checked in';
  static const String notCheckedIn = 'Visitor has not checked in yet';
  static const String visitCompleted = 'Visit is already completed';
  static const String retry = 'Retry';

  static const String visitorIdLabel = 'Visitor ID';
  static const String cameraPermissionHint =
      'Enable camera access in app settings, then tap Retry.';
  static const String cameraError = 'Unable to start the camera.';
}
