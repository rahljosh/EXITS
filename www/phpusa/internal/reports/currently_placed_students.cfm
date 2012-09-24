<!--- ------------------------------------------------------------------------- ----
	
	File:		currently_placed_students.cfm
	Author:		James Griffiths
	Date:		September 19, 2012
	Desc:		List of students that are currently placed with host family information.

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Form Variables ---->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.orderBy" default="1">
    
    <!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
    
    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT
        	*
        FROM
        	smg_programs 
        LEFT JOIN
        	smg_program_type ON type = programtypeid
        WHERE
        	programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>
    
</cfsilent>

<style type="text/css">
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		font:Arial, Helvetica, sans-serif;
		font-size:18px;
		font-weight: bold;
		text-decoration:underline;
		background: #C2D1EF;
	}
</style>

<cfoutput>

	<table width="100%" cellpadding="4" cellspacing="0" align="center">
    	<tr>
        	<th><span class="application_section_header">#companyshort.companyshort# - Students Currently Placed</span></th>
        </tr>
    </table>
    
    <br>
    
    <table width="95%" cellpadding=4 cellspacing="0" align="center" frame="box">
		<tr>
        	<td align="center">
				Program(s) Included in this Report:<br>
				<cfloop query="qGetPrograms"><b>#programname# &nbsp; (#ProgramID#)</b><br></cfloop>
			</td>
     	</tr>
	</table>
    
    <br>
    
    <cfloop query="qGetPrograms">
    
    	<!--- Get results --->
        <cfquery name="qGetResults" datasource="MySql">
            SELECT
                php.studentID,
                s.firstName,
                s.familyLastName AS studentLastName,
                h.fatherFirstName,
                h.motherFirstName,
                h.familyLastName AS hostLastName,
                h.hostID,
                h.address,
                h.address2,
                h.city,
                h.state,
                h.zip,
                school.schoolName
            FROM
                php_students_in_program php
            INNER JOIN
                smg_students s ON s.studentID = php.studentID
            INNER JOIN
                smg_hosts h ON h.hostID = php.hostID
           	INNER JOIN
            	php_schools school ON school.schoolID = php.schoolID
            WHERE
                php.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetPrograms.programID#">
            AND
                php.hostID != 0
            AND
                php.active = 1
          	<cfif FORM.orderBy EQ 2>
            	ORDER BY
                	hostLastName,
                    fatherFirstName,
                    motherFirstName
            <cfelseif FORM.orderBy EQ 3>
            	ORDER BY
                	schoolName,
                    studentLastName,
                    firstName
            <cfelse>
            	ORDER BY
                	studentLastName,
                    firstName
            </cfif>
        </cfquery>
        
        <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">
			<tr><td><b>Program #programname# &nbsp; &nbsp; &nbsp; Total of #qGetResults.recordcount# student(s)</b></td></tr>	
		</table>
        
        <br />
        
        <table width="95%" cellpadding="0" cellspacing="0" align="center" frame="below">

            <tr>
                <td width="25%"><b>Student</b></td>
                <td width="25%"><b>Host Family</b></td>
                <td width="30%"><b>Address</b></td>
                <td width="20%"><b>School</b></td>
            </tr>
            
            <cfloop query="qGetResults">
                <tr bgcolor="#iif(currentrow MOD 2 ,DE('ededed') ,DE('white') )#">
                    <td>#firstName# #studentLastName# (###studentID#)</td>
                    <td>#fatherFirstName#<cfif LEN(fatherFirstName) AND LEN(motherFirstName)> & </cfif>#motherFirstName# #hostLastName# (###hostID#)</td>
                    <td>#address# #address2# #city#, #state# #zip#</td>
                    <td>#schoolName#</td>
                </tr>
            </cfloop>
            
        </table>
        
    </cfloop>
    
</cfoutput>