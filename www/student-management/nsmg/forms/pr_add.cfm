<!--- ------------------------------------------------------------------------- ----
	
	File:		pr_add.cfm
	Author:		Marcus Melo
	Date:		February 15, 2012
	Desc:		Add Progress Report / 2nd Visit Report

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_ID" default="0">
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.type_of_report" default="0">
    <cfparam name="FORM.fk_secondVisitRep" default="0">
    <cfparam name="FORM.fk_sr_user" default="0">
    <cfparam name="FORM.fk_pr_user" default="0">
    <cfparam name="FORM.fk_ra_user" default="0">
    <cfparam name="FORM.fk_rd_user" default="0">
    <cfparam name="FORM.fk_ny_user" default="0">
    <cfparam name="FORM.fk_host" default="0">
    <cfparam name="FORM.fk_intrep_user" default="0">
    <cfparam name="FORM.month_of_report" default="0">
    <cfparam name="FORM.dueFromDate" default="">
    <cfparam name="FORM.dueToDate" default="">
	
    <cfscript>
		// Get Student Info
		qGetStudent = APPLICATION.CFC.STUDENT.getStudentByID(studentID=VAL(FORM.studentID));
	
		// Progress Report
		if ( FORM.type_of_report EQ 1 ) {
			vFormTitle = "Add Progress Report";
		// 2nd Visit Report
		} else {
			vFormTitle = "Add 2<sup>nd</sup> Visit Report";
		}
	</cfscript>	

</cfsilent>    

<!--- FORM Submitted --->
<cfif FORM.submitted>

	<!--- Initialize the pr_id for sending the form later --->
    <cfset vPRID = 0>

    <Cfquery name="checkForDupe" datasource="#application.dsn#">
        select *
        from progress_reports
        where fk_student =  <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        <cfif FORM.type_of_report NEQ 2>
        	and pr_month_of_report = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.month_of_report#">
        </cfif>
        AND fk_host = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_host#">
        AND fk_reportType = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.type_of_report#">
	</Cfquery>
    
	<cfif NOT VAL(checkForDupe.recordcount)>
    
        <cflock timeout="30">
        
            <!--- Insert Report Data --->
            <cfquery datasource="#APPLICATION.DSN#" result="newRecord">
                INSERT INTO 
                    progress_reports 
                (
                    fk_reportType, 
                    fk_student, 
                    pr_uniqueID, 
                    pr_month_of_report, 
                    fk_program, 
                    fk_secondVisitRep, 
                    fk_sr_user, 
                    fk_pr_user, 
                    fk_ra_user, 
                    fk_rd_user, 
                    fk_ny_user, 
                    fk_host, 
                    fk_intrep_user
                )
                VALUES 
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.type_of_report#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">,
                    <cfqueryparam cfsqltype="cf_sql_idstamp" value="#CreateUUID()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.month_of_report#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_secondVisitRep#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_sr_user#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_pr_user#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_ra_user#" null="#NOT VAL(FORM.fk_ra_user)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_rd_user#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_ny_user#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_host#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.fk_intrep_user#">
                )  
            </cfquery>
       
        </cflock>
            
        <!--- Progress Report --->    
        <cfif FORM.type_of_report NEQ 2>
        
            <cfquery name="qGetPRQuestions" datasource="#APPLICATION.DSN#">
                SELECT 
                    ID
                FROM 
                    smg_prquestions
                WHERE 
                    companyGroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CLIENT.company_submitting#"> 
                AND 	
                    active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
                AND 
                    month = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.month_of_report#">
            </cfquery>
           
            <cfloop query="qGetPRQuestions">
        
                <cfquery datasource="#APPLICATION.DSN#">
                    INSERT INTO 
                        x_pr_questions 
                    (
                            fk_progress_report, 
                            fk_prquestion
                    )
                    VALUES 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPRQuestions.ID#">
                    )
                </cfquery>
        
            </cfloop>
        
        <!--- Second Visit Report --->
        <cfelseif FORM.type_of_report EQ 2>
        
            <cfquery datasource="#APPLICATION.DSN#">
                INSERT INTO
                    secondvisitanswers 
                (
                    fk_reportID, 
                    fk_studentID,
                    dueFromDate,
                    dueToDate                               
                )
                VALUES
                (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#newRecord.GENERATED_KEY#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dueFromDate#" null="#NOT IsDate(FORM.dueFromDate)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dueToDate#" null="#NOT IsDate(FORM.dueToDate)#">
                )
            </cfquery>
            
        </cfif>
        
        <cfset vPRID = newRecord.GENERATED_KEY>
        
  	<cfelse>
    	<cfset vPRID = checkForDupe.pr_id>        
    </cfif>
    <cfscript>    
		// Redirect to 2nd Visit Report 
		if ( FORM.type_of_report EQ 2 ) {
			vFormPath = "index.cfm?curdoc=forms/secondHomeVisitReport";
		// Redirect to Progress Report
		} else {
			vFormPath = "index.cfm?curdoc=progress_report_info";
		}
    </cfscript>
    
    <cfoutput>
        <form action="#vFormPath#" method="post" name="theForm" id="theForm">
            <input type="hidden" name="pr_id" value="#vPRID#">
        </form>
    </cfoutput>
    
    <script type="text/javascript">    	
		// Page is ready
		$(document).ready(function() {
			// Submit Form								   	
			$("#theForm").submit();
		});
    </script>
    
    <cfabort>

