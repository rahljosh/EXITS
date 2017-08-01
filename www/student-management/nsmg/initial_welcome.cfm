<!--- ------------------------------------------------------------------------- ----
	
	File:		initial_welcome.cfm
	Author:		Marcus Melo
	Date:		March 15, 2010
	Desc:		Initial Welcome Screen

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
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

        qAYPEnglishCamps = APPCFC.SCHOOL.getAYPCamps(campType='english').campID;    
	</cfscript>


    <cfquery name="qGetPendingHosts" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT s.hostid, sh.isRelocation, sh.datePISEmailed, s.studentid, sh.doc_school_accept_date, s.uniqueID,
            s.aypenglish, sh.datePlaced, sh.isRelocation,sh.compliance_school_accept_date, h.fatherFirstName, 
            h.motherFirstName,
            sh.secondVisitRepID,
            sh.doc_school_accept_date,
            sh.compliance_school_accept_date,
            sh.doc_host_app_page1_date,
            sh.compliance_host_app_page1_date,
            sh.doc_host_app_page2_date,
            sh.compliance_host_app_page2_date,
            sh.doc_letter_rec_date,
            sh.compliance_letter_rec_date,
            sh.doc_photos_rec_date,
            sh.compliance_photos_rec_date,
            sh.doc_bedroom_photo,
            sh.compliance_bedroom_photo,
            sh.doc_bathroom_photo,
            sh.compliance_bathroom_photo,
            sh.doc_kitchen_photo,
            sh.compliance_kitchen_photo,
            sh.doc_living_room_photo,
            sh.compliance_living_room_photo,
            sh.doc_outside_photo,
            sh.compliance_outside_photo,
            sh.doc_rules_rec_date,
            sh.compliance_rules_rec_date,
            sh.doc_rules_sign_date,
            sh.compliance_rules_sign_date,
            sh.doc_school_profile_rec,
            sh.compliance_school_profile_rec,
            sh.doc_income_ver_date,
            sh.compliance_income_ver_date,
            sh.doc_conf_host_rec,
            sh.compliance_conf_host_rec,
            sh.doc_date_of_visit,
            sh.compliance_date_of_visit,
            sh.doc_ref_form_1,
            sh.compliance_ref_form_1,
            sh.doc_ref_check1,
            sh.compliance_ref_check1,
            sh.doc_ref_form_2,
            sh.compliance_ref_form_2,
            sh.doc_ref_check2,
            sh.compliance_ref_check2,
            sh.doc_single_ref_form_1,
            sh.compliance_single_ref_form_1,
            sh.doc_single_ref_form_2,
            sh.compliance_single_ref_form_2,
            sh.doc_single_place_auth,
            sh.compliance_single_place_auth,
            sh.doc_single_parents_sign_date,
            sh.compliance_single_parents_sign_date,
            sh.doc_single_student_sign_date,
            sh.compliance_single_student_sign_date,
            sh.hfSupervisingDistance,
            sht_doubleplacement.doublePlacementHostFamilyDateCompliance,
            sht_doubleplacement.doublePlacementHostFamilyDateSigned,
            sht_doubleplacement.isDoublePlacementPaperworkRequired,
            sht_doubleplacement.doublePlacementParentsDateSigned,
            sht_doubleplacement.doublePlacementParentsDateCompliance,
            sht_doubleplacement.doublePlacementStudentDateSigned,
            sht_doubleplacement.doublePlacementStudentDateCompliance,

            count(shc.childid) AS totalChildren,
            shc.childid,
            count(ah.id) AS totalCompNotes,
            ah.id AS compNoteID 
        FROM smg_students s
        INNER JOIN smg_hosts h ON s.hostid = h.hostid
        INNER JOIN smg_programs p ON p.programid = s.programid
        INNER JOIN smg_hosthistory sh ON sh.studentID = s.studentID
            AND sh.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- Filter out PHP --->
        INNER JOIN smg_companies c ON c.companyID = s.companyID            
        INNER JOIN smg_regions r ON r.regionID = s.regionAssigned
        INNER JOIN user_access_rights uar ON s.placeRepID = uar.userID
            AND s.regionassigned = uar.regionID
        LEFT JOIN smg_users advisor ON uar.advisorID = advisor.userID
        LEFT JOIN smg_users arearep ON s.areaRepID = arearep.userid
        LEFT JOIN smg_users facilitator ON  r.regionfacilitator = facilitator.userid 
        LEFT JOIN smg_seasons season ON season.seasonid = p.seasonid
        LEFT OUTER JOIN smg_aypcamps english ON s.aypenglish = english.campID
        LEFT OUTER JOIN smg_notes notes ON notes.hostid = h.hostid
        LEFT OUTER JOIN (
                      SELECT    MAX(id) id, studentid, historyID
                      FROM      smg_hosthistorytracking
                      GROUP BY  studentid
                  ) shtMax ON (shtMax.historyID = sh.historyID AND shtMax.studentID = s.studentID)
        LEFT OUTER JOIN
            smg_hosthistorytracking sht ON sht.id = shtMax.id

        LEFT OUTER JOIN smg_hosthistorytracking sht_doubleplacement ON sht_doubleplacement.historyID = sh.historyID 
            AND sht_doubleplacement.fieldName = 'doublePlacementID'

        LEFT JOIN smg_host_children shc ON (shc.hostID = h.hostID 
            AND shc.liveAtHome = 'yes' 
            AND shc.isDeleted = 0)
        
        LEFT OUTER JOIN applicationhistory ah ON ah.applicationID = #APPLICATION.CONSTANTS.TYPE.EXITS#
            AND ah.foreignTable = "smg_hosthistorycompliance"
            AND ah.foreignID = sh.historyID
            AND ah.isResolved = 0

        WHERE s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">   
                
            <cfif CLIENT.companyID EQ 5>
                AND s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
            <cfelse>            
                AND s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
            </cfif>
            
        <cfswitch expression="#CLIENT.userType#">
            
            <!--- Filter Out Placements Waiting on AR --->
            <cfcase value="1,2,3">
                <!---
                AND
                    s.host_fam_approved != <cfqueryparam cfsqltype="cf_sql_integer" value="10">
                --->
            </cfcase>
            <!--- Filter by Facilitator ---> 
            <cfcase value="4">
                AND
                    r.regionFacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                <!--- 
                AND
                    s.host_fam_approved != <cfqueryparam cfsqltype="cf_sql_integer" value="10">
                --->
            </cfcase>
            
            <!--- Filter by Regional Manager --->
            <cfcase value="5">
                AND 
                    s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.regionID#">
            </cfcase>
        
            <!--- Filter by Regional Advisor --->
            <cfcase value="6">
                AND
                    s.placeRepID IN (
                        SELECT DISTINCT 
                            userID 
                        FROM 
                            user_access_rights
                        WHERE
                            userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        OR
                            ( 
                                advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#"> 
                            AND 
                                companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
                            )
                    )
            </cfcase>
        
            <!--- Filter by Area Representative --->
            <cfcase value="7">
                AND 
                    (
                        s.arearepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    OR
                        s.placerepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                    )
            </cfcase>
        
        </cfswitch>
       
        GROUP BY
            s.studentID
    </cfquery>

    <cfset totalShown = 0 />
    <cfset toEmailIDs = '' />
    <cfloop query="qGetPendingHosts">
        <!---<cfscript>
            vDisplayEmailLink = 0;
                    
            // Do not check compliance for Wayne Brewer - Page will load quicker
            if ( CLIENT.userID NEQ 1956 ) { 
            
                // Check if Host Family is in compliance
                vHostInCompliance = APPLICATION.CFC.CBC.checkHostFamilyCompliance(
                                        hostID=qGetPendingHosts.hostID, 
                                        studentID=qGetPendingHosts.studentID,
                                        schoolAcceptanceDate = qGetPendingHosts.doc_school_accept_date
                                    );
                
                if ( NOT LEN(vHostInCompliance) ) {
                    vDisplayEmailLink = 1;
                }
            
            }
        </cfscript>--->


        <cfif NOT isDate(qGetPendingHosts.datePISEmailed) 
                AND APPLICATION.CFC.USER.isOfficeUser()
                AND ((VAL(qGetPendingHosts.isDoublePlacementPaperworkRequired)
                        AND (NOT isDate(qGetPendingHosts.doublePlacementParentsDateCompliance)
                        OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateCompliance)
                        OR NOT isDate(qGetPendingHosts.doublePlacementParentsDateSigned)
                        OR NOT isDate(qGetPendingHosts.doublePlacementStudentDateSigned)))

                    OR ((LEN(qGetPendingHosts.fatherFirstName) EQ 0 OR LEN(qGetPendingHosts.motherFirstName) EQ 0)
                        AND qGetPendingHosts.totalChildren EQ 0
                        AND (NOT isDate(qGetPendingHosts.compliance_single_place_auth)
                            OR NOT isDate(qGetPendingHosts.compliance_single_parents_sign_date)
                            OR NOT isDate(qGetPendingHosts.compliance_single_student_sign_date)
                            OR NOT isDate(qGetPendingHosts.doc_single_place_auth)
                            OR NOT isDate(qGetPendingHosts.doc_single_parents_sign_date)
                            OR NOT isDate(qGetPendingHosts.doc_single_student_sign_date))))>

            <cfset totalShown = totalShown + 1 />
            <cfif totalShown GT 1>
                <cfset toEmailIDs = toEmailIDs & ", " />
            </cfif>
            <cfset toEmailIDs = toEmailIDs & "#qGetPendingHosts.hostID#" />
        </cfif>
    </cfloop>

    <cfquery dbtype="query" name="qGetPendingHostsToApprove">
        SELECT count(hostid) as total
        FROM qGetPendingHosts
        WHERE (compliance_school_accept_date IS NOT NULL AND compliance_school_accept_date <> '')
            AND (compliance_host_app_page1_date IS NOT NULL AND compliance_host_app_page1_date <> '')
            AND (compliance_host_app_page2_date IS NOT NULL AND compliance_host_app_page2_date <> '')
            AND (compliance_letter_rec_date IS NOT NULL AND compliance_letter_rec_date <> '')
            AND (compliance_photos_rec_date IS NOT NULL AND compliance_photos_rec_date <> '')
            AND (compliance_bedroom_photo IS NOT NULL AND compliance_bedroom_photo <> '')
            AND (compliance_bathroom_photo IS NOT NULL AND compliance_bathroom_photo <> '')
            AND (compliance_kitchen_photo IS NOT NULL AND compliance_kitchen_photo <> '')
            AND (compliance_living_room_photo IS NOT NULL AND compliance_living_room_photo <> '')
            AND (compliance_outside_photo IS NOT NULL AND compliance_outside_photo <> '')
            AND (compliance_rules_rec_date IS NOT NULL AND compliance_rules_rec_date <> '')
            AND (compliance_rules_sign_date IS NOT NULL AND compliance_rules_sign_date <> '')
            AND (compliance_school_profile_rec IS NOT  NULL AND compliance_school_profile_rec <> '')
            AND (compliance_income_ver_date IS NOT NULL AND compliance_income_ver_date <> '')
            AND (compliance_conf_host_rec IS NOT NULL AND compliance_conf_host_rec <> '')
            AND (compliance_date_of_visit IS NOT NULL AND compliance_date_of_visit <> '')
            AND (compliance_ref_form_1 IS NOT NULL AND compliance_ref_form_1 <> '')
            AND (compliance_ref_check1 IS NOT NULL AND compliance_ref_check1 <> '')
            AND (compliance_ref_form_2 IS NOT NULL AND compliance_ref_form_2 <> '')
            AND (compliance_ref_check2 IS NOT NULL AND compliance_ref_check2 <> '')

            AND (doc_school_accept_date IS NOT NULL AND doc_school_accept_date <> '')
            AND (doc_host_app_page1_date IS NOT NULL AND doc_host_app_page1_date <> '')
            AND (doc_host_app_page2_date IS NOT NULL AND doc_host_app_page2_date <> '')
            AND (doc_letter_rec_date IS NOT NULL AND doc_letter_rec_date <> '')
            AND (doc_photos_rec_date IS NOT NULL AND doc_photos_rec_date <> '')
            AND (doc_bedroom_photo IS NOT NULL AND doc_bedroom_photo <> '')
            AND (doc_bathroom_photo IS NOT NULL AND doc_bathroom_photo <> '')
            AND (doc_kitchen_photo IS NOT NULL AND doc_kitchen_photo <> '')
            AND (doc_living_room_photo IS NOT NULL AND doc_living_room_photo <> '')
            AND (doc_outside_photo IS NOT NULL AND doc_outside_photo <> '')
            AND (doc_rules_rec_date IS NOT NULL AND doc_rules_rec_date <> '')
            AND (doc_rules_sign_date IS NOT NULL AND doc_rules_sign_date <> '')
            AND (doc_school_profile_rec IS NOT  NULL AND doc_school_profile_rec <> '')
            AND (doc_income_ver_date IS NOT NULL AND doc_income_ver_date <> '')
            AND (doc_conf_host_rec IS NOT NULL AND doc_conf_host_rec <> '')
            AND (doc_date_of_visit IS NOT NULL AND doc_date_of_visit <> '')
            AND (doc_ref_form_1 IS NOT NULL AND doc_ref_form_1 <> '')
            AND (doc_ref_check1 IS NOT NULL AND doc_ref_check1 <> '')
            AND (doc_ref_form_2 IS NOT NULL AND doc_ref_form_2 <> '')
            AND (doc_ref_check2 IS NOT NULL AND doc_ref_check2 <> '')

            AND hfSupervisingDistance < 120

            AND (secondVisitRepID IS NOT NULL AND secondVisitRepID > 0)

            AND ((fatherFirstName IS NOT NULL AND fatherFirstName <> '' AND motherFirstName IS NOT NULL AND motherFirstName <> '')
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '') 
                    AND totalChildren > 0)
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (totalChildren = 0 OR totalChildren IS NULL)
                    AND compliance_single_ref_form_1 IS NOT NULL 
                    AND compliance_single_ref_form_1 <> ''
                    AND compliance_single_ref_form_2 IS NOT NULL 
                    AND compliance_single_ref_form_2 <> ''
                    AND doc_single_ref_form_1 IS NOT NULL 
                    AND doc_single_ref_form_1 <> ''
                    AND doc_single_ref_form_2 IS NOT NULL 
                    AND doc_single_ref_form_2 <> ''))
                
            AND ((isDoublePlacementPaperworkRequired = 0 OR isDoublePlacementPaperworkRequired IS NULL)
                OR (isDoublePlacementPaperworkRequired = 1
                AND doublePlacementHostFamilyDateCompliance IS NOT NULL 
                AND doublePlacementHostFamilyDateCompliance <> ''
                AND doublePlacementHostFamilyDateSigned IS NOT NULL 
                AND doublePlacementHostFamilyDateSigned <> ''))

            AND ((isDoublePlacementPaperworkRequired = 0 OR isDoublePlacementPaperworkRequired IS NULL)
                OR (isDoublePlacementPaperworkRequired = 1
                AND doublePlacementParentsDateCompliance IS NOT NULL 
                AND doublePlacementParentsDateCompliance <> ''
                AND doublePlacementStudentDateCompliance IS NOT NULL 
                AND doublePlacementStudentDateCompliance <> ''
                AND doublePlacementParentsDateSigned IS NOT NULL 
                AND doublePlacementParentsDateSigned <> ''
                AND doublePlacementStudentDateSigned IS NOT NULL 
                AND doublePlacementStudentDateSigned <> ''))
            
            AND ((fatherFirstName IS NOT NULL AND fatherFirstName <> '' AND motherFirstName IS NOT NULL AND motherFirstName <> '')
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '') 
                    AND totalChildren > 0)
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (totalChildren = 0 OR totalChildren IS NULL)
                    AND compliance_single_place_auth IS NOT NULL 
                    AND compliance_single_place_auth <> ''
                    AND compliance_single_parents_sign_date IS NOT NULL 
                    AND compliance_single_parents_sign_date <> ''
                    AND compliance_single_student_sign_date IS NOT NULL 
                    AND compliance_single_student_sign_date <> ''
                    AND doc_single_place_auth IS NOT NULL 
                    AND doc_single_place_auth <> ''
                    AND doc_single_parents_sign_date IS NOT NULL 
                    AND doc_single_parents_sign_date <> ''
                    AND doc_single_student_sign_date IS NOT NULL 
                    AND doc_single_student_sign_date <> ''))

            AND (compNoteID = 0 OR compNoteID IS NULL)
    </cfquery>

    <cfquery dbtype="query" name="qGetPendingHostsPreAYP">
        SELECT count(hostID) AS total
        FROM qGetPendingHosts
        WHERE aypenglish > 0
    </cfquery>

    <cfquery dbtype="query" name="qGetPendingHostsSafAndHF">
        SELECT count(hostID) AS total
        FROM qGetPendingHosts
        WHERE  (((compliance_school_accept_date IS NULL OR compliance_school_accept_date = '')
                OR (compliance_host_app_page1_date IS NULL OR compliance_host_app_page1_date = '')
                OR (compliance_host_app_page2_date IS NULL OR compliance_host_app_page2_date = '')
                OR (compliance_letter_rec_date IS NULL OR compliance_letter_rec_date = '')
                OR (compliance_photos_rec_date IS NULL OR compliance_photos_rec_date = '')
                OR (compliance_bedroom_photo IS NULL OR compliance_bedroom_photo = '')
                OR (compliance_bathroom_photo IS NULL OR compliance_bathroom_photo = '')
                OR (compliance_kitchen_photo IS NULL OR compliance_kitchen_photo = '')
                OR (compliance_living_room_photo IS NULL OR compliance_living_room_photo = '')
                OR (compliance_outside_photo IS NULL OR compliance_outside_photo = '')
                OR (compliance_rules_rec_date IS NULL OR compliance_rules_rec_date = '')
                OR (compliance_rules_sign_date IS NULL OR compliance_rules_sign_date = '')
                OR (compliance_school_profile_rec IS  NULL OR compliance_school_profile_rec = '')
                OR (compliance_income_ver_date IS NULL OR compliance_income_ver_date = '')
                OR (compliance_conf_host_rec IS NULL OR compliance_conf_host_rec = '')
                OR (compliance_date_of_visit IS NULL OR compliance_date_of_visit = '')
                OR (compliance_ref_form_1 IS NULL OR compliance_ref_form_1 = '')
                OR (compliance_ref_check1 IS NULL OR compliance_ref_check1 = '')
                OR (compliance_ref_form_2 IS NULL OR compliance_ref_form_2 = '')
                OR (compliance_ref_check2 IS NULL OR compliance_ref_check2 = '')

                OR (doc_school_accept_date IS NULL OR doc_school_accept_date = '')
                OR (doc_host_app_page1_date IS NULL OR doc_host_app_page1_date = '')
                OR (doc_host_app_page2_date IS NULL OR doc_host_app_page2_date = '')
                OR (doc_letter_rec_date IS NULL OR doc_letter_rec_date = '')
                OR (doc_photos_rec_date IS NULL OR doc_photos_rec_date = '')
                OR (doc_bedroom_photo IS NULL OR doc_bedroom_photo = '')
                OR (doc_bathroom_photo IS NULL OR doc_bathroom_photo = '')
                OR (doc_kitchen_photo IS NULL OR doc_kitchen_photo = '')
                OR (doc_living_room_photo IS NULL OR doc_living_room_photo = '')
                OR (doc_outside_photo IS NULL OR doc_outside_photo = '')
                OR (doc_rules_rec_date IS NULL OR doc_rules_rec_date = '')
                OR (doc_rules_sign_date IS NULL OR doc_rules_sign_date = '')
                OR (doc_school_profile_rec IS  NULL OR doc_school_profile_rec = '')
                OR (doc_income_ver_date IS NULL OR doc_income_ver_date = '')
                OR (doc_conf_host_rec IS NULL OR doc_conf_host_rec = '')
                OR (doc_date_of_visit IS NULL OR doc_date_of_visit = '')
                OR (doc_ref_form_1 IS NULL OR doc_ref_form_1 = '')
                OR (doc_ref_check1 IS NULL OR doc_ref_check1 = '')
                OR (doc_ref_form_2 IS NULL OR doc_ref_form_2 = '')
                OR (doc_ref_check2 IS NULL OR doc_ref_check2 = ''))

                OR (((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (totalChildren = 0 OR totalChildren IS NULL))
                    AND ((compliance_single_ref_form_1 IS NULL OR compliance_single_ref_form_1 = '')
                        OR (compliance_single_ref_form_2 IS NULL OR compliance_single_ref_form_2 = '')
                        OR (doc_single_ref_form_1 IS NULL OR doc_single_ref_form_1 = '')
                        OR (doc_single_ref_form_2 IS NULL OR doc_single_ref_form_2 = '')))
                
                OR ((isDoublePlacementPaperworkRequired = 1)
                    AND (doublePlacementHostFamilyDateCompliance IS NULL OR doublePlacementHostFamilyDateCompliance = ''
                        OR doublePlacementHostFamilyDateSigned IS NULL OR doublePlacementHostFamilyDateSigned = ''))

                OR (hfSupervisingDistance >= 120)

                OR (secondVisitRepID IS  NULL OR secondVisitRepID = 0)
                OR (compNoteID > 0))
    </cfquery>

    <cfquery dbtype="query" name="qGetPendingHostsIntAgent">
        SELECT count(hostID) AS total
        FROM qGetPendingHosts
        WHERE ((isDoublePlacementPaperworkRequired = 1
                AND (doublePlacementParentsDateCompliance IS NULL OR doublePlacementParentsDateCompliance = ''
                    OR doublePlacementStudentDateCompliance IS NULL OR doublePlacementStudentDateCompliance = ''))
            
                OR ((fatherFirstName IS NULL OR fatherFirstName = '' OR motherFirstName IS NULL OR motherFirstName = '')
                    AND (totalChildren = 0 OR totalChildren IS NULL)
                    AND (compliance_single_place_auth IS NULL OR compliance_single_place_auth = ''
                        OR compliance_single_parents_sign_date IS NULL OR compliance_single_parents_sign_date = ''
                        OR compliance_single_student_sign_date IS NULL OR compliance_single_student_sign_date = ''
                        OR doc_single_place_auth IS NULL OR doc_single_place_auth = ''
                        OR doc_single_parents_sign_date IS NULL OR doc_single_parents_sign_date = ''
                        OR doc_single_student_sign_date IS NULL OR doc_single_student_sign_date = '')))
    </cfquery>


    
</cfsilent>    

<script type="text/javascript">
	<!-- Begin
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function MM_jumpMenu(targ,selObj,restore){ //v3.0
	  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	  if (restore) selObj.selectedIndex=0;
	}
	// End -->
</script>



<script>
	jQuery(document).ready(function($) {
		$(".clickableRow").click(function() {
      		window.document.location = $(this).attr("href");
      	});

          $( function() {
            $( "#accordion" ).accordion();
          } );
	});

	// Set a new season
	function reloadWithSelectedSeason() {
		var newURL = document.URL.toString();
		if (newURL.indexOf("?") > 0) {
			newURL = newURL.substring(0,newURL.indexOf("?"));
		}
		newURL = newURL + "?seasonID=" + $("#seasonID").val()
		window.location.href = newURL;
	}
</script>
<script type="text/javascript" language="JavaScript">
<!-- Script to Swap div area
	function HideDIV(d) { document.getElementById(d).style.display = "none"; }
	function DisplayDIV(d) { document.getElementById(d).style.display = "block"; }
//-->
</script>


<style type="text/css">
  <style type="text/css">
  <style type="text/css">
/* Form */
 .Tabs {
	height:30px;
	width:auto;
	margin-bottom: 5px;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #c6c6c6;
 } 


 .Tabs .rdTab {
	border-left:1px solid #c6c6c6;
	border-right:1px solid #c6c6c6;
	padding:10px 15px;
	margin:0;
	display: block;
 } 
.clearfix {
	display: block;
	clear: both;
	height: 5px;
	width: auto;
}

 .rdtopTab {
	width:auto;
	height:30px;
	/* -webkit for Safari and Google Chrome */

  -webkit-border-top-left-radius:15px;
	-webkit-border-top-right-radius:15px;
	/* -moz for Firefox, Flock and SeaMonkey  */

  -moz-border-radius-topright:15px;
	-moz-border-radius-topleft:15px;
	border-top-right-radius:15px;
	border-top-left-radius:15px;
	background-color: #FFF;
	color: #006699;
	background-image: linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -o-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -moz-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -webkit-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -ms-linear-gradient(top, rgb(235,235,235) 22%, rgb(255,255,255) 64%);
	background-image: -webkit-gradient(
	linear,
	left top,
	left bottom,
	color-stop(0.22, rgb(235,235,235)),
	color-stop(0.64, rgb(255,255,255))
);
	border: 1px solid #c6c6c6;
 }
.rdtopTab {
	 behavior: url(/css/border-radius.htc);
    border-radius-topright: 15px;
	border-radius-topleft: 15px;
	  }
	  
 .rdtopTab .rdtitleTab {
	margin:0;
	line-height:30px;
	font-family:Arial, Geneva, sans-serif;
	font-size:14px;
	padding-top: 5px;
	padding-right: 10px;
	padding-bottom: 0px;
	padding-left: 10px;
	color: #0066A4;
	text-align: center;	
 }
.rdtopTab:link{
	text-decoration: none;
}
.rdtopTab:hover{
	text-decoration: none;
	color: #999;
	/* IE10 Consumer Preview */ 
background-image: -ms-linear-gradient(bottom, #FFFFFF 0%, #CCCCCC 100%);

/* Mozilla Firefox */ 
background-image: -moz-linear-gradient(bottom, #FFFFFF 0%, #CCCCCC 100%);

/* Opera */ 
background-image: -o-linear-gradient(bottom, #FFFFFF 0%, #CCCCCC 100%);

/* Webkit (Safari/Chrome 10) */ 
background-image: -webkit-gradient(linear, left bottom, left top, color-stop(0, #FFFFFF), color-stop(1, #CCCCCC));

/* Webkit (Chrome 11+) */ 
background-image: -webkit-linear-gradient(bottom, #FFFFFF 0%, #CCCCCC 100%);

/* W3C Markup, IE10 Release Preview */ 
background-image: linear-gradient(to top, #FFFFFF 0%, #CCCCCC 100%);
}
 .rdtitleTab:link {
	text-decoration: none;
 }
  .rdtitleTab:hover {
	color: #666;
 }

 .ui-state-active {
    background: #90B2D5 !important;
    color: #fff !important;
 }

 .highlightNumber {
    background-color: #e45400;
    color: #fff;
    padding: 3px 9px;
    border-radius: 5px;
    float:right;
    margin-top:-3px;
 }

 .highlightNumberOFF {
    background-color: #ccc;
    color: #fff;
    padding: 3px 9px;
    border-radius: 5px;
    float:right;
    margin-top:-3px;
 }
	
</style>


<cfoutput>
	
    <!--- Visible for all users --->
    <table width="100%">
        <tr>
            <td>Your last visit was on #DateFormat(CLIENT.lastlogin, 'mmm d, yyyy')# MST</td>
            <td align="right">#DateFormat(now(), 'MMMM D, YYYY')#</td>
        </tr>
    </table>

    <!--- Display Sections Based on UserType --->
    <cfswitch expression="#CLIENT.userType#">            


        <!--- Office + Field --->
        <cfcase value="1,2,3,4,5,6,7">

			<!--- Left column --->
            <div style="width:49%;float:left;display:block;">
            
            
				<!--- Host Applications --->
                <div class="rdholder" style="width:100%; float:left;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">
                        	Host Family Pipeline 
                            <span style="float:right; margin-right:5px;">
                                <font size="-1">SEASON: </font>
                                <select name="seasonID" id="seasonID" onchange="reloadWithSelectedSeason()">
                                    <cfloop query="qGetSeasons">
                                        <option value="#seasonID#" <cfif seasonID EQ vSelectedSeason>selected="selected"</cfif>>#season#</option>
                                    </cfloop>
                                </select>
                           	</span>
                     	</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox" style="margin-bottom: 0">
                        <cfinclude template="welcome_includes/hostAppsOffice.cfm">
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of Host Applications --->
                

				<!--- News Messages --->
                <cfif qNewsMessages.recordcount>
                    <div class="rdholder" style="width:100%; float:left;"> 
                    
                        <div class="rdtop"> 
                            <span class="rdtitle">Please take note...</span> 
                        </div> <!-- end top --> 
                        
                        <div class="rdbox">
                            <img src="pics/newsIcon.png" width=65 height=65 align="left">
                            <cfloop query="qNewsMessages">
                                <p>
                                    <b>#message#</b><br />
                                    #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br />,<br />,<br />')#
                                    <cfif LEN(additional_file)>
                                        <br />
                                        <img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                    </cfif>
                                </p>
                            </cfloop>
                        </div>
                        
                        <div class="rdbottom"></div> <!-- end bottom --> 
                        
                    </div>
                </cfif>
				<!--- End of News Messages --->
                
                   <!--- Missing complinace documents --->
             <cfquery name="numberHostProbs" dbtype="query">
                select distinct hostid
                from qGetStudentWithMissingCompliance
                </cfquery>
              <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Current Host Status</span> 
                    </div> <!-- end top --> 
                     
                    
                    <div class="rdbox">
                    <div class="Tabs"> 
                        <div class="rdtopTab" style="width: 170px; float: left;">
                        <span class="rdtitleTab" onmouseover="HideDIV('receivedStatus');DisplayDIV('missingDocs')" style="cursor:pointer;">Missing Placement Doc</a></span></div><!-- end top -->
                            
                         <!-- end top -->
                            
                        </div>
                        <div class="clearfix"></div>
                                             
                     
                    
                    
                      <div id="missingDocs" class="mybox">
                            <span class="MOtext" style="background-color: ##E6F2D5;">
                                <cfinclude template="reports/welcomePageMissingPlacementDocs.cfm">
                            </span>
                        </div>
                        
                </div>
                   
                	<div class="rdbottom"></div> <!-- end bottom --> 
                </div>

                <!--- ToDo --->
                <div class="rdholder" style="width:100%; float:left;"> 
                    
                    <div class="rdtop"> 
                        <span class="rdtitle">To Do Board</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        <div id="accordion">
                            <h3 style="padding:8px 10px 8px 26px">Pending Placements <span class="highlightNumber<cfif NOT VAL(qGetPendingHosts.recordCount)>OFF</cfif>" >#VAL(qGetPendingHosts.recordCount)#</span></h3>

                            <ul style="padding:5px 20px !important; border-top:1px solid ##33 !important">
                                <a href="index.cfm?curdoc=pendingPlacementList">
                                    <li style="padding:8px; font-size: 12px; background-color:##eee">
                                        All Pending Placements <span class="highlightNumber<cfif NOT VAL(qGetPendingHosts.recordCount)>OFF</cfif>">#VAL(qGetPendingHosts.recordCount)#</span>
                                    </li>
                                </a>
                                <a href="index.cfm?curdoc=pendingPlacementList&pending_status=to_approve">
                                    <li style="padding:8px; font-size: 12px">
                                        Review & Approve <span class="highlightNumber<cfif NOT VAL(qGetPendingHostsToApprove.total)>OFF</cfif>">#VAL(qGetPendingHostsToApprove.total)#</span>
                                    </li>
                                </a>
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="index.cfm?curdoc=pendingPlacementList&toEmail=1">
                                        <li style="padding:8px; font-size: 12px; background-color:##eee">
                                            Present PIS to Inter.Rep <span class="highlightNumber<cfif NOT VAL(totalShown)>OFF</cfif>">#totalShown#</span>
                                        </li>
                                    </a>
                                </cfif>

                                <a href="index.cfm?curdoc=pendingPlacementList&preAypCamp=#qAYPEnglishCamps#">
                                    <li style="padding:8px; font-size: 12px;<cfif NOT APPLICATION.CFC.USER.isOfficeUser()>background-color:##eee</cfif>">
                                        Expedite Pre-AYP Students <span class="highlightNumber<cfif NOT VAL(qGetPendingHostsPreAYP.total)>OFF</cfif>">#VAL(qGetPendingHostsPreAYP.total)#</span>
                                    </li>
                                </a>
                                <a href="index.cfm?curdoc=pendingPlacementList&pending_status=saf_and_hf">
                                    <li style="padding:8px; font-size: 12px; <cfif APPLICATION.CFC.USER.isOfficeUser()>background-color:##eee</cfif>">
                                        Get Missing Items from Field <span  class="highlightNumber<cfif NOT VAL(qGetPendingHostsSafAndHF.total)>OFF</cfif>">#VAL(qGetPendingHostsSafAndHF.total)#</span>
                                    </li>
                                </a>
                                
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="index.cfm?curdoc=pendingPlacementList&pending_status=int_agent">
                                        <li style="padding:8px; font-size: 12px">
                                            Secure Missing Docs from Inter.Rep <span class="highlightNumber<cfif NOT VAL(qGetPendingHostsIntAgent.total)>OFF</cfif>">#VAL(qGetPendingHostsIntAgent.total)#</span>
                                        </li>
                                    </a>
                                </cfif>
                            </ul>
                              
                            <h3 style="padding:5px 10px 5px 26px">Progress Reports</h3>
                            <ul style="padding:5px 20px !important; border-top:1px solid ##33 !important">
                                <li style="padding:4px; font-size: 12px">Coming soon</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                
                </div>
                <!--- End of ToDo --->


				<!--- Online Reports --->
                <div class="rdholder" style="width:100%; float:left;"> 
                	
                    <div class="rdtop"> 
                        <span class="rdtitle">Online Reports</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        <table width="90%" align="center" cellpadding="4">
                            <tr>
                                <td><img src="pics/icons/annualPaperwork.png" border="0" title="Click Here to fill out  your annual paperwork" /></td>
                                <td><a href="index.cfm?curdoc=user/index">Yearly Paperwork</a></td>
								<!--- View Pending Placements --->
                                <!---<cfif CLIENT.usertype LTE 7>
                                    <td width="22"><img src="pics/icons/viewPlacements.png" /></td>
                                    <td><a href="index.cfm?curdoc=pendingPlacementList">View Pending Placements</a></td>
                                </cfif>--->
               				</tr>
                			<tr>
								<!--- Progress Reports --->
                                <td width=22><img src="pics/icons/onlineReports.png" /></td>
                                <td>          
                                    <a href="index.cfm?curdoc=progress_reports">Progress Reports</a>
                                    / 
                                    <a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a>
                                </td>
                                <!---  WebEx --->
                                <!----<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.publicHS, CLIENT.companyID)>
                                    <td width="22"><img src="pics/icons/webex.png" /></td>
                                    <td><a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a></td>
                                </cfif>---->
                			</tr>
                            <tr>
								<!--- Help Project --->
                                <cfif (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or CLIENT.companyID eq 10) and CLIENT.usertype lte 7>
                                    <td width="22"><img src="pics/icons/HelpHours.png" /></td>
                                    <td><a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a></td>
                                </cfif>
                                <!--- Quick Start --->
                                <cfif ListFind("1,2,3,4,5", CLIENT.userType) AND listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG ,CLIENT.companyID)>
                                    <td width="22"><img src="pics/icons/annualPaperwork.png" /></td>
                                    <td><a href="uploadedfiles/pdf_docs/ISE/ar-welcome-packet.pdf" target="_blank">AR Welcome Brochure</a></td>
                                </cfif>
                            </tr>
                		</table>
                	</div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                
                </div>
                <!--- End of Online Reports --->
                
                
              
                
                <!--- New Students --->
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">New Students</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
						<cfif new_students.recordcount eq 0>
                            <em> There are no new students.</em>
                        <cfelse>
                        
							<!--- this is used to display the message if the user was added since last login. --->
							<cfset since_lastlogin = 0>
                            
                            <cfloop query="new_students">
								<!--- highlight if user was added since last login. --->
								<cfif dateapplication GTE CLIENT.lastlogin>
                                    <a href="index.cfm?curdoc=student_info&studentid=#studentid#"><font color="FF0000">#firstname# #familylastname#</font></a>
									<cfset since_lastlogin = 1>
                                <cfelse>
                                    <a href="index.cfm?curdoc=student_info&studentid=#studentid#">#firstname# #familylastname#</a>
                                </cfif>
                                <br />
                            </cfloop>
                            
                        	<cfif since_lastlogin>
                        		<br /><font color="FF0000">students in red were added since your last visit</font>
                        	</cfif>
                            
                        </cfif>
                    </div>
                    
                	<div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of New Students --->
                
         
                   </div>
              
                <!--- End of Missing Compliance Docs  --->
            	</div>
        	
            <!--- Right Column --->
            <div style="width:49%;float:right;display:block;">
            
				<!--- Student Applications / Field Bonuses --->
                <div class="rdholder" style="width:100%; float:right;"> 
                    <Cfif client.companyid lt 13 >
                    	<cfif isDate('#APPLICATION.CFC.USER.getUserSessionPaperwork().dateDOSTestExpired#')>
                   			<cfif #now()# gt #DateAdd('m','-1','#APPLICATION.CFC.USER.getUserSessionPaperwork().dateDOSTestExpired#')#>
								<cfset daysToExpire = #dateDiff('d','#now()#','#APPLICATION.CFC.USER.getUserSessionPaperwork().dateDOSTestExpired#')#>
                     			<div class="rdtop"> 
                            		<span class="rdtitle">DOS Certification Expiring</span> 
                        		</div> <!-- end top --> 
                        		<div class="rdbox" style="background-color: ##fef3b9;">
                        			<div align="center">
                                 
											Your DOS Certification expires in #daysToExpire# day<cfif daysToExpire gt 1 or daysToExpire lt 1>s</cfif>.  You can re-certify by clicking the link below.<br /><br />
                           				<a href="user/index.cfm?uniqueID=#CLIENT.uniqueID#&action=trainCasterLogin" target="_blank" title="Click Here to Take the DOS Test">
                                 			<img src="pics/buttons/DOScertification.png" border="0" title="Click Here to Take the DOS Certification Test" />
                            			</a>
                                       
                           			</div>
                        		</div>
                        		<div class="rdbottom" style="background-color: ##fef3b9;"></div> <!-- end bottom --> 
                    			<br /><br />
                    		</cfif>
                      	<cfelse>
                        	<div class="rdtop"> 
                                <span class="rdtitle">DOS Certification Not Completed</span> 
                            </div> <!-- end top --> 
                            <div class="rdbox" style="background-color: ##fef3b9;">
                                <div align="center">
                         
                                   Your DOS Certification has not been completed.<br /><br />
                                    <a href="user/index.cfm?uniqueID=#CLIENT.uniqueID#&action=trainCasterLogin" target="_blank" title="Click Here to Take the DOS Test">
                                        <img src="pics/buttons/DOScertification.png" border="0" title="Click Here to Take the DOS Certification Test" />
                                    </a>
                                </div>
                            </div>
                            <div class="rdbottom" style="background-color: ##fef3b9;"></div> <!-- end bottom --> 
                            <br /><br />
                      	</cfif>
                       </Cfif>
					<!--- Office - Student Applications --->
                    <cfif APPLICATION.CFC.USER.isOfficeUser()>                        

                        <div class="rdtop"> 
                            <span class="rdtitle">Student Applications</span> 
                        </div> <!-- end top --> 
                        
                        <div class="rdbox">
                            <cfinclude template="welcome_includes/office_apps.cfm">
                        </div>
                        
                        <div class="rdbottom"></div> <!-- end bottom --> 
                        
					<!--- Bonuses for the Field --->    
                    <cfelse>
                    	
                    
                        <div class="rdtop"> 
                            <span class="rdtitle">Bonuses</span> 
                        </div> <!-- end top --> 
                        
                        <div class="rdbox">
                            <cfinclude template="welcome_includes/adds.cfm">
                        </div>
                        
                        <div class="rdbottom"></div> <!-- end bottom --> 

                    </cfif>
                	<cfif (client.userid eq 1 or client.userid eq 21963 or client.userid eq 11364 or client.userid eq 13799)>
						  <br><br>
						  <div class="rdtop"> 
								<span class="rdtitle">Bonuses</span> 
							</div> <!-- end top --> 

							<div class="rdbox">
								<cfinclude template="welcome_includes/adds.cfm">
							</div>

							<div class="rdbottom"></div> <!-- end bottom --> 

                	</Cfif>		
                </div>
                <!--- End of Student Applications / Field Bonuses --->
 
                <!--- Case Management---->
                 <cfif client.usertype lte 4>
                 <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Case Management </span> 
                        <em>Any cases you're involved with or looped in on.  </em>
                    </div>
                    
                    <div class="rdbox" >
                    
                       <table width=90% align="center" cellpadding=4 cellspacing="0">
                        	<Tr>
                            	<tr>
                                	<td colspan="3" align="right" valign="middle"><img src="pics/icons/N_icons/1_Desktop_Icons/icon_016.png"  border=0 /> New case</td>
                                   <td colspan="3" valign="middle"><img src="pics/icons/Up_icons/1_Desktop_Icons/icon_016.png"  border=0 /> Updated case</td>
                                </tr>
                            </Tr>
                            <tr bgcolor="##90b2d5">
                            	<th></th>
                            	<th align="left">Student</th> 
                                <th align="left">Subject</th>
                                <th align="left">Status</th>
                                <th align="left"><a href="?curdoc=initial_welcome&caseOrder=facFirstName"><font color="##000000">Facilitator &uarr;</font></a></th>
                                <th align="left"><a href="?curdoc=initial_welcome&caseOrder=regionname"><font color="##000000">Region &uarr;</font></a></th>
                                <th align="left"><a href="?curdoc=initial_welcome&caseOrder=lastPerCommentDate"><font color="##000000">Updated &uarr;</font></a></th>
                            </tr>
                        <Cfif qYourCasesInitial.recordcount eq 0>
                        	<tr>
                            	<td colspan=5>You have no open cases.</td>
                            </tr>
                        <cfelse>    
                            
                            <cfloop query="qYourCasesInitial">
                            	<!----Get all the messages from the case---->
                                <Cfquery name="allMessages" datasource="#application.dsn#">
                                select count(id) as allMessages
                                from smg_casemgmt_case_items
                                where caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
								</Cfquery>                               
                                <!----Check if the case has been viewed---->
                                <cfquery name="checkViewed" datasource="#application.dsn#">
                                select id
                                from smg_casemgmt_case_views
                                where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                and fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
                                </cfquery>
                                <!----check how many of the messages you have read---->
                                <cfquery name="checkUnreadMessage" datasource="#application.dsn#">
                                select count(fk_messageID) as readMessage
                                from smg_casemgmt_case_views
                                 where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                 and fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
                                </cfquery>
                            
                                <tr class='clickableRow' style="cursor: pointer;" href='index.cfm?curdoc=caseMgmt/index&action=viewCase&caseID=#caseID#'  <cfif currentrow mod 2>bgcolor="##ccc"</cfif> >			<td><cfif checkViewed.recordcount eq 0><img src="pics/icons/N_icons/1_Desktop_Icons/icon_016.png"  border=0 /></cfif>
                                	    <cfif (checkUnreadMessage.readMessage neq allMessages.allMessages) AND checkViewed.recordcount neq 0><img src="pics/icons/Up_icons/1_Desktop_Icons/icon_016.png"  border=0 /></cfif>
                                	</td>
                                    <td>#firstname# #familylastname# (#studentid#)</td>
                                    <td>#Left(caseSubject,8)#...</td>
                                    <td>#caseStatus#</td>
                                    <td>#facFirstName#</th>
                               		<td>#regionname#</th>
                                    <Td>#DateFormat(lastPerCommentDate, 'mmm. dd')#</Td>
                                </tr>
                            </cfloop> 
                            
                          
						</Cfif>
   <cfif val(qYourLoopedCasesInitial.recordcount)>
                            <tr bgcolor="##90b2d5">
                            	<th align="left" colspan="7"><em>Looped In</em></th>
                            </tr>
                            </cfif>
                            <cfloop query="qYourLoopedCasesInitial">
                            <!----Get all the messages from the case---->
                                <Cfquery name="allMessagesLooped" datasource="#application.dsn#">
                                select count(id) as allMessages
                                from smg_casemgmt_case_items
                                where caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
								</Cfquery>     
                            <cfquery name="checkViewedLoop" datasource="#application.dsn#">
                                select id
                                from smg_casemgmt_case_views
                                where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                and fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
                                </cfquery>
                                 <cfquery name="checkUnreadMessageLooped" datasource="#application.dsn#">
                                select count(fk_messageID) as readMessage
                                from smg_casemgmt_case_views
                                 where fk_userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                                 and fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value="#caseID#">
                                </cfquery>
                                <tr class='clickableRow' style="cursor: pointer;" href='index.cfm?curdoc=caseMgmt/index&action=viewCase&caseID=#caseID#' <cfif currentrow mod 2>bgcolor="##ccc"</cfif>>					<td><cfif checkViewedLoop.recordcount eq 0><img src="pics/icons/N_icons/1_Desktop_Icons/icon_016.png"  border=0 /></cfif>
                                <cfif (checkUnreadMessageLooped.readMessage neq allMessagesLooped.allMessages) AND checkViewedLoop.recordcount neq 0><img src="pics/icons/Up_icons/1_Desktop_Icons/icon_016.png"  border=0 /></cfif></td>
                                    <td>#firstname# #familylastname# (#studentid#)</td>
                                    <td>#Left(caseSubject,8)#...</td>
                                    <td>#caseStatus#</td>
                                    <td>#facFirstName#</th>
                               		<td>#regionname#</th>
                                     <Td>#DateFormat(lastPerCommentDate, 'mmm. dd')#</Td>
                                </tr>
                            </cfloop> 
                        </table>
                   <div align="right"><em><a href="?curdoc=caseMgmt/index&action=viewCaseList&viewAll=1">View Closed Cases</a></em></div>
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of Case Management --->      
                </cfif>             
                  
                <!--- Marketing Material --->
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Area Rep Resources</span> 
                        <em></em>
                    </div>
                    
                    <div class="rdbox">
                    
                        <table width=95% align="center" cellpadding=6 cellspacng=0>
                        	<tr>

                                <td bgcolor="##1f4a79" <cfif client.companyid eq 14> colspan="4" <cfelse> colspan="4"</cfif> align="center"><font color="white">Printable Flyers</td>
                            </tr>
                            <!---_Available for All companies --->
                            <cfif ListFind("1,2,3,4,5,12", CLIENT.companyID) >
                           
                                <tr>
                                	
                                  	<td colspan=2 align="center">
                                      <a href="?curdoc=marketing/index&type=pr">  <img src="marketing/print-2.png" /></a><Br />Click Icon to View Materials
                					</td>
                                </tr>
                            
                            </cfif>
                            <cfif ListFind("10", CLIENT.companyID) >
                            <tr>
                                    <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/difference.cfm" target="_blank">Make A Difference</a></td>
                                    <td><img src="pics/icons/marketing2.png" /></td><td><a href="marketing/HostFam2012/HostFamiles.cfm" target="_blank">Host Families</a></td>
                                </tr>
                                <tr>    
                                    <td><img src="pics/icons/marketing2.png" /></td><td><A href="marketing/aroundWorld.cfm" target="_blank"> School Around the World</A></td>
                                    <td><img src="pics/icons/marketing3.png" /></td><td> <a href="marketing/bookmark.cfm" target="_blank">  Enrich Your Life Bookmarks</A></td>
                                </tr>
                                <tr>
                                    <td><img src="pics/icons/marketing3.png" /></td><td><a href="marketing/openHeart.cfm" target="_blank">Open Heart & Soul</a></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </cfif>
                            <!--- ESI ONLY Docs --->
                            <cfif ListFind("14", CLIENT.companyID) >
                            	<tr>
                                    <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/ESI_host_flier/Host-Family-Flier-Screen.cfm" target="_blank">Host Flier Preview</a></td>
                                    <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/ESI_host_flier/Host-Family-Flier-Print.cfm" target="_blank">Host Flier Print</a></td>
                                </tr>
                                <!----
                                <tr>
                                    <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/bookmark.cfm" target="_blank">Enrich Your Life Bookmarks</a></td>
                                    <td><img src="pics/icons/marketing.png" /></td><td><a href="marketing/difference.cfm" target="_blank">Make A Difference</a></td>
                                </tr>
								---->
                            </cfif>
                            
                        </table>
                    
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
               
                <!--- End of Marketing Material --->
            
            
                <!--- Office Users Only - State and Region Availability --->
                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                    <div class="rdholder" style="width:100%; float:right;"> 
                    
                        <div class="rdtop"> 
                        	<span class="rdtitle">State & Region Availability</span> 
                        </div> <!-- end top --> 
                        
                        <div class="rdbox">
                        
                            <table align="center" width="80%">
                                <tr>
                                    <td width="25"><img src="pics/icons/map.png" /></td>
                                    <td><a href="javascript:openPopUp('tools/stateStatus.cfm', 875, 675);">Available States</a></td>
                                    <td rowspan="2" width="60%"><font size=-2><em>State and Region availability can change at any time, acceptance of choice will not be confirmed until application is submitted for approval</em></font>
                                </tr>
                                <tr>
                                    <td><img src="pics/icons/region.png" /></td>
                                    <td><a href="javascript:openPopUp('tools/regionStatus.cfm', 750, 775);">Available Regions</a></td>
                                </tr>
                            </table>
            
                		</div>
                        
                        <div class="rdbottom"></div> <!-- end bottom --> 
                        
                	</div>
                </cfif>
                <!--- End of Office Users Only - State and Region Availability  --->
                
                
                <!--- New Users --->
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">New Users</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
						<cfif get_new_users.recordcount eq 0 or CLIENT.usertype gte 6>
                        
                            <em> There are no new reps in your region.</em>
                            
						<cfelse>
                        
							<!--- this is used to display the message if the user was added since last login. --->
                            <cfset since_lastlogin = 0>
                            <!--- this is used to display the message if the user is the advisor of any new users. --->
                            <cfset is_advisor = 0>
                            <table width="100%" cellpadding="4" cellspacing="0">
                                <tr style="font-weight:bold;">
                                	<td></td>
                                    <td>Name & Location</td>
                                    <td>Account Status</td>
                                </tr>
                                <cfloop query="get_new_users"> 
                                
									<cfscript>
										// Get User Paperwork Struct
										stUserPaperwork = APPLICATION.CFC.USER.getUserPaperwork(userID=get_new_users.userID);
                                    </cfscript>
                                
									<!--- put * if user is the advisor for this user. --->
                                    <cfif advisorid EQ CLIENT.userID>
                                    	<font color="FF0000" size="4"><strong>*</strong></font>
                                    	<cfset is_advisor = 1>
                                    </cfif>
                                
                                    <tr>
                                        <td><a href="mailto:#email#"><img src="pics/email.gif" border="0" align="absmiddle"></a></td>
                                        <td>
											<!--- highlight if user was added since last login. --->
                                            <cfif datecreated GTE CLIENT.lastlogin>
                                            <a href="index.cfm?curdoc=user_info&userID=#userID#"><font color="FF0000">#firstname# #lastname#</font></a> <font color="FF0000">of #city#, #state#</font>
                                            <cfset since_lastlogin = 1>
                                            <cfelse>
                                            <a href="index.cfm?curdoc=user_info&userID=#userID#">#firstname# #lastname#</a> of #city#, #state#
                                            </cfif>
                                        </td>
                                        <td>
											<cfif stUserPaperwork.isAccountCompliant>
                                                
                                                Active - Fully Enabled (Paperwork Compliant)
                                                
                                            <cfelseif stUserPaperwork.accountReviewStatus EQ 'rmReview'>
                                               
                                                Active (Initial Paperwork Received) - 
                                                <a href="index.cfm?curdoc=user_info&userID=#get_new_users.userID#">RM - Reference Questionnaires Needed</a>
                                                
                                            <cfelseif stUserPaperwork.accountReviewStatus EQ 'officeReview'>
                                            
                                                Active (Initial Paperwork Received) - 
                                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                                    <a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#get_new_users.userID#">Office Verification Needed</a>
                                                <cfelse>
                                                    Office Verification Needed
                                                </cfif>
                                            
                                            <cfelseif stUserPaperwork.accountReviewStatus EQ 'missingTraining'>
                                                
                                                <cfif NOT stUserPaperwork.isDOSCertificationCompleted AND NOT stUserPaperwork.isTrainingCompleted>
                                                	Active (Initial Paperwork Received) - DOS Certification and AR training needed
                                                <cfelseif NOT stUserPaperwork.isDOSCertificationCompleted>
                                                	Active (Initial Paperwork Received) - DOS Certification training needed
                                                <cfelse>
                                                	Active (Initial Paperwork Received) - AR training needed
                                                </cfif>
                                                  
                                            <cfelse>
                                            
                                                Active - 
                                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                                    <a href="index.cfm?curdoc=user/index&action=paperworkDetails&userID=#get_new_users.userID#">Missing Paperwork</a>
                                                <cfelse>
                                                    Missing Paperwork
                                                </cfif>
                                                
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfloop>
                            </table>
                            
							<cfif since_lastlogin>
                            	<br /><font color="FF0000">users in red were added since your last visit</font>
                            </cfif>
                            
							<cfif is_advisor>
                            	<br /><font color="FF0000" size="4"><strong>*</strong></font> reps assigned to you
                            </cfif>
                            
                    	</cfif>
                        
                    </div>
                    
                	<div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div> 
				<!--- End of New Users --->
                
                <table align="right">
                    <tr>
                        <td>
                            <form name="form" id="form">
                                <font size="1">
                                    Display students & users newer than
                                    <select name="jumpMenu" id="jumpMenu" onchange="MM_jumpMenu('parent',this,0)" class="new_weeks">
                                        <cfloop from="1" to="6" index="i">
                                            <option value="index.cfm?curdoc=initial_welcome&new_weeks=#i#" <cfif URL.new_weeks EQ i>selected="selected"</cfif>>
                                                <cfif I EQ 1>#i# Week<cfelse>#i# Weeks</cfif>
                                            </option>
                                        </cfloop>
                                    </select>
                                </font>
                            </form>
                        </td>
                    </tr>
                </table> 
                
            </div>   

        </cfcase>
        <!--- End of Office + Field --->
        
        
        <!--- Student View --->
        <cfcase value="9">
        
			<!--- Left column --->
            <div style="width:49%;float:left;display:block;">
				
                <!--- News Messages --->
                <div class="rdholder"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">News &amp; Announcements</span> 
                    </div> <!-- end top --> 
                            
                    <div class="rdbox" style="min-height:90px;">
                    	<img src="pics/newsIcon.png" width=100 height=100 align="left">
                        
						<cfif qNewsMessages.recordcount>
                        
                            <cfloop query="qNewsMessages">
                                <p>
                                    <b>#message#</b><br />
                                    #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br />,<br />,<br />')#
                                    <cfif LEN(additional_file)>
                                        <br />
                                        <img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                    </cfif>
                                </p>
                            </cfloop>
                        
                        <cfelse>
                            
                            <p>There are currently no announcements or news items.</p>
                            
                        </cfif>
                        
                    </div>
                            
                    <div class="rdbottom"></div> <!-- end bottom -->                    

				</div> 
                <!--- End of News Messages --->  
                                           
            </div>
        	
            <!--- Right Column --->
            <div style="width:49%;float:right;display:block;">
            
				<!--- Field Bonuses --->
                <div class="rdholder" style="width:100%; float:right;"> 
                    
                    <div class="rdtop"> 
                        <span class="rdtitle">Bonuses</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        <cfinclude template="welcome_includes/adds.cfm">
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                				
                </div>
                <!--- End of Field Bonuses --->
                
            </div>   
        
        </cfcase> 
        <!--- End of Student View --->              
        

        <!--- Second Visit Representative --->
        <cfcase value="15">
        
			<!--- Left column --->
            <div style="width:49%;float:left;display:block;">
				
                <!--- News Messages --->
                <div class="rdholder"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">News &amp; Announcements</span> 
                    </div> <!-- end top --> 
                            
                    <div class="rdbox" style="min-height:90px;">
                    	<img src="pics/newsIcon.png" width=100 height=100 align="left">
                        
						<cfif qNewsMessages.recordcount>
                        
                            <cfloop query="qNewsMessages">
                                <p>
                                    <b>#message#</b><br />
                                    #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br />,<br />,<br />')#
                                    <cfif LEN(additional_file)>
                                        <br />
                                        <img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                    </cfif>
                                </p>
                            </cfloop>
                        
                        <cfelse>
                            
                            <p>There are currently no announcements or news items.</p>
                            
                        </cfif>
                        
                    </div>
                            
                    <div class="rdbottom"></div> <!-- end bottom -->                    

				</div> 
                <!--- End of News Messages --->                   

                <!--- Online Reports --->
                <div class="rdholder" style="width:100%; float:left;"> 
                	
                    <div class="rdtop"> 
                        <span class="rdtitle">Online Reports</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        <table width="90%" align="center" cellpadding="4">
                            <tr>
                                <td><img src="pics/icons/annualPaperwork.png" border="0" title="Click Here to fill out  your annual paperwork" /></td>
                                <td><a href="index.cfm?curdoc=user/index">Yearly Paperwork</a></td>
                                <td></td>
                                <td></td>
               				</tr>
                			<tr>
								<!--- Second Visit Reports --->
                                <td width=22><img src="pics/icons/onlineReports.png" /></td>
                                <td><a href="index.cfm?curdoc=secondVisitReports">Second Visit Reports</a></td>
                			</tr>
                            <tr>
								<!--- Help Project --->
                                <cfif (CLIENT.companyID LTE 5 or CLIENT.companyID EQ 12 or CLIENT.companyID eq 10) and CLIENT.usertype lte 7>
                                    <td width="22"><img src="pics/icons/HelpHours.png" /></td>
                                    <td><a href="index.cfm?curdoc=project_help">H.E.L.P. Community Service Hours</a></td>
                                </cfif>
                                <!---  WebEx --->
                                <cfif APPLICATION.CFC.USER.isOfficeUser() and (CLIENT.companyID eq 10)>
                                    <td width="22"><img src="pics/icons/webex.png" /></td>
                                    <td><a href="index.cfm?curdoc=calendar/index">WebEx Calendar</a></td>
                                </cfif>
                            </tr>
                		</table>
                	</div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                
                </div>
                <!--- End of Online Reports --->

                <!--- Incentives --->
                <!-----
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Incentives</span> 
                    </div> 
                    
                    <div class="rdbox">
						<cfif CLIENT.companyID lte 5>
                            <table width="90%" align="center" cellpadding="4">
                                <tr>
                                    <td width=22><img src="pics/icons/bonus.png" /></td>
                                    <td><a href="uploadedfiles/pdf_docs/ISE/promotion/Pre-Ayp%20Bonus%202012.pdf" target="_blank">Pre-AYP</a> </td>
                                </tr>	
                                <tr>
                                    <td><img src="pics/icons/bonus2.png" /></td>
                                    <td><a href="uploadedfiles/pdf_docs/ISE/promotion/Early%20Placement%20Bonus%202012.pdf" target="_blank">Early Placement</a> </td>
                                </tr>
                                <tr>
                                    <td><img src="pics/icons/bonus.png" /></td>
                                    <td><a href="slideshow/pdfs/CASE/CEOBonus.pdf" target="_blank">CEO Placement Bonus</a></td>
                                </tr>
                            </table>
                        <cfelse>
                            There are currently no available bonuses
                        </cfif>
                    </div>
                    
                	<div class="rdbottom"></div> 
                
                </div>
                ---->
                <!--- End of Incentives --->
                           
            </div>
        	
            <!--- Right Column --->
            <div style="width:49%;float:right;display:block;">
            
				<!--- Field Bonuses --->
                <div class="rdholder" style="width:100%; float:right;"> 
                    
                    <div class="rdtop"> 
                        <span class="rdtitle">Bonuses</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        <cfinclude template="welcome_includes/adds.cfm">
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                				
                </div>
                <!--- End of Field Bonuses --->
                
            </div>   
        
        </cfcase> 
        <!--- End of Second Visit Representative --->              

        
        <!--- Intl. Rep. | Intl. Branch --->
        <cfcase value="8,11">
        
            <cfquery name="qGetParentCompany" datasource="#application.dsn#">
                SELECT 
                	businessname
                FROM 
                	smg_users
                WHERE 
                	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
            </cfquery>
            
            <cfquery name="qGetIntlRepMessages" datasource="#application.dsn#">
                SELECT 
                	*
                FROM 
                	smg_intagent_messages
                WHERE 
                	parentcompany = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentcompany#">
                AND 
                	expires > #now()#
                AND 
                	startdate < #now()#
            </cfquery>
            
            <cfquery name="qGetIntlRepAlerts" dbtype="query">
                SELECT 
                	*
                FROM 
                	qGetIntlRepMessages
                WHERE 
                	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="alert">
            </cfquery>
            
            <cfquery name="qGetIntlRepUpdates" dbtype="query">
                SELECT 
                	*
                FROM 
                	qGetIntlRepMessages
                WHERE 
                	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="update">
            </cfquery>
            
            <cfquery name="qGetIntlRepNews" dbtype="query">
                SELECT 
                	*
                FROM 
                	qGetIntlRepMessages
                WHERE 
                	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="news">
            </cfquery>
            
   			<!--- Left column --->
            <div style="width:44%;float:left;display:block;">

				<!--- News & Announcements --->
                <div class="rdholder" style="width:100%; float:left;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Activities Relating to Today</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                    
                        <table width="100%" cellpadding="4" cellspacing="0" border="0">
                            <tr>
                                <td  valign="top" width="100%">
                                    <img src="pics/tower_100.jpg" width=71 height=100 align="left">
                                    
                                    <cfif NOT VAL(qNewsMessages.recordcount)>
                                        <br>There are currently no announcements or news items.
                                    <cfelse>
                                    
                                        <cfloop query="qNewsMessages">
                                            <p>
                                                <b>#message#</b><br>
                                                #DateFormat(startdate, 'MMMM D, YYYY')# - #replaceList(details, '#chr(13)##chr(10)#,#chr(13)#,#chr(10)#', '<br>,<br>,<br>')#
                                                <cfif LEN(additional_file)>
                                                    <br /><img src="pics/info.gif" height="15" border="0" />&nbsp;<a href="uploadedfiles/news/#additional_file#" target="_blank">Additional Information (pdf)</font></a>
                                                </cfif>
                                            </p>
                                        </cfloop>
                                        
                                    </cfif>
                                    
                                    <cfif CLIENT.usertype GTE 8>
                                        <br><br>Please see below for announcements from your organization.
                                    </cfif>
                                
                                </td>
                                <td align="right" valign="top" rowspan=2></td>
                            </tr>
                        </table>
            
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of News & Announcements --->

				<!--- News and Announcements From Parent Company --->
                <div class="rdholder" style="width:100%; float:left;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Announcements from #qGetParentCompany.businessname#</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                    
                        <table width="100%" cellpadding="4" cellspacing="0" border="0">
                            <tr>
                                <td valign="top">
                                    <h3 style="text-align:center; padding:10px; text-decoration:underline;">News</h3>
                                    <p>
                                        <cfif qGetIntlRepAlerts.recordcount neq 0>
                                            <cfloop query="qGetIntlRepNews">
                                                <cfif qGetIntlRepNews.details is not ''><b>#message#</b><br />
                                                    <div align="justify">#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</div>
                                                </cfif>
                                            </cfloop>
                                        <cfelse>
                                            There are currently no annoucements or news items from #qGetParentCompany.businessname#
                                        </cfif>
                                    </p>
                            
                                    <cfif qGetIntlRepAlerts.recordcount>
                                        <h3 style="text-align:center; padding:10px; text-decoration:underline;">Alerts</h3>
                                        <cfloop query="qGetIntlRepAlerts">
                                            <cfif qGetIntlRepAlerts.details is not ''><b>#message#</b><br />
                                                <p>#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</p>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                            
                                    <cfif qGetIntlRepUpdates.recordcount>
                                        <h3 style="text-align:center; padding:10px; text-decoration:underline;">Updates</h3>
                                        <cfloop query="qGetIntlRepUpdates">
                                            <cfif qGetIntlRepUpdates.details is not ''><b>#message#</b><br />
                                                <p>#DateFormat(startdate, 'MMMM D, YYYY')# - #ParagraphFormat(details)#</p>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                            
                                </td>
                            </tr>
                        </table>
            
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of News and Announcements From Parent Company --->

				<!--- Flight Schedule --->
                <div class="rdholder" style="width:100%; float:left;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Flight Schedule</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                    
                        <p align="center">
                        	Please click on the link below to submit arrival and departure information for your students <br /><br />
                            <a href="index.cfm?curdoc=intRep/index&action=flightInformationList"><img src="pics/flightSchedule.jpg" border="0" align="middle" /></a>
                        </p>
            
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of Flight Schedule --->

			</div> 
			<!--- End of Left column --->
                        
            
            <!--- Right Column --->
            <div style="width:55%;float:right;display:block;">
            
				<!--- Student Applications --->
                <div class="rdholder" style="width:100%; float:right;"> 

                    <div class="rdtop"> 
                        <span class="rdtitle">Student Applications </span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                    	<!--- EF Central Office --->
                        <cfif CLIENT.userID EQ 10115>
                            <cfinclude template="welcome_includes/ef_centraloffice.cfm">
                        <cfelseif CLIENT.userType EQ 11>
                            <cfinclude template="welcome_includes/branch_apps.cfm">
                        <cfelse>
                            <cfinclude template="welcome_includes/int_agent_apps.cfm">
						</cfif>
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
				
                </div>
                <!--- End of Student Applications --->
                      
                <!--- State and Region Availability --->
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">State & Region Availability</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                
                        <table width="100%" cellpadding="4" cellspacing="0" border="0">
                            <tr>
                                <td width="25"><img src="pics/icons/map.png" /></td>
                                <td><a href="javascript:openPopUp('tools/stateStatus.cfm', 875, 675);">Available States</a></td>
                                <td rowspan="2" width="60%"><font size=-1><em>State and Region availability can change at any time, acceptance of choice will not be guranteed until application is submitted for approval</em></font></td>
                            </tr>
                            <tr>
                                <td><img src="pics/icons/region.png" /></td>
                                <td><a href="javascript:openPopUp('tools/regionStatus.cfm', 750, 775);">Available Regions</a></td>
                            </tr>
                        </table>
            
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of State and Region Availability --->
                
				<!--- Help Desk --->
                <div class="rdholder" style="width:100%; float:right;"> 
                
                    <div class="rdtop"> 
                        <span class="rdtitle">Your Current Help Desk Tickets</span> 
                    </div> <!-- end top --> 
                    
                    <div class="rdbox">
                        
                        <table width="100%" cellpadding="4" cellspacing="0" border="0">
                            <tr>
                                <td width="20%">Submitted</td>
                                <td width="50%">Title</td>
                                <td width="20%">Status</td>
                                <td width="10%">&nbsp;</td>
                            </tr>
                            <cfloop query="help_desk_user">
                                <tr bgcolor="###iif(help_desk_user.currentrow MOD 2 ,DE("EEEEEE") ,DE("FFFFFF") )#">
                                    <td>#DateFormat(date, 'mm/dd/yyyy')#</td>
                                    <td>#title#</td>
                                    <td>#status#</td>
                                    <td><a href="index.cfm?curdoc=helpdesk/help_desk_view&helpdeskid=#helpdeskid#">View</a></td>
                                </tr>
                            </cfloop>
                            <cfif NOT VAL(help_desk_user.recordcount)>
                                <tr><td colspan="4" bgcolor="ffffe6" valign="top">You have no open or recently completed tickets on the Help Desk</td></tr>
                            </cfif>
                        </table>
            
                    </div>
                    
                    <div class="rdbottom"></div> <!-- end bottom --> 
                    
                </div>
                <!--- End of Help Desk --->
                
            </div> 
			<!--- End of Right Column --->
        
        </cfcase>
        <!--- End of Intl. Rep. | Intl. Branch --->
                
        
        <!--- Not a valid UserType --->
        <cfdefaultcase>
        	<p>We could not verify your account information, please click on [Logout] and log back in.</p>
        </cfdefaultcase>
    
    </cfswitch>
   
</cfoutput>