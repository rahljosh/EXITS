<cfajaxproxy cfc="extensions.components.cbc" jsclassname="CBC">

<!--- CHECK RIGHTS --->
<cfinclude template="check_rights.cfm">
<cfif isDefined('form.allocationSeasonID')>

<cfquery name="updateAllocations" datasource="#APPLICATION.dsn#">
	update smg_users_allocation
    	set augustAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.augustAllocation#">,
        	januaryAllocation = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.januaryAllocation#">
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userid#"> and seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.allocationSeasonID#">
</cfquery>
</cfif>
<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL variables --->
    <cfparam name="URL.action" default="">
    
    <!--- Param FORM variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.errors" default="">    
    <cfparam name="FORM.dateTrained" default="#DateFormat(now(), 'mm/dd/yyyy')#">
    <cfparam name="FORM.trainingID" default="0">
	<cfparam name="FORM.score" default="">
    
    <cfscript>
		// Get Current Season
		qGetCurrentSeason = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason();
		
		// Get Training Options
		qGetTrainingOptions = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(fieldKey='smgUsersTraining');
	
		// Get Training records for this user
		qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userID);
		
		// Get User Paperwork Struct
		stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=URL.userID);
	</cfscript>
	<Cfquery name="smgMediaRights" datasource="#APPLICATION.DSN#">
    select fk_companyid
    from smg_media_user_access
    where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </Cfquery>
	<cfquery name="availableRights" datasource="#APPLICATION.DSN#">
    select description, fieldid
    from applicationlookup
    where fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="userRole">
    and isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    <cfquery name="assignedRights" datasource="#APPLICATION.DSN#">
    select roleid
    from smg_users_role_jn
    where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userid#">
    </cfquery>
    <cfset userRights = ''>
    <Cfloop query="assignedRights">
    	<cfset userRights = #ListAppend(userrights, #roleid#)#>	
    </Cfloop>
	
	<!----Rep Info---->
    <cfquery name="rep_info" datasource="#APPLICATION.DSN#">
        SELECT 
        	smg_users.*, 
            smg_countrylist.countryname, 
            smg_insurance_type.type,
            smg_states.statename
            
        FROM 
        	smg_users
        LEFT JOIN 
        	smg_countrylist ON smg_users.country = smg_countrylist.countryid
        LEFT JOIN 
        	smg_insurance_type ON smg_users.insurance_typeid = smg_insurance_type.insutypeid
        LEFT JOIN
        	smg_states on smg_states.state = smg_users.state
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>
   
    <!---see if there are any reasons why account isn't enabled---->
    <cfquery name="disableReasonID" datasource="#application.dsn#">
    	SELECT
       		max(id) as id
    	FROM 
        	smg_accountdisabledhistory
        WHERE 
        	fk_userDisabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>
    
    <cfif val(disableReasonid.id)>
    
        <cfquery name="disableReason" datasource="#application.dsn#">
        	SELECT 
            	*
        	FROM 
            	smg_accountdisabledhistory
            WHERE 
            	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#disableReasonID.id#">
        </cfquery>
        
    </cfif>
 
    <!--- Check if logged in user has access to compliance --->
    <cfquery name="user_compliance" datasource="#APPLICATION.DSN#">
        SELECT 
        	userID, 
            compliance
        FROM 
        	smg_users
        WHERE 
        	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
    </cfquery>

    <cfquery name="qGetReferences" datasource="#application.dsn#">
        SELECT 
        	*
        FROM
        	smg_user_references
        WHERE
        	referencefor = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    </cfquery>	

    <!--- get the access level of the user viewed. If null, then user viewing won't have access to username, etc. --->
    <cfinvoke component="nsmg.cfc.user" method="get_access_level" returnvariable="uar_usertype">
        <cfinvokeargument name="userID" value="#rep_info.userID#">
    </cfinvoke>
    
    <cfswitch expression="#action#">
    
		<!--- delete access level. --->
        <cfcase value="delete_uar">
            
            <cfquery datasource="#APPLICATION.DSN#">
                DELETE FROM 
                	user_access_rights
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.id#">
            </cfquery>
            
        </cfcase>
        
		<!--- set default access level. --->
        <cfcase value="set_default_uar">
            
			<!--- set all others to no first --->
            <cfquery name="get_all_access" datasource="#APPLICATION.DSN#">
                SELECT 
                	uar.id
                FROM 
                	user_access_rights uar
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
                    
				<cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
               	
            </cfquery>
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	user_access_rights
                SET 
                	default_access = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE id 
                	IN (#valueList(get_all_access.id)#)
            </cfquery>
            
			<!--- set the selected to yes --->
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	user_access_rights
                SET 
                	default_access = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                WHERE 
                	id = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.id#">
            </cfquery>
        </cfcase>
        
		<!--- resend login info --->
        <cfcase value="resend_login">
            
            <cfquery name="get_user" datasource="#APPLICATION.DSN#">
                SELECT 
                	email, accountCreationVerified
                FROM 
                	smg_users
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
            </cfquery>
            
            <cfinvoke component="nsmg.cfc.email" method="send_mail">
                <cfinvokeargument name="email_to" value="#get_user.email#">
                <cfinvokeargument name="email_replyto" value="#CLIENT.email#">
                <cfinvokeargument name="email_subject" value="Login Information">
                <cfif get_user.accountCreationVerified eq 1>
                	<cfinvokeargument name="include_content" value="resend_login">
                <cfelse>
                	<cfinvokeargument name="include_content" value="newUserMoreInfo">
                </cfif>
                <cfinvokeargument name="userID" value="#URL.userID#">
            </cfinvoke>
            
        </cfcase>
        
		<!--- verify information. --->
        <cfcase value="verify_info">
            
            <cfquery datasource="#APPLICATION.DSN#">
                UPDATE 
                	smg_users
                SET 
                	last_verification = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            </cfquery>
            
			<cfset temp = DeleteClientVariable("verify_info")>
            <cflocation url="index.cfm?curdoc=initial_welcome" addtoken="no">
            
        </cfcase>
        
    </cfswitch>
 <!----Student Allocation---->
   <cfquery name="qAllAvailablePrograms" datasource="#APPLICATION.dsn#">
   SELECT 
			p.programID,
			p.programName,
            p.startDate,
            p.endDate,
            p.type,
			p.seasonid,
            p.companyid,
            s.season,
            p.fk_smg_student_app_programID,
						(SELECT count(studentid) as NoStudents
						 FROM smg_students s
						 WHERE s.programID = p.programid
                   		 AND  s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">)  as NoStudents,
                      (SELECT Month(startdate) as startMonth
						 FROM smg_programs
						 WHERE programID = p.programid
                   		)  as startMonth   
                        
        FROM 
        	smg_programs p
		LEFT JOIN smg_seasons s on s.seasonid = p.seasonid
	
        WHERE
			
            p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyid)> 
        	AND ( p.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.publicHS#" list="yes"> )
			)
        </cfif>
		order by seasonid desc
    </cfquery>
    
    <Cfquery name="availSeasons" dbtype="query">
    select distinct season, seasonid
    from qAllAvailablePrograms
    order by seasonid desc
    </Cfquery>
    
     <!---user allocations---->
    <cfquery name="userAllocations" datasource="#application.dsn#">
    SELECT 
    	a.augustAllocation, a.januaryAllocation, a.seasonid
    FROM 
    	smg_users_allocation a
    LEFT JOIN 
    	smg_seasons s on s.seasonid = a.seasonid
    WHERE 
    	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#"> 
    AND 
    	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    


	<cfscript>
        // Form Submitted 
        if ( VAL(FORM.submitted) ) {
    
            if (NOT IsDate(FORM.dateTrained)) {
                FORM.errors = "Please enter a valid date trained (mm/dd/yyyy)";
                FORM.dateTrained = '';
            }		

            if (NOT VAL(FORM.trainingID)) {
                FORM.errors = "Please select a training type";
            }		
            
            // DOS Certification
            if ( FORM.trainingID EQ 2 AND ( NOT LEN(FORM.score) OR NOT IsValid("float", FORM.score) ) ) {
                FORM.errors = "Please enter a score in decimal format eg 93.70";
            }
            
            // There are no errors
            if (NOT LEN(FORM.errors)) {
                
                // Make sure we have a valid decimal
                FORM.score = ReplaceNoCase(FORM.score, ",", ".");
            
                // Insert Training
                APPLICATION.CFC.USER.insertTraining (
                    userID=VAL(URL.userID),
                    officeuserID=VAL(CLIENT.userID), 
                    trainingID=FORM.trainingID,
                    dateTrained=FORM.dateTrained,
                    score=FORM.score					
                );
            
                // Re-set Form Variables
                FORM.dateTrained = '';
                FORM.trainingID = 0;
                FORM.score = '';
				
                // Get updated query
                qGetTraining = APPLICATION.CFC.USER.getTraining(userID=URL.userID);
            }
        }
    </cfscript>
    
	<!----Denial/Submit/Approve info history---->
    <Cfquery name="accountDisableHistory" datasource="#application.dsn#">
    select h.date, h.fk_whoDisabled, h.reason, h.accountAction, smg_users.firstname, smg_users.lastname
    from smg_accountdisabledhistory h
    left join smg_users on smg_users.userID = h.fk_whoDisabled
    where fk_userDisabled = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.userID#">
    order by date desc
    </Cfquery>
      <!--- ------------------------------------------------------------------------- ---->
		<!----CBC's---->
	  <!--- ------------------------------------------------------------------------- ---->
            
                <cfquery name="get_cbc_user" datasource="#APPLICATION.DSN#">
                    SELECT cbcid, userID, date_authorized , date_sent, notes, date_expired, requestid, smg_users_cbc.seasonid, flagcbc, smg_seasons.season, batchid
                    FROM smg_users_cbc
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = smg_users_cbc.seasonid
                    WHERE smg_users_cbc.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#"> 
                    AND familyid = '0'
                    <cfif CLIENT.companyid eq 10>
                        AND smg_users_cbc.companyid = 10
                    </cfif>
                    ORDER BY smg_seasons.season DESC
                </cfquery>
                            
                <cfquery name="check_hosts" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT h.hostid, familylastname, h.fatherssn, h.motherssn, date_sent, date_expired, smg_seasons.season, requestid, cbc.batchid, cbc.cbcfamid
                    FROM smg_hosts h
                    INNER JOIN smg_hosts_cbc cbc ON h.hostid = cbc.hostid
                    LEFT JOIN smg_seasons ON smg_seasons.seasonid = cbc.seasonid
                    
                    WHERE cbc.cbc_type = 'father' AND ((h.fatherssn = '#rep_info.ssn#' AND h.fatherssn != '') OR (h.fatherfirstname = '#rep_info.firstname#' AND h.fatherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.fatherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                    OR cbc.cbc_type = 'mother' AND ((h.motherssn = '#rep_info.ssn#' AND h.motherssn != '') OR (h.motherfirstname = '#rep_info.firstname#' AND h.motherlastname = '#rep_info.lastname#' <cfif rep_info.dob NEQ ''>AND h.motherdob = '#DateFormat(rep_info.dob,'yyyy/mm/dd')#'</cfif>))
                </cfquery>
                
                <cfquery name="currentSeasonCBC" dbtype="query">
                    select 
                    	date_sent
                    from 
                    	get_cbc_user
                    where 
                    	seasonid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCurrentSeason.seasonID)#"> 
                    and 
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.userID#"> 
                </cfquery>
                
                 <!----Regional Information---->
            <cfquery name="region_company_access" datasource="#APPLICATION.DSN#">
                SELECT 
                    uar.id, 
                    uar.regionid, 
                    uar.usertype, 
                    uar.changedate, 
                    uar.default_access, 
                    r.regionname, 
                    c.companyshort, 
                    c.companyID, 
                    ut.usertype AS usertypename,
                    adv.userID AS advisorid, 
                    adv.firstname, 
                    adv.lastname
                FROM 
                    user_access_rights uar
                LEFT JOIN 
                    smg_regions r ON uar.regionid = r.regionid
                INNER JOIN 
                    smg_companies c ON uar.companyid = c.companyid
                INNER JOIN 
                    smg_usertype ut ON uar.usertype = ut.usertypeid
                LEFT OUTER JOIN 
                    smg_users adv ON uar.advisorid = adv.userID
                WHERE 
                    uar.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rep_info.userID#">
                    
                <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
                    AND          
                        uar.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
                <cfelse>
                    AND          
                        uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#"> 
                </cfif>
                    
                ORDER BY 
                    uar.companyid, uar.regionid, uar.usertype
            </cfquery>
            
            <cfquery name="check_default" dbtype="query">
                SELECT id
                FROM region_company_access
                WHERE default_access = 1
            </cfquery>
            <!-- Random Colors-->
            <cfset numberList = 'one,two,three,four,five,six,seven'>
            
</cfsilent>

<body>

		<!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
		<div class="container">
			<h1 class="pull-left"><cfoutput>#rep_info.firstname# #rep_info.lastname#</cfoutput></h1>
			<ul class="pull-right breadcrumb">

			</ul>
		</div><!--/container-->
	</div><!--/breadcrumbs-->
	<!--=== End Breadcrumbs ===-->

			

		<!--=== Profile ===-->
		<div class="container content profile">
			<div class="row">
				<!--Left Sidebar-->
				<div class="col-md-3 md-margin-bottom-40">
					<img class="img-responsive profile-img margin-bottom-20" src="assets/img/team/img32-md.jpg" alt="">

					<ul class="list-group sidebar-nav-v1 margin-bottom-40" id="sidebar-nav-1">
						<li class="list-group-item active">
							<a href="page_profile.html"><i class="fa fa-bar-chart-o"></i> Overall</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_me.html"><i class="fa fa-user"></i> Profile</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_users.html"><i class="fa fa-group"></i> Users</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_projects.html"><i class="fa fa-cubes"></i> My Projects</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_comments.html"><i class="fa fa-comments"></i> Comments</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_history.html"><i class="fa fa-history"></i> History</a>
						</li>
						<li class="list-group-item">
							<a href="page_profile_settings.html"><i class="fa fa-cog"></i> Settings</a>
						</li>
					</ul>

					<div class="panel-heading-v2 overflow-h">
						<h2 class="heading-xs pull-left"><i class="fa fa-bar-chart-o"></i> Task Progress</h2>
						<a href="#"><i class="fa fa-cog pull-right"></i></a>
					</div>
					<h3 class="heading-xs">Web Design <span class="pull-right">92%</span></h3>
					<div class="progress progress-u progress-xxs">
						<div style="width: 92%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="92" role="progressbar" class="progress-bar progress-bar-u">
						</div>
					</div>
					<h3 class="heading-xs">Unify Project <span class="pull-right">85%</span></h3>
					<div class="progress progress-u progress-xxs">
						<div style="width: 85%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="85" role="progressbar" class="progress-bar progress-bar-blue">
						</div>
					</div>
					<h3 class="heading-xs">Sony Corporation <span class="pull-right">64%</span></h3>
					<div class="progress progress-u progress-xxs margin-bottom-40">
						<div style="width: 64%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="64" role="progressbar" class="progress-bar progress-bar-dark">
						</div>
					</div>

					<hr>

					<!--Notification-->
					<div class="panel-heading-v2 overflow-h">
						<h2 class="heading-xs pull-left"><i class="fa fa-bell-o"></i> Notification</h2>
						<a href="#"><i class="fa fa-cog pull-right"></i></a>
					</div>
					<ul class="list-unstyled mCustomScrollbar margin-bottom-20" data-mcs-theme="minimal-dark">
						<li class="notification">
							<i class="icon-custom icon-sm rounded-x icon-bg-red icon-line icon-envelope"></i>
							<div class="overflow-h">
								<span><strong>Albert Heller</strong> has sent you email.</span>
								<small>Two minutes ago</small>
							</div>
						</li>
						<li class="notification">
							<img class="rounded-x" src="assets/img/testimonials/img6.jpg" alt="">
							<div class="overflow-h">
								<span><strong>Taylor Lee</strong> started following you.</span>
								<small>Today 18:25 pm</small>
							</div>
						</li>
						<li class="notification">
							<i class="icon-custom icon-sm rounded-x icon-bg-yellow icon-line fa fa-bolt"></i>
							<div class="overflow-h">
								<span><strong>Natasha Kolnikova</strong> accepted your invitation.</span>
								<small>Yesterday 1:07 pm</small>
							</div>
						</li>
						<li class="notification">
							<img class="rounded-x" src="assets/img/testimonials/img1.jpg" alt="">
							<div class="overflow-h">
								<span><strong>Mikel Andrews</strong> commented on your Timeline.</span>
								<small>23/12 11:01 am</small>
							</div>
						</li>
						<li class="notification">
							<i class="icon-custom icon-sm rounded-x icon-bg-blue icon-line fa fa-comments"></i>
							<div class="overflow-h">
								<span><strong>Bruno Js.</strong> added you to group chating.</span>
								<small>Yesterday 1:07 pm</small>
							</div>
						</li>
						<li class="notification">
							<img class="rounded-x" src="assets/img/testimonials/img6.jpg" alt="">
							<div class="overflow-h">
								<span><strong>Taylor Lee</strong> changed profile picture.</span>
								<small>23/12 15:15 pm</small>
							</div>
						</li>
					</ul>
					<button type="button" class="btn-u btn-u-default btn-u-sm btn-block">Load More</button>
					<!--End Notification-->

					<div class="margin-bottom-50"></div>

					<!--Datepicker-->
					<form action="#" id="sky-form2" class="sky-form">
						<div id="inline-start"></div>
					</form>
					<!--End Datepicker-->
				</div>
				<!--End Left Sidebar-->

				<!-- Profile Content -->
				<div class="col-md-9">
					<div class="profile-body">
						<!--Service Block v3-->
						<div class="row margin-bottom-10">
							<div class="col-sm-6 sm-margin-bottom-20">
								<div class="service-block-v3 service-block-u">
									<i class="icon-users"></i>
									<span class="service-heading">Overall Visits</span>
									<span class="counter">52,147</span>

									<div class="clearfix margin-bottom-10"></div>

									<div class="row margin-bottom-20">
										<div class="col-xs-6 service-in">
											<small>Last Week</small>
											<h4 class="counter">1,385</h4>
										</div>
										<div class="col-xs-6 text-right service-in">
											<small>Last Month</small>
											<h4 class="counter">6,048</h4>
										</div>
									</div>
									<div class="statistics">
										<h3 class="heading-xs">Statistics in Progress Bar <span class="pull-right">67%</span></h3>
										<div class="progress progress-u progress-xxs">
											<div style="width: 67%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="67" role="progressbar" class="progress-bar progress-bar-light">
											</div>
										</div>
										<small>11% less <strong>than last month</strong></small>
									</div>
								</div>
							</div>

							<div class="col-sm-6">
								<div class="service-block-v3 service-block-blue">
									<i class="icon-screen-desktop"></i>
									<span class="service-heading">Overall Page Views</span>
									<span class="counter">324,056</span>

									<div class="clearfix margin-bottom-10"></div>

									<div class="row margin-bottom-20">
										<div class="col-xs-6 service-in">
											<small>Last Week</small>
											<h4 class="counter">26,904</h4>
										</div>
										<div class="col-xs-6 text-right service-in">
											<small>Last Month</small>
											<h4 class="counter">124,766</h4>
										</div>
									</div>
									<div class="statistics">
										<h3 class="heading-xs">Statistics in Progress Bar <span class="pull-right">89%</span></h3>
										<div class="progress progress-u progress-xxs">
											<div style="width: 89%" aria-valuemax="100" aria-valuemin="0" aria-valuenow="89" role="progressbar" class="progress-bar progress-bar-light">
											</div>
										</div>
										<small>15% higher <strong>than last month</strong></small>
									</div>
								</div>
							</div>
						</div><!--/end row-->
						<!--End Service Block v3-->
<hr>

						<!--Profile Blog-->
						<div class="panel panel-profile">
							<div class="panel-heading overflow-h">
								<h2 class="panel-title heading-sm pull-left"><i class="fa fa-tasks"></i>Contacts</h2>
								<a href="page_profile_users.html" class="btn-u btn-brd btn-brd-hover btn-u-dark btn-u-xs pull-right">View All</a>
							</div>
							<div class="panel-body">
								<div class="row">
									<div class="col-sm-6">
										<div class="profile-blog blog-border">
											<img class="rounded-x" src="assets/img/testimonials/img1.jpg" alt="">
											<div class="name-location">
												<strong>Mikel Andrews</strong>
												<span><i class="fa fa-map-marker"></i><a href="#">California,</a> <a href="#">US</a></span>
											</div>
											<div class="clearfix margin-bottom-20"></div>
											<p>Donec non dignissim eros. Mauris faucibus turpis volutpat sagittis rhoncus. Pellentesque et rhoncus sapien, sed ullamcorper justo.</p>
											<hr>
											<ul class="list-inline share-list">
												<li><i class="fa fa-bell"></i><a href="#">12 Notifications</a></li>
												<li><i class="fa fa-group"></i><a href="#">54 Followers</a></li>
												<li><i class="fa fa-twitter"></i><a href="#">Retweet</a></li>
											</ul>
										</div>
									</div>

									<div class="col-sm-6">
										<div class="profile-blog blog-border">
											<img class="rounded-x" src="assets/img/testimonials/img4.jpg" alt="">
											<div class="name-location">
												<strong>Natasha Kolnikova</strong>
												<span><i class="fa fa-map-marker"></i><a href="#">Moscow,</a> <a href="#">Russia</a></span>
											</div>
											<div class="clearfix margin-bottom-20"></div>
											<p>Donec non dignissim eros. Mauris faucibus turpis volutpat sagittis rhoncus. Pellentesque et rhoncus sapien, sed ullamcorper justo.</p>
											<hr>
											<ul class="list-inline share-list">
												<li><i class="fa fa-bell"></i><a href="#">37 Notifications</a></li>
												<li><i class="fa fa-group"></i><a href="#">46 Followers</a></li>
												<li><i class="fa fa-twitter"></i><a href="#">Retweet</a></li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>
						<!--End Profile Blog-->
						<hr>

						<div class="row margin-bottom-20">
							<!--Profile Post-->
							<div class="col-sm-6">
								<div class="panel panel-profile no-bg">
									<div class="panel-heading overflow-h">
										<h2 class="panel-title heading-sm pull-left"><i class="fa fa-key"></i>Access</h2>
										<a href="#"><i class="fa fa-cog pull-right"></i></a>
									</div>
									<div id="scrollbar" class=" panel-body no-padding mCustomScrollbar " data-mcs-theme="minimal-dark">
									
									<cfloop query="region_company_access">
									<cfset objSelections = {} />
									<cfset intIndex = RandRange( 1, ListLen( numberList ) ) />
									<cfset objSelections[ ListGetAt( numberList, intIndex ) ] = true />
										<cfoutput>
											<div class="profile-post color-#StructKeyList( objSelections )#">
										</cfoutput>
										
											<span class="profile-post-numb"><Cfoutput>#currentrow#</Cfoutput></span>
											  
											<div class="profile-post-in">
												<h3 class="heading-xs"><a href="#"><Cfoutput>#regionname#</Cfoutput></a>
												<span class="pull-right">
													<cfoutput>#companyshort#</cfoutput>
												</span></h3>
												<p><cfoutput>#usertypename#</cfoutput><span class="pull-right">
                                                   	<Cfoutput>
                                                   	<cfif default_access>
                                                    	<i class="fa fa-star style="color:green></i>
                                                	<cfelse>
														<a href="index.cfm?curdoc=user_info&action=set_default_uar&id=#id#&userID=#rep_info.userID#" title="Set as default."><i class="fa fa-star-o"></i></a>
													</cfif>
													 <cfif APPLICATION.CFC.USER.isOfficeUser() AND ( not (region_company_access.recordcount EQ 1 OR default_access))>
														<a href="index.cfm?curdoc=user_info&action=delete_uar&id=#id#&userID=#rep_info.userID#" onClick="return confirm('Are you sure you want to delete this Company & Regional Access record?')">
															<i class="fa fa-trash-o"></i>
														</a>                                                    
													</cfif>
													</Cfoutput>
													</span>
													</p>
											</div>
										</div>
									</cfloop>
									
									</div>
								</div>
							</div>
							<!--End Profile Post-->
		
							<!--Profile Event-->
							<div class="col-sm-6 md-margin-bottom-20">
								<div class="panel panel-profile no-bg">
									<div class="panel-heading overflow-h">
										<h2 class="panel-title heading-sm pull-left"><i class="fa fa-graduation-cap"></i>Training </h2>
										<a href="#"><i class="fa fa-cog pull-right"></i></a>
									</div>
									<div id="scrollbar2" class="panel-body no-padding mCustomScrollbar" data-mcs-theme="minimal-dark">
                    					<cfloop query="qGetTraining">
										<div class="profile-event">
											<div class="date-formats">
												<span><cfoutput>#qGetTraining.score#</cfoutput></span>
												<small><cfoutput> <cfif VAL(qGetTraining.has_passed)>
													Pass
												<cfelse>
													Fail
                                   				 </cfif>
													</cfoutput>
												</small>
											</div>
											<div class="overflow-h">
												<h3 class="heading-xs"><a href="#"><cfoutput>#qGetTraining.trainingName#</cfoutput></a></h3>
												<p><cfoutput> #DateFormat(qGetTraining.date_trained, 'mmmm d, yyyy')# 
												<cfif LEN(officeUser)><br><em>Recorded By:  #officeUser#</em></cfif>  
												</cfoutput></p>
											</div>
										</div>
										</cfloop>
									</div>
								</div>
							</div>
							<!--End Profile Event-->
						</div><!--/end row-->

						

						<div class="row">
							<!--Alert-->
							<div class="col-sm-7 sm-margin-bottom-30">
								<div class="panel panel-profile">
									<div class="panel-heading overflow-h">
										<h2 class="panel-title heading-sm pull-left"><i class="fa fa-send"></i> Background Checks</h2>
										<cfif CLIENT.usertype EQ 1 OR user_compliance.compliance EQ 1 OR APPLICATION.CFC.USER.hasUserRoleAccess(userID=CLIENT.userID, role="runCBC")>
                <a href="?curdoc=cbc/users_cbc&userID=#rep_info.userID#"><i class="fa fa-penicl pull-right"></i></a></cfif>
									</div>
									<div id="scrollbar3" class="panel-body no-padding mCustomScrollbar" data-mcs-theme="minimal-dark">
									
									
										<div class="alert-blocks alert-blocks-success alert-dismissable">
											<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
											<img class="rounded-x" src="assets/img/testimonials/img2.jpg" alt="">
											<div class="overflow-h">
												<strong class="color-green">Accepted. <small class="pull-right"><em>7 hours ago</em></small></strong>
												<p>Your friend request has been accepted.</p>
											</div>
										</div>
										<div class="alert-blocks alert-blocks-info alert-dismissable">
											<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
											<i class="icon-custom rounded-x icon-bg-blue fa fa-bolt"></i>
											<div class="overflow-h">
												<strong class="color-blue">Info <small class="pull-right"><em>2 days ago</em></small></strong>
												<p>Your friend request has been denied :)</p>
											</div>
										</div>
										<div class="alert-blocks alert-blocks-error alert-dismissable">
											<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
											<img class="rounded-x" src="assets/img/testimonials/img6.jpg" alt="">
											<div class="overflow-h">
												<strong class="color-red">Denied! <small class="pull-right"><em>2 days ago</em></small></strong>
												<p>Your friend request has been denied.</p>
											</div>
										</div>
										<div class="alert-blocks alert-dismissable">
											<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
											<i class="icon-custom rounded-x icon-bg-dark fa fa-magic"></i>
											<div class="overflow-h">
												<strong class="color-dark">Default <small class="pull-right"><em>Just now</em></small></strong>
												<p><strong>Adam Johnson's</strong> friend request pending..</p>
											</div>
										</div>
										<div class="alert-blocks alert-blocks-pending alert-dismissable">
											<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
											<i class="icon-custom rounded-x icon-bg-yellow fa fa-info"></i>
											<div class="overflow-h">
												<strong class="color-yellow">Pending <small class="pull-right"><em>Just now</em></small></strong>
												<p><strong>Adam Johnson's</strong> friend request pending..</p>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!--End Alert-->

							<div class="col-sm-5">
								<div class="panel panel-profile">
									<div class="panel-heading overflow-h">
										<h2 class="panel-title heading-sm pull-left"><i class="fa fa-comments-o"></i> Discussions</h2>
										<a href="page_profile_comments.html" class="btn-u btn-brd btn-brd-hover btn-u-dark btn-u-xs pull-right">View All</a>
									</div>
									<div id="scrollbar4" class="panel-body no-padding mCustomScrollbar" data-mcs-theme="minimal-dark">
										<div class="comment">
											<img src="assets/img/testimonials/img6.jpg" alt="">
											<div class="overflow-h">
												<strong>Taylor Lee<small class="pull-right"> 25m</small></strong>
												<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
												<ul class="list-inline comment-list">
													<li><i class="fa fa-heart"></i> <a href="#">23</a></li>
													<li><i class="fa fa-comments"></i> <a href="#">5</a></li>
												</ul>
											</div>
										</div>
										<div class="comment">
											<img src="assets/img/testimonials/img2.jpg" alt="">
											<div class="overflow-h">
												<strong>Miranda Clarsson<small class="pull-right"> 44m</small></strong>
												<p>Donec cursus, orci non posuere luctus, risus massa luctus nisi, sit amet cursus leo massa id arcu. Nunc tincidunt magna sit amet sapien congue.</p>
												<ul class="list-inline comment-list">
													<li><i class="fa fa-heart"></i> <a href="#">23</a></li>
													<li><i class="fa fa-comments"></i> <a href="#">5</a></li>
												</ul>
											</div>
										</div>
										<div class="comment">
											<img src="assets/img/testimonials/img4.jpg" alt="">
											<div class="overflow-h">
												<strong>Natasha Kolnikova<small class="pull-right"> 7h</small></strong>
												<p>Suspendisse est est, sollicitudin eget auctor et, pharetra eu sapien. Mauris mollis libero ac auctor iaculis.</p>
												<ul class="list-inline comment-list">
													<li><i class="fa fa-heart"></i> <a href="#">23</a></li>
													<li><i class="fa fa-comments"></i> <a href="#">5</a></li>
												</ul>
											</div>
										</div>
										<div class="comment">
											<img src="assets/img/testimonials/img1.jpg" alt="">
											<div class="overflow-h">
												<strong>Mikel Andrews<small class="pull-right"> 15h</small></strong>
												<p>Nam ut dolor cursus nibh aliquet bibendum in eget risus.</p>
												<ul class="list-inline comment-list">
													<li><i class="fa fa-heart"></i> <a href="#">20</a></li>
													<li><i class="fa fa-comments"></i> <a href="#">5</a></li>
												</ul>
											</div>
										</div>
										<div class="comment">
											<img src="assets/img/testimonials/img7.jpg" alt="">
											<div class="overflow-h">
												<strong>Edward Rooster<small class="pull-right"> 1d</small></strong>
												<p>Nam ut dolor cursus nibh aliquet bibendum in eget risus. Mauris mollis libero ac auctor iaculis.</p>
												<ul class="list-inline comment-list">
													<li><i class="fa fa-heart"></i> <a href="#">23</a></li>
													<li><i class="fa fa-comments"></i> <a href="#">5</a></li>
												</ul>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div><!--/end row-->

						<hr>

						<!--Table Search v1-->
						<div class="table-search-v1 margin-bottom-20">
							<div class="table-responsive">
								<table class="table table-hover table-bordered table-striped">
									<thead>
										<tr>
											<th>Name</th>
											<th class="hidden-sm">Description</th>
											<th>Headquarters</th>
											<th>Progress</th>
											<th style="width: 100px;">Status</th>
											<th>Contacts</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<a href="#">HP Enterprise Service</a>
											</td>
											<td class="td-width">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">USA</a>
													<a href="#">Palo Alto</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-u-red btn-block btn-u-xs"><i class="fa fa-sort-amount-desc margin-right-5"></i> Deep</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<a href="#">Samsung Electronics</a>
											</td>
											<td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">South Korea</a>
													<a href="#">Suwon</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="76" aria-valuemin="0" aria-valuemax="100" style="width: 76%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-block btn-u-dark btn-u-xs"><i class="icon-graph margin-right-5"></i> High</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<a href="#">LG</a>
											</td>
											<td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">South Korea</a>
													<a href="#">Seoul</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="77" aria-valuemin="0" aria-valuemax="100" style="width: 77%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-block btn-u-aqua btn-u-xs"><i class="fa fa-level-down margin-right-5"></i> Low</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<a href="#">Sony Corporation</a>
											</td>
											<td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">Japan</a>
													<a href="#">Tokyo</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="92" aria-valuemin="0" aria-valuemax="100" style="width: 92%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-block btn-u-yellow btn-u-xs"><i class="fa fa-arrows-v margin-right-5"></i> Middle</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<a href="#">Lenovo Group</a>
											</td>
											<td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">Chinese</a>
													<a href="#">Beijing</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="77" aria-valuemin="0" aria-valuemax="100" style="width: 77%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-block btn-u-green btn-u-xs"><i class="fa fa-level-up margin-right-5"></i> High</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<a href="#">Acer</a>
											</td>
											<td>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec porttitor arcu.</td>
											<td>
												<div class="m-marker">
													<a href="#"><i class="color-green fa fa-map-marker"></i></a>
													<a href="#" class="display-b">Taiwan</a>
													<a href="#">Taipei</a>
												</div>
											</td>
											<td>
												<div class="progress progress-u progress-xxs">
													<div class="progress-bar progress-bar-u" role="progressbar" aria-valuenow="77" aria-valuemin="0" aria-valuemax="100" style="width: 77%">
													</div>
												</div>
											</td>
											<td><button class="btn-u btn-block btn-u-blue btn-u-xs"><i class="icon-graph margin-right-5"></i> Stabile</button></td>
											<td>
												<span>1(123) 456</span>
												<span><a href="#">info@example.com</a></span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!--End Table Search v1-->

						<!-- Begin Table Search v2 -->
						<div class="table-search-v2">
							<div class="table-responsive">
								<table class="table table-bordered table-striped">
									<thead>
										<tr>
											<th>User Image</th>
											<th class="hidden-sm">About</th>
											<th>Status</th>
											<th>Contacts</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												<img class="rounded-x" src="assets/img/testimonials/img1.jpg" alt="">
											</td>
											<td class="td-width">
												<h3><a href="#">Sed nec elit arcu</a></h3>
												<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id commodo lacus. Fusce non malesuada ante. Donec vel arcu.</p>
												<small class="hex">Joined February 28, 2014</small>
											</td>
											<td>
												<span class="label label-success">Success</span>
											</td>
											<td>
												<ul class="list-inline s-icons">
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Facebook" href="#">
															<i class="fa fa-facebook"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Twitter" href="#">
															<i class="fa fa-twitter"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Dropbox" href="#">
															<i class="fa fa-dropbox"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Linkedin" href="#">
															<i class="fa fa-linkedin"></i>
														</a>
													</li>
												</ul>
												<span><a href="#">info@example.com</a></span>
												<span><a href="#">www.htmlstream.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<img class="rounded-x" src="assets/img/testimonials/img2.jpg" alt="">
											</td>
											<td>
												<h3><a href="#">Donec at aliquam est, a mattis mauris</a></h3>
												<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id commodo lacus. Fusce non malesuada ante. Donec vel arcu.</p>
												<small class="hex">Joined March 2, 2014</small>
											</td>
											<td>
												<span class="label label-info"> Pending</span>
											</td>
											<td>
												<ul class="list-inline s-icons">
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Facebook" href="#">
															<i class="fa fa-facebook"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Twitter" href="#">
															<i class="fa fa-twitter"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Dropbox" href="#">
															<i class="fa fa-dropbox"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Linkedin" href="#">
															<i class="fa fa-linkedin"></i>
														</a>
													</li>
												</ul>
												<span><a href="#">info@example.com</a></span>
												<span><a href="#">www.htmlstream.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<img class="rounded-x" src="assets/img/testimonials/img3.jpg" alt="">
											</td>
											<td>
												<h3><a href="#">Pellentesque semper tempus vehicula</a></h3>
												<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id commodo lacus. Fusce non malesuada ante. Donec vel arcu.</p>
												<small class="hex">Joined March 3, 2014</small>
											</td>
											<td>
												<span class="label label-warning">Expiring</span>
											</td>
											<td>
												<ul class="list-inline s-icons">
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Facebook" href="#">
															<i class="fa fa-facebook"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Twitter" href="#">
															<i class="fa fa-twitter"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Dropbox" href="#">
															<i class="fa fa-dropbox"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Linkedin" href="#">
															<i class="fa fa-linkedin"></i>
														</a>
													</li>
												</ul>
												<span><a href="#">info@example.com</a></span>
												<span><a href="#">www.htmlstream.com</a></span>
											</td>
										</tr>
										<tr>
											<td>
												<img class="rounded-x" src="assets/img/testimonials/img4.jpg" alt="">
											</td>
											<td>
												<h3><a href="#">Alesuada fames ac turpis egestas</a></h3>
												<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed id commodo lacus. Fusce non malesuada ante. Donec vel arcu.</p>
												<small class="hex">Joined March 4, 2014</small>
											</td>
											<td>
												<span class="label label-danger">Error!</span>
											</td>
											<td>
												<ul class="list-inline s-icons">
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Facebook" href="#">
															<i class="fa fa-facebook"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Twitter" href="#">
															<i class="fa fa-twitter"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Dropbox" href="#">
															<i class="fa fa-dropbox"></i>
														</a>
													</li>
													<li>
														<a data-placement="top" data-toggle="tooltip" class="tooltips" data-original-title="Linkedin" href="#">
															<i class="fa fa-linkedin"></i>
														</a>
													</li>
												</ul>
												<span><a href="#">info@example.com</a></span>
												<span><a href="#">www.htmlstream.com</a></span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						<!-- End Table Search v2 -->
					</div>
				</div>
				<!-- End Profile Content -->
			</div>
		</div><!--/container-->
		<!--=== End Profile ===-->

		<!--=== Footer Version 1 ===-->
		<div class="footer-v1">
			<div class="footer">
				<div class="container">
					<div class="row">
						<!-- About -->
						<div class="col-md-3 md-margin-bottom-40">
							<a href="index.html"><img id="logo-footer" class="footer-logo" src="assets/img/logo2-default.png" alt=""></a>
							<p>About Unify dolor sit amet, consectetur adipiscing elit. Maecenas eget nisl id libero tincidunt sodales.</p>
							<p>Duis eleifend fermentum ante ut aliquam. Cras mi risus, dignissim sed adipiscing ut, placerat non arcu.</p>
						</div><!--/col-md-3-->
						<!-- End About -->

						<!-- Latest -->
						<div class="col-md-3 md-margin-bottom-40">
							<div class="posts">
								<div class="headline"><h2>Latest Posts</h2></div>
								<ul class="list-unstyled latest-list">
									<li>
										<a href="#">Incredible content</a>
										<small>May 8, 2014</small>
									</li>
									<li>
										<a href="#">Best shoots</a>
										<small>June 23, 2014</small>
									</li>
									<li>
										<a href="#">New Terms and Conditions</a>
										<small>September 15, 2014</small>
									</li>
								</ul>
							</div>
						</div><!--/col-md-3-->
						<!-- End Latest -->

						<!-- Link List -->
						<div class="col-md-3 md-margin-bottom-40">
							<div class="headline"><h2>Useful Links</h2></div>
							<ul class="list-unstyled link-list">
								<li><a href="#">About us</a><i class="fa fa-angle-right"></i></li>
								<li><a href="#">Portfolio</a><i class="fa fa-angle-right"></i></li>
								<li><a href="#">Latest jobs</a><i class="fa fa-angle-right"></i></li>
								<li><a href="#">Community</a><i class="fa fa-angle-right"></i></li>
								<li><a href="#">Contact us</a><i class="fa fa-angle-right"></i></li>
							</ul>
						</div><!--/col-md-3-->
						<!-- End Link List -->

						<!-- Address -->
						<div class="col-md-3 map-img md-margin-bottom-40">
							<div class="headline"><h2>Contact Us</h2></div>
							<address class="md-margin-bottom-40">
								25, Lorem Lis Street, Orange <br />
								California, US <br />
								Phone: 800 123 3456 <br />
								Fax: 800 123 3456 <br />
								Email: <a href="mailto:info@anybiz.com" class="">info@anybiz.com</a>
							</address>
						</div><!--/col-md-3-->
						<!-- End Address -->
					</div>
				</div>
			</div><!--/footer-->

			<div class="copyright">
				<div class="container">
					<div class="row">
						<div class="col-md-6">
							<p>
								2015 &copy; All Rights Reserved.
								<a href="#">Privacy Policy</a> | <a href="#">Terms of Service</a>
							</p>
						</div>

						<!-- Social Links -->
						<div class="col-md-6">
							<ul class="footer-socials list-inline">
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Facebook">
										<i class="fa fa-facebook"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Skype">
										<i class="fa fa-skype"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Google Plus">
										<i class="fa fa-google-plus"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Linkedin">
										<i class="fa fa-linkedin"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Pinterest">
										<i class="fa fa-pinterest"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Twitter">
										<i class="fa fa-twitter"></i>
									</a>
								</li>
								<li>
									<a href="#" class="tooltips" data-toggle="tooltip" data-placement="top" title="" data-original-title="Dribbble">
										<i class="fa fa-dribbble"></i>
									</a>
								</li>
							</ul>
						</div>
						<!-- End Social Links -->
					</div>
				</div>
			</div><!--/copyright-->
		</div>
		<!--=== End Footer Version 1 ===-->
	</div><!--/wrapper-->

	<!--=== Style Switcher ===-->
	<i class="style-switcher-btn fa fa-cogs hidden-xs"></i>
	<div class="style-switcher animated fadeInRight">
		<div class="style-swticher-header">
			<div class="style-switcher-heading">Style Switcher</div>
			<div class="theme-close"><i class="icon-close"></i></div>
		</div>

		<div class="style-swticher-body">
			<!-- Theme Colors -->
			<div class="style-switcher-heading">Theme Colors</div>
			<ul class="list-unstyled">
				<li class="theme-default theme-active" data-style="default" data-header="light"></li>
				<li class="theme-blue" data-style="blue" data-header="light"></li>
				<li class="theme-orange" data-style="orange" data-header="light"></li>
				<li class="theme-red" data-style="red" data-header="light"></li>
				<li class="theme-light" data-style="light" data-header="light"></li>
				<li class="theme-purple last" data-style="purple" data-header="light"></li>
				<li class="theme-aqua" data-style="aqua" data-header="light"></li>
				<li class="theme-brown" data-style="brown" data-header="light"></li>
				<li class="theme-dark-blue" data-style="dark-blue" data-header="light"></li>
				<li class="theme-light-green" data-style="light-green" data-header="light"></li>
				<li class="theme-dark-red" data-style="dark-red" data-header="light"></li>
				<li class="theme-teal last" data-style="teal" data-header="light"></li>
			</ul>

			<!-- Theme Skins -->
			<div class="style-switcher-heading">Theme Skins</div>
			<div class="row no-col-space margin-bottom-20 skins-section">
				<div class="col-xs-6">
					<button data-skins="default" class="btn-u btn-u-xs btn-u-dark btn-block active-switcher-btn handle-skins-btn">Light</button>
				</div>
				<div class="col-xs-6">
					<button data-skins="dark" class="btn-u btn-u-xs btn-u-dark btn-block skins-btn">Dark</button>
				</div>
			</div>

			<hr>

			<!-- Layout Styles -->
			<div class="style-switcher-heading">Layout Styles</div>
			<div class="row no-col-space margin-bottom-20">
				<div class="col-xs-6">
					<a href="javascript:void(0);" class="btn-u btn-u-xs btn-u-dark btn-block active-switcher-btn wide-layout-btn">Wide</a>
				</div>
				<div class="col-xs-6">
					<a href="javascript:void(0);" class="btn-u btn-u-xs btn-u-dark btn-block boxed-layout-btn">Boxed</a>
				</div>
			</div>

			<hr>

			<!-- Theme Type -->
			<div class="style-switcher-heading">Theme Types and Versions</div>
			<div class="row no-col-space margin-bottom-10">
				<div class="col-xs-6">
					<a href="E-Commerce/index.html" class="btn-u btn-u-xs btn-u-dark btn-block">Shop UI <small class="dp-block">Template</small></a>
				</div>
				<div class="col-xs-6">
					<a href="One-Pages/Classic/index.html" class="btn-u btn-u-xs btn-u-dark btn-block">One Page <small class="dp-block">Template</small></a>
				</div>
			</div>

			<div class="row no-col-space">
				<div class="col-xs-6">
					<a href="Blog-Magazine/index.html" class="btn-u btn-u-xs btn-u-dark btn-block">Blog <small class="dp-block">Template</small></a>
				</div>
				<div class="col-xs-6">
					<a href="RTL/index.html" class="btn-u btn-u-xs btn-u-dark btn-block">RTL <small class="dp-block">Version</small></a>
				</div>
			</div>
		</div>
	</div><!--/style-switcher-->
	<!--=== End Style Switcher ===-->

	<!-- JS Global Compulsory -->
	<script type="text/javascript" src="assets/plugins/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="assets/plugins/jquery/jquery-migrate.min.js"></script>
	<script type="text/javascript" src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!-- JS Implementing Plugins -->
	<script type="text/javascript" src="assets/plugins/back-to-top.js"></script>
	<script type="text/javascript" src="assets/plugins/smoothScroll.js"></script>
	<script type="text/javascript" src="assets/plugins/counter/waypoints.min.js"></script>
	<script type="text/javascript" src="assets/plugins/counter/jquery.counterup.min.js"></script>
	<script type="text/javascript" src="assets/plugins/sky-forms-pro/skyforms/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="assets/plugins/scrollbar/js/jquery.mCustomScrollbar.concat.min.js"></script>
	<!-- JS Customization -->
	<script type="text/javascript" src="assets/js/custom.js"></script>
	<!-- JS Page Level -->
	<script type="text/javascript" src="assets/js/app.js"></script>
	<script type="text/javascript" src="assets/js/plugins/datepicker.js"></script>
	<script type="text/javascript" src="assets/js/plugins/style-switcher.js"></script>
	<script type="text/javascript">
		jQuery(document).ready(function() {
			App.init();
			App.initCounter();
			App.initScrollBar();
			Datepicker.initDatepicker();
			StyleSwitcher.initStyleSwitcher();
		});
	</script>
	<!--[if lt IE 9]>
	<script src="assets/plugins/respond.js"></script>
	<script src="assets/plugins/html5shiv.js"></script>
	<script src="assets/plugins/placeholder-IE-fixes.js"></script>
	<![endif]-->
</body>
</html>
