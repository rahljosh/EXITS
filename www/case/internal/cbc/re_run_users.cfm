<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Re Run CBCs Feature - Users and Members</title>
</head>

<body>

<cfset back_date = '#DateFormat(DateAdd('yyyy', -1, now()),'yyyy-mm-dd')#'>

<cfquery name="get_users" datasource="caseusa">
	SELECT DISTINCT u.userid, u.firstname, u.lastname
	FROM smg_users u
	INNER JOIN smg_users_cbc cbc ON u.userid = cbc.userid
	WHERE u.active = '1'
		AND cbc.familyid = '0'
		AND (cbc.notes IS NULL OR cbc.notes = '')
		AND cbc.date_sent <= '#back_date#'
	GROUP BY u.userid	
	ORDER BY cbc.companyid, cbc.date_sent	
</cfquery>

<!---
CURDATE( ), (YEAR( CURDATE( ) ) - YEAR( date_sent ) ) - ( RIGHT( CURDATE( ) , 5 ) < RIGHT( date_sent, 5 ) ) AS age
--->

<cfoutput>

<cfset count_user = 0>
<cfset count_member = 0>

<table width="600" align="center" cellpadding="2" frame="below">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>CBC ran before #back_date#</b></td></tr>
	<tr bgcolor="##CCCCCC"><td><b>USER</b></td><td><b>CBC Sent Date</b></td><th>Season</th><th>Company</th></tr>

	<cfloop query="get_users">
	
		<!--- CHECK LAST CBC RECORD --->
		<cfquery name="check_last_cbc" datasource="caseusa">
			SELECT DISTINCT userid, date_authorized, date_sent, cbc.seasonid, cbc.companyid,
				c.companyshort,
				season
			FROM smg_users_cbc cbc
			LEFT JOIN smg_companies c ON c.companyid = cbc.companyid
			INNER JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
			WHERE userid = '#userid#'
				AND familyid = '0'
				AND (notes IS NULL OR notes = '')
			ORDER BY cbcid DESC	
		</cfquery>
	
		<cfif check_last_cbc.date_sent NEQ '' AND check_last_cbc.date_sent LTE back_date AND firstname NEQ '' AND lastname NEQ ''>
			<tr>
				<td>###userid# - #firstname# #lastname#</td>
				<td align="center">#DateFormat(check_last_cbc.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#check_last_cbc.season#</td>
				<td align="center">#check_last_cbc.companyshort#</td>				
			</tr>
			<cfset new_season_user = check_last_cbc.seasonid + 1>
			<cfset count_user = count_user + 1>
			<cfquery name="insert_cbc" datasource="caseusa">
				INSERT INTO smg_users_cbc
					(userid, seasonid, companyid, date_authorized)
				VALUES
					(#check_last_cbc.userid#, #new_season_user#, #check_last_cbc.companyid#, #CreateODBCDate(check_last_cbc.date_authorized)#)
			</cfquery>
		</cfif>

		<!--- CHECK MEMBERS --->
		<cfquery name="check_members" datasource="caseusa">
			SELECT DISTINCT userid, date_authorized, date_sent, smg_users_cbc.seasonid, smg_users_cbc.companyid, familyid,
				c.companyshort,
				season
			FROM smg_users_cbc
			LEFT JOIN smg_companies c ON c.companyid = smg_users_cbc.companyid 
			INNER JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
			WHERE userid = '#userid#'
				AND familyid != '0'
				AND notes IS NULL
			ORDER BY cbcid DESC	
		</cfquery>
		<cfif check_members.date_sent NEQ '' AND check_members.date_sent LTE back_date>
			<tr>
				<td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ###userid# - #firstname# #lastname# Family Member</td>
				<td align="center">#DateFormat(check_members.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#check_members.season#</td>
				<td align="center">#check_members.companyshort#</td>
			</tr>
			<cfset new_season_member = check_members.seasonid + 1>
			<cfset count_member = count_member + 1>
			<cfquery name="insert_cbc" datasource="caseusa">
				INSERT INTO smg_users_cbc
					(userid, familyid, seasonid, companyid, date_authorized)
				VALUES
					('#check_members.userid#', '#check_members.familyid#', '#new_season_user#', '#check_members.companyid#', #CreateODBCDate(check_members.date_authorized)#)
			</cfquery>
		</cfif>
		
	</cfloop>

	<tr><td colspan="4">Total of users #count_user# records</td></tr>
	<tr><td colspan="4">Total of members #count_member# records</td></tr>
</table>
</cfoutput>

</body>
</html>