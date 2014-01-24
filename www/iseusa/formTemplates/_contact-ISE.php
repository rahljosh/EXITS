    <!-- load Zebra_Form's stylesheet file -->
        <link rel="stylesheet" href="../Zebra_Form/public/css/zebra_form.css">

        <!-- load jQuery -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

        <!-- load Zebra_Form's JavaScript file -->
        <script src="../Zebra_Form/public/javascript/zebra_form.js"></script>
       
<?php
  // instantiate a Zebra_Form object
    $form = new Zebra_Form('form');

    // the label for the "first name" element
    $form->add('label', 'label_firstname', 'firstname', 'First Name:');

    // add the "first name" element
    $obj = $form->add('text', 'firstname');

	session_start();
	
	//This is where we process the form. 
	function show_results ()
	
	{ 
	$emailRecipient = 'Spencer';
	$emailFromName = $_POST[name];
	$emailFromAddress = $_POST[email];
	$emailTo = $_SESSION[outboundEmail];
	$emailToAddress = $_POST[email];
	$emailSubject = 'Comments from ISE Website';
	$emailBody = nl2br($_POST[comments]);
	$emailHeader = $_POST[name].' ('.$emailAddress.') wrote...';
	include('formTemplates/_sendEmail.php');
	 echo '<div align="Center"><h1>Thank you! You will be contacted shortly.</h1></div>';
	}
	
	
	
	
	

    // instantiate a Zebra_Form object
    $form = new Zebra_Form('form');

    // the label for the "first name" element
    $form->add('label', 'label_name', 'name', 'Name:','',array('inside' => true));
	
	 // add the "first name" element
    $obj = $form->add('text', 'name');

    // set rules
    $obj->set_rule(array(

        // error messages will be sent to a variable called "error", usable in custom templates
        'required'  =>  array('error', 'Please include your name.'),

    ));
	
	  // "email"
    $form->add('label', 'label_email', 'email', 'Email:','',array('inside' => true));
    $obj = $form->add('text', 'email');
    $obj->set_rule(array(
        'required'  => array('error', 'Email is required!'),
        'email'     => array('error', 'Email address seems to be invalid!')
    ));
	
	//Why Interested
	 $form->add('label', 'label_comments', 'comments', 'Comments','',array('inside' => true));
   	 $obj = $form->add('textarea', 'comments', '', array('cols' => 5));
	 $obj->set_rule(array(
        'required'  =>  array('error', 'Let us know what your thinking.'),

    ));
    $form->add('submit', 'btnsubmit', 'Send');

    // if the form is valid
    if ($form->validate()) {

        // show results
        show_results();

    // otherwise
    } else

        // generate output using a custom template
        $form->render('*horizontal');

?>
    
