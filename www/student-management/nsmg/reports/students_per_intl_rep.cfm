<!--- Kill Extra Output --->
<cfsilent>

	<cfsetting requestTimeOut="9999">

    <!--- Get Program --->
    <cfquery name="qGetProgram" datasource="MYSQL">
        SELECT DISTINCT 
            p.programid, 
            p.programname, 
            c.companyshort
        FROM 	
        	smg_programs p
        INNER JOIN 
        	smg_companies c ON c.companyid = p.companyid
        WHERE 		
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
    </cfquery>
    
    <!--- get Students  --->
    <Cfquery name="qGetStudentList" datasource="MySQL">
        SELECT 
            s.studentid, 
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
            countryname,
            h.familylastname as hostfamily,
            english.name as englishcamp, 
            fac.firstName as facFirstName,
            fac.lastName as facLastName
        FROM 
            smg_students s
        INNER JOIN 
            smg_users u ON s.intrep = u.userid
        INNER JOIN 
            smg_programs p	ON s.programid = p.programid
        LEFT OUTER JOIN 
            smg_countrylist c ON s.countryresident = c.countryid
        LEFT OUTER JOIN 
            smg_regions r ON s.regionassigned = r.regionid 
        LEFT OUTER JOIN 
            smg_hosts h ON s.hostid = h.hostid		
        LEFT OUTER JOIN 
            smg_aypcamps english ON s.aypenglish = english.campid
        LEFT OUTER JOIN
            smg_users fac ON fac.userID = r.regionFacilitator
        WHERE
            s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
        
            <cfif CLIENT.companyID EQ 5>
                AND
                    s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
            <cfelse>
                AND
                    s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
            </cfif>        
            
            <!--- active --->
            <cfif FORM.active EQ 1> 
                AND 
                    s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.active#">
            <!--- inactive --->
			<cfelseif FORM.active EQ 0> 
                AND 
                    canceldate IS NULL
			<!--- canceled --->                    
            <cfelseif FORM.active EQ 2> 
                AND canceldate IS NOT NULL
            </cfif>  
            
			<cfif VAL(FORM.intrep)>
                AND
                    s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.intrep#">
            </cfif>
            
			<cfif FORM.status is 1>
                AND 
                    s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                AND 
                    s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4"> <!--- placed --->
            <cfelseif FORM.status EQ 2>
                AND 
                    s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> <!--- unplaced --->
            </cfif>
            
			<cfif FORM.preayp EQ 'All'>
                AND 
                    s.aypenglish = english.campid 
            <cfelseif VAL(FORM.preayp)>
                AND 
                    s.aypenglish = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.preayp#">
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
            
            Program(s) Included in this Report: <br />
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
</table><br />

</cfoutput>

<cfif FORM.preayp EQ 'none'>	

    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
        <tr>
            <th width="75%">International Representative</th>
            <th width="25%">Total</th>
        </tr>
    </table><br />
	
	<cfoutput query="qGetStudentList" group="intrep">
    
        <cfquery name="qGetTotal" dbtype="query">
            SELECT 
                studentid
            FROM 
                qGetStudentList
            WHERE 	
                intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentList.intrep#">
         </cfquery>
         
        <cfquery name="qSchoolDates" datasource="MySQL">
            SELECT 
                year_begins
            FROM 
                smg_school_dates
            INNER JOIN 
                smg_programs p ON p.seasonid = smg_school_dates.seasonid
            WHERE 
                schoolid = <cfqueryparam value="#qGetStudentList.schoolid#" cfsqltype="cf_sql_integer">
            AND 
                p.programid = <cfqueryparam value="#qGetStudentList.programid#" cfsqltype="cf_sql_integer">
         </cfquery>
    
		<table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">	
			<tr>
            	<th width="75%"><a href="mailto:#qGetStudentList.email#">#qGetStudentList.businessname#</a></th>
				<td width="25%" align="center">#qGetTotal.recordcount#</td>
            </tr>
		</table>
            
		<table width="98%" frame="below" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
            <tr>
                <td width="6%" align="center"><strong>ID</strong></th>
                <td width="18%"><strong>Student</strong></td>
                <td width="8%" align="center"><strong>Sex</strong></td>
                <td width="8%" align="center"><strong>DOB</strong></td>
                <td width="12%"><strong>Country</strong></td>
                <cfif FORM.status EQ 1>
	                <td width="12%"><strong>Family</strong></td>
                <cfelse>
	                <td width="12%"><strong>Region</strong></td>
                </cfif>			
                <td width="16%"><strong>Facilitator</strong></td>
                <td width="12%"><strong>School Start Date</strong></td>
                <td width="8%"><strong>Entry Date</strong></td>
            </tr>
            
			<cfoutput>					
                <tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("EDEDED") ,DE("FFFFFF") )#">
                    <td align="center">#studentid#</td>
                    <td>#firstname# #familylastname#</td>
                    <td align="center">#sex#</td>
                    <td align="center">#DateFormat(DOB, 'mm/dd/yy')#</td>
                    <td>#countryname#</td>
                    <cfif FORM.status is 1>
                    <td>#hostfamily#</td>	
                    <cfelse>
                    <td>#regionname#</td>	
                    </cfif>		
                    <td>#facFirstName# #facLastName#</td>			
                    <td>#DateFormat(qSchoolDates.year_begins, 'mm/dd/yy')#</td>
                    <td>#DateFormat(dateapplication, 'mm/dd/yy')#</td>
				</tr>							
			</cfoutput>	
		
        </table><br />
            
	</cfoutput><br />
    
