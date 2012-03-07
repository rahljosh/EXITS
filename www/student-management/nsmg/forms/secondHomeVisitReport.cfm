

	<!--- Import CustomTag Used for Page Messages and Form Errors--->
    <cfimport taglib="../extensions/customtags/gui/" prefix="gui" /> 
	
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_action" default="">
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
	<cfset allow_edit = 0>
    <cfset allow_approve = 0>
    <cfset allow_reject = 0>
    <cfset allow_delete = 0>

    <!--- Param URL Variables --->
    <cfparam name="URL.reportID" default="0">
    
    <cfif VAL(URL.reportID)>
        <cfset FORM.pr_id = URL.reportID>
    </cfif>
    
  
    
        <!----Edit Report---->
        <Cfif pr_action EQ 'edit_report'>
            <cfset FORM.performEdit = 1>
        </Cfif>
        
        <!--- approve report   
        <cfif pr_action is 'approve'>
        
            <cfquery name="get_report" datasource="#application.dsn#">
                SELECT *
                FROM progress_reports
                WHERE pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            
            <cfset approve_field = ''>
            
            <!--- in case the user has multiple approval levels, check them in order and just do the first one. --->
            <!--- supervising rep --->
            <cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ ''>
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
            </cfif>
            
            <cflocation url="index.cfm?curdoc=secondVisitReports">
       
        </cfif>
      ---->
  
	
	<!----Save Report---->
    
        <cfif pr_action is 'save'>
       
        <cfquery datasource="mysql">
                UPDATE 
                    secondVisitAnswers 
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
	
	
	
	<!--- LEN(FORM.pr_action) --->
    
    <Cfquery name="secondvisitanswers" datasource="#application.dsn#">
        select *
        from secondvisitanswers
        where fk_reportID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
    </cfquery>
    
    <Cfquery name="reportDates" datasource="#application.dsn#">
        select *
        from progress_reports
        where pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
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
                FORM.neighborhoodAppearance = secondVisitAnswers.neighborhoodAppearance;
                FORM.avoid = secondVisitAnswers.avoid;
                FORM.homeAppearance = secondVisitAnswers.homeAppearance;
                FORM.typeOfHome = secondVisitAnswers.typeOfHome;
                FORM.numberBedRooms = secondVisitAnswers.numberBedRooms;
                FORM.numberBathRooms = secondVisitAnswers.numberBathRooms;
                FORM.livingRoom = secondVisitAnswers.livingRoom;
                FORM.diningRoom = secondVisitAnswers.diningRoom;
                FORM.kitchen = secondVisitAnswers.kitchen;
                FORM.homeDetailsOther = secondVisitAnswers.homeDetailsOther;
                FORM.ownBed = secondVisitAnswers.ownBed;
                FORM.bathRoom = secondVisitAnswers.bathRoom;
                FORM.outdoorsFromBedroom = secondVisitAnswers.outdoorsFromBedroom;
                FORM.storageSpace = secondVisitAnswers.storageSpace;
                FORM.studySpace = secondVisitAnswers.studySpace;
                FORM.privacy = secondVisitAnswers.privacy;
                FORM.pets = secondVisitAnswers.pets;
                FORM.other = secondVisitAnswers.other;
                FORM.dateOfVisit = secondVisitAnswers.dateOfVisit;
             </cfscript>
	<cfset approve_error_msg = ''>
    
  
	<!--- FORM Submitted --->
	<cfif pr_action is 'approve'>
  
		  <cfscript>
                 // Set FORM Values   
                FORM.neighborhoodAppearance = secondVisitAnswers.neighborhoodAppearance;
                FORM.avoid = secondVisitAnswers.avoid;
                FORM.homeAppearance = secondVisitAnswers.homeAppearance;
                FORM.typeOfHome = secondVisitAnswers.typeOfHome;
                FORM.numberBedRooms = secondVisitAnswers.numberBedRooms;
                FORM.numberBathRooms = secondVisitAnswers.numberBathRooms;
                FORM.livingRoom = secondVisitAnswers.livingRoom;
                FORM.diningRoom = secondVisitAnswers.diningRoom;
                FORM.kitchen = secondVisitAnswers.kitchen;
                FORM.homeDetailsOther = secondVisitAnswers.homeDetailsOther;
                FORM.ownBed = secondVisitAnswers.ownBed;
                FORM.bathRoom = secondVisitAnswers.bathRoom;
                FORM.outdoorsFromBedroom = secondVisitAnswers.outdoorsFromBedroom;
                FORM.storageSpace = secondVisitAnswers.storageSpace;
                FORM.studySpace = secondVisitAnswers.studySpace;
                FORM.privacy = secondVisitAnswers.privacy;
                FORM.pets = secondVisitAnswers.pets;
                FORM.other = secondVisitAnswers.other;
                FORM.dateOfVisit = secondVisitAnswers.dateOfVisit;
             </cfscript>
             should be assigned
  
		<cfscript>
            // Data Validation
            // Neighborhood Appearance
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
            <cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ ''>
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
            </cfif>
            <!--- Successfully Updated - Go to Next Page --->
           <cflocation url="index.cfm?curdoc=secondVisitReports" addtoken="No">
           
           
           <!----
           
            <!---Auto approve the Submitting rep so REgional Manager can approve.---->
            <cfquery datasource="#application.dsn#">
                update 
                    progress_reports
                set 
                    pr_sr_approved_date = #now()#
               where 
                pr_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.pr_id#">
            </cfquery>
            ---->
           
            
        
		
        <!--- NOT SESSION.formErrors.length() --->
        
	<!--- FORM NOT SUBMITTED --->
    <cfelse>

         <cfscript>
             // Set FORM Values   
            FORM.neighborhoodAppearance = secondVisitAnswers.neighborhoodAppearance;
            FORM.avoid = secondVisitAnswers.avoid;
            FORM.homeAppearance = secondVisitAnswers.homeAppearance;
            FORM.typeOfHome = secondVisitAnswers.typeOfHome;
            FORM.numberBedRooms = secondVisitAnswers.numberBedRooms;
            FORM.numberBathRooms = secondVisitAnswers.numberBathRooms;
            FORM.livingRoom = secondVisitAnswers.livingRoom;
            FORM.diningRoom = secondVisitAnswers.diningRoom;
            FORM.kitchen = secondVisitAnswers.kitchen;
            FORM.homeDetailsOther = secondVisitAnswers.homeDetailsOther;
            FORM.ownBed = secondVisitAnswers.ownBed;
            FORM.bathRoom = secondVisitAnswers.bathRoom;
            FORM.outdoorsFromBedroom = secondVisitAnswers.outdoorsFromBedroom;
            FORM.storageSpace = secondVisitAnswers.storageSpace;
			FORM.studySpace = secondVisitAnswers.studySpace;
            FORM.privacy = secondVisitAnswers.privacy;
            FORM.pets = secondVisitAnswers.pets;
            FORM.other = secondVisitAnswers.other;
			FORM.dateOfVisit = secondVisitAnswers.dateOfVisit;
         </cfscript>
         
    </cfif>  
