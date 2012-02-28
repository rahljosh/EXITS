<!--- ------------------------------------------------------------------------- ----
	
	File:		pending_hosts.cfm
	Author:		Marcus Melo
	Date:		February 13, 2012
	Desc:		Pending Host Families

	Updated:  	

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL variables --->
    <cfparam name="URL.sortBy" default="">
    <cfparam name="URL.sortOrder" default="ASC">

    <!--- Param FORM Variables --->
    <cfparam name="FORM.regionID" default="#CLIENT.regionID#">
    <cfparam name="FORM.userType" default="#CLIENT.userType#">
	
    <cfscript>
		// Get Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(companyID=CLIENT.companyID, userID=CLIENT.userID, usertype=FORM.userType);
	
        // make sure we have a valid sortOrder value
		if ( NOT ListFind("ASC,DESC", URL.sortOrder) ) {
			URL.sortOrder = "ASC";				  
		}
			
		vSetClassNotification = '';
	</cfscript>

    <!--- Field Viewing --->
    <cfif NOT listFind("1,2,3,4", FORM.userType)>
        
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
            s.studentid, 
            s.uniqueID,
            s.hostid, 
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
                	applicationHistory ah
				WHERE
                	ah.foreignTable = <cfqueryparam cfsqltype="cf_sql_varchar" value="smg_hostHistory">
                AND
                	ah.foreignID = sh.historyID
                ORDER BY
                	ah.dateCreated DESC
                LIMIT 1
			) AS placementAction                                	
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		INNER JOIN 
        	smg_programs p ON p.programid = s.programid
		INNER JOIN 
        	smg_hostHistory sh ON sh.studentID = s.studentID
            AND
            	sh.isActive = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
		INNER JOIN
        	smg_companies c ON c.companyID = s.companyID            
		INNER JOIN
        	smg_regions r ON r.regionID = s.regionAssigned
        INNER JOIN user_access_rights uar ON s.placeRepID = uar.userid
            AND 
                s.regionassigned = uar.regionID
        LEFT JOIN 
            smg_users advisor ON uar.advisorID = advisor.userid
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
			overlayClose:false,
			escKey:false, 
			onClosed:function(){ window.location.reload(); }
		});	

	});
	
	// Submit Form
	var submitForm = function() { 
		$("#selectRegionForm").submit();
	}
	// End -->
</script> 	

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        imageName="current_items.gif"
        tableTitle="Pending Placements"
        width="100%"
    />    

	<!--- Field Viewing - REGIONS DROP DOWN LIST --->
    <cfif NOT listFind("1,2,3,4", FORM.userType) AND qGetRegionList.recordcount GT 1>
          <table border="0" cellpadding="4" cellspacing="0" class="section" width="100%">        
              <tr>
                  <td>                      
                      <form name="selectRegionForm" id="selectRegionForm" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
                          You have access to multiple regions filter by Region: &nbsp; 
                          <select name="regionID" id="regionID" onChange="submitForm();" class="xLargeField">
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
        	<td>
				<cfif FORM.userType EQ 7>
                    <p>
                        The following list shows the placements that you have submitted and the status of that placement.  
                        If the report is marked Rejected, you can click on piece of the Host Information to see 
                        why it was rejected and then make the necessary changes or remove the placement.
                    </p>
                <cfelse>
                    <p>
                        The following list shows the placements that you have submitted and the status of those placements.  
                        If the report is marked Rejected, you can click on the Host Information column to see 
                        why it was rejected. From there you can make the necessary changes or remove the placement.
                    </p>   	
                </cfif>
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
            <td class="sectionHeader" width="30%"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='placementAction',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Reason">Reason</a></td>
            <td class="sectionHeader"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='datePISEmailed',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Date PIS Emailed">Date PIS Emailed</a></td>
	        <td class="sectionHeader">Actions</td>
            <td class="sectionHeader" align="center"><a href="#APPLICATION.CFC.UDF.buildSortURL(columnName='timeOnPending',sortBy=URL.sortBy,sortOrder=URL.sortOrder)#" title="Sort By Time on pending..">Time on Pending</a></td>
        </tr>
        
        <cfloop query="qGetPendingHosts">
        
			<cfscript>
	           	// Reset Class Notification
				// vSetClassNotification = '';
				vSetClassNotification = "attention";
			</cfscript>        
        
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
                
                    <!--- Only check paperwork for placements pending HQ approval --->
                    <cfif qGetPendingHosts.host_fam_approved EQ 5 OR ListFind("1,2,3,4", CLIENT.usertype)>
                    
                        <cfscript>
                            // Check if we have CBC and School Acceptance in order to allow PIS to be emailed out
                            vDisplayEmailLink = 0;

                            // Check if Host Family is in compliance
                            vHostInCompliance = APPLICATION.CFC.CBC.checkHostFamilyCompliance(hostID=qGetPendingHosts.hostID, studentID=qGetPendingHosts.studentID);
                            
                            if ( NOT LEN(vHostInCompliance) AND IsDate(qGetPendingHosts.doc_school_accept_date) ) {
                                vDisplayEmailLink = 1;
                            }
                        </cfscript>
                        
                        <cfif NOT isDate(qGetPendingHosts.datePISEmailed) AND VAL(vDisplayEmailLink) AND ListFind("1,2,3,4", CLIENT.userType)>
                            <a href="reports/placementInfoSheet.cfm?uniqueID=#qGetPendingHosts.uniqueID#&closeModal=1" class="jQueryModalPL">[Click to Email]</a>
                        <cfelseif NOT VAL(vDisplayEmailLink)>
                            waiting on CBC <br /> and/or school acceptance
                        <cfelseif isDate(qGetPendingHosts.datePISEmailed)>
                            #DateFormat(qGetPendingHosts.datePISEmailed, 'mm/dd/yyyy')#
                            <cfset vSetClassNotification = "attentionGreen">
						</cfif>
                    
                    <cfelse>
                        n/a
                    </cfif>
                </td>
                <td class="sectionHeader">
                	
                    <cfswitch expression="#qGetPendingHosts.host_fam_approved#">
						
						<!--- Pending HQ Approval --->
                        <cfcase value="5">
                        	
                            <cfif listFind("1,2,3,4", FORM.userType)>
                            	<a href="student/placementMgmt/index.cfm?uniqueID=#qGetPendingHosts.uniqueID#" class="jQueryModalPL">[Click to Approve]</a>
                           	<cfelse>
                           		(Pending HQ Approval)
                            </cfif>
                            
                        </cfcase>                    

						<!--- Pending Regional Manager Approval --->
                        <cfcase value="6">

                            <cfif listFind("1,2,3,4", FORM.userType)>
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
