<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<script src="SpryAssets/SpryMenuBar.js" type="text/javascript"></script>
<link href="SpryAssets/SpryMenuBarHorizontal.css" rel="stylesheet" type="text/css" />
<link href="css/granby.css" rel="stylesheet" type="text/css" />
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
-->
</style></head>

<body class="oneColElsCtrHdr">
<Cfif isDefined('form.sendEmail')>
<cfmail  to="jeimi@exitgroup.org, bchatterley@granbyprep.com" replyto="#form.email#" from="support@granbyprep.com" type="html" SUBJECT="Granby Info Request"> 
<p> The info submitted was:
  <br /><br />
  <strong>Student Information</strong><br />
  Name:#form.firstname# #form.lastname#<br />
  Email:#form.email#<br />
  Sex:#form.sex# 
  <br />
  Date of Birth:#form.birth#<br />
  Current School:#form.current#<br />
  Current Grade: #form.grade# <br />
  Admission for what grade: #form.admission#<br />
  Admission for what grade: #form.admYear#<br />
  Day / Boarding school:#form.school#<br />
  Academic Interests:#form.academicInt#<br />
  Other Interests:#form.interests#<br />
  Sports Interests:#form.sportsInt#
  Comments:#form.comments#<br /><br /><br />
  
  <strong>Parent / Guardian Information</strong><br />
   Name:#form.ptfirstname# #form.ptlastname#<Br />
  Address:#form.address#<br />
  City:#form.city#<Br />
  State:#form.state#<br />
  Zip:#form.zip#<br />
  Country: #form.country#<br />
  Phone: #form.phone#<br /><br />
  
  </p>

</cfmail>
</Cfif>
<div id="container">
<div href="javascript:void(0)" onclick="window.location.href='http://www.granbyprep.com'">
  <div id="headerBar">
    <div id="clickright">
  <a href="index.cfm"><img src="images/click.png" width="190" height="170" border="0" /></a>
  <!-- BEGIN ProvideSupport.com Graphics Chat Button Code -->
<div id="ciQmQ6" style="z-index:100;position:absolute"></div><div id="scQmQ6" style="display:inline"></div><div id="sdQmQ6" style="display:none"></div><script type="text/javascript">var seQmQ6=document.createElement("script");seQmQ6.type="text/javascript";var seQmQ6s=(location.protocol.indexOf("https")==0?"https":"http")+"://image.providesupport.com/js/granbyprep/safe-standard.js?ps_h=QmQ6&ps_t="+new Date().getTime();setTimeout("seQmQ6.src=seQmQ6s;document.getElementById('sdQmQ6').appendChild(seQmQ6)",1)</script><noscript><div style="display:inline"><a href="http://www.providesupport.com?messenger=granbyprep">Live Support Chat</a></div></noscript>
<!-- END ProvideSupport.com Graphics Chat Button Code -->
  <!-- end clickright --></div>
  <!-- end header --></div></div>
  <div id="menu">
<cfinclude template ="menu.cfm">
  </div>
<div id="mainContent">
   
    <h2>Request Information</h2>
     <cfif not isDefined('form.sendEmail')>
 <p class="paragraphText"> Thank you for your interest in Granby Preparatory Academy. Please complete the form below to request more information about our school. In the mean time, don't hesitate to send us an email at:<strong> admission@granbyprep.com.</strong> </p>

<cfoutput>
  <cfform id="RequestInfo" name="RequestInfo" method="post" action="requestInfo.cfm">
  <cfinput type="hidden" name="sendEmail" value=1/>
  <table width="570" border="0">
  <tr>
    <th colspan="2" bgcolor="##CCCCCC" scope="row">Student Information</th>
    </tr>
    <tr>
    <th width="183" bgcolor="##FFFFFF" scope="row"><span class="formText">Students First Name</span></th>
    <td width="232" bgcolor="##FFFFFF"><cfinput type="text" name="firstname" message="Please enter your first name" required="yes" /></td>
    </tr>
  <tr>
    <th bgcolor="##FFFFFF" scope="row"><span class="formText">Students Last Name</span></th>
    <td bgcolor="##FFFFFF"><cfinput name="lastname" type="text" /></td>
    </tr>
     <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Email Address</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="email" type="text" /></td>
 </tr>
  <tr>
    <th bgcolor="##FFFFFF" scope="row">&nbsp; </th>
    <td bgcolor="##FFFFFF"><span class="formText">male</span>
 <cfinput name="sex" type="radio" value="male"/>
 <span class="formText"> female</span>
 <cfinput name="sex" type="radio" value="female"/></td>
  </tr>
    <tr>
  <th width="183" bgcolor="##FFFFFF" scope="row"> <span class="formText">Date of Birth</span></th>
 <td width="330" bgcolor="##FFFFFF"><cfinput type="text" name="birth" message="please enter a valid date of birth" pattern="99-99-9999" validate="date" required="yes" /></td>
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Current School</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="current" type="text" /></td>
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Current Grade</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="grade" type="text" /></td>
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Admission for what grade?</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="admission" type="text" /></td>
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Admission for what year?</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="admYear" type="text" /></td>
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Day school or boarding?</span></th>
 <td bgcolor="##FFFFFF"><cfinput name="school" type="text" /></td>