<!--- FORM NOT submitted --->
<cfelse>

    <cfquery name="qGetRegionalAdvisorID" datasource="#APPLICATION.DSN#">
        SELECT 
        	advisorID
        FROM 
        	user_access_rights
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.arearepID#">
        AND 
        	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.regionassigned#">
    </cfquery>

    <cfquery name="qGetRegionFacilitator" datasource="#APPLICATION.DSN#">
        SELECT 
        	regionfacilitator
        FROM 
        	smg_regions
        WHERE 
        	regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudent.regionassigned#">
    </cfquery>
	
    <cfscript>
		// Set Default Values
        FORM.fk_sr_user = qGetStudent.arearepID;
        FORM.fk_pr_user = qGetStudent.placerepID;
        FORM.programID = qGetStudent.programID;
		FORM.fk_intrep_user = qGetStudent.intrep;
		if ( NOT VAL(FORM.fk_host) ) {
			FORM.fk_host = qGetStudent.hostID;
		}
		FORM.fk_secondVisitRep = qGetStudent.secondVisitRepID;
		FORM.fk_ra_user = qGetRegionalAdvisorID.advisorID;
		FORM.fk_ny_user = qGetRegionFacilitator.regionfacilitator;

		// Get Regional Manager
		qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(qGetStudent.regionassigned);
		FORM.fk_rd_user = qGetRegionalManager.userID;

		// Get Second Visit Representative
        qGetSecondVisitRep = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_secondVisitRep));
        
        // Get Supervising Representative
        qGetSupervisingRep = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_sr_user));
        
        // Get Placing Representative
        qGetPlacingRepresentative = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_pr_user));
        
        // Get Advisor
        qGetAdvisorInfo = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_ra_user));
        
        // Get Facilitator
        qGetFacilitator = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_ny_user));
        
        // Get Intl. Representative
        qGetIntlRep = APPLICATION.CFC.USER.getUsers(userID=VAL(FORM.fk_intrep_user));
        
        // Get Program Info
        qGetProgram = APPLICATION.CFC.PROGRAM.getPrograms(programID=VAL(FORM.programID));
        
        // Host Family
        qGetHostFamily = APPLICATION.CFC.HOST.getHosts(hostID=VAL(FORM.fk_host));
    </cfscript>

</cfif>
<script>
document.getElementById("submitForm").onsubmit = function() {   
    this.children[1].disabled = true;
   
}
</script>
<cfif NOT VAL(FORM.studentID)>
	a numeric studentID is required to add a new report.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.month_of_report)>
	a numeric month is required to add a new report.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.type_of_report)>
	a numeric type of report is required to add a new report.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.programID)>
	Program is missing.  Report may not be added.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.fk_host)>
	Host Family is missing.  Report may not be added.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.fk_intrep_user)>
	International Agent is missing.  Report may not be added.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.fk_rd_user)>
	Regional Director is missing.  Report may not be added.
	<cfabort>
</cfif>

<cfif NOT VAL(FORM.fk_ny_user)>
	Facilitator is missing.  Report may not be added.
	<cfabort>
</cfif>

