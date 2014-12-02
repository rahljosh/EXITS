<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Documents Received per Period</title>
</head>

<body>

<link rel="stylesheet" href="../reports/reports.css" type="text/css">

<cfif FORM.date1 EQ '' OR FORM.date2 EQ ''>
	You must enter start and/or end date in order to continue.
	<cfabort>
</cfif>

<cfif not IsDefined('FORM.programid')>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfscript>
	// Declaring local variables
	vUserUnderAdvisor = '';
</cfscript>

<!--- Get Program --->
<cfquery name="qGetProgramList" datasource="MYSQL">
	SELECT	
    	*
	FROM 	
    	smg_programs 
	LEFT JOIN 
    	smg_program_type ON type = programtypeid
	WHERE 	
    	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
</cfquery>

<!--- get company region --->
<cfquery name="qGetRegions" datasource="MySQL">
	SELECT 
    	regionid, 
        regionname
	FROM 
    	smg_regions
	WHERE 
    	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        
	<cfif VAL(FORM.regionid)>
    	AND 
        	regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
	</cfif>
    
	ORDER BY 
    	regionname
</cfquery> 

<!--- advisors --->
<cfif CLIENT.usertype EQ 6> 

	<cfquery name="qGetUserUnderAdvisor" datasource="MySql">
        SELECT 
        	userid
        FROM 
        	user_access_rights
        WHERE 
        	advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
        AND
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
	</cfquery>
    
    <cfscript>
		vUserUnderAdvisor = ValueList(qGetUserUnderAdvisor.userid, ',');
		vUserUnderAdvisor = ListAppend(vUserUnderAdvisor, CLIENT.userid);
    </cfscript>
    
</cfif>
<!--- advisors ---> 

<table width='100%' cellpadding=4 cellspacing="0" align="center">
<span class="application_section_header"><cfoutput>#CLIENT.companyshort# - Documents Received Per Period Report</cfoutput></span>
</table>
<br>

<cfoutput>
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">
<tr><td align="center">
	Program(s) Included in this Report:<br>
	<cfloop query="qGetProgramList"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	Period: From #DateFormat(FORM.date1, 'mm/dd/yyyy')# To #DateFormat(FORM.date2, 'mm/dd/yyyy')#
	</td></tr>
</table>

<br> <!--- table header --->
<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="box">	
<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table>
<br>

