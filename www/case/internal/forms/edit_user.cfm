<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Information</title>
</head>

<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function CheckDates(ckname, frname) {
	if (document.form.elements[ckname].checked) {
		document.form.elements[frname].value = '#DateFormat(now(), 'mm/dd/yyyy')#';
		}
	else { 
		document.form.elements[frname].value = '';  
	}
}
//  End -->
</script>
</cfoutput>

<!--- CHECK RIGHTS --->
<cfinclude template="../check_rights.cfm">

<cfquery name="rep_info" datasource="caseusa">
select *
from smg_users
where userid = #url.userid#
</cfquery>

<cfquery name="country_list" datasource="caseusa">
select countryname, countryid
from smg_countrylist
ORDER BY countryname
</cfquery>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<Cfquery name="default_company" datasource="caseusa">
	SELECT DISTINCT uar.companyid, 
		   c.companyshort
	FROM user_access_rights uar
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	WHERE uar.userid = '#url.userid#'
	ORDER BY c.companyshort
</Cfquery>

<title>User Information</title>

<cfform action="?curdoc=querys/update_user" name="form" method="post">

<cfoutput query="rep_info">

<cfset temp = "temp">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">
<input type="hidden" name=temp_password value='#temp_password#'>
<input type="hidden" value=#usertype# name="usertype">
<cfset decryptedssn = ''>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Edit User Account Information </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<div class="section">

