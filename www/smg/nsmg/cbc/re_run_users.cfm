<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="500">

	<!--- Param Form Variables --->
    <cfparam name="FORM.seasonid" default="0">

	<cfscript>
		//  Set expiration date
		back_date = DateFormat(DateAdd('yyyy', -1, now()),'yyyy-mm-dd');

		count_user = 0;
		count_member = 0;
	</cfscript>
    
    <cfquery name="qGetUsers" datasource="MySql">
        SELECT DISTINCT 
        	u.userid, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        INNER JOIN 
	        smg_users_cbc cbc ON u.userid = cbc.userid
        WHERE 
        	u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	cbc.familyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	cbc.date_sent <= <cfqueryparam cfsqltype="cf_sql_date" value="#back_date#">
        AND 
        	(
            	cbc.notes IS <cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes"> 
            OR 
            	cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
            )
        GROUP BY 
        	u.userid	
        ORDER BY 
        	cbc.companyid, 
            cbc.date_sent	
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Re Run CBCs Feature - Users and Members</title>
</head>

<body>

<!---
CURDATE( ), (YEAR( CURDATE( ) ) - YEAR( date_sent ) ) - ( RIGHT( CURDATE( ) , 5 ) < RIGHT( date_sent, 5 ) ) AS age
--->

<cfoutput>

<table width="600" align="center" cellpadding="2" frame="below">
	<tr bgcolor="##CCCCCC"><td colspan="4"><b>CBC ran before #back_date#</b></td></tr>
	<tr bgcolor="##CCCCCC"><td><b>USER</b></td><td><b>CBC Sent Date</b></td><th>Season</th><th>Company</th></tr>

	<cfloop query="qGetUsers">
	
		<!--- CHECK LAST CBC RECORD --->
		<cfquery name="qCheckLastUserCBC" datasource="MySql">
			SELECT DISTINCT 
            	userid, 
                date_authorized, 
                date_sent, 
                cbc.seasonid,
                cbc.companyid,
				c.companyshort,
				season
			FROM 
            	smg_users_cbc cbc
			LEFT JOIN 
            	smg_companies c ON c.companyid = cbc.companyid
			INNER JOIN 
            	smg_seasons ON smg_seasons.seasonid = cbc.seasonid
			WHERE 
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
            AND 
            	familyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND 
                (
                    cbc.notes IS <cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes">
                OR 
                    cbc.notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
                )
			ORDER BY cbcid DESC	
		</cfquery>
	
		<cfif LEN(qCheckLastUserCBC.date_sent) AND qCheckLastUserCBC.date_sent LTE back_date AND LEN(firstname) AND LEN(lastname)>
			<tr>
				<td>###userid# - #firstname# #lastname#</td>
				<td align="center">#DateFormat(qCheckLastUserCBC.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#qCheckLastUserCBC.season#</td>
				<td align="center">#qCheckLastUserCBC.companyshort#</td>				
			</tr>
			
			<cfset new_season_user = qCheckLastUserCBC.seasonid + 1>
			<cfset count_user = count_user + 1>
			
            <cfquery name="qInsertCBC" datasource="MySql">
				INSERT INTO 
                	smg_users_cbc
				(
                	userid, 
                    seasonid, 
                    companyid, 
                    date_authorized
                )
				VALUES
				(
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastUserCBC.userid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#new_season_user#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckLastUserCBC.companyid#">, 
                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qCheckLastUserCBC.date_authorized)#">
                ) 
			</cfquery>
		</cfif>

		<!--- CHECK MEMBERS --->
		<cfquery name="qCheckMember" datasource="MySql">
			SELECT DISTINCT 
            	userid, 
                date_authorized, 
                date_sent, 
                smg_users_cbc.seasonid, 
                smg_users_cbc.companyid, 
                familyid,
				c.companyshort,
				season
			FROM 
            	smg_users_cbc
			LEFT JOIN 
            	smg_companies c ON c.companyid = smg_users_cbc.companyid 
			INNER JOIN 
            	smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
			WHERE 
            	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#userid#">
            AND 
            	familyid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND 
            	notes IS <cfqueryparam cfsqltype="cf_sql_varchar" value="" null="yes">
			ORDER BY 
            	cbcid DESC	
		</cfquery>
        
		<cfif LEN(qCheckMember.date_sent) AND qCheckMember.date_sent LTE back_date>
			<tr>
				<td>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ###userid# - #firstname# #lastname# Family Member</td>
				<td align="center">#DateFormat(qCheckMember.date_sent, 'mm/dd/yy')#</td>
				<td align="center">#qCheckMember.season#</td>
				<td align="center">#qCheckMember.companyshort#</td>
			</tr>
            
			<cfset new_season_member = qCheckMember.seasonid + 1>
			<cfset count_member = count_member + 1>
			
            <cfquery name="qInsertCBC" datasource="MySql">
				INSERT INTO 
                	smg_users_cbc
                (
                	userid, 
                    familyid, 
                    seasonid, 
                    companyid,
                    date_authorized
                 )
				VALUES
				(
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckMember.userid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckMember.familyid#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#new_season_member#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qCheckMember.companyid#">, 
                    <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(qCheckMember.date_authorized)#">
                )
			</cfquery>
            
		</cfif>
		
	</cfloop>

	<tr><td colspan="4">Total of users #count_user# records</td></tr>
	<tr><td colspan="4">Total of members #count_member# records</td></tr>
</table>
</cfoutput>

</body>
</html>