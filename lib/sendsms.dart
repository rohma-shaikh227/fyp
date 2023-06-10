import 'package:twilio_flutter/twilio_flutter.dart';

void sendSms() async {
  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC8e05c338e114cc7f0d1aa42ec7263dfd',
    authToken: '9c43132f11ec79494427a6e7eb659e02',
    twilioNumber: '+16506893924',
  );

  await twilioFlutter.sendSMS(toNumber: '+92 3313295978', messageBody: 'alert driver drowsy');
}

void getSms() async {
  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC8e05c338e114cc7f0d1aa42ec7263dfd',
    authToken: '9c43132f11ec79494427a6e7eb659e02',
    twilioNumber: '+16506893924',
  );

  var data = await twilioFlutter.getSmsList();
  print(data);

  await twilioFlutter.getSMS('***************************');
}
