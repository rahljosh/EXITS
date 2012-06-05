<!--- ------------------------------------------------------------------------- ----
	
	File:		dos_user_list.cfm
	Author:		Marcus Melo
	Date:		March 08, 2010
	Desc:		Department of State User List Report

	Updated:  	06/05/2012 - Modified to get users involved from 2011/01/01

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
    <cfsetting requesttimeout="9999" enablecfoutputonly="yes">
    
    <cfquery name="qUsers" datasource="MySQL">
        <!--- Placing Reps --->
		SELECT
			userID,
            firstName,
            lastName,
            ssn,
            dateCreated,
            regionID,
            userType
        FROM
        	(
                <!--- Placing Reps --->
                SELECT DISTINCT
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.ssn,
                    u.dateCreated,
                    uar.regionID,
                    uar.userType
                FROM
					smg_students s
                INNER JOIN
                    smg_programs p ON s.programID = p.programID
                    	AND
                        	p.startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/01/01"> 
                INNER JOIN
                    smg_hosthistory h ON s.studentID = h.studentID
				INNER JOIN
                	smg_users u ON u.userID = h.placeRepID
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                    	AND
                        	uar.regionID = s.regionAssigned
                WHERE
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                
                UNION
                
                <!--- Supervising Reps --->
                SELECT DISTINCT
                    u.userID,
                    u.firstName,
                    u.lastName,
                    u.ssn,
                    u.dateCreated,
                    uar.regionID,
                    uar.userType
                FROM
					smg_students s
                INNER JOIN
                    smg_programs p ON s.programID = p.programID
                    	AND
                        	p.startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="2011/01/01"> 
                INNER JOIN
                    smg_hosthistory h ON s.studentID = h.studentID
				INNER JOIN
                	smg_users u ON u.userID = h.areaRepID
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                    	AND
                        	uar.regionID = s.regionAssigned
                WHERE
                	s.companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )
                
			) AS t
            
        GROUP BY
        	userID
        
        ORDER BY
        	lastName,
            firstName
    </cfquery>


	<cfquery name="qRegionalManagersList" datasource="MySQL">
		SELECT
        	u.userID,
            CONCAT(u.lastName, ', ', u.firstName) as name,
            uar.regionID
		FROM
        	smg_users u
		INNER JOIN 
        	user_access_rights uar ON uar.userID = u.userID 
            AND 
            	uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
			AND
            	uar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes">)             
	</cfquery>


	<cffunction name="checkHostFamily" access="public" returntype="string">
    	<cfargument name="SSN" hint="SSN is required">

        <cfscript>
			// 
			var isHost = 'No';
		</cfscript>
		
        <cfif LEN(ARGUMENTS.SSN)>
        
            <cfquery 
            	name="qCheckHostFamily" 
                datasource="MySQL">
                SELECT 
                    hostID
                FROM
                    smg_hosts
                WHERE 
                    fatherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.SSN#">
                OR	
                    motherSSN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.SSN#">                
            </cfquery>
            
            <cfscript>
                if ( VAL(qCheckHostFamily.recordCount) ) {
                    isHost = 'Yes';
                } 		
            </cfscript>

		</cfif>
        
        <cfscript>
			return isHost;
		</cfscript>

    </cffunction>

</cfsilent>    

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<!--- "Content-Disposition" in cfheader also ensures 
relatively correct Internet Explorer behavior. --->
<cfheader name="Content-Disposition" value="attachment; filename=dos-user-list.xls"> 

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->

<cfoutput>

	<style type="text/css">
		table.tableReport {
			border-width: 0px 0px 0px 0px;
			border-spacing: 0px;
			border-style: none none none none;
			border-color: black black black black;
			border-collapse: collapse;
			background-color: white;
		}
		table.tableReport th {
			border-width: 1px 1px 1px 1px;
			padding: 2px 2px 2px 2px;
			border-style: solid solid solid solid;
			border-color: black black black black;
			background-color: white;
			-moz-border-radius: 0px 0px 0px 0px;
		}
		table.tableReport th.noBorder {
            border:none;
        }
		table.tableReport td {
			border-width: 1px 1px 1px 1px;
			padding: 2px 2px 2px 2px;
			border-style: solid solid solid solid;
			border-color: black black black black;
			background-color: white;
			-moz-border-radius: 0px 0px 0px 0px;
		}	
        table.tableReport td.noBorder {
            border:none;
			font-weight:bold;
        }
    </style>

    <table class="tableReport">
        <tr>
        	<th colspan="12" class="noBorder">LOCAL COORDINATOR STAFF LIST</th>
        </tr>
        <tr>
        	<td colspan="12" class="noBorder">PROGRAM NAME:</td>
        </tr>
        <tr>
        	<td colspan="12" class="noBorder">PROGRAM NUMBER:</td>
        </tr>
        <tr>
        	<td colspan="12">
                LOCAL COORDINATOR STAFF LIST <br />
                Input date for everyone who functioned as a local coordinator* for any period of time since January 1, 2011 <br />
                *Local coordinator is defined as anyone with direct responsability for securing home and school placements and for monitoring exchange visitors.                        
            </td>
        </tr>
        <tr>
            <td><b>First Name</b></td>
            <td><b>Last Name</b></td>
            <td><b>Title</b></td>
            <td><b>Supervisor</b></td>
            <td><b>Does s/he also serve as host family?</b></td>
            <td><b>Does s/he represent another J-1 sponsor?</b></td>
            <td><b>Employee, independent contractor, or volunteer</b></td>
            <td><b>Full-time or part-time</b></td>
            <td><b>Date of Hire</b></td>
            <td><b>Does s/he work on ECA grants?</b></td>						
            <td><b>If so, which programs?</b></td>
            <td><b>% of time spent on ECA grants</b></td>	
        </tr>
        
        <cfloop query="qUsers">	
        
            <cfquery name="qRegionalManager" dbtype="query">
                SELECT
                    name
                FROM
                    qRegionalManagersList
                WHERE
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qUsers.regionID#">     	
            </cfquery>

            <tr>
                <td>#qUsers.firstName#</td>
                <td>#qUsers.lastName#</td>
                <td>	
                	<cfif qUsers.userType EQ 5>
                    	Regional Manager
                    <cfelse>
                    	AR
                    </cfif>
                </td>
                <td>#qRegionalManager.name#</td>
                <td>#checkHostFamily(qUsers.SSN)#</td>
                <td>N/A</td>
                <td>Independent Contractor</td>
                <td>Part-time</td>
                <td>#DateFormat(qUsers.dateCreated, 'mm/dd/yyyy')#</td>
                <td>No</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>		
        </cfloop>
        
    </table>

</cfoutput>
