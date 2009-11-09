<!----Get regions to pull users in that region---->
<cfoutput>
<cfif client.usertype LTE '4'>
	<cfquery name="list_regions" datasource="MySql"> 
		SELECT regionid, regionname
		FROM smg_regions
		WHERE company = '#client.companyid#' and subofregion = '0'
		ORDER BY regionname
	</cfquery>
	<cfif not isDefined("url.regionid")><cfset url.regionid = list_regions.regionid></cfif>
<!--- FIELD - GET USERS REGION --->
<cfelse>	
	<cfquery name="list_regions" datasource="MySql"> 
		SELECT user_access_rights.regionid, user_access_rights.usertype, smg_regions.regionname
		FROM user_access_rights
		INNER JOIN smg_regions ON smg_regions.regionid = user_access_rights.regionid
		WHERE userid = '#client.userid#' 
			AND user_access_rights.companyid = '#client.companyid#'
			AND user_access_rights.usertype <= '6'
		ORDER BY default_region DESC, regionname
	</cfquery>

	<cfif NOT IsDefined('url.regionid')><cfset url.regionid = list_regions.regionid></cfif>
</cfif>

<cfset region = #list_regions.regionid#>
	<cfquery name="get_ra" datasource="mysql">
		SELECT smg_users.firstname, smg_users.lastname, smg_users.userid, user_access_rights.regionid, user_access_rights.usertype 
		FROM smg_users 
		INNER JOIN user_access_rights ON smg_users.userid = user_access_rights.userid 
		WHERE user_access_rights.usertype = 6 and regionid = #region# AND smg_users.active = '1'
	</cfquery>
 
<cfloop query="get_ra">
RA: #firstname# #lastname# (#userid#)<br>
	<cfquery name="reginal_advisor_students" datasource="mysql">
	SELECT s.studentid, s.regionassigned, s.familylastname, s.firstname, s.programid, s.uniqueid, 
			  p.startdate, ADDDATE(p.enddate, INTERVAL 2 MONTH ) AS enddate, p.type, pt.aug_report
		FROM smg_students s
		
		INNER JOIN smg_programs p ON s.programid = p.programid
		inner join smg_program_type pt ON pt.programtypeid = p.type
		WHERE s.active = '1'
			
			AND s.companyid = '#client.companyid#'
			AND p.startdate < #now()# 
		  	AND ADDDATE(p.enddate, INTERVAL 2 MONTH ) > #now()#  
			
		
				
					AND s.arearepid = '#client.userid#'
				
		
		ORDER BY s.familylastname 
	</Cfquery> 
	<cfdump var=#reginal_advisor_students#>
			
				
		<cfquery name="get_ar" datasource="mysql">
			SELECT uar.regionid, uar.usertype,
				u.firstname, u.lastname, u.userid, u.address, u.address2, u.city, u.state, u.zip, u.phone, u.fax, u.email, u.datecreated  
			FROM smg_users u
			INNER JOIN user_access_rights uar ON u.userid = uar.userid 
			WHERE uar.advisorid = '#get_ra.userid#' AND uar.regionid = '#region#' AND uar.usertype = '7' AND u.active = '1'
			
			ORDER BY u.lastname		
		</cfquery>
		
		<cfloop query="get_ar">
			&nbsp;&nbsp;AR: #get_ar.firstname# (#get_ar.userid#)<br>
			
		</cfloop>
</cfloop>

<!----

<cfquery name="rd_students" datasource="mysql">
	SELECT distinct prquestion.report_number, s.studentid, s.regionassigned, s.familylastname, s.firstname, s.programid,
				u.firstname as rep_firstname, u.lastname as rep_lastname, u.userid, u.usertype,
				p.startdate, ADDDATE(p.enddate, INTERVAL 2 MONTH ) AS enddate, p.type,
        pt.aug_report, prquestion.submit_type, tracking.date_ra_approved, tracking.date_rd_approved, 
		tracking.ny_accepted, tracking.date_rejected, tracking.saveonly, tracking.rejected_by , tracking.date_submitted
        
    FROM smg_students s
		INNER JOIN smg_users u ON s.arearepid = u.userid
		INNER JOIN smg_programs p ON s.programid = p.programid
		LEFT JOIN smg_program_type pt ON pt.programtypeid = p.type
    LEFT JOIN smg_prquestion_details prquestion on prquestion.stuid = s.studentid
	left join smg_document_tracking tracking on tracking.report_number = prquestion.report_number
		WHERE s.active =1
			
	
  

		ORDER BY u.lastname, u.userid, s.familylastname
	
			
	</cfquery>	
<cfdump var="#rd_students#">	
	
<cfoutput>
<table cellpadding = 2 cellspacing = 4 width=100%>
			<tr><td bgcolor="CCCCCC" colspan=2><span class="get_attention"><b>></b></span> Progress Reports to Approve</u></td></tr>
			<tr>
				<td valign="top" colspan=2>
				<cfif rd_students.recordcount is 0>
					<div align="center">There are no placed students under your supervision. #url.rmonth#</div>
				<cfelse>
					<table width=90% align="center" cellspacing="0" cellpadding=2 border=0>
						<tr bgcolor="ABADFC">
							<td width="2%">&nbsp;</td>
							<td width="38%">Student Name (id)</td>
							<td width="10%">Submitted </td>
							<td width="10%">RA Approved <br>(if applicable)</td>
							<td width="10%">RD Approved</td>
							<td width="10%">NY Approved</td>
							<td width="10%">Rejected</td>
							<td width="10%">&nbsp;</td> 			
						</tr>
							<cfloop query="rd_students">
							<Cfset prevrep = 0>
							<Cfset currentrep = #userid#>
								<cfif currentrep NEQ #prevrep#>
									<tr><td colspan=8 bgcolor="F0F0F0">#rep_firstname# #rep_lastname#</td></tr>
										<tr>
								<td>&nbsp;</td>
								<td><a href="student_profile.cfm?studentid=#rd_students.studentid#" target=top>#firstname# #familylastname# (#studentid#)</a></td>
								
								<!----Show Status of Report---->
								
									<cfif submit_type eq 'offline'>
									<td colspan=6 align="center">Report was submitted offline.</td>
									<cfelseif 1 eq 1>
								     <td><cfif date_submitted is not ''>#LSDateFormat(date_submitted, 'mmm dd')# #LSTimeFormat(date_Submitted, 'h:mm tt')#</cfif></td>
									 <td><cfif date_ra_approved is not ''>#LSDateFormat(date_ra_approved, 'mmm dd')# #LSTimeFormat(date_ra_approved, 'h:mm tt')#</cfif></td>
									 <td><cfif date_rd_approved is not ''>#LSDateFormat(date_rd_approved, 'mmm dd')# #LSTimeFormat(date_rd_approved, 'h:mm tt')#</cfif></td>
									 <td><cfif ny_accepted is not ''>#LSDateFormat(ny_accepted, 'mmm dd')# #LSTimeFormat(ny_accepted, 'h:mm tt')#</cfif></td>
									 <td><cfif date_rejected is not ''>#LSDateFormat(date_rejected, 'mmm dd')# #LSTimeFormat(date_rejected, 'h:mm tt')#</cfif></td>
									 <td></td>
									 </cfif>
								
								
								</cfif>
							</cfloop>
				</cfif>
					</tr>
					</table>
</cfoutput>
---->
</cfoutput>