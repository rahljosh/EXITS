<!--- ------------------------------------------------------------------------- ----
	
	File:		_userCBCAuthorization.cfm
	Author:		James Griffiths
	Date:		April 25, 2012
	Desc:		Users CBC Authorization
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=userCBCAuthorization
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables	
		param name="FORM.submitted" default=0;
		param name="FORM.regionID" default=0;
		param name="FORM.type" default=0;
	</cfscript>	

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
			
            // Program
            if ( NOT VAL(FORM.programID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one program");
            }

            // Region
            if ( NOT VAL(FORM.regionID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one region");
            }
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
                u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
            AND 
                uar.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            AND 
                uar.regionid IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
            
            <cfif form.type EQ 0>
                AND
                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4" list="yes"> ) 
            <cfelseif form.type EQ 1>
                AND 
                    uar.usertype IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="5,6,7,9" list="yes"> ) 
            </cfif>
            
            AND 
                u.userid NOT IN ( SELECT userid FROM smg_users_cbc )
            ORDER BY 
                u.lastname, 
                u.firstname            
        </cfquery>
    
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

	<cfoutput>


	</cfoutput>

<!--- FORM Submitted --->
<cfelse>

	<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
    />	

    <!--- FORM Submitted with errors --->
    <cfif SESSION.formErrors.length()> 
       
        <!--- Form Errors --->
        <gui:displayFormErrors 
            formErrors="#SESSION.formErrors.GetCollection()#"
            messageType="tableSection"
            width="100%"
            />	
            
		<cfabort>            
	</cfif>
    
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
                        <cfif FORM.type EQ 0>
                            <strong>Total of users in this report:</strong> #qGetUsers.recordcount# <br />
                        </cfif>                    
                    </td>
                </tr>
            </table>
            
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
    
</cfif>        