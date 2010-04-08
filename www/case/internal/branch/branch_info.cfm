<!DOCTYPE HTML PUBLIC "-//W3C//Dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Branch Information</title>
</head>

<SCRIPT LANGUAGE="javascript">
<!--
function copy() {
   document.new_branch.username.value = '';
   document.new_branch.username.value = document.new_branch.email.value;
}
function CheckFields() {
var emailaddress=document.new_branch.email.value;
var emailFormat = /^\w(\.?[\w-])*@\w(\.?[\w-])*\.[a-zA-Z]{2,6}(\.[a-zA-Z]{2})?$/i;
var username=document.new_branch.username.value;
var password=document.new_branch.password.value;
   if (document.new_branch.businessname.value == '') {
		  alert("Company Name is required. Please enter a company name.");
		  document.new_branch.businessname.focus();
		  return false;
   } else if (document.new_branch.email.value == '') {
		  alert("Email is required. Please enter an email address.");
		  document.new_branch.email.focus();
		  return false;
   } else if (document.new_branch.username.value == '') {
		  alert("Username is required. Please enter an username.");
		  document.new_branch.username.focus();
		  return false;
   } else if (document.new_branch.password.value == '') {
		  alert("Password is required. Please enter a password.");
		  document.new_branch.password.focus();
		  return false;
   } else if (emailaddress.search(emailFormat) == -1) {
		alert("Please specify your email address in the following format: email@emailaddress.com");
		return false;
   }  else if (username.length < 6) { 
		alert("Your username must contain at least 6 characters. Please retry.");
		document.new_branch.username.focus();
		return false;
   } else if (password.length < 6 || password.length > 10) { 
		alert("Your password must contain 6-10 characters. Please retry.");
		document.new_branch.email.focus();
		return false;
   }
}
// -->	
</SCRIPT>

<body>

<cfif not IsDefined('url.branchid')>
	<cfinclude template="../forms/error_message.cfm">
	<cfabort>
</cfif>

<cfquery name="get_branch" datasource="caseusa">
	SELECT *
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.branchid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfif client.usertype EQ '8' AND client.userid NEQ get_branch.intrepid and url.m eq 0>
	<cfinclude template="../forms/error_message.cfm">
	<cfabort>
</cfif>

<cfif client.usertype EQ '11' AND client.userid NEQ url.branchid and url.m eq 0>
	<cfinclude template="../forms/error_message.cfm">
	<cfabort>
</cfif>

<cfinclude template="../querys/get_countries.cfm">

<cfform action="?curdoc=branch/qr_branch_info" name="new_branch" method="post" onSubmit="return CheckFields();">
<cfinput type="hidden" name="branchid" value="#get_branch.userid#">

<cfoutput query="get_branch">

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Branch Information</h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>	
		<td width="130" align="right">Company Name:</td>
		<td align="left"><cfinput type="text" name="businessname" value="#businessname#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">First Name:</td>
		<td align="left"><cfinput type="text" name="firstname" value="#firstname#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Last Name:</td>
		<td align="left"><cfinput type="text" name="lastname" value="#lastname#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Sex:</td>
		<td align="left">
			<cfif sex EQ 'male'> <cfinput type="radio" name="Sex" value="male" checked="yes"> <cfelse> <cfinput type="radio" name="Sex" value="male"> </cfif> Male 
			<cfif sex EQ 'female'> <cfinput type="radio" name="Sex" value="female" checked="yes"> <cfelse> <cfinput type="radio" name="Sex" value="female"> </cfif> Female 
		</td>
	</tr>
		<td align="right">Address:</td>
		<td align="left"><cfinput type="text" name="address" value="#address#" size="25"></td>
	</tr>
	<tr>	
		<td align="right"></td>
		<td align="left"><cfinput type="text" name="address2" value="#address2#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">City:</td>
		<td align="left"><cfinput type="text" name="city" value="#city#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">State:</td>
		<td align="left"><cfinput type="text" name="state" value="#state#" size="25"></td>
	</tr>	
	<tr>	
		<td align="right">Country:</td>
		<td align="left">
			<cfselect name="country" required="yes" message="You must select a country">
				<option value="0">Country...</option>
				<cfloop query="get_countries">
					<option value="#countryid#" <cfif get_branch.country EQ countryid> selected </cfif>>#countryname#</option>
				</cfloop>
			</cfselect>
		</td>
	</tr>
	<tr>	
		<td align="right">Postal Code:</td>
		<td align="left"><cfinput type="text" name="zip" value="#zip#" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Phone:</td>
		<td align="left"><cfinput type="text" name="phone" value="#phone#" size="25"></td>
	</tr>		
	<tr>	
		<td align="right">Fax:</td>
		<td align="left"><cfinput type="text" name="fax" value="#fax#" size="25"></td>
	</tr>		
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>	
		<td width="130" align="right">Email:</td>
		<td align="left"><cfinput type="text" name="email" value="#email#" size="40" onchange="javascript:copy()" required="yes" message="Email is required."></td>
	</tr>

	<tr>
		<td align="right">Username:</td>
		<td align="left"><cfinput type="text" name="username" value="#username#" size="40" required="yes" message="Username is required."> &nbsp; <font size="-2" color="000066"><b>* Defaults to email address, change if desire. - Min 6 characters. </b></font></td>
	</tr>
		<tr>	
		<td width="130" align="right">Student Contact Email:</td>
		<td align="left"><cfinput type="text" name="studentcontactemail" value="#studentcontactemail#" size="40" required="yes" message="Email is required."></td>
	</tr>
	<tr>	
		<td align="right">Password:</td>
		<td align="left"><cfinput type="text" name="password" value="#password#" size="20" maxlength="10" required="yes" message="Password is required.">  &nbsp; <font size="-2" color="000066"><b>* Min 6 Max 10 characters. </b></font></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><font size=-2><a href="?curdoc=branch/resend_login&branchid=#userid#"><img src="pics/email.gif" border=0 align="left"> Resend Login Info Email</A><cfif isDefined('url.sent')><font color="red"> - Sent</font></cfif></td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="center"><input name="Submit" type="image" src="pics/update.gif" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfoutput>

</cfform>

</body>
</html>