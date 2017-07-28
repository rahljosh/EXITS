<!--- ------------------------------------------------------------------------- ----
    
    File:       pending_hosts.cfm
    Author:     Marcus Melo
    Date:       February 13, 2012
    Desc:       Pending Host Families

    Updated:    08/03/2012 - Placement Type added

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <cfsetting requesttimeout="9999">

    <!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />   
    
    <!--- Param URL variables --->
    <cfparam name="URL.sortBy" default="">
    <cfparam name="URL.sortOrder" default="ASC">
    <cfparam name="URL.preAypCamp" default="">
    <!--- Default Facilitators, field, CASE and ESI to All --->
    <cfif ListFind("4,5,6,7", CLIENT.userType) OR listFind("10,14", CLIENT.companyID)>
        <cfparam name="URL.placementType" default="All">
    <cfelse>
        <cfparam name="URL.placementType" default="newPlacements">
    </cfif>
    <!--- Param FORM Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.preAypCamp" default="">
    <cfparam name="FORM.placementType" default="">
    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
    <cfparam name="FORM.userType" default="#CLIENT.userType#">
    
    <cfscript>
        // Get Regions
        qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=FORM.userType);

        // Get AYP English Camps
        qAYPEnglishCamps = APPCFC.SCHOOL.getAYPCamps(campType='english');   

        vSetClassNotification = '';

        // make sure we have a valid sortOrder value
        if ( NOT ListFind("ASC,DESC", URL.sortOrder) ) {
            URL.sortOrder = "ASC";                
        }

        // Build New URL based on preAypCAmp and Placement Type Selection in order to keep the option selected when refreshing the page
        if ( VAL(FORM.submitted) ) {

            // rebuilt QueryString and remove placementType and preAypCamp
            vNewQueryString = CGI.QUERY_STRING;

            // Clean Up preAypCamp URL
            if ( ListContainsNoCase(vNewQueryString, "preAypCamp", "&") ) {
                vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "preAypCamp", "&"), "&");
            }
            
            // Clean Up placementType URL
            if ( ListContainsNoCase(vNewQueryString, "placementType", "&") ) {
                vNewQueryString = ListDeleteAt(vNewQueryString, ListContainsNoCase(vNewQueryString, "placementType", "&"), "&");
            }
            
            // Get Current URL
            vNewURL = CGI.SCRIPT_NAME & "?" & vNewQueryString;
            
            if ( LEN(FORM.placementType) ) {
                vNewURL = vNewURL & "&placementType=" & FORM.placementType;
            }
            
            if ( LEN(FORM.preAypCamp) ) {
                vNewURL = vNewURL & "&preAypCamp=" & FORM.preAypCamp;
            }
            
            // Reload Page with proper URL variables
            location(vNewURL, "no");
            
        }
    </cfscript>

    <!--- Field Viewing --->
    <cfif NOT APPLICATION.CFC.USER.isOfficeUser()>
        
        <!--- Get Usertype From Selected Region --->
        <cfquery name="qGetUserTypeByRegion" datasource="#APPLICATION.DSN#"> 
            SELECT 
                uar.regionID, 
                uar.usertype, 
                u.usertype AS user_access
            FROM 
                user_access_rights uar
            INNER JOIN 
                smg_usertype u ON  u.usertypeid = uar.usertype
            WHERE 
                userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
            AND 
                companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">    
            AND 
                uar.usertype != <cfqueryparam cfsqltype="cf_sql_integer" value="9">
            AND 
                uar.regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#">
        </cfquery>  
        
        <cfscript>
            // Set new access level based on region choice
            FORM.userType = qGetUserTypeByRegion.userType;
            
            // User Does Not Have Access - Set default values
            if ( NOT VAL(qGetUserTypeByRegion.recordCount) ) {
                FORM.userType = CLIENT.userType;
                FORM.regionID = CLIENT.regionID;
            }
        </cfscript>
        
    </cfif>
    
    <cfquery name="qGetPendingHosts" datasource="#APPLICATION.DSN#">
        SELECT 
            DISTINCT
             s.hostid, 
            s.studentid, 
            s.uniqueID,
           
            s.firstname AS studentFirstName, 
            s.familylastname AS studentLastName, 
            s.regionAssigned, 
            s.placeRepID,
            s.dateplaced,
            s.host_fam_approved,
            DATEDIFF(CURRENT_DATE(), s.date_host_fam_approved) AS timeOnPending, 
            s.date_host_fam_approved, 
            sh.datePISEmailed,
            sh.doc_school_accept_date,
            h.familylastname AS hostFamilyLastName, 
            h.fatherFirstName, 
            h.fatherLastName, 
            h.motherLastName, 
            h.motherFirstName, 
            h.city, 
            h.state,  
            p.programname,
            c.companyShort,
            r.regionName,
            advisor.userID AS advisorID,            
            ( 
                SELECT
                    ah.actions
                FROM
                    applicationhistory ah
                WHERE
                    ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hosthistory">
                AND
                    ah.foreignID = sh.historyID
                ORDER BY
                    ah.dateCreated DESC
                LIMIT 1
            ) AS placementAction,
            notes.appNotes                                  
        FROM 
            smg_students s
        INNER JOIN 
            smg_hosts h ON s.hostid = h.hostid
        INNER JOIN 
            smg_programs p ON p.programid = s.programid
        INNER JOIN 
            smg_hosthistory sh ON sh.studentID = s.studentID
            AND
                sh.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                sh.assignedID = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- Filter out PHP --->
        INNER JOIN
            smg_companies c ON c.companyID = s.companyID            
        INNER JOIN
            smg_regions r ON r.regionID = s.regionAssigned
        INNER JOIN user_access_rights uar ON s.placeRepID = uar.userID
            AND 
                s.regionassigned = uar.regionID
        LEFT JOIN 
            smg_users advisor ON uar.advisorID = advisor.userID
        LEFT OUTER JOIN 
            smg_aypcamps english ON s.aypenglish = english.campID
        LEFT OUTER JOIN
            smg_notes notes ON notes.hostid = h.hostid
        WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">   
                
        <cfif CLIENT.companyID EQ 5>
            AND
                s.companyid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes"> )
        <cfelse>            
            AND
                s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
        <!--- Pre-AYP Filter --->
        <cfif URL.preAypCamp EQ 'All'>
            AND 
                s.aypenglish = english.campID 
        <cfelseif VAL(URL.preAypCamp)>
            AND 
                s.aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.preAypCamp#">
        </cfif>        
        
        <!--- Placement Type --->
        <cfif URL.placementType EQ 'newPlacements'>
            AND
                sh.datePlaced IS NULL
            AND
                sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        <cfelseif URL.placementType EQ 'previouslyApproved'>
            AND
                sh.datePlaced IS NOT NULL
            AND
                sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
        <cfelseif URL.placementType EQ 'relocations'>
            AND
                sh.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        </cfif>

        <cfswitch expression="#FORM.userType#">
            
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
                    s.regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#">
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
        
        ORDER BY
        
        <cfswitch expression="#URL.sortBy#">
            
            <cfcase value="studentID">                    
                s.studentID #URL.sortOrder#,
                studentLastName
            </cfcase>
        
            <cfcase value="studentLastName">
                studentLastName #URL.sortOrder#
            </cfcase>

            <cfcase value="studentFirstName">
                studentFirstName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="regionName">
                r.regionName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="programName">
                p.programName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="hostFamilyLastName">
                hostFamilyLastName #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="placementAction">
                placementAction #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="datePISEmailed">
                sh.datePISEmailed #URL.sortOrder#,
                studentLastName
            </cfcase>

            <cfcase value="actions">
                s.host_fam_approved #URL.sortOrder#,
                p.programName ASC,
                studentLastName
            </cfcase>

            <cfcase value="timeOnPending">
                timeOnPending #URL.sortOrder#,
                studentLastName
            </cfcase>
            
            <!--- Default by program | if field default by approval level --->
            <cfdefaultcase>
                s.host_fam_approved,
                p.programName ASC,
                studentLastName
            </cfdefaultcase>

        </cfswitch>
        
    </cfquery>
    
