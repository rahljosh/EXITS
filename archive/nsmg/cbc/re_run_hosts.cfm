<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="500">

	<!--- Param Form Variables --->
    <cfparam name="FORM.cbc_type" default="">
    <cfparam name="FORM.seasonid" default="0">

	<cfscript>
		//  Set expiration date
		back_date = DateFormat(DateAdd('yyyy', -1, now()),'yyyy-mm-dd');
		
		count_records = 0;
	</cfscript>
	
    <cfquery name="qGetHosts" datasource="MySql">
        SELECT DISTINCT 
            h.hostid, 
            h.familylastname
        FROM 
            smg_hosts h
        INNER JOIN 
            smg_hosts_cbc cbc ON h.hostid = cbc.hostid
        INNER JOIN 
            smg_students s ON s.hostid = h.hostid
        INNER JOIN 
            smg_programs p ON p.programid = s.programid 	
        WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            cbc.date_sent <= <cfqueryparam cfsqltype="cf_sql_date" value="#back_date#">
        AND 
            cbc.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cbc_type#">
        AND 
            p.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonid#">
        AND 
            (
                cbc.notes IS <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
            OR 
                cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
        GROUP BY 
            h.hostid	
        ORDER BY 
            cbc.companyid, 
            cbc.date_sent
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Re Run CBCs Feature - Host Family and Members</title>
</head>

<body>

<cfif NOT LEN('FORM.cbc_type')>
	You must select an usertype in order to proceed. Please go back and try again.
	<cfabort>
</cfif>

<cfoutput>

<table width="600" align="center" cellpadding="2" frame="below">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>CBC ran before #back_date#</b></td></tr>
	<tr bgcolor="##CCCCCC"><td><b>Host</b></td><td><b>CBC Sent Date</b></td><th>Last Season</th><th>Current Season</th><th>Company</th></tr>

	<cfloop query="qGetHosts">
	
		<!--- CHECK LAST CBC RECORD --->
		<cfquery name="qCheckLastHostCBC" datasource="MySql">
			SELECT DISTINCT 
            	cbc.hostid, 
                date_authorized, 
                date_sent, 
                cbc.seasonid, 
                cbc.companyid, 
                cbc.familyid,
				c.companyshort,
				cbc_type,
				season,
				child.childid
			FROM 
            	smg_hosts_cbc cbc
			LEFT JOIN 
            	smg_companies c ON c.companyid = cbc.companyid
			INNER JOIN 
            	smg_students s ON s.hostid = cbc.hostid
			INNER JOIN 
            	smg_programs p ON p.programid = s.programid 
			INNER JOIN 
            	smg_seasons ON smg_seasons.seasonid = cbc.seasonid
			LEFT JOIN 
            	smg_host_children child ON child.childid = cbc.familyid
			WHERE 
            	cbc.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#hostid#">
            AND 
            	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
            	cbc.cbc_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cbc_type#">
            AND 
            	p.seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonid#">
            AND 
                (
                    cbc.notes IS <cfqueryparam cfsqltype="cf_sql_varchar" null="yes">
                   
                OR 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                )
                <cfif client.companyid gt 5>
                and s.companyid = #client.companyid#                
                </cfif>
			ORDER BY 
            	cbcfamid DESC	
		</cfquery>	
	
		<cfif LEN(qCheckLastHostCBC.date_sent) AND qCheckLastHostCBC.date_sent LTE back_date AND FORM.seasonid NEQ qCheckLastHostCBC.seasonid>
			<tr>
				<td>###hostid# - #familylastname#</td>
				<td align="center">#DateFormat(qCheckLastHostCBC.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#qCheckLastHostCBC.season#</td>
				<td align="center">#FORM.seasonid#</td>
				<td align="center">#qCheckLastHostCBC.companyshort#</td>				
			</tr>
			
			<cfset count_records = count_records + 1>
			
			<cfif FORM.cbc_type NEQ 'member'>
				<cfquery name="insert_cbc" datasource="MySql">
					INSERT INTO 
                    	smg_hosts_cbc
					(
                    	hostid, 
                        cbc_type, 
                        seasonid, 
                        familyid, 
                        companyid, 
                        date_authorized
                    )
					VALUES
					(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.hostid#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cbc_type#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.familyid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.companyid#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qCheckLastHostCBC.date_authorized)#">
                    )
				</cfquery>
                
			<cfelseif VAL(qCheckLastHostCBC.childid)>		
				
                <cfquery name="insert_cbc" datasource="MySql">
					INSERT INTO 
                    	smg_hosts_cbc
                    (
                    	hostid, 
                        cbc_type, 
                        seasonid, 
                        familyid, 
                        companyid, 
                        date_authorized
                    )
					VALUES
					(
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.hostid#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.cbc_type#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.seasonid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.familyid#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastHostCBC.companyid#">, 
                        <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qCheckLastHostCBC.date_authorized)#">
                    )
				</cfquery>
                
			</cfif>
		</cfif>
		
	</cfloop>

	<tr><td colspan="4">Total of Host #FORM.cbc_type# #count_records# records</td></tr>	
</table>
</cfoutput>

</body>
</html>