<table width=90%>
	<tr>
		<td width=50%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Personal Information</u></td><td width=50%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Contact Info</u></td>
	</tr>
	<tr>
		<td valign="top" border=0>
			<table>
				<tr><td align="right">First: </td><td><input type="text" name="firstname" value='#firstname#'></td></tr>
				<tr><td align="right">Middle:</td><Td> <input type="text" name="middlename" value="#middlename#"></Td></tr>
				<tr><td align="right">Last:</td><Td> <input type="text" name="lastname" value="#lastname#"></Td></tr>
				<cfif usertype EQ 8>
				<tr><td align="right">Business Name:</td><td><input type="text" value="#businessname#" name="businessname"></td></tr>
				</cfif>
				<tr><td align="right">Address:</td><td><input type="text" name="address" value="#address#"></td></tr>
				<tr><td align="right"></td><td><input type="text" name="address2" value="#address2#"></td></tr>
				<tr><td align="right">City:</td><td><input type="text" name="city" value="#city#"></td></tr>
				<tr>
				<cfif usertype EQ 8>
					<td align="right">Country:</td>
					<td><cfselect name="country">
						<option value="0">Country...</option>
						<cfloop query="country_list">
						<option value="#countryid#" <cfif rep_info.country is #countryid#>selected</cfif>>#countryname#</option>
						</cfloop>
						</cfselect>
					</td>
				<cfelse>
					<td align="right">State:</td><td><input name="state" type="text" value="#state#"></td>
				</cfif>
				</tr>
				<tr><td align="right">Postal Code (Zip):</td><td><input name="zip" type="text" value="#zip#" size="10" maxlength="10"></td></tr>
				<tr>
					<td align="right">Drivers License:</td><td><input type="text" name="drivers_license" value="#drivers_license#"></td>
				</tr>
				<tr>
					<td align="right">Birthdate:</td><td><input type="text" name="dob" value="#DateFormat(dob,'mm/dd/yyyy')#"> mm/dd/yyyy</td>
				</tr>
				<cfif client.usertype NEQ '8' AND client.usertype NEQ '11' AND (client.usertype LTE 4 OR client.userid eq rep_info.userid)>
					<cfif #len(ssn)# lte 8>
						social is stored incorrectly, please contact support.
					<cfelse>
						<cfif cgi.SERVER_PORT eq 443 and ssn NEQ '' OR user_compliance.compliance EQ 1 or client.userid eq 5 or client.userid eq 1 or client.userid eq 12522> <!--- SKIP SSL --->
								<cfset key='BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
								<cfset decryptedssn = decrypt(ssn, key, "desede", "hex")>
						<cfelse>
								<cfset decryptedssn = #ssn#>
								
						</cfif>
					</cfif>
					<tr><td align="right" valign="top">Social:</td><td>
					
					<cfif cgi.SERVER_PORT eq 443 and ssn NEQ '' OR user_compliance.compliance EQ 1 or client.userid eq 5 or client.userid eq 1 or client.userid eq 12522><input type="text" name="ssn" value="#decryptedssn#"></cfif>
					
					<cfif cgi.SERVER_PORT neq 443 AND client.userid NEQ 7657 AND client.userid NEQ 10459 AND client.userid NEQ 9719>#decryptedssn#<cfelse><input type="text" name="ssn" value="#decryptedssn#"></cfif><br>
						<font size=-2>
						<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
							<cfif cgi.SERVER_PORT eq 443>
								SSN is encrypted on secure connections, click <a href="http://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.
							<cfelse>							
								You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.
							</cfif>
						</cfif>
						</font>
						</td>
					</tr>
				</cfif>
			</table>
		</td>
		<td valign="top">
			<table border="0" width="100%">
			  	<tr>
					<td align="right"> Home Phone:</td>
					<td><input type="text" value="#phone#" name="phone"></td>
				</tr>
				  	<tr>
					<td align="right"> Work Phone:</td>
					<td><input type="text" value="#work_phone#" name="work_phone"></td>
				</tr>
				  	<tr>
					<td align="right"> Cell Phone:</td>
					<td><input type="text" value="#cell_phone#" name="cell_phone"></td>
				</tr>
				<tr>
					<td align="right">Fax:</td>
					<td><input type="text" value="#fax#" name="fax"></td>
				</tr>
				<tr>
					<td align="right">Email:</td>
					<td><input type="text" value="#email#" name="email" size="30"></td>
				</tr>
				<tr>
					<td align="right">Alt. Email:</td>
					<td><input type="text" name="email2" value="#email2#" size="30"></td>
				</tr>
				<tr><td colspan=2 bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Login Information</u></td></tr>
				<tr><td align="right">Username:</td><td><cfif rep_info.userid EQ 9401 and client.userid NEQ 9401>****<cfelseif client.usertype is 1 or client.usertype lt #rep_info.usertype# or client.userid eq rep_info.userid><input type="text" value="#username#" name="username" size="30"><cfelse>**********</cfif></td></tr>
				<tr><td align="right">Password:</td><td><cfif rep_info.userid EQ 9401 and client.userid NEQ 9401>****<cfelseif client.usertype is 1 or client.usertype lt #rep_info.usertype# or client.userid eq rep_info.userid><input type="text" value="#password#" name="password" maxlength="10" size="30"><cfelse>**********</cfif></td></tr>
				<cfif rep_info.usertype NEQ 8>
				<tr><td align="right">Default Company:</td>
					<td><select name="defaultcompany">
						<cfloop query="default_company">
						<option value="#companyid#" <cfif rep_info.defaultcompany EQ companyid>selected</cfif>>#companyshort#</option>
						</cfloop>
						</select>
					</td>
				</tr>
				</cfif>
				<tr><td colspan=2>
					<cfif client.usertype lt 4>
						<cfif rep_info.changepass eq 1>
							<span class="get_attention"<font size=-2>User will be required to change pass on next log in.</span>
						<cfelse>
							<input type="checkbox" name="changepass" value=1><font size=-2>Force user to change password on next login.</font><br>
						</cfif>
						<cfif client.usertype eq 1><input type=checkbox name="invoiceaccess" <cfif invoice_access eq 1>checked</cfif>><font size=-2>User has invoice access</cfif>
					</cfif>
				</td></tr>
			</table>
		</td>
	</tr>
</table>

<!----Billing Inforamtion for Int. Reps---->
<cfif rep_info.usertype eq 8>

