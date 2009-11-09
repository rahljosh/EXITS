<link rel="stylesheet" href="reports.css" type="text/css">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get students in program according to the company --->
<cfquery name="get_programs" datasource="MySQL">
	SELECT 	p.programname, p.programid, c.companyshort
	FROM	smg_programs p
	INNER JOIN smg_companies c ON p.companyid = c.companyid
	WHERE   <cfloop list=#form.programid# index='prog'>
			p.programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop>
	GROUP BY p.programid
	ORDER BY c.companyshort, p.programid
</cfquery>

<style type="text/css">
<!--
.style1 {font-size: 10px; font-weight: bold; }
-->
</style>

<cfoutput>
<table width='670' cellpadding=4 cellspacing="0" align="center">	
	<tr>
    	<td>    
			<span class="application_section_header">#companyshort.companyshort# Missing Documents Report</span>
        </td>
	</tr>    
</table><br>

<cfquery name="get_intrep" datasource="MySQL">
	SELECT 	count(*) as total_stu, s.intrep, s.programid,
		u.businessname
	FROM 	smg_students s
	INNER JOIN smg_users u ON intrep = userid
	WHERE s.other_missing_docs != '' 	
		AND s.other_missing_docs NOT LIKE '%ok%'
		<cfif form.intrep NEQ 0>AND s.intrep ='#form.intrep#'</cfif>
		AND	( <cfloop list=#form.programid# index='prog'>
			s.programid = #prog# 
		<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
		</cfloop> )
	GROUP BY s.intrep
	ORDER BY u.businessname
</cfquery>

	<cfif get_intrep.recordcount NEQ 0> <!--- If there's no students, won't show up --->
	<!--- table header --->
	<table width='670' cellpadding=4 cellspacing="0" align="center" frame="box">	
		<tr><td colspan="2">
			<div align="center">Program(s) Included in this Report:</div><br>
			<cfloop query="get_programs"><b>#companyshort# &nbsp; &nbsp; #programname# &nbsp; (###ProgramID#)</b><br></cfloop></td></tr>
		<tr>
			<td width="85%" class="style1">International Representative</th>
			<td width="15%" align="center" class="style1">Total</th>
		</tr>
	</table><br>
		
	<!--- international rep loop ---->
	<cfloop query="get_intrep">				
	<table width='670' cellpadding=4 cellspacing="0" align="center" frame="box">		
		<tr>
			<td width="85%"><cfif intrep is '0'><font color="FF0000">No International Rep. Assigned</font>
							<cfelse><b><i>#get_intrep.businessname# &nbsp;(#get_intrep.intrep#)</i></b></cfif></td>
			<td width="15%" align="center"><i>#get_intrep.total_stu#</i></td>		
		</tr>
	</table>
		<cfquery name="get_students" datasource="MySQL">
			SELECT s.firstname, s.familylastname, s.studentid, s.other_missing_docs,
				c.companyshort
			FROM smg_students s
			INNER JOIN smg_companies c ON c.companyid = s.companyid
			WHERE s.intrep ='#get_intrep.intrep#'
				AND s.active = '1' 
				AND s.other_missing_docs <> '' 	
				AND s.other_missing_docs NOT LIKE '%ok%'
				AND	( <cfloop list=#form.programid# index='prog'>
					s.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			ORDER BY c.companyshort, s.firstname
		</cfquery>
		<table width='670' cellpadding=4 cellspacing="0" align="center" frame="box">
			<tr>
				<td width="10%" class="style1">Company</td>
				<td width="35%" class="style1">Student</td>
				<td width="65%" class="style1">Missing Documents</td>	
			</tr>
			<!--- students under the rep loop ---->
			<cfloop query="get_students">
			<tr bgcolor="#iif(get_students.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
				<td>#companyshort#</td>
				<td>#firstname# #familylastname# (###studentid#)</td>
				<td>#other_missing_docs#</i></td>
			</tr>
		  </cfloop>
		</table><br>
		</cfloop>	<!--- international representative --->
		<br>
</cfif>

</cfoutput>