<!--- ------------------------------------------------------------------------- ----
	
	File:		dos_user_list.cfm
	Author:		Marcus Melo
	Date:		March 08, 2010
	Desc:		Department of State User List Report

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
    <cfsetting requesttimeout="9999" enablecfoutputonly="yes">
    
    <cfquery name="qUsers" datasource="MySQL">
        <!--- Get all active reps regardless if they are involved in placing/supervising kids --->
        SELECT DISTINCT
			u.userID,
            u.firstName,
            u.lastName,
            u.ssn,
            u.dateCreated
   		FROM
        	smg_users u
        INNER JOIN
        	smg_students s ON (s.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">) AND (s.placeRepID = u.userID OR s.areaRepID = u.userID) )
        INNER JOIN
        	smg_programs p ON s.programID = p.programID AND p.startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="2009/01/01">
		
        UNION
        
        SELECT
			u.userID,
            u.firstName,
            u.lastName,
            u.ssn,
            u.dateCreated
  		FROM
        	smg_users u
        INNER JOIN
        	smg_hosthistory h ON (h.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">) AND (h.placeRepID = u.userID OR h.areaRepID = u.userID) )
        
        <!---
        UNION
        
        <!--- Get inactive reps that were involved in placing/supervising kids --->
        SELECT
			u.userID,
            u.firstName,
            u.lastName,
            u.ssn,
            u.dateCreated
  		FROM
        	smg_users u
        INNER JOIN
        	smg_students s ON (s.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">) AND (s.placeRepID = u.userID OR s.areaRepID = u.userID) )
        INNER JOIN
        	smg_programs p ON s.programID = p.programID AND p.startdate >= <cfqueryparam cfsqltype="cf_sql_date" value="2009/01/01">
        WHERE
            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">       
		--->
        
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
            	uar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,12" list="yes">)             
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
<cfheader name="Content-Disposition" value="attachment; filename=smg_students.xls"> 

<!--- <cfheader name="Content-Disposition"filename=caremed_template.xls">  Open in the Browser --->

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
                Input date for everyone who functioned as a local coordinator* for any period of time since January 1, 2009 <br />
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
                    regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(APPCFC.USER.getUserAccessRights(userID=qUsers.userID, companyID=CLIENT.companyID).regionID)#">     	
            </cfquery>

            <tr>
                <td>#qUsers.firstName#</td>
                <td>#qUsers.lastName#</td>
                <td>AR</td>
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
