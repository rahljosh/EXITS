<html>
<head>
<title>:: IntoEdVentures ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<script src="menu.js"></script>
</head>
<body>
<table width="770" height="442" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="134"><script>menutop();</script></td>
	</tr>
	<tr>
<td background="images/blank_02.gif"><table width="95%"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><P align="left"><span class="style1"><img src="images/work_travel.gif" width="730" height="42"><BR>
            </span>              
			</td>
          </tr>
          <tr>
            <td height="250" valign="top" class="style1"><div align="center">
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
  
	<cfif url.request is 'checkin'>
		<cfset desc = 'SUMMER WORK & TRAVEL - CHECK-IN / VALIDATION'>
		<cfelse>
		<cfset desc= 'SUMMER WORK & TRAVEL - CHANGE OF EMPLOYER/ADDRESS'>
	</cfif>
  
 
  <cfif url.request is 'checkin'>
    <cfmail from="#APPLICATION.EMAIL.TRAINEE.from#" to="#APPLICATION.EMAIL.TRAINEE.contact#" subject="#form.lastname#, #form.firstname#  - Validation">

      #desc# from the CSB web site on #dateformat(Now())#.
      
		Student ID Number: #form.idnumber#
		SEVIS Number: #form.sevis#
		Last Name: #form.lastname#
		First Name: #form.firstname#
		Middle Name: #form.middlename#
		Street address in US: #form.street#
		City: #form.city#
		State: #form.state#
		ZIP code: #form.zip#
		E-Mail Address: #form.email#
		Phone number: #form.phone#
      
		Comments: #form.comment#
      
--
    </cfmail>
            </div>
              <div class="page-title"></div>
              <div align="center"><br>
                <strong>The following information has been succesfully submitted to IntoEdVentures.</strong><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="style1">
      Student ID Number: #form.idnumber#<br>
	  SEVIS Number: #form.sevis#<br>
	  Last Name: #form.lastname#<br>
  	  First Name: #form.firstname#<br>
	  Middle Name: #form.middlename#<br>
	  Street address in US: #form.street#<br>
      City: #form.city#<br>
	  State: #form.state#<br>
	  ZIP code: #form.zip#<br>
      E-Mail Address: #form.email#<br>
      Phone number: #form.phone#<br>
      <br>
	  Comments: #form.comment#
		          </td>
	        </tr>
      </table>
    </cfoutput>
	
    <Cfelse>
    <!--- Check to see if the Form variable exists. --->
	
    <cfmail from="#APPLICATION.EMAIL.TRAINEE.from#" to="#APPLICATION.EMAIL.TRAINEE.contact#" subject="#form.lastname2#, #form.firstname2#  - Validation">
	<cfif form.UploadFile NEQ ''>
    	<cffile action="upload" fileField="UploadFile" destination="/var/www/html/intoedventures/uploaded/job-offers/" nameConflict="overwrite" mode="777">
		<cfmailparam file="#CFFILE.ServerDirectory#/#CFFILE.ServerFile#">
		<cfset FileName = file.ServerFileName>
    <cfelse>
		<cfset FileName = "No File Attached!">
	</cfif>
	
      #desc# from the CSB web site on #dateformat(Now())#.
      
		Student ID Number: #form.idnumber2#
		Last Name: #form.lastname2#
		First Name: #form.firstname2#
		Middle Name: #form.middlename2#
		Email Address: #form.email2#
		----------------------------------------
		New employer information
		----------------------------------------
		Company name: #form.company#
		Street address: #form.compaddress#
		City: #form.compcity#
		State: #form.compstate#
		ZIP code: #form.compzip#
		Primary Contact: #form.compcontact#
		Phone Number: #form.comphone#
		Email Address: #form.compemail#
        
		Attached File: #FileName#
		----------------------------------------
		New housing information
		----------------------------------------
		Street address in US: #form.housingaddress#
		City: #form.housingcity#
		State: #form.housingstate#
		ZIP code: #form.housingzip#
		Phone Number: #form.housingphone#
            
--
    </cfmail>
            </div>
              <div class="page-title"></div>
              <div align="center">
              <div align="center"><br>
                <strong>The following information has been succesfully submitted to IntoEdVentures.</strong></div>
              <cfoutput>
      <table width=90% align="center">
	      <tr>
		        <td class="style1">
	  Student ID Number: #form.idnumber2#<br>
	  Last Name: #form.lastname2#<br>
  	  First Name: #form.firstname2#<br>
	  Middle Name: #form.middlename2#<br>
	  Email Address: #form.email2#<br>
      ----------------------------------------<br>
	  New employer information<br>
      ----------------------------------------<br>
      Company name: #form.company#<br>
	  Street address: #form.compaddress#<br>
      City: #form.compcity#<br>
	  State: #form.compstate#<br>
	  ZIP code: #form.compzip#<br>
	  Primary Contact: #form.compcontact#<br>
	  Phone Number: #form.comphone#<br>
	  Email Address: #form.compemail#<br>
      <br>
	  Attached File: #FileName#<br>
      ----------------------------------------<br>
	  New housing information<br>
      ----------------------------------------<br>
	  Street address in US: #form.housingaddress#<br>
      City: #form.housingcity#<br>
  	  State: #form.housingstate#<br>
  	  ZIP code: #form.housingzip#<br>
	  Phone Number: #form.housingphone#<br>

		          </td>
	        </tr>
      </table>
    </cfoutput>
  </cfif>
    <div align="center"><br>
      <strong>Thank you!</strong></div>
    </div></td>
          </tr>
        </table>	    <div align="center"><img src="images/back.gif" width="730" height="10"></div></td>
	</tr>
	<tr>
		<td height="42">
			<img src="images/blank_04.gif" alt="" width="770" height="42" border="0" usemap="#Map"></td>
	</tr>
</table>
<map name="Map">
  <area shape="rect" coords="511,20,703,32" href="mailto:contact@intoedventures.org">
</map>
</body>
</html>