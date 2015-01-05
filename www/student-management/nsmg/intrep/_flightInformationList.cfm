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
    
    <!--- Arrival Information --->
	<cfquery name="qStudentsMissingArrival" datasource="#application.dsn#">
		SELECT DISTINCT 
        	s.studentID, 
            s.uniqueID, 
            s.programID,
            s.firstname, 
            s.familylastname, 
            s.host_fam_approved, 
            s.dateplaced,
            s.aypEnglish,
            s.hostID,
			p.programname, 
			h.familylastname AS hostFamilyName, 
            h.fatherlastname, 
            h.motherlastname, 
            h.state,
            ac.name AS campName,
            regularArrival.flightID,
            sc.schoolName,
            preAYPArrival.flightID AS preAYPFlightID
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_programs p ON s.programid = p.programid
		LEFT OUTER JOIN
        	smg_hosts h ON s.hostid = h.hostid
		LEFT OUTER JOIN
        	smg_schools sc ON sc.schoolID = s.schoolID        
        LEFT OUTER JOIN
        	smg_aypcamps ac ON ac.campID = s.aypEnglish
		LEFT OUTER JOIN
        	smg_flight_info preAYPArrival ON preAYPArrival.studentID = s.studentID
                AND
                	preAYPArrival.programID = s.programID
                AND
                    preAYPArrival.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAYPArrival"> 
                AND 
                    preAYPArrival.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                AND 
                    preAYPArrival.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
		LEFT OUTER JOIN
        	smg_flight_info regularArrival ON regularArrival.studentID = s.studentID
                AND
                	regularArrival.programID = s.programID
                AND
                    regularArrival.flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                AND 
                    regularArrival.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                AND 
                    regularArrival.isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
        WHERE 
			s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND                    					
            s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">                
            
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
        
        <!--- Canada Students are not placed --->  
        <cfif APPLICATION.SETTINGS.COMPANYLIST.Canada NEQ CLIENT.companyID>
			AND 
				s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
		</cfif>		
        
		<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
		AND 
            (	<!--- Arrival --->
                s.studentID NOT IN ( 
                                        SELECT 
                                            studentID 
                                        FROM 
                                            smg_flight_info 
                                        WHERE 
                                            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival"> 
                                        AND
                                            programID = s.programID
                                        AND 
                                            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                        AND 
                                            isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                                    )	
			OR			                                
                (	<!--- Pre-AYP Arrival --->
                	s.aypEnglish != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                AND    
                    s.studentID NOT IN ( 
                                            SELECT 
                                                studentID 
                                            FROM 
                                                smg_flight_info 
                                            WHERE 
                                                flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="preAYPArrival"> 
                                            AND
                                                programID = s.programID
                                            AND 
                                                isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> 
                                            AND 
                                                isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
                                        )	
				)                                        
			)                                    
        ORDER BY 
        	s.familylastname
	</cfquery>
	
	<!----Departure Information---->
	<cfquery name="qStudentsMissingDeparture" datasource="#APPLICATION.dsn#">
		SELECT DISTINCT 
        	s.studentID, 
            s.uniqueID,
            s.programID, 
            s.firstname, 
            s.familylastname, 
            s.host_fam_approved, 
            s.dateplaced,
			p.programname, 
            DATE_SUB(p.enddate, INTERVAL 3 MONTH) AS startInputDate,
			h.familylastname AS hostFamilyName, 
            h.fatherlastname, 
            h.motherlastname, 
            h.state,
			sc.schoolName,            
            ac.name AS campName
		FROM 
        	smg_students s
		INNER JOIN 
        	smg_programs p ON s.programid = p.programid
		INNER JOIN 
        	smg_hosts h ON s.hostid = h.hostid
		LEFT OUTER JOIN
        	smg_schools sc ON sc.schoolID = s.schoolID        
		LEFT OUTER JOIN
        	smg_aypcamps ac ON ac.campID = s.aypEnglish
		WHERE 
			s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
        AND                    					
            s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">                
        AND 
            s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        AND 
            s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">

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
        
		<cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            AND
                s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
        <cfelse>
            AND
                s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
        </cfif>
        
		AND 
            s.studentID NOT IN ( 
            						SELECT 
                                    	studentID 
									FROM 
                                    	smg_flight_info 
                                    WHERE 
                                    	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
                                    AND
                                        programID = s.programID
                                    AND 
                                    	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                                    AND 
                                    	isCompleted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">                                         
								)	
        ORDER BY 
        	s.familylastname
	</cfquery>

	<!--- Do Not Display For Canada --->
    <cfif APPLICATION.SETTINGS.COMPANYLIST.Canada NEQ CLIENT.companyID>
    
		<!----PHP flight info---->
        <cfquery name="qPHPStudentsMissingArrival" datasource="#APPLICATION.dsn#">
            SELECT DISTINCT 
                s.studentid, 
                s.uniqueid, 
                s.firstname, 
                s.familylastname, 
                p.programname, 
                h.familylastname AS hostFamilyName, 
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
                smg_programs p ON php.programid = p.programid
            LEFT OUTER JOIN
                smg_hosts h ON php.hostid = h.hostid
            LEFT OUTER JOIN
                php_schools sc ON sc.schoolID = php.schoolID                   
            WHERE
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND
                p.enddate > now()
             
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
                                        AND
                                            assignedID = php.assignedID                                       
                                    )	
            ORDER BY 
                s.familylastname
        </cfquery>

        <cfquery name="qPHPStudentsMissingDeparture" datasource="#APPLICATION.dsn#">
            SELECT DISTINCT 
                s.studentid, 
                s.uniqueid, 
                s.firstname, 
                s.familylastname, 
                p.programname, 
                DATE_SUB(p.enddate, INTERVAL 3 MONTH) AS startInputDate,
                h.familylastname AS hostFamilyName, 
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
                smg_programs p ON php.programid = p.programid
            LEFT OUTER JOIN
                smg_hosts h ON php.hostid = h.hostid
            LEFT OUTER JOIN
                php_schools sc ON sc.schoolID = php.schoolID        
            WHERE 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                p.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND
                p.enddate > now()
                
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
                                        AND
                                            assignedID = php.assignedID                                                                               
                                    )	
            ORDER BY 
                s.familylastname
        </cfquery>

	</cfif>

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
    
