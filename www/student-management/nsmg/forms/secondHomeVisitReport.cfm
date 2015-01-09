<!--- ------------------------------------------------------------------------- ----
	
	File:		secondHomeVisitReport.cfm
	Author:		Marcus Melo
	Date:		August 23, 2012
	Desc:		Second Visit Report Form

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.pr_id" default="0">
    <cfparam name="FORM.performEdit" default="0">
	<cfparam name="FORM.neighborhoodAppearance" default="">
    <cfparam name="FORM.avoid" default="">
    <cfparam name="FORM.homeAppearance" default="">
    <cfparam name="FORM.typeOfHome" default="">
    <cfparam name="FORM.numberBedRooms" default="0">
    <cfparam name="FORM.numberBathRooms" default="0">
    <cfparam name="FORM.livingRoom" default="">
    <cfparam name="FORM.diningRoom" default="">
    <cfparam name="FORM.kitchen" default="">
    <cfparam name="FORM.homeDetailsOther" default="">
    <cfparam name="FORM.ownBed" default="">
    <cfparam name="FORM.bathRoom" default="">
    <cfparam name="FORM.outdoorsFromBedroom" default="">
    <cfparam name="FORM.storageSpace" default="">
    <cfparam name="FORM.privacy" default="">
    <cfparam name="FORM.studySpace" default="">
    <cfparam name="FORM.pets" default="">
    <cfparam name="FORM.other" default="">
    <cfparam name="FORM.dateOfVisit" default="">
	
    <!--- set the edit/approve/reject/delete access. --->
	<cfset allow_edit=0>
    <cfset allow_approve=0>
    <cfset allow_reject=0>
    <cfset allow_delete=0>

    <!--- Param URL Variables --->
    <cfparam name="URL.reportID" default="0">
    
    <cfif VAL(URL.reportID)>
        <cfset FORM.pr_id = URL.reportID>
    </cfif>
  
  	<cfquery name="reportDates" datasource="#application.dsn#">
        select *
        from progress_reports
        where pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    
    <cfscript>
		// Get Student By UniqueID
        qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=reportDates.fk_student);
	</cfscript>
  
	<!----Edit Report---->
    <cfif pr_action EQ 'edit_report'>
        <cfset FORM.performEdit=1>
    </cfif>
	
	<!----Save Report---->
	<cfif pr_action EQ 'save'>
    
    	<!---<cfquery name="qCheckForReport" datasource="#APPLICATION.DSN#">
        	SELECT *
            FROM secondvisitanswers
            WHERE fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
        </cfquery>
        
        <cfif NOT VAL(qCheckForReport.recordCount)>
        	<cfquery datasource="#APPLICATION.DSN#">
            	INSERT INTO secondvisitanswers (fk_reportID, fk_studentID)
                VALUES(
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentID#">
                )
            </cfquery>
        </cfif>--->
     
        <cfquery datasource="#application.dsn#">
            UPDATE 
                secondvisitanswers 
            SET
                dateOfVisit = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#FORM.dateOfVisit#">,
                neighborhoodAppearance= <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.neighborhoodAppearance#">,
                avoid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.avoid#">,
                homeAppearance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeAppearance#">,
                typeOfHome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.typeOfHome#">,
                numberBedRooms = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.numberBedRooms)#">,
                numberBathRooms = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(FORM.numberBathRooms)#">,
                livingRoom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.livingRoom#">,
                diningRoom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.diningRoom#">,
                kitchen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.kitchen#">,
                homeDetailsOther = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.homeDetailsOther#">,
                ownBed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ownBed#">,
                bathRoom =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.bathRoom#">,
                outdoorsFromBedroom = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.outdoorsFromBedroom#">,
                storageSpace = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.storageSpace#">,
                studySpace = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.studySpace#">,
                privacy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.privacy#">,
                pets = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.pets#">,
                other =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.other#">
            WHERE 
                fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">                  
        </cfquery>
        
	</cfif>
	
    <cfquery name="secondvisitanswers" datasource="#application.dsn#">
        select *
        from secondvisitanswers
        where fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>

    <cfquery name="get_report" datasource="#application.dsn#">
        SELECT *
        FROM progress_reports
        WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    
    <cfquery name="get_second_rep" datasource="#application.dsn#">
        SELECT userid, firstname, lastname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_secondVisitRep#">
    </cfquery>
    
    <cfquery name="get_rep" datasource="#application.dsn#">
        SELECT userid, firstname, lastname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_sr_user#">
    </cfquery>
    
    <cfif get_report.fk_pr_user is not ''>
        <cfquery name="get_place_rep" datasource="#application.dsn#">
            SELECT userid, firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_pr_user#">
    	</cfquery>
	<cfelse>
		<cfset get_place_rep.firstname = 'Not Originally'>
        <cfset get_place_rep.lastname = 'Recorded'>
        <cfset get_place_rep.userid = ''>
	</cfif>
    
	<cfif get_report.fk_ra_user NEQ ''>
        <cfquery name="get_advisor_for_rep" datasource="#application.dsn#">
            SELECT userid, firstname, lastname
            FROM smg_users
            WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ra_user#">
        </cfquery>
    </cfif>
    
    <cfquery name="get_regional_director" datasource="#application.dsn#">
        SELECT userid, firstname, lastname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_rd_user#">
    </cfquery>
    
    <cfquery name="get_facilitator" datasource="#application.dsn#">
        SELECT userid, firstname, lastname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_ny_user#">
    </cfquery>
    
    <cfquery name="get_host_family" datasource="#application.dsn#">
        SELECT hostid, familylastname, fatherfirstname, motherfirstname
        FROM smg_hosts
        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_host#">
    </cfquery>
    
    <cfquery name="get_international_rep" datasource="#application.dsn#">
        SELECT userid, businessname
        FROM smg_users
        WHERE userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_report.fk_intrep_user#">
    </cfquery>
    
    <cfscript>
		// Set FORM Values   
		FORM.neighborhoodAppearance = secondvisitanswers.neighborhoodAppearance;
		FORM.avoid = secondvisitanswers.avoid;
		FORM.homeAppearance = secondvisitanswers.homeAppearance;
		FORM.typeOfHome = secondvisitanswers.typeOfHome;
		FORM.numberBedRooms = secondvisitanswers.numberBedRooms;
		FORM.numberBathRooms = secondvisitanswers.numberBathRooms;
		FORM.livingRoom = secondvisitanswers.livingRoom;
		FORM.diningRoom = secondvisitanswers.diningRoom;
		FORM.kitchen = secondvisitanswers.kitchen;
		FORM.homeDetailsOther = secondvisitanswers.homeDetailsOther;
		FORM.ownBed = secondvisitanswers.ownBed;
		FORM.bathRoom = secondvisitanswers.bathRoom;
		FORM.outdoorsFromBedroom = secondvisitanswers.outdoorsFromBedroom;
		FORM.storageSpace = secondvisitanswers.storageSpace;
		FORM.studySpace = secondvisitanswers.studySpace;
		FORM.privacy = secondvisitanswers.privacy;
		FORM.pets = secondvisitanswers.pets;
		FORM.other = secondvisitanswers.other;
		FORM.dateOfVisit = secondvisitanswers.dateOfVisit;
		approve_error_msg = '';
	</cfscript>
    
	<!--- FORM Submitted --->
	<cfif pr_action EQ 'approve'>
  
		<cfscript>
			// Data Validation
			//Date is within range.
			if ( isDate(FORM.dateOfVisit) AND ( FORM.dateOfVisit LT secondvisitanswers.dueFromDate OR FORM.dateOfVisit GT secondvisitanswers.dueToDate ) ) {
			SESSION.formErrors.Add("Contact date must be between #dateFormat(secondvisitanswers.dueFromDate, 'mm/dd/yyyy')# and #dateFormat(secondvisitanswers.dueToDate, 'mm/dd/yyyy')#");
		}	
            // Date of Visit
            if ( NOT LEN(TRIM(FORM.dateOfVisit)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please enter the date you visited the home.");
            }	
			
            // Neighborhood Appearance
            if ( NOT LEN(TRIM(FORM.neighborhoodAppearance)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the neighboorhoods appearance.");
            }	
            
            // Neighborhood Location
            if ( NOT LEN(TRIM(FORM.avoid)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the neighboorhoods location.");
            }
            
            // Home Appearance
            if ( NOT LEN(TRIM(FORM.homeAppearance)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the homes appearance.");
            }
            
            // Home Type
            if ( NOT LEN(TRIM(FORM.typeOfHome)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the type of home.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.numberBedRooms)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the number of bedrooms.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.numberBathRooms)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate the number of bathrooms.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.livingRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the living room.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.diningRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the dining room.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.kitchen)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please describe the kitchen.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.ownBed)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if #FORM.studentName# has #FORM.studentSex# own bed.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.bathRoom)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if #FORM.studentName# has access to #FORM.studentSex# own bathroom.");
            }
           
            // Home detials
            if ( NOT LEN(TRIM(FORM.storageSpace)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if #FORM.studentName# has adequete storage space.");
            }
              // Home detials
            if ( NOT LEN(TRIM(FORM.studySpace)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if #FORM.studentName# has adequete study space.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.privacy)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate if #FORM.studentName# has adequete privacy.");
            }
            
            // Home detials
            if ( NOT LEN(TRIM(FORM.pets)) ) {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please indicate how many and what kind of pets are in the home.");
            }
        </cfscript>

		<!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
           
           <cfquery name="get_report" datasource="#application.dsn#">
                SELECT *
                FROM progress_reports
                WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            
            <cfset approve_field = ''>
            
            <!--- in case the user has multiple approval levels, check them in order and just do the first one. --->
            <!--- supervising rep --->
            <cfif CLIENT.userid EQ get_report.fk_secondVisitRep and get_report.pr_sr_approved_date EQ ''>
                <cfset approve_field = 'pr_sr_approved_date'>
            <!--- regional advisor --->
            <cfelseif CLIENT.userid EQ get_report.fk_ra_user and get_report.pr_ra_approved_date EQ ''>
                <cfset approve_field = 'pr_ra_approved_date'>
            <!--- regional director --->
            <cfelseif CLIENT.userid EQ get_report.fk_rd_user and get_report.pr_rd_approved_date EQ ''>
                <cfset approve_field = 'pr_rd_approved_date'>
            <!--- facilitator OR any office user --->
            <cfelseif get_report.pr_ny_approved_date EQ '' AND (CLIENT.userid EQ get_report.fk_ny_user OR CLIENT.userType LTE 4)>
                <cfset approve_field = 'pr_ny_approved_date'>
            </cfif>
            
            <cfif approve_field NEQ ''>
                <cfquery datasource="#application.dsn#">
                    UPDATE 
                    	progress_reports 
                    SET
                    	#approve_field# = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    	pr_rejected_date = NULL
                    WHERE 
                    	pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
                </cfquery>
                
                <cfif approve_field eq 'pr_ny_approved_date' and get_report.pr_sr_approved_date eq ''>
                	<cfquery datasource="#application.dsn#">
                    UPDATE 
                    	progress_reports 
                    SET
                    	pr_sr_approved_date  = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    	pr_rejected_date = NULL
                    WHERE 
                    	pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
                	</cfquery>
                </cfif>
            </cfif>
            <!--- Successfully Updated - Go to Next Page --->
           <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="No">
        
	<!--- FORM NOT SUBMITTED --->
    <cfelse>

         <cfscript>
            // Set FORM Values   
            FORM.neighborhoodAppearance = secondvisitanswers.neighborhoodAppearance;
            FORM.avoid = secondvisitanswers.avoid;
            FORM.homeAppearance = secondvisitanswers.homeAppearance;
            FORM.typeOfHome = secondvisitanswers.typeOfHome;
            FORM.numberBedRooms = secondvisitanswers.numberBedRooms;
            FORM.numberBathRooms = secondvisitanswers.numberBathRooms;
            FORM.livingRoom = secondvisitanswers.livingRoom;
            FORM.diningRoom = secondvisitanswers.diningRoom;
            FORM.kitchen = secondvisitanswers.kitchen;
            FORM.homeDetailsOther = secondvisitanswers.homeDetailsOther;
            FORM.ownBed = secondvisitanswers.ownBed;
            FORM.bathRoom = secondvisitanswers.bathRoom;
            FORM.outdoorsFromBedroom = secondvisitanswers.outdoorsFromBedroom;
            FORM.storageSpace = secondvisitanswers.storageSpace;
			FORM.studySpace = secondvisitanswers.studySpace;
            FORM.privacy = secondvisitanswers.privacy;
            FORM.pets = secondvisitanswers.pets;
            FORM.other = secondvisitanswers.other;
			FORM.dateOfVisit = secondvisitanswers.dateOfVisit;
         </cfscript>
             
        </cfif>  
        
    </cfif>

	<cfscript>
        
        CLIENT.studentID = reportDates.fk_student;
        
        // Program Information
        qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programid=qGetStudentInfo.programid);
        
        //Host Family Info
        qGetHosts = APPLICATION.CFC.HOST.getHosts(hostID=get_Report.fk_host);
    </cfscript>
    
     <!----Initial Answers on 1st Report ONLY show for office folks---->
    <cfscript>
   // Get Confidential Visit Form
		previousReport = APPLICATION.CFC.PROGRESSREPORT.getVisitInformation(hostID=VAL(qGetHosts.hostid),reportType=5);
    </cfscript>
    
    
	<cfset NumberList = '0,1,2,3,4,5,6,7,8,9,10'>
     
    <!--- set the edit/approve/reject/delete access. --->
    <cfset allow_edit=1>
    <cfset allow_approve=1>
    <cfset allow_reject=1>
    <cfset allow_delete=1>
    <cfset allow_save=1>
    <cfset show_save=1>
    
    <!--- used to display the pending message for the supervising rep. --->
    <cfset pending_msg=0>
    
    <!--- users are allowed access until they approve the report.  Also, if a higher level has already approved then they are not allowed access. --->
    <!--- supervising rep --->
    <cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ '' and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
        
        <cfset allow_edit=1>
        <cfset allow_approve=1>
        <cfset allow_reject=0>
        <cfset allow_delete=1>
        <cfset pending_msg=1>
        <cfset allow_save=1>
        <Cfset show_save=1>
        
    <!--- regional advisor --->
    <cfelseif CLIENT.userid EQ get_report.fk_ra_user and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
        
        <cfset allow_edit=1>
        <cfset allow_approve=1>
        <cfset allow_reject=1>
        <cfset allow_delete=1>
        <cfset allow_save=1>
        <Cfset show_save=1>
        
    <!--- regional director --->
    <cfelseif CLIENT.userid EQ get_report.fk_rd_user and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
        
        <cfset allow_edit=1>
        <cfset allow_approve=1>
        <cfset allow_reject=1>
        <cfset allow_delete=1>
        <cfset allow_save=1>
        <Cfset show_save=1>
        
    <!--- facilitator --->
    <cfelseif CLIENT.userid EQ get_report.fk_ny_user and get_report.pr_ny_approved_date EQ ''>
        
        <cfset allow_edit=1>
        <cfset allow_approve=1>
        <cfset allow_reject=1>
        <cfset allow_delete=1>
        <cfset allow_save=1>
        <Cfset show_save=1>
        
    <!--- Program Manager - Office User - Gary request - 10/01/2010 - Managers should be able to approve progress reports --->
    <cfelseif CLIENT.userType LTE 4 AND NOT LEN(get_report.pr_ny_approved_date)>
        
        <cfset allow_edit=1>
        <cfset allow_approve=1>
        <cfset allow_reject=1>
        <cfset allow_delete=1>
        <cfset allow_save=1>
        <Cfset show_save=1>
    
    <!--- DOS User - Read Only Version --->
    <cfelseif CLIENT.userType EQ 27>
    
        <cfset allow_edit=0>
        <cfset allow_approve=0>
        <cfset allow_reject=0>
        <cfset allow_delete=0>
        <cfset allow_save=0>
        <cfset show_save=0>
    
    </cfif>
    
    <!----toggle Edit/save function---->
    <cfif listFind("save,print", FORM.pr_action)>
        <cfset allow_save=0>
    </cfif>
    
    <cfif SESSION.formErrors.length()>
        <cfset allow_save=1>
    </cfif>  

</cfsilent>
    
<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script> 	

<style type="text/css">
	p, h1, form, button{border:0; margin:0; padding:0;}
	/* ----------- stylized ----------- */
	#stylized{
		border:solid 2px #b7ddf2;
		background:#ebf4fb;
		margin:0 auto;
		width:700px;
		padding:15px;		
	}
	#stylized h1 {
		font-size:1.4em;
		font-weight:bold;
		margin-bottom:10px;
	}
	#stylized p{
		font-size:1.1em;		
		color:#666666;
		margin-bottom:10px;
		border-bottom:solid 1px #b7ddf2;
		padding-bottom:10px;
	}
	#stylized label.title {
		display:table;
		font-weight:bold;
		text-align:right;
		width:250px;
		float:left;
		padding-right:15px;
	}
	#stylized .small {
		color:#666666;
		display:block;
		font-size:11px;
		font-weight:normal;
		text-align:right;
		width:250px;
		clear:both;		
	}
	#stylized .inputLabel{
		vertical-align: top;
		display:inline;
		padding:5px;
		margin:0px 3px 0px 3px;
	}
	#stylized .subTitle{
		width:90px;
		vertical-align: top;
		display:inline-table;
		margin-bottom:5px;
	}
	#stylized button{
		clear:both;
		margin-left:150px;
		width:125px;
		height:31px;
		background:#666666 url(img/button.png) no-repeat;
		text-align:center;
		line-height:31px;
		color:#FFFFFF;
		font-size:11px;
		font-weight:bold;
	}
	#stylized .item {
		display:table;
		margin:0px 0px 10px 0px;
		width:100%;
	}	
	#stylized .subItems {
		display:table;
		margin:0px;
	}
	#stylized .subItems input,
	#stylized .subItems select {
		margin-bottom:5px;	
	}
