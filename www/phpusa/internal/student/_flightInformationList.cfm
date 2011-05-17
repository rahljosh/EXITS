<!--- ------------------------------------------------------------------------- ----
	
	File:		_flightInformationList.cfm
	Author:		Marcus Melo
	Date:		May 11, 2011
	Desc:		Display a list of students missing flight arrival/departure

	Updated:  	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfsetting requesttimeout="9999">

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
    
    <!----PHP flight info---->
	<cfquery name="qPHPStudentsMissingArrival" datasource="mysql">
		SELECT DISTINCT 
        	s.studentid, 
            s.uniqueid, 
            s.firstname, 
            s.familylastname, 
            s.host_fam_approved, 
			p.programname, 
			h.familylastname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.state,
            php.dateplaced,
            php.assignedID,
            php.programID,
            sc.schoolName 
		FROM 
        	smg_students s
		INNER JOIN 
        	php_students_in_program php on php.studentid = s.studentid
		INNER JOIN 
        	smg_hosts h ON php.hostid = h.hostid
        INNER JOIN 
        	smg_programs p ON php.programid = p.programid
		LEFT OUTER JOIN
        	php_schools sc ON sc.schoolID = php.schoolID                   
		WHERE
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            p.enddate > now()
        AND
            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
         
		<cfif CLIENT.userType EQ 8>
            <!--- Intl Rep --->
            AND
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">            
        <cfelseif CLIENT.userType EQ 11>
            <!--- Branch --->
            AND
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentCompany#">
            AND    
                s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfif>   

        AND 
            s.studentid NOT IN (
            						SELECT 
                                    	studentid 
                                    FROM 
                                    	smg_flight_info 
                                    WHERE 
                                    	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                                    AND 
                                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                    AND 
                                    	isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
									AND
                                    	programID = php.programID                                        
								)	
        ORDER BY 
        	s.familylastname
	</cfquery>

	<cfquery name="qPHPStudentsMissingDeparture" datasource="mysql">
		SELECT DISTINCT 
        	s.studentid, 
            s.uniqueid, 
            s.firstname, 
            s.familylastname, 
            s.host_fam_approved, 
			p.programname, 
			h.familylastname, 
            h.fatherlastname, 
            h.motherlastname, 
            h.state,
            php.dateplaced,
            php.assignedID,
            php.programID,
            sc.schoolName 
		FROM 
        	smg_students s
		INNER JOIN 
        	php_students_in_program php on php.studentid = s.studentid
		INNER JOIN 
        	smg_hosts h ON php.hostid = h.hostid
        INNER JOIN 
        	smg_programs p ON php.programid = p.programid
		LEFT OUTER JOIN
        	php_schools sc ON sc.schoolID = php.schoolID        
		WHERE 
            s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
            p.enddate > now()
        AND
            s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
			
		<cfif CLIENT.userType EQ 8>
            <!--- Intl Rep --->
            AND
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">            
        <cfelseif CLIENT.userType EQ 11>
            <!--- Branch --->
            AND
                s.intrep = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.parentCompany#">
            AND    
                s.branchID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
        </cfif>    

        AND 
            s.studentid NOT IN (
            						SELECT 
                                  		studentid 
                                    FROM 
                                    	smg_flight_info 
                                    WHERE 
                                    	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure"> 
                                    AND 
                                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                    AND 
                                    	isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
									AND
                                    	programID = php.programID                                        
								)	
        ORDER BY 
        	s.familylastname
	</cfquery>

</cfsilent>

<script language="javascript">	
    // Document Ready!
    $(document).ready(function() {

		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"60%", 
			height:"90%", 
			iframe:true,
			overlayClose:false,
			escKey:false 
		});		

	});
</script>    

