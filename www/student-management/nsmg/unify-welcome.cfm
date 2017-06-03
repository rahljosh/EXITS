<cfsilent>
	<cfparam name="url.caseOrder" default="lastPerCommentDate">
    <cfsetting requesttimeout="200">
    
    <!--- Set the default season --->
	<cfparam name="URL.seasonID" default="0">
    
    <!--- Get all of the seasons from AYP 13/14 - current --->
    <cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
    	SELECT *
        FROM smg_seasons
        WHERE datePaperworkStarted <= <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">
        AND seasonID >= 10
    </cfquery>
    
    <!--- Set the season --->
    <cfscript>
		vSelectedSeason = ListLast(ValueList(qGetSeasons.seasonID));
		if (VAL(URL.seasonID)) {
			vSelectedSeason = URL.seasonID;	
		}
	</cfscript>
    
	<!--- Old Initial Welcome for WEP and ESI --->
    <cfif ListFind("11", CLIENT.companyID)>
        <cflocation url="index.cfm?curdoc=old_initial_welcome" addtoken="no">
    </cfif>

	<!--- the number of weeks to display new items. --->
    <cfparam name="URL.new_weeks" default="2">

	<cfset new_date = dateFormat(dateAdd("ww", "-#URL.new_weeks#", now()), "mm/dd/yyyy")>
    
    <cfquery name="qNewsMessages" datasource="#application.dsn#">
        SELECT 
        	*
        FROM 
        	smg_news_messages
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="news">
        AND
        	expires > #now()# 
        AND
        	startdate < #now()#
        AND
        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.usertype#">
        <cfif CLIENT.companyID EQ 10 or CLIENT.companyID EQ 11 or CLIENT.companyID EQ 13 or CLIENT.companyID EQ 14>
        	AND
            	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfelse>
            AND
                companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="0,#CLIENT.companyID#" list="yes"> ) 
        </cfif>
        ORDER BY
        	startdate DESC
    </cfquery>

    <cfquery name="smg_pics" datasource="#application.dsn#" maxrows="1">
        SELECT 
            pictureid, 
            title, 
            description
        FROM 
            smg_pictures
        WHERE 
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
            rand()
    </cfquery> 

    <cfquery name="help_desk_user" datasource="#application.dsn#">
        SELECT 
        	helpdeskid, 
            title,
            category, 
            priority, 
            text, 
            status, 
            date, 
            submit.firstname as submit_firstname, submit.lastname as submit_lastname,
            assign.firstname as assign_firstname, assign.lastname as assign_lastname
        FROM 
        	smg_help_desk
        LEFT JOIN 
        	smg_users submit ON smg_help_desk.submitid = submit.userID
        LEFT JOIN 
        	smg_users assign ON smg_help_desk.assignid = assign.userID 
        
		<!--- Global Administrator Users --->
        <cfif CLIENT.usertype eq 1>
            WHERE 
                assignid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND 
                status = <cfqueryparam cfsqltype="cf_sql_varchar" value="initial">
        <!--- Field and Intl. Rep --->
        <cfelse>            
            WHERE 
                submitid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND
                status != <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
        </cfif>	
        
        ORDER BY 
        	status, 
            date
    </cfquery>

    <cfquery name="new_students" datasource="#application.dsn#">
        SELECT 
        	studentid, 
            dateapplication, 
            firstname, 
            familylastname
        FROM
        	smg_students
        WHERE 
        	dateapplication >= <cfqueryparam cfsqltype="cf_sql_date" value="#new_date#">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        <cfif CLIENT.usertype LTE 5>
            AND 
            	regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
        <cfelseif CLIENT.usertype EQ 6>
            <!--- get reps who the user is the advisor of, and in the company. --->
            <cfquery name="get_reps" datasource="#application.dsn#">
                SELECT DISTINCT 
                	userID 
                FROM
                	user_access_rights
                WHERE
                	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
                AND 

                (
                    advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                OR 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                )
            </cfquery>
            <!--- use val() so if get_reps has no results we get 0 instead of null and get no results. --->
            AND 
            	arearepid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#val(valueList(get_reps.userID))#" list="yes"> )
        <cfelseif CLIENT.usertype eq 7 or CLIENT.usertype eq 9>
            AND 
            	arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfif>
        ORDER BY 
        	dateapplication DESC
    </cfquery>

    <cfquery name="get_new_users" datasource="#application.dsn#">
        SELECT 
        	u.email, 
            u.userID, 
            u.firstname, 
            u.lastname, 
            u.city, 
            u.state, 
            u.datecreated,
            u.whocreated,
            u.active,
            uar.advisorid
        FROM 
        	smg_users u
        INNER JOIN 
        	user_access_rights uar ON u.userID = uar.userID
        WHERE 
        <cfif CLIENT.usertype gte 5>
           	uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
    	<cfelse>
        	uar.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        AND 
        	u.datecreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#new_date#">
        <!--- Do not display student view users. Managers shouldn't know who is looking at their kids --->
        AND	
        	uar.userType != <cfqueryparam cfsqltype="cf_sql_integer" value="9">
        ORDER BY 
        	u.datecreated DESC
    </cfquery>
    <!----Get a list of users that report to the person logged in, for displaying hierachy in missing docs section.---->
    <cfset userUnderList ='#client.userid#'>
	<cfquery name="usersUnder" datasource="#application.dsn#">
    select userid
    from user_access_rights
    where regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
    AND advisorid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
    and companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
    </cfquery>
    <cfloop query="usersUnder">
    <Cfset userUnderList = #ListAppend(userUnderList, userid)#> 
	</cfloop>
