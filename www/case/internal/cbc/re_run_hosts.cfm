<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Re Run CBCs Feature - Host Family and Members</title>
</head>

<body>

<cfsetting requesttimeout="500">

<cfif NOT IsDefined('form.cbc_type')>
	You must select an usertype in order to proceed. Please go back and try again.
	<cfabort>
</cfif>

<cfset back_date = '#DateFormat(DateAdd('yyyy', -1, now()),'yyyy-mm-dd')#'>

<cfoutput>

<cfquery name="get_hosts" datasource="caseusa">
	SELECT DISTINCT h.hostid, h.familylastname
	FROM smg_hosts h
	INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
	INNER JOIN smg_students s ON s.hostid = h.hostid
	INNER JOIN smg_programs p ON p.programid = s.programid 	
	WHERE s.active = '1'
		AND cbc.date_sent <= '#back_date#'
		AND cbc.cbc_type = '#form.cbc_type#'
		AND p.seasonid = '#form.seasonid#'
		AND (cbc.notes IS NULL OR cbc.notes = '')
	GROUP BY h.hostid	
	ORDER BY cbc.companyid, cbc.date_sent
</cfquery>

<cfset count_records = 0>

<table width="600" align="center" cellpadding="2" frame="below">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>CBC ran before #back_date#</b></td></tr>
	<tr bgcolor="##CCCCCC"><td><b>Host</b></td><td><b>CBC Sent Date</b></td><th>Season</th><th>Company</th></tr>

	<cfloop query="get_hosts">
	
		<!--- CHECK LAST CBC RECORD --->
		<cfquery name="check_last_cbc" datasource="caseusa">
			SELECT DISTINCT cbc.hostid, date_authorized, date_sent, cbc.seasonid, cbc.companyid, cbc.familyid,
				c.companyshort,
				cbc_type,
				season,
				child.childid
			FROM smg_hosts_cbc cbc
			LEFT JOIN smg_companies c ON c.companyid = cbc.companyid
			INNER JOIN smg_students s ON s.hostid = cbc.hostid
			INNER JOIN smg_programs p ON p.programid = s.programid 
			INNER JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
			LEFT JOIN smg_host_children child ON child.childid = cbc.familyid
			WHERE cbc.hostid = '#hostid#'
				AND s.active = '1'
				AND cbc.cbc_type = '#form.cbc_type#'
				AND p.seasonid = '#form.seasonid#'
				AND (cbc.notes IS NULL OR cbc.notes = '')
			ORDER BY cbcfamid DESC	
		</cfquery>	
	
		<cfif check_last_cbc.date_sent NEQ '' AND check_last_cbc.date_sent LTE back_date AND form.seasonid NEQ check_last_cbc.seasonid>
			<tr>
				<td>###hostid# - #familylastname#</td>
				<td align="center">#DateFormat(check_last_cbc.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#check_last_cbc.season#</td>
				<td align="center">#check_last_cbc.companyshort#</td>				
			</tr>
			<cfset new_season_host = 0>
			<cfset new_season_host = check_last_cbc.seasonid + 1>
			
			<cfset count_records = count_records + 1>
			
			<cfif form.cbc_type NEQ 'member'>
				<cfquery name="insert_cbc" datasource="caseusa">
					INSERT INTO smg_hosts_cbc
						(hostid, cbc_type, seasonid, familyid, companyid, date_authorized)
					VALUES
						('#check_last_cbc.hostid#', '#form.cbc_type#', #new_season_host#, #check_last_cbc.familyid#, #check_last_cbc.companyid#, #CreateODBCDate(check_last_cbc.date_authorized)#)
				</cfquery>
			<cfelseif check_last_cbc.childid NEQ ''>		
				<cfquery name="insert_cbc" datasource="caseusa">
					INSERT INTO smg_hosts_cbc
						(hostid, cbc_type, seasonid, familyid, companyid, date_authorized)
					VALUES
						('#check_last_cbc.hostid#', '#form.cbc_type#', #new_season_host#, #check_last_cbc.familyid#, #check_last_cbc.companyid#, #CreateODBCDate(check_last_cbc.date_authorized)#)
				</cfquery>
			</cfif>
		</cfif>
		
	</cfloop>

	<tr><td colspan="4">Total of Host #form.cbc_type# #count_records# records</td></tr>	
</table>
</cfoutput>

</body>
</html>