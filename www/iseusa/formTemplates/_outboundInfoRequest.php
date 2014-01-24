	    <!-- load Zebra_Form's stylesheet file -->
        <link rel="stylesheet" href="../Zebra_Form/public/css/zebra_form.css">

  
       
<?php


/* rest of code goes here */

session_start();


//This is where we process the form. 
function show_results ()

{ 

	require_once 'lib/swift_required.php';
	// Create the Transport
	$transport = Swift_SmtpTransport::newInstance('smtp1.dnsmadeeasy.com', 25)
	  ->setUsername('iseTest')
	  ->setPassword('fr12ws98')
	  ;
	// Create the Mailer using your created Transport
	$mailer = Swift_Mailer::newInstance($transport);
	
	// Create a message
	//Send Email to person that filled out message. 
	$emailRecipient = $_POST[firstname];
	$emailFromName = 'ISE Outbound';
	$emailFromAddress = $_SESSION[outboundEmail];
	$emailTo = $_POST[firstname].' '.$_POST[lastname];
	$emailToAddress = $_POST[email];
	$emailSubject ='Your interest in studying abroad';
	$emailHeader = $_POST[name].' ('.$emailAddress.') wrote...';
  	$emailBody =  'Dear '.$_POST[firstname].',';
	$emailBody .='<p>Thank you for your interest in our program. Below, please find information regarding frequently asked questions about International Student Exchange&rsquo;s Outbound program.</p>';
	$emailBody .='<p>I have also attached some additional information along with this email for you to review. Our information is currently being updated for the upcoming year, so please do not take the program prices and deadlines to heart at the moment, although they will fall around the same ranges.</p>';
	$emailBody .='<p><strong>International Student Exchange (ISE) Outbound Program Important Information </strong><br></p>';
	$emailBody .='<p>1. In order to study abroad, each student must receive a student visa from the country in which they plan to visit. A visa is needed for both school year programs and semester programs. To obtain a visa, a student must schedule an appointment with a Consulate of the host country, located in the United States. This process may take as long as four weeks and, in some cases, may entail a fee. This fee and other travel expenses incurred in acquiring this visa will not be covered by your Outbound program fee and will be at the student\'s expense.</p>';
	$emailBody .='<p>2. ISE Outbound program works with students between the ages of 15 and 18 1/2. </p>';
    $emailBody .='<p>3. Each program applicant must have at least two years of experience speaking, reading, and writing in the language of the host country. Language immersion programs such as &quot;Rosetta Stone&quot; will be considered on a subjective basis.</p>';
	$emailBody .='<p>4. Students abroad will live with host families who have undergone thorough background checks. A representative of ISE\'s overseas partner agency will be available to address any concerns of the student while abroad. An International Student Exchange representative will be available to address concerns of the natural family. The ISE representative and overseas agent will work together to address any and all issues that may arise in order to ensure a safe and rewarding cultural sharing experience.</p>';
    $emailBody .='<p>5. International Student Exchange will provide insurance for the student while abroad. These insurance expenses will be covered by the cost of your program fee. This program fee also covers homestay, room and board, and school placement.</p>';
	$emailBody .='<p>6. Program fees are due in their entirety thirty (30) days after formal acceptance into the program.</p>';
    $emailBody .='<p>7. In certain countries, private school options will be offered to the Outbound student. These private school options are optional. If the private school option is accepted by the student, the student is liable for any accompanying tuition fees, which are not included in the cost of the program.</p>';
	$emailBody .= '<p>8. In order to apply for a visa, certain consulates require a complete flight itinerary before providing a visa. In the event that a plane ticket cannot yet be purchased, because the date of the program\'s end is too far in advance, a placeholder date may be put in for the purposes of acquiring the visa. The actual departure flight may be purchased at a later date, with the proper information being forwarded by ISE to the overseas agent at that time.</p>';
    $emailBody .='<p>9. Each Outbound application must include a $100 dollar, non-refundable application fee. Each application must also include a $750 program deposit. This $750 will go towards the student\'s program fee and will be refunded if the student is not selected for the Outbound program, or must back out of the program prior to visa acquisition and departure.</p>';
	
    $emailBody .='<p>10. Note that these schools are not English speaking schools in a foreign country. Host families and schools will be authentic in the sense that the foreign language (if applicable) will be spoken exclusively.</p>';
    $emailBody .='<p>11. No scholarships towards the program are offered to any applicants under any circumstances. The primary fee of this program pays the international agent and does not involve ISE.</p>';
	$emailBody .= '<p>12. ISE requires each student to arrive with $300 spending money for each month of the student\'s program.</p>';	
	$emailBody .='<p><strong>For more information about studying abroad please click the links below:</strong></p>';
	$emailBody .='<p><ul>
                <li><a href="http://www.iseusa.com/pdfs/OUTBOUND/PriceList2014.pdf">2014 Pricelist</a></li>
                <li><a href="http://www.iseusa.com/pdfs/OUTBOUND/PromoFlyer2014-15.pdf">Promomotional Ad</a></li>
                <li><a href="http://www.iseusa.com/pdfs/OUTBOUND/Outbound-App-2014.pdf">Student Application</a></li>
                <li><a href="http://www.iseusa.com/pdfs/OUTBOUND/Outbound_Student_Handbook_2014.pdf">Student Handbook</a></li>
				</ul></p>';
	$emailBody .='<p>Best Regards,</p>
				<p><strong>Tom Policastro</strong><br>
 				 Project Manager<br>
  				International Student Exchange<br>
				tom@iseusa.com<br>
				1-631-893-4540 Ext. 104</p>
				<p><br />
				</p>';
		
				
	
	include('formTemplates/_sendEmail.php');
	// Send the message
	
	
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
	$emailRecipient = 'Tom';
	$emailFromName = $_POST[firstname].' '.$_POST[lastname];
	$emailFromAddress = $_POST[email];
	$emailTo = 'Tom';
	$emailToAddress = $_SESSION[outboundEmail];
	$emailSubject ='Interest in Outbound Program';
	$emailHeader = $_POST[name].' ('.$emailToAddress.') wrote...';
  	$emailBody =  '<p>Hey '.$emailRecipient.',</p>';
	$emailBody .=  '<p>'.$_POST[firstname].' would like more info on the outbound program.</p> ';
	$emailBody .= '<p>Name: '.$_POST[firstname].' '.$_POST[lastname].'<br>';
    $emailBody .= 'Address: '.$_POST[address].'<br>';
    $emailBody .= 'City: '.$_POST[city].'<br>';
    $emailBody .= 'Zip:  '.$_POST[zip].'<br>';
    $emailBody .= 'State: '.$_POST[state].'<br>';
    $emailBody .= 'Phone: '.$_POST[phone].'<br>';
    $emailBody .= 'E-Mail Address:  '.$_POST[email].'<br>';
    $emailBody .= 'What country are you interested in: '.$_POST[country].'<br>';
    $emailBody .= 'How did you hear about us: '.$_POST[language].'</p>';
	
	include('formTemplates/_sendEmail.php');
	// Send the message
	
	
	
	
	
	  echo '<h2>Thank you for your interest in the ISE Outbound Program.</h2><p> You should receive and email with more information on the outbound program.  After reviewing your information a representative from ISE will be in contact with you.</p>';
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
      <!-- load jQuery -->
         <script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
        <script>window.jQuery || document.write('<script src="path/to/jquery-1.9.1.min.js"><\/script>')</script>

        <!-- load Zebra_Form's JavaScript file -->
        <script src="../Zebra_Form/public/javascript/zebra_form.js"></script>