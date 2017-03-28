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
	
	require_once 'lib/swift_required.php';
	//Email that is sent to ISE Staff
	// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('smtp1.dnsmadeeasy.com', 25)
	  ->setUsername('iseTest')
	  ->setPassword('fr12ws98')
	  ;
	// Create the Mailer using your created Transport
	$mailer = Swift_Mailer::newInstance($transport);
	
	// Create a message
	//Send Email to person that filled out message. 
	$emailRecipient = $_SESSION[regionalManagerFirst];
	$emailFromName = $_POST[firstname].' '.$_POST[lastname];
	$emailFromAddress = $_POST[email];
	$emailTo = $_SESSION[regionalManagerFirst];
	$emailToAddress = $_SESSION[regionalManagerEmail];
	$emailSubject ='Interest in working with ISE';
	$emailHeader = $_POST[name].' ('.$emailAddress.') wrote...';
  
  	$emailBody =  '<p>Hey '.$emailRecipient.',</p>';
	$emailBody .= '<p><em>Will be sent to '.$_SESSION[regionalManagerEmail].' when live</em></p>';
	$emailBody .=  '<p>'.$_POST[firstname].' is interested in working with ISE as a '.$_POST[position].'</p> ';
	$emailBody .= '<p>Name: '.$_POST[firstname].' '.$_POST[lastname].'<br>';
    $emailBody .= 'Address: '.$_POST[address].'<br>';
    $emailBody .= 'City: '.$_POST[city].'<br>';
    $emailBody .= 'State: '.$_POST[state].'<br>';
	$emailBody .= 'Zip:  '.$_POST[zip].'<br>';
    $emailBody .= 'Phone: '.$_POST[phone].'<br>';
    $emailBody .= 'E-Mail Address:  '.$_POST[email].'<br>';
	$emailBody .= 'Why Interested:  '.$_POST[why].'<br>';
	
	include('formTemplates/_sendEmail.php');
	// Send the message
	
	  ;
	
	
	  echo '<p>Thank you for your interest in working with ISE.</p><p> Your information has been submitted and you should be contacted shortly.</p>';
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
	// "email"
    $form->add('label', 'label_phone', 'phone', 'Phone Number:');
    $obj = $form->add('text', 'phone');
    $obj->set_rule(array(
        'required'  => array('error', 'Phone number is required!'),
       
    ));

    // attach a note to the email element
    $form->add('note', 'note_email', 'email', 'We will only use your email to contact you regarding job opportunities.  We will not send out unsolicited emails or sell your email address to other companies.', array('style'=>'width:200px'));

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
	// "city"
    $form->add('label', 'label_state', 'state', 'State');
    // single-option select box
	$obj = $form->add('select', 'state');
 
	// add selectable values with specific indexes
	// values will be "v1", "v2" and "v3", respectively
	// a default first value, "- select -" (language dependent) will also be added
	
	
	$obj->add_options(array(
		'Alabama' => 'Alabama',
		'Alaska' => 'Alaska',
		'Arizona' => 'Arizona',
		'Arkansas' => 'Arkansas',
		'California' => 'California',
		'Colorado' => 'Colorado',
		'Connecticut' => 'Connecticut',
		'Deleware' => 'Deleware',
		'Florida' => 'Florida',
		'Georgia' => 'Georgia',
		'Hawaii' => 'Hawaii',
		'Idaho' => 'Idaho',
		'Illinois' => 'Illinois',
		'Indiana' => 'Indiana',
		'Iowa' => 'Iowa',
		'Kansas' => 'Kansas',
		'Kentucky' => 'Kentucky',
		'Louisiana' => 'Louisiana',
		'Maine' => 'Maine',
		'Maryland' => 'Maryland',
		'Massachusetts' => 'Massachusetts',
		'Michigan' => 'Michigan',
		'Minnesota' => 'Minnesota',
		'Mississippi' => 'Mississippi',
		'Missouri' => 'Missouri',
		'Montana' => 'Montana',
		'Nebraska' => 'Nebraska',
		'Nevada' => 'Nevada',
		'New Hampshire' => 'New Hampshire',
		'New Jersey' => 'New Jersey',
		'New Mexico' => 'New Mexico',
		'New York' => 'New York',
		'North Carolina' => 'North Carolina',
		'North Dakota' => 'North Dakota',
		'Ohio' => 'Ohio',
		'Oklahoma' => 'Oklahoma',
		'Oregon' => 'Oregon',
		'Pennsylvania' => 'Pennsylvania',
		'Rhode Island' => 'Rhode Island',
		'South Carolina' => 'South Carolina',
		'South Dakota' => 'South Dakota',
		'Tennessee' => 'Tennessee',
		'Texas' => 'Texas',
		'Utah' => 'Utah',
		'Vermont' => 'Vermont',
		'Virginia' => 'Virginia',
		'Washington State' => 'Washington State',
		'Washington DC' => 'Washington DC',
		'West Virginia' => 'West Virginia',
		'Wisconsin' => 'Wisconsin',
		'Wyoming' => 'Wyoming'
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
  
	
	
	//Posistion
	 $form->add('label', 'label_posistion', 'position', 'Which position are you interested in?');
    // single-option select box
	$obj = $form->add('select', 'position', 'Area Rep');
 
	// add selectable values with specific indexes
	// a default first value, "- select -" (language dependent) will also be added
	
	$obj->add_options(array(
	 'Area Rep'  => 'Area Representative'
		
	));
		$obj->set_rule(array(
        'required' => array('error', 'Which posistion are you interested in.')
    ));
	//Why Interested
	 $form->add('label', 'label_why', 'why', 'Why are you interested in this position?');
    $obj = $form->add('textarea', 'why', '', array('cols' => 5));
	$obj->set_rule(array(
        'required' => array('error', 'Why are you interested in this position?')
    ));
	
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