</cfsilent>   

<script language="javascript">  
    <!-- Begin

    // Document Ready!
    $(document).ready(function() {

        // JQuery Modal - Refresh Student Info page after closing placement management
        $(".jQueryModalPL").colorbox( {
            width:"60%", 
            height:"90%", 
            iframe:true,
            
            onClosed:function(){ window.location.reload(); }
        }); 
        
        // Submit preAypCamp form when option changes
        $("#placementType").change(function() {
            $("#placementFilterForm").submit();
        });

        // Submit Placement Type form when option changes
        $("#preAypCamp").change(function() {
            $("#placementFilterForm").submit();
        });

        // Submit regionSelectForm form when option changes
        $("#regionSelectForm").change(function() {
            $("#regionSelectForm").submit();
        });

    });

        
</script>

<cfoutput>

    <!--- Table Header --->
    <gui:tableHeader
        imageName="current_items.gif"
        tableTitle="Pending Placements"
        width="100%"
    />    
    
    <!--- Office Users - PreAyp Filter --->
    <cfif APPLICATION.CFC.USER.isOfficeUser()>
        <form name="placementFilterForm" id="placementFilterForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
            <input type="hidden" name="submitted" value="1">
            <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">        
                <tr>
                    <td>                      
                        <label for="placementType">Placement Type:</label> &nbsp; 
                        <select name="placementType" id="placementType" class="largeField">
                            <option value="All" <cfif URL.placementType EQ 'All'> selected="selected" </cfif> >All</option>
                            <option value="newPlacements" <cfif URL.placementType EQ 'newPlacements'> selected="selected" </cfif> >New Placements</option>
                            <option value="previouslyApproved" <cfif URL.placementType EQ 'previouslyApproved'> selected="selected" </cfif> >Previously Approved</option>
                            <option value="relocations" <cfif URL.placementType EQ 'relocations'> selected="selected" </cfif> >Relocations</option>
                        </select>
                    </td>
                    <td>
                        <label for="preAypCamp">Pre-AYP Camp:</label> &nbsp; 
                        <select name="preAypCamp" id="preAypCamp" class="largeField">
                            <option value="" <cfif NOT LEN(URL.preAypCamp)> selected="selected" </cfif> ></option>
                            <option value="All" <cfif URL.preAypCamp EQ 'All'> selected="selected" </cfif> >All Pre-AYP Camps</option>
                            <cfloop query="qAYPEnglishCamps">
                                <option value="#qAYPEnglishCamps.campID#" <cfif URL.preAypCamp EQ qAYPEnglishCamps.campID> selected="selected" </cfif> >#qAYPEnglishCamps.name#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
            </table> 
        </form>                        
    <!--- Field Viewing - REGIONS DROP DOWN LIST --->
    <cfelseif NOT APPLICATION.CFC.USER.isOfficeUser() AND qGetRegionList.recordcount GT 1>
        <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">        
            <tr>
                <td>                      
                    <form name="regionSelectForm" id="regionSelectForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                        <label for="regionID">You have access to multiple regions filter by Region:</label> &nbsp; 
                        <select name="regionID" id="regionID" class="xLargeField">
                            <cfloop query="qGetRegionList">
                                <option value="#qGetRegionList.regionID#" <cfif FORM.regionID EQ qGetRegionList.regionID>selected</cfif>>#qGetRegionList.regionname# - #qGetRegionList.userAccessLevel#</option>
                            </cfloop>
                        </select>
                    </form> 
                </td>
            </tr>
        </table>            
    </cfif> 
    
    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">     
        <tr>
            <td width="85%">
                <cfif FORM.userType EQ 7>
                    The following list shows the placements that you have submitted and the status of that placement.
                    If the report is marked Rejected, you can click on piece of the Host Information to see 
                    why it was rejected and then make the necessary changes or remove the placement.
                <cfelse>
                    The following list shows the placements that you have submitted and the status of those placements.  
                    If the report is marked Rejected, you can click on the Host Information column to see 
                    why it was rejected. From there you can make the necessary changes or remove the placement.
                </cfif>
            </td>
            <td align="right" width="15%">
                <strong>#qGetPendingHosts.recordCount# records</strong>
            </td>
        </tr>
    </table>                                

    <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">
        <tr>
            <td class="sectionHeader" colspan="5" align="center" bgcolor="##afcee3">
                <strong>S T U D E N T &nbsp;&nbsp;&nbsp; I N F O</strong>
            </td>
            <td class="sectionHeader" colspan="5" align="center" bgcolor="##ede3d0">
                <strong>P L A C E M E N T &nbsp;&nbsp;&nbsp; I N F O</strong>
            </td>
        </tr>
        <tr style="font-weight:bold;">
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentID',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Student ID">Student ID</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Last Name">Last Name</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='studentFirstName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By First Name">First Name</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='regionName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Region">Region</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='programName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Program">Program</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='hostFamilyLastName',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Host Family">Host Family</a></td>
            <td class="sectionHeader" width="380"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='placementAction',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Reason">Reason</a></td>
            <td class="sectionHeader" width="120">Notes</td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='datePISEmailed',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Date PIS Emailed">Date PIS Emailed</a></td>
            <td class="sectionHeader">Actions</td>
            <td class="sectionHeader" align="center"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='timeOnPending',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Time on pending..">Time on Pending</a></td>
        </tr>
        <td>
                
            </td> 
        <cfloop query="qGetPendingHosts">
        
            <cfscript>
                // Set Default Value
                vTimeOnPending = 'n/a';
                
                // Set Default Value
                vNumberWaiting = 'n/a';

                // Reset Class Notification
                vSetClassNotification = "attention";
            
                // Only check paperwork for placements pending HQ approval
                if ( qGetPendingHosts.host_fam_approved EQ 5 OR APPLICATION.CFC.USER.isOfficeUser() ) {
                
                    // Check if we have CBC and School Acceptance in order to allow PIS to be emailed out
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
                
                    if ( NOT isDate(qGetPendingHosts.datePISEmailed) AND VAL(vDisplayEmailLink) AND APPLICATION.CFC.USER.isOfficeUser() ) {
                        
                        vTimeOnPending = '<a href="reports/placementInfoSheet.cfm?uniqueID=#qGetPendingHosts.uniqueID#&closeModal=1" class="jQueryModalPL">[Click to Email]</a>';
                        
                    } else if ( NOT VAL(vDisplayEmailLink) AND CLIENT.userID NEQ 1956 ) { // Wayne
                    
                        vTimeOnPending = 'waiting on CBC <br /> and/or school acceptance';
                        
                    } else if ( isDate(qGetPendingHosts.datePISEmailed) ) {
                        
                        vSetClassNotification = "attentionGreen";
                        vTimeOnPending = '#DateFormat(qGetPendingHosts.datePISEmailed, 'mm/dd/yyyy')#';
                        
                        
                    }
                
                }
                
                // Set Default Value
                vDisplayStudent = true;
                
                // If selecting Pre-AYP display only students that are pending documents
                if ( LEN(URL.preAypCamp) AND vSetClassNotification EQ 'attentionGreen' ) {
                    vDisplayStudent = true;
                }
            </cfscript>
            
            <cfif vDisplayStudent>
            
                <tr bgcolor="#iif(qGetPendingHosts.currentRow MOD 2 ,DE("eeeeee") ,DE("white") )#">
                    <td class="sectionHeader" ><a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">#qGetPendingHosts.studentid#</a></td>
                    <td class="sectionHeader"><a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">#qGetPendingHosts.studentLastName#</a></td>
                    <td class="sectionHeader"><a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">#qGetPendingHosts.studentFirstName#</a></td>
                    <td class="sectionHeader">
                        <cfif CLIENT.companyID EQ 5>
                            #qGetPendingHosts.companyShort# - 
                        </cfif>
                        #qGetPendingHosts.regionname#
                    </td>
                    <td class="sectionHeader">#qGetPendingHosts.programname#</td>
                    <td class="sectionHeader">
                        <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">
                            #APPLICATION.CFC.HOST.displayHostFamilyName(
                                hostID=qGetPendingHosts.hostID,
                                fatherFirstName=qGetPendingHosts.fatherFirstName,
                                fatherLastName=qGetPendingHosts.fatherLastName,
                                motherFirstName=qGetPendingHosts.motherFirstName,
                                motherLastName=qGetPendingHosts.motherLastName,
                                familyLastName=qGetPendingHosts.hostFamilyLastName
    
                            )#
                        </a>            
                    </td>
                    <td class="sectionHeader">#qGetPendingHosts.placementAction#</td>
                    <td class="sectionHeader">
                        <a href="pending-list/appNotes.cfm?hostID=#qGetPendingHosts.hostid#" class="jQueryModalPL" title="Open Notes">
                            <cfif qGetPendingHosts.appNotes is ''>
                                <button type="button" class="btn btn-default btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> Add Notes</button>
                            <cfelse>
                                <button type="button" class="btn btn-warning btn-sm"><i class="fa fa-comments-o" aria-hidden="true"></i> See Notes</button>
                            </cfif>
                        </a>
                    </td>
                    <td class="sectionHeader">#vTimeOnPending#</td>
                    <td class="sectionHeader">
                        
                        <cfswitch expression="#qGetPendingHosts.host_fam_approved#">
                            
                            <!--- Pending HQ Approval --->
                            <cfcase value="5">
                                
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">[Click to Approve]</a>
                                <cfelse>
                                    (Pending HQ Approval)
                                </cfif>
                                
                            </cfcase>                    
    
                            <!--- Pending Regional Manager Approval --->
                            <cfcase value="6">
    
                                <cfif APPLICATION.CFC.USER.isOfficeUser()>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL" style="display:block;">[Click to Approve]</a>
                                </cfif>
                                
                                <cfif FORM.userType EQ 5>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">[Click to Approve]</a>
                                <cfelse>
                                    (Pending RM Approval)
                                </cfif>
                                
                            </cfcase>                    
                            
                            <!--- Pending Regional Advisor Approval --->
                            <cfcase value="7">
    
                                <cfif listFind("1,2,3,4,5", FORM.userType)>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL" style="display:block;">[Click to Approve]</a>
                                </cfif>
                                
                                <cfif CLIENT.userID EQ qGetPendingHosts.advisorID>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">[Click to Approve]</a>
                                <cfelseif VAL(qGetPendingHosts.advisorID)>
                                    (Pending RA Approval)
                                <cfelse>
                                    (Pending RM Approval)
                                </cfif>
                                
                            </cfcase>                    
                        
                            <!--- Pending Area Representative Approval --->
                            <cfcase value="10">
    
                                <cfif listFind("1,2,3,4,5,6", FORM.userType)>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL" style="display:block;">[Click to Approve]</a>
                                </cfif>
                                
                                <cfif CLIENT.userID EQ qGetPendingHosts.placeRepID>
                                    <a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">[Click to Approve]</a>
                                <cfelse>
                                    (Pending AR Approval)
                                </cfif>
                                
                            </cfcase>                    
                            
                            <!--- Rejected --->
                            <cfcase value="99">
                                Rejected
                                <cfset vSetClassNotification = "rejected">
                            </cfcase>                    
    
                        </cfswitch>
                    </td>
                    <td class="sectionHeader #vSetClassNotification#" align="center">   
                        #APPLICATION.CFC.UDF.calculateTimePassed(dateStarted=qGetPendingHosts.date_host_fam_approved, dateEnded=now())#    
                    </td>
                </tr>

            </cfif>
                
        </cfloop>
        
    </table>

    <!--- Table Footer --->
    <gui:tableFooter 
        width="100%"
    />
    
    <p style="margin-top:10px;">*you can override anyone below you in the approval process. You can not approve past your level.</p>

    <table align="center" cellpadding="4" cellspacing="0" class="nav_bar">
        <th bgcolor="##CC0000" ><font color="##FFFFFF">Key</font></th>
        <tr class="attention">
            <td align="Center">Waiting for CBC and/or School Acceptance Form</td>
        </tr>
        <tr class="attentionGreen">
            <td align="Center">Waiting for Host Family Application</td>
        </tr>
            <tr class="rejected">
            <td align="Center">Rejected</td>
        </tr>
    </table>

</cfoutput>