<!--- Upload XML | INTO International Representative --->
<cfif ListFind("20,21,28,109,115,628,701,6584,7199,7502,8913,9106,11480,11565,12038,12201", CLIENT.userID)>

    <table width="100%" cellspacing="0" cellpadding="3" style="border:1px solid ##999">
        <tr>
        	<td bgcolor="##E2EFC7" colspan="2">
            	<span class="get_attention"><b>:: </b></span>Upload flight info in an XML file.
            </td>
        </tr>
        <tr>
            <td style="line-height:20px;" valign="top" width="100%">
                <form action="?curdoc=xml/get_flight_info" method="post" enctype="multipart/form-data">
                    Select your XML file: 
                    <input type="file" name="flights" size=50 required="yes" enctype="multipart/form-data">
                    <br><br>
                    Options:<br>
                    <input type="checkbox" name="displayResults" value="1" checked>Display results on screen<br>
                    <input type="checkbox" name="receiveXML" value="1" checked> I'd like to receive back an XML file for verification.
                    <br><br>
                    Upload file and process: <input type="submit" value="Process" alt="Upload File to Server">
                </form>
            </td>
        </tr>
    </table>
    
    <br /><br />

</cfif>

<!--- Public School Missing Arrival Information --->
<table width="100%" cellspacing="0" cellpadding="3" style="border:1px solid ##999">
	<tr>
        <th bgcolor="##E2EFC7" style="border-bottom:1px solid ##999">
            <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            	Public School 
            </cfif>
            Students Missing Flight Arrival Information - Total of #qStudentsMissingArrival.recordCount# students
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
                    <td width="14%">School</td>                    
                    <td width="10%">Pre-AYP Camp</td>
                    <td width="22%">Actions</td>
                </tr>
                <cfloop query="qStudentsMissingArrival">
                    <tr bgcolor="###iif(qStudentsMissingArrival.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                        <td>
                            <a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingArrival.uniqueID#">
                                #qStudentsMissingArrival.firstname# #qStudentsMissingArrival.familylastname# (###qStudentsMissingArrival.studentID#)
                            </a>
                        </td>
                        <td>#qStudentsMissingArrival.programname#</td>
                        <td>	
                            <cfif qStudentsMissingArrival.host_fam_approved LTE 4> 
                                #DateFormat(qStudentsMissingArrival.dateplaced, 'mm/dd/yy')#
                            <cfelseif APPLICATION.SETTINGS.COMPANYLIST.Canada EQ CLIENT.companyID>
								n/a
                            <cfelse> 
                                Pending Approval 
                            </cfif>
                        </td>
                        <td>
                            <cfif LEN(qStudentsMissingArrival.hostFamilyName)>
                                #qStudentsMissingArrival.hostFamilyName# (#qStudentsMissingArrival.state#) 
                            <cfelse>
                            	n/a
                            </cfif>
                        </td>
                        <td>#qStudentsMissingArrival.schoolName#</td>
                        <td>
                            <cfif LEN(qStudentsMissingArrival.campName)>
                                #qStudentsMissingArrival.campName#
                            <cfelse>                                
                                n/a    
                            </cfif>
                        </td>
                        <td style="font-weight:bold;">
                        
                       
                            <cfif VAL(qStudentsMissingArrival.aypEnglish) AND NOT LEN(qStudentsMissingArrival.preAYPFlightID)>
                                <a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingArrival.uniqueID#&programID=#qStudentsMissingArrival.programID#" class="jQueryModal">
                                    [ Submit Pre-AYP Arrival ] 
                                </a>
                            </cfif>
                        	
                            <cfif VAL(qStudentsMissingArrival.aypEnglish) AND NOT LEN(qStudentsMissingArrival.preAYPFlightID) AND NOT LEN(qStudentsMissingArrival.flightID)>
                            	&nbsp; | &nbsp;
                            </cfif>
                            
                            <cfif NOT LEN(qStudentsMissingArrival.flightID)>
                                <a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingArrival.uniqueID#&programID=#qStudentsMissingArrival.programID#" class="jQueryModal">
                                    [ Submit Arrival ]
                                </a>
                            </cfif>
                        </td>
                        
                    </tr>
                </cfloop>
				<cfif NOT VAL(qStudentsMissingArrival.recordcount)>
                    <tr>
                    	<td colspan="7" align="center" bgcolor="##FFFFE6">                    
		                    You currently have no active students placed in the United States.
						</td>
					</tr>                                                    
				</cfif>
            </table>
		</td>
	</tr>
