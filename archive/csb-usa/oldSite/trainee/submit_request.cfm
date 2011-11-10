<html>
<head>
<title>:: CSB International : Employers ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table width="871" height="435" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="131" background="images/top.jpg"><table width="99%" border="0">
		  <tr>
		    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
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
		    <td width="90%" valign="bottom" class="top"><p><a href="index.cfm" class="LinkItens">Home</a> &gt; Check In</p></td>
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
  
	<cfif url.request is 'checkin'>
		<cfset desc = 'TRAINEE - CHECK-IN / VALIDATION'>
		<cfelse>
		<cfset desc= 'TRAINEE- CHANGE OF HOST COMPANY/ADDRESS'>
	</cfif>
  
 
  <cfif url.request is 'checkin'>
    <cfmail from="#APPLICATION.EMAIL.TRAINEE.from#" to="#APPLICATION.EMAIL.TRAINEE.contact#" subject="#form.lastname#, #form.firstname#  - Validation">

      #desc# from the CSB web site on #dateformat(Now())#.
      
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
    
     <strong>The following information has been succesfully submitted to CSB International.</strong><br><cfoutput>
     	<table width=90% align="center">
	      <tr>
		        <td class="text">
                  <p>SEVIS Number: #form.sevis#<br>
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
                    Comments: #form.comment#</p></td>
	        </tr>
      </table>
    </cfoutput>
	
    <Cfelse>
    
    <cfmail from="#APPLICATION.EMAIL.TRAINEE.from#" to="#APPLICATION.EMAIL.TRAINEE.contact#" subject="#form.lastname2#, #form.firstname2#  - Validation">
	<cfif form.UploadFile NEQ ''>
    	<cffile action="upload" fileField="UploadFile" destination="/var/www/html/intoedventures/uploaded/job-offers/" nameConflict="overwrite" mode="777">
		<cfmailparam file="#CFFILE.ServerDirectory#/#CFFILE.ServerFile#">
		<cfset FileName = file.ServerFileName>
    <cfelse>
		<cfset FileName = "No File Attached!">
	</cfif>
	
      #desc# from the CSB web site on #dateformat(Now())#.
      
		Last Name: #form.lastname2#
		First Name: #form.firstname2#
		Middle Name: #form.middlename2#
		Email Address: #form.email2#
		----------------------------------------
		New Host Company information
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
    
     <strong>The following information has been succesfully submitted to CSB International.</strong></div>
              <cfoutput><br>
      <table width=90% align="center">
	      <tr>
		        <td class="text">	  Last Name: #form.lastname2#<br>
  	  First Name: #form.firstname2#<br>
	  Middle Name: #form.middlename2#<br>
	  Email Address: #form.email2#<br>
      ----------------------------------------<br>
	  New Host Company information<br>
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