<script>
function areYouSure() { 
   if(confirm("You are about to delete this Host Family. You will not be able to recover this information. Click OK to continue")) { 
     form.submit(); 
        return true; 
   } else { 
        return false; 
   } 
} 
</script>

<cfquery name="user_compliance" datasource="caseusa">
	SELECT userid, compliance
	FROM smg_users
	WHERE userid = <cfqueryparam value="#client.userid#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>
<cfif isDefined('url.review')>
	<cfcookie name="review_host" value=#url.hostid#>
	<cfcookie name="review_student" value=#url.studentid#>
</cfif>
</cfoutput>

<cfinclude template="../querys/family_info.cfm">

<cfoutput query="family_info">

<cfform method="post" action="querys/update_host_fam_pis.cfm">
<cfinput type="hidden" name="hostid" value="#family_info.hostid#">

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/family.gif"></td>
		<td background="pics/header_background.gif"><h2>Host Parents Infomation</h2></td>
		<td align="right" background="pics/header_background.gif"><span class="edit_link">[ <a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a> ]</span></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><td width="70%">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<Tr><td class="label">Family Name:</td><td colspan=3> <input type="text" name="familyname" size="20"  onBlur="javascript:lastname(this.form);" value="#familylastname#"></td></tr>
			<tr><td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address" size="20" value="#address#"></td></tr>
			<tr><td class="label">Mailing Address:</td><td colspan=3> <cfinput type="text" name="address2" size="20" value="#address2#"></td></tr>
			<tr><td class="label">City:</td><td  colspan=3><cfinput type="text" name="city" size="20" value="#city#"></td></tr>
			<tr><td class="label" >State:</td>
				<td width=10>
					<cfinclude template="../querys/states.cfm">
						<select name="state">
						<cfloop query = states>
						<option value="#state#" <Cfif family_info.state is #state#>selected</cfif>>#State#</option>
						</cfloop>
						</select>
					</td>
				<td class="zip">Zip: </td>
				<td><cfinput type="text" name="zip" size="5" value="#zip#" maxlength="5"></td>
			</tr>
			<tr><td class="label">Phone:</td><td colspan=3> <cfinput type="text" name="phone" size=12 value="#phone#"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Email:</td><td colspan=3> <cfinput type="text" name="email" size=20 value="#email#"></td></tr>
			
			<tr><td class="label">Fathers First Name:</td><td colspan="3">  <cfinput type="text" name="fatherfirst" size="20" value="#fatherfirstname#"></td></tr>
			<tr><td class="label">Fathers Middle Name:</td><td colspan="3">  <cfinput type="text" name="fathermiddle" size="20" value="#fathermiddlename#"></td></tr>
			<tr><td class="label">Fathers Last Name:</td><td colspan="3">  <cfinput type="text" name="fatherlast" size="20" value="#fatherlastname#"></td></tr>
			<tr><td class="label">Year of Birth:</td><td colspan="3">  <cfinput type="text" name="fatherbirth" size="4" value="#fatherbirth#"> yyyy</td></tr>
			<tr><td class="label">Date of Birth:</td><td colspan="3">  <cfinput type="text" name="fatherdob" size="8" value="#DateFormat(fatherdob, 'mm/dd/yyyy')#" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>
			<tr><td class="label" valign="top">SSN:</td>
				<td colspan="3">
				<cfif cgi.SERVER_PORT EQ 443 or client.userid eq 5 or client.userid eq 1 or client.userid eq 12522>
					<cfif fatherssn EQ ''>
						<cfset DecryptedFatherSSN = fatherssn>
					<cfelse>
						<cfset DecryptedFatherSSN = decrypt(fatherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
					</cfif>		
					<cfinput type="text" name="fatherssn" size=10 value="#DecryptedFatherSSN#" maxlength="11" validate="social_security_number"> xxx-xx-xxxx
		  			<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
					<font size=-2><br>SSN is encrypted on secure connection, click <a href="http://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.</font>
					</cfif>
				<cfelse>
					<cfif fatherssn EQ ''>
						<cfinput type="text" name="fatherssn" size=10 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Father SSN in the following format xxx-xx-xxxx"> xxx-xx-xxxx
					<cfelse>
						#fatherssn#
						<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
						<font size=-2><br>You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.</font>
						</cfif>
					</cfif>
				</cfif>
				</td>
			</tr>	
			<tr><td class="label">Occupation:</td><td colspan="3"><cfinput type="text" size=20 name="fatherocc" value="#fatherworktype#"></td></tr>
			
			<tr><td class="label">Mothers First Name:</span></td><td colspan="3"><span class="formw">  <cfinput type="text" name="motherfirst" size="20" value="#motherfirstname#"></span></td></tr>
			<Tr><td class="label">Mothers Middle Name:</span></td><td colspan="3"><span class="formw">  <cfinput type="text" name="mothermiddle" size="20" value="#mothermiddlename#"></span></td></tr>			
			<Tr><td class="label">Mothers Last Name:</span></td><td colspan="3"><span class="formw">  <cfinput type="text" name="motherlast" size="20" value="#motherlastname#"></span></td></tr>
			<Tr><td class="label">Year of Birth:</span></td><td colspan="3"><span class="formw">  <cfinput type="text" name="motherbirth" size="4" value="#motherbirth#"> yyyy</span></td></tr>
			<tr><td class="label">Date of Birth:</td><td colspan="3"><cfinput type="text" name="motherdob" size="8" value="#DateFormat(motherdob, 'mm/dd/yyyy')#" validate="date" maxlength="10"> mm/dd/yyyy</td></tr>	
			<tr><td class="label" valign="top">SSN:</td>
				<td colspan="3">
				<cfif cgi.SERVER_PORT EQ 443 or client.userid eq 5 or client.userid eq 1 or client.userid eq 12522>
					<cfif motherssn EQ ''>
						<cfset DecryptedMotherSSN = motherssn>
					<cfelse>
						<cfset DecryptedMotherSSN = decrypt(motherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
					</cfif>									
					<cfinput type="text" name="motherssn" size=10 value="#DecryptedMotherSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Mother SSN in the following format xxx-xx-xxxx"> xxx-xx-xxxx
					<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
					<font size=-2><br>SSN is encrypted on secure connections, click <a href="http://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.</font>
					</cfif>
				<cfelse>
					<cfif motherssn EQ ''>
						<cfinput type="text" name="motherssn" size=10 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Mother SSN in the following format xxx-xx-xxxx">  xxx-xx-xxxx
					<cfelse>
						#motherssn#
						<cfif client.usertype EQ '1' OR user_compliance.compliance EQ '1'> <!--- ONLY ADMINISTRATORS HAVE ACCESS TO IT --->
						<font size=-2><br>You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.</font>
						</cfif>
					</cfif>
				</cfif>
				</td>
			</tr>			
			<Tr><td class="label">Occupation:</span></td><td colspan="3"><span class="formw"> <cfinput type="text" size=20 name="motherocc" value="#motherworktype#"></span></td></tr>
		</table>
	</td>
	<td width="30%" align="right" valign="top">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="left">
			<cfif client.usertype LTE '4'>
				<a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/delete.gif" border="0" align="middle"></img></a>
			</cfif></td>
		<td align="left"><input name="Submit" type="image" src="pics/update.gif" align="left" border=0></td>
	</tr>
</table>

<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign=bottom >
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>
</cfform>

</cfoutput>
</body> 
</html>