</cfif>
	<cfscript>
		// Get Student By UniqueID
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=reportDates.fk_student);
					CLIENT.studentID = reportDates.fk_student;
		
		// Program Information
		qGetProgramInfo = APPLICATION.CFC.PROGRAM.getPrograms(programid=qGetStudentInfo.programid);
		
		
		//Host Family Info
		qGetHosts = APPLICATION.CFC.HOST.getHosts(hostID=get_Report.fk_host);
		
	</cfscript>
    


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
	body{
	font-family:"Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif;
	font-size:12px;
	}
	p, h1, form, button{border:0; margin:0; padding:0;}
	.spacer{clear:both; height:1px;}
	/* ----------- My Form ----------- */
	.myform{
	margin:0 auto;
	width:600px;
	padding:14px;
	}
	
	/* ----------- stylized ----------- */
	#stylized{
	border:solid 2px #b7ddf2;
	background:#ebf4fb;
	}
	#stylized h1 {
	font-size:14px;
	font-weight:bold;
	margin-bottom:8px;
	}
	#stylized p{
	font-size:11px;
	color:#666666;
	margin-bottom:20px;
	border-bottom:solid 1px #b7ddf2;
	padding-bottom:10px;
	}
	#stylized label{
	display:block;
	font-weight:bold;
	text-align:right;
	width:190px;
	float:left;
	padding-right:15px;
	}
	#stylized .small{
	color:#666666;
	display:block;
	font-size:11px;
	font-weight:normal;
	text-align:right;
	width:190px;
	}
	
	#stylized .inputLabel{
	padding-right: 15px;
	vertical-align: top;
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
</style>