</style>

<cfoutput>

	<cfif FORM.pr_action EQ 'print'>
		<!--- Page Header --->
        <gui:pageHeader
            headerType="applicationNoHeader"
        />	
	</cfif>

    <form method="post" name="secondVisitReport" id="secondVisitReport" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
        <input type="hidden" name="studentName" value="#qGetStudentInfo.firstname#" />
        <input type="hidden" name="studentSex" value=<cfif qGetStudentInfo.firstname is 'male'>"his"<cfelse>"her"</cfif> >
        <input type="hidden" name="pr_action" value="save">
        <input type="hidden" name="pr_id" value="#FORM.pr_id#">
    
        <div id="stylized">
            
            <cfif FORM.pr_action NEQ 'print'>
                <div align="right">
                    <a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#" class="jQueryModal">Flight Information</a>
                </div>
            </cfif>
        
            
			<cfif allow_approve and get_report.pr_rejected_date NEQ ''>
                <table border="0" cellpadding="4" cellspacing="0" align="Center">
                    <tr>
                        <td><font color="FF0000">
                            This report has been rejected.  Approval will "unreject" this report.
                        </font></td>
                    </tr>
                </table>
            </cfif>
            
            <h1>Second Host Family Home Visit #FORM.pr_id#</h1>
            <p>
                <strong>Student:</strong> #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)<br />
                <strong>Report ID:</strong> #FORM.pr_id# #previousReport.fk_reportID#<br />
                <strong>Program:</strong> #qGetProgramInfo.programName#
            </p>

            <p>
                <strong>Family:</strong> #qGetHosts.fatherfirstname# <cfif qGetHosts.fatherfirstname is not ''>&amp;</cfif> #qGetHosts.motherfirstname# #qGetHosts.familylastname# (#qGetHosts.hostid#) <br />
                #qGetHosts.address#<br />
              <cfif #qGetHosts.address2# is not ''>#qGetHosts.address2# <br /></cfif>
                #qGetHosts.city# #qGetHosts.state#, #qGetHosts.zip#
          </p>
    
            <p>
                <strong>Second Visit Representative::</strong> #get_second_rep.firstname# #get_second_rep.lastname# (###get_second_rep.userid#)<br />
                <strong>Supervising Representative::</strong> #get_rep.firstname# #get_rep.lastname# (###get_rep.userid#)<br />
                <strong>Regional Advisor:</strong> 
					<cfif get_report.fk_ra_user EQ ''>
                        Reports Directly to Regional Director
                    <cfelse>
                        #get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (###get_advisor_for_rep.userid#)
                    </cfif><br />
                <strong>Regional Director:</strong> #get_regional_director.firstname# #get_regional_director.lastname# (###get_regional_director.userid#)<br />
                <strong>Facilitator:</strong> #get_facilitator.firstname# #get_facilitator.lastname# (###get_facilitator.userid#)<br />
                <strong>Placing Representative:</strong> #get_place_rep.firstname# #get_place_rep.lastname# (###get_place_rep.userid#)
          </p>
        
			<!--- Form Errors --->
            <gui:displayFormErrors 
            	formErrors="#SESSION.formErrors.GetCollection()#"
              	messageType="divOnly"
				/>
          
            <div class="item">
                <label class="title">
                    Date of Visit
                    <span class="small">Date you visited the home</span>
                </label>
                <cfif allow_save>
                    <input type="text" name="dateOfVisit" value="#DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')#" class="datePicker">
                    <cfif isDate(secondvisitanswers.dueFromDate) AND isDate(secondvisitanswers.dueToDate)>
                        <p>Visit must be between #DateFormat(secondvisitanswers.dueFromDate, 'mm/dd/yyyy')# and #DateFormat(secondvisitanswers.dueToDate, 'mm/dd/yyyy')#</p>
                    </cfif>
                <cfelse>
                    #DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')#
                </cfif>
            </div>

            
            <div class="item">
                <label class="title">
                    Neighborhood Appearance
                    <span class="small">General look and feel</span>
                  
                </label>
                <cfif allow_save>
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearanceExcellent" value='Excellent' <cfif FORM.neighborhoodAppearance is 'Excellent'>checked</cfif> /> 
                    <label for="neighborhoodAppearanceExcellent" class="inputLabel">Excellent</label>
                    
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearanceAverage" value='Average' <cfif FORM.neighborhoodAppearance is 'Average'>checked</cfif> /> 
                    <label for="neighborhoodAppearanceAverage" class="inputLabel">Average</label>
                    
                    <input type="radio" name="neighborhoodAppearance" id="neighborhoodAppearancePoor" value='Poor' <cfif FORM.neighborhoodAppearance is 'Poor'>checked</cfif> />    
                    <label for="neighborhoodAppearancePoor" class="inputLabel">Poor</label>
                <cfelse>
                    #FORM.neighborhoodAppearance#

                    
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.neighborhoodAppearance#</strong></em></cfif>
          </div>        
            
            
            <div class="item">
                <label class="title">
                    Neighborhood Location
                    <span class="small">Is home in or near an area to be avoided.</span>
                </label>
                <cfif allow_save>
                    <input type="radio" value='Yes' name="avoid" id="avoidYes" <cfif FORM.avoid is 'Yes'>checked</cfif>/> 
                    <label for="avoidYes" class="inputLabel">Yes</label> 
                    
                    <input type="radio" value='No' name="avoid" id="avoidNo" <cfif FORM.avoid eq 'no'>checked</cfif> /> 
                    <label for="avoidNo" class="inputLabel">No</label>
                <cfelse>
                    #FORM.avoid#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.avoid#</strong></em></cfif>
            </div>            
            
            
            <div class="item">
                <label class="title">
                    Home Appearance
                    <span class="small">Cleanliness, Maintenance</span>
                </label>
                <cfif allow_save>
                    <input type="radio" name="homeAppearance" id="homeAppearanceExcellent" value='Excellent' <cfif FORM.homeAppearance is 'Excellent'>checked</cfif> /> 
                    <label for="homeAppearanceExcellent" class="inputLabel">Excellent</label>
                    
                    <input type="radio" name="homeAppearance" id="homeAppearanceAverage" value='Average' <cfif FORM.homeAppearance is 'Average'>checked</cfif>/> 
                    <label for="homeAppearanceAverage" class="inputLabel">Average</label> 
                    
                    <input type="radio" name="homeAppearance" id="homeAppearancePoor" value='Poor' <cfif FORM.homeAppearance is 'Poor'>checked</cfif>/> 
                    <label for="homeAppearancePoor" class="inputLabel">Poor</label>
                <cfelse>
                    #FORM.homeAppearance#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.homeAppearance#</strong></em></cfif>
            </div>            
            
            
            <div class="item">
                <label class="title">
                    Type of Home
                  
                </label>
                <cfif allow_save>
                    <div class="subItems">
                        <input type="radio" name="typeOfHome" id="typeOfHomeSingle" value='Single Family' <cfif FORM.typeOfHome is 'Single Family'>checked</cfif> />
                        <label for="typeOfHomeSingle" class="inputLabel">Single Family</label>
                        
                        <input type="radio" name="typeOfHome" id="typeOfHomeCondominium" value='Condominium' <cfif FORM.typeOfHome is 'Condominium'>checked</cfif> /> 
                        <label for="typeOfHomeCondominium" class="inputLabel">Condominium</label> 
                        
                        <input type="radio" name="typeOfHome" id="typeOfHomeApartment" value='Apartment' <cfif FORM.typeOfHome is 'Apartment'>checked</cfif> /> 
                        <label for="typeOfHomeApartment" class="inputLabel">Apartment</label> <br />
                        
                        <input type="radio" name="typeOfHome" id="typeOfHomeDuplex" value='Duplex' <cfif FORM.typeOfHome is 'Duplex'>checked</cfif> /> 
                        <label for="typeOfHomeDuplex" class="inputLabel">Duplex</label>
                        
                        <input for="" type="radio" name="typeOfHome" id="typeOfHomeMobile" value='Mobile Home' <cfif FORM.typeOfHome is 'Mobile Home'>checked</cfif> /> 
                        <label for="typeOfHomeMobile" class="inputLabel">Mobile Home</label> 
					
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.typeOfHome#</strong></em></cfif>
                    </div>
                <cfelse>
                    #FORM.typeOfHome#<br />
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.typeOfHome#</strong></em></cfif>
                </cfif>
                
            </div>            


            <div class="item">
                <label class="title">
                    Home Details
                    <span class="small">Short Descriptions</span>
                </label>
                
                <div class="subItems">
                
                    <label for="numberBedRooms" class="subTitle">Bedrooms</label>
                    <cfif allow_save>
                        <select name="numberBedRooms" id="numberBedRooms" class="xSmallField">
                            <option value=""></option>
                            <cfloop list='#numberlist#' index="i">
                                <option value="#i#" <cfif FORM.numberBedRooms eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </select>
                    <cfelse>
                        #FORM.numberBedRooms#
                    </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.numberBedRooms#</strong></em></cfif>
                  <br />
                 
                    <label for="numberBathRooms" class="subTitle">Bathrooms</label>     
                    <cfif allow_save>
                        <select name="numberBathRooms" id="numberBathRooms" class="xSmallField">
                            <option value=""></option>
                            <cfloop list='#numberlist#' index="i">
                                <option value="#i#" <cfif FORM.numberBathRooms eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </select>
                    <cfelse>
                        #FORM.numberBathRooms#
                    </cfif>
        			<cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.numberBathRooms#</strong></em></cfif>
                  <br />
                
                    <label for="livingRoom" class="subTitle">Living Room</label>
                    <cfif allow_save>
                        <input type="text" name="livingRoom" id="livingRoom" class="xLargeField" value="#FORM.livingRoom#"/>
                    <cfelse>
                        #FORM.livingRoom#
                    </cfif>
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.livingRoom#</strong></em></cfif>
                  <br />
                
                    <label for="diningRoom" class="subTitle">Dining Room</label>
                    <cfif allow_save>
                        <input type="text" name="diningRoom" id="diningRoom" class="xLargeField" value="#FORM.diningRoom#"/>
                    <cfelse>
                        #FORM.diningRoom#
                    </cfif>
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.diningRoom#</strong></em></cfif>
                  <br />
                    
                    <label for="kitchen" class="subTitle">Kitchen</label>
                    <cfif allow_save>
                        <input type="text" name="kitchen" id="kitchen" class="xLargeField"  value="#FORM.kitchen#"/>
                    <cfelse>
                        #FORM.kitchen#
                    </cfif>
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.kitchen#</strong></em></cfif>
                  <br />
                    
                    <label for="homeDetailsOther" class="subTitle">Other</label>
                    <cfif allow_save>
                        <textarea name="homeDetailsOther" id="homeDetailsOther" class="largeTextArea">#FORM.homeDetailsOther#</textarea>
                    <cfelse>
                        #FORM.homeDetailsOther#
                    </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.homeDetailsOther#</strong></em></cfif>
              </div>    
				                    
            </div>            
            
            
            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have <cfif qGetStudentInfo.sex is 'male'>his<cfelse>her</cfif> own permanent bed? 
                    <span class="small">Bed may not be a futon or inflatable<br />if two students, two seperate beds</span>
                </label>
                <cfif allow_save>
                    
                    <select name="ownBed">
                    	<option value="Solo bedroom - permanent bed" <cfif FORM.ownBed eq 'Solo bedroom - permanent bed'>selected</cfif>>Solo bedroom - permanent bed</option>
                        <option value="Shared bedroom - two permanent beds" <cfif FORM.ownBed eq 'Shared bedroom - two permanent beds'>selected</cfif>>Shared bedroom - two permanent beds</option>
                        <option value="No permanent bed" <cfif FORM.ownBed eq 'No permanent bed'>selected</cfif>>No permanent bed</option>
                    </select>
                <cfelse>
                    #FORM.ownBed#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.ownBed#</strong></em></cfif>
            </div>   
                     
                
                
            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have access to a bathroom?
                <span class="small">Shared, Private</span>
                </label>    
               
                <cfif allow_save>	
                    <input type="text" name="bathRoom" class="xLargeField" value="#FORM.bathRoom#"/>
                      <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.bathRoom#</strong></em></cfif>
                    
                <cfelse>
                    #FORM.bathRoom#<br />
                      <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.bathRoom#</strong></em></cfif>
                </cfif>
              
            </div>            
    
    
            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have access to the outdoors from <cfif qGetStudentInfo.sex is 'male'>his<cfelse>her</cfif> bedroom? 
                    <span class="small">i.e. a door or window</span>
                </label>
                <cfif allow_save>	
                    <input type="text" name="outdoorsFromBedroom" class="xLargeField" value="#FORM.outdoorsFromBedroom#"/>
                <cfelse>
                    #FORM.outdoorsFromBedroom#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.outdoorsFromBedroom#</strong></em></cfif>
            </div>            
    
    
            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have a closet and/or dresser that the exchange student can use to store his/her clothing and other belongings? </label>
                <cfif allow_save>	
                  
                    <select name="storageSpace">
                    	<option value="Yes - in the exchange student's room" <cfif FORM.storageSpace eq "Yes - in the exchange student's room">selected</cfif>>Yes - in the exchange student's room</option>
                        <option value="Yes - adjacent to the exchange student's room" <cfif FORM.storageSpace eq "Yes - adjacent to the exchange student's room">selected</cfif>>Yes - adjacent to the exchange student's room</option>
                        <option value="Yes - in another part of the home" <cfif FORM.storageSpace eq 'Yes - in another part of the home'>selected</cfif>>Yes - in another part of the home</option>
                         <option value="No - no storage for exchange student" <cfif FORM.storageSpace eq 'No - no storage for exchange student'>selected</cfif>>No - no storage for exchange student</option>
                    </select>
                <cfelse>
                    #FORM.storageSpace#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.storageSpace#</strong></em></cfif>
            </div>            
            
            
            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have privacy? 
                  <span class="small">i.e. a door on their room</span>
                </label>
                <cfif allow_save>	
                    <input type="text" name="privacy" class="xLargeField" value="#FORM.privacy#"/>
                <cfelse>
                    #FORM.privacy#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.privacy#</strong></em></cfif>
            </div>
    

            <div class="item">
                <label class="title">Does #qGetStudentInfo.firstname# have adequate study space?
                <span class="small">in bedroom or other room in home</span> </label>
                <cfif allow_save>	
                    
                       <select name="studySpace">
                    	<option value="In exchange student's room" <cfif FORM.studySpace eq "In exchange student's room">selected</cfif>>In exchange student's room</option>
                        <option value="In another part of the home" <cfif FORM.studySpace eq 'In another part of the home'>selected</cfif>>In another part of the home</option>
                        <option value="No place in home to study" <cfif FORM.studySpace eq 'No place in home to study'>selected</cfif>>No place in home to study</option>
                    </select>
                <cfelse>
                    #FORM.studySpace#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.studySpace#</strong></em></cfif>
            </div>
    
            <div class="item">
                <label class="title">Are there pets present in the home? 
                    <span class="small">How many & what kind</span>
                </label>
                <cfif allow_save>	
                    <input type="text" name="pets"  value="#FORM.pets#" class="xLargeField"/>
                <cfelse>
                    #FORM.pets#
                </cfif>
                <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.pets#</strong></em></cfif>
            </div>
    
            <div class="item">
                <label class="title">Other Comments</label>
                <cfif allow_save>	
                    <textarea name="other" class="xLargeTextArea">#FORM.other#</textarea>
                  <label class="title"><font color="##000000">Initial Report Answer:</font></label>  <cfif client.usertype lte 4><br /><em><strong> #previousReport.other#</strong></em></cfif>
                <cfelse>
                    #FORM.other#<br />
                    <cfif client.usertype lte 4><br /><em><strong>Initial Report Answer: #previousReport.other#</strong></em></cfif>
                </cfif>
                
            </div>

    	</div>

	</form>
    
	<!--- approve error messages. --->
    <cfif LEN(approve_error_msg)>
        <table border="0" cellpadding="4" cellspacing="0" width=100% class="section">
            <tr>
                <td>
                    <font color="FF0000">
                        Approval is not allowed until the following missing information is entered:
                        <ul>
                            <!--- questions error message. --->
                            <cfif listFind(approve_error_msg, 'question')>
                                <p><li>Questions: all questions must be answered.</li></p>
                            </cfif>
                        </ul>
                    </font>
                </td>
            </tr>
        </table>
    </cfif>
    
    <cfif allow_approve and get_report.pr_rejected_date NEQ ''>
        <table border="0" cellpadding="4" cellspacing="0" align="center" >
            <tr>
                <td>
                    <font color="FF0000">This report has been rejected.  Approval will "unreject" this report.</font>
                </td>
            </tr>
        </table>
    </cfif>
    
    <br />

    <!----if printing don't show buttons---->
    <cfif FORM.pr_action NEQ 'print'>
        <table border="0" cellpadding="4" cellspacing="0" width="700px" align="center">
            <tr>
                <td align="center">
                    <cfif show_save AND allow_save>
                        <input name="Submit" type="image" src="pics/buttons/save50x58.png" alt="Approve Report" border="0" onclick="javascript:secondVisitReport.submit();">
                    <cfelse>
                        <img src="pics/buttons/save50x58BW.png" alt="Save Report" border="0">
                    </cfif>
                </td>
                <td width=10></td>
                <td>
                	<!--- edit --->
                    <cfif show_save AND NOT allow_save>
                        <form action="index.cfm?curdoc=forms/secondHomeVisitReport" method="post" >
                            <input type="hidden" name="pr_action" value="edit">
                            <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                            <input name="Submit" type="image" src="pics/buttons/edit50x50.png" alt="Approve Report" border="0">
                        </form>                                                
                    <cfelse>
                        <img src="pics/buttons/edit50x50bw.png" alt="Edit Report" border="0">
                    </cfif>
                </td>
                <td width="30">&nbsp;</td>
                <td>
                    <!--- approve --->
                    <cfif NOT allow_save AND allow_approve>
                        <form action="index.cfm?curdoc=forms/secondHomeVisitReport" method="post" onclick="return confirm('Are you sure you want to approve this report?  You will no longer be able to edit this report after approval.')">
                            <input type="hidden" name="pr_action" value="approve">
                            <input type="hidden" name="studentname" value="#qGetStudentInfo.firstname#">
                            <cfif qGetStudentInfo.sex is 'male'>
                                <input type="hidden" name="studentsex" value="his">
                            <cfelse>
                                <input type="hidden" name="studentsex" value="her">
                            </cfif> 
                            <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                            <input name="Submit" type="image" src="pics/buttons/approve50x50.png" alt="Approve Report" border="0">
                        </form>
                    <cfelse>
                        <img src="pics/buttons/approvebw50.png" alt="Approve Report" border="0">
                    </cfif>
                </td>
                <td>&nbsp;</td>
                <td>
                    <!--- reject --->
                    <cfif NOT allow_save AND allow_reject>
                        <form action="index.cfm?curdoc=forms/pr_reject" method="post">
                            <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                            <input name="Submit" type="image" src="pics/buttons/reject50x50.png" alt="Reject Report" border="0">
                        </form>
                    <cfelse>
                        <img src="pics/buttons/reject50x50bw.png" alt="Reject" border="0">    
                    </cfif>
                </td>
                <td>&nbsp;</td>
                <td>
                    <!--- delete --->
                    <cfif allow_delete>
                        <form action="index.cfm?curdoc=secondVisitReports" method="post" onclick="return confirm('Are you sure you want to delete this report?')">
                            <input type="hidden" name="pr_action" value="deleteReport">
                            <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                            <input name="Submit" type="image" src="pics/buttons/deleteFolder50x55.png" alt="Delete Report" border="0">
                        </form>
                    <cfelse>
                        <img src="pics/buttons/deleteFolder50x55bw.png" alt="Delete Report"  border="0">
                    </cfif>
                </td>
            
                <!--- disable print and email for rejected reports. --->
                <cfif get_report.pr_rejected_date EQ ''>
                    <td width="30">&nbsp;</td>
                    <td>
                        <!--- print --->
                        <form action="forms/secondHomeVisitReport.cfm" method="post" target="_blank">
                            <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                            <input type="hidden" name="pr_action" value="print">
                            <input name="Submit" type="image" src="pics/buttons/Print50x50.png" alt="Print Report" border="0">
                        </form>
                    </td>
                    <cfif APPLICATION.CFC.USER.isOfficeUser()>
                        <td>
                            <!--- email --->
                            <form action="index.cfm?curdoc=forms/pr_email" method="post">
                                <input type="hidden" name="pr_id" value="#FORM.pr_id#">
                                <input name="Submit" type="image" src="pics/buttons/email50x50.png" alt="Email Report" border="0">
                            </form>
                        </td>
                    </cfif>
                </cfif>
            </tr>
            <tr>
                <td colspan="12" align="center">
                    <br />
                    <a href="index.cfm?curdoc=secondVisitReports&lastReport=#qGetStudentInfo.studentid####qGetStudentInfo.studentid#">Back to Second Visit Reports</a>
                </td>
            </tr>                
        </table>
            
    </cfif>

</cfoutput>