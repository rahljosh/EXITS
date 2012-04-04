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
    <cfparam name="FORM.placementStatus" default="">
    <cfparam name="FORM.placedDateFrom" default="">
    <cfparam name="FORM.placedDateTo" default="">

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
<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">

<cfoutput>

    <table width="98%" cellpadding="3" cellspacing="0" align="center" style="border:1px solid ##999; margin-bottom:10px; font-weight:bold;">
        <tr>
            <td align="center">
                <p>Overall Students per Facilitator - Printed on #DateFormat(now(), 'mm/dd/yyyy')# at #TimeFormat(now(), 'hh:mm tt')# EST</p>
                
                Program(s) Included in this Report: <br />
                <cfloop query="qGetPrograms">
                    #qGetPrograms.programname# &nbsp; (###qGetPrograms.programID#)<br />
                </cfloop>
               
                Placement Status: #FORM.placementStatus# <br />
                
                <cfif isDate(FORM.placedDateFrom) AND IsDate(FORM.placedDateTo)>
                	Date Placed From: #FORM.placedDateFrom# to #FORM.placedDateTo#
                </cfif>
            </td>
        </tr>
    </table>

    <cfloop query="qGetFacilitators">
    
        <cfquery name="qGetStudents" datasource="MySql">
            SELECT 	
                s.studentid, 
                s.firstname, 
                s.familylastname,
                s.datePlaced, 
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

			<cfif FORM.placementStatus EQ "Placed">
                AND 
                    s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                AND 
                    s.host_fam_approved <= <cfqueryparam cfsqltype="cf_sql_integer" value="4">
            <cfelseif FORM.placementStatus EQ "Unplaced">
                AND 
                    ( 
                    	s.hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                     OR
                     	(
                            s.hostid != <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
                        AND 
                            s.host_fam_approved > <cfqueryparam cfsqltype="cf_sql_integer" value="4">
                        )
				)                        
            </cfif>
            
            <cfif isDate(FORM.placedDateFrom) AND IsDate(FORM.placedDateTo)>
            	AND
                	s.datePlaced 
                    	BETWEEN 
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#FORM.placedDateFrom#">
                        AND 
            				<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d', 1, FORM.placedDateTo)#">
            </cfif>
            
            AND
    			s.app_current_status = <cfqueryparam cfsqltype="cf_sql_integer" value="11">
                
            ORDER BY 
                s.familyLastname,
                s.firstName
        </cfquery>
    	
        <cfif qGetStudents.recordCount>
        
            <table width="98%" align="center" cellpadding="3" cellspacing="0" class="reportFullBorder" style="font-weight:bold;">
                <tr bgcolor="##CCCCCC">
                    <td width="70%">Facilitator: #qGetFacilitators.firstname# #qGetFacilitators.lastname# (###qGetFacilitators.userID#)</td>
                    <td width="30%" align="right">Total of #qGetStudents.recordcount# students</td>
                </tr>
            </table>
            
            <table width="98%" align="center" cellpadding="3" cellspacing="0" class="reportTable">
                <tr bgcolor="##CCCCCC" style="font-weight:bold;">
                    <td width="30%" class="reportColumn">Student Information</td>
                    <td width="12%" class="reportColumnAlignCenter">Date Placed</td>
                    <td width="17%" class="reportColumnAlignCenter">Region</td>
                    <td width="17%" class="reportColumnAlignCenter">Program Manager</td>
                    <td width="12%" class="reportColumnAlignCenter">Facilitator Check</td>
                    <td width="12%" class="reportRightColumnAlignCenter">PM Check</td>
                </tr>
                <cfloop query="qGetStudents">
                    <tr>
                        <td class="reportColumn">#qGetStudents.familylastname#, #qGetStudents.firstname# (###qGetStudents.studentid#)</td>
                        <td class="reportColumnAlignCenter">#DateFormat(qGetStudents.datePlaced, 'mm/dd/yyyy')#</td>
                        <td class="reportColumnAlignCenter">#qGetStudents.regionname#</td>
                        <td class="reportColumnAlignCenter">#qGetStudents.companyShort#</td>
                        <td class="reportColumnAlignCenter">&nbsp;</td>							
                        <td class="reportRightColumnAlignCenter">&nbsp;</td>								
                    </tr>
                </cfloop>        
            </table>
            <br />
        
        </cfif>
        
    </cfloop>
    
</cfoutput>