<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param FORM variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.regionID" default="0">
	<cfparam name="FORM.reportBy" default="Placing"> <!--- Placing/Supervising representatives --->

    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
	
    <cfscript>
		// Declare variables
		listAdvisorUsers = '';
		
		// Define if we are getting students by supervising or placing rep
		if ( reportBy EQ 'Placing' ) {
			tableField = 'placeRepID';	
		} else {
			tableField = 'areaRepID';
		}
	</cfscript>
    	
	<!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT	
            programID,
            programName
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
        	regionID, 
            regionname
        FROM 
        	smg_regions
        WHERE 
        	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
		AND
            regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
        ORDER BY 
        	regionname
    </cfquery> 

	<!--- Advisors --->
	<cfif CLIENT.usertype EQ 6> 
        <cfquery name="get_users_under_adv" datasource="MySql">
            SELECT DISTINCT
            	userID
            FROM 
            	user_access_rights
            WHERE 
                advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND 
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
			GROUP BY
            	userID                
        </cfquery>
        
        <cfscript>
			// populate list of users under advisor
			listAdvisorUsers = ValueList(get_users_under_adv.userID);
			// include current user
        	listAdvisorUsers = ListAppend(listAdvisorUsers, CLIENT.userID);
		</cfscript>
    </cfif>

	<!--- get total students in program --->
    <cfquery name="qGetTotalStudents" datasource="MySQL">
        SELECT	
        	studentID, 
            hostid
        FROM 	
        	smg_students
        WHERE 
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
        	hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND
            regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> ) 
        AND 
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
		<!--- Get Only Users under an advisor --->
        <cfif LEN(listAdvisorUsers)>
            AND 
            	#tableField# IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#listAdvisorUsers#" list="yes"> ) 
        </cfif>							
    </cfquery>


</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>EXITS - Missing Placement Documents</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<cfif NOT VAL(FORM.programID) OR NOT VAL(FORM.regionID)>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<cfoutput>

<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">
	<tr>
    	<td align="center">
            <span class="application_section_header">#companyshort.companyshort# - Missing Placement Documents Report</span> <br />
            
            Program(s) Included in this Report:<br />
            <cfloop query="qGetPrograms">
            	<strong>#programname# &nbsp; (#programID#)</strong><br />
            </cfloop>
            Total of Students <strong>placed</strong> in program: #qGetTotalStudents.recordcount#
		</td>
	</tr>
</table>

<br />

<!--- table header --->
<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">	
	<tr>
    	<th width="85%">Region</th> 
        <th width="15%">Total Region</th>
    </tr>
</table>

<br />

