<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="../SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="../SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
<link href="../css/granby.css" rel="stylesheet" type="text/css" />
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Granby Preparatory Academy: Request Information</title>
<style type="text/css">

<!--
body {
	font: 100% Verdana, Arial, Helvetica, sans-serif;
	background: #666666;
	margin: 0; /* it's good practice to zero the margin and padding of the body element to account for differing browser defaults */
	padding: 0;
	text-align: center; /* this centers the container in IE 5* browsers. The text is then set to the left aligned default in the #container selector */
	color: #000000;
}
td, th {
	padding-left: 15px;
	padding-top: 2px;
	padding-bottom: 2px;
}
.InsPhoto {
	float: right;
	height: 500px;
	width: 330px;
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
	text-align: center;
}
.call-out {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	height: 200px;
	width: 250px;
	background-color: #FDD22B;
	margin-top: 20px;
	margin-left: 10px;
	padding-top: 10px;
	padding-right: 30px;
	padding-bottom: 10px;
	padding-left: 30px;
	line-height: 16px;
}
-->
</style></head>

<body class="oneColElsCtrHdr">
<Cfif isDefined('form.sendEmail')>
<cfmail  to="#APPLICATION.EMAIL.headMaster#;#APPLICATION.EMAIL.admissionsOfficer#;jeimi@exitgroup.org" replyto="#form.email#" from="support@granbyprep.com" type="html" SUBJECT="Granby Open House Registration"> 
<p> The info submitted was:
  <br /><br />
  <strong>Student Information</strong><br />
  Name:#form.firstname# #form.lastname#<br />
  Email:#form.email#<br />
  
<strong>Parent / Guardian Information</strong><br />
  Name:#form.ptfirstname# #form.ptlastname#<Br />
  Address:#form.address#<br />
  City:#form.city#<Br />
  State:#form.state#<br />
  Zip:#form.zip#<br />
  Country: #form.country#<br />
  Phone: #form.phone#<br /><br />
  Attendees: #form.attendees#<br /><br />
  Comments:#form.comments#<br /><br /><br />
  
  </p>

</cfmail>
</Cfif>
<div id="container">
<div href="javascript:void(0)" onclick="window.location.href='http://www.granbyprep.com'">
  <div id="headerBar">
    <div id="clickright">
  <a href="../index.cfm"><img src="../images/click.png" width="190" height="170" border="0" /></a>
  <!-- BEGIN ProvideSupport.com Graphics Chat Button Code -->
<div id="ciQmQ6" style="z-index:100;position:absolute"></div><div id="scQmQ6" style="display:inline"></div><div id="sdQmQ6" style="display:none"></div><script type="text/javascript">var seQmQ6=document.createElement("script");seQmQ6.type="text/javascript";var seQmQ6s=(location.protocol.indexOf("https")==0?"https":"http")+"://image.providesupport.com/js/granbyprep/safe-standard.js?ps_h=QmQ6&ps_t="+new Date().getTime();setTimeout("seQmQ6.src=seQmQ6s;document.getElementById('sdQmQ6').appendChild(seQmQ6)",1)</script><noscript><div style="display:inline"><a href="http://www.providesupport.com?messenger=granbyprep">Live Support Chat</a></div></noscript>
<!-- END ProvideSupport.com Graphics Chat Button Code -->
  <!-- end clickright --></div>
  <!-- end header --></div></div>
  <div id="menu">
<cfinclude template ="../menu.cfm">
  </div>
<div id="mainContent">
   
    <h2>The MacDuffie /GPA School Open House</h2>
     <cfif not isDefined('form.sendEmail')>
 <p class="paragraphText">Come visit us at the MacDuffie / GPA school on<strong> January 23rd 2011 from 1:00 &#8211; 4:00 PM</strong> for our Open House!  Please fill out the registration form below. </p>
<p class="paragraphText">Guests will be shown around campus on a tour of the grounds and given an opportunity to see the exciting opportunities available at the MacDuffie / GPA school! Come and see New England's newest world-class high school!</p><br />

  <div class="InsPhoto"><img src="images/GPA_Arial.jpg" width="330" height="220" alt="GAP arial shot" /><br /><br />
  Aerial shot of Granby Prep Academy
    <div class="call-out">
      <h2>Open House</h2>
      <p>Granby Preparatory Academy opened its doors for the first time to the area residents to come and see all of the changes that the GPA campus has undergone.</p>
      <p><a href="openhouse.cfm">Click to see video </a><br />
        from the first Open House</p>
    </div>
  </div>
<cfoutput>
  <cfform id="RequestInfo" name="RequestInfo" method="post" action="#CGI.SCRIPT_NAME#">
  <cfinput type="hidden" name="sendEmail" value="1"/>
  <table width="425" border="0">
  <tr>
    <th colspan="2" bgcolor="##CCCCCC" scope="row">Student Information</th>
    </tr>
    <tr>
    <th width="183" bgcolor="##FFFFFF" scope="row"><span class="formText">Student First Name</span></th>
    <td width="232" bgcolor="##FFFFFF"><cfinput type="text" name="firstname" message="Please enter your first name" required="yes" /></td>
    </tr>
  <tr>
    <th bgcolor="##FFFFFF" scope="row"><span class="formText">Student Last Name</span></th>
    <td bgcolor="##FFFFFF"><cfinput name="lastname" type="text" /></td>
    </tr>
     <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Email Address</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="email" type="text" /></td>
 </tr>
  </table>

  
  <table width="425" border="0">
    <tr>
      <th colspan="2" bgcolor="##CCCCCC" scope="row"> Parent/Guardian Information</th>
      </tr>
    <tr>
      <th width="183" bgcolor="##FFFFFF" scope="row"><span class="formText">First Name</span></th>
      <td width="232" bgcolor="##FFFFFF"><cfinput name="ptfirstname" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">Last Name</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="ptlastname" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"> <span class="formText">Address</span></th>
      <td bgcolor="##FFFFFF"> <cfinput name="address" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">City</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="city" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">State</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="state" type="text" /></td>
      </tr>
    <tr>            
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">Zipcode</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="zip" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">Country</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="country" type="text" /></td>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formText">Home Phone</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="phone" type="text" /></td>
      </tr>
    <tr>
      <th colspan="2" bgcolor="##CCCCCC" scope="row">Attendance Information</th>
      </tr>
    <tr>
      <th bgcolor="##FFFFFF" scope="row"><span class="formTextRed">Number Attending</span></th>
      <td bgcolor="##FFFFFF"><cfinput name="attendees" type="text" /></td>
      </tr>
      <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Comments or Questions?</span></th>
 <td bgcolor="##FFFFFF"><cftextarea name="comments" cols="25" rows="5"></cftextarea></td>
 </tr>
  </table>
 <table width="425" border="0">
  <tr>
    <th align="right" bgcolor="##CCCCCC" scope="row"><cfinput type="submit" name="submit" id="submit" value="Submit" /></th>
  </tr>
</table>
 
 </cfform>
</cfoutput>
<cfelse>
 <p class="paragraphText"> Thank you for your interest in the MacDuffie / GPA school Open House. We look forward to seeing you at our Open House.</p>
</cfif>
 <p>&nbsp;</p>

  <!-- end mainContent --></div>
<cfinclude template ="../footer.cfm">
<!-- end container --></div>
<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
</body>
</html>