<cfoutput>

    <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="POST" id="submitForm"> 
        <input type="hidden" name="submitted" value="1">
        <input type="hidden" name="studentID" value="#FORM.studentID#">
        <input type="hidden" name="month_of_report" value="#FORM.month_of_report#">
        <input type="hidden" name="programID" value="#FORM.programID#">
        <input type="hidden" name="fk_secondVisitRep" value="#FORM.fk_secondVisitRep#">
        <input type="hidden" name="fk_sr_user" value="#FORM.fk_sr_user#">
        <input type="hidden" name="fk_pr_user" value="#FORM.fk_pr_user#">
        <input type="hidden" name="fk_ra_user" value="#FORM.fk_ra_user#">
        <input type="hidden" name="fk_rd_user" value="#FORM.fk_rd_user#">
        <input type="hidden" name="fk_ny_user" value="#FORM.fk_ny_user#">
        <input type="hidden" name="fk_host" value="#FORM.fk_host#">
        <input type="hidden" name="fk_intrep_user" value="#FORM.fk_intrep_user#">
        <input type="hidden" name="dueFromDate" value="#FORM.dueFromDate#">
       	<input type="hidden" name="dueToDate" value="#FORM.dueToDate#">
        <input type="hidden" name="type_of_report" value="#FORM.type_of_report#" />

		<!--- Table Header --->
        <gui:tableHeader
        	width="50%"
            imageName="current_items.gif"
            tableTitle="#vFormTitle#"
        />

        <table width="50%" border="0" cellpadding="4" cellspacing="0" class="section" align="center"> 
            <tr align="center">
                <td colspan="2">
                    <h2>
                        Student: #qGetStudent.firstname# #qGetStudent.familylastname# ###FORM.studentID# <br />
                        <!--- Progress Report --->
                        <cfif FORM.type_of_report eq 1>
                            <cfswitch expression="#FORM.month_of_report#">
                                <cfcase value="10">
                                    Phase 1<br>
                                    <font size=-1>Due Oct 1st - includes information from Aug 1st through Oct 1st</font>
                                </cfcase>
                                <cfcase value="12">
                                    Phase 2<br>
                                    <font size=-1>Due Dec 1st - includes information from Oct 1st through Dec 1st</font>
                                </cfcase>
                                <cfcase value="2">
                                    Phase 3<br>
                                    <font size=-1>Due Feb 1st - includes information from Dec 1st through Feb 1st</font>
                                </cfcase>
                                <cfcase value="4">
                                    Phase 4<br>
                                    <font size=-1>Due April 1st - includes information from Feb 1st through April 1st</font>
                                </cfcase>
                                <cfcase value="6">
                                    Phase 5<br>
                                    <font size=-1>Due June 1st - includes information from April 1st through June  1st</font>
                                </cfcase>
                                <cfcase value="8">
                                    Phase 6<br>
                                    <font size=-1>Due August 1st - includes information from June 1st through August 1st</font>
                                </cfcase>
                            </cfswitch>
                        </cfif>
                    </h2>
				</td>
			</tr>        
            <tr>
            	<th bgcolor="##cccccc" colspan="2">Report Information</th> 
			</tr>
            <tr align="center">
        		<td colspan="2">
                    <table cellpadding="4" cellspacing="0">
                        <tr>
                            <th align="right">Program Name:</th>
                            <td>#qGetProgram.programname# ###qGetProgram.programID#</td>
                        </tr>
                        <tr>
                            <th align="right">Second Visit Representative:</th>
                            <td>#qGetSecondVisitRep.firstname# #qGetSecondVisitRep.lastname# ###qGetSecondVisitRep.userID#</td>
                        </tr>
                        <tr>
                            <th align="right">Supervising Representative:</th>
                            <td>#qGetSupervisingRep.firstname# #qGetSupervisingRep.lastname# ###qGetSupervisingRep.userID#</td>
                        </tr>
                        <tr>
                            <th align="right">Placing Representative:</th>
                            <td>#qGetPlacingRepresentative.firstname# #qGetPlacingRepresentative.lastname# ###qGetPlacingRepresentative.userID#</td>
                        </tr>
                        <tr>
                            <th align="right">Regional Advisor:</th>
                        <td>
							<cfif qGetAdvisorInfo.recordCount>
                                #qGetAdvisorInfo.firstname# #qGetAdvisorInfo.lastname# ###qGetAdvisorInfo.userID#
                            <cfelse>
                            	Reports Directly to Regional Director
                            </cfif>
                        </td>
                        </tr>
                        <tr>
                            <th align="right">Regional Director:</th>
                            <td>#qGetRegionalManager.firstname# #qGetRegionalManager.lastname# ###qGetRegionalManager.userID#</td>
                        </tr>
                        <tr>
                            <th align="right">Facilitator:</th>
                            <td>#qGetFacilitator.firstname# #qGetFacilitator.lastname# ###qGetFacilitator.userID#</td>
                        </tr>
                        <tr>
                            <th align="right">Host Family:</th>
                            <td>
                                #qGetHostFamily.fatherfirstname#
                                <cfif NOT LEN(qGetHostFamily.fatherfirstname) AND NOT LEN(qGetHostFamily.motherfirstname)>&amp;</cfif>
                                #qGetHostFamily.motherfirstname#
                                #qGetHostFamily.familylastname# ###qGetHostFamily.hostID#
                            </td>
                        </tr>
                        <tr>
                            <th align="right">International Agent:</th>
                            <td>#qGetIntlRep.businessname# ###qGetIntlRep.userID#</td>
                        </tr>
                    </table>

                </td>
            </tr>
        </table>

        <table border="0" cellpadding="4" cellspacing="0" width="50%" class="section" align="center">
            <tr>
                <td align="center"><input name="Submit" type="image" src="pics/continue.gif" border="0"></td>
            </tr>
        </table>

		<!--- Table Footer --->
        <gui:tableFooter
            width="50%"
        />

	</form>

</cfoutput>