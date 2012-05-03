<!--- ------------------------------------------------------------------------- ----
	
	File:		_usersAuthorizationNotReceived.cfm
	Author:		James Griffiths
	Date:		April 25, 2012
	Desc:		Users Authorization Not Received
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=usersAuthorizationNorReceived
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables	
		param name="FORM.regionID" default=0;
		param name="FORM.type" default=0;
	</cfscript>	
    
    <!--- Get Users --->
    <cfquery name="qGetUsers" datasource="#APPLICATION.DSN#">
    	SELECT DISTINCT
        	u.userID,
            u.firstName,
            u.middleName,
            u.lastName,
            u.userID,
            u.ssn,
            uar.regionID,
            r.regionName
       	FROM
        	smg_users u
        INNER JOIN 
        	user_access_rights uar ON uar.userid = u.userid
       	INNER JOIN
        	smg_regions r ON r.regionID = uar.regionID
        WHERE 
        	u.active = '1'
            AND 
            	uar.companyid = <cfqueryparam value="#client.companyid#" cfsqltype="cf_sql_integer">
            AND 
            	uar.regionid IN ( <cfqueryparam value="#FORM.regionID#" cfsqltype="cf_sql_integer" list="yes"> )
            <cfif form.type EQ '0'>
                AND uar.usertype <= '4' 
            <cfelseif form.type EQ '1'>
                AND (uar.usertype >='5' AND uar.usertype <= '7' OR uar.usertype = '9')
            </cfif>
    		AND 
            	u.userid NOT IN (SELECT userid FROM smg_users_cbc)
        ORDER BY 
        	u.lastname, 
            u.firstname            
            
    </cfquery>
    
</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	


<cfoutput>

	<!--- Report Header Information --->
    <cfsavecontent variable="reportHeader">
    
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
            	<cfif FORM.type EQ '0'>
                	<th>Host Family Management - Active Users Authorization Not Received</th>
               	<cfelse>
                	<th>Host Family Management - Active Reps Authorization Not Received</th>
                </cfif>           
            </tr>
            <tr>
                <td class="center">
                	<!--- NEED TO FIX TOTAL DISPLAY FOR REPS --->
                	<cfif FORM.type EQ '0'>
                    	<strong>Total of users in this report:</strong> #qGetUsers.recordcount# <br />
                    </cfif>                    
                </td>
            </tr>
        </table>
    
    </cfsavecontent>
    
    <cfif NOT LEN(FORM.regionID)>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Region information. Please close this window and try again.</p>
                    <p><a href="javascript:window.close();" title="Close Window"><img src="../pics/close.gif" /></a></p>
                </td>
            </tr>      
        </table>
        <cfabort>
    </cfif>

</cfoutput>

