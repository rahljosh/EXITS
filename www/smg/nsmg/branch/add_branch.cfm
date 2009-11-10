<!DOCTYPE HTML PUBLIC "-//W3C//Dtd HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>New Branch</title>
</head>

<SCRIPT LANGUAGE="javascript">
<!--
function copy() {
   document.new_branch.username.value = '';
   document.new_branch.username.value = document.new_branch.email.value;
   document.new_branch.studentcontactemail.value = document.new_branch.email.value;
}
function CheckFields() {
var emailaddress = document.new_branch.email.value;
var emailFormat = /^\w(\.?[\w-])*@\w(\.?[\w-])*\.[a-zA-Z]{2,6}(\.[a-zA-Z]{2})?$/i;
var username = document.new_branch.username.value;

   if (document.new_branch.businessname.value == '') {
		  alert("Company Name is required. Please enter a company name.");
		  document.new_branch.businessname.focus();
		  return false;
   } else if (document.new_branch.email.value == '') {
		  alert("Email is required. Please enter an email address.");
		  document.new_branch.email.focus();
		  return false;
   } else if (document.new_branch.username.value == '') {
		  alert("Username is required. Please enter an username address.");
		  document.new_branch.username.focus();
		  return false;
   } else if (emailaddress.search(emailFormat) == -1) {
		alert("Please specify your email address in the following format: email@emailaddress.com");
		document.new_branch.email.focus();
		return false;
   } else if (username.length < 6) { 
		alert("Your username must contain at least 6 characters. Please retry.");
		document.new_branch.username.focus();
		return false;
   }
}
// -->	
</SCRIPT>

<body>

<cfquery name="get_agent_country" datasource="MySql">
	SELECT userid, country
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfinclude template="../querys/get_countries.cfm">

<cfform action="?curdoc=branch/qr_add_branch" name="new_branch" method="post" onSubmit="return CheckFields();">

<cfset temp = "temp">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">

<cfinput type="hidden" name="password" value="#temp_password#">
<cfinput type="hidden" name="intrepid" value="#get_agent_country.userid#">
<cfinput type="hidden" name="usertype" value="11">

<cfoutput>

<!--- header of the table --->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
<tr valign=middle height=24>
	<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
	<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
	<td background="pics/header_background.gif"><h2>Add New Branch </h2></td>
	<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>	
		<td width="130" align="right">Company Name:</td>
		<td align="left"><cfinput type="text" name="businessname" size="25"></td>
	</tr>
	<tr>	
		<td align="right">First Name:</td>
		<td align="left"><cfinput type="text" name="firstname" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Last Name:</td>
		<td align="left"><cfinput type="text" name="lastname" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Sex:</td>
		<td align="left"><cfinput type="radio" name="Sex" value="male"> Male <cfinput type="radio" name="Sex" value="female"> Female</td>
	</tr>
		<td align="right">Address:</td>
		<td align="left"><cfinput type="text" name="address" size="25"></td>
	</tr>
	<tr>	
		<td align="right"></td>
		<td align="left"><cfinput type="text" name="address2" size="25"></td>
	</tr>
	<tr>	
		<td align="right">City:</td>
		<td align="left"><cfinput type="text" name="city" size="25"></td>
	</tr>
	<tr>	
		<td align="right">State:</td>
		<td align="left"><cfinput type="text" name="state" size="25"></td>
	</tr>	
	<tr>	
		<td align="right">Country:</td>
		<td align="left">
			<cfselect name="country" required="yes" message="You must select a country">
				<option value="0">Country...</option>
				<cfloop query="get_countries">
					<option value="#countryid#" <cfif get_agent_country.country EQ countryid> selected </cfif>>#countryname#</option>
				</cfloop>
			</cfselect>
		</td>
	</tr>
	<tr>	
		<td align="right">Postal Code:</td>
		<td align="left"><cfinput type="text" name="zip" size="25"></td>
	</tr>
	<tr>	
		<td align="right">Phone:</td>
		<td align="left"><cfinput type="text" name="phone" size="25"></td>
	</tr>		
	<tr>	
		<td align="right">Fax:</td>
		<td align="left"><cfinput type="text" name="fax" size="25"></td>
	</tr>		
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>	
		<td width="130" align="right">Email:</td>
		<td align="left"><cfinput type="text" name="email" size="40" onchange="javascript:copy()" required="yes" message="You must enter an e-mail address"> &nbsp; <font size="-2" color="000066"><b>* Login Information will be sent to this e-mail.</b></font></td>
	</tr>
	<tr>	
		<td align="right">Username:</td>
		<td align="left"><cfinput type="text" name="username" size="40" required="yes" message="You must enter an e-mail address"> &nbsp; <font size="-2" color="000066"><b>* Defaults to email address, change if desire. </b></font></td>
	</tr>
	<tr>	
		<td width="130" align="right">Student Contact Email:</td>
		<td align="left"><cfinput type="text" name="studentcontactemail" size="40" required="yes" message="You must enter an e-mail address"> &nbsp; <font size="-2" color="000066"><b>* Email students will use to contact branch.</b></font></td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr>
		<td align="center"><input name="Submit" type="image" src="pics/submit.gif" border=0></td>
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