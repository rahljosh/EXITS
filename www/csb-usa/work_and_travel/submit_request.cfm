<html>
<head>
<title>:: CSB International : Emplyers ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../style.css" rel="stylesheet" type="text/css">
<script>
function test(){
	with (document.form) {
		if (firstname.value == '') {
			alert("FIRST NAME is Required");
			firstname.focus();
			return false;
		}
		if (lastname.value == '') {
			alert("LAST NAME is Required");
			lastname.focus();
			return false;
		}
		if (email.value == '') {
			alert("EMAIL is Required");
			email.focus();
			return false;
		}
		if (street.value == '') {
			alert("STREET ADDRESS is Required");
			street.focus();
			return false;
		}
		if (city.value == '') {
			alert("CITY is Required");
			city.focus();
			return false;
		}
		if (state.value == '') {
			alert("STATE is Required");
			state.focus();
			return false;
		}
		if (zip.value == '') {
			alert("ZIP CODE is Required");
			zip.focus();
			return false;
		}
	}
}

function testChangeAdrress(){
	with (document.formChangeAdrress) {
		if (firstname2.value == '') {
			alert("FIRST NAME is Required");
			firstname2.focus();
			return false;
		}
		if (lastname2.value == '') {
			alert("LAST NAME is Required");
			lastname2.focus();
			return false;
		}
		if (email2.value == '') {
			alert("EMAIL is Required");
			email2.focus();
			return false;
		}
		if (company.value == '') {
			alert("COMPANY is Required");
			company.focus();
			return false;
		}
		if (compaddress.value == '') {
			alert("COMPANY'S STREET ADDRESS is Required");
			compaddress.focus();
			return false;
		}
		if (compcity.value == '') {
			alert("COMPANY'S CITY is Required");
			compcity.focus();
			return false;
		}
		if (compstate.value == '') {
			alert("COMPANY'S STATE is Required");
			compstate.focus();
			return false;
		}
		if (compzip.value == '') {
			alert("COMPANY'S ZIP CODE is Required");
			compzip.focus();
			return false;
		}
		if (compcontact.value == '') {
			alert("COMPANY'S PRIMARY CONTACT is Required");
			compcontact.focus();
			return false;
		}
		if (comphone.value == '') {
			alert("COMPANY'S PHONE NUMBER is Required");
			comphone.focus();
			return false;
		}
		if (housingaddress.value == '') {
			alert("HOUSING ADDRESS is Required");
			housingaddress.focus();
			return false;
		}
		if (housingcity.value == '') {
			alert("HOUSING CITY is Required");
			housingcity.focus();
			return false;
		}
		if (housingstate.value == '') {
			alert("HOUSING STATE is Required");
			housingstate.focus();
			return false;
		}
		if (housingzip.value == '') {
			alert("HOUSING ZIP CODE is Required");
			housingzip.focus();
			return false;
		}
	}
}


</script>

</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

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
		<cfset desc = 'SUMMER WORK & TRAVEL - CHECK-IN / VALIDATION'>
		<cfelse>
		<cfset desc= 'SUMMER WORK & TRAVEL - CHANGE OF EMPLOYER/ADDRESS'>
	</cfif>
  
 
  <cfif url.request is 'checkin'>
    <cfmail to="anca@intoedventures.org" from="into@intoedventures.org" subject="#form.lastname#, #form.firstname#  - Validation">

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
    
     <strong>The following information has been succesfully submitted to IntoEdVentures.</strong><br><cfoutput>
                  <table width=90% align="center">
	      <tr>
		        <td class="text">
                  <p>Student ID Number: #form.idnumber#<br>
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
                    ------------------------------------------<br>
                    Employer Information<br>
                    ------------------------------------------
                    <br>
                  Company name: #form.companyName#<br>
                  Street Address: #form.companyStreet#<br>
                  City: #form.CompanyCity#<br>
                  State: #form.companyState#<br>
                  Zip: #form.companyZip#<br>
                  Primary Contact/Supervisor: #form.companyContact#<br>
                  Phone Number: #form.companyPhone#<br>
                  <br>
                    <br>
                    Comments: #form.comment#</p></td>
	        </tr>
      </table>
    </cfoutput>
	
    <Cfelse>
    
    <cfmail to="anca@intoedventures.org" from="into@intoedventures.org" subject="#form.lastname2#, #form.firstname2#  - Validation">
	<cfif form.UploadFile NEQ ''>
    	<cffile action="upload" fileField="UploadFile" destination="/var/www/html/intoedventures/uploaded/job-offers/" nameConflict="overwrite" mode="777">
		<cfmailparam file="#CFFILE.ServerDirectory#/#CFFILE.ServerFile#">
		<cfset FileName = file.ServerFileName>
    <cfelse>
		<cfset FileName = "No File Attached!">
	</cfif>
	
      #desc# from the INTO web site on #dateformat(Now())#.
      
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
    
     <strong>The following information has been succesfully submitted to IntoEdVentures.</strong></div>
              <cfoutput><br>
      <table width=90% align="center">
	      <tr>
		        <td class="text">
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