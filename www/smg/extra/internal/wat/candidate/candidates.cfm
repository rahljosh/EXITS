<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate List</title>
</body>
<link href="../style.css" rel="stylesheet" type="text/css">

<cftry>

<cfif NOT IsDefined('url.status')>
	<cfset url.status = '1'>
</cfif>

<cfif NOT IsDefined('url.order')>
	<cfset url.order = 'lastname'>
</cfif>

<cfquery name="candidates_expired" datasource="MySql">
	SELECT 	candidateid, enddate, companyid, status
	FROM extra_candidates
	WHERE companyid = '#client.companyid#' AND status!='canceled'
</cfquery>

<cfloop query="candidates_expired">
	<cfif enddate LT Now()> 
		
		<cfquery name="candidates_expired_update" datasource="mysql">
		UPDATE extra_candidates
		SET status='0'
		WHERE candidateid = #candidates_expired.candidateid# AND status!='canceled'
		</cfquery> 
		
	</cfif>
</cfloop>

<cfquery name="candidates" datasource="MySql">
	SELECT extra_candidates.firstname, extra_candidates.lastname, extra_candidates.sex, extra_candidates.residence_country, extra_candidates.candidateid, extra_candidates.programid,
	extra_candidates.intrep, extra_candidates.uniqueid, smg_countrylist.countryname, smg_programs.programname, smg_users.businessname
	FROM extra_candidates
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = extra_candidates.residence_country 
	LEFT JOIN smg_programs ON smg_programs.programid = extra_candidates.programid 
	LEFT JOIN smg_users ON smg_users.userid = extra_candidates.intrep 	
	WHERE extra_candidates.companyid = '#client.companyid#' 
		<!--- <cfif (url.status NEQ "All")>
			AND status = #url.status#
		</cfif> --->
		
		<cfif url.status EQ 'canceled'>
			AND extra_candidates.status = 'canceled'
		<cfelseif url.status EQ 0>
			AND extra_candidates.status = '0'
		<cfelseif url.status EQ 1>
			AND extra_candidates.status = '1'
		</cfif>
		
	ORDER BY #url.order#
</cfquery>

<cfoutput>


<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
  <tr>
    <td bordercolor="##FFFFFF">

		<table width=95% cellpadding=0 cellspacing=0 border=0 align="center">
			<tr valign=middle height=24>
				<td width="57%" valign="middle" bgcolor="##E4E4E4" class="title1">&nbsp;Candidates</td>
				<td width="42%" align="right" valign="top" bgcolor="##E4E4E4" class="style1">
					#candidates.recordcount# <b><cfif url.status EQ 1>Active<cfelseif url.status EQ 0>Canceled<cfelseif url.status is 'all'>All</cfif></b>
					candidate<cfif candidates.recordcount GT 1>s</cfif> found&nbsp;<br>
					Filter: &nbsp; <cfif url.status NEQ 'All'><a href="?curdoc=candidate/candidates&placed=all&status=all" class="style4"></cfif>All</a> 
					&nbsp; | &nbsp; <cfif url.status NEQ '1'><a href="?curdoc=candidate/candidates&status=1" class="style4" ></cfif>Active</a> 
					&nbsp; | &nbsp; <cfif url.status NEQ '0'><a href="?curdoc=candidate/candidates&status=0" class="style4" ></cfif>Inactive</a> 					
					&nbsp; | &nbsp; <cfif url.status NEQ 'canceled'><a href="?curdoc=candidate/candidates&status=canceled" class="style4" ></cfif>Cancelled</a>&nbsp;</td>
				<td width="1%"></td>
			</tr>
		</table>
		<br>
		<table border=0 cellpadding=4 cellspacing=0 class="section" align="center" width=95%>
			<tr>
				<th width="5%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=candidateid&status=#url.status#" class="style2">ID</a></th>
				<th width="15%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=lastname&status=#url.status#" class="style2">Last Name</a></th>
				<th width="12%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=firstname&status=#url.status#" class="style2">First Name</a></th>
				<th width="10%"  bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=sex&status=#url.status#" class="style2">Sex</a></th>
				<th width="13%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=countryname&status=#url.status#" class="style2">Country</a></th>
				<th width="20%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=programname&status=#url.status#" class="style2">Program</a></th>		
				<th width="25%" bgcolor="4F8EA4" align="left"><a href="?curdoc=candidate/candidates&order=businessname&status=#url.status#" class="style2">Intl. Rep.</a></th>
			</tr>
		<cfloop query="candidates">
			<tr bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#candidateid#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#lastname#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
				  <div align="left"><a href="?curdoc=candidate/candidate_info&uniqueid=#uniqueid#" class="style4">#firstname#</a></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left"><cfif sex EQ 'm'>Male<cfelse>Female</cfif></div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#countryname#</div></td>
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#programname#</div></td>		
				<td bgcolor="#iif(candidates.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" class="style5"><div align="left">#businessname#
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

<cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>
</cftry>