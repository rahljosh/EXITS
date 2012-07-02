<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInformationPerTour.cfm
	Author:		James Griffiths
	Date:		June 26, 2012
	Desc:		Flight Information report
				
				#CGI.SCRIPT_NAME#?curdoc=report/MPDReports/flightInformationPerTour			
				
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
		param name="FORM.flightStatus" default="all";
		param name="FORM.outputType" default="onScreen";

		// Set Report Title To Keep Consistency
		vReportTitle = "Flight Information Per Tour";
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
                    ss.firstName,
                    ss.familyLastName,
                    tour.tour_name,
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
              	INNER JOIN
                	smg_hosts h ON h.hostID = ss.hostID
               	WHERE
                	st.tripID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.tourID#" list="yes"> )
              	AND
                	ss.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
              	<cfif FORM.flightStatus EQ "missing">
                    AND
                        ( 
                        	st.studentID NOT IN ( SELECT studentID FROM student_tours_flight_information WHERE studentID = st.studentID AND tripID = st.tripID AND flightType = "arrival" )
                     		OR
                         	st.studentID NOT IN ( SELECT studentID FROM student_tours_flight_information WHERE studentID = st.studentID AND tripID = st.tripID AND flightType = "departure" )
                     	)
              	<cfelseif FORM.flightStatus EQ "received">
                	AND
                        ( 
                        	st.studentID IN ( SELECT studentID FROM student_tours_flight_information WHERE studentID = st.studentID AND tripID = st.tripID AND flightType = "arrival" )
                     		AND
                         	st.studentID IN ( SELECT studentID FROM student_tours_flight_information WHERE studentID = st.studentID AND tripID = st.tripID AND flightType = "departure" )
                     	)
                </cfif>
              	ORDER BY
                	familyLastName,
                    firstName           	
            </cfquery>

		</cfif>
		<!--- END - No Errors Found ---->

	</cfif>
	<!--- END - FORM Submitted --->
    
</cfsilent>

<!--- BEGIN - FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>
    
	<cfoutput>

        <form action="report/MPDReports/index.cfm?action=flightInformationPerTour" name="flightInformationPerTour" id="flightInformationPerTour" method="post" target="blank">
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
                	<td class="subTitleRightNoBorder">Flight Status: <span class="required">*</span></td>
                    <td>
                    	<select name="flightStatus" id="flightStatus" class="xLargeField">
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
        <cfheader name="Content-Disposition" value="attachment; filename=flightInformationPerTour.xls"> 
      
      	<cfoutput>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
                <tr>
                    <th colspan="7">#vReportTitle#</th>            
                </tr>
                <tr style="font-weight:bold;">
                    <td>Tour</td>
                    <td>Student</td>
                    <td>Host Family</td>
                    <td>Host Family Address</td>
                    <td>Email</td>
                    <td>Arrival Flight</td>
                    <td>Departure Flight</td>
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
                
                	<cfquery name="qGetArrivalFlight" datasource="#APPLICATION.DSN#">
                    	SELECT
                        	departDate
                      	FROM
                        	student_tours_flight_information
                       	WHERE
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.studentID#">
                      	AND
                        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.tripID#">
                       	AND
                        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                      	ORDER BY
                        	departDate
                    </cfquery>
                    
                    <cfquery name="qGetDepartureFlight" datasource="#APPLICATION.DSN#">
                    	SELECT
                        	departDate
                      	FROM
                        	student_tours_flight_information
                       	WHERE
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.studentID#">
                      	AND
                        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.tripID#">
                       	AND
                        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                      	ORDER BY
                        	departDate
                    </cfquery>
                
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
                            <cfif LEN(qGetArrivalFlight.departDate)>
                                #DateFormat(qGetArrivalFlight.departDate, 'mm/dd/yyyy')#
                            <cfelse>
                                <span style="color:red;">Missing</span>
                            </cfif>
                        </td>
                        <td #vRowColor# align="left">
                            <cfif LEN(qGetDepartureFlight.departDate)>
                                #DateFormat(qGetDepartureFlight.departDate, 'mm/dd/yyyy')#
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
                        <th class="left" width="86%" colspan="5">#qGetStudentsPerTour.tour_name#</th>
                        <th class="right" width="14%">Total of #totalPerTour# students</th>
                    </tr>
                    <tr>
                        <td class="subTitleLeft" width="20%">Student</td>
                        <td class="subTitleLeft" width="20%">Host Family</td>
                        <td class="subTitleLeft" width="24%">Host Family Address</td>
                        <td class="subTitleLeft" width="16%">Email</td>
                        <td class="subTitleLeft" width="10%">Arrival Flight</td>
                        <td class="subTitleLeft" width="10%">Departure Flight</td>
                    </tr>
                    
       		</cfoutput>
            
                <cfoutput query="qGetStudentsPerTour" group="studentID">
                	
                    <cfquery name="qGetArrivalFlight" datasource="#APPLICATION.DSN#">
                    	SELECT
                        	departDate
                      	FROM
                        	student_tours_flight_information
                       	WHERE
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.studentID#">
                      	AND
                        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.tripID#">
                       	AND
                        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
                      	ORDER BY
                        	departDate
                    </cfquery>
                    
                    <cfquery name="qGetDepartureFlight" datasource="#APPLICATION.DSN#">
                    	SELECT
                        	departDate
                      	FROM
                        	student_tours_flight_information
                       	WHERE
                        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.studentID#">
                      	AND
                        	tripID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsPerTour.tripID#">
                       	AND
                        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                      	ORDER BY
                        	departDate
                    </cfquery>
                
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
                            <cfif LEN(qGetArrivalFlight.departDate)>
                                #DateFormat(qGetArrivalFlight.departDate, 'mm/dd/yyyy')#
                            <cfelse>
                                <span style="color:red;">Missing</span>
                            </cfif>
                        </td>
                        <td>
                            <cfif LEN(qGetDepartureFlight.departDate)>
                                #DateFormat(qGetDepartureFlight.departDate, 'mm/dd/yyyy')#
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