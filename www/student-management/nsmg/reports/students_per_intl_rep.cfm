<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut="9999">

    <!--- Get Program --->
    <cfquery name="qGetProgram" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT 
            p.programid, 
            p.programname, 
            c.companyshort
        FROM smg_programs p
        INNER JOIN smg_companies c ON c.companyid = p.companyid
        WHERE programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    </cfquery>
    
    <!--- get Students  --->
    <Cfquery name="qGetStudentList" datasource="#APPLICATION.DSN#">
        SELECT 
            s.studentid, 
            s.flsID,
            s.countryresident, 
            s.firstname, 
            s.familylastname, 
            s.intrep, 
            s.programid, 
            s.sex, 
            s.dateapplication, 
            s.dob,
            s.schoolID,
            u.userid, 
            u.businessname, 
            u.email, 
            p.programid, 
            p.programname,
            r.regionname, 
            r.regionid,
            comp.projectManagerName,
            countryname,
            h.familylastname as hostfamily,
            english.name as englishcamp, 
            fac.firstName as facFirstName,
            fac.lastName as facLastName,
            (
                CASE 
                	<!--- August Programs --->
                    WHEN 
                        p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,3,5,25" list="yes"> )
                    THEN 
                        ssd.year_begins
                    <!--- January Programs --->
                    WHEN 	
                        p.type IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="2,4,24,26" list="yes"> )
                    THEN 
                        ssd.semester_begins
                END
            ) AS schoolStartDate
        FROM smg_students s
        INNER JOIN smg_users u ON s.intrep = u.userid
        INNER JOIN smg_programs p	ON s.programid = p.programid
        LEFT OUTER JOIN smg_countrylist c ON s.countryresident = c.countryid
        LEFT OUTER JOIN smg_regions r ON s.regionassigned = r.regionid 
        LEFT OUTER JOIN smg_hosts h ON s.hostid = h.hostid		
        LEFT OUTER JOIN smg_aypcamps english ON s.aypenglish = english.campid
        LEFT OUTER JOIN smg_users fac ON fac.userID = r.regionFacilitator
        LEFT OUTER JOIN smg_companies comp on comp.companyid = s.companyid
        LEFT OUTER JOIN smg_school_dates ssd ON ssd.schoolID = s.schoolID
      		AND ssd.seasonID = p.seasonID
        WHERE s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
      	AND s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        
		<cfif CLIENT.companyID EQ 5>
            AND s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
        <cfelse>
            AND s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
        </cfif>        
            
		<!--- active --->
        <cfif FORM.active EQ 1> 
            AND s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.active#">
        <!--- inactive --->
        <cfelseif FORM.active EQ 0> 
            AND canceldate IS NULL
        <!--- canceled --->                    
        <cfelseif FORM.active EQ 2> 
            AND canceldate IS NOT NULL
        </cfif>  
            
		<cfif VAL(FORM.intrep)>
            AND s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
        </cfif>
        
        <cfif FORM.status is 1>
            AND s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            AND s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
        <cfelseif FORM.status EQ 2>
            AND s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
        </cfif>
            
		<cfif FORM.preayp EQ 'All'>
            AND s.aypenglish = english.campid 
        <cfelseif VAL(FORM.preayp)>
            AND s.aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.preayp#">
        </cfif>
            
        ORDER BY 
            u.businessname, 
            s.firstname, 
            s.familylastname
    </cfquery>  

</cfsilent>

<link rel="stylesheet" href="reports.css" type="text/css">

<cfoutput>

	<table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
    	<tr>
            <td align="center">
                <p style="font-weight:bold;">#CLIENT.companyshort# -  Students per International Rep.</p>
                
                Program(s) Included in this Report:
                <br />
                <cfloop query="qGetProgram">
                    <strong>#qGetProgram.programname# &nbsp; (#qGetProgram.ProgramID#)</strong><br />
                </cfloop>
                <p>
                    Total of #qGetStudentList.recordcount# 
                    <cfif FORM.active EQ 1>
                        active
                    <cfelseif FORM.active EQ 0>
                        inactive
                    <cfelseif FORM.active EQ 2>
                        canceled
                    </cfif> students
                    
                    <cfif FORM.status is 1>
                        <strong>placed</strong>
                    <cfelseif FORM.status is 2>
                        <strong>unplaced</strong>
                    </cfif> in report: &nbsp; 
                </p> 
            </td>
        </tr>
    </table>
    <br />
    
</cfoutput>

