	    <!-- load Zebra_Form's stylesheet file -->
        <link rel="stylesheet" href="../Zebra_Form/public/css/zebra_form.css">

        <!-- load jQuery -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

        <!-- load Zebra_Form's JavaScript file -->
        <script src="../Zebra_Form/public/javascript/zebra_form.js"></script>
       
<?php


/* rest of code goes here */

session_start();


//This is where we process the form. 
function show_results ()

{ 
 
/*
	$to = 'josh@pokytrails.com';
	
	$subject = 'ISE Job Opportunities';
	
	$headers = "From: " . strip_tags($_POST['req-email']) . "\r\n";
	$headers .= "Reply-To: ". strip_tags($_POST['req-email']) . "\r\n";
	//$headers .= "CC: user@iseusa.com\r\n";
	$headers .= "MIME-Version: 1.0\r\n";
	$headers .= "Content-Type: text/html; charset=ISO-8859-1\r\n";
	
	
	$message = '<html><body>';
	$message .= '<img src="http://css-tricks.com/examples/WebsiteChangeRequestForm/images/wcrf-header.png" alt="Website Change Request" />';
	$message .= '<table rules="all" style="border-color: #666;" cellpadding="10">';
	$message .= "<tr style='background: #eee;'><td><strong>Name:</strong> </td><td>" . strip_tags($_POST['firstName']) . strip_tags($_POST['lastName']) . "</td></tr>";
	$message .= "<tr><td><strong>Email:</strong> </td><td>" . strip_tags($_POST['email']) . "</td></tr>";
	$message .= "<tr><td><strong>Phone:</strong> </td><td>" . strip_tags($_POST['phone']) . "</td></tr>";
	$message .= "<tr><td><strong>Address:</strong> </td><td>" . strip_tags($_POST['address']) . "<br>". strip_tags($_POST['city']) . strip_tags($_POST['state']) ."<br>". strip_tags($_POST['zip']) . "</td></tr>";
	
	$message .= "<tr><td><strong>Posistion:</strong> </td><td>" . $_POST['position'] . "</td></tr>";
	$message .= "<tr><td><strong>Why Interested:</strong> </td><td>" . htmlentities($_POST['position']) . "</td></tr>";
	$message .= "</table>";
	$message .= "</body></html>";
		
		
	mail($to, $subject, $message, $headers);
	*/
	
	
	require_once 'lib/swift_required.php';
	// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('smtp1.dnsmadeeasy.com', 25)
	  ->setUsername('iseTest')
	  ->setPassword('fr12ws98')
	  ;
	// Create the Mailer using your created Transport
	$mailer = Swift_Mailer::newInstance($transport);
	
	// Create a message
	$message = Swift_Message::newInstance('ISE Job Opportunities')
	  ->setFrom(array('$_POST[email]' => '$_POST[firstName] $_POST[lastName]'))
	  ->setTo(array('$_SESSION[outboundEmail]'))
	  ->setBody(
	  
	'<html>' .
' <head></head>' .
' <body>' .
'<table>'.
'<tr><Td>'.$_POST['email'].'<br>Is intersted in a job.</tr></td>'.
'</table>' .
' </body>' .
'</html>',
  'text/html' // Mark the content-type as HTML
	  
	  )
	  ;
	
	// Send the message
	$result = $mailer->send($message);
	  echo 'Thank you for your interest in the ISE Outbound Program. A representative will contact you shortly.';
		}
	
	
	

    // instantiate a Zebra_Form object
    $form = new Zebra_Form('form');

    // the label for the "first name" element
    $form->add('label', 'label_firstname', 'firstname', 'First Name:');

    // add the "first name" element
    $obj = $form->add('text', 'firstname');

    // set rules
    $obj->set_rule(array(

        // error messages will be sent to a variable called "error", usable in custom templates
        'required'  =>  array('error', 'First name is required!'),

    ));

    // "last name"
    $form->add('label', 'label_lastname', 'lastname', 'Last Name:');
    $obj = $form->add('text', 'lastname');
    $obj->set_rule(array(
        'required' => array('error', 'Last name is required!')
    ));
	// "last name"
    $form->add('label', 'label_firstname', 'firstname', 'First Name:');
    $obj = $form->add('text', 'firstname');
    $obj->set_rule(array(
        'required' => array('error', 'First name is required!')
    ));

    // "email"
    $form->add('label', 'label_email', 'email', 'Email Address:');
    $obj = $form->add('text', 'email');
    $obj->set_rule(array(
        'required'  => array('error', 'Email is required!'),
        'email'     => array('error', 'Email address seems to be invalid!')
    ));
	// "phone"
    $form->add('label', 'label_phone', 'phone', 'Phone Number:');
    $obj = $form->add('text', 'phone');
    $obj->set_rule(array(
        'required'  => array('error', 'Phone number is required!'),
       
    ));


    // "address"
    $form->add('label', 'label_address', 'address', 'Address');
    $obj = $form->add('text', 'address');
    $obj->set_rule(array(
        'required'  => array('error', 'Password is required!'),
        
    ));
 
   
   // "city"
    $form->add('label', 'label_city', 'city', 'City');
    $obj = $form->add('text', 'city');
	 $obj->set_rule(array(
        'required' => array('error', 'Please enter your city')
    ));
	// "State"
    $form->add('label', 'label_state', 'state', 'State');
    // single-option select box
	$obj = $form->add('select', 'state');
 
	// add selectable values with specific indexes
	// values will be "v1", "v2" and "v3", respectively
	// a default first value, "- select -" (language dependent) will also be added
	
	
	$obj->add_options(array(
		'1' => 'Alabama',
		'2' => 'Alaska',
		'3' => 'Arizona',
		'4' => 'Arkansas',
		'5' => 'California',
		'6' => 'Colorado',
		'7' => 'Connecticut',
		'8' => 'Deleware',
		'9' => 'Florida',
		'10' => 'Georgia',
		'11' => 'Hawaii',
		'12' => 'Idaho',
		'13' => 'Illinois',
		'14' => 'Indiana',
		'15' => 'Iowa',
		'16' => 'Kansas',
		'17' => 'Kentucky',
		'18' => 'Louisiana',
		'19' => 'Maine',
		'20' => 'Maryland',
		'21' => 'Massachusetts',
		'22' => 'Michigan',
		'23' => 'Minnesota',
		'24' => 'Mississippi',
		'25' => 'Missouri',
		'26' => 'Montana',
		'27' => 'Nebraska',
		'28' => 'Nevada',
		'29' => 'New Hampshire',
		'30' => 'New Jersey',
		'31' => 'New Mexico',
		'32' => 'New York',
		'33' => 'North Carolina',
		'34' => 'North Dakota',
		'35' => 'Ohio',
		'36' => 'Oklahoma',
		'37' => 'Oregon',
		'38' => 'Pennsylvania',
		'39' => 'Rhode Island',
		'40' => 'South Carolina',
		'41' => 'South Dakota',
		'42' => 'Tennessee',
		'43' => 'Texas',
		'44' => 'Utah',
		'45' => 'Vermont',
		'46' => 'Virginia',
		'47' => 'Washington State',
		'48' => 'Washington DC',
		'49' => 'West Virginia',
		'50' => 'Wisconsin',
		'51' => 'Wyoming'
	));
	
	
	 $obj->set_rule(array(
        'required' => array('error', 'Please select your state')
    ));
	
	// "zip"
    $form->add('label', 'label_zip', 'zip', 'Zip');
    $obj = $form->add('text', 'zip','',array('maxlength' => '5'));
	$obj->set_rule(array(
        'required' => array('error', 'Please enter your zip/postal code.')
    ));
  
	
	
	//Country
	 $form->add('label', 'label_country', 'country', 'Which country would you like to study in?');
   	 $obj = $form->add('text', 'country');
	 $obj->set_rule(array(
        'required' => array('error', 'Which country would you like to study in?')
    ));
	
	//When would you oilke to go
	   // "date"
    $form->add('label', 'label_fromDate', 'fromDate', 'Earliest Start Date');
    $date = $form->add('date',  'my_date', date('Y-m-d'));
    $date->set_rule(array(
        'required'      =>  array('error', 'This date is required'),
        'date'          =>  array('error', 'This date is invalid!'),
    ));

    // date format
    // don't forget to use $date->get_date() if the form is valid to get the date in YYYY-MM-DD format ready to be used
    // in a database or with PHP's strtotime function!
    $date->format('M d, Y');
	$form->add('note', 'note_date', 'fromDate', 'Date format is M d, Y');