<!----Get students with issues that are not resolved in paperwork---->
        <cfquery name="qGetStudentWithMissingCompliance" datasource="#application.dsn#">
            select hh.studentid, hh.hostid, hh.historyid, ah.actions, s.firstname, s.familylastname, s.studentid, h.familylastname as hostLast, s.regionassigned, s.arearepid, u.firstname as repFirst, u.lastname as repLast, r.regionname
            from smg_hosthistory hh
            left join smg_students s on s.studentid = hh.studentid 
            left join applicationhistory ah on ah.foreignid = hh.historyid
            left join smg_hosts h on h.hostid = hh.hostid
            left join smg_regions r on r.regionid = s.regionassigned
            left join smg_users u on u.userid = s.arearepid
            where s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <Cfif client.usertype eq 5>
                    AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfelseif client.usertype eq 6>
                    AND s.arearepid in (#userUnderList#)
            <cfelseif client.usertype eq 7>
                  AND s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </Cfif>
           
            and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> and ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistorycompliance">
            and ah.isResolved = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            order by regionname
        </cfquery>
<!----Get the list of host apps, and when received, if received---->

		<cfquery name="qGetHostAppsReceived" datasource="#application.dsn#">
            select distinct s.hostID,  s.firstname as studentFirst, s.familylastname as studentLast, s.studentid, s.regionassigned, s.arearepid,
            hh.dateReceived,
            h.familylastname as hostLast,
            p.programname,
            u.firstname as repFirst, u.lastname as repLast, r.regionname
            from smg_students s
            left outer join smg_hosthistory hh on hh.hostID = s.hostid
            left join smg_hosts h on h.hostid = s.hostid
            left join smg_regions r on r.regionid = s.regionassigned
            left join smg_users u on u.userid = s.arearepid
            left join smg_programs p on p.programid = s.programid
          
                 where s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            <Cfif client.usertype eq 5>
                    AND s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.regionid#">
            <cfelseif client.usertype eq 6>
                    AND s.arearepid in (#userUnderList#)  
            <cfelseif client.usertype eq 7>
                  AND s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
            </Cfif>
            
            and s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            and s.hostid > 0
            order by s.programid desc, studentLast, hostLast
         </cfquery>
    
    <cfscript>
		vPlacedStudents = APPLICATION.CFC.USER.getPlacementsAndPointsCount(
			userID = CLIENT.userID,
			seasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID);
	</cfscript>

    <cfquery name="incentive_trip" datasource="#application.dsn#">
        SELECT
        	trip_place
        FROM 
        	smg_incentive_trip 
        WHERE 
        	active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfquery>

    <cfscript>
		//get all cases that your involved in
		qYourCasesInitial = APPLICATION.CFC.CASEMGMT.yourCasesInitial(personid=client.userid,caseOrder=url.caseOrder); 
		qYourLoopedCasesInitial = APPLICATION.CFC.CASEMGMT.yourLoopedCasesInitial(personid=client.userid,caseOrder=url.caseOrder); 
	</cfscript>
</cfsilent>    
	<!--=== Breadcrumbs ===-->
	<div class="breadcrumbs">
		<div class="container">
			<h1 class="pull-left">Welcome</h1>
			<ul class="pull-right breadcrumb">

			</ul>
		</div><!--/container-->
	</div><!--/breadcrumbs-->
	<!--=== End Breadcrumbs ===-->

<!-- Profile Content -->
<div class="container content profile">

	<div class="row">
		<div class="col-md-12">
			<div class="profile-body">
					<div class="row">
					
					<!--Students-->
					<div class="col-sm-4 sm-margin-bottom-30">
						<div class="panel panel-profile">
							<div class="panel-heading overflow-h">
								<h2 class="panel-title heading-sm pull-left"><i class="fa fa-graduation-cap"></i> Students </h2>
								<a href="#"><i class="fa fa-cog pull-right"></i></a>
							</div>
							<div class="panel-body">
								<ul class="list-unstyled social-contacts-v2">
									<cfinclude  template="applicationStatusLists/studentApplications.cfm">
								</ul>
							</div>
						</div>
					</div>
					<!--End Students-->
					<!--Hosts-->
					<div class="col-sm-4 sm-margin-bottom-30">
						<div class="panel panel-profile">
							<div class="panel-heading overflow-h">
								<h2 class="panel-title heading-sm pull-left"><i class="fa fa-home"></i> Hosts </h2>
<!--
								<form action="#" id="seasonID" class="sky-form">
                                  <section class="col-sm-4 pull-right">
										<label class="select">
										   <select name="seasonID" id="seasonID" onchange="reloadWithSelectedSeason()">
											<cfoutput query="qGetSeasons">
												<option value="#seasonID#" <cfif seasonID EQ vSelectedSeason>selected="selected"</cfif>>#season#</option>
											</cfoutput>
										</select>
										</label>
									</section>
								</form>
-->
							</div>
							<div class="panel-body">
								<ul class="list-unstyled social-contacts-v2">
									<cfinclude  template="applicationStatusLists/hostApplications.cfm">

								</ul>
							</div>
						</div>
					</div>
					<!--End Hosts-->
					<!--Users-->
					<div class="col-sm-4 sm-margin-bottom-30">
						<div class="panel panel-profile">
							<div class="panel-heading overflow-h">
								<h2 class="panel-title heading-sm pull-left"><i class="fa fa-users"></i> Reps </h2>
								<a href="#"><i class="fa fa-cog pull-right"></i></a>
							</div>
							<div class="panel-body">
								<ul class="list-unstyled social-contacts-v2">
									<li> <a href="#">Email Sent</a></li>
									<li> <a href="#">In Training</a></li>
									<li><a href="#">Reviewing</a></li>
									<li> <a href="#">Approved</a></li>
									
								</ul>
							</div>
						</div>
					</div>
					<!--End Useres-->
				</div><!--/end row-->
			</div>
		</div>	
	</div>
</div>
						
						