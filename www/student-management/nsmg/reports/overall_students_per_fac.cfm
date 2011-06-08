<!--- ------------------------------------------------------------------------- ----
	
	File:		flightInfoByIntlRep.cfm
	Author:		Marcus Melo
	Date:		May 26, 2011
	Desc:		Flight Information By Intl Rep

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param FORM Variable --->
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.userID" default="0">

    <!--- Get Program --->
    <cfquery name="qGetPrograms" datasource="MYSQL">
        SELECT DISTINCT 
            p.programID, 
            p.programname 
        FROM 	
        	smg_programs p
        WHERE 		
            programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>
    
    <cfquery name="qGetFacilitators" datasource="MySql">
        SELECT 	
        	u.userID, 
            u.firstname, 
            u.lastname
        FROM 
        	smg_users u
        LEFT JOIN 
        	smg_regions r ON r.regionfacilitator = u.userID
        WHERE 	
		<cfif CLIENT.companyID EQ 5>
            r.company IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
        <cfelse>
            r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
        </cfif>        
		AND 
        	subofregion = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
        <cfif VAL(FORM.userID)>
        	AND 
            	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.userID#">
		</cfif>
        GROUP BY 
        	u.userID
        ORDER BY 
        	u.firstname
    </cfquery>

</cfsilent>

<link rel="stylesheet" href="reports.css" type="text/css">

<cfoutput>

    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:10px; font-weight:bold;">
        <tr>
            <td align="center">
                <p>Overall Students per Facilitator - Printed on #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# EST</p>
                
                Program(s) Included in this Report: <br />
                <cfloop query="qGetPrograms">
                    #qGetPrograms.programname# &nbsp; (###qGetPrograms.programID#)<br />
                </cfloop>
            </td>
        </tr>
    </table>

    <cfloop query="qGetFacilitators">
    
        <cfquery name="qGetStudents" datasource="MySql">
            SELECT 	
                s.studentid, 
                s.firstname, 
                s.familylastname, 
                r.regionname,
                c.companyShort
            FROM 
                smg_students s
            INNER JOIN 
                smg_regions r ON s.regionassigned = r.regionid
            INNER JOIN
            	smg_companies c ON c.companyID = r.company
            WHERE 
                s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
            AND 
                r.regionfacilitator = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetFacilitators.userID#">
			<cfif CLIENT.companyID EQ 5>
                AND
	                r.company IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISE#" list="yes"> )        
            <cfelse>
                AND
	                r.company = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">        
            </cfif>        
            AND 
                programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )        
            ORDER BY 
                s.familyLastname,
                s.firstName
        </cfquery>
    	
        <cfif qGetStudents.recordCount>
        
            <table width="98%" align="center" cellpadding="3" cellspacing="0" style="border:1px solid ##021157; margin-top:5px; font-weight:bold;">
                <tr bgcolor="##CCCCCC">
                    <td width="70%">Facilitator: #qGetFacilitators.firstname# #qGetFacilitators.lastname# (###qGetFacilitators.userID#)</td>
                    <td width="30%" align="right">Total of #qGetStudents.recordcount# students</td>
                </tr>
            </table>
            
            <table width="98%" align="center" cellpadding="3" cellspacing="0" style="border:1px solid ##021157; margin-top:5px;">
                <tr bgcolor="##CCCCCC" style="font-weight:bold;">
                    <td width="36%" style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">Student</td>
                    <td width="16%" style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">Region</td>
                    <td width="16%" style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">Program Manager</td>
                    <td width="16%" style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">Facilitator Check</td>
                    <td width="16%" style="border-bottom:1px solid ##021157;">PM Check</td>
                </tr>
                <cfloop query="qGetStudents">
                    <tr>
                        <td style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">#qGetStudents.firstname# #qGetStudents.familylastname# (###qGetStudents.studentid#)</td>
                        <td style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">#qGetStudents.regionname#</td>
                        <td style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">#qGetStudents.companyShort#</td>
                        <td style="border-bottom:1px solid ##021157; border-right:1px solid ##021157;">&nbsp;</td>							
                        <td style="border-bottom:1px solid ##021157;">&nbsp;</td>								
                    </tr>
                </cfloop>        
            </table>
            <br />
        
        </cfif>
        
    </cfloop>
    
</cfoutput>