<cfoutput>

    <Cfset NumberList = '0,1,2,3,4,5,6,7,8,9,10'>
 
<!--- set the edit/approve/reject/delete access. --->
<cfset allow_edit = 0>
<cfset allow_approve = 0>
<cfset allow_reject = 0>
<cfset allow_delete = 0>
<cfset allow_save = 0>
<cfset show_save = 0>

<!--- used to display the pending message for the supervising rep. --->
<cfset pending_msg = 0>

<!--- users are allowed access until they approve the report.  Also, if a higher level has already approved then they are not allowed access. --->
<!--- supervising rep --->
<cfif CLIENT.userid EQ get_report.fk_sr_user and get_report.pr_sr_approved_date EQ '' and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 0>
	<cfset allow_delete = 1>
	<cfset pending_msg = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
    
<!--- regional advisor --->
<cfelseif CLIENT.userid EQ get_report.fk_ra_user and get_report.pr_ra_approved_date EQ '' and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- regional director --->
<cfelseif CLIENT.userid EQ get_report.fk_rd_user and get_report.pr_rd_approved_date EQ '' and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- facilitator --->
<cfelseif CLIENT.userid EQ get_report.fk_ny_user and get_report.pr_ny_approved_date EQ ''>
	<cfset allow_edit = 1>
    <cfset allow_approve = 1>
	<cfset allow_reject = 1>
	<cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
<!--- Program Manager - Office User - Gary request - 10/01/2010 - Managers should be able to approve progress reports --->
<cfelseif CLIENT.userType LTE 4 AND NOT LEN(get_report.pr_ny_approved_date)>
    <cfset allow_edit = 1>
	<cfset allow_approve = 1>
	<cfset allow_reject = 1>
    <cfset allow_delete = 1>
    <cfset allow_save = 1>
	<Cfset show_save = 1>
</cfif>
<!----toggle Edit/save function---->
<cfif form.pr_action is 'save' or form.pr_action is 'print'>
	<cfset allow_save = 0>

</cfif>
<cfif SESSION.formErrors.length()>
	<cfset allow_save =1>
    
</cfif>  

