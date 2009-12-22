<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Param Form Variable --->
	<cfparam name="URL.status" default="1">
	<cfparam name="URL.order" default="lastName">

	<!--- Inactivate Students --->
    <cfquery name="qSetExpiredCandidates" datasource="mysql">
        UPDATE 
            extra_candidates
        SET 
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE 
            status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            endDate < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
    </cfquery> 
    
    <!--- Get Candidates --->   
    <cfquery name="qCandidates" datasource="MySql">
        SELECT 
        	ec.candidateID, 
            ec.firstName, 
            ec.lastName, 
            ec.sex, 
            ec.residence_country, 
            ec.programid,
        	ec.intrep, 
            ec.uniqueid, 
            c.countryName, 
            p.programName, 
            u.businessName
        FROM 
        	extra_candidates ec
        LEFT JOIN 
        	smg_countrylist c ON c.countryid = ec.residence_country 
        LEFT JOIN 
        	smg_programs p ON p.programid = ec.programid 
        LEFT JOIN 
        	smg_users u ON u.userid = ec.intrep 	
        WHERE 
        	ec.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            
            <cfif URL.status EQ 'canceled'>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="canceled">
            <cfelseif URL.status EQ 0>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            <cfelseif URL.status EQ 1>
                AND ec.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            </cfif>
            
        ORDER BY 
        	<cfswitch expression="#URL.order#">
            
            	<cfcase value="candidateID">
                	ec.candidateID
                </cfcase>
                
                <cfcase value="lastName">
                	ec.lastName,
                    ec.firstName
                </cfcase>

                <cfcase value="firstName">
                	ec.firstName,
                    ec.lastName                   
                </cfcase>

                <cfcase value="sex">
                	ec.sex,
                    ec.lastName
                </cfcase>

                <cfcase value="countryName">
                	c.countryName,
                    ec.lastName
                </cfcase>

                <cfcase value="programName">
                	p.programName,
                    ec.lastName
                </cfcase>

                <cfcase value="businessName">
                	u.businessName,
                    ec.lastName
                </cfcase>

                <cfdefaultcase>
                	ec.lastName,
                    ec.firstName
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

<cftry>

<cfoutput>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">

		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Candidates</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					#qCandidates.recordcount# <b><cfif URL.status EQ 1>Active<cfelseif URL.status EQ 0>Canceled<cfelseif URL.status is 'all'>All</cfif></b>
					candidate<cfif qCandidates.recordcount GT 1>s</cfif> found&nbsp;<br>
					Filter: &nbsp; <cfif URL.status NEQ 'All'><a href="?curdoc=candidate/candidates&placed=all&status=all" class="style4"></cfif>All</a> 
					&nbsp; | &nbsp; <cfif URL.status NEQ '1'><a href="?curdoc=candidate/candidates&status=1" class="style4" ></cfif>Active</a> 
					&nbsp; | &nbsp; <cfif URL.status NEQ '0'><a href="?curdoc=candidate/candidates&status=0" class="style4" ></cfif>Inactive</a> 					
					&nbsp; | &nbsp; <cfif URL.status NEQ 'canceled'><a href="?curdoc=candidate/candidates&status=canceled" class="style4" ></cfif>Cancelled</a>&nbsp;</td>
				<td width="1%"></td>
			</tr>
		</table>
		<br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<th width="5%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=candidateID&status=#URL.status#" class="style2">ID</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=lastName&status=#URL.status#" class="style2">Last Name</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=firstName&status=#URL.status#" class="style2">First Name</a></th>
				<th width="10%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=sex&status=#URL.status#" class="style2">Sex</a></th>
				<th width="13%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=countryName&status=#URL.status#" class="style2">Country</a></th>
				<th width="20%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=programName&status=#URL.status#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=businessName&status=#URL.status#" class="style2">Intl. Rep.</a></th>
			</tr>
		<cfloop query="qCandidates">
			<tr bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateID#</a></div></td>
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastName#</a></div></td>
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstName#</a></div></td>
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></div></td>
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#countryName#</div></td>
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#programName#</div></td>		
				<td bgcolor="#iif(qCandidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#businessName#
				  </option>
				  </div></td>
			</tr>
		</cfloop>
		</table>
		<br><br>
		<div align="center">
		<a href="index.cfm?curdoc=candidate/new_candidate"><img src="../pics/add-candidate.gif" border="0" align="middle" alt="Add a Candidate"></img></a></div>
		<br>

	</td>
  </tr>
</table>

</cfoutput>

</html>

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>