<SCRIPT LANGUAGE="JavaScript">
<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Begin -->
function CopyContact() {
	if (document.form.elements.copycontact.checked) {
	document.form.elements.billing_company.value = '#rep_info.billing_company#';
	document.form.elements.billing_contact.value = '#rep_info.firstname# #rep_info.lastname#';
	document.form.elements.billing_address.value =  '#rep_info.address#';
	document.form.elements.billing_address2.value = '#rep_info.address2#';
	document.form.elements.billing_city.value = '#rep_info.city#';      
	document.form.elements.billing_country.value = '#rep_info.country#';
	document.form.elements.billing_zip.value =  '#rep_info.zip#'; 
	document.form.elements.billing_phone.value =  '#rep_info.phone#';
	document.form.elements.billing_fax.value = '#rep_info.fax#';
	document.form.elements.billing_email.value = '#rep_info.email#';
	}
	else {
	document.form.elements.billing_company.value = '';
	document.form.elements.billing_contact.value = '';
	document.form.elements.billing_address.value =  '';
	document.form.elements.billing_address2.value = '';
	document.form.elements.billing_city.value = '';      
	document.form.elements.billing_country.value = '';
	document.form.elements.billing_zip.value =  ''; 
	document.form.elements.billing_phone.value =  '';
	document.form.elements.billing_fax.value = '';
	document.form.elements.billing_email.value = '';
   }
}
//  End -->
</script>


	<table width=90%>
	<tr>
		<td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Billing Info Info</u> <input type="checkbox" name="copycontact" OnClick="CopyContact();" value="checkbox">Copy personal information: </td><td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Contract Info</u></td>
	</tr>
		<td valign="top">
			<table border="0">
			<Tr>
				<td colspan=2><input type="checkbox" name="usebilling" <cfif usebilling eq 1>checked</cfif>>Use billing address on invoice</td>
			</Tr>
			  <tr>
				<td align="right">Company Name:</td>
				<td> <input type="text" value="#billing_company#" name="billing_company"> </td>
			  </tr>
				<tr>
				<td align="right">Contact:</td>
				<td> <input type="text" value="#billing_contact#" name="billing_contact"> </td>
			  </tr>
			  <tr>
				<td align="right">Address:</td>
				<td><input type="text" value="#billing_address#" name="billing_address"></td>
			  </tr>
				<tr>
				<td align="right"></td>
				<td><input type="text" value="#billing_address2#" name="billing_address2"></td>
			  </tr>
			  <tr>
				<td align="right">City:</td>
				<td> <input type="text" value="#billing_city#" name="billing_city"></td>
			  </tr>
			  <tr>				  
				<td align="right">Country:</td>
				<td><cfselect name="billing_country">
					<option value="0">Country...</option>
					<cfloop query="country_list">
					<option value="#countryid#" <cfif rep_info.billing_country is #countryid#>selected</cfif>>#countryname#</option>
					</cfloop>
					</cfselect>
				</td>
				</tr>
			  <tr><td align="right"> Zip:</td><td><input name="billing_zip" type="text" value="#billing_zip#" size="5" maxlength="6"></td></tr>
			<tr><td align="right">Phone:</td><td><input type="text" name="billing_phone" value="#billing_phone#" size=15></td></tr>
		
			  <tr><td align="right">Fax:</td><td><input type="text" name="billing_fax" value="#billing_fax#" size=15></td></tr>
			  <tr><td align="right">Email:</td><td><input type="text" name="billing_email" value="#billing_email#" size=32><br>
			  </td></tr
		><tr>
			</table>
		<td valign="top">
				<table border="0">
			  <tr>
				<td align="right">User Entered:</td>
				<td> #DateFormat(datecreated, 'mm/dd/yyyy')#</td>
			  </tr>
			  <tr>
				<td align="right">Contract Rec.:</td>
				<td>
				<cfif client.usertype GT '4'>#date_contract_received#<cfelse><input type="text" value="#date_Contract_received#" name="date_Contract_received"></cfif></td>
			  </tr>
			  <tr>
				<td align="right">Active:</td>
				<td><cfif #active# is 1><input name="active" type="radio" <cfif client.usertype GT '4'>disabled="true"</cfif> value=1 checked>yes <input type="radio" name="active"  <cfif client.usertype GT '4'>disabled="true"</cfif> value=0>no<cfelse><input type="radio" name="active"  <cfif listfindnocase("5,6,7,8", #client.usertype#)>disabled</cfif> value=1>yes <input type="radio" name="active"  <cfif listfindnocase("5,6,7,8", #client.usertype#)>disabled</cfif> value=0 checked>no </cfif></td>
			  </tr> 
			  <tr>
				<td>Date Cancelled:</td><td>

				#datecancelled#</td>
			  </tr>
			</table>
		</tr>