</table>

<br /><br />
	
<!--- Public School Missing Departure Information --->
<table width="100%" cellspacing="0" cellpadding="3" style="border:1px solid ##999">
	<tr>
        <th bgcolor="##E2EFC7" style="border-bottom:1px solid ##999">
            <cfif listFind(APPLICATION.SETTINGS.COMPANYLIST.ISESMG, CLIENT.companyID)>
            	Public School 
            </cfif>
            Students Missing Flight Departure Information - Total of #qStudentsMissingDeparture.recordCount# students
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
                    <td width="14%">School</td>                    
                    <td width="10%">Pre-AYP Camp</td>
                    <td width="22%">Actions</td>
                </tr>
                <cfloop query="qStudentsMissingDeparture">
                    <tr bgcolor="###iif(qStudentsMissingDeparture.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                        <td>
                            <a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qStudentsMissingDeparture.uniqueID#">
                                #qStudentsMissingDeparture.firstname# #qStudentsMissingDeparture.familylastname# (###qStudentsMissingDeparture.studentID#)
                            </a>
                        </td>
                        <td>#qStudentsMissingDeparture.programname#</td>
                        <td>	
                            <cfif qStudentsMissingDeparture.host_fam_approved LTE 4> 
                                #DateFormat(qStudentsMissingDeparture.dateplaced, 'mm/dd/yy')#
							<cfelse> 
                                Pending Approval 
                            </cfif>
                        </td>
                        <td>
                            <cfif LEN(qStudentsMissingDeparture.hostFamilyName)>
                                #qStudentsMissingDeparture.hostFamilyName# (#qStudentsMissingDeparture.state#) 
                            <cfelse>
                            	n/a
							</cfif>
                        </td>
                        <td>#qStudentsMissingDeparture.schoolName#</td>
                        <td>
                            <cfif LEN(qStudentsMissingDeparture.campName)>
                                #qStudentsMissingDeparture.campName#
                            <cfelse>                                
                                n/a    
                            </cfif>
                        </td>
                        <td style="font-weight:bold;">
                        	<cfif '#now()#' gt #qStudentsMissingDeparture.startInputDate# and client.companyid eq 10>
                        Submit after #DateFormat(qStudentsMissingDeparture.startInputDate, 'mm/dd/yyyy')# 
                            <cfelse>
                                <a href="student/index.cfm?action=flightInformation&uniqueID=#qStudentsMissingDeparture.uniqueID#" class="jQueryModal">
                                    [ Submit Departure ]
                                </a>
                            </cfif>
                        </td>
                    </tr>
                </cfloop>
                <cfif NOT VAL(qStudentsMissingDeparture.recordcount)>
                    <tr>
                        <td colspan="7" align="center" bgcolor="##FFFFE6">                    
                            You currently have no active students placed in the United States.
                        </td>
                    </tr>                                                    
                </cfif>
            </table>
		</td>
	</tr>