<!--- pre ayp cfif --->
<cfelse>

	<cfsavecontent variable="reportContent">

		<table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid #999;"> 
            <tr>
                <td style="border-bottom:1px solid #999; font-weight:bold;">&nbsp;</td>
                <td style="border-bottom:1px solid #999; font-weight:bold;">ID</td>
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
                <td style="border-bottom:1px solid #999; font-weight:bold;">Arrival to Camp</td>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Flight Info</td>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Departure to Host</td>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Flight Info</td>
                <td style="border-bottom:1px solid #999; font-weight:bold;">Pre-AYP Camp</td>
            </tr>
    
            <cfoutput query="qGetStudentList" group="intrep">
                
                <cfoutput>		
                
                    <cfscript>
                        // Get Pre-AYP Arrival Flight Information
                        qGetPreAypArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="preAYPArrival",flightLegOption="lastLeg");
                
                        // Get Arrival to Host Flight Information
                        qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="arrival",flightLegOption="firstLeg");
                    </cfscript>
                
                    <tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("FFFFFF") ,DE("EDEDED") )#">
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.currentRow#</td>
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.studentid#</td>
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
                        <!--- Arrival to Pre-AYP --->
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">
                            <cfif qGetPreAypArrival.overnight EQ 1>
                                #DateFormat(DateAdd("d", 1, qGetPreAypArrival.dep_date), 'mm/dd/yyyy')#
                            <cfelse>
                                #DateFormat(qGetPreAypArrival.dep_date, 'mm/dd/yy')#
                            </cfif>
                            
                            <cfif LEN(qGetPreAypArrival.arrival_time)>
                                 at #TimeFormat(qGetPreAypArrival.arrival_time, 'hh:mm tt')#
                            </cfif>
                        </td>                    
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">
                            <cfif LEN(qGetPreAypArrival.dep_city)>
                                From #qGetPreAypArrival.dep_city# #qGetPreAypArrival.dep_aircode# <br />
                            </cfif>
                            
                            <cfif LEN(qGetPreAypArrival.arrival_city)>
                                to #qGetPreAypArrival.arrival_city# #qGetPreAypArrival.arrival_aircode# <br />
                            </cfif>
                            
                            <cfif LEN(qGetPreAypArrival.flight_number)>
                               Flight #qGetPreAypArrival.flight_number#
                            </cfif> <br />
                        </td>
                        <!--- Arrival to HF --->
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">
                            <cfif qGetArrival.overnight EQ 1>
                                #DateFormat(DateAdd("d", 1, qGetArrival.dep_date), 'mm/dd/yyyy')#
                            <cfelse>
                                #DateFormat(qGetArrival.dep_date, 'mm/dd/yy')#
                            </cfif>
                            
                            <cfif LEN(qGetArrival.arrival_time)>
                                 at #TimeFormat(qGetArrival.arrival_time, 'hh:mm tt')#
                            </cfif>
                        </td>
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">
                            <cfif LEN(qGetArrival.dep_city)>
                                From #qGetArrival.dep_city# #qGetArrival.dep_aircode# <br />
                            </cfif>
                            
                            <cfif LEN(qGetArrival.arrival_city)>
                                to #qGetArrival.arrival_city# #qGetArrival.arrival_aircode# <br />
                            </cfif>
                            
                            <cfif LEN(qGetArrival.flight_number)>
                               Flight #qGetArrival.flight_number#
                            </cfif> <br />
                        </td>
                        <td style="border-bottom:1px solid ##999; vertical-align:top;">#qGetStudentList.englishcamp#</td>
                    </tr>							
                </cfoutput>	
        
            </cfoutput>	

        </table><br />
	
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
        
</cfif> <!--- pre ayp cfif --->
			