</table>
<cfelse>

<br><br>


<table width=90%>
	<tr>
		<td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Employment Info</u></td><td width=33%  bgcolor="CCCCCC"><span class="get_attention"><b>></b></span><u>Contract Info</u></td>
	</tr>
		<td valign="top">
			<table border="0">
			  <tr>
				<td align="right">Occupation:</td>
				<td> <input type="text" value="#occupation#" name="occupation"> </td>
			  </tr>
			  <tr>
				<td align="right">Employer:</td>
				<td><input type="text" value="#businessname#" name="businessname"></td>
			  </tr>
			  <tr>
				<td align="right">Work Phone:</td>
				<td> <input type="text" value="#businessphone#" name="businessphone"></td>
			  </tr>
			</table>
		<td valign="top">
				<table border="0">
			  <tr>
				<td align="right">User Entered:</td>
				<td> #DateFormat(datecreated, 'mm/dd/yyyy')#</td>
			  </tr>
			  <tr>
				<td align="right">Contract Rec.:</td>
				<td>
				<cfif client.usertype GT '4'>#date_contract_received#<cfelse><input type="text" value="#date_Contract_received#" name="date_Contract_received"></cfif></td>
			  </tr>
			  <tr>
				<td align="right">Active:</td>
				<td><cfif #active# is 1><input name="active" type="radio" <cfif listfindnocase("5,6,7", #client.usertype#)>disabled="true"</cfif> value=1 checked>yes <input type="radio" name="active"  <cfif listfindnocase("5,6,7", #client.usertype#)>disabled="true"</cfif> value=0>no<cfelse><input type="radio" name="active"  <cfif listfindnocase("5,6,7", #client.usertype#)>disabled="true"</cfif> value=1>yes <input type="radio" name="active"  <cfif listfindnocase("5,6,7", #client.usertype#)>disabled="true"</cfif> value=0 checked>no </cfif></td>
			  </tr>
			  <tr>
			  	<td>Date Cancelled:</td><td>
				#datecancelled#</td>
			  </tr>
			</table>
		</tr>
</table>
</cfif>
</cfoutput>

<table width=100%>
<cfif client.usertype lt 5>
<Cfoutput query="rep_info"><br>
<Table width=90%>
	<tr bgcolor="CCCCCC">
		<td><span class="get_attention"><b>></b></span><u>Notes / Misc Info</u></td>
	</tr>
	<tr>
		<td>
		<cfif client.usertype lt #rep_info.usertype# or client.usertype is 1 or client.usertype is 2 or client.usertype is 3 or client.usertype is 4 >
			<cfif comments EQ ''>
				<textarea cols="45" rows="10" name="comments">No additional information available.</textarea>
			<cfelse>
				<textarea cols="45" rows="10" name="comments">#comments#</textarea>
			</cfif>
		</cfif>
<br>
<!--- <cfif client.usertype lte 1><input type="checkbox" name="delete" value=#url.userid# <cfif #url.userid# is 1>disabled</cfif>> Delete User Account - You can not undelete accounts.</cfif>
 ---><!----
<cfif client.usertype lte 5>><input type="checkbox" name="delete" value=#url.userid# <cfif #url.userid# is 1>disabled</cfif>> Deactivate User Account </cfif>
---->
</td>
	</tr>

		</cfoutput>
</cfif>
	<tr>
		<td colspan=5>
<cfoutput>
<input type="hidden" name="userid" value="#userid#"></cfoutput>
<div class="button"><input name="Submit" type="image" src="pics/update.gif" align="right" border=0></div>
</cfform>
		</td>
	</tr>

</table>



</div>

<cfinclude template="../table_footer.cfm">