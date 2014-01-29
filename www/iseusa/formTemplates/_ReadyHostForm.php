<?PHP if(isset($_COOKIE['iseLead']))
{
	header('Location: viewStudents.php');
}
?>
	    <!-- load Zebra_Form's stylesheet file -->
        <link rel="stylesheet" href="../Zebra_Form/public/css/zebra_form.css">

        <!-- load jQuery -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

        <!-- load Zebra_Form's JavaScript file -->
        <script src="../Zebra_Form/public/javascript/zebra_form.js"></script>
       
<?php


session_start();


//This is where we process the form. 
function show_results ()

{ 

function generatePassword( $length = 8 ) {
$chars = "abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ23456789!@$_=+;:,.?23456789!@$_=+;:,.?";
$password = substr( str_shuffle( $chars ), 0, $length );
return $password;
}
 

	$userPass = generatePassword();
		$db = new mysqli('204.12.102.10', 'rahljosh', 'f8qvVpF[@v', 'smg');

   if (mysqli_connect_errno()) {

   exit();
  } else {

	$hostID = "select max(id) as lastID
	 			from smg_host_lead";
					
   	$result = $db->query($hostID);
	 while($fieldData=$result->fetch_object())
	 {
		$newID = ($fieldData->lastID+1);
		$hashid = (($newID*64) % 29).chr((substr($newID,-1,1)+65)).($newID % 4);
	 }
  

  $query = "INSERT INTO
				smg_host_lead 
			(
				firstName,
				lastName,
				address,
				city,
				stateID,
				zipCode,
				phone,
				email,
				contactWithRep,
				password,
				hashID,
				contactWithRepName,
				hearAboutUs,
                httpReferer,
                remoteAddress,
				dateCreated
					)
                    VALUES                                
                    (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	$firstname = $_POST['firstname'];
	$lastname = $_POST['lastname'];
	$address = $_POST['address'];
	$city = $_POST['city'];
	$state = $_POST['state'];
	$zipcode = $_POST['zip'];
	$phone = $_POST['phone'];
	$email = $_POST['email'];
	$contactWithRep = $_POST['rep'];
	$userPass = $userPass;
	$hashid = $hashid;
	$contactWithRepName = $_POST['who'];
	$hearAboutUs = $_POST['howHear'];
	$dateCreated = date("Y-m-d");
	
	/*	
	$historyQuery = "INSERT INTO
                    applicationHistory
                 (
                    applicationID,
                    foreignTable,
                    foreignID,
                    actions,
					isResolved,
					comments,
					enteredByID,
                    dateCreated
                 )
				 VALUES (?,?,?,?,?,?,?,?)";           				
					
	  				$applicationID=6;
                    $foreignTable='smg_host_lead';
					$isResolved=0;
					$enteredByID=0;
                    $foreignID=$newID;
					$comments='n/a';
                    $actions='Status: Initial - Host Lead Received';
                    
	
	$histEntry = $db->prepare(historyQuery);
	$histEntry ->bind_param('isisisis',$applicationID,$foreignTable,$foreignID,$actions,$isResolved,$comments,$enteredByID,$dateCreated);
	$histEntry->execute();
	
	*/
	
	$stmt = $db->prepare($query);
	$stmt->bind_param('ssssisssisssssss',$firstname,$lastname,$address,$city,$state,$zipcode,$phone,$email,$contactWithRep,$userPass,$hashid,$contactWithRepName,$hearAboutUs,$_SERVER['HTTP_REFERER'],$_SERVER['REMOTE_ADDR'],$dateCreated);
    $stmt->execute();
	
	$db ->close();
	
	//Send Email to Host Lead person. 
	$emailRecipient = $_POST[firstname];
	$emailToName = $_POST[firstname].' '.$_POST[lastname];
	$emailFromAddress = $_SESSION[hostLeadEmail];
	$emailToAddress = $_POST[email];
	$emailSubject = 'Thank you for you interest in ISE.';
	$emailBody = '<p> We appreciate your interest in providing an international student with a life-changing experience. A representative of International Student Exchange';
	$emailBody .= ' will be contacting you shortly to provide you with additional information about hosting.</p>';
	$emailBody .= '<p>Please visit http://www.iseusa.com/ready-host-student.php to view profiles of students who ';
	$emailBody .= 'are coming to the United States this next season. </p>';
    $emailBody .='<p>Best Regards-<br />International Student Exchange</p>';
	
	include('formTemplates/_sendEmail.php');
	// Send the message
	
	

  }
  
  echo '<h3>Thank you for your interest in becoming a host family!</h3>';
  echo '<p>A represenative with ISE will be in contact with you shortly. Click the button below to view limited profiles of students here or coming to the US shorlty.</p>';
  echo '<div align="center"><form method="post" action="viewStudents.php">
				<input type="hidden" name="lastName" value='.$_POST[lastname].'>
				<input type="hidden" name="iseLead" value=1>
				<input type="submit" value="View Student Profiles" class="basicBlueButton"> 
		</form></div>';
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
    $form->add('note', 'note_email', 'email', 'We will only use your email to contact you regarding being a host family.  We will not send out unsolicited emails or sale your email address to other companies.', array('style'=>'width:200px'));

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
        'required' => array('error', 'Please enter your zip/postal code.'),
		'digits'    => array('', 'error', 'Accepts only digits (0 to 9)')
    ));
    // "captcha"
   // $form->add('captcha', 'captcha_image', 'captcha_code');
   // $form->add('label', 'label_captcha_code', 'captcha_code', 'anti-spam');
    //$obj = $form->add('text', 'captcha_code');
    //$form->add('note', 'note_captcha', 'captcha_code', 'You must enter the characters with black color that stand
    //out from the other characters', array('style'=>'width: 200px'));
    ///$obj->set_rule(array(
     //   'required'  => array('error', 'Enter the characters from the image above!'),
     //   'captcha'   => array('error', 'Characters from image entered incorrectly!')
    //));

    // "submit"
	
	//How hear 
	 $form->add('label', 'label_howHear', 'howHear', 'How did you hear about ISE?');
    // single-option select box
	$obj = $form->add('select', 'howHear');
 
	// add selectable values with specific indexes
	// values will be "v1", "v2" and "v3", respectively
	// a default first value, "- select -" (language dependent) will also be added
	
	
	$obj->add_options(array(
	 'Friend / Acquaintance'  => 'Friend / Acquaintance',
	 'Church Group' => 'Church Group',
     'Facebook' => 'Facebook',
     'Google Search' => 'Google Search',
     'Yahoo Search' => 'Yahoo Search',
     'Past Host Family' =>  'Past Host Family',
	 'Printed Material' => 'Printed Material'
		
	));
		$obj->set_rule(array(
        'required' => array('error', 'Please indicate how you heard about ISE.')
    ));
	//Rep
	 $form->add('label', 'label_rep', 'rep', 'Are you in contact with an
ISE Representative?');
    // single-option select box
	$obj = $form->add('select', 'rep');
 
	// add selectable values with specific indexes
	// a default first value, "- select -" (language dependent) will also be added
	
	$obj->add_options(array(
	 'Yes'  => 'Yes',
	 'No' => 'No'
		
	));
		$obj->set_rule(array(
        'required' => array('error', 'Please indicate if you are in touch with a rep.')
    ));
	
	//What rep?
	  // "why"
    $form->add('label', 'label_who', 'who', 'Who is the rep you have been working with?');
    $obj = $form->add('text', 'who');
    $obj->set_rule(array(
        'required'  =>  array('error', 'Please tell us the rep you\'re working with.' ),
        'dependencies'   =>  array(array(
            'rep' =>  'Yes',
        ), 'mycallback, 1'),
    ));
    $form->add('submit', 'btnsubmit', 'Submit');

    // if the form is valid
    if ($form->validate()) {

        // show results
        show_results();

    // otherwise
    } else

        // generate output using a custom template
        $form->render('formTemplates/_ReadyHostFormDisplay.php');

?>