</table>

<br /><br />

<!--- Do Not Display For Canada --->
<cfif APPLICATION.SETTINGS.COMPANYLIST.Canada NEQ CLIENT.companyID>

	<!--- PHP Missing Arrival Information --->
    <table width="100%" cellspacing="0" cellpadding="3" style="border:1px solid ##999">
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
                        <td width="14%">School</td>                    
                        <td width="10%">Pre-AYP Camp</td>
                        <td width="22%">Actions</td>
                    </tr>
                    <cfloop query="qPHPStudentsMissingArrival">
                        <tr bgcolor="###iif(qPHPStudentsMissingArrival.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                            <td>
                                <a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qPHPStudentsMissingArrival.uniqueID#">
                                    #qPHPStudentsMissingArrival.firstname# #qPHPStudentsMissingArrival.familylastname# (###qPHPStudentsMissingArrival.studentID#)
                                </a>
                            </td>
                            <td>#qPHPStudentsMissingArrival.programname#</td>
                            <td>#DateFormat(qPHPStudentsMissingArrival.dateplaced, 'mm/dd/yy')#</td>
                            <td>
                                <cfif LEN(qPHPStudentsMissingArrival.hostFamilyName)>
                                    #qPHPStudentsMissingArrival.hostFamilyName# (#qPHPStudentsMissingArrival.state#) 
                                <cfelse>
                                	n/a
								</cfif>
                            </td>
                            <td>#qPHPStudentsMissingArrival.schoolName#</td>
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
                            <td colspan="7" align="center" bgcolor="##FFFFE6">                    
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
    <table width="100%" cellspacing="0" cellpadding="3" style="border:1px solid ##999">
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
                        <td width="14%">School</td>                    
                        <td width="10%">Pre-AYP Camp</td>
                        <td width="22%">Actions</td>
                    </tr>
                    <cfloop query="qPHPStudentsMissingDeparture">
                        <tr bgcolor="###iif(qPHPStudentsMissingDeparture.currentrow MOD 2 ,DE("FFFFE6") ,DE("FFFFFF") )#">
                            <td>
                                <a href="index.cfm?curdoc=intrep/int_student_info&unqid=#qPHPStudentsMissingDeparture.uniqueID#">
                                    #qPHPStudentsMissingDeparture.firstname# #qPHPStudentsMissingDeparture.familylastname# (###qPHPStudentsMissingDeparture.studentID#)
                                </a>
                            </td>
                            <td>#qPHPStudentsMissingDeparture.programname#</td>
                            <td>#DateFormat(qPHPStudentsMissingDeparture.dateplaced, 'mm/dd/yy')#</td>
                            <td>
                                <cfif LEN(qPHPStudentsMissingDeparture.hostFamilyName)>
                                    #qPHPStudentsMissingDeparture.hostFamilyName# (#qPHPStudentsMissingDeparture.state#) 
                                <cfelse>
                                	n/a
								</cfif>
                            </td>
                            <td>#qPHPStudentsMissingDeparture.schoolName#</td>
                            <td>n/a</td>
                            <td style="font-weight:bold;">
                            <cfif '#now()#' gt #qPHPStudentsMissingDeparture.startInputDate# and client.companyid eq 10>
                        Submit after #DateFormat(qPHPStudentsMissingDeparture.startInputDate, 'mm/dd/yyyy')# 
                            <cfelse>
                                <a href="student/index.cfm?action=flightInformation&uniqueID=#qPHPStudentsMissingDeparture.uniqueID#&programID=#qPHPStudentsMissingDeparture.programID#" class="jQueryModal">
                                    [ Submit Departure ]
                                </a>
                            </cfif>
                            </td>
                        </tr>
                    </cfloop>
                    <cfif NOT VAL(qPHPStudentsMissingDeparture.recordcount)>
                        <tr>
                            <td colspan="7" align="center" bgcolor="##FFFFE6">                    
                                You currently have no active students placed in the United States.
                            </td>
                        </tr>                                                    
                    </cfif>
                </table>
            </td>
        </tr>
    </table>
    
    <br />

</cfif>

</cfoutput>