<cfloop query="qGetRegions">
	
	<cfquery name="qGetAllStudentsInRegion" datasource="MySQL">
		SELECT 
			s.studentID, 
            s.countryresident, 
            s.hostid,
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.programID, 
            s.#tableField#,
            s.date_pis_received, 
            s.doc_full_host_app_date,
            s.doc_letter_rec_date, 
            s.doc_rules_rec_date, 
            s.doc_photos_rec_date, 
            s.doc_school_accept_date, 
            s.doc_school_profile_rec,
            s.doc_conf_host_rec, 
            s.doc_date_of_visit, 
            s.doc_ref_form_1, 
            s.doc_ref_form_2, 
            s.stu_arrival_orientation, 
            s.host_arrival_orientation, 
            s.doc_class_schedule,
          <!----Added 2/2/2011---->
            s.doc_income_ver_date,
            s.doc_conf_host_rec2,
            s.doc_single_ref_check1,
            s.doc_single_ref_check2,
            p.seasonid,
            u.userID,
            u.email as repEmail,
            CONCAT(u.firstName, ' ', u.lastName) AS repName
		FROM 
        	smg_students s
		LEFT JOIN 
        	smg_users u ON s.#tableField# = userID
        LEFT JOIN
            smg_programs p on p.programid = s.programid
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#"> 
        AND 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        AND 
        	s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
        	s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        AND 
        	(
            	s.doc_full_host_app_date IS NULL 
            OR 
            	s.doc_letter_rec_date IS NULL 
            OR 
            	s.doc_rules_rec_date IS NULL 
            OR
        		s.doc_photos_rec_date IS NULL 
            OR 
            	s.doc_school_accept_date IS NULL 
            OR 
            	s.doc_school_profile_rec IS NULL 
            OR
		        s.doc_conf_host_rec IS NULL 
            OR 
            	s.doc_date_of_visit IS NULL 
            OR 
            	s.doc_ref_form_1 IS NULL 
            OR 
            	s.doc_ref_form_2 IS NULL
        	OR 
            	s.stu_arrival_orientation IS NULL 
            OR 
            	s.host_arrival_orientation IS NULL 
            OR 
            	s.doc_class_schedule IS NULL
			OR
                s.doc_income_ver_date IS NULL
            OR
            	s.doc_conf_host_rec2 IS NULL
            OR
            	s.doc_single_ref_check1 IS NULL
            or
            	s.doc_single_ref_check2  IS NULL
			)
		ORDER BY
        	repName,
            s.firstName            
	</cfquery> 
	
    <cfquery name="qGetRepsInRegion" dbtype="query">
        SELECT DISTINCT	
        	userID,
            repName,
            repEmail
        FROM 
            qGetAllStudentsInRegion
		ORDER BY
        	repName            
    </cfquery> 
    
	<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">	
		<tr bgcolor="##CCCCCC">	
        	<th width="85%">#qGetRegions.regionname#</th>
            <td width="15%" align="center"><strong>#qGetAllStudentsInRegion.recordcount#</strong></td>
        </tr>
        <tr>
            <td><strong>#FORM.reportBy# Representative</strong></td> 
            <th>Total By Rep</th>
        </tr>
	</table>
    
    <br />

	<cfif qGetAllStudentsInRegion.recordcount>

        <cfloop query="qGetRepsInRegion">

            <cfquery name="qGetStudentsByRep" dbtype="query">
                SELECT 	
                	*
                FROM 
                	qGetAllStudentsInRegion
                WHERE 
                	#tableField# = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepsInRegion.userID#">
				ORDER BY
                	firstName,
                    familyLastName                    
            </cfquery> 
		
			<cfif qGetStudentsByRep.recordcount> 

                <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="below">
                    <tr bgcolor="##CCCCCC">
                        <td width="85%" align="left">
							<cfif LEN(qGetRepsInRegion.repName)>
                                <strong>#qGetRepsInRegion.repName# (###qGetRepsInRegion.userID#)</strong>
                            <cfelse>
                                <font color="red">Missing or Unknown</font>
                            </cfif>
                        </td>
                        <td width="15%" align="center">#qGetStudentsByRep.recordcount#</td>
                    </tr>
                </table>
                                    
                <table width="100%" frame=below cellpadding="4" cellspacing="0" align="center" frame="border">
                    <tr>
                        <td width="4%"><strong>ID</strong></td>
                        <td width="18%"><strong>Student</strong></td>
                        <td width="8%"><strong>Placement</strong></td>
                        <td width="70%"><strong>Missing Documents</strong></td>
                    </tr>	
                    <cfloop query="qGetStudentsByRep">		
                    
                    <cfquery name="get_host_info" datasource="MySQL">
                        SELECT  h.hostid, h.motherfirstname, h.fatherfirstname, h.familylastname as hostlastname, h.hostid as hostfamid
                        FROM smg_hosts h
                        WHERE hostid = #hostid#
                    </cfquery>
	 				  <!---number kids at home---->
                        <cfquery name="kidsAtHome" datasource="#application.dsn#">
                        select count(childid) as kidcount
                        from smg_host_children
                        where liveathome = 'yes' and hostid =#get_host_info.hostid#
                        </cfquery>
						
						<Cfset father=0>
                        <cfset mother=0>
                      
                        <Cfif get_host_info.fatherfirstname is not ''>
                            <cfset father = 1>
                        </Cfif>
                        <Cfif get_host_info.motherfirstname is not ''>
                            <cfset mother = 1>
                        </Cfif>
                        <cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>
                        
                        <tr bgcolor="###iif(qGetStudentsByRep.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                            <td>#qGetStudentsByRep.studentID#</td>
                            <td>#qGetStudentsByRep.firstname# #qGetStudentsByRep.familylastname#</td>
                            <td>#DateFormat(qGetStudentsByRep.date_pis_received, 'mm/dd/yyyy')#</td>
                            <td align="left">
                                <i>
                                    <font size="-2">
                                        <cfif NOT LEN(qGetStudentsByRep.doc_full_host_app_date)>Host Family &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_letter_rec_date)>HF Letter &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_rules_rec_date)>HF Rules &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_photos_rec_date)>HF Photos &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_school_accept_date)>School Acceptance &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_school_profile_rec)>School & Community Profile &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_conf_host_rec)>Visit Form &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_date_of_visit)>Date of Visit &nbsp; &nbsp; </cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_ref_form_1)>Ref. 1 &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_ref_form_2)>Ref. 2 &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.stu_arrival_orientation)>Student Orientation &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.host_arrival_orientation)>HF Orientation &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_class_schedule)>Class Schedule &nbsp; &nbsp;</cfif>
                                        <cfif seasonid gt 8>
											<cfif NOT LEN(qGetStudentsByRep.doc_income_ver_date)>Income Verification &nbsp; &nbsp;</cfif>
                                            <cfif NOT LEN(qGetStudentsByRep.doc_conf_host_rec2)> 2nd Conf. Host Visit &nbsp; &nbsp;</cfif>
                                        </cfif>
                                        <cfif client.totalfam eq 1>
											<cfif NOT LEN(qGetStudentsByRep.doc_single_ref_check1)>Ref Check (Single) &nbsp; &nbsp;</cfif>
                                            <cfif NOT LEN(qGetStudentsByRep.doc_single_ref_check2)>2nd Ref Check (Single) &nbsp; &nbsp;</cfif>
                                        </cfif>
                                    </font>
                                </i>
                            </td>		
                        </tr>								
                    </cfloop>	
                </table>

                <br />				
                
            </cfif>  <!--- qGetStudentsByRep.recordcount ---> 
	
		</cfloop> <!--- cfloop query="qGetRepsInRegion" --->
	
	<cfelse> <!---  qGetAllStudentsInRegion.recordcount --->
        
        <table width="100%" cellpadding="4" cellspacing="0" align="center">
        	<tr><td>There are no students missing documents.</td></tr>
        </table>
        
	</cfif> <!---  qGetAllStudentsInRegion.recordcount --->
    
