<!--- ------------------------------------------------------------------------- ----
	
	File:		document_tracking_previous_host.cfm
	Author:		Marcus Melo
	Date:		October 06, 2009
	Desc:		Gets missing placement documents from previous host families.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param variables --->
	<cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.regionID" default="0">
    <cfparam name="FORM.dateFrom" default="">
    <cfparam name="FORM.dateTo" default="">

	<cfscript>
		// Make sure we have valid dates, if not set them as ''
		if (NOT IsDate(FORM.dateFrom) OR NOT isDate(FORM.dateTo)) {
			FORM.dateFrom = '';
			FORM.dateTo = '';
		}
	</cfscript>  
    
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Document Tracking Previous Placements</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>
<body>

<cfif NOT VAL(FORM.programid) OR NOT VAL(FORM.regionid)>
	<cfinclude template="../forms/error_message.cfm">
</cfif>

<!--- Get Program --->
<cfquery name="get_program" datasource="MYSQL">
	SELECT	
    	programID,
        programname
	FROM 	
    	smg_programs 
	LEFT JOIN 
    	smg_program_type ON type = programtypeid
	WHERE 	
    	(
        	<cfloop list="#FORM.programid#" index="prog">
				programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
				<cfif NOT ListLast(FORM.programid) EQ prog> OR </cfif>
			</cfloop> 
        )
</cfquery> 


<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">


<!--- get company region --->
<cfquery name="get_regions" datasource="MySQL">
	SELECT 
    	regionid,  
        regionname
	FROM 
    	smg_regions
	WHERE 
    	company = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
    AND (
            <cfloop list="#FORM.regionid#" index="reg">
                regionid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#reg#">
                <cfif NOT ListLast(FORM.regionid) EQ reg> OR </cfif>
            </cfloop>
        )
	ORDER BY 
    	regionname
</cfquery> 


<!--- advisors --->
<cfif client.usertype EQ 6>
	<cfquery name="get_users_under_adv" datasource="MySql">
		SELECT 
        	userid
		FROM 
        	user_access_rights
		WHERE 
    		advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#"> 
        AND 
        	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
	</cfquery>
    
	<cfset ad_users = ValueList(get_users_under_adv.userid, ',')>
	<cfset ad_users = ListAppend(ad_users, client.userid)>
</cfif>
<!--- advisors --->


<cfoutput>

<table width="100%" cellpadding=4 cellspacing="0" align="center">
	<tr><td><span class="application_section_header">#companyshort.companyshort# - Previous HF Missing Placement Documents Report</span></td></tr>
</table><br>

<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="box">
	<tr><td align="center">
		Program(s) Included in this Report:<br>
		<cfloop query="get_program"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
	</td></tr>
</table><br>


<!--- table header --->
<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="box">	
	<tr><th width="85%">Region</th> <th width="15%">Total Assigned</th></tr>
	<tr><td width="85%">Placing Representative</td><td width="15%" align="center">Total</td></tr>
</table><br>

