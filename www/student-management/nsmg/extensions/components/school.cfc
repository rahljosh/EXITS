<!--- ------------------------------------------------------------------------- ----
	
	File:		school.cfc
	Author:		Marcus Melo
	Date:		October, 27 2009
	Desc:		This holds the functions needed for the school

----- ------------------------------------------------------------------------- --->

<cfcomponent 
	displayname="school"
	output="false" 
	hint="A collection of functions for the company">


	<!--- Return the initialized Company object --->
	<cffunction name="Init" access="public" returntype="school" output="false" hint="Returns the initialized School object">
		
		<cfscript>
			// There is nothing really to initiate, so just return this
			return(this);
		</cfscript>
        
	</cffunction>

	
	<cffunction name="getSchools" access="public" returntype="query" output="false" hint="Gets a list of schools, if schoolID is passed gets a school by ID">
    	<cfargument name="schoolID" default="" hint="schoolID is not required">
        <cfargument name="stateList" default="" hint="List of states">
        
        <cfquery 
			name="qGetSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					schoolID,
                    schoolName,
                    regionID,
                    schoolDistrict,
                    principal,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    phone,
                    phone_ext,
                    fax,
                    email,
                    url,
                    allowGraduation,
                    tuition,
                    bookFees,
                    numberOfStudents,
                    collegeBound,
                    comments,
                    begins,
                    semesterEnds,
                    semesterBegins,
                    ends,
                    enrollment,
                    special_programs,
                    grad_policy,
                    sports,
                    other_policies,
                    private_school_info,
                    other_trans
                FROM 
                    smg_schools
                WHERE
                	1 = 1
                 
                <cfif LEN(ARGUMENTS.schoolID)>
                	AND
                    	schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
                </cfif>    
                
                <cfif LEN(ARGUMENTS.stateList)>
                	AND
                    	state IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.stateList#" list="yes"> )
                </cfif>    
                
                ORDER BY 
                    schoolName
		</cfquery>
		   
		<cfreturn qGetSchools>
	</cffunction>
    
	
 	<cffunction name="getSchoolByID" access="public" returntype="query" output="false" hint="Gets school information">
    	<cfargument name="schoolID" default="0" hint="schoolID is required">
              
        <cfquery 
			name="qGetSchoolByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					schoolID,
                    schoolName,
                    regionID,
                    schoolDistrict,
                    principal,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    phone,
                    phone_ext,
                    fax,
                    email,
                    url,
                    allowGraduation,
                    tuition,
                    bookFees,
                    numberOfStudents,
                    collegeBound,
                    comments,
                    begins,
                    semesterEnds,
                    semesterBegins,
                    ends,
                    enrollment,
                    special_programs,
                    grad_policy,
                    sports,
                    other_policies,
                    private_school_info,
                    other_trans
                FROM 
                    smg_schools
                WHERE
                    schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
		</cfquery>
		   
		<cfreturn qGetSchoolByID>
	</cffunction>


    <!--- Sends out an email when school reaches 5 students --->
	<cffunction name="complianceSchoolNotification" access="public" returntype="void" output="false" hint="Sends out an email when school reaches 5 students">
        <cfargument name="studentID" default="0" hint="studentID is not required">
        <cfargument name="schoolID" hint="schoolID is required">
        <cfargument name="startDate" hint="startDate is required">
        <cfargument name="endDate" hint="endDate is required">        
    	
        <cfscript>
			// Stores email addresses
			var vEmailTo = '';
			
			// ISE
			if ( listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID) ) {
				vEmailTo = APPLICATION.EMAIL.ISESchoolNotification;
			// CASE
			} else if ( CLIENT.companyID EQ 10 ) {
				vEmailTo = APPLICATION.EMAIL.CASESchoolNotification;
			}
		</cfscript>		        
                        
        <cfif LEN(vEmailTo) AND VAL(ARGUMENTS.schoolID) AND IsDate(ARGUMENTS.startDate) AND isDate(ARGUMENTS.endDate)>

            <cfquery name="qGetStudentsAssignedToSchool" datasource="#APPLICATION.DSN#">
                SELECT
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' (##', s.studentID, ')') AS CHAR) AS studentInformation,
                    s.host_fam_approved,                   
                    CAST(CONCAT(sc.schoolName, ' (##', sc.schoolID, ')') AS CHAR) AS schoolInformation, 
                    sc.schoolID,
                    sh.datePlaced,
                    p.programName,
                    p.seasonid,
                    c.companyShort,
                    r.regionName,
                    vuh.`Regional Manager Email` AS rmEmail               
                FROM
                    smg_students s
                INNER JOIN
                	smg_companies c ON c.companyID = s.companyID
                INNER JOIN
                	smg_regions r ON r.regionID = s.regionAssigned
                INNER JOIN
                    smg_programs p ON p.programID = s.programID
                        AND
                            p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.startDate#">
                        AND
                            p.endDate <= <cfqueryparam cfsqltype="cf_sql_date" value="#ARGUMENTS.endDate#">                              
                INNER JOIN
                    smg_hostHistory sh ON sh.studentID = s.studentID
                INNER JOIN
                    smg_schools sc ON sh.schoolID = sc.schoolID
                        AND
                            sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.schoolID#">
                INNER JOIN
                	v_user_hierarchy vuh ON r.regionID = vuh.`Region ID`
               
                WHERE s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
               	AND ( sh.datePlacedEnded > p.startDate or sh.datePlacedEnded is null )
                
                <!--- Check ISE companies --->
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND	
                        s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
				<cfelse>
                    AND	
                        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                </cfif>
                
                GROUP BY s.studentID
                
				ORDER BY
                	sh.datePlaced DESC,
                    s.familyLastName                
            </cfquery>			            
           
            <cfscript>	
			// Get the letter info
			check5students = APPLICATION.CFC.DOCUMENT.getDocuments(foreignTable='school_info',foreignid=ARGUMENTS.schoolid,seasonid=qGetStudentsAssignedToSchool.seasonID);
 			</cfscript>
           
            <cfquery name="qGetApprovedStudents" dbtype="query">
                SELECT
                    studentInformation,                   
                    schoolInformation, 
                    schoolID,
                    datePlaced,
                    programName,
                    companyShort,
                    regionName
                FROM
                    qGetStudentsAssignedToSchool 
                WHERE
                    host_fam_approved IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> )    
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
           	   UPDATE smg_school_dates
               SET fiveStudentAssigned = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
               WHERE schoolid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
               AND seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentsAssignedToSchool.seasonid)#">
            </cfquery>
            
            <!--- Sent out Notification --->
            <cfif qGetApprovedStudents.recordCount GTE 6 and not val(#check5students.recordcount#)>

				<!--- Email Template --->
                <cfsavecontent variable="vEmailSchoolNotification">
                    <cfoutput>
                        <html>
                            <head>
                                <title>Compliance - School Notification</title>
                            </head>
                            <body>
                                
                                <!--- Include CSS on the body of email --->
                                <style type="text/css">
                                    <cfinclude template="../../linked/css/baseStyle.css">
                                </style>                    
                                Please obtain a letter from this high school stating that they will accept more than 5 exchange students from #client.companyshort# for the upcoming school year. The letter should be on school letterhead, dated, and hand signed.  It is required by Dept. of State to have this letter on file in the Compliance Department. <br><br>
                                Thank you for your assistance.<br>
                                #client.companyname# Compliance Dept.<br><br>
                                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                                    <tr>
                                    	<th>School Compliance Notification</th>
                                    </tr>
                                    <tr>
                                        <td class="center">
                                            <a href="https://#CGI.HTTP_HOST#/nsmg/index.cfm?curdoc=school_info&schoolid=#qGetStudentsAssignedToSchool.schoolID#">#qGetStudentsAssignedToSchool.schoolInformation#</a> 
                                            reached 5 or more students - Additional paperwork required.
                                        </td>
                                    </tr>
                                </table>
                                
                                <br />
                                
                                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                                    <tr class="on">
                                        <td class="subTitleLeft">Division</td>
                                        <td class="subTitleLeft">Student</td>
                                        <td class="subTitleLeft">Program</td>
                                        <td class="subTitleLeft">Region</td>
                                        <td class="subTitleLeft">Date Placed</td>
                                        <td class="subTitleLeft">Status</td>
                                    </tr>     
                                    <cfloop query="qGetStudentsAssignedToSchool">
                                        <tr class="#iif(qGetStudentsAssignedToSchool.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                                            <td>#qGetStudentsAssignedToSchool.companyShort#</td>
                                            <td>#qGetStudentsAssignedToSchool.studentInformation#</td>
                                            <td>#qGetStudentsAssignedToSchool.programName#</td>
                                            <td>#qGetStudentsAssignedToSchool.regionName#</td>
                                            <td>
                                            	<cfif isDate(qGetStudentsAssignedToSchool.datePlaced)>
                                                	#DateFormat(qGetStudentsAssignedToSchool.datePlaced, 'mm/dd/yyyy')#
                                                <cfelse>
                                                	n/a
                                                </cfif>
                                            </td>
                                            <td>
                                            	<cfif listFind("1,2,3,4", qGetStudentsAssignedToSchool.host_fam_approved)>
                                                	Approved
                                                <cfelse>
                                                	Pending
                                                </cfif>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </table>
        
                           </body>
                        </html>
                     </cfoutput>                
                </cfsavecontent>
                
                <!--- Email Compliance --->
                <cfinvoke component="nsmg.cfc.email" method="send_mail">
                	<cfinvokeargument name="email_from" value="#CLIENT.support_email#">
                    <cfinvokeargument name="email_to" value="#vEmailTo#">
                    <cfinvokeargument name="email_subject" value="School Compliance Notification - #qGetStudentsAssignedToSchool.schoolInformation#">
                    <cfinvokeargument name="email_message" value="#vEmailSchoolNotification#">
                </cfinvoke>
                
            
            
            
            </cfif>
	
    	</cfif>
    
	</cffunction>


	<cffunction name="getSchoolAndDatesInfo" access="public" returntype="query" output="false" hint="Returns school and date information for a season">
    	<cfargument name="schoolID" hint="schoolID is required">
        <cfargument name="seasonID" hint="seasonID is required">
              
        <cfquery 
			name="qGetSchoolAndDatesInfo" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                    sc.schoolID,
                    sc.schoolname, 
                    sc.city,
                    sc.state,
                    sc.zip, 
                    sd.year_begins, 
                    sd.semester_begins, 
                    sd.semester_ends, 
                    sd.year_ends
                FROM 
                    smg_schools sc
                LEFT OUTER JOIN 
                    smg_school_dates sd on sd.schoolID = sc.schoolID
                    AND 
                        sd.seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.seasonID)#">
                WHERE 
                    sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
		</cfquery>
		        		   
		<cfreturn qGetSchoolAndDatesInfo>
	</cffunction>


	<cffunction name="getSchoolDates" access="public" returntype="query" output="false" hint="Returns school dates">
    	<cfargument name="schoolID" hint="schoolID is required">
        <cfargument name="programID" hint="programID is required to get the correct dates according to the season">
        <cfargument name="seasonID" default="0" hint="seasonID is not required">
              
        <cfquery 
			name="qGetSchoolDates" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	sd.schoolDateID,
                    sd.schoolID,
                    sd.seasonID,
                    sd.enrollment,
                    sd.year_begins,
                    sd.semester_ends,
                    sd.semester_begins,
                    sd.year_ends,
                    p.type
                FROM 
                	smg_school_dates sd
                INNER JOIN
                	smg_programs p ON p.seasonID = sd.seasonID
                WHERE
                	sd.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
                AND 
                	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
		</cfquery>
		
        <cfscript>
			var qReturnDates = QueryNew("startDate, endDate");
			
			/*  Return Start/End dates based on programType
				1 = 10 month
				5 = 10 month J1 Private
				
				3 = 1st Semester
				25 = 1st Semester J1 Private

				4 = 2nd Semester
				26 - 2nd Semester J1 Private								

				2 = 12 month
				24 = 12 month J1 Private
			*/
		</cfscript>

		<cfswitch expression="#qGetSchoolDates.type#">
        
        	<cfcase value="1,5">
            	
				<cfscript>
					// 10 Month Program
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
            
        	<cfcase value="3,25">
            	
				<cfscript>
					// 1st Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.semester_ends, 'mm/dd/yyyy'));
				</cfscript>
                
            </cfcase>

        	<cfcase value="4,26">
            	
				<cfscript>
					// 2nd Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>

        	<cfcase value="2,24">
            	
				<cfscript>
					// 12 Month
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
        	
            <cfdefaultcase>
				
				<cfscript>
					// Query did not return data
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", "n/a");	
					QuerySetCell(qReturnDates, "endDate", "n/a");
            	</cfscript>
                
            </cfdefaultcase>
        
        </cfswitch>
        		   
		<cfreturn qReturnDates>
	</cffunction>

    
	<cffunction name="getPrivateSchools" access="public" returntype="query" output="false" hint="Gets a list of Private schools, if privateSchoolID is passed gets it by ID">
    	<cfargument name="privateSchoolID" default="0" hint="privateSchoolID is not required">
              
        <cfquery 
			name="qGetPrivateSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					privateSchoolID,
                    privateSchoolPrice,
                    type
                FROM 
                    smg_private_schools
                <cfif VAL(ARGUMENTS.privateSchoolID)>
                	WHERE
                    	privateSchoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.privateSchoolID#">
                </cfif>    
                ORDER BY 
                    privateSchoolPrice
		</cfquery>
		   
		<cfreturn qGetPrivateSchools>
	</cffunction>
    
    
	<cffunction name="getIFFSchools" access="public" returntype="query" output="false" hint="Gets a list of IFF schools, if IFFID is passed gets it by ID">
    	<cfargument name="IFFID" default="0" hint="IFFID is not required">
              
        <cfquery 
			name="qGetIFFSchools" 
			datasource="#APPLICATION.dsn#">
                SELECT
					IFFID,
                    name
                FROM 
                    smg_iff
                <cfif VAL(ARGUMENTS.IFFID)>
                	WHERE
                    	IFFID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.IFFID#">
                </cfif>    
                ORDER BY 
                    name
		</cfquery>
		   
		<cfreturn qGetIFFSchools>
	</cffunction>
    
    
	<cffunction name="getAYPCamps" access="public" returntype="query" output="false" hint="Gets a list of AYP Camps, if campID is passed gets it by ID">
    	<cfargument name="campID" default="0" hint="IFFID is not required">
        <cfargument name="campType" default="" hint="Orientation or English">
              
        <cfquery 
			name="qGetAYPCamps" 
			datasource="#APPLICATION.dsn#">
                SELECT
					campID,
                    name,
                    campType
                FROM 
                    smg_aypcamps
                WHERE
                    isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					
                    <cfif LEN(ARGUMENTS.campType)>
                    	AND
                    		campType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.campType#">
                    </cfif>	
					
					<cfif VAL(ARGUMENTS.campID)>
                        AND
                            campID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.campID#">
                    </cfif>  
                      
                ORDER BY 
                    name
		</cfquery>
		   
		<cfreturn qGetAYPCamps>
	</cffunction>


	<!-------------------------------------------------- 
		Get PHP School Information
	--------------------------------------------------->
	<cffunction name="getPHPSchoolByID" access="public" returntype="query" output="false" hint="Gets PHP school information">
    	<cfargument name="schoolID" default="" hint="schoolID is not required">
              
        <cfquery 
			name="qGetPHPSchoolByID" 
			datasource="#APPLICATION.dsn#">
                SELECT
					schoolID,
					fk_ny_user,
                    active,
                    show_school,
                    schoolName,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    email,
                    phone,
                    cell_phone,
                    emergency_contact,
                    emergency_phone,
                    fax,
                    website,
                    tuition_notes,
                    tuition_semester,
                    tuition_year,
                    tuition_12months,
                    nonRef_deposit,
                    refund_plan,
                    focus_gender,
                    contact,
                    contact_title,
                    fax_comments,
                    misc_notes,
                    communityType,
                    nearBigCity,
                    bigCityDistance,
                    local_air_code,
                    major_air_code,
                    airport_city,
                    airport_state,
                    boarding_school,
                    boarding_notes,
                    pert_info,
                    localContact,
                    ext_school_type,
                    ext_school_grade_offer,
                    ext_school_religion,
                    ext_school_number_students,
                    ext_school_int_students,
                    ext_ratio,
                    ext_uniform,
                    ext_esl,
                    ext_school_about,
                    ext_school_location,
                    ext_housing,
                    ext_courses,
                    ext_dress_code,
                    ext_athletics,
                    ext_sat,
                    ext_major_city,
                    payHost,
                    manager,
                    supervising_rep,
                    password,
                    dateAdded,
                    lastLogin,
                    lastUpdated
                FROM 
                    php_schools
                WHERE
                    schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
		</cfquery>
		   
		<cfreturn qGetPHPSchoolByID>
	</cffunction>
    
 
	<cffunction name="getPHPSchoolDates" access="public" returntype="query" output="false" hint="Returns school dates">
    	<cfargument name="schoolID" hint="schoolID is required">
        <cfargument name="programID" hint="programID is required to get the correct dates according to the season">
        <cfargument name="seasonID" default="0" hint="seasonID is not required">
              
        <cfquery 
			name="qGetPHPSchoolDates" 
			datasource="#APPLICATION.dsn#">
                SELECT 
                	sd.schoolDateID,
                    sd.schoolID,
                    sd.seasonID,
                    sd.enrollment,
                    sd.year_begins,
                    sd.semester_ends,
                    sd.semester_begins,
                    sd.year_ends,
                    p.type
                FROM 
                	php_school_dates sd
                INNER JOIN
                	smg_programs p ON p.seasonID = sd.seasonID
                WHERE
                	sd.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.schoolID)#">
                AND 
                	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ARGUMENTS.programID)#">
		</cfquery>
		
        <cfscript>
			var qReturnDates = QueryNew("startDate, endDate");
			
			/*  Return Start/End dates based on programType
				1 = 10 month
				5 = 10 month J1 Private
				
				3 = 1st Semester
				25 = 1st Semester J1 Private

				4 = 2nd Semester
				26 - 2nd Semester J1 Private								

				2 = 12 month
				24 = 12 month J1 Private
			*/
		</cfscript>

		<cfswitch expression="#qGetPHPSchoolDates.type#">
        
        	<cfcase value="1,5">
            	
				<cfscript>
					// 10 Month Program
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetPHPSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetPHPSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
            
        	<cfcase value="3,25">
            	
				<cfscript>
					// 1st Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetPHPSchoolDates.year_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetPHPSchoolDates.semester_ends, 'mm/dd/yyyy'));
				</cfscript>
                
            </cfcase>

        	<cfcase value="4,26">
            	
				<cfscript>
					// 2nd Semester
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetPHPSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetPHPSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>

        	<cfcase value="2,24">
            	
				<cfscript>
					// 12 Month
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", DateFormat(qGetPHPSchoolDates.semester_begins, 'mm/dd/yyyy') );	
					QuerySetCell(qReturnDates, "endDate", DateFormat(qGetPHPSchoolDates.year_ends, 'mm/dd/yyyy') );
				</cfscript>
                
            </cfcase>
        	
            <cfdefaultcase>
				
				<cfscript>
					// Query did not return data
					QueryAddRow(qReturnDates);
					QuerySetCell(qReturnDates, "startDate", "n/a");	
					QuerySetCell(qReturnDates, "endDate", "n/a");
            	</cfscript>
                
            </cfdefaultcase>
        
        </cfswitch>
        		   
		<cfreturn qReturnDates>
	</cffunction>
	<!-------------------------------------------------- 
		End of PHP School Information
	--------------------------------------------------->

</cfcomponent>