<html>
<head>
<title>:: CSB International : Emplyers ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
<script>
function test(){
	/*with (document.form) {
		if (firstname.value == '') {
			alert("FIRST NAME is Required");
			firstname.focus();
			return false;
		}
	}*/
}

</script>

</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<p>&nbsp;</p>
<table width="871" height="435" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
  <tr>
		<td height="131" background="images/top.jpg"><table width="99%" border="0">
		  <tr>
		    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
	      </tr>
		  <tr>
		    <td width="325">&nbsp;</td>
		    <td><cfinclude template="menu.cfm"></td>
	      </tr>
	    </table></td>
	</tr>
	<tr>
	  <td height="252" valign="top" background="images/back-table.png"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%" height="26">&nbsp;</td>
		    <td width="90%" valign="bottom" class="top"><p><a href="index.cfm" class="LinkItens">Home</a> &gt; International Partners</p></td>
		    <td width="5%">&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="17" colspan="3"><hr width="94%" color="#CCCCCC"></td>
	      </tr>
		  <tr>
		    <td colspan="3">&nbsp;</td>
	      </tr>
		  </table>
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%">&nbsp;</td>
		    <td width="90%" class="text">
            
            <cfparam name="idnumber" default="Not filled in the request form">
	<cfparam name="sevis" default="Not filled in the request form">
	<cfparam name="lastname" default="Not filled in the request form">
	<cfparam name="firstname" default="Not filled in the request form">
	<cfparam name="middlename" default="Not filled in the request form">
	<cfparam name="street" default="Not filled in the request form">
	<cfparam name="city" default="Not filled in the request form">
	<cfparam name="state" default="Not filled in the request form">
	<cfparam name="zip" default="Not filled in the request form">
	<cfparam name="email" default="Not filled in the request form">
	<cfparam name="phone" default="Not filled in the request form">
	<cfparam name="comment" default="Not filled in the request form">
    <cfparam name="upload" default="Not filled in the request form">
  
	<cfset desc = 'SUMMER WORK & TRAVEL - International Partner Contact'>
  
 
  <cfif url.request is 'send'>
    <cfmail to="#APPLICATION.EMAIL.contact#" from="#APPLICATION.EMAIL.from#" subject="#form.companyName#">

    #desc# from the CSB web site on #dateformat(Now())#.
      
	Company name: #form.companyName#
	Primary Contact: #form.primaryContact#
    Title: #form.title#
    Email: #form.email#
    Phone Number: #form.phoneNumber#
    Mailing Address: #form.mailingAddress#
    Country: #form.country#
    Number of Years in Business: #form.yearInBusiness#
    Number of Offices: #form.numberOffices#
    Number Summer Work Travel Participants per Year: #form.numberParticipants#
    Visal Denial Rate (Percentage): #form.visaDenial#
    Previous Sponsors You Have Worked With: #form.sponsorWorked#
    Target Number of Students to be Enrolled with CSB: #form.studentsEnrolled#
    Number of Participants That Would Require Placement Assistance (Percentage): #form.numberAssistance#
      
--
    </cfmail>
    
     <strong>The following information has been succesfully submitted to IntoEdVentures.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
                  <p>Company name: #form.companyName#<br>
                  Primary Contact: #form.primaryContact#<br>
                  Title: #form.title#<br>
                  Email: #form.email#<br>
                  Phone Number: #form.phoneNumber#<br>
                  Mailing Address: #form.mailingAddress#<br>
                  Country: #form.country#<br>
                  Number of Years in Business: #form.yearInBusiness#<br>
                  Number of Offices: #form.numberOffices#<br>
                  Number Summer Work Travel Participants per Year: #form.numberParticipants#<br>
                  Visal Denial Rate (Percentage): #form.visaDenial#<br>
                  Previous Sponsors You Have Worked With: #form.sponsorWorked#<br>
                  Target Number of Students to be Enrolled with CSB: #form.studentsEnrolled#<br>
                  Number of Participants That Would Require Placement Assistance (Percentage): #form.numberAssistance#<br>
                  </p></td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>
    <div align="center"><br>
      <strong>Thank you!</strong></div>
    </div>
            
            </td>
		    <td width="5%">&nbsp;</td>
	      </tr>
      </table></td>
	</tr>
	<tr>
		<td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
	</tr>
</table>
</body>
</html>