//When would you oilke to go
	   // "date"
    $form->add('label', 'label_toDate', 'toDate', 'Latest Return date');
    $date = $form->add('date', 'date');
    $date->set_rule(array(
        'required'      =>  array('error', 'This date is required'),
        'date'          =>  array('error', 'This date is invalid!'),
    ));

    // date format
    // don't forget to use $date->get_date() if the form is valid to get the date in YYYY-MM-DD format ready to be used
    // in a database or with PHP's strtotime function!
    $date->format('M d, Y');

    $form->add('note', 'note_date', 'toDate', 'Date format is M d, Y');
	
	
	// $form->add('label', 'label_when', 'when', 'Any other notes on ?');
    // $obj = $form->add('textarea', 'when', '', array('cols' => 5));
	
	//How Long
	 $form->add('label', 'label_length', 'length', 'How long would you like to study abroad?');
   	 $obj = $form->add('textarea', 'length', '', array('cols' => 5));
	
	//Language
	 $form->add('label', 'label_language', 'language', 'How much experience do you have in the language of the host country?');
    $obj = $form->add('textarea', 'language', '', array('cols' => 5));
	
    $form->add('submit', 'btnsubmit', 'Submit');

    // if the form is valid
    if ($form->validate()) {

        // show results
        show_results();

    // otherwise
    } else

        // generate output using a custom template
        $form->render();

?>
