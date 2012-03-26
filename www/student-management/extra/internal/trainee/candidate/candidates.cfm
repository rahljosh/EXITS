<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM variables --->
    <cfparam name="url.status" default="1">
	<cfparam name="URL.sortBy" default="lastName">
    <cfparam name="URL.sortOrder" default="ASC">

    <!--- Inactivate Candidates --->
    <cfquery datasource="MySql">
        UPDATE  
             extra_candidates        
        SET
             active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
             status = <cfqueryparam cfsqltype="cf_sql_bit" value="0">                
        WHERE
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
		AND            
        	status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">      
        AND 
            DATE_ADD(ds2019_enddate, INTERVAL 30 DAY) < now()
        LIMIT 1
    </cfquery>

    <cfquery name="qCandidatesList" datasource="MySql">
        SELECT 
        	ec.firstname, 
            ec.lastname, 
            ec.sex, 
            ec.residence_country, 
            ec.candidateid, 
            ec.programid,
        	ec.intrep, 
            ec.status, 
            ec.uniqueid,
            ec.ds2019_startDate,
            ec.ds2019_endDate, 
            c.countryname, 
            p.programname, 
            u.businessname
        FROM 
        	extra_candidates ec
        LEFT JOIN 
        	smg_countrylist c ON c.countryid = ec.residence_country 
        LEFT JOIN
        	smg_programs p ON p.programid = ec.programid 
        LEFT JOIN
        	smg_users u ON u.userid = ec.intrep 	
        WHERE 
        	ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <cfif url.status EQ 'canceled'>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
                <!--- AND ec.cancel_date IS NOT NULL --->
            <cfelseif url.status EQ 0>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                <!---AND ec.cancel_date IS NULL --->
            <cfelseif url.status EQ 1>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
            </cfif>
        ORDER BY 
        	<cfswitch expression="#URL.sortBy#">
            
            	<cfcase value="candidateID">
                	ec.candidateID #URL.sortOrder#
                </cfcase>
                
                <cfcase value="lastName">
                	ec.lastName #URL.sortOrder#,
                    ec.firstName #URL.sortOrder#
                </cfcase>

                <cfcase value="firstName">
                	ec.firstName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#                   
                </cfcase>

                <cfcase value="sex">
                	ec.sex #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="countryName">
                	c.countryName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="programName">
                	p.programName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfcase value="businessName">
                	u.businessName #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>
                
                <cfcase value="ds2019_startDate">
                	ec.ds2019_startDate #URL.sortOrder#,
                    ec.lastName #URL.sortOrder#
                </cfcase>

                <cfdefaultcase>
                	ec.lastName #URL.sortOrder#,
                    ec.firstName #URL.sortOrder#
                </cfdefaultcase>

			</cfswitch>        
            
    </cfquery>

</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate List</title>
</body>
<link href="../style.css" rel="stylesheet" type="text/css">

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">

		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp; Candidates</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					#qCandidatesList.recordcount# 
					<b><cfif url.status EQ 1>active<cfelseif url.status EQ 0>inactive<cfelseif url.status EQ 'canceled'>canceled</cfif></b> candidate<cfif qCandidatesList.recordcount GT 1>s</cfif> found&nbsp; <br>
					Filter: &nbsp; <cfif url.status NEQ 'All'><a href="?curdoc=candidate/candidates&placed=all&status=all" class="style4"></cfif>All</a> 
					&nbsp; | &nbsp; <cfif url.status NEQ 1><a href="?curdoc=candidate/candidates&status=1" class="style4"></cfif>Active</a> 
					&nbsp; | &nbsp; <cfif url.status NEQ 0><a href="?curdoc=candidate/candidates&status=0" class="style4"></cfif>Inactive</a> 
					&nbsp; | &nbsp; <cfif url.status NEQ 'canceled'><a href="?curdoc=candidate/candidates&status=canceled" class="style4"></cfif>Cancelled</a>&nbsp; </td>
				<td width="1%"></td>
			</tr>
		</table>
		<br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<th width="5%"  bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='candidateID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">ID</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='firstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">First Name</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='lastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Last Name</a></th>
				<th width="10%"  bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='sex',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Sex</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='countryName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Country</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='programName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='businessName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Intl. Rep.</a></th>
                <th width="12%" bgcolor="4F8EA4" align="left"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='ds2019_startDate',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" class="style2">Program Dates</a></th>
			</tr>
		<cfloop query="qCandidatesList">
			<tr bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				<td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateid#</a></td>
				<td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstname#</a></td>
				<td><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastname#</a></td>
				<td class="style5"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></div></td>
				<td class="style5">#countryname#</td>
				<td class="style5">#programname#</td>		
				<td class="style5">#businessname#</td>
				<td class="style5">#DateFormat(ds2019_startDate, 'mm/dd/yy')# - #DateFormat(ds2019_endDate, 'mm/dd/yy')#</td>                
			</tr>
		</cfloop>
		</table>
		<br><br>
		</cfoutput>
		<div align="center">
		<a href="index.cfm?curdoc=candidate/new_candidate"><img src="../pics/add-candidate.gif" border="0" align="middle" alt="Add a Candidate"></img></a></div>
		<br>

	</td>
  </tr>
</table>
</html>
