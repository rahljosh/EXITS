<link rel="stylesheet" href="reports.css" type="text/css">

<cfif not IsDefined('form.programid')>
<table width='650' cellpadding=6 cellspacing="0" align="center" frame="box">
	<tr>
		<td align="center">
			<h1>Sorry, It was not possible to proccess you request at this time due the program information was not found.<br>
			Please close this window and be sure you select at least one program from the programs list before you run the report.</h1>
			<center><input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()"></center>
		</td>
	</tr>
</table>
<cfabort>
</cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	*
	FROM 	smg_programs 
	LEFT JOIN smg_program_type ON type = programtypeid
	WHERE 	(<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
</cfquery>

<!--- get company region --->
<cfquery name="get_region" datasource="MySQL">
	SELECT	regionname, company, regionid
	FROM smg_regions
	WHERE company = '#client.companyid#'
		<cfif form.regionid is  not 0>
			AND regionid = '#form.regionid#'	
		</cfif>
	ORDER BY regionname
</cfquery>

<cfif client.usertype is '6'> <!--- advisors --->
	<cfquery name="get_users_under_adv" datasource="MySql">
	SELECT userid
	FROM smg_users
	WHERE advisor_id = '#client.userid#' and companyid like '%#client.companyid#%'
	</cfquery>
	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, #client.userid#)>
</cfif> <!--- advisors --->

<!--- get total students in program --->
<cfquery name="get_total_students" datasource="MySQL">
	SELECT	studentid, hostid
	FROM 	smg_students
	WHERE companyid = #client.companyid# and active = '1'
		AND onhold_approved <= '4'
		AND hostid <> '0' AND doubleplace <> '0'
		AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
		<cfif client.usertype is '6'>
			AND ( placerepid = 
			<cfloop list="#ad_users#" index='i' delimiters = ",">
			'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
		</cfif>							
</cfquery>
<cfsavecontent variable="reportHeader">
<table width='100%' cellpadding=4 cellspacing="0" align="center">
	<tr><td><span class="application_section_header"><cfoutput>#companyshort.companyshort# - Missing Double Placement Documents Report</cfoutput></span></td></tr>
</table><br>


<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfoutput query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfoutput>
	<cfoutput>Total of Students <b>placed</b> in program: #get_total_students.recordcount#</cfoutput>
</td></tr><br>
</table>
</cfsavecontent>

<!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table><br>

<cfloop query="get_region">
    <cfscript>
        // Get Regional Manager
        qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=get_region.regionID);
    </cfscript>
	<cfsavecontent variable="doubleDocumentTrackingReport">
	<cfset current_region = get_region.regionid>
	
	<Cfquery name="list_repid" datasource="MySQL">
		SELECT placerepid, u.firstname as repname
		FROM smg_students
		LEFT JOIN smg_users u ON placerepid = userid
		where smg_students.active = '1' AND smg_students.regionassigned = '#get_region.regionid#' AND smg_students.companyid = '#client.companyid#' 
			AND onhold_approved <= '4'
			 AND smg_students.hostid <> '0' AND smg_students.doubleplace <> '0'
			 AND (<cfloop list=#form.programid# index='prog'>
				smg_students.programid = #prog# 
				<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
				</cfloop> )
			<cfif client.usertype is '6'>
				AND ( placerepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
			</cfif>							
		Group by placerepid
		Order by repname
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		select studentid
		from smg_students
		where active = '1' AND regionassigned = '#get_region.regionid#'  AND companyid = '#client.companyid#' 
			AND onhold_approved <= '4'
			AND hostid <> '0' AND doubleplace <> '0'
			AND (<cfloop list=#form.programid# index='prog'>
			programid = #prog# 
			<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
			</cfloop> )
			AND (dblplace_doc_stu is null OR dblplace_doc_fam is null OR dblplace_doc_host is null OR 
			dblplace_doc_school is null <!--- OR dblplace_doc_dpt is null --->) 		
			<cfif client.usertype is '6'>
				AND ( placerepid = 
				<cfloop list="#ad_users#" index='i' delimiters = ",">
				'#i#' <cfif #ListLast(ad_users)# is #i#><cfelse> or placerepid = </cfif> </Cfloop>)
			</cfif>							
	</cfquery> 
	
	<cfif get_total_in_region.recordcount is not 0>
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="#CCCCCC"><cfoutput>#get_region.regionname#</th><td width="15%" align="center" bgcolor="CCCCCC"><b>#get_total_in_region.recordcount#</b></td></cfoutput></tr>
	</table><br>

	<cfloop query="list_repid">
		<Cfquery name="get_rep_info" datasource="MySQL">
			select userid, firstname, lastname
			from smg_users
			where userid = '#list_repid.placerepid#'
		</cfquery>

		<Cfquery name="get_students_region" datasource="MySQL">
			select studentid, countryresident, firstname, smg_students.familylastname, sex, programid, placerepid, date_pis_received,
			dblplace_doc_stu, dblplace_doc_fam, dblplace_doc_host, dblplace_doc_school, dblplace_doc_dpt,
			h.familylastname as hostname, h.hostid
			from smg_students
			LEFT JOIN smg_hosts h ON h.hostid = smg_students.hostid
			where smg_students.active = '1' AND regionassigned = '#current_region#'
				 AND onhold_approved <= '4'
				 AND placerepid = '#list_repid.placerepid#' AND smg_students.hostid != '0'
				 AND doubleplace != '0' 
					AND (<cfloop list=#form.programid# index='prog'>
					programid = #prog# 
					<cfif prog is #ListLast(form.programid)#><Cfelse>or</cfif>
					</cfloop> )
				 AND (dblplace_doc_stu is null OR dblplace_doc_fam is null OR dblplace_doc_host is null OR 
				 dblplace_doc_school is null <!--- OR dblplace_doc_dpt is null --->) 
		</cfquery> 
		<cfif get_students_region.recordcount is not 0> 
			<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					<cfoutput> &nbsp; <cfif get_rep_info.firstname is '' and get_rep_info.lastname is ''><font color="red">Missing or Unknown</font><cfelse>
					#get_rep_info.firstname# #get_rep_info.lastname#</u></cfif>
					</td>
					<td width="15%" align="center">#get_students_region.recordcount#</td></cfoutput></tr>
			</table>
								
			<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="8%">ID</th>
					<td width="20%">Student</td>
					<td width="14%">Host Family</td>
					<td width="10%">Placement</td>
					<td width="48%">Missing Documents</td>
				</tr>					<cfoutput query="get_students_region">			 
					<tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#hostname# (###hostid#)</td>
						<td>#DateFormat(date_pis_received, 'mm/dd/yyyy')#</td>
						<td align="left"><i><font size="-2">			
							<cfif dblplace_doc_stu is ''>Student &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_fam is ''>Natural Family &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_host is ''>Host Family &nbsp; &nbsp; &nbsp;</cfif>
							<cfif dblplace_doc_school is ''>School &nbsp; &nbsp; &nbsp;</cfif>
							<!--- <cfif dblplace_doc_dpt is ''>Department of State &nbsp; &nbsp; &nbsp;</cfif> --->
						</font></i></td>		
					</tr>								
				</cfoutput>	
			</table>
			<br>				
		</cfif>  <!--- get_students_region.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="list_repid" --->
	
	</cfif> <!---  get_total_in_region.recordcount --->

    </cfsavecontent>
	<!--- Display Report --->
    <cfoutput>
    #doubleDocumentTrackingReport#
     </Cfoutput>           
<!--- Email Regional Managers --->        
    <cfif VAL(FORM.sendEmail) AND get_students_region.recordcount AND IsValid("email", qGetRegionalManager.email) AND IsValid("email", CLIENT.email)>
    	<cfoutput>
        <cfsavecontent variable="emailBody">
            <!--- Display Report Header --->
            #reportHeader#	
                                
            <!--- Display Report --->
            #doubleDocumentTrackingReport#
        </cfsavecontent>
		</cfoutput>
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="#qGetRegionalManager.email#">
            <cfinvokeargument name="email_cc" value="#CLIENT.email#">
            <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
            <cfinvokeargument name="email_subject" value="Missing Documents Report - #companyshort.companyshort# - #get_region.regionName# Region">
            <cfinvokeargument name="email_message" value="#emailBody#">
        </cfinvoke>
            
    </cfif>   <!--- Email Regional Managers --->    
</cfloop> <!--- cfloop query="get_region" --->


<br>

