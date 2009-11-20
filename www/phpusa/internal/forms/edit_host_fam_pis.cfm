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

<cfoutput>
<cfif isDefined('url.review')>
	<cfcookie name="review_host" value=#url.hostid#>
	<cfcookie name="review_student" value=#url.studentid#>
</cfif>
</cfoutput>

<cfinclude template="../querys/family_info.cfm">

<cfform method="post" action="querys/update_host_fam_pis.cfm">
<cfoutput query="family_info">
<input type="hidden" name=hostid value=#hostid#>
<h2>&nbsp;&nbsp;&nbsp;&nbsp;H o s t &nbsp;&nbsp;&nbsp; P a r e n t  &nbsp;&nbsp;&nbsp;  I n f o r m a t i o n <font size=-2>[ <cfoutput><a href="?curdoc=host_fam_info&hostid=#client.hostid#">overview</a></cfoutput> ] </font></h2>

<table width="90%" border=1 align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
	<tr><td width="80%" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="left">
			<Tr><td class="label">Family Name:</td><td colspan=3> <input type="text" name="familyname" size="20"  onBlur="javascript:lastname(this.form);" value="#familylastname#"></td></tr>
			<tr><td class="label">Address:</td><td colspan=3> <cfinput type="text" name="address" size="20" value="#address#"></td></tr>
			<tr><td class="label">Mailing Address:</td><td  colspan=3> <cfinput type="text" name="address2" size="20" value="#address2#"></td></tr>
			<tr><td class="label">City: </td><td  colspan=3><cfinput type="text" name="city" size="20" value="#city#"></td></tr>
			<tr><td class="label" > State: </td>
				<td width=10>
					<cfinclude template="../querys/states.cfm">
						<select name="state">
						<option>
						<cfloop query = states>
						<option value="#state#" <Cfif family_info.state is #state#>selected</cfif>>#State#</option>
						</cfloop>
						</select> Zip: <cfinput type="text" name="zip" size="5" value="#zip#" maxlength="5"></td></tr>
			<tr><td class="label">Phone:</td><td  colspan=3> <cfinput type="text" name="phone" size=12 value="#phone#"> nnn-nnn-nnnn</td></tr>
			<tr><td class="label">Email:</td><td  colspan=3> <cfinput type="text" name="email" size=20 value="#email#"></td></tr>
			<tr><td class="label">Fathers First Name:</td><td>  <cfinput type="text" name="fatherfirst" size="20" value="#fatherfirstname#"></td></tr>
			<tr><td class="label">Fathers Last Name:</td><td>  <cfinput type="text" name="fatherlast" size="20" value="#fatherlastname#"></td></tr>
			<tr><td class="label">Fathers Cell Phone:</td><td>  <cfinput type="text" name="fathercell" size="20" value="#father_cell#"></td></tr>
			<tr><td class="label">Year of Birth:</td><td>  <cfinput type="text" name="fatherdob" size="4" value="#fatherbirth#"> yyyy</td></tr>
					<tr><td class="label" valign="top">SSN:</td>
				<td colspan="3">
				<cfif cgi.SERVER_PORT EQ 443  or client.usertype lte 4>
					<cfif fatherssn EQ ''>
						<cfset DecryptedFatherSSN = fatherssn>
					<cfelse>
						<cfset DecryptedFatherSSN = decrypt(fatherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
					</cfif>		
					<cfinput type="text" name="fatherssn" size=10 value="#DecryptedFatherSSN#" maxlength="11" validate="social_security_number"> xxx-xx-xxxx
					<font size=-2><br>SSN is encrypted on unsecure connections, click <a href="http://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.</font>
				<cfelse>
					<cfif fatherssn EQ ''>
						<cfinput type="text" name="fatherssn" size=10 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Father SSN in the following format xxx-xx-xxxx"> xxx-xx-xxxx
					<cfelse>
						#fatherssn#
						<cfinput type="hidden" name="fatherssn" value="#fatherssn#">
					</cfif>
					<font size=-2><br>You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.</font>
				</cfif>
				</td>
			<tr><td class="label">Occupation:</td><td> <cfinput type="text" size=20 name="fatherocc" value="#fatherworktype#"></td></tr>
			<tr><td class="label">Mothers First Name:</span></td><td><span class="formw">  <cfinput type="text" name="motherfirst" size="20" value="#motherfirstname#"></span></td></tr>
			<Tr><td class="label">Mothers Last Name:</span></td><td><span class="formw">  <cfinput type="text" name="motherlast" size="20" value="#motherlastname#"></span></td></tr>
				<Tr><td class="label">Mothers Cell Phone:</span></td><td><span class="formw">  <cfinput type="text" name="mothercell" size="20" value="#mother_cell#"></span></td></tr>
			
			<Tr><td class="label">Year of Birth:</span></td><td><span class="formw">  <cfinput type="text" name="motherdob" size="4" value="#motherbirth#"> yyyy</span></td></tr>
			<tr><td class="label" valign="top">SSN:</td>
				<td colspan="3">
				<cfif cgi.SERVER_PORT EQ 443 or client.usertype lte 4>
					<cfif motherssn EQ ''>
						<cfset DecryptedMotherSSN = motherssn>
					<cfelse>
						<cfset DecryptedMotherSSN = decrypt(motherssn, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
					</cfif>									
					<cfinput type="text" name="motherssn" size=10 value="#DecryptedMotherSSN#" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Mother SSN in the following format xxx-xx-xxxx"> xxx-xx-xxxx
					<font size=-2><br>SSN is encrypted on unsecure connections, click <a href="http://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to view over unsecure.</font>
				<cfelse>
					<cfif motherssn EQ ''>
						<cfinput type="text" name="motherssn" size=10 value="" maxlength="11" validate="social_security_number" message="This is not a valid SSN. Please enter the Mother SSN in the following format xxx-xx-xxxx">  xxx-xx-xxxx
					<cfelse>
						#motherssn#
						<cfinput type="hidden" name="motherssn" value="#motherssn#"> 
					</cfif>
					<font size=-2><br>You must be using a secure connection to see SSN. Click <a href="https://#cgi.http_host#/#cgi.script_name#?#cgi.QUERY_STRING#">here</a> to decrypt SSN.</font>
				</cfif>
				</td>
			</tr>			
			
			<Tr><td class="label">Occupation:</span></td><td><span class="formw"> <cfinput type="text" size=20 name="motherocc" value="#motherworktype#"></span></td></tr>
			<Tr><td class="label">Emergency Contact Name:</span></td><td><span class="formw"> <cfinput type="text" size=20 name="emergency_contact_name" value="#emergency_contact_name#"></span></td></tr>
			<Tr><td class="label">Emergency Phone:</span></td><td><span class="formw"> <cfinput type="text" size=20 name="emergency_phone" value="#emergency_phone#"></span></td></tr>
		</table>
	</td>
	<td width="20%" align="right" valign="top" class="box">
		<table border=0 cellpadding=4 cellspacing=0 align="right">
			<tr><td align="right"><cfinclude template="../family_pis_menu.cfm"></td></tr>
		</table> 		
	</td>
	</tr>
</table>

<table width=50% border=0 align="center" cellpadding=4 cellspacing=0 class="section">
	<tr><td align="left">
			<div align="center">
			  <cfif client.usertype LTE '4'>
			      <a href="?curdoc=querys/delete_host&hostid=#hostid#" onClick="return areYouSure(this);"><img src="pics/delete-btn.gif" width="102" height="27" border="0" align="middle"></img></a>
		      </cfif>
		  </div></td>
		<td align="left">
	      <div align="center">
	        <input name="Submit" type="image" value="next" src="pics/next.gif" align="middle" width="74" height="29" border=0>
          </div></td></tr>
</table>

</cfoutput>
</cfform>
</body> 
</html>