<cfsavecontent variable="reportContent">

    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid #999;"> 
        <tr>
            <td style="border-bottom:1px solid #999; font-weight:bold;">&nbsp;</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">ID</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">FLS ID</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Student</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Sex</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">DOB</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Country</td>
            <cfif FORM.status EQ 1>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Family</td>
            <cfelse>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Region</td>
            </cfif>	
            <td style="border-bottom:1px solid #999; font-weight:bold;">Intl. Rep.</td>		
            <td style="border-bottom:1px solid #999; font-weight:bold;">Facilitator</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Project Manager</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Arrival to Camp</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Time</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Flight Info</td>    
            <td style="border-bottom:1px solid #999; font-weight:bold;">Departure to Host</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Time</td>
            <td style="border-bottom:1px solid #999; font-weight:bold;">Flight Info</td> 
            <td style="border-bottom:1px solid #999; font-weight:bold;">School Start Date</td>                  
            <td style="border-bottom:1px solid #999; font-weight:bold;">Pre-AYP Camp</td>
        </tr>

        <cfoutput query="qGetStudentList" group="intrep">	
            
            <cfscript>
                // Get Pre-AYP Arrival Flight Information
                qGetPreAypArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="preAYPArrival", programID=qGetStudentList.programID, flightLegOption="lastLeg");
                // Get Departure from Camp - Arrival to Host Family Flight Information
                qGetDepartureFromCamp = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="arrival", programID=qGetStudentList.programID, flightLegOption="firstLeg");
            </cfscript>
            
            <tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("FFFFFF") ,DE("EDEDED") )#">
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.currentRow#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.studentID#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.flsID#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.firstname# #qGetStudentList.familylastname#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.sex#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#DateFormat(qGetStudentList.DOB, 'mm/dd/yy')#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.countryname#</td>
                <cfif FORM.status EQ 1>
                    <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.hostfamily#</td>	
                <cfelse>
                    <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.regionname#</td>	
                </cfif>	
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.businessname#</td>	
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.facFirstName# #qGetStudentList.facLastName#</td>		
                 <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.projectManagerName#</td>			
                <!--- Arrival to Pre-AYP --->
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    <cfif qGetPreAypArrival.overnight EQ 1>
                        #DateFormat(DateAdd("d", 1, qGetPreAypArrival.dep_date), 'mm/dd/yyyy')#
                    <cfelse>
                        #DateFormat(qGetPreAypArrival.dep_date, 'mm/dd/yy')#
                    </cfif>
                </td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    #TimeFormat(qGetPreAypArrival.arrival_time, 'hh:mm tt')#
                </td>                    
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    <cfif LEN(qGetPreAypArrival.dep_city)>
                        From #qGetPreAypArrival.dep_city# #qGetPreAypArrival.dep_aircode#
                    </cfif>
                    
                    <cfif LEN(qGetPreAypArrival.arrival_city)>
                        to #qGetPreAypArrival.arrival_city# #qGetPreAypArrival.arrival_aircode#
                    </cfif>
                    
                    <cfif LEN(qGetPreAypArrival.flight_number)>
                       Flight #qGetPreAypArrival.flight_number#
                    </cfif>
                </td>
                <!--- Departure from Camp / Arrival to HF --->
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    <cfif qGetDepartureFromCamp.overnight EQ 1>
                        #DateFormat(DateAdd("d", 1, qGetDepartureFromCamp.dep_date), 'mm/dd/yyyy')#
                    <cfelse>
                        #DateFormat(qGetDepartureFromCamp.dep_date, 'mm/dd/yy')#
                    </cfif>
                </td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    #TimeFormat(qGetDepartureFromCamp.dep_time, 'hh:mm tt')#
                </td>                                            
                <td style="border-bottom:1px solid ##999; vertical-align:top;">
                    <cfif LEN(qGetDepartureFromCamp.dep_city)>
                        From #qGetDepartureFromCamp.dep_city# #qGetDepartureFromCamp.dep_aircode#
                    </cfif>
                    
                    <cfif LEN(qGetDepartureFromCamp.arrival_city)>
                        to #qGetDepartureFromCamp.arrival_city# #qGetDepartureFromCamp.arrival_aircode#
                    </cfif>
                    
                    <cfif LEN(qGetDepartureFromCamp.flight_number)>
                       Flight #qGetDepartureFromCamp.flight_number#
                    </cfif>
                </td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#DateFormat(qGetStudentList.schoolStartDate, 'mm/dd/yy')#</td>
                <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.englishcamp#</td>
            </tr>
    
        </cfoutput>	

    </table>
    <br />

</cfsavecontent>

<cfoutput>
	
	<!-----Display Reports---->
    <cfswitch expression="#FORM.reportFormat#">
    
        <!--- Screen --->
        <cfcase value="screen">
            <!--- Include Report --->
            #reportContent#
        </cfcase>
   
        <!--- Excel --->
        <cfcase value="excel">
    
            <!--- set content type --->
            <cfcontent type="application/msexcel">
            
            <!--- suggest default name for XLS file --->
            <cfheader name="Content-Disposition" value="attachment; filename=preAypStudents.xls"> 
    
            <!--- Include Report --->
            #reportContent#
            
            <cfabort>
    
        </cfcase>
        
    </cfswitch>

</cfoutput>        
        

			

