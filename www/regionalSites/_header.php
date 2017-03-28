
<?php
	
	session_start();
	if (strpos($_SERVER[SERVER_NAME],'www.') !== false) {
   header( 'Location: '.substr($_SERVER[SERVER_NAME], 4).'');
}
	
	include_once('extensions/dumpVars.php');
	include_once('dBug.php');
	 // include the Zebra_Form class
    require 'Zebra_Form/Zebra_Form.php';
	
	//Block for NY
	//if ($_SERVER['REMOTE_ADDR'] == '96.56.128.61'){
	//	new dBug($_SESSION);	
	//	exit();
	//};
	//new dBug($_SESSION);
	
 	$db_conn = new mysqli('db.exitsapplication.com', 'rahljosh', 'f8qvVpF[@v', 'smg');
			
			  if (mysqli_connect_errno()) {
				echo 'Connect failed '.printf("Connect failed: %s\n", $mysqli->connect_error);
			   exit();
			  } else {
			  
			  $query = 'select r.regionname, r.regionid, r.url, r.facebook, r.twitter, r.googleplus, r.websiteBlurb, r.tumblr, r.youtube, r.pintrest, r.regionalEmail,r.title,
	  					u.firstname, u.lastname, u.email, u.work_phone as phone, u.userid
	 					from smg_regions r 
	  					left join user_access_rights uar on uar.regionid = r.regionid
						left join smg_users u on u.userid = uar.userid
	  					where r.url like "'.$_SERVER[SERVER_NAME].'" and uar.usertype = 5 and r.active = 1';
			
			  $result = $db_conn->query($query);
			
			
			  if ($result->num_rows >0 )
			  {
					 //$result=mysql_query($query);
					 $row = mysql_fetch_assoc($result);
			while($fieldData=$result->fetch_object())
					{
				// set session varibales for region info

					  $_SESSION['regionname'] = $fieldData->regionname;
					  $_SESSION['regionid'] = $fieldData->regionid;
					  $_SESSION['regionalManagerName'] = $fieldData->firstname.' '.$fieldData->lastname;
					  $_SESSION['regionalManagerFirst'] = $fieldData->firstname;
					  $_SESSION['regionalManagerLast'] = $fieldData->lastname;
					  $_SESSION['regionalManagerEmail'] = $fieldData->regionalEmail;
					  $_SESSION['regionalManagerPhone'] = $fieldData->phone;
					  $_SESSION['regionalManagerID'] = $fieldData->userid;
					  $_SESSION['regionalManagerTitle'] = $fieldData->title;
					  $_SESSION['websiteBlurb'] = $fieldData->websiteBlurb;
					  $_SESSION['facebook'] = $fieldData->facebook;
					  $_SESSION['tumblr'] = $fieldData->tumblr;
					  $_SESSION['youtube'] = $fieldData->youtube;
					  $_SESSION['googleplus'] = $fieldData->googleplus;
					  $_SESSION['pintrest'] = $fieldData->pintrest;
					  $_SESSION['twitter'] = $fieldData->twitter;
					  $db_conn->close();
			
			
					}
			
					} else {
						echo '<table align="center"><tr><td><br><br><br>';
						echo 'This doesn\'t seem to be a valid regional site. <br> Please contact josh@iseusa.org regarding: '.$_SERVER[SERVER_NAME].'';
						
						echo '</td></tr></table>';
						exit();
					}
			  }
			
		
?>
<header>
<title>ISE <?php echo $_SESSION['regionname']; ?> </title>
<div class="fltrt" style="margin: 5px 20px 0 0; width:250px;"><span class="smSize">Call us:</span> <strong><?PHP echo $_SESSION['regionalManagerPhone']; ?></strong></div>
<div class="fltlt" style="margin: 5px 0 0 40px; width:350px;"><strong>International Student Exchange</strong></div>
</header>