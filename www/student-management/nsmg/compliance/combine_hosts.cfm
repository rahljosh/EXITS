<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Combining Host Families</title>
</head>

<body>
<cfoutput>

<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/helpdesk.gif"></td>
		<td background="pics/header_background.gif"><h2>Combining Host Families</h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<table width=100% border=0 cellpadding=4 cellspacing=0 class="section">
<tr><td>

<cfif NOT IsDefined('FORM.from') OR NOT IsDefined('FORM.to')>

	<cfform name="hosts" action="?curdoc=compliance/combine_hosts&confirm=yes" method="post">
		<Table cellpadding=6 cellspacing="0" align="center" width="50%">
			<tr><th colspan="2" bgcolor="e2efc7">Combining Host Families</th></tr>
			<tr><td align="right">From : </td><td><cfinput name="from" type="text" size="5" maxlength="6" validate="integer" required="yes"> * this one will be deleted</td></tr>
			<tr><td align="right">To : </td><td><cfinput name="to" type="text" size="5" maxlength="6" validate="integer" required="yes"></td></tr>
			<tr><td colspan="2">* This feature moves students, cbcs, host history and host doc history from one account to the other.<br />
								Then if there are no records assigned to the HF the HF will be permanently deleted from the system.</td></tr>
			<tr><td colspan="2" bgcolor="e2efc7" align="center"><cfinput name="submit" type="submit" value="Submit">
		</table>	
	</cfform>

<cfelseif IsDefined('url.confirm')>

	<cfif FORM.from EQ '' OR FORM.to EQ ''>
		From or To cannot be null. Please go back and try again.
		<cfabort>
	</cfif>
	
	<cfquery name="get_from" datasource="MySql">
		SELECT hostid, companyid, familylastname, fatherfirstname, motherfirstname, address, city
		FROM smg_hosts
		WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.from)#">
	</cfquery>
	
	<cfquery name="get_to" datasource="MySql">
		SELECT hostid, companyid, familylastname, fatherfirstname, motherfirstname, address, city
		FROM smg_hosts
		WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.to)#">
	</cfquery>

	<cfif get_from.companyid NEQ get_to.companyid>
		Host Families are not assigned to the same company. You cannot combine them.
		<cfabort>
	</cfif>

	<cfform name="confirm" action="?curdoc=compliance/combine_hosts" method="post">
		<cfinput type="hidden" name="from" value="#FORM.from#">
		<cfinput type="hidden" name="to" value="#FORM.to#">
		<Table cellpadding=6 cellspacing="0" align="center" width="50%">
			<tr><th colspan="2" bgcolor="e2efc7">Combining Host Families</th></tr>
			<tr><td align="right">From : </td>
				<td>Last Name : #get_from.familylastname# (###get_from.hostid#)<br />
					Host Father : #get_from.fatherfirstname#<br />
					Host Mother : #get_from.motherfirstname#<br />
					Address : #get_from.address#<br />
					City : #get_from.city#</td></tr>
			<tr><td align="right">To : </td>
				<td>Last Name: #get_to.familylastname# (###get_to.hostid#)<br />
					Host Father : #get_to.fatherfirstname#<br />
					Host Mother : #get_to.motherfirstname#<br />
					Address: #get_to.address#<br />
					City: #get_to.city#</td></tr>
			<cfif get_from.familylastname NEQ get_to.familylastname>
			<tr><th colspan="2" bgcolor="e2efc7">Host families do not have the same last name. If you wish to combine them please click on continue.</th></tr>
			</cfif>
			<tr><th colspan="2">PS: Please confirm the host famlies are duplicates and you would like to combine them. THIS ACTION CANNOT BE UNDONE.</th></tr>
			<tr><td colspan="2" bgcolor="e2efc7" align="center"><a href="?curdoc=compliance/combine_hosts">Click here to go back and try another family</a> &nbsp; &nbsp;<cfinput name="submit" type="submit" value="Confirm"></td></tr>
		</table>
	</cfform>	

