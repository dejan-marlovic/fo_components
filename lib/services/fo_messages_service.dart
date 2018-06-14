import 'package:angular/di.dart';
import 'package:intl/intl.dart';

@Injectable()
class FoMessagesService {

  String select() => Intl.message('select');

  String search() => Intl.message('search');

  String gdpr_fetch_my_info() => Intl.message('I want to know my personal details');
  
  String gdpr_fetch_my_info_portable() => Intl.message('I want to access my personal details in a portable data');
  
  String gdpr_change_my_info() => Intl.message('I wish to change/update my information');
  
  String gdpr_limit_my_data_processing() => Intl.message('I wish to limit how my data is being processed');
  
  String gdpr_oppose_my_data_processing() => Intl.message('I wish to oppose how my data is being processed');
  
  String gdpr_erase_me() => Intl.message('I wish to erase all my data');

  String back() => Intl.message('back');

  String reset_password_description() => Intl.message('We have sent an ${email()} with a reset key to you. Paste it below to update your password.', desc: 'Displayed to the user have he has requested a new password');

  String new_password() => Intl.message('new ${password()}');

  String token() => Intl.message('token');

  String save() => Intl.message('save');

  String cancel() => Intl.message('cancel');

  String forgot_password_description() => Intl.message('Enter your username and press send to begin resetting your password', desc: 'Direction on steps to take if the user wishes to restore his password, shown in FoLoginComponent under forgot password section');

  String password() => Intl.message('password');

  String username() => Intl.message('username');

  String login() => Intl.message('log in');

  String reset_password() => Intl.message('reset password');

  String forgot_password() => Intl.message('forgot password');

  String gdpr_form_accept() => Intl.message('I hereby consent that above details are stored while the case is processed', desc: 'Label next to checkbox that the user must check in order to submit an issue');

  String gdpr_form_info() => Intl.message('This form is used for inquiries regarding your rights in accordance with Data Protection Regulation 2016/79.<br /><br />We save the details you provide in accordance with article 17.3.<br /><br />This information is sent to the support contact who registered your details and is logged by the service provider.', desc: 'Text displayed over the GDPR issue form');

  String gdpr_form_completed_message() => Intl.message('<h1>Thank you!</h1><p>Your inquiry has been now been sent, and we will take necessary actions and reply to you as soon as we can.</p>', desc: 'Displayed to the user after submitting the gdpr form, can be basic html');

  String send() => Intl.message('send');

  String firstname() => Intl.message('firstname');

  String lastname() => Intl.message('lastname');

  String email() => Intl.message('email');

  String phone() => Intl.message('phone number');

  String issue([int howMany = 1]) => Intl.plural(howMany, one: 'issue', other: 'issues');

  String comment([int howMany = 1]) => Intl.plural(howMany, one: 'comment', other: 'comments');

  String read_more() => Intl.message('read more');

  String invalid_file() => Intl.message('invalid file');

  String enter_value() => Intl.message('enter a value');

  String enter_firstname() => Intl.message('enter a ${firstname()}');

  String enter_lastname() => Intl.message('enter a ${lastname()}');

  String enter_email() => Intl.message('enter a valid ${email()}');

  String enter_phone() => Intl.message('enter a valid ${phone()}');

  String max_filesize_exceeded() => Intl.message('max filesize exceeded');

  String confirm() => Intl.message('confirm');

  String description() => Intl.message('description');
  
  String no_results_found() => Intl.message('no results found');

  String row([int howMany = 1]) => Intl.plural(howMany, one: 'row', other: 'rows');
  
  String page([int howMany = 1]) => Intl.plural(howMany, one: 'page', other: 'pages');

  String add() => Intl.message('add');
  
  String download_csv() => Intl.message('download .CSV file');

  String filter() => Intl.message('filter');

  String filter_enter() => Intl.message('filter (press enter to apply)');  
  
  String confirm_delete_resource() =>
      Intl.message('Are you sure you want to delete this resource?');
  
  String information() => Intl.message('information');
  
  String ok() => Intl.message('ok');
}