<cfloop query="qGetRegions">
	
	<cfset current_region = qGetRegions.regionid>
	
    <cfquery name="qGetRepsInRegion" datasource="MySQL">
		SELECT 
            u.userid, 
            u.firstname,
            u.lastname,
            s.placeRepID
		FROM 
        	smg_students s
		LEFT OUTER JOIN 
        	smg_users u ON s.placerepid = u.userid
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
        AND 
            s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionid#"> 
        AND 
            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
        AND 
            s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )

        <cfif CLIENT.usertype EQ 6>
            AND
                s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vUserUnderAdvisor#" list="yes"> )
        </cfif>

		GROUP BY 
        	s.placerepid
		ORDER BY 
        	u.firstName
	</cfquery>
	
	<cfquery name="qGetTotalStudentsInRegion" datasource="MySQL">
		SELECT 
        	s.studentid,
            s.firstName,
            s.familyLastName,
			sh.placeRepID,
            sh.datePlaced,
            sh.doc_host_app_page1_date,
            sh.doc_host_app_page2_date,
            sh.doc_letter_rec_date, 
            sh.doc_rules_rec_date, 
            sh.doc_photos_rec_date, 
            sh.doc_school_accept_date,
            sh.doc_school_profile_rec, 
            sh.doc_conf_host_rec, 
            sh.doc_date_of_visit, 
            sh.doc_ref_form_1, 
            sh.doc_ref_form_2,
            sh.stu_arrival_orientation, 
            sh.host_arrival_orientation
		FROM 
        	smg_students s
		INNER JOIN
        	smg_hosthistory sh ON sh.studentID = s.studentID
            AND
            	sh.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        	AND
            	sh.isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionid#">  
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#"> 
		AND
        	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )

        <cfif CLIENT.usertype EQ 6>
            AND
                sh.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vUserUnderAdvisor#" list="yes"> )
        </cfif>

        AND 
        	(
                sh.doc_host_app_page1_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)#
            OR 
				sh.doc_host_app_page2_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)#
            OR 
                sh.doc_letter_rec_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_rules_rec_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 	
                sh.doc_photos_rec_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_school_accept_date BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)#
            OR 	
                sh.doc_school_profile_rec BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_conf_host_rec BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_date_of_visit BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_ref_form_1 BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.doc_ref_form_2 BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)#
            OR 
                sh.stu_arrival_orientation BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)# 
            OR 
                sh.host_arrival_orientation BETWEEN #CreateODBCDate(FORM.date1)# AND #CreateODBCDate(FORM.date2)#
            )
	</cfquery> 
	
	<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="##CCCCCC">#qGetRegions.regionname#</th><td width="15%" align="center" bgcolor="##CCCCCC"><b>#qGetTotalStudentsInRegion.recordcount#</b></td></tr>
	</table><br>

	<cfif qGetTotalStudentsInRegion.recordcount NEQ 0>

	<cfloop query="qGetRepsInRegion">

		<cfquery name="qGetStudentsPePlaceRep" dbtype="query">
			SELECT 
            	*
            FROM
            	 qGetTotalStudentsInRegion
            WHERE
				placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepsInRegion.placerepid#">            		     
		</cfquery> 
		
		<cfif VAL(qGetStudentsPePlaceRep.recordcount)> 
			<table width='100%' cellpadding=4 cellspacing="0" align="center" frame="below">
				<tr><td width="85%" align="left">
					&nbsp; 
					<cfif qGetRepsInRegion.firstname EQ '' and qGetRepsInRegion.lastname EQ ''>
						<font color="red">Missing or Unknown</font>
					<cfelse>
						#qGetRepsInRegion.firstname# #qGetRepsInRegion.lastname#</u>
					</cfif>
					</td>
					<td width="15%" align="center">#qGetStudentsPePlaceRep.recordcount#</td></tr>
			</table>
								
			<table width='100%' frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
				<tr>
					<td width="4%">ID</th>
					<td width="18%">Student</td>
					<td width="8%">Placement</td>
					<td width="70%">Documents Received from #DateFormat(FORM.date1, 'mm/dd/yyyy')# to #DateFormat(FORM.date2, 'mm/dd/yyyy')#</td>
				</tr>	
				<cfloop query="qGetStudentsPePlaceRep">			 
					<tr bgcolor="#iif(qGetStudentsPePlaceRep.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
						<td>#studentid#</td>
						<td>#firstname# #familylastname#</td>
						<td>#DateFormat(datePlaced, 'mm/dd/yyyy')#</td>
						<td align="left"><i><font size="-2">
                            <cfif doc_host_app_page1_date GTE CreateODBCDate(FORM.date1) AND doc_host_app_page1_date LTE CreateODBCDate(FORM.date2)>HF Application P.1 &nbsp; #DateFormat(doc_host_app_page1_date,'mm/dd/yyyy')# &nbsp;</cfif>
                            <cfif doc_host_app_page2_date GTE CreateODBCDate(FORM.date1) AND doc_host_app_page2_date LTE CreateODBCDate(FORM.date2)>HF Application P.2 &nbsp; #DateFormat(doc_host_app_page2_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_letter_rec_date GTE CreateODBCDate(FORM.date1) AND doc_letter_rec_date LTE CreateODBCDate(FORM.date2)> -  &nbsp; HF Letter P.3 &nbsp; #DateFormat(doc_letter_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_rules_rec_date GTE CreateODBCDate(FORM.date1) AND doc_rules_rec_date LTE CreateODBCDate(FORM.date2)> -  &nbsp; HF Rules &nbsp; #DateFormat(doc_rules_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_photos_rec_date GTE CreateODBCDate(FORM.date1) AND doc_photos_rec_date LTE CreateODBCDate(FORM.date2)> -  &nbsp; HF Photos &nbsp; #DateFormat(doc_photos_rec_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_school_accept_date GTE CreateODBCDate(FORM.date1) AND doc_school_accept_date LTE CreateODBCDate(FORM.date2)> -  &nbsp; School Acceptance &nbsp; #DateFormat(doc_school_accept_date,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_school_profile_rec GTE CreateODBCDate(FORM.date1) AND doc_school_profile_rec LTE CreateODBCDate(FORM.date2)> -  &nbsp; School & Community Profile &nbsp;#DateFormat(doc_school_profile_rec,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_conf_host_rec GTE CreateODBCDate(FORM.date1) AND doc_conf_host_rec LTE CreateODBCDate(FORM.date2)> -  &nbsp; Visit Form &nbsp; #DateFormat(doc_conf_host_rec,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_date_of_visit GTE CreateODBCDate(FORM.date1) AND doc_date_of_visit LTE CreateODBCDate(FORM.date2)> -  &nbsp; Date of Visit &nbsp; #DateFormat(doc_date_of_visit,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_ref_form_1 GTE CreateODBCDate(FORM.date1) AND doc_ref_form_1 LTE CreateODBCDate(FORM.date2)> -  &nbsp; Ref. 1 &nbsp; #DateFormat(doc_ref_form_1,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif doc_ref_form_2 GTE CreateODBCDate(FORM.date1) AND doc_ref_form_2 LTE CreateODBCDate(FORM.date2)> -  &nbsp; Ref. 2 &nbsp; #DateFormat(doc_ref_form_2,'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif stu_arrival_orientation GTE CreateODBCDate(FORM.date1) AND stu_arrival_orientation LTE CreateODBCDate(FORM.date2)> -  &nbsp; Student Orientation &nbsp;#DateFormat(stu_arrival_orientation, 'mm/dd/yyyy')# &nbsp;</cfif>
							<cfif host_arrival_orientation GTE CreateODBCDate(FORM.date1) AND host_arrival_orientation LTE CreateODBCDate(FORM.date2)> -  &nbsp; HF Orientation &nbsp;#DateFormat(host_arrival_orientation,'mm/dd/yyyy')# &nbsp;</cfif>
						</font></i></td>		
					</tr>								
				</cfloop>	
			</table>
			<br>				
		</cfif>  <!--- qGetStudentsPePlaceRep.recordcount is not 0 ---> 
	
	</cfloop> <!--- cfloop query="qGetRepsInRegion" --->
	
	<cfelse><!---  qGetTotalStudentsInRegion.recordcount --->

        <table width='100%' cellpadding=4 cellspacing="0" align="center">
            <tr><td>No documents were received from #DateFormat(FORM.date1, 'mm/dd/yyyy')# to #DateFormat(FORM.date2, 'mm/dd/yyyy')#.</td></tr>
        </table><br>

	</cfif> <!---  qGetTotalStudentsInRegion.recordcount --->
    
</cfloop> <!--- cfloop query="qGetRegions" --->

</cfoutput>

</body>
</html>