<cfelse>
	
	<!--- GET STUDENTS --->
	<cfquery name="students" datasource="MySQL">
		SELECT studentid
		FROM smg_students
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	<!--- MOVE STUDENTS --->
	<cfquery name="move_students" datasource="MySQL">
		UPDATE smg_students
		SET hostid = <cfqueryparam value="#FORM.to#" cfsqltype="cf_sql_integer">
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>

	<!--- GET CBC --->
	<cfquery name="cbc" datasource="MySQL">
		SELECT hostid
		FROM smg_hosts_cbc
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	<!--- MOVE CBC --->
	<cfquery name="move_cbc" datasource="MySQL">
		UPDATE smg_hosts_cbc
		SET hostid = <cfqueryparam value="#FORM.to#" cfsqltype="cf_sql_integer">
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>

	<!--- GET HOST HISTORY --->
	<cfquery name="host_history" datasource="MySQL">
		SELECT hostid
		FROM smg_hosthistory
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
	<!--- MOVE HOST HISTORY --->
	<cfquery name="move_host_history" datasource="MySQL">
		UPDATE smg_hosthistory
		SET hostid = <cfqueryparam value="#FORM.to#" cfsqltype="cf_sql_integer">
		WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
	</cfquery>
    <!--- MOVE SCHOOL HISTORY TRACKING --->
	<cfquery datasource="MySQL">
		UPDATE 
        	smg_hosthistoryTracking
		SET 
        	fieldID = <cfqueryparam value="#FORM.to#" cfsqltype="cf_sql_integer">
		WHERE 
        	fieldID = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">	
		AND
        	fieldName =  <cfqueryparam value="hostID" cfsqltype="cf_sql_varchar">           	
	</cfquery>

	<Table cellpadding=6 cellspacing="0" align="center" width="50%">
		<tr><th colspan="2" bgcolor="e2efc7">Combining Host Families</th></tr>
		<tr><th colspan="2">Records moved from : ###FORM.from#  &nbsp; to : ###FORM.to#</th></tr>
		<tr><td align="right" width="200">Students :</td><td width="450">#students.recordcount#</td></tr>
		<tr><td align="right">CBCs : </td><td>#cbc.recordcount#</td></tr>
		<tr><td align="right">Host History :</td><td>#host_history.recordcount#</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2">Deletion Information</th></tr>
		
		<!--- CHECK IF HOST FAMILY IS READY TO BE DELETED --->
		<!--- GET STUDENTS --->
		<cfquery name="students" datasource="MySQL">
			SELECT studentid
			FROM smg_students
			WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
		</cfquery>
		<!--- GET CBC --->
		<cfquery name="cbc" datasource="MySQL">
			SELECT hostid
			FROM smg_hosts_cbc
			WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
		</cfquery>
		<!--- GET HOST HISTORY --->
		<cfquery name="host_history" datasource="MySQL">
			SELECT hostid
			FROM smg_hosthistory
			WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">		
		</cfquery>
	
		<cfif students.recordcount EQ 0 AND cbc.recordcount EQ 0 AND host_history.recordcount EQ 0>
			<!--- DELETE HOST --->
			<cfquery name="delete_host" datasource="MySql">
				DELETE 
				FROM smg_hosts
				WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">
				LIMIT 1
			</cfquery>
			<!--- DELETE CHILDREN --->
			<cfquery name="delete_children" datasource="MySql">
				DELETE 
				FROM smg_host_children
				WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">
			</cfquery>
			<!--- DELETE ANIMALS --->
			<cfquery name="delete_animals" datasource="MySql">
				DELETE 
				FROM smg_host_animals
				WHERE hostid = <cfqueryparam value="#FORM.from#" cfsqltype="cf_sql_integer">
			</cfquery>	
			<tr><td align="right">Host family deleted :</td><td>## #FORM.from#</td></tr>
			<tr><td align="right">Host children for family deleted :</td><td>## #FORM.from#</td></tr>
			<tr><td align="right">Host animals for family deleted :</td><td>## #FORM.from#</td></tr>
		<cfelse>
		<tr><th colspan="2">## #FORM.from# Host family was not deleted.</th></tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2">DONE.</th></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><th colspan="2" bgcolor="e2efc7"><a href="?curdoc=compliance/combine_hosts">Click here to combine another family</a></th></tr>
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

<!---

DELETE smg_host_children.*
FROM smg_host_children 
LEFT JOIN smg_hosts h ON h.hostid = smg_host_children.hostid
WHERE h.hostid is null

DELETE smg_host_animals.*
FROM smg_host_animals 
LEFT JOIN smg_hosts h ON h.hostid = smg_host_animals.hostid
WHERE h.hostid is null

--->