</tr>
  <tr>
<th bgcolor="##FFFFFF" scope="row"><span class="formText">Academic interests?</span></th>
 <td bgcolor="##FFFFFF"><cfselect name="academicInt" id="interest">
 				<option value=''></option>
                <option value='Math'>Math</option>
                <option value='Science'>Science</option>
                <option value='Writing'>Writing</option>
                <option value='History'>History</option>
                <option value='World Languages'>World Languages</option>
                <option value='Fine or Performing Arts'>Fine or Performing Arts</option>
                <option value='Technology'>Technology</option>
      </cfselect></td>
   </tr>
  <tr>           
<th bgcolor="##FFFFFF" scope="row"><span class="formText">Other interests?</span><br /></th>
             <td bgcolor="##FFFFFF"> <cfselect name="interests" id="interest">
		       <option value=''></option>
              <option value='Music'>Music</option>
                <option value='Visual Arts'>Visual Arts</option>
                <option value='Theater'>Theater</option>
                <option value='Dance'>Dance</option>
	      </cfselect></td>
   </tr>
  <tr>           
<th bgcolor="##FFFFFF" scope="row"><span class="formText">Sports interests?</span></th>
      <td bgcolor="##FFFFFF"><cfselect name="sportsInt" id="interest">
        		<option value=""></option>
                <option value="Soccer">Soccer</option>
                <option value="Cross country">Cross country</option>
                <option value="Volleyball">Volleyball</option>
                <option value="Basketball">Basketball</option>
                <option value="Skiing">Skiing</option>
                <option value="Baseball">Baseball</option>
                <option value="Softball">Softball</option>
                <option value="Badminton">Badminton</option>
                <option value="Golf">Golf</option>
                <option value="Tennis">Tennis</option>
                <option value="Track">Track</option>
                <option value="Martial Arts">Martial Arts</option>
	      </cfselect></td> 
 </tr>
  <tr>
 <th bgcolor="##FFFFFF" scope="row"><span class="formText">Comments or Questions?</span></th>
 <td bgcolor="##FFFFFF"><cftextarea name="comments" cols="45" rows="5"></cftextarea></td>
 </tr>
  <tr>
    <th bgcolor="##FFFFFF" scope="row">&nbsp;</th>
    <td bgcolor="##FFFFFF">&nbsp;</td>
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
 </table>
 <table width="425" border="0">
  <tr>
    <th align="right" bgcolor="##CCCCCC" scope="row"><cfinput type="submit" name="submit" id="submit" value="Submit" /></th>
  </tr>
</table>
 
 </cfform>
</cfoutput>
<cfelse>
 <p class="paragraphText"> Thank you for your interest in Granby Preparatory Academy. Your information has been submitted and you should hear from us shortly.  In the mean time should you think of any questions please don't hesitate to contact us. <strong> admission@granbyprep.com.</strong> </p>
</cfif>
 <p>&nbsp;</p>

  <!-- end mainContent --></div>
  <div id="footer">
    <p>Granby Preparatory Academy &nbsp; |&nbsp;  (800) 766-4656 or (631) 893-4540 &nbsp; |  &nbsp;66 School Street, Granby , MA 01033<br />
    For more information contact us at info@granbyprep.com</p>
  <!-- end footer --></div>
<!-- end container --></div>
<script type="text/javascript">
<!--
var MenuBar1 = new Spry.Widget.MenuBar("MenuBar1", {imgDown:"SpryAssets/SpryMenuBarDownHover.gif", imgRight:"SpryAssets/SpryMenuBarRightHover.gif"});
//-->
</script>
</body>
</html>