</cfloop> <!--- cfloop query="qGetRegions" --->


<!----Send as Email---->
<!----Email---->      
<cfif form.sendemail eq 1>

<cfmail to='#qGetRepsInRegion.repEmail#' from="support@iseusa.com" subject="Missing documents report for your region" type="html">

 
<cfloop query="qGetRegions">
	
	<cfquery name="qGetAllStudentsInRegion" datasource="MySQL">
		SELECT 
			s.studentID, 
            s.countryresident, 
            s.hostid,
            s.firstname, 
            s.familylastname, 
            s.sex, 
            s.programID, 
            s.#tableField#,
            s.date_pis_received, 
            s.doc_full_host_app_date,
            s.doc_letter_rec_date, 
            s.doc_rules_rec_date, 
            s.doc_photos_rec_date, 
            s.doc_school_accept_date, 
            s.doc_school_profile_rec,
            s.doc_conf_host_rec, 
            s.doc_date_of_visit, 
            s.doc_ref_form_1, 
            s.doc_ref_form_2, 
            s.stu_arrival_orientation, 
            s.host_arrival_orientation, 
            s.doc_class_schedule,
          <!----Added 2/2/2011---->
            s.doc_income_ver_date,
            s.doc_conf_host_rec2,
            s.doc_single_ref_check1,
            s.doc_single_ref_check2,
            p.seasonid,
            u.userID,
            CONCAT(u.firstName, ' ', u.lastName) AS repName
		FROM 
        	smg_students s
		LEFT JOIN 
        	smg_users u ON s.#tableField# = userID
        LEFT JOIN
            smg_programs p on p.programid = s.programid
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#"> 
        AND 
        	s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
        AND 
        	s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
        	s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND 
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
        AND 
        	(
            	s.doc_full_host_app_date IS NULL 
            OR 
            	s.doc_letter_rec_date IS NULL 
            OR 
            	s.doc_rules_rec_date IS NULL 
            OR
        		s.doc_photos_rec_date IS NULL 
            OR 
            	s.doc_school_accept_date IS NULL 
            OR 
            	s.doc_school_profile_rec IS NULL 
            OR
		        s.doc_conf_host_rec IS NULL 
            OR 
            	s.doc_date_of_visit IS NULL 
            OR 
            	s.doc_ref_form_1 IS NULL 
            OR 
            	s.doc_ref_form_2 IS NULL
        	OR 
            	s.stu_arrival_orientation IS NULL 
            OR 
            	s.host_arrival_orientation IS NULL 
            OR 
            	s.doc_class_schedule IS NULL
			OR
                s.doc_income_ver_date IS NULL
            OR
            	s.doc_conf_host_rec2 IS NULL
            OR
            	s.doc_single_ref_check1 IS NULL
            or
            	s.doc_single_ref_check2  IS NULL
			)
		ORDER BY
        	repName,
            s.firstName            
	</cfquery> 
	
    <cfquery name="qGetRepsInRegion" dbtype="query">
        SELECT DISTINCT	
        	userID,
            repName
        FROM 
            qGetAllStudentsInRegion
		ORDER BY
        	repName            
    </cfquery> 
    
	<table width="100%" cellpadding="4" cellspacing="0" align="center" frame="box">	
		<tr bgcolor="##CCCCCC">	
        	<th width="85%">#qGetRegions.regionname#</th>
            <td width="15%" align="center"><strong>#qGetAllStudentsInRegion.recordcount#</strong></td>
        </tr>
        <tr>
            <td><strong>#FORM.reportBy# Representative</strong></td> 
            <th>Total By Rep</th>
        </tr>
	</table>
    
    <br />

	<cfif qGetAllStudentsInRegion.recordcount>

        <cfloop query="qGetRepsInRegion">

            <cfquery name="qGetStudentsByRep" dbtype="query">
                SELECT 	
                	*
                FROM 
                	qGetAllStudentsInRegion
                WHERE 
                	#tableField# = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRepsInRegion.userID#">
				ORDER BY
                	firstName,
                    familyLastName                    
            </cfquery> 
		
			<cfif qGetStudentsByRep.recordcount> 

                <table width="100%" cellpadding="4" cellspacing="0" align="center" frame="below">
                    <tr bgcolor="##CCCCCC">
                        <td width="85%" align="left">
							<cfif LEN(qGetRepsInRegion.repName)>
                                <strong>#qGetRepsInRegion.repName# (###qGetRepsInRegion.userID#)</strong>
                            <cfelse>
                                <font color="red">Missing or Unknown</font>
                            </cfif>
                        </td>
                        <td width="15%" align="center">#qGetStudentsByRep.recordcount#</td>
                    </tr>
                </table>
                                    
                <table width="100%" frame=below cellpadding="4" cellspacing="0" align="center" frame="border">
                    <tr>
                        <td width="4%"><strong>ID</strong></td>
                        <td width="18%"><strong>Student</strong></td>
                        <td width="8%"><strong>Placement</strong></td>
                        <td width="70%"><strong>Missing Documents</strong></td>
                    </tr>	
                    <cfloop query="qGetStudentsByRep">		
                    
                    <cfquery name="get_host_info" datasource="MySQL">
                        SELECT  h.hostid, h.motherfirstname, h.fatherfirstname, h.familylastname as hostlastname, h.hostid as hostfamid
                        FROM smg_hosts h
                        WHERE hostid = #hostid#
                    </cfquery>
	 				  <!---number kids at home---->
                        <cfquery name="kidsAtHome" datasource="#application.dsn#">
                        select count(childid) as kidcount
                        from smg_host_children
                        where liveathome = 'yes' and hostid =#get_host_info.hostid#
                        </cfquery>
						
						<Cfset father=0>
                        <cfset mother=0>
                      
                        <Cfif get_host_info.fatherfirstname is not ''>
                            <cfset father = 1>
                        </Cfif>
                        <Cfif get_host_info.motherfirstname is not ''>
                            <cfset mother = 1>
                        </Cfif>
                        <cfset client.totalfam = #mother# + #father# + #kidsAtHome.kidcount#>
                        
                        <tr bgcolor="###iif(qGetStudentsByRep.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                            <td>#qGetStudentsByRep.studentID#</td>
                            <td>#qGetStudentsByRep.firstname# #qGetStudentsByRep.familylastname#</td>
                            <td>#DateFormat(qGetStudentsByRep.date_pis_received, 'mm/dd/yyyy')#</td>
                            <td align="left">
                                <i>
                                    <font size="-2">
                                        <cfif NOT LEN(qGetStudentsByRep.doc_full_host_app_date)>Host Family &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_letter_rec_date)>HF Letter &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_rules_rec_date)>HF Rules &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_photos_rec_date)>HF Photos &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_school_accept_date)>School Acceptance &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_school_profile_rec)>School & Community Profile &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_conf_host_rec)>Visit Form &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_date_of_visit)>Date of Visit &nbsp; &nbsp; </cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_ref_form_1)>Ref. 1 &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_ref_form_2)>Ref. 2 &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.stu_arrival_orientation)>Student Orientation &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.host_arrival_orientation)>HF Orientation &nbsp; &nbsp;</cfif>
                                        <cfif NOT LEN(qGetStudentsByRep.doc_class_schedule)>Class Schedule &nbsp; &nbsp;</cfif>
                                        <cfif seasonid gt 8>
											<cfif NOT LEN(qGetStudentsByRep.doc_income_ver_date)>Income Verification &nbsp; &nbsp;</cfif>
                                            <cfif NOT LEN(qGetStudentsByRep.doc_conf_host_rec2)> 2nd Conf. Host Visit &nbsp; &nbsp;</cfif>
                                        </cfif>
                                        <cfif client.totalfam eq 1>
											<cfif NOT LEN(qGetStudentsByRep.doc_single_ref_check1)>Ref Check (Single) &nbsp; &nbsp;</cfif>
                                            <cfif NOT LEN(qGetStudentsByRep.doc_single_ref_check2)>2nd Ref Check (Single) &nbsp; &nbsp;</cfif>
                                        </cfif>
                                    </font>
                                </i>
                            </td>		
                        </tr>								
                    </cfloop>	
                </table>

                <br />				
                
            </cfif>  <!--- qGetStudentsByRep.recordcount ---> 
	
		</cfloop> <!--- cfloop query="qGetRepsInRegion" --->
	
	<cfelse> <!---  qGetAllStudentsInRegion.recordcount --->
        
        <table width="100%" cellpadding="4" cellspacing="0" align="center">
        	<tr><td>There are no students missing documents.</td></tr>
        </table>
        
	</cfif> <!---  qGetAllStudentsInRegion.recordcount --->
    
</cfloop> <!--- cfloop query="qGetRegions" --->
     </cfmail>
      </cfif>
</cfoutput>

<br />

</body>
</html>