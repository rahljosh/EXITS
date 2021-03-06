<!--- ------------------------------------------------------------------------- ----
	
	File:		officeProgramStatistics.cfm
	Author:		Marcus Melo
	Date:		July 3, 2012
	Desc:		Program Statistics
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=officeProgramStatistics
				
	Updated: 			
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="FORM.programid" default="0">
    <cfparam name="FORM.continent" default="0">
    <cfparam name="FORM.inactive" default="0">
	
    <cfscript>
		vTotal = 0;
		vTotalMale = 0;
		vTotalFemale = 0;
		
		vTotalPlaced = 0;
		vTotalPlacedFemale = 0;
		vTotalPlacedMale = 0;
	</cfscript>
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">

	<!--- get company region --->
    <cfquery name="qGetRegion" datasource="MySQL">
        SELECT	
        	r.regionid,
            r.regionname, 
            r.company, 
            c.companyShort
        FROM 
        	smg_regions r
		LEFT OUTER JOIN
        	smg_companies c ON c.companyID = r.company          
        WHERE 
		<cfif CLIENT.companyID EQ 5>
            r.company IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        <cfelse>
            r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        <cfif VAL(FORM.inactive)>
            AND 
                r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
         <cfelse>
             AND 
                r.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">        
        </cfif>
        ORDER BY 
        	c.companyShort,
            r.regionname
    </cfquery>
    
    <cfquery name="qGetProgram" datasource="MYSQL">
        SELECT	
        	ProgramID, 
            programname, 
            startdate, 
            enddate, 
            companyid, 
            type,
            programtype
        FROM 	
        	smg_programs 
        LEFT JOIN 
        	smg_program_type ON type = programtypeid
        WHERE 
            programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
    </cfquery>
    
    <cfquery name="qGetStudentsInProgram" datasource="MySQL">
        SELECT	 
        	s.studentID,
            s.sex,
            s.hostID,
            s.host_fam_approved
        FROM 	
        	smg_students s
        <cfif FORM.continent NEQ 0>
        	INNER JOIN 
            	smg_countrylist c ON s.countryresident = c.countryid 
                AND 
                    c.continent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.continent#">
		</cfif>
        INNER JOIN 
        	smg_regions r ON r.regionID = s.regionAssigned
        WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
          	s.programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
		<cfif CLIENT.companyID EQ 5>
            AND	
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
        <cfelse>
	        AND	
    	        s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
    </cfquery>
    
    <cfquery name="qGetPlacedStudents" dbtype="query">
        SELECT	 
        	studentID
        FROM 	
        	qGetStudentsInProgram
        WHERE 
        	hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">
    </cfquery>

</cfsilent>

<cfif FORM.programid EQ 0>
	<table align="center" width="90%" cellpadding=6 cellspacing="0">
        <tr><td>Please select at least one program.</td></tr>
        <tr><td align="center"><input type="image" value="close window" src="pics/back.gif" onClick="javascript:history.back()"></td></tr>
	</table><br />
	<cfabort>
</cfif>

<cfoutput>
<span class="application_section_header">#companyshort.companyshort# Program Statistics</span><br />

