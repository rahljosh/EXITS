<!--- ------------------------------------------------------------------------- ----
	
	File:		permissionFormPerTour.cfm
	Author:		James Griffiths
	Date:		June 26, 2012
	Desc:		Tours permission form report
				
				#CGI.SCRIPT_NAME#?curdoc=tours/MPDReports/permissionFormPerTour			
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.tourID" default=0;
		param name="FORM.receivedStatus" default="all";
		param name="FORM.outputType" default="onScreen";
		param name="FORM.sendEmail" default=0;

		// Set Report Title To Keep Consistency
		vReportTitle = "Permission Form Per Tour";
	</cfscript>	
	
    <!--- BEGIN - FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
			
            // Trip
            if ( NOT VAL(FORM.tourID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one tour");
            }
		</cfscript>
    	
        <!--- BEGIN - No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>
        
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
            	SELECT
                	st.tripID,
                	st.email,
                    st.studentID,
                    st.permissionForm,
                    st.companyID,
                    ss.firstName,
                    ss.familyLastName,
                    <!--- Use Luke for PHP --->
                    CASE WHEN st.companyID = 6 THEN 7630 ELSE ss.areaRepID END AS areaRepID,
                    CASE WHEN st.companyID = 6 THEN 7630 ELSE rm.userID END AS regionalManagerID,
                    tour.tour_name,
                    tour.tour_date,
                    h.familyLastName AS hostName,
                    h.address,
                    h.city,
                    h.state,
                    h.zip,
                    h.fatherFirstName,
                    h.motherFirstName
               	FROM
                	student_tours st
               	INNER JOIN
                	smg_students ss ON ss.studentID = st.studentID
              	INNER JOIN
                	smg_tours tour ON tour.tour_id = st.tripID
              	LEFT JOIN
                	smg_hosts h ON h.hostID = ss.hostID
              	LEFT JOIN user_access_rights rm ON rm.regionID = ss.regionAssigned
                    AND usertype = 5
               	WHERE
                	tripID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.tourID#" list="yes"> )
              	AND
                	ss.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
              	<cfif FORM.receivedStatus EQ "missing">
                    AND
                        st.permissionForm IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
              	<cfelseif FORM.receivedStatus EQ "received">
                	AND
                        st.permissionForm IS NOT <cfqueryparam cfsqltype="cf_sql_date" null="yes">
                </cfif>
              	ORDER BY
                	familyLastName,
                    firstName           	
            </cfquery>
            
            <!--- Send email to AR's and RM's --->
            <cfif VAL(FORM.sendEmail)>
            	
                <!--- Get all area reps --->
                <cfquery name="qGetAreaReps" datasource="#APPLICATION.DSN#">
                	SELECT userID, firstName, lastName, email
                    FROM smg_users
                    WHERE userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VALUELIST(qGetResults.areaRepID)#" list="yes"> )
                    GROUP BY userID
                </cfquery>
                
                <!--- Loop through all area reps --->
                <cfloop query="qGetAreaReps">
                
                	<!--- Get all students under the current area rep --->
                    <cfquery name="qGetResultsByAreaRep" dbtype="query">
                    	SELECT *
                        FROM qGetResults
                        WHERE areaRepID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                    </cfquery>
                    
                    <!--- Set up email message --->
                    <cfsavecontent variable="message">
                    	Please be advised that the following student(s) have outstanding permission forms for the MPD Trip outlined below. 
                        Please follow up with the student(s) and ensure that the completed permission form is forwarded to both MPD Tours 
                        and the appropriate Area Representative as soon as possible.<br/>
                        Thank you<br/>
                        <ul>
                            <cfloop query="qGetResultsByAreaRep">
                                <li><cfoutput>#firstName# #familyLastName# (###studentID#) - #tour_name# #tour_date#</cfoutput></li>
                            </cfloop>
                        </ul>
                    </cfsavecontent>
                    
                    <!--- Send email to area rep --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#qGetAreaReps.email#">
                        <cfinvokeargument name="email_subject" value="MPD Tours - Outstanding permission forms">
                        <cfinvokeargument name="email_message" value="#message#">
                        <cfinvokeargument name="email_from" value="#CLIENT.emailFrom#">
                        <cfinvokeargument name="isMPDEmail" value="1">
                    </cfinvoke>
                    
                </cfloop>
                
                <!--- Get all regional managers --->
                <cfquery name="qGetRegionalManagers" datasource="#APPLICATION.DSN#">
                	SELECT userID, firstName, lastName, email
                    FROM smg_users
                    WHERE userID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VALUELIST(qGetResults.regionalManagerID)#" list="yes"> )
                    GROUP BY userID
                </cfquery>
                
                <!--- Loop through all regional managers --->
                <cfloop query="qGetRegionalManagers">
                
                	<!--- Get all students under the current regional manager --->
                    <cfquery name="qGetResultsByRegionalManager" dbtype="query">
                    	SELECT *
                        FROM qGetResults
                        WHERE regionalManagerID = <cfqueryparam cfsqltype="cf_sql_integer" value="#userID#">
                    </cfquery>
                    
                    <!--- Set up email message --->
                    <cfsavecontent variable="message">
                    	Please be advised that the following student(s) have outstanding permission forms for the MPD Trip outlined below. 
                        Please follow up with the student(s) and ensure that the completed permission form is forwarded to both MPD Tours 
                        and the appropriate Area Representative as soon as possible.<br/>
                        Thank you<br/>
                        <ul>
                            <cfloop query="qGetResultsByRegionalManager">
                                <li><cfoutput>#firstName# #familyLastName# (###studentID#) - #tour_name# #tour_date#</cfoutput></li>
                            </cfloop>
                        </ul>
                    </cfsavecontent>
                    
                    <!--- Send email to regional manager --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#qGetRegionalManagers.email#">
                        <cfinvokeargument name="email_subject" value="MPD Tours - Outstanding permission forms">
                        <cfinvokeargument name="email_message" value="#message#">
                        <cfinvokeargument name="email_from" value="#CLIENT.emailFrom#">
                        <cfinvokeargument name="isMPDEmail" value="1">
                    </cfinvoke>
                    
                </cfloop>
                
                <!--- Get all program managers --->
                <cfquery name="qGetProgramManagers" datasource="#APPLICATION.DSN#">
                    SELECT *
                    FROM smg_companies
                    WHERE companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#VALUELIST(qGetResults.companyID)#" list="yes"> ) 
                    GROUP BY companyID                  
                </cfquery>
                
                <!--- Loop through all program managers --->
                <cfloop query="qGetProgramManagers">
                	
                    <!--- Get all students under the current program manager --->
                    <cfquery name="qGetResultsByProgramManager" dbtype="query">
                    	SELECT *
                        FROM qGetResults
                        WHERE companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
                    </cfquery>
                    
                    <!--- Set up email message --->
                    <cfsavecontent variable="message">
                    	Please be advised that the following student(s) have outstanding permission forms for the MPD Trip outlined below. 
                        Please follow up with the student(s) and ensure that the completed permission form is forwarded to both MPD Tours 
                        and the appropriate Area Representative as soon as possible.<br/>
                        Thank you<br/>
                        <ul>
                            <cfloop query="qGetResultsByProgramManager">
                                <li><cfoutput>#firstName# #familyLastName# (###studentID#) - #tour_name# #tour_date#</cfoutput></li>
                            </cfloop>
                        </ul>
                    </cfsavecontent>
                    
                    <!--- Send email to program manager --->
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <cfinvokeargument name="email_to" value="#qGetProgramManagers.pm_email#">
                        <cfinvokeargument name="email_subject" value="MPD Tours - Outstanding permission forms">
                        <cfinvokeargument name="email_message" value="#message#">
                        <cfinvokeargument name="email_from" value="#CLIENT.emailFrom#">
                        <cfinvokeargument name="isMPDEmail" value="1">
                    </cfinvoke>
                    
                </cfloop>
                
            </cfif>
            <!--- END - Send email to AR's and RM's --->

		</cfif>
		<!--- END - No Errors Found ---->

	</cfif>
	<!--- END - FORM Submitted --->
    
</cfsilent>

<script type="text/javascript">
	function showHideSendEmailRow() {
		if ($('#receivedStatus').val() == "missing") {
			$('#sendEmailRow').show();	
		} else {
			$('#sendEmailRow').hide();	
		}
	}
</script>

<!--- BEGIN - FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>
    
	<cfoutput>

        <form action="tours/MPDReports/index.cfm?action=permissionFormPerTour" name="permissionFormPerTour" id="permissionFormPerTour" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Tour: <span class="required">*</span></td>
                    <td>
                    	<select name="tourID" id="tourID" class="xLargeField" multiple="multiple" size="6" required>
                        	<cfloop query="qGetToursList">
                            	<option value="#tour_id#">#tour_name#</option>
                            </cfloop>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                	<td class="subTitleRightNoBorder">Received: <span class="required">*</span></td>
                    <td>
                    	<select name="receivedStatus" id="receivedStatus" class="xLargeField" onchange="showHideSendEmailRow();">
                        	<option value="all">All</option>
                            <option value="missing">Missing</option>
                            <option value="received">Received</option>
                        </select>
                    </td>
                </tr>                    
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
                            <option value="onScreen">On Screen</option>
                            <option value="Excel">Excel Spreadsheet</option>
                        </select>
                    </td>		
                </tr>
                <tr id="sendEmailRow" class="on" style="display:none;">
                	<td class="subTitleRightNoBorder">Email:&nbsp;&nbsp;</td>
                    <td>
                    	<input type="checkbox" name="sendEmail" value="1"/>&nbsp;Send email to Area Reps and Regional Managers
                    </td>
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will create a list of permission forms for all students going on the selected tour(s).
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        
        </form>

	</cfoutput>

<!--- FORM Submitted --->
<cfelse>

	<cfif VAL(FORM.sendEmail)>
    	<script type="text/javascript">
			alert("Emails have been sent to the ARs and RMs.");
		</script>
    </cfif>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../../"
    />	
    
    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
    
    <!--- Output in Excel - Do not use GroupBy --->
    <cfif FORM.outputType EQ 'excel'>
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=permissionFormPerTour.xls"> 
      
      	<cfoutput>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
                <tr>
                    <th colspan="6">#vReportTitle#</th>            
                </tr>
                <tr style="font-weight:bold;">
                    <td>Tour</td>
                    <td>Student</td>
                    <td>Host Family</td>
                    <td>Host Family Address</td>
                    <td>Email</td>
                    <td>Permission Form</td>
                </tr>
       	</cfoutput>
            
            <cfscript>
                vRowNumber = 0;
            </cfscript>
            
            <cfloop list="#FORM.tourID#" index="i">
            
                <cfquery name="qGetStudentsPerTour" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetResults
                    WHERE
                        tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
                </cfquery>
                
                <cfoutput query="qGetStudentsPerTour" group="studentID">
                
                    <cfscript>
                        // Set Row Color
                        if ( vRowNumber MOD 2 ) {
                            vRowColor = 'bgcolor="##E6E6E6"';
                        } else {
                            vRowColor = 'bgcolor="##FFFFFF"';
                        }
                    </cfscript>
                
                    <tr>
                        <td #vRowColor#>#tour_name#</td>
                        <td #vRowColor#>#firstName# #familyLastName# (###studentID#)</td>
                        <td #vRowColor#>
                            #fatherFirstName#
                            <cfif LEN(fatherFirstName) AND LEN(motherFirstName)>
                                &
                            </cfif>
                            #motherFirstName#
                            #hostName#
                        </td>
                        <td #vRowColor#>#address# #city#, #state# #zip#</td>
                        <td #vRowColor#>#email#</td>
                        <td #vRowColor# align="left">
                            <cfif LEN(permissionForm)>
                                #DateFormat(permissionForm, 'mm/dd/yyyy')#
                            <cfelse>
                                <span style="color:red;">Missing</span>
                            </cfif>
                        </td>
                    </tr>
                    
                    <cfscript>
                        vRowNumber++;
                    </cfscript>
                    
                </cfoutput>
            
            </cfloop>
            
        </table>
        
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfoutput>
            
			<!--- Include Report Header --->   
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th width="34%">#vReportTitle#</th>       
                </tr>
            </table>
            
            <!--- No Records Found --->
            <cfif NOT VAL(qGetResults.recordCount)>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr class="on">
                        <td class="subTitleCenter">No records found</td>
                    </tr>      
                </table>
                <cfabort>
            </cfif>
        
        </cfoutput>
        
        <cfloop list="#FORM.tourID#" index="i">
            
            <cfquery name="qGetStudentsPerTour" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                WHERE
                    tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
            </cfquery>
            
            <cfset totalPerTour = 0>
            
            <cfoutput query="qGetStudentsPerTour" group="studentID">
            	<cfset totalPerTour++>
            </cfoutput>
            
            <cfoutput>
            
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th class="left" width="20%">
                        <th class="center" width="50%" colspan="3">#qGetStudentsPerTour.tour_name#</th>
                        <th class="right" width="20%">Total of #totalPerTour# students</th>
                    </tr>
                    <tr>
                        <td class="subTitleLeft" width="20%">Student</td>
                        <td class="subTitleLeft" width="20%">Host Family</td>
                        <td class="subTitleLeft" width="20%">Host Family Address</td>
                        <td class="subTitleLeft" width="20%">Email</td>
                        <td class="subTitleLeft" width="20%">Permission Form</td>
                    </tr>
                    
       		</cfoutput>
            
                <cfoutput query="qGetStudentsPerTour" group="studentID">
                    <tr class="#iif(qGetStudentsPerTour.currentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>
                            #firstName# #familyLastName# (###studentID#)
                        </td>
                        <td>
                            #fatherFirstName#
                            <cfif LEN(fatherFirstName) AND LEN(motherFirstName)>
                                &
                            </cfif>
                            #motherFirstName#
                            #hostName#
                        </td>
                        <td>
                            #address# #city#, #state# #zip#
                        </td>
                        <td>
                            #email#
                        </td>
                        <td>
                            <cfif LEN(permissionForm)>
                                #DateFormat(permissionForm, 'mm/dd/yyyy')#
                            <cfelse>
                                <span style="color:red;">Missing</span>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            
            </table>
                
        </cfloop>
        
    </cfif>
    
    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    