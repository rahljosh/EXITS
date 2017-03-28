
<?PHP
session_start();
if(!isset($_COOKIE['iseLead']))
	{
		if (isset($_POST['iseLead'])){
			
			setcookie('iseLead', viewStudents, time()+3600*24*365, '/');  /* expire in 1 year */	
		}
	};
	
if(!isset($_COOKIE['iseLead']))
{
	header( 'Location: meet-our-students.php' );
}

?>

<?php include 'extensions/_pageHeader.php'; ?>
<?php include 'dBug.php'; ?>

<!----PAGINATION---->
<?php

        // database connection detailss
        $MySQL_host     = 'db.exitsapplication.com';
        $MySQL_username = 'rahljosh';
        $MySQL_password = 'f8qvVpF[@v';
        $MySQL_database = 'smg';

        // if could not connect to database
        if (!($connection = @mysql_connect($MySQL_host, $MySQL_username, $MySQL_password)))

            // stop execution and display error message
            die('Error connecting to the database!<br>Make sure you have specified correct values for host, username and password.');

        // if database could not be selected
        if (!@mysql_select_db($MySQL_database, $connection))

            // stop execution and display error message
            die('Error selecting database!<br>Make sure you have specified an existing and accessible database.');

        // how many records should be displayed on a page?
        $records_per_page = 5;

        // include the pagination class
        require 'Zebra_Pagination/Zebra_Pagination.php';

        // instantiate the pagination object
        $pagination = new Zebra_Pagination();

        // set position of the next/previous page links
        $pagination->navigation_position(isset($_GET['navigation_position']) && in_array($_GET['navigation_position'], array('left', 'right')) ? $_GET['navigation_position'] : 'outside');

        // the MySQL statement to fetch the rows
        // note how we build the LIMIT
        // also, note the "SQL_CALC_FOUND_ROWS"
        // this is to get the number of rows that would've been returned if there was no LIMIT
        // see http://dev.mysql.com/doc/refman/5.0/en/information-functions.html#function_found-rows
      // echo var_dump(validateDate($_POST['fromDate'], 'Y-m-d'));
	   
		
	$MySQL = 'SELECT  
		SQL_CALC_FOUND_ROWS   	
            studentid,
            dob, 
            firstname, 
            interests, 
            interests_other, 
            countryresident,
            smg_countrylist.countryname, 
            smg_religions.religionname,
			regionassigned
        FROM
            smg_students
        INNER JOIN 	
            smg_countrylist ON smg_countrylist.countryid = smg_students.countryresident
        LEFT JOIN 	
            smg_religions ON smg_religions.religionid = smg_students.religiousaffiliation
        WHERE 	   	
            active = 1 
			 AND 
            hostid = 0
        AND 
            direct_placement = 0
        AND 
            (companyID = 1 or companyid = 2 or companyid = 3 or companyid = 4 or companyid = 12)
		AND regionassigned = '.$_SESSION['regionid'].'
        LIMIT
                ' . (($pagination->get_page() - 1) * $records_per_page) . ', ' . $records_per_page . '
     ';  
		
	
		
        // if query could not be executed
        if (!($result = @mysql_query($MySQL)))

            // stop execution and display error message
            die(mysql_error());

        // fetch the total number of records in the table
        $rows = mysql_fetch_assoc(mysql_query('SELECT FOUND_ROWS() AS rows'));

        // pass the total number of records to the pagination class
        $pagination->records($rows['rows']);

        // records per page
        $pagination->records_per_page($records_per_page);
		
        ?>

 <link rel="stylesheet" href="Zebra_Pagination/examples/style.css" type="text/css">

 <link rel="stylesheet" href="Zebra_Pagination/public/css/zebra_pagination.css" type="text/css">
<!----END OF PAGINATION---->

<?PHP  

 $db_conn = new mysqli('db.exitsapplication.com', 'rahljosh', 'f8qvVpF[@v', 'smg');

   if (mysqli_connect_errno()) {
	
   exit();
  } else {

 

  $studentResults = $db_conn->query($MySQL);
 
  }


  
?>

<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>

<img src="images/header-pic.jpg" width="1024" height="250" alt=" ISE student Scholarships" />
  <?php include '_menu.php'; ?>
 <div class="clearfloat">&nbsp;</div>
 
<article class="contentLft">
<div class="dotLine">&nbsp;</div>
<h1>View Our Exchange Students</h1>
<div class="dotLine">&nbsp;</div>

<h3>Student Profiles</h3>
<p>Below are some are students that are currently in the US or on their way.</p>
<div class="blueLine">&nbsp;</div>

<table width="90%" align="center">
	<Tr>
<?PHP

	while($studentRow=$studentResults->fetch_assoc())
		
		{
		$now = new DateTime();
		$birthday = new DateTime($studentRow['dob']);
		$interval = $now->diff($birthday);
	
		echo '<tr>';
		echo '<td>';
		echo '<span class="picIMG" style="float:right; margin:10px;"><img src="http://ise.exitsapplication.com/nsmg/pics/flags/'.$studentRow['countryresident'].'.jpg" width="133"></span>';
		echo '<strong>Name: </strong>'.$studentRow['firstname'].'<br>';
		echo '<strong>Age: </strong> '.$interval->format('%y years').'<br />';
		echo '<strong>Home Country: </strong>'.$studentRow['countryname'].'<br />';
		echo '<strong>ID: </strong>'.$studentRow['studentid'].'-'.$_SESSION['regionid'].'<br />';
		//echo '<strong>Religion: </strong>'.$studentRow['religionname'].'<br /><br />';
		echo '<strong>About '.$studentRow->firstname.': </strong>'.$studentRow['interests_other'].'</p>';
		echo '</td>';
      	echo '</tr>';
		echo '<tr>';
		echo '<td>';
		echo '<div class="dotLine">&nbsp;</div>';
		echo '</td>';
      	echo '</tr>';
		
		}
	?>
</Table>

      <div class="clearfloat" style="height: 20px;">&nbsp;</div> 
<div class="blueLine">&nbsp;</div>
  <div class="clearfloat" style="height: 20px;">&nbsp;</div> 
     <tr>
     	<Td colspan=4 align="center"> 
		<?php

        // render the pagination links
        $pagination->render();
        ?></Td>
    </table>
    
          </cfif>

<div class="clearfloat" style="height: 20px;">&nbsp;</div>
<div style="background-color: #FFC; padding: 20px 20px 5px 20px; font-style: italic; width: 90%; margin: 10px auto;">
<p style="color: #16468E; font-style: italic;">If you have already spoken with an ISE representative and are ready to host, then please hit the login button at the top of the page to start your Host Family Application.  You must have an email from an ISE representative that contains instructions and login information before you can start your Host Family Application.</p>
</div> 

<div class="clearfloat" style="height: 20px;">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>
 <div class="dotLine">&nbsp;</div>
 
   <div class="clearfloat">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>