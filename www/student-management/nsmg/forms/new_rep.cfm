

<cfset temp = "ise">
<cfset temp_password = "#temp##RandRange(100000, 999999)#">
<cfoutput>
<cfform action="../querys/insert_rep_info.cfm" method="POST">

<div class="form_section_title"><h3>Personal Information</h3></div>
<table>
	<tr>	
		<td align="right">First Name:</td><Td align="left"> <cfinput type=text name="rep_first_name" size=20></td>
	</tr>
	<Tr>
		<td align="right">Last Name: </td><td align="left"><cfinput type=text name="rep_last_name" size=20></td>
	</tr>
	<tr>
		<td align="right">Address:</td><td align="left"><cfinput type=text name=address1 size=30></td>
	</tr>
	<tr>
		<td align="right"></td><td align="left"><cfinput type=text name=address2 size=30></td>
	</tr>
	<tr>
		<td align="right">City:</td><td align="left"><cfinput type=text name=city size=15> State: <cfinput type="text" size=2 name=state>
    Zip: <cfinput type="text" name="zip" size=5></td>
	</tr>
	<Tr>
		<td align="right">Social Security: </td><td align="left"><cfinput type=text name="social" size=9> (no spaces or dashes)</td>
	</tr>

	<tr>	
		<td align="right">Occupation:</td><Td align="left"> <cfinput type=text name="occupation" size=20></td>
	</tr>
	<Tr>
		<td align="right">Company Name: </td><td align="left"><cfinput type=text name="business_name" size=20></td>
	</tr>

	
</table>

<div class="form_section_title"><h3>Contact Information</h3></div>
<table>
	<tr>	
		<td align="right">&nbsp;&nbsp;&nbsp;Home Phone:</td><Td align="left"> <cfinput type=text name="home_phone" size=12></td>
	</tr>
	<Tr>
		<td align="right">ISE Contact Number: </td><td align="left"><cfinput type=text name="work_phone" size=12></td>
	</tr>
	<tr>
		<td align="right">Fax:</td><td align="left"><cfinput type=text name=fax size=12></td>
	</tr>
	<tr>
		<td align="right">Email:</td><td align="left"><cfinput type="Text" name="email" required="No" size="30"> Send Login info <cfinput type="checkbox" name="Send" checked></td><td> <div class="inline_help"><a href="javascript:void window.open('pop_ups/send_login_info.cfm','','height=370,width=300,margin=0,scrollbars=yes');">(Whats this?)</a></div></td> 
	</tr>
</table>
<input type="hidden" name="temp_password" value="#temp_password#">
<input type="hidden" name="companyid" value="ISE">
<div class="button" align="right"><input type="submit" value=" Next "></div>

</cfform>
</cfoutput>

</body>
</html>
