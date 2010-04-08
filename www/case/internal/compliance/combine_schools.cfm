<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Combining Schools</title>
</head>

<body>
<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Combining Schools</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr><td>

<cfif NOT IsDefined('form.from') OR NOT IsDefined('form.to')>

	<cfform name="hosts" action="?curdoc=compliance/combine_schools&confirm=yes" method="post">
		<Table cellpadding=6 cellspacing="0" align="center" width="75%">
			<tr><th colspan="2" bgcolor="e2efc7">Combining Schools</th></tr>
			<tr><td align="right">From : </td><td><cfinput name="from" type="text" size="5" maxlength="6" validate="integer" required="yes"> * this one will be deleted</td></tr>
			<tr><td align="right">To : </td><td><cfinput name="to" type="text" size="5" maxlength="6" validate="integer" required="yes"></td></tr>
			<tr><td colspan="2">* This feature moves students, school history and school dates from one account to the other.<br />
								Then if there are no records assigned to the school, it will be permanently deleted from the system.</td></tr>
			<tr><td colspan="2" bgcolor="e2efc7" align="center"><cfinput name="submit" type="submit" value="Submit">
		</table>	
	</cfform>

<cfelseif IsDefined('url.confirm')>

	<cfif form.from EQ '' OR form.to EQ ''>
		From or To cannot be null. Please go back and try again.
		<cfabort>
	</cfif>
	
	<cfquery name="get_from" datasource="caseusa">
		SELECT schoolid, schoolname, address, city, state, zip, principal
		FROM smg_schools
		WHERE schoolid = '#form.from#'
	</cfquery>
	
	<cfquery name="get_to" datasource="caseusa">
		SELECT schoolid, schoolname, address, city, state, zip, principal
		FROM smg_schools
		WHERE schoolid = '#form.to#'
	</cfquery>

	<cfform name="confirm" action="?curdoc=compliance/combine_schools" method="post">
		<cfinput type="hidden" name="from" value="#form.from#">
		<cfinput type="hidden" name="to" value="#form.to#">
		<Table cellpadding=6 cellspacing="0" align="center" width="75%">
			<tr><th colspan="2" bgcolor="e2efc7">Combining Schools</th></tr>
			<tr><th>FROM</th><th>TO</th></tr>
			<tr>
				<td width="50%">
					School Name : <b>#get_from.schoolname# (###get_from.schoolid#)</b><br />
					Address : <b>#get_from.address#</b><br />
					City : <b>#get_from.city#</b><br />
					State : <b>#get_from.state#</b><br />
					Zip : <b>#get_from.zip#</b><br />
					Principal : <b>#get_from.principal#	</b>			
				</td>
				<td width="50%">
					School Name : <b>#get_to.schoolname# (###get_to.schoolid#)</b><br />
					Address : <b>#get_to.address#</b><br />
					City : <b>#get_to.city#</b><br />
					State : <b>#get_to.state#</b><br />
					Zip : <b>#get_to.zip#</b><br />
					Principal : <b>#get_to.principal#</b>				
				</td>
			</tr>
			<cfset block_deletion = 0>
			
			<cfif get_from.schoolname NEQ get_to.schoolname>
				<tr><th colspan="2" bgcolor="e2efc7">**** Schools have different names ****</th></tr>
				<cfset block_deletion = 1>
			</cfif>
			<cfif get_from.city NEQ get_to.city>
				<tr><th colspan="2" bgcolor="e2efc7">*** Schools are located in different cities ***</th></tr>
				<cfset block_deletion = 1>
			</cfif>
			<cfif get_from.state NEQ get_to.state>
				<tr><th colspan="2" bgcolor="e2efc7">*** Schools are located in different states ***</th></tr>
				<cfset block_deletion = 1>
			</cfif>
			<cfif block_deletion EQ 0>
				<tr><th colspan="2">PS: Please confirm the schools are duplicates and you would like to combine them.</th></tr>
				<tr><td colspan="2" bgcolor="e2efc7" align="center"><a href="?curdoc=compliance/combine_schools">Click here to go back and try another school</a> &nbsp; &nbsp;<cfinput name="submit" type="submit" value="Confirm"></td></tr>
			<cfelse>
				<tr><th colspan="2">In order to combine these schools please make sure they have the exacly name, city and state. Please try again.</th></tr>
				<tr><td colspan="2" bgcolor="e2efc7" align="center"><a href="?curdoc=compliance/combine_schools">Click here to go back and try another school</a></td></tr>
			</cfif>
		</table>
	</cfform>	

