<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM variables --->
    <cfparam name="url.status" default="1">
    <cfparam name="url.order" default="lastname">

    <!--- Inactivate Candidates --->
    <cfquery datasource="MySql">
        UPDATE  
             extra_candidates        
        SET
             active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">   
        WHERE
             active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        AND 
            DATE_ADD(ds2019_enddate, INTERVAL 15 DAY) < now()
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
        	#url.order#
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
				<th width="5%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=candidateid&status=#url.status#" class="style2">ID</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=firstname&status=#url.status#" class="style2">First Name</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=lastname&status=#url.status#" class="style2">Last Name</a></th>
				<th width="10%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=sex&status=#url.status#" class="style2">Sex</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=countryname&status=#url.status#" class="style2">Country</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=programname&status=#url.status#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=businessname&status=#url.status#" class="style2">Intl. Rep.</a></th>
			</tr>
		<cfloop query="qCandidatesList">
			<tr bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateid#</a></div></td>
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstname#</a></div></td>
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastname#</a></div></td>
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></div></td>
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#countryname#</div></td>
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#programname#</div></td>		
				<td bgcolor="#iif(qCandidatesList.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#businessname#
				  </option>
				  </div></td>
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