<div id="stylized" class="myform">
   <Cfoutput>
   
    <div align="right">
    	<a href="student/index.cfm?action=flightInformation&uniqueID=#qGetStudentInfo.uniqueID#&programID=#qGetStudentInfo.programID#" class="jQueryModal">Flight Information</a>
    </div>
	</Cfoutput>   
    <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
        <input type="hidden" name="studentName" value="#qGetStudentInfo.firstname#" />
        <input type="hidden" name="studentSex" value=<cfif qGetStudentInfo.firstname is 'male'>"his"<cfelse>"her"</cfif> >
        
        <!----<input type="hidden" name="pr_id" value="#FORM.pr_id#"/>
        <input type="hidden" name="pr_action" value="#FORM.pr_action#">
        <input type="hidden" name="submitted" value=1 />---->

	<cfif allow_approve and get_report.pr_rejected_date NEQ ''>
            <table border=0 cellpadding=4 cellspacing=0 align="Center">
                <tr>
                    <td><font color="FF0000">
                        This report has been rejected.  Approval will "unreject" this report.
                    </font></td>
                </tr>
            </table>
        </cfif>
            
        <h1>Second Host Family Home Visit</h1>
        <p>
        	<strong>Student:</strong> #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)<br />
            <strong>Report ID</strong> #FORM.pr_id#<br />
            <strong>Program:</strong> #qGetProgramInfo.programName#
        </p>

        <p>
            <strong>Family:</strong> #qGetHosts.fatherfirstname# <cfif qGetHosts.fatherfirstname is not ''>&amp;</cfif> #qGetHosts.motherfirstname# #qGetHosts.familylastname# <br />
            #qGetHosts.address#<br />
            <cfif #qGetHosts.address2# is not ''>#qGetHosts.address2# <br /></cfif>
            #qGetHosts.city# #qGetHosts.state#, #qGetHosts.zip#
        </p>

        <p>
        	<strong>Second Visit Representative::</strong> #get_second_rep.firstname# #get_second_rep.lastname# (#get_second_rep.userid#)<br />
            <strong>Supervising Representative::</strong> #get_rep.firstname# #get_rep.lastname# (#get_rep.userid#)<br />
            <strong>Placing Representative::</strong> #get_place_rep.firstname# #get_place_rep.lastname# (#get_place_rep.userid#)<br />
            <strong>Regional Advisor:</strong> <cfif get_report.fk_ra_user EQ ''>
                        Reports Directly to Regional Director
                    <cfelse>
                        #get_advisor_for_rep.firstname# #get_advisor_for_rep.lastname# (#get_advisor_for_rep.userid#)
                    </cfif><br />
            <strong>Regional Director:</strong> #get_regional_director.firstname# #get_regional_director.lastname# (#get_regional_director.userid#)<br />
            <strong>Facilitator:</strong> #get_facilitator.firstname# #get_facilitator.lastname# (#get_facilitator.userid#)
        </p>
        
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="divOnly"
            />
		<label>
           Date of Visit
            <span class="small">Date you visited the home</span>
        </label>
        <Cfif allow_save>
            <input type="text" name="dateOfVisit" value="#DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')#" class="datePicker">
        <cfelse>
            #DateFormat(FORM.dateofvisit, 'mm/dd/yyyy')#
        </Cfif>
        <br /><br /><br />
        <label>
            Neighborhood Appearance
            <span class="small">General look and feel</span>
        </label>
        
		<Cfif allow_save>
            <input type="radio" name="neighborhoodAppearance" id="name" value='Excellent' <cfif FORM.neighborhoodAppearance is 'Excellent'>checked</cfif> /> 
                <span class="inputLabel">Excellent</span>
            <input type="radio" name="neighborhoodAppearance" id="name" value='Average' <cfif FORM.neighborhoodAppearance is 'Average'>checked</cfif> /> 
                <span class="inputLabel">Average</span>
             <input type="radio" name="neighborhoodAppearance" id="name2" value='Poor' <cfif FORM.neighborhoodAppearance is 'Poor'>checked</cfif> />    
                <span class="inputLabel">Poor</span>
        <cfelse>
            #FORM.neighborhoodAppearance#
        </Cfif>
        
        <br /><br /><br />
        
        <label>
        	Neighborhood Location
            <span class="small">Is home in or near an area to be avoided.</span>
        </label>
        
		<Cfif allow_save>
            <input type="radio" value='Yes' name="avoid" <cfif FORM.avoid is 'Yes'>checked</cfif>/> <span class="inputLabel">Yes</span> 
            <input type="radio" value='No' name="avoid" <cfif FORM.avoid eq 'no'>checked</cfif> /> <span class="inputLabel">No</span>
        <cfelse>
            #FORM.avoid#
        </Cfif>

        <br /><br /><br />
        
        <label>
        	Home Appearance
            <span class="small">Cleanliness, Maintenance</span>
        </label>
        <Cfif allow_save>
            <input type="radio" name="homeAppearance" id="name" value='Excellent' <cfif FORM.homeAppearance is 'Excellent'>checked</cfif> /> <span class="inputLabel">Excellent</span>
            <input type="radio" name="homeAppearance" id="name" value='Average' <cfif FORM.homeAppearance is 'Average'>checked</cfif>/> <span class="inputLabel">Average</span> 
            <input type="radio" name="homeAppearance" id="name" value='Poor' <cfif FORM.homeAppearance is 'Poor'>checked</cfif>/> <span class="inputLabel">Poor</span>
        <cfelse>
            #FORM.homeAppearance#
        </Cfif>
        
        <br /><br /><br />

        <label>
        	Type of Home
	        <span class="small">&nbsp;</span>
        </label>
        <Cfif allow_save>
            <input type="radio" name="typeOfHome" id="name" value='Single Family' <cfif FORM.typeOfHome is 'Single Family'>checked</cfif> />
               <span class="inputLabel">Single Family</span>
            <input type="radio" name="typeOfHome" id="name" value='Condominium' <cfif FORM.typeOfHome is 'Condominium'>checked</cfif> /> 
              <span class="inputLabel">Condominium</span> 
            <input type="radio" name="typeOfHome" id="name" value='Apartment' <cfif FORM.typeOfHome is 'Apartment'>checked</cfif> /> 
              <span class="inputLabel">Apartment</span><br />
            <input type="radio" name="typeOfHome" id="name" value='Duplex' <cfif FORM.typeOfHome is 'Duplex'>checked</cfif> /> 
              <span class="inputLabel">Duplex</span>
            <input type="radio" name="typeOfHome" id="name" value='Mobile Home' <cfif FORM.typeOfHome is 'Mobile Home'>checked</cfif> /> 
              <span class="inputLabel">Mobile Home</span> 
        <cfelse>
            #FORM.typeOfHome#
        </Cfif>
        
        <br /><br /><br />
        
        <label>
        	Home Details
        	<span class="small">Short Descriptions<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /></span>
        </label>
        <span class="inputLabel">Bedrooms&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <Cfif allow_save>
            <select name="numberBedRooms">
                <option value=''></option>
              <cfloop list='#numberlist#' index=i>
                <option value=#i# <cfif FORM.numberBedRooms eq  i>selected</cfif>>#i#</option>
            </cfloop>
             </select>
         <cfelse>
            #FORM.numberBedRooms#
        </Cfif>
        
         <br />
         
        <span class="inputLabel">Bathrooms&nbsp;&nbsp;&nbsp;</span>     
        <Cfif allow_save>
             <select name="numberBathRooms">
                <option value=''></option>
              <cfloop list='#numberlist#' index=i>
                <option value=#i# <cfif FORM.numberBathRooms eq  #i#>selected</cfif>>#i#</option>
            </cfloop>
             </select>
        <cfelse>
            #FORM.numberBathRooms#
        </Cfif>
         <br />
        
         <span class="inputLabel">Living Room&nbsp;</span>
         <Cfif allow_save>
            <input type="text" name="livingRoom" id="name" size=25 value="#FORM.livingRoom#"/>
         <cfelse>
            #FORM.livingRoom#
         </Cfif>
        <br />
        
         <span class="inputLabel">Dining Room</span>
          <Cfif allow_save>
            <input type="text" name="diningRoom" id="name" size=25 value="#FORM.diningRoom#"/>
         <cfelse>
            #FORM.diningRoom#
         </Cfif>
         <br />
         
         <span class="inputLabel">Kitchen&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
         <Cfif allow_save>
            <input type="text" name="kitchen" id="name" size=25  value="#FORM.kitchen#"/>
         <cfelse>
            #FORM.kitchen#
         </Cfif>
         <br />
         
         <span class="inputLabel">Other&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
         <Cfif allow_save>
            <textarea name="homeDetailsOther" cols=20 rows=3>#FORM.homeDetailsOther#</textarea>
          <cfelse>
            #FORM.homeDetailsOther#
         </Cfif>
        <br /><br /><Br />
        <hr width=60% />
        <br />
        
          <label>Does #qGetStudentInfo.firstname# have 
            <cfif #qGetStudentInfo.sex# is 'male'>
              his
              <cfelse>her
            </cfif>  
            own permanet bed? 
            <span class="small">Bed may not be a futon or inflatable</span>
          </label>
          <Cfif allow_save>
            <input type="text" name="ownBed" size = 30 value="#FORM.ownBed#"/>
            <cfelse>
            #FORM.ownBed#
          </Cfif>
          <br /><Br /><Br />
          <label>Does #qGetStudentInfo.firstname# have access to a bathroom? 
            <span class="small"></span>
          </label>
          
          <Cfif allow_save>	
            <input type="text" name="bathRoom" size = 30 value="#FORM.bathRoom#"/>
            <cfelse>
            #FORM.bathRoom#
          </Cfif>
          <br /><Br /><Br />
          <label>Does #qGetStudentInfo.firstname# have access to the outdoors from 
            <cfif #qGetStudentInfo.sex# is 'male'>
              his
              <cfelse>her
            </cfif> 
            bedroom? 
            <span class="small">i.e. a door or window</span>
          </label>
          <br />
          <Cfif allow_save>	
            <input type="text" name="outdoorsFromBedroom" size = 30 value="#FORM.outdoorsFromBedroom#"/>
            <cfelse>
            #FORM.outdoorsFromBedroom#
          </Cfif>
          <br /><Br /><Br />
          <label>Does #qGetStudentInfo.firstname# have adequate storage space? 
            <span class="small"></span>
          </label>
          <Cfif allow_save>	
            <input type="text" name="storageSpace" size = 30 value="#FORM.storageSpace#"/>
            <cfelse>
            #FORM.storageSpace#
          </Cfif>
          <br /><Br /><Br />
          <label>Does #qGetStudentInfo.firstname# have privacy? 
            <span class="small">i.e. a door on their room</span>
          </label>
          <Cfif allow_save>	
            <input type="text" name="privacy" size = 30 value="#FORM.privacy#"/>
            <cfelse>
            #FORM.privacy#
          </Cfif>
          <br /><Br /><Br />
          <label>Does #qGetStudentInfo.firstname# have adequate study space? 
            <span class="small"></span>
          </label>
          <Cfif allow_save>	
            <input type="text" name="studySpace" size = 30 value="#FORM.studySpace#"/>
            <cfelse>
            #FORM.studySpace#
          </Cfif>
          <br /><Br /><Br />
          <label>Are there pets present in the home? 
            <span class="small">How many & what kind</span>
          </label>
          <Cfif allow_save>	
            <input type="text" name="pets"  value="#FORM.pets#" size = 30/>
            <cfelse>
            #FORM.pets#
          </Cfif>
          <br /><Br /><Br />
          <label>Other Comments 
            <span class="small"></span>
          </label>
          <Cfif allow_save>	
            <textarea name="other" cols="40" rows=5>#FORM.other#</textarea>
            <cfelse>
            #FORM.other#
          </Cfif>
          
          <br /><Br /><br />
        </p>
        <!----
        <div align="right" >
        <Cfif allow_save>
            <button type="submit">Verify & Submit Information</button>
        </cfif>
        </div>
	
        </form>
		---->
    </div>
    
	<!--- approve error messages. --->
    <cfif LEN(approve_error_msg)>
        <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
            <tr>
                <td><font color="FF0000">
                   	Approval is not allowed until the following missing information is entered:
                    <ul>
                	<!--- questions error message. --->
					<cfif listFind(approve_error_msg, 'question')>
                        <p><li>Questions: all questions must be answered.</li></p>
                    </cfif>
                    </ul>
                </font></td>
            </tr>
        </table>
    </cfif>
    
  <cfif allow_approve and get_report.pr_rejected_date NEQ ''>
        <table border=0 cellpadding=4 cellspacing=0 align="center" >
            <tr>
                <td><font color="FF0000">
                   	This report has been rejected.  Approval will "unreject" this report.
                </font></td>
            </tr>
        </table>
    </cfif>
    <br />
    <!----if printing don't show buttons---->
    <cfif form.pr_action is not 'print'>
 <table border=0 cellpadding=4 cellspacing=0 width=100% >
        <tr>
            <td align="center">
    
        <table border=0 align="center">
        <tr>
        
         <td>
        	<cfif show_save>
				<!--- save --->
                <cfif allow_save>
                    
                    <input type="hidden" name="pr_action" value="save">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/save50x58.png" alt="Approve Report" border=0>
                    
                <cfelse>
                    <img src="pics/buttons/save50x58BW.png" alt="Save Report" border=0>
                </cfif>
            <cfelse>
            		<img src="pics/buttons/save50x58BW.png" alt="Save Report" border=0>
            </cfif>
            </form>
          </td>
          <td width=10></td>
          <td>
          <cfif show_save>
          	<!--- edit --->
            <cfif not allow_save>
                <form action="index.cfm?curdoc=forms/secondHomeVisitReport" method="post" >
                <input type="hidden" name="pr_action" value="edit">
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/edit50x50.png" alt="Approve Report" border=0>
                
            <cfelse>
            	<img src="pics/buttons/edit50x50bw.png" alt="Edit Report" border=0>
            </cfif>
            </form>
            <cfelse>
            		<img src="pics/buttons/edit50x50bw.png" alt="Edit Report" border=0>
            </cfif>
          </td>
          
          
          <td width=30>&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td>
          	<!--- approve --->
           <cfif not allow_save>
            <cfif allow_approve>
                <form action="index.cfm?curdoc=forms/secondHomeVisitReport" method="post" onclick="return confirm('Are you sure you want to approve this report?  You will no longer be able to edit this report after approval.')">
                <input type="hidden" name="pr_action" value="approve">
                <input type="hidden" name="studentname" value="#qGetStudentInfo.firstname#">
                <cfif #qGetStudentInfo.sex# is 'male'>
              		<input type="hidden" name="studentsex" value="his">
              	<cfelse>
                	<input type="hidden" name="studentsex" value="her">
            	</cfif> 
                
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/approve50x50.png" alt="Approve Report" border=0>
                </form>
            <cfelse>
            	<img src="pics/buttons/approvebw50.png" alt="Approve Report" border=0>
            </cfif>
           <cfelse>
           		<img src="pics/buttons/approvebw50.png" alt="Approve Report" border=0>
           </cfif>
          </td>
          <td >&nbsp;&nbsp;</td>
          <td>
          	<!--- reject --->
            <cfif not allow_save>
				<cfif allow_reject>
                    <form action="index.cfm?curdoc=forms/pr_reject" method="post">
                    
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/reject50x50.png" alt="Reject Report" border=0>
                    </form>
                <cfelse>
                    <img src="pics/buttons/reject50x50bw.png" alt="Reject" border=0>
                </cfif>
          	<cfelse>
            	<img src="pics/buttons/reject50x50bw.png" alt="Reject" border=0>    
            </cfif>
            
          </td>
         <td>&nbsp;&nbsp;</td>
         <td>
          	<!--- delete --->
            <cfif allow_delete>
                <form action="index.cfm?curdoc=secondVisitReports" method="post" onclick="return confirm('Are you sure you want to delete this report?')">
                <input type="hidden" name="pr_action" value="delete_report">
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input name="Submit" type="image" src="pics/buttons/deleteFolder50x55.png" alt="Delete Report" border=0>
                </form>
            <cfelse>
            	<img src="pics/buttons/deleteFolder50x55bw.png" alt="Delete Report"  border=0>
            </cfif>
          </td>
          
		<!--- disable print and email for rejected reports. --->
        <cfif get_report.pr_rejected_date EQ ''>
              <td width="30">&nbsp;</td>
              <td>
                <!--- print --->
                <form action="forms/secondHomeVisitReport.cfm?p" method="post" target="_blank">
                <input type="hidden" name="pr_id" value="#form.pr_id#">
                <input type="hidden" name="pr_action" value="print">
                <input name="Submit" type="image" src="pics/buttons/Print50x50.png" alt="Print Report" border=0>
                </form>
                <!---<A href="progress_report_info.cfm?pr_id=#form.pr_id#&report_mode=print" title="Print Report" target="_blank"><img src="pics/printer.gif" border=0 align="absmiddle"> Print</A>--->
              </td>
            <cfif CLIENT.usertype LTE 4>
                
                <td>
                    <!--- email --->
                    <form action="index.cfm?curdoc=forms/pr_email" method="post">
                    <input type="hidden" name="pr_id" value="#form.pr_id#">
                    <input name="Submit" type="image" src="pics/buttons/email50x50.png" alt="Email Report" border=0>
                    </form>
                    <!---<a href="javascript:OpenLetter('../nsmg/reports/email_progress_report.cfm?number=#form.pr_id#');" title="Email Progress Report"><img src="pics/email.gif" border="0" align="absmiddle"> Email</a>--->
                </td>
            </cfif>
        </cfif>
        </tr>
      </table>

      <br /><br />
      <Cfoutput>
      <a href="index.cfm?curdoc=secondVisitReports&lastReport=#qGetStudentInfo.studentid####qGetStudentInfo.studentid#">Back to Second Visit Reports</a>
      </Cfoutput>          
            </td>
        </tr>
    </table>
    </cfif>

</cfoutput>
