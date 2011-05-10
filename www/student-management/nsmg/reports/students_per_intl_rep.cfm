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
            orientation.name as orientationcamp,
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
            smg_aypcamps orientation ON s.ayporientation = orientation.campid
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
            
			<cfif FORM.preayp EQ 'all'>
                AND 
                    (
                        s.aypenglish = english.campid 
                    OR 
                        s.ayporientation = orientation.campid
                    )
            <cfelseif FORM.preayp EQ 'english'>
                AND 
                    s.aypenglish = english.campid
            <cfelseif FORM.preayp EQ 'orientation'>
                AND 
                    s.ayporientation = orientation.campid
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
            
			<cfif FORM.preayp NEQ 'none'>Pre-AYP #FORM.preayp# camp students</cfif>
    	</td>
	</tr>
</table><br />

<table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">
    <tr>
    	<th width="75%">International Representative</th>
        <th width="25%">Total</th>
	</tr>
</table><br />

</cfoutput>

<cfif FORM.preayp EQ 'none'>	
	
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
                <tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
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

	<cfoutput query="qGetStudentList" group="intrep">
        
        <cfquery name="qGetTotal" dbtype="query">
	        SELECT 
            	studentid
            FROM 
                qGetStudentList
            WHERE 
                intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#intrep#">
        </cfquery>					
		
		<cfscript>
			// Get Pre-AYP Arrival Flight Information
			qGetPreAypArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="preAYPArrival");

			// Get Arrival to Host Flight Information
			qGetArrival = APPLICATION.CFC.STUDENT.getFlightInformation(studentID=qGetStudentList.studentID,flightType="arrival");
		</cfscript>
        
        <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;">	
        	<tr>
            	<th width="75%"><a href="mailto:#email#">#businessname#</a></th>
        		<td width="25%" align="center">#qGetTotal.recordcount#</td>
			</tr>
        </table>
        
        <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999;"> 
            <tr>
            	<td width="4%" style="border-bottom:1px solid ##999; font-weight:bold;">ID</th>
	            <td width="12%" style="border-bottom:1px solid ##999; font-weight:bold;">Student</td>
	            <td width="6%" style="border-bottom:1px solid ##999; font-weight:bold;">Sex</td>
	            <td width="4%" style="border-bottom:1px solid ##999; font-weight:bold;">DOB</td>
	            <td width="6%" style="border-bottom:1px solid ##999; font-weight:bold;">Country</td>
	            <cfif FORM.status EQ 1>
		            <td width="8%" style="border-bottom:1px solid ##999; font-weight:bold;">Family</td>
	            <cfelse>
		            <td width="8%" style="border-bottom:1px solid ##999; font-weight:bold;">Region</td>
	            </cfif>			
	            <td width="8%" style="border-bottom:1px solid ##999; font-weight:bold;">Facilitator</td>
                <td width="12%" style="border-bottom:1px solid ##999; font-weight:bold;">Flight Info</td>
                <td width="10%" style="border-bottom:1px solid ##999; font-weight:bold;">Arrival</td>
                <td width="12%" style="border-bottom:1px solid ##999; font-weight:bold;">Flight Info</td>
                <td width="10%" style="border-bottom:1px solid ##999; font-weight:bold;">Departure</td>
                <td width="8%" style="border-bottom:1px solid ##999; font-weight:bold;">Pre-AYP Camp</td>
            </tr>
        
			<cfoutput>					
                <tr bgcolor="###iif(qGetStudentList.currentrow MOD 2 ,DE("FFFFFF") ,DE("EDEDED") )#">
                    <td>#qGetStudentList.studentid#</td>
                    <td>#qGetStudentList.firstname# #qGetStudentList.familylastname#</td>
                    <td>#qGetStudentList.sex#</td>
                    <td>#DateFormat(qGetStudentList.DOB, 'mm/dd/yy')#</td>
                    <td>#qGetStudentList.countryname#</td>
                    <cfif FORM.status EQ 1>
                        <td>#qGetStudentList.hostfamily#</td>	
                    <cfelse>
                        <td>#qGetStudentList.regionname#</td>	
                    </cfif>	
                    <td>#qGetStudentList.facFirstName# #qGetStudentList.facLastName#</td>					
                    <!--- Arrival to Pre-AYP --->
                    <td>
                    	<cfloop query="qGetPreAypArrival">
                        	#qGetPreAypArrival.dep_city# to #qGetPreAypArrival.arrival_city# 
                            <cfif LEN(qGetPreAypArrival.flight_number)>
	                            - #qGetPreAypArrival.flight_number#
                            </cfif> <br />
                        </cfloop>
                    </td>
                    <td>
                    	<cfloop query="qGetPreAypArrival">
                        	#DateFormat(qGetPreAypArrival.dep_date, 'mm/dd/yy')# at #TimeFormat(qGetPreAypArrival.arrival_time, 'hh:mm tt')#<br />
                        </cfloop>
                    </td>
                    <!--- Arrival to HF --->
                    <td>
                    	<cfloop query="qGetArrival">
                        	#qGetArrival.dep_city# to #qGetArrival.arrival_city# 
                            <cfif LEN(qGetArrival.flight_number)>
	                            - #qGetArrival.flight_number#
                            </cfif> <br />
                        </cfloop>
                    </td>
                    <td>
                    	<cfloop query="qGetArrival">
                        	#DateFormat(qGetArrival.dep_date, 'mm/dd/yy')# at #TimeFormat(qGetArrival.arrival_time, 'hh:mm tt')#<br />
                        </cfloop>
                    </td>
                    <td>#qGetStudentList.englishcamp# #qGetStudentList.orientationcamp#</td>
                </tr>							
        	</cfoutput>	
        
        </table><br />

	</cfoutput>	
    	
</cfif> <!--- pre ayp cfif --->
			