<cfloop query="get_regions">
	
	<cfset current_region = get_regions.regionid>
	
	<Cfquery name="getRepIDs" datasource="MySQL">
		SELECT 
        	s.placerepid, 
            CONCAT(u.firstname, ' ', u.lastname) as name
		FROM 
        	smg_students s
        INNER JOIN
        	smg_hosthistory hist ON hist.studentID = s.studentID
		LEFT OUTER JOIN 
        	smg_users u ON hist.placerepid = u.userid
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_regions.regionid#">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND 
        	(
            	<cfloop list="#FORM.programid#" index='prog'>
            		s.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
            		<cfif NOT ListLast(FORM.programid) EQ prog> OR </cfif>
            	</cfloop> 
            )
        <!--- Advisors --->
        <cfif client.usertype EQ 6>
            AND 
            	( 
                    <cfloop list="#ad_users#" index='i' delimiters = ",">
                        s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
						<cfif NOT ListLast(ad_users) EQ i> OR </cfif> 
                    </Cfloop>
                )
        </cfif>	
        <!--- From / To Dates --->
        <cfif LEN(FORM.dateFrom) AND LEN(FORM.dateTo)> 
        	AND
            	hist.dateofchange >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateFrom)#">
        	AND
            	hist.dateofchange <= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateTo)#">
        </cfif>
        GROUP BY
        	placerepid
		ORDER BY 
        	name
	</cfquery>
	
	<Cfquery name="get_total_in_region" datasource="MySQL">
		SELECT 
        	s.studentid
		FROM 
        	smg_students s
        INNER JOIN
        	smg_hosthistory hist ON hist.studentID = s.studentID
		WHERE 
        	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_regions.regionid#">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
        AND 
        	s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
        AND	
        	hist.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
        	(
        		<cfloop list="#FORM.programid#" index='prog'>
		            s.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#">
        		    <cfif NOT ListLast(FORM.programid) EQ prog> OR </cfif>
	            </cfloop> 
            )
        <!--- From / To Dates --->
        <cfif LEN(FORM.dateFrom) AND LEN(FORM.dateTo)> 
        	AND
            	hist.dateofchange >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateFrom)#">
        	AND
            	hist.dateofchange <= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateTo)#">
        </cfif>
        AND 
            (
                    hist.doc_full_host_app_date IS NULL 
                OR 
                    hist.doc_letter_rec_date IS NULL 
                OR 
                    hist.doc_rules_rec_date IS NULL 
                OR 
                    hist.doc_photos_rec_date IS NULL 
                OR 
                    hist.doc_school_accept_date IS NULL 
                OR 
                    hist.doc_school_sign_date IS NULL 
                OR 
                    hist.doc_class_schedule IS NULL 
                OR 
                    hist.doc_school_profile_rec IS NULL 
                OR 
                    hist.doc_conf_host_rec IS NULL 
                OR 
                    hist.doc_date_of_visit IS NULL 
                OR 
                    hist.doc_ref_form_1 IS NULL 
                OR 
                    hist.doc_ref_check1 IS NULL 
                OR 
                    hist.doc_ref_form_2 IS NULL 
                OR 
                    hist.doc_ref_check2 IS NULL 
                OR 
                    hist.stu_arrival_orientation  IS NULL
                OR 
                    hist.host_arrival_orientation IS NULL 
                OR 
                    hist.doc_host_orientation IS NULL
            )
		<cfif client.usertype EQ 6>
			AND 
            	( 
                    <cfloop list="#ad_users#" index='i' delimiters = ",">
                    	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                        <cfif NOT ListLast(ad_users) EQ i> OR </cfif> 
                    </Cfloop>
                )
		</cfif>				
	</cfquery> 
	   
	<table width="100%" cellpadding=4 cellspacing="0" align="center" frame="below">	
		<tr><th width="85%" bgcolor="##CCCCCC">#get_regions.regionname#</th><td width="15%" align="center" bgcolor="##CCCCCC"><b>#get_total_in_region.recordcount#</b></td></tr>
	</table><br>
    
	<cfif get_total_in_region.recordcount NEQ 0>

        <cfloop query="getRepIDs">
    
            <Cfquery name="get_students_region" datasource="MySQL">
                SELECT 
                    s.studentid, 
                    s.countryresident, 
                    s.firstname, 
                    s.familylastname, 
                    s.sex, 
                    s.programid, 
                    s.placerepid,
                    smg_hosts.hostID,
                    smg_hosts.familyLastName as hostFamilyLastName,
                    hist.dateofchange,
                    hist.date_pis_received,
                    hist.doc_full_host_app_date,
                    hist.doc_letter_rec_date,
                    hist.doc_rules_rec_date,
                    hist.doc_photos_rec_date,
                    hist.doc_school_accept_date,
                    hist.doc_school_sign_date,
                    hist.doc_class_schedule,
                    hist.doc_school_profile_rec,
                    hist.doc_conf_host_rec,
                    hist.doc_date_of_visit,
                    hist.doc_ref_form_1,
                    hist.doc_ref_check1,
                    hist.doc_ref_form_2,
                    hist.doc_ref_check2,
                    hist.stu_arrival_orientation,
                    hist.host_arrival_orientation,
                    hist.doc_host_orientation
                FROM 
                    smg_students s
                INNER JOIN
                    smg_hosthistory hist ON hist.studentID = s.studentID
                LEFT OUTER JOIN 
                	smg_hosts ON smg_hosts.hostID = hist.hostID                      
                WHERE 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
                AND 
                    s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#current_region#"> 
                AND 
                    s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#"> 
                AND 
                    s.onhold_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> 
                AND 
                    s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#getRepIDs.placerepid#"> 
                AND	
                    hist.hostID != <cfqueryparam cfsqltype="cf_sql_integer" value="0">                    
                AND 
                    (
                        <cfloop list="#FORM.programid#" index="prog">
                            s.programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#prog#"> 
                            <cfif NOT ListLast(FORM.programid) EQ prog> OR</cfif>
                        </cfloop> 
                    )
				<!--- From / To Dates --->
                <cfif LEN(FORM.dateFrom) AND LEN(FORM.dateTo)> 
                    AND
                        hist.dateofchange >= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateFrom)#">
                    AND
                        hist.dateofchange <= <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDateTime(FORM.dateTo)#">
                </cfif>
                AND 
                    (
                            hist.doc_full_host_app_date IS NULL 
                        OR 
                            hist.doc_letter_rec_date IS NULL 
                        OR 
                            hist.doc_rules_rec_date IS NULL 
                        OR 
                            hist.doc_photos_rec_date IS NULL 
                        OR 
                            hist.doc_school_accept_date IS NULL 
                        OR 
                            hist.doc_school_sign_date IS NULL 
                        OR 
                            hist.doc_class_schedule IS NULL 
                        OR 
                            hist.doc_school_profile_rec IS NULL 
                        OR 
                            hist.doc_conf_host_rec IS NULL 
                        OR 
                            hist.doc_date_of_visit IS NULL 
                        OR 
                            hist.doc_ref_form_1 IS NULL 
                        OR 
                            hist.doc_ref_check1 IS NULL 
                        OR 
                            hist.doc_ref_form_2 IS NULL 
                        OR 
                            hist.doc_ref_check2 IS NULL 
                        OR
                            hist.stu_arrival_orientation IS NULL    
						OR	
							hist.host_arrival_orientation IS NULL 
                        OR 
                            hist.doc_host_orientation IS NULL
                    )
                ORDER BY                	
                	s.familylastname,
                    hist.dateofchange DESC                  
            </cfquery> 
            
            <cfif get_students_region.recordcount NEQ 0> 
    			
                <table width="100%" cellpadding=4 cellspacing="0" align="center" frame="below">
                    <tr>
                    	<td width="85%" align="left">
                            &nbsp; 
                            <cfif NOT LEN(getRepIDs.name)>
                                <font color="red">Missing OR Unknown</font>
                            <cfelse>
                                #getRepIDs.name#
                            </cfif>
                        </td>
                        <td width="15%" align="center">
                        	#get_students_region.recordcount#
                        </td>
                    </tr>
                </table>
                                    
                <table width="100%" frame=below cellpadding=4 cellspacing="0" align="center" frame="border">
                    <tr>
                        <td width="4%">ID</th>
                        <td width="18%">Student</td>
                        <td width="8%">Change Date</td>
                        <td width="10%">Host Family</td>
                        <td width="60%">Missing Documents</td>
                    </tr>	
                    <cfloop query="get_students_region">			 
                        <tr bgcolor="#iif(get_students_region.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
                            <td>#studentid#</td>
                            <td>#firstname# #familylastname#</td>
                            <td>#DateFormat(dateofchange, 'mm/dd/yyyy')#</td>
                            <td>#hostFamilyLastName# (#hostID#)</td>
                            <td align="left"><i><font size="-2">
                                <cfif doc_full_host_app_date EQ ''>Host Family &nbsp; &nbsp;</cfif>
								<cfif doc_letter_rec_date EQ ''>HF Letter &nbsp; &nbsp;</cfif>
								<cfif doc_rules_rec_date EQ ''>HF Rules &nbsp; &nbsp;</cfif>
								<cfif doc_photos_rec_date EQ ''>HF Photos &nbsp; &nbsp;</cfif>
								<cfif doc_school_accept_date EQ ''>School Acceptance &nbsp; &nbsp;</cfif>
								<cfif doc_school_sign_date EQ ''>School Acceptance Signature Date &nbsp; &nbsp;</cfif>
								<cfif doc_school_profile_rec EQ ''>School & Community Profile &nbsp; &nbsp;</cfif>
                                <cfif doc_conf_host_rec EQ ''>Visit Form &nbsp; &nbsp;</cfif>
                                <cfif doc_date_of_visit EQ ''>Date of Visit &nbsp; &nbsp; </cfif>
                                <cfif doc_ref_form_1 EQ ''>Ref. 1 &nbsp; &nbsp;</cfif>
								<cfif doc_ref_check1 EQ ''>Ref. 1 Check Date &nbsp; &nbsp;</cfif>
								<cfif doc_ref_form_2 EQ ''>Ref. 2 &nbsp; &nbsp;</cfif>
								<cfif doc_ref_check2 EQ ''>Ref. 2 Check Date &nbsp; &nbsp;</cfif>
								<cfif stu_arrival_orientation EQ ''>Student Orientation &nbsp; &nbsp;</cfif> 
                                <cfif host_arrival_orientation EQ ''>HF Orientation &nbsp; &nbsp;</cfif>
                                <cfif doc_class_schedule EQ ''>Class Schedule &nbsp; &nbsp;</cfif>
                            </font></i></td>		
                        </tr>								
                    </cfloop>	
                </table>
                <br>				
            </cfif>  <!--- get_students_region.recordcount NEQ 0 ---> 
        
        </cfloop> <!--- cfloop query="getRepIDs" --->
	
	<cfelse><!---  get_total_in_region.recordcount --->
			
        <table width="100%" cellpadding=4 cellspacing="0" align="center">
            <tr><td>There are none students missing documents.</td></tr>
        </table>
            
	</cfif> <!---  get_total_in_region.recordcount --->
    
</cfloop> <!--- cfloop query="get_regions" --->

</cfoutput>
<br>

</body>
</html>