<cfoutput>

	<!--- Table Header --->
    <gui:tableHeader
        width="98%"
        tableTitle="Flight Information List"
        imageName="students.gif"
    />    

    <table width="98%" border="0" cellpadding="4" cellspacing="0" class="section" align="center">
        <tr>
            <td>
        
				<!--- PHP Missing Arrival Information --->
                <table width="98%" cellspacing="0" cellpadding="3" style="border:1px solid ##999" align="center">
                    <tr>
                        <th bgcolor="##E2EFC7" style="border-bottom:1px solid ##999">
                            <span class="get_attention"><b>:: </b></span>
                            Private School Students Missing Flight Arrival Information - Total of #qPHPStudentsMissingArrival.recordCount# students
                        </th>
                    </tr>    
                    <tr>
                        <td valign="top" align="center" style="padding-top:10px; padding-bottom:10px;">
                            <table width="100%" align="center" cellspacing="0" cellpadding="3">
                                <tr bgcolor="##E2EFC7" style="font-weight:bold;">
                                    <td width="20%">Student Name (ID)</td>
                                    <td width="12%">Program</td>
                                    <td width="10%">Placed On</td>
                                    <td width="12%">Host Family</td>                    
                                    <td width="22%">School</td>                    
                                    <td width="10%">Pre-AYP Camp</td>
                                    <td width="14%">Actions</td>
                                </tr>
                                <cfloop query="qPHPStudentsMissingArrival">
                                    <tr bgcolor="###iif(qPHPStudentsMissingArrival.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                                        <td>
                                            <a href="index.cfm?curdoc=student/student_profile&unqid=#qPHPStudentsMissingArrival.uniqueid#&assignedID=#qPHPStudentsMissingArrival.assignedID#">
                                                #qPHPStudentsMissingArrival.firstname# #qPHPStudentsMissingArrival.familylastname# (###qPHPStudentsMissingArrival.studentid#)
                                            </a>
                                        </td>
                                        <td>#qPHPStudentsMissingArrival.programname#</td>
                                        <td>#DateFormat(qPHPStudentsMissingArrival.dateplaced, 'mm/dd/yy')#</td>
                                        <td>
                                            <cfif qPHPStudentsMissingArrival.fatherlastname EQ qPHPStudentsMissingArrival.motherlastname>
                                                #qPHPStudentsMissingArrival.fatherlastname# (#qPHPStudentsMissingArrival.state#) 
                                            <cfelse>
                                                #qPHPStudentsMissingArrival.familylastname# (#qPHPStudentsMissingArrival.state#) 
                                            </cfif>
                                        </td>
                                        <td>#qPHPStudentsMissingDeparture.schoolName#</td>
                                        <td>n/a</td>
                                        <td style="font-weight:bold;">
                                            <a href="student/index.cfm?action=flightInformation&uniqueID=#qPHPStudentsMissingArrival.uniqueID#&programID=#qPHPStudentsMissingArrival.programID#" class="jQueryModal">
                                                [ Submit Arrival ]
                                            </a>
                                        </td>
                                    </tr>
                                </cfloop>
                                <cfif NOT VAL(qPHPStudentsMissingArrival.recordcount)>
                                    <tr>
                                        <td colspan="6" align="center" bgcolor="##FFFFE6">                    
                                            You currently have no active students placed in the United States.
                                        </td>
                                    </tr>                                                    
                                </cfif>
                            </table>
                        </td>
                    </tr>
                </table>
                
                <br /><br />
                    
                <!--- PHP Missing Departure Information --->
                <table width="98%" cellspacing="0" cellpadding="3" style="border:1px solid ##999" align="center">
                    <tr>
                        <th bgcolor="##E2EFC7" style="border-bottom:1px solid ##999">
                            <span class="get_attention"><b>:: </b></span>
                            Private School Students Missing Flight Departure Information - Total of #qPHPStudentsMissingDeparture.recordCount# students
                        </th>
                    </tr>    
                    <tr>
                        <td valign="top" align="center" style="padding-top:10px; padding-bottom:10px;">
                            <table width="100%" align="center" cellspacing="0" cellpadding="3">
                                <tr bgcolor="##E2EFC7" style="font-weight:bold;">
                                    <td width="20%">Student Name (ID)</td>
                                    <td width="12%">Program</td>
                                    <td width="10%">Placed On</td>
                                    <td width="12%">Host Family</td>                    
                                    <td width="22%">School</td>                    
                                    <td width="10%">Pre-AYP Camp</td>
                                    <td width="14%">Actions</td>
                                </tr>
                                <cfloop query="qPHPStudentsMissingDeparture">
                                    <tr bgcolor="###iif(qPHPStudentsMissingDeparture.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                                        <td>
                                            <a href="index.cfm?curdoc=student/student_profile&unqid=#qPHPStudentsMissingDeparture.uniqueid#&assignedID=#qPHPStudentsMissingDeparture.assignedID#">
                                                #qPHPStudentsMissingDeparture.firstname# #qPHPStudentsMissingDeparture.familylastname# (###qPHPStudentsMissingDeparture.studentid#)
                                            </a>
                                        </td>
                                        <td>#qPHPStudentsMissingDeparture.programname#</td>
                                        <td>#DateFormat(qPHPStudentsMissingDeparture.dateplaced, 'mm/dd/yy')#</td>
                                        <td>
                                            <cfif qPHPStudentsMissingDeparture.fatherlastname EQ qPHPStudentsMissingDeparture.motherlastname>
                                                #qPHPStudentsMissingDeparture.fatherlastname# (#qPHPStudentsMissingDeparture.state#) 
                                            <cfelse>
                                                #qPHPStudentsMissingDeparture.familylastname# (#qPHPStudentsMissingDeparture.state#) 
                                            </cfif>
                                        </td>
                                        <td>#qPHPStudentsMissingDeparture.schoolName#</td>
                                        <td>n/a</td>
                                        <td style="font-weight:bold;">
                                            <a href="student/index.cfm?action=flightInformation&uniqueID=#qPHPStudentsMissingDeparture.uniqueID#&programID=#qPHPStudentsMissingDeparture.programID#" class="jQueryModal">
                                                [ Submit Departure ]
                                            </a>
                                        </td>
                                    </tr>
                                </cfloop>
                                <cfif NOT VAL(qPHPStudentsMissingDeparture.recordcount)>
                                    <tr>
                                        <td colspan="6" align="center" bgcolor="##FFFFE6">                    
                                            You currently have no active students placed in the United States.
                                        </td>
                                    </tr>                                                    
                                </cfif>
                            </table>
                        </td>
                    </tr>
                </table>
				<br />
                
            </td>
        </tr>
    </table> <!--- end of main table --->
            
	<!--- Table Footer --->
    <gui:tableFooter 
        width="98%"
    />
    
</cfoutput>