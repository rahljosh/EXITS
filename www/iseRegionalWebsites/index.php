<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<?php
	session_start();
	include_once('dBug.php');
	//new dBug($_SERVER);
 	$db_conn = new mysqli('204.12.102.10', 'rahljosh', 'f8qvVpF[@v', 'smg');
			
			  if (mysqli_connect_errno()) {
				echo 'Connect failed '.printf("Connect failed: %s\n", $mysqli->connect_error);
			   exit();
			  } else {
			  
			  $query = 'select r.regionname, r.regionid,
	  					u.firstname, u.lastname, u.email, u.phone
	 					from smg_regions r 
	  					left join user_access_rights uar on uar.regionid = r.regionid
						left join smg_users u on u.userid = uar.userid
	  					where r.url = "'.$_SERVER[SERVER_NAME].'" and uar.usertype = 5 and r.active = 1';
			
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
					  $_SESSION['regionalManagerEmail'] = $fieldData->email;
					  $_SESSION['regionalManagerPhone'] = $fieldData->phone;
					  $db_conn->close();
			
			
					}
			
					} else {
						echo 'This site is not registered.';
					}
			  }
			
		
?>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="robots" content="noindex">
<title>ISE <?PHP echo $_SESSION['regionname'] ?> Region Website</title>
</head>

<body>

<?PHP
new dBug($_SESSION);
?>
Lead Form:

<?php include 'extensions/includes/_pageHeader.php'; ?>
</body>
</html>