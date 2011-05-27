<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInfoByIntlRep.cfm
	Author:		Marcus Melo
	Date:		May 26, 2011
	Desc:		Flight Information By Intl Rep

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
	
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.flightType" default="">

	<cfscript>
        // Data Validation
        // Program ID
        if ( NOT LEN(FORM.programID) ) {
            SESSION.formErrors.Add("Please select at least one program");
        }
        // Flight Type
        if ( NOT LEN(FORM.flightType) ) {
            SESSION.formErrors.Add("Please select a report option");
        }
		
        // Set Up Report Colors
        if ( FORM.flightType EQ 'Departure' ) {
            vColorTitle = 'FDCEAC';
            vColorRow = 'FEE6D3';
        } else if ( FORM.flightType EQ 'preAypArrival' )
            vColorTitle = 'A0D69A';
            vColorRow = 'DDF0DD';
		else {
            vColorTitle = 'ACB9CD';
            vColorRow = 'D5DCE5';
        }
    </cfscript>

    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT DISTINCT 
            p.programID, 
            p.programname, 
            c.companyshort
        FROM 	
        	smg_programs p
        INNER JOIN 
        	smg_companies c ON c.companyid = p.companyid
        WHERE 		
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>

    <!--- get Students  --->
    <Cfquery name="qGetResults" datasource="MySQL">
        SELECT DISTINCT
            s.studentID, 
            s.programID,
            s.schoolID,
            s.firstname, 
            s.familylastname, 
            u.userID, 
            u.businessname 
		FROM 
            smg_students s
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN
        	smg_flight_info fi ON fi.studentID AND s.studentID 
				AND
                	fi.programID = s.programID                     
            	AND 
                	fi.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.flightType#">
                AND
                	fi.isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        WHERE
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
        AND 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        
            <cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
            </cfif>        
            
			<cfif VAL(FORM.intrep)>
                AND
                    s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
            </cfif>
            
        ORDER BY 
            u.businessName,
            s.familyLastName,
            s.firstName
    </cfquery>  
    
</cfsilent>    

<!--- Display Errors --->
<cfif SESSION.formErrors.length()>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

		<!--- Table Header --->
        <gui:tableHeader
            imageName="students.gif"
            tableTitle="Flight Information Reports"
            width="98%"
            imagePath="../"
        />
    
        <!--- Page Messages --->
        <gui:displayPageMessages 
            pageMessages="#SESSION.pageMessages.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />
    
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="98%"
            />	
    
        <!--- Table Footer --->
        <gui:tableFooter 
            width="98%"
            imagePath="../"
        />

	<!--- Page Footer --->
    <gui:pageFooter
        footerType="application"
        width="98%"
    />

<!--- Report --->
<cfelse>

	<cfoutput>
    
        <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:10px;">
            <tr>
                <td align="center">
                    <p style="font-weight:bold;">#CLIENT.companyshort# -  Received #FORM.flightType# Flight Information By International Representative.</p>
                    
                    Program(s) Included in this Report: <br />
                    <cfloop query="qGetPrograms">
                        <strong>#qGetPrograms.programname# &nbsp; (###qGetPrograms.programID#)</strong><br />
                    </cfloop>
                    
                    <p>Total of #qGetResults.recordcount# active students</p> 
                </td>
            </tr>
        </table>
    
        <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157; margin-top:10px;">
            <tr bgcolor="###vColorTitle#" style="font-weight:bold;">
                <td width="35%">Student</td>
                <td width="35%">International Representative</td>
                <td width="30%">School End Date</td>
            </tr>
        </table>
        <br />    
        
        <cfloop query="qGetResults">
            
            <cfscript>
                // Get School Dates
                qGetSchoolDates = APPLICATION.CFC.SCHOOL.getSchoolDates(schoolID=qGetResults.schoolID, programID=qGetResults.programID);
                
                // Get Flight Information
                qGetFlightInfo = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetResults.studentID, programID=qGetResults.programID, flightType=FORM.flightType);
            </cfscript>
            
            <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border-top:1px solid ##021157; border-right:1px solid ##021157; border-left:1px solid ##021157;">
                <tr bgcolor="###vColorTitle#" style="font-weight:bold;">
                    <td width="35%">#qGetResults.firstName# #qGetResults.familyLastName# (###qGetResults.studentID#)</td> 
                    <td width="35%">#qGetResults.businessName# (###qGetResults.userID#)</td>  
                    <td width="30%">
                    	<cfif FORM.flightType EQ 'departure'>
                            School End Date: <cfif LEN(qGetSchoolDates.endDate)>#qGetSchoolDates.endDate# <cfelse> n/a </cfif>
                        <cfelse>
	                        School Start Date: <cfif LEN(qGetSchoolDates.startDate)>#qGetSchoolDates.startDate# <cfelse> n/a </cfif>
                        </cfif>
                    </td>               
                </tr>
            </table>
        
            <table width="98%" align="center" cellpadding="3" cellspacing="1" style="border:1px solid ##021157">
                <tr bgcolor="###vColorTitle#">
                   <th width="8%">Date</th>
                   <th width="16%">Departure City</th>
                   <th width="10%">Airport Code</th>
                   <th width="16%">Arrival City</th>
                   <th width="10%">Airport Code</th>
                   <th width="10%">Flight Number</th>
                   <th width="10%">Departure Time</th>
                   <th width="10%">Arrival Time</th>
                   <th width="10%">Overnight Flight</th>
                </tr>
                <cfloop query="qGetFlightInfo">
                    <tr bgcolor="###vColorRow#">
                        <td align="center">#DateFormat(qGetFlightInfo.dep_date , 'mm/dd/yyyy')#&nbsp;</td>
                        <td align="center">#qGetFlightInfo.dep_city#&nbsp;</td>
                        <td align="center">#qGetFlightInfo.dep_aircode#&nbsp;</td>
                        <td align="center">#qGetFlightInfo.arrival_city#&nbsp;</td>
                        <td align="center">#qGetFlightInfo.arrival_aircode#&nbsp;</td>
                        <td align="center">#qGetFlightInfo.flight_number#&nbsp;</td>
                        <td align="center">#TimeFormat(qGetFlightInfo.dep_time, 'hh:mm tt')#&nbsp;</td>
                        <td align="center">#TimeFormat(qGetFlightInfo.arrival_time, 'hh:mm tt')#&nbsp;</td>
                        <td align="center">#YesNoFormat(VAL(qGetFlightInfo.overnight))#</td>
                    </tr>
                </cfloop>
            </table>
    
            <br />
                    
        </cfloop>

	</cfoutput>

</cfif>