<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=usersByRegion.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
    	<cfif FORM.type EQ '0'>
    		<tr><th colspan="3">Host Family Management - Users Authorization Not Received</th></tr>
       	<cfelse>
        	<tr><th colspan="3">Host Family Management - Reps Authorization Not Received</th></tr>
  		</cfif>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Name</td>
            <td>ID</td>
        </tr>
        <cfscript>
			vCurrentRow = 0;
		</cfscript>
        <cfoutput query="qGetUsers">
        	<cfif FORM.type EQ '0'>
				<cfscript>
                    // Set Row Color
                    if ( vCurrentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                </cfscript>
                <tr>
                    <td #vRowColor#>#qGetUsers.regionName#</td>
                    <td #vRowColor#>#qGetUsers.firstName# #qGetUsers.middleName# #qGetUsers.lastName#</td>
                    <td #vRowColor#>#qGetUsers.userID#</td>
                </tr>
                <cfscript>
                    vCurrentRow++;
                </cfscript>
            <cfelse>
            	<cfquery name="check_hosts" datasource="MySQL">
                    SELECT DISTINCT 
                        h.hostid, 
                        h.fatherssn, 
                        h.motherssn
                    FROM
                        smg_hosts h
                    INNER JOIN 
                        smg_hosts_cbc cbc ON h.hostid = cbc.hostid
                    WHERE 
                        cbc.cbc_type = 'father' AND (h.fatherssn = '#qGetUsers.ssn#' OR (h.fatherfirstname = '#qGetUsers.firstname#' AND h.familylastname = '#qGetUsers.lastname#'))
                        OR 
                        cbc.cbc_type = 'mother' AND (h.motherssn = '#qGetUsers.ssn#' OR (h.motherfirstname = '#qGetUsers.firstname#' AND h.familylastname = '#qGetUsers.lastname#'))
                </cfquery>
                <cfif check_hosts.recordcount EQ 0>
                	<cfscript>
						// Set Row Color
						if ( vCurrentRow MOD 2 ) {
							vRowColor = 'bgcolor="##E6E6E6"';
						} else {
							vRowColor = 'bgcolor="##FFFFFF"';
						}
					</cfscript>
					<tr>
						<td #vRowColor#>#qGetUsers.regionName#</td>
						<td #vRowColor#>#qGetUsers.firstName# #qGetUsers.middleName# #qGetUsers.lastName#</td>
						<td #vRowColor#>#qGetUsers.userID#</td>
					</tr>
					<cfscript>
						vCurrentRow++;
					</cfscript>
                </cfif>
           	</cfif>
        </cfoutput>
  	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetUsers.recordCount)>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr class="on">
                	<td class="subTitleCenter">No records found</td>
                </tr>      
            </table>
        	<cfabort>
        </cfif>
        
    </cfoutput>
	
    <!--- Loop Regions ---> 
    <cfloop list="#FORM.regionID#" index="currentRegionID">

        <cfquery name="qGetUsersByRegion" dbtype="query">
            SELECT DISTINCT
                *
            FROM
                qGetUsers
            WHERE
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">               
        </cfquery>
        
        <cfif qGetUsersByRegion.recordCount>
        
			<cfoutput>
            
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                    <tr>
                        <th class="left">
                            #qGetUsersByRegion.regionName#
                        </th>
                        <th class="right note">
                        	<!--- NEED TO FIX TOTAL DISPLAY FOR REPS --->
                			<cfif FORM.type EQ '0'>
                        		Total of #qGetUsersByRegion.recordCount# records
                           	</cfif>
                        </th>
                    </tr>      
                </table>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">    
                    <tr class="on">
                        <td class="subTitleLeft" width="35%">Name</td>
                    </tr>
                    
        	</cfoutput>
        
        </cfif>
        
        <cfscript>
			// Set Current Row
			vCurrentRow = 0;			
		</cfscript>
        
		<cfoutput query="qGetUsersByRegion">
        	<cfif FORM.type EQ '1'>
                <cfquery name="check_hosts" datasource="MySQL">
                    SELECT DISTINCT 
                        h.hostid, 
                        h.fatherssn, 
                        h.motherssn
                    FROM
                        smg_hosts h
                    INNER JOIN 
                        smg_hosts_cbc cbc ON h.hostid = cbc.hostid
                    WHERE 
                        cbc.cbc_type = 'father' AND (h.fatherssn = '#qGetUsersByRegion.ssn#' OR (h.fatherfirstname = '#qGetUsersByRegion.firstname#' AND h.familylastname = '#qGetUsersByRegion.lastname#'))
                        OR 
                        cbc.cbc_type = 'mother' AND (h.motherssn = '#qGetUsersByRegion.ssn#' OR (h.motherfirstname = '#qGetUsersByRegion.firstname#' AND h.familylastname = '#qGetUsersByRegion.lastname#'))
                </cfquery>
                <cfif check_hosts.recordcount EQ 0>
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>#qGetUsersByRegion.firstName# #qGetUsersByRegion.middleName# #qGetUsersByRegion.lastName# ###qGetUsersByRegion.userID#</td>
                    </tr>
                    <cfscript>
                        // Set Current Row
                        vCurrentRow ++;			
                    </cfscript>
                </cfif>
          	<cfelse>
            	<tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#qGetUsersByRegion.firstName# #qGetUsersByRegion.middleName# #qGetUsersByRegion.lastName# ###qGetUsersByRegion.userID#</td>
                </tr>
                <cfscript>
                    // Set Current Row
                    vCurrentRow ++;			
                </cfscript>
            </cfif>
                  
    	</cfoutput>
            
        </table>
        
	</cfloop>

</cfif>

<!--- Page Footer --->
<gui:pageFooter />	