<table align="center" width="90%" cellpadding=6 cellspacing="0" frame="box">
    <tr>
    	<td align="left">
            &nbsp &nbsp Program(s) : &nbsp <br />
            <cfloop query="qGetProgram">
            	&nbsp &nbsp <b>(#ProgramID#) &nbsp #programname# &nbsp (#programtype#)</b><br />
            </cfloop>
            
            <cfif FORM.continent NEQ 0>
            	&nbsp &nbsp 
                Continent: &nbsp; <b>#FORM.continent#</b><br />
			</cfif>
            
            <cfif isDate(FORM.date_host_fam_approved)>
            	&nbsp &nbsp 
                Students placed by <b>#DateFormat(FORM.date_host_fam_approved, 'mm/dd/yyyy')#</b><br />
			</cfif>
            
            <cfif VAL(qGetStudentsInProgram.recordCount)>
                &nbsp &nbsp 
                
                Active Students in Program(s) : &nbsp #qGetStudentsInProgram.recordCount#<br />
                &nbsp &nbsp 
                
                Placed : &nbsp #qGetPlacedStudents.recordCount# (#numberformat((qGetPlacedStudents.recordCount/qGetStudentsInProgram.recordCount)*100,"___.__")#%) &nbsp;  <font size="-2" color="FF6633"> ( Approved Placements Only )</font><br />
                &nbsp &nbsp 
                
                Unplaced : &nbsp #qGetStudentsInProgram.recordCount - qGetPlacedStudents.recordCount# (#numberformat(((qGetStudentsInProgram.recordCount - qGetPlacedStudents.recordCount)/qGetStudentsInProgram.recordCount)*100,"___.__")#%)<br />
			</cfif>
    	</td>
	</tr>
</table>

<br />

<table align="center" width="90%" cellpadding=2 cellspacing="0" border="1">
    <tr>
        <Th width="26%">Region</th>
        <Th colspan="3">Assigned</th>
        <td></td>
        <Th colspan="3">Placed</th>
        <td></td>
        <Th colspan="3">Ratio</th>
    </tr>
    <tr>
        <td>&nbsp;</td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td  width="8%" align="center">Male</td>
        <td width="1%"></td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td width="8%" align="center">Male</td>
        <td width="1%"></td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td width="8%" align="center">Male</td>
    </tr>
    
    <cfloop query="qGetRegion">
    
        <cfquery name="qGetStudentAssignedRegion" datasource="MYSQL">
            SELECT	
                SUM(if(not isnull(StudentID), 1, 0) ) AS assigned_students,
                SUM(IF(SEX = 'FEMALE', 1, 0)) AS assigned_female,
                SUM(IF(SEX = 'MALE', 1, 0)) AS assigned_male
            FROM 	
                smg_students
            <cfif FORM.continent NEQ 0>
                INNER JOIN 
                	smg_countrylist c ON countryresident = c.countryid
                    AND 
                        c.continent = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.continent#">
            </cfif>
            WHERE 
                regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegion.regionid#">
            AND  
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
        </cfquery>
        
        <cfquery name="qGetPlacedStudentsRegion" datasource="MYSQL">
            SELECT	
                SUM(if(not isnull(StudentID), 1, 0) ) as placed_student,
                SUM(if(Sex = 'Female', 1, 0)) as placed_female,
                SUM(if(Sex = 'Male', 1, 0)) as placed_male
            FROM 	
                smg_students
            <cfif FORM.continent NEQ 0>
                INNER JOIN 
                    smg_countrylist c ON countryresident = c.countryid
                    AND 
                        c.continent = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.continent#">
            </cfif>
            WHERE 
                regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegion.regionid#"> 
            AND 
                host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">	
            AND 
                Hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            AND 
                active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
              programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
            <cfif isDate(FORM.date_host_fam_approved)>
                AND 
                    date_host_fam_approved <= #CreateODBCDate(FORM.date_host_fam_approved)#
            </cfif>
        </cfquery>
        
		<cfscript>
            vTotal = vTotal + VAL(qGetStudentAssignedRegion.assigned_students);
            vTotalFemale = vTotalFemale + VAL(qGetStudentAssignedRegion.assigned_female);
			vTotalMale = vTotalMale + VAL(qGetStudentAssignedRegion.assigned_male);            
            
            vTotalPlaced = vTotalPlaced + VAL(qGetPlacedStudentsRegion.placed_student);
            vTotalPlacedFemale = vTotalPlacedFemale + VAL(qGetPlacedStudentsRegion.placed_female);
			vTotalPlacedMale = vTotalPlacedMale + VAL(qGetPlacedStudentsRegion.placed_male);
		</cfscript>

        <tr bgcolor="#iif(qGetRegion.currentrow MOD 2 ,DE("ededed") ,DE("white") )#">
            <td align="left">            	
                <cfif CLIENT.companyID EQ 5>
                	#qGetRegion.companyShort# - 
                </cfif>
                #qGetRegion.regionname#
            </td> 
            <td align="right">#numberformat(qGetStudentAssignedRegion.assigned_students)#</td>
            <td align="right">#numberformat(qGetStudentAssignedRegion.assigned_female)#</td>
            <td align="right">#numberformat(qGetStudentAssignedRegion.assigned_male)#</td>
            <td></td>
            <td align="right">#numberformat(qGetPlacedStudentsRegion.placed_student)#</td>
            <td align="right">#numberformat(qGetPlacedStudentsRegion.placed_female)#</td>
            <td align="right">#numberformat(qGetPlacedStudentsRegion.placed_male)#</td>
            <td></td>
            <td align="right">
				<cfif numberformat(qGetStudentAssignedRegion.assigned_students) EQ 0>
                    N/A
                <cfelse>
                    <cfif numberformat(qGetPlacedStudentsRegion.placed_student) EQ 0>
                        0%
                    <cfelse>
                        #numberformat(evaluate((qGetPlacedStudentsRegion.placed_student/qGetStudentAssignedRegion.assigned_students)*100),"___.__")#
                    </cfif>
                </cfif>
            </td>
            <td align="right">
				<cfif numberformat(qGetStudentAssignedRegion.assigned_female) EQ 0>
                    N/A
                <cfelse>
                    <cfif numberformat(qGetPlacedStudentsRegion.placed_female) EQ 0>
                            0%
                    <cfelse>
                        #numberformat(evaluate((qGetPlacedStudentsRegion.placed_female/qGetStudentAssignedRegion.assigned_female)*100),"___.__")#
                    </cfif>
                </cfif>
            </td>
            <td align="right">
				<cfif numberformat(qGetStudentAssignedRegion.assigned_male) EQ 0>
                    N/A
                <cfelse>
                    <cfif numberformat(qGetPlacedStudentsRegion.placed_male) EQ 0>
                        0%
                    <cfelse>
                        #numberformat(evaluate((qGetPlacedStudentsRegion.placed_male/qGetStudentAssignedRegion.assigned_male)*100),"___.__")#
                    </cfif>
                </cfif>
            </td>
        </tr>

	</cfloop>
        
    <cfquery name="qGetStudentsUnassigned" datasource="MYSQL">
        SELECT	
            SUM(if(not isnull(StudentID), 1, 0) ) AS assigned_students,
            SUM(IF(SEX = 'FEMALE', 1, 0)) AS assigned_female,
            SUM(IF(SEX = 'MALE', 1, 0)) AS assigned_male,
            studentid
        FROM 	
            smg_students
        <cfif FORM.continent NEQ 0>
            INNER JOIN 
                smg_countrylist c ON countryresident = c.countryid 
                AND 
                    c.continent = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.continent#">
        </cfif>
        WHERE 
            regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND	
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND
        	app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        AND 
            canceldate IS NULL
        AND 
            programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
        <cfif isDate(FORM.date_host_fam_approved)>
            AND 
                date_host_fam_approved <= #CreateODBCDate(FORM.date_host_fam_approved)#
        </cfif>
        group by 
        	studentid
    </cfquery>
    
    <cfquery name="qGetStudentsUnassignedPlaced" datasource="MYSQL">
        SELECT	
            SUM(if(not isnull(StudentID), 1, 0) ) as placed_student,
            SUM(if(Sex = 'Female', 1, 0)) as placed_female,
            SUM(if(Sex = 'Male', 1, 0)) as placed_male
        FROM 	
            smg_students
        <cfif FORM.continent NEQ 0>
            INNER JOIN 
            	smg_countrylist c ON countryresident = c.countryid
                AND 
                    c.continent = '#FORM.continent#'
        </cfif>
        WHERE 
            regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND	
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        AND 
            host_fam_approved < <cfqueryparam cfsqltype="cf_sql_integer" value="5">	
        AND 
            hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
        AND
        	app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
        AND 
            canceldate IS NULL
        AND 
            programid IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes">)
        <cfif isDate(FORM.date_host_fam_approved)>
            AND 
                date_host_fam_approved <= #CreateODBCDate(FORM.date_host_fam_approved)#
        </cfif>
    </cfquery>
        
    <tr bgcolor="ededed">
        <td align="left">-- Unassigned -- </td> 
        <td align="right">#numberformat(qGetStudentsUnassigned.assigned_students)#</td>
        <td align="right">#numberformat(qGetStudentsUnassigned.assigned_female)#</td>
        <td align="right">#numberformat(qGetStudentsUnassigned.assigned_male)#</td>
        <td></td>
        <td align="right">#numberformat(qGetStudentsUnassignedPlaced.placed_student)#</td>
        <td align="right">#numberformat(qGetStudentsUnassignedPlaced.placed_female)#</td>
        <td align="right">#numberformat(qGetStudentsUnassignedPlaced.placed_male)#</td>
        <td></td>
        <td align="right">
			<cfif VAL(qGetStudentsUnassigned.assigned_students) AND VAL(qGetStudentsUnassignedPlaced.placed_student)>
                #numberformat((qGetStudentsUnassignedPlaced.placed_student/qGetStudentsUnassigned.assigned_students)*100,"___.__")#
            <cfelseif qGetStudentsUnassignedPlaced.placed_student EQ 0>
                0%
            <cfelse>
                N/A
            </cfif>
        </td>
        <td align="right">
			<cfif VAL(qGetStudentsUnassigned.assigned_female) AND VAL(qGetStudentsUnassignedPlaced.placed_female)>
                #numberformat((qGetStudentsUnassignedPlaced.placed_female/qGetStudentsUnassigned.assigned_female)*100,"___.__")#
            <cfelseif qGetStudentsUnassignedPlaced.placed_female EQ 0>
                0%
            <cfelse>
                N/A
            </cfif>
        </td>
        <td align="right">
			<cfif VAL(qGetStudentsUnassigned.assigned_male) AND VAL(qGetStudentsUnassignedPlaced.placed_male)>
                #numberformat((qGetStudentsUnassignedPlaced.placed_male/qGetStudentsUnassigned.assigned_male)*100,"___.__")#
            <cfelseif qGetStudentsUnassignedPlaced.placed_male EQ 0>
                0%
            <cfelse>
                N/A
            </cfif>
        </td>
    </tr>
</table>
    
<br />

<table align="center" width="90%" cellpadding=2 cellspacing="0" border="1">
    <tr>
        <td>Summary</td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td width="8%" align="center">Male</td>
        <td width="1%"></td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td width="8%" align="center">Male</td>
        <td width="1%"></td>
        <td width="8%" align="center">Total</td>
        <td width="8%" align="center">Female</td>
        <td width="8%" align="center">Male</td>
    </tr>
        <tr bgcolor="##ededed">
            <td align="left">&nbsp;</td> 
            <td align="right">#numberformat(vTotal)#</td>
            <td align="right">#numberformat(vTotalFemale)#</td>
            <td align="right">#numberformat(vTotalMale)#</td>
            <td></td>
            <td align="right">#numberformat(vTotalPlaced)#</td>
            <td align="right">#numberformat(vTotalPlacedFemale)#</td>
            <td align="right">#numberformat(vTotalPlacedMale)#</td>
            <td></td>
            <td align="right">
				<cfif VAL(vTotal) AND VAL(vTotalPlaced)>
					#numberformat((vTotalPlaced/vTotal)*100,"___.__")#
                <cfelseif vTotalPlaced EQ 0>
                	0%
                <cfelse>
                	N/A
                </cfif>
            </td>
            <td align="right">
				<cfif VAL(vTotalFemale) AND VAL(vTotalPlacedFemale)>
					#numberformat((vTotalPlacedFemale/vTotalFemale)*100,"___.__")#
                <cfelseif vTotalPlaced EQ 0>
                	0%
                <cfelse>
                	N/A
                </cfif>
            </td>
            <td align="right">
				<cfif VAL(vTotalMale) AND VAL(vTotalPlacedMale)>
					#numberformat((vTotalPlacedMale/vTotalMale)*100,"___.__")#
                <cfelseif vTotalPlaced EQ 0>
                	0%
                <cfelse>
                	N/A
                </cfif>
            </td>
        </tr>
</table>

</cfoutput>