<cfelse>
	
	<cfset school_dates_count = 0>
	
	<!--- GET STUDENTS --->
	<cfquery name="students" datasource="caseusa">
		SELECT studentid
		FROM smg_students
		WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	<!--- MOVE STUDENTS --->
	<cfquery name="move_students" datasource="caseusa">
		UPDATE smg_students
		SET schoolid = <cfqueryparam value="#form.to#" cfsqltype="cf_sql_integer">
		WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
	</cfquery>

	<!--- GET SCHOOL HISTORY --->
	<cfquery name="school_history" datasource="caseusa">
		SELECT schoolid
		FROM smg_hosthistory
		WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	<!--- MOVE SCHOOL HISTORY --->
	<cfquery name="move_school_history" datasource="caseusa">
		UPDATE smg_hosthistory
		SET schoolid = <cfqueryparam value="#form.to#" cfsqltype="cf_sql_integer">
		WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
	</cfquery>

	<!--- GET SCHOOL DATES --->
	<cfquery name="school_dates" datasource="caseusa">
		SELECT schoolid, seasonid
		FROM smg_school_dates 
		WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	
	<cfloop query="school_dates">
		<!--- CHECK IF THERE ARE SAME SEASON FOR KEEPING SCHOOL --->
		<cfquery name="school_dates" datasource="caseusa">
			SELECT schoolid, seasonid
			FROM smg_school_dates 
			WHERE schoolid = <cfqueryparam value="#form.to#" cfsqltype="cf_sql_integer">
				AND seasonid = '#seasonid#'		
		</cfquery>
			
		<cfif school_dates.recordcount EQ 0>
			<!--- MOVE SCHOOL DATES --->
			<cfquery name="move_school_dates" datasource="caseusa">
				UPDATE smg_school_dates
				SET schoolid = <cfqueryparam value="#form.to#" cfsqltype="cf_sql_integer">
				WHERE schoolid = '#schoolid#'
					AND seasonid = '#seasonid#'		
			</cfquery>
			<cfset school_dates_count = school_dates_count + 1>
		</cfif>
	</cfloop>
	<Table cellpadding=6 cellspacing="0" align="center" width="75%">
		<tr><th colspan="2" bgcolor="e2efc7">Combining Schools</th></tr>
		<tr><th colspan="2">Records moved from : ###form.from#  &nbsp; to : ###form.to#</th></tr>
		<tr><td align="right" width="200">Students :</td><td width="450">#students.recordcount#</td></tr>
		<tr><td align="right">School History :</td><td>#school_history.recordcount#</td></tr>
		<tr><td align="right">School Dates :</td><td>#school_dates_count#</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2">Deletion Information</th></tr>
		
		<!--- CHECK IF SCHOOL READY TO BE DELETED --->
		<!--- GET STUDENTS --->
		<cfquery name="students" datasource="caseusa">
			SELECT studentid
			FROM smg_students
			WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
		</cfquery>

		<!--- GET SCHOOL HISTORY --->
		<cfquery name="school_history" datasource="caseusa">
			SELECT schoolid
			FROM smg_hosthistory
			WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">		
		</cfquery>
	
		<cfif students.recordcount EQ 0 AND school_history.recordcount EQ 0>
			<!--- DELETE SCHOOL --->
			<cfquery name="delete_school" datasource="caseusa">
				DELETE 
				FROM smg_schools
				WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">
				LIMIT 1
			</cfquery>
			
			<!--- DELETE SCHOOL DATES --->
			<cfquery name="delete_dates" datasource="caseusa">
				DELETE 
				FROM smg_school_dates
				WHERE schoolid = <cfqueryparam value="#form.from#" cfsqltype="cf_sql_integer">
				LIMIT 1
			</cfquery>
			<tr><td align="right">School deleted :</td><td>## #form.from#</td></tr>
		<cfelse>
		<tr><th colspan="2">## #form.from# School was not deleted.</th></tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2">DONE.</th></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2" bgcolor="e2efc7"><a href="?curdoc=compliance/combine_schools">Click here to combine another school.</a></th></tr>
	</table>

</cfif>

</td></tr>
</table>

<!----footer of table --- new message ---->
<table width=100% cellpadding=0 cellspacing=0 border=0>
	<tr valign="bottom">
		<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
		<td width=100% background="pics/header_background_footer.gif"></td>
		<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table><br>

</cfoutput>

</body>
</html>