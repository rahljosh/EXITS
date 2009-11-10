<link rel="stylesheet" href="../smg.css" type="text/css">

<cfif not IsDefined('url.studentid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfinclude template="../querys/get_company_short.cfm">

<cfinclude template="../querys/get_student_info.cfm">

<Cfquery name="get_history" datasource="MySQL">
	SELECT insuranceid, studentid, firstname, lastname, sex, dob, country_code, new_date, end_date, sent_to_caremed, 
	org_code, policy_code, transtype	
	FROM smg_insurance
	WHERE studentid = <cfqueryparam value="#url.studentid#" cfsqltype="cf_sql_integer">
	ORDER BY insuranceid
</cfquery>

<cfoutput>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="../pics/header_background.gif"><img src="../pics/user.gif"></td>
		<td background="../pics/header_background.gif"><h2>#companyshort.companyshort#</h2></td>
		<td align="right" background="../pics/header_background.gif"><h2>Insurance History for #get_student_info.firstname# #get_student_info.familylastname#</h2></td>
		<td width=17 background="../pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width="100%" border=0 cellpadding=4 cellspacing=0 class="section">
	<tr><!--- <td><b>Previous Date</b> ---></td>
		<td><b>Transaction</b></td>
		<td><b>First Name</b></td>
		<td><b>Last Name</b></td>
		<td><b>Sex</b></td>
		<td><b>DOB</b></td>
		<td><b>Country</b></td>
		<td><b>Start Date</b></td>
		<td><b>End Date</b></td>
		<td><b>Org. Code</b></td>		
		<td><b>Policy Code</b></td>				
		<td><b>Sent on</b></td>
	</tr>
	
	<cfif get_history.recordcount EQ '0'>
	<tr><td colspan=9 align="center">Insurance file has not been filled to Caremed.</td></tr>
	<cfelse>
		<cfloop query="get_history">
			<tr bgcolor="#iif(get_history.currentrow MOD 2 ,DE("ffffe6") ,DE("e2efc7") )#">
<!--- 		<td><cfif previous_date is ''>1<sup>st</sup> File<cfelse>#DateFormat(previous_date, 'mm/dd/yyyy')#</cfif></td> --->	
				<td>#transtype#</td>
				<td>#get_history.firstname#</td>
				<td>#get_history.lastname#</td>
				<td>#sex#</td>
				<td>#DateFormat(dob, 'mm/dd/yyyy')#</td>
				<td>#country_code#</td>
				<td>#DateFormat(new_date, 'mm/dd/yyyy')#</td>
				<td>#DateFormat(end_date, 'mm/dd/yyyy')#</td>				
				<td>#org_code#</td>		
				<td>#policy_code#</td>		
				<td><cfif sent_to_caremed EQ ''>File has not been sent<cfelse></cfif>#DateFormat(sent_to_caremed, 'mm/dd/yyyy')#</td>
			</tr>
		</cfloop>
	</cfif>
</table>

<table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
	<tr><td align="center" width="50%">&nbsp;<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></td></tr>
</table>

<!----footer of table---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
		<td width=100% background="../pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="../pics/footer_rightcap.gif"></td></tr>
</table>
</cfoutput>