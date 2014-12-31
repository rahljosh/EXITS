<!--- ------------------------------------------------------------------------- ----
	
	File:		_userRegionalHierarchy.cfm
	Author:		James Griffiths
	Date:		April 27, 2012
	Desc:		Hierarchy Report by Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=hierarchyReport
				
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
		param name="FORM.dateCreated" default="";
		param name="FORM.beginDate" default="";
		param name="FORM.endDate" default="";
		param name="FORM.includeViewOnly" default="";
		param name="FORM.includeStudents" default="";
		param name="FORM.sort" default="lastName";
		param name="FORM.outputType" default="flashPaper";
		
		// Get List of Users Under Advisor and the Advisor self
		vListOfAdvisorUsers = "";
		if ( CLIENT.usertype EQ 6 ) {
			
			// Get Available Reps
			qGetUserUnderAdv = APPLICATION.CFC.USER.getSupervisedUsers(userType=CLIENT.userType, userID=CLIENT.userID, regionIDList=FORM.regionID);
		   
			// Store Users under Advisor on a list
			vListOfAdvisorUsers = ValueList(qGetUserUnderAdv.userID);

		}
	</cfscript>	

    <!--- FORM Submitted --->
    <cfif VAL(FORM.submitted)>
		
        <cfscript>
			// Data Validation
			
            // Region
            if ( NOT VAL(FORM.regionID) ) {
                // Set Page Message
                SESSION.formErrors.Add("You must select at least one region");
            }
		</cfscript>

        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

			<!--- This query is used to get the total number of reps that will be displayed --->
            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT
                    u.userID
                FROM
                    smg_users u
                INNER JOIN
                    user_access_rights uar ON uar.userID = u.userID
                INNER JOIN
                    smg_regions r ON r.regionID = uar.regionID
                WHERE
                    uar.userType BETWEEN 5 AND 7
                    AND
                        r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                    AND
                        u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                  	<cfif FORM.dateCreated NEQ "">
                    	AND
                        	u.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateCreated#">
                    </cfif>
                    <cfif FORM.beginDate NEQ "">
                        AND
                            u.dateAccountVerified >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.beginDate#">
                     	AND
                        	u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    </cfif>
                    <cfif FORM.endDate NEQ "">
                        AND
                            u.dateAccountVerified <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,FORM.endDate)#">
                      	AND
                        	u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                    </cfif>
                    <!--- Regional Advisors --->
					<cfif CLIENT.userType EQ 6>
                        AND 
                            (
                                uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                            OR
                                u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                            )
                    </cfif>
                GROUP BY
                    u.userID
            </cfquery>
    
		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>


<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=userRegionalHierarchy" name="userRegionalHierarchy" id="userRegionalHierarchy" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Representative Management - Regional Hierarchy Report</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Region: <span class="required">*</span></td>
                    <td>
                        <select name="regionID" id="regionID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetRegionList">
                            	<option value="#qGetRegionList.regionID#">
                                	<cfif CLIENT.companyID EQ 5>#qGetRegionList.companyShort# -</cfif> 
                                    #qGetRegionList.regionname#
                                </option>
                            </cfloop>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Sort By: <span class="required">*</span></td>
                    <td>
                        <select name="order" id="order" class="xLargeField" required>
                            <option value="lastName" selected="selected">Last Name</option>
                            <option value="firstname">First Name</option>
                            <option value="userID">User ID</option>
                            <option value="phone">Phone</option>
                            <option value="fax">Fax</option>
                            <option value="email">Email</option>
                            <option value="city">City</option>
                            <option value="state">State</option>
                        </select>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Entered Date: </td> 
                    <td>
                        <input type="text" class="datePicker" name="dateCreated" id="dateCreated" /> <span class="note">(Account Created)</span>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Begin Date: </td> 
                    <td>
                        <input type="text" class="datePicker" name="beginDate" id="beginDate" /> <span class="note">(Account Creation Verified)</span>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">End Date: </td> 
                    <td>
                        <input type="text" class="datePicker" name="endDate" id="endDate" /> <span class="note">(Account Creation Verified)</span>
                    </td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Options:</td>
                    <td>
                    	<input type="checkbox" name="includeStudents" id="includeStudents" /> 
                    	<label for="includeStudents">Include Students</label>
                    </td>
                </tr>
                <!--- This option is not available for regional advisors --->
                <cfif CLIENT.userType NEQ 6>                                            
                    <tr class="on">
                        <td class="subTitleRightNoBorder">&nbsp;</td>
                        <td>
                            <input type="checkbox" name="includeViewOnly" id="includeViewOnly" /> 
                            <label for="includeViewOnly">Include Users With View Only Access</label> 
                        </td>
                    </tr>  
               	</cfif>                                           
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" class="xLargeField">
                        	<option value="flashPaper">FlashPaper</option>
                            <option value="onScreen">On Screen</option>
                            <option value="Excel">Excel Spreadsheet</option>
                        </select>
                    </td>		
                </tr>
                <tr class="on">
                    <td>&nbsp;</td>
                    <td class="required noteAlert">* Required Fields</td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Description:</td>
                    <td>
                        This report will create a list of all the reps assigned to your region and provide you with all their contact info, students assigned and date they began.
                    </td>		
                </tr>
                <tr>
                    <th colspan="2"><input type="image" src="pics/view.gif" align="center" border="0"></th>
                </tr>
            </table>
        </form>	

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
    
    <cfoutput>
    
        <!--- Report Header Information --->
        <cfsavecontent variable="reportHeader">
        
            <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Representative Management - Regional Hierarchy Report</th>            
                </tr>
                <tr>
                    <td class="center"><strong>Total Number of Reps in this report:</strong> #qGetResults.recordcount# <br /></td>
                </tr>
                <tr>
                    <td class="center"><strong>Sorted By:</strong> #FORM.order# <br /></td>
                </tr>
            </table>
        
        </cfsavecontent>
        
        <cfif NOT LEN(FORM.regionID)>
            
            <!--- Include Report Header --->
            #reportHeader#
            
            <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
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
        <cfheader name="Content-Disposition" value="attachment; filename=studentListByRegion.xls"> 
        
			<cfif FORM.includeStudents NEQ "on">
                <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
                    <tr><th colspan="10">Representative Management - Regional Hierarchy Report</th></tr>
                    <tr style="font-weight:bold;">
                        <td>Region</td>
                        <td>Facilitator</td>
                        <td>Director</td>
                        <td>Advisor</td>
                        <td>User Type</td>
                        <td>Name</td>
                        <td>Address</td>
                        <td>Email</td>
                        <td>Phone</td>
                        <td>Fax</td>
                    </tr>
            <cfelse>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
                    <tr><th colspan="12">Representative Management - Regional Hierarchy Report</th></tr>
                    <tr style="font-weight:bold;">
                        <td>Region</td>
                        <td>Facilitator</td>
                        <td>Director</td>
                        <td>Advisor</td>
                        <td>User Type</td>
                        <td>Name</td>
                        <td>Address</td>
                        <td>Email</td>
                        <td>Phone</td>
                        <td>Fax</td>
                        <td>Student</td>
                        <td>HostFamily</td>
                    </tr>
        	</cfif>
            
            <cfscript>
                vCurrentRow = 1;
            </cfscript>
            
            <cfloop list="#FORM.regionID#" index="currentRegionID">
            
                <cfscript>
                    // Get Regional Manager
                    qGetDirector = APPLICATION.CFC.USER.getRegionalManager(regionID=currentRegionID);
                    // Get Regional Facilitators
                    getFacilitators = APPLICATION.CFC.USER.getFacilitators();
                </cfscript>
                
                <cfquery name="qGetRegion" datasource="#APPLICATION.DSN#">
                    SELECT
                        regionName,
                        regionID,
                        regionFacilitator
                    FROM
                        smg_regions
                    WHERE
                        regionID = #currentRegionID#
                </cfquery>
                
                <cfquery name="qGetRepsByRegion" datasource="#APPLICATION.DSN#">
                    SELECT
                        u.userID,
                        u.firstName,
                        u.middleName,
                        u.lastName,
                        u.phone,
                        u.email,
                        u.fax,
                        uar.advisorID,
                        u.address,
                        u.address2,
                        u.city,
                        u.state,
                        u.zip,
                        t.userType
                    FROM
                        smg_users u
                    INNER JOIN
                        user_access_rights uar ON uar.userID = u.userID
                    INNER JOIN
                        smg_regions r ON r.regionID = uar.regionID
                    INNER JOIN
                        smg_usertype t ON t.userTypeID = uar.userType
                    WHERE
                        uar.userType BETWEEN 5 AND 7
                        AND
                            r.regionID = #currentRegionID#
                        AND
                            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                      	<cfif FORM.dateCreated NEQ "">
                            AND
                                u.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateCreated#">
                        </cfif>
                        <cfif FORM.beginDate NEQ "">
                            AND
                                u.dateAccountVerified >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.beginDate#">
                            AND
                                u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        </cfif>
                        <cfif FORM.endDate NEQ "">
                            AND
                                u.dateAccountVerified <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,FORM.endDate)#">
                            AND
                                u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        </cfif>
                    GROUP BY
                        u.userID
                    ORDER BY
                        #FORM.order#
                </cfquery>
                
                <cfquery name="qGetFacilitator" dbtype="query">
                    SELECT
                        *
                    FROM
                        getFacilitators
                    WHERE
                        userID = #qGetRegion.regionFacilitator#
                </cfquery>
                
                <cfquery name="qGetAdvisors" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        u.firstName,
                        u.middleName,
                        u.lastName,
                        u.userID
                    FROM
                        smg_users u
                    INNER JOIN
                        user_access_rights uar ON uar.userID = u.userID
                    WHERE
                        uar.regionid = #currentRegionID# 
                        AND 
                            uar.usertype = 6 
                        AND 
                            u.active = 1
                      	<cfif CLIENT.userType EQ 6>
                        	AND
                            	u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                      	</cfif>
                    GROUP BY
                        u.userID
                    ORDER BY
                        #FORM.order#
                </cfquery>
                
                <cfquery name="qGetRepsWithoutAdvisor" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetRepsByRegion
                    WHERE
                        qGetRepsByRegion.advisorID = 0
                        <cfif VAL(qGetDirector.userID)> 
                            AND
                                qGetRepsByRegion.userID != #qGetDirector.userID#
                        </cfif>
                        <!--- Don't return anything for a regional advisor --->
						<cfif CLIENT.userType EQ 6>
                            AND
                                0 = 1
                        </cfif>
                </cfquery>
                
                <cfoutput query="qGetRepsWithoutAdvisor">
                    <cfif FORM.includeStudents NEQ "on">
                    
                        <cfscript>
                            // Set Row Color
                            if ( vCurrentRow MOD 2 ) {
                                vRowColor = 'bgcolor="##E6E6E6"';
                            } else {
                                vRowColor = 'bgcolor="##FFFFFF"';
                            }
                        </cfscript>
                        
                        <tr>
                            <td #vRowColor#>#qGetRegion.regionName#</td>
                            <td #vRowColor#>#qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#</td>
                            <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                            <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.userType#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.firstName# #qGetRepsWithoutAdvisor.middleName# #qGetRepsWithoutAdvisor.lastName# ###qGetRepsWithoutAdvisor.userID#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.address# #qGetRepsWithoutAdvisor.address2# #qGetRepsWithoutAdvisor.city#<cfif VAL("#qGetRepsWithoutAdvisor.state#")>, </cfif> #qGetRepsWithoutAdvisor.state# #qGetRepsWithoutAdvisor.zip#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.email#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.phone#</td>
                            <td #vRowColor#>#qGetRepsWithoutAdvisor.fax#</td>
                        </tr>
                        
                        <cfscript>
                            vCurrentRow++;
                        </cfscript>
                    
                    <cfelse>
                                                            
                        <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
                            SELECT
                                s.firstName,
                                s.middleName,
                                s.familyLastName,
                                h.familyLastName AS hostFamily
                            FROM
                                smg_students s
                            INNER JOIN
                                smg_hosts h ON h.hostID = s.hostID
                            WHERE
                                s.areaRepID = "#qGetRepsWithoutAdvisor.userID#"
                            ORDER BY
                                s.familyLastName
                        </cfquery>
                        
                        <cfloop query="qGetStudents">
                        
                            <cfscript>
                                // Set Row Color
                                if ( vCurrentRow MOD 2 ) {
                                    vRowColor = 'bgcolor="##E6E6E6"';
                                } else {
                                    vRowColor = 'bgcolor="##FFFFFF"';
                                }
                            </cfscript>
                        
                            <tr>
                                <td #vRowColor#>#qGetRegion.regionName#</td>
                                <td #vRowColor#>#qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#</td>
                                <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.userType#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.firstName# #qGetRepsWithoutAdvisor.middleName# #qGetRepsWithoutAdvisor.lastName# ###qGetRepsWithoutAdvisor.userID#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.address# #qGetRepsWithoutAdvisor.address2# #qGetRepsWithoutAdvisor.city#<cfif VAL("#qGetRepsWithoutAdvisor.state#")>, </cfif> #qGetRepsWithoutAdvisor.state# #qGetRepsWithoutAdvisor.zip#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.email#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.phone#</td>
                                <td #vRowColor#>#qGetRepsWithoutAdvisor.fax#</td>
                                <td #vRowColor#>#qGetStudents.firstName# #qGetStudents.middleName# #qGetStudents.familyLastName#</td>
                                <td #vRowColor#>#qGetStudents.hostFamily#</td>
                            </tr>
                            
                            <cfscript>
                                vCurrentRow++;
                            </cfscript>
                            
                        </cfloop>
                                                                
                    </cfif>
                    
                </cfoutput>
                
                <cfoutput query="qGetAdvisors">
                
                    <cfquery name="qGetRepsUnderAdvisor" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetRepsByRegion
                        WHERE
                            qGetRepsByRegion.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAdvisors.userID#">
                    </cfquery>
                    
                    <cfloop query="qGetRepsUnderAdvisor">
                    
                        <cfif FORM.includeStudents NEQ "on">
                        
                            <cfscript>
                                // Set Row Color
                                if ( vCurrentRow MOD 2 ) {
                                    vRowColor = 'bgcolor="##E6E6E6"';
                                } else {
                                    vRowColor = 'bgcolor="##FFFFFF"';
                                }
                            </cfscript>
                        
                            <tr>
                                <td #vRowColor#>#qGetRegion.regionName#</td>
                                <td #vRowColor#>#qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#</td>
                                <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.userType#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.firstName# #qGetRepsUnderAdvisor.middleName# #qGetRepsUnderAdvisor.lastName# ###qGetRepsUnderAdvisor.userID#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.address# #qGetRepsUnderAdvisor.address2# #qGetRepsUnderAdvisor.city#<cfif VAL("#qGetRepsUnderAdvisor.state#")>, </cfif> #qGetRepsUnderAdvisor.state# #qGetRepsUnderAdvisor.zip#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.email#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.phone#</td>
                                <td #vRowColor#>#qGetRepsUnderAdvisor.fax#</td>
                            </tr>
                            
                            <cfscript>
                                vCurrentRow++;
                            </cfscript>
                            
                        <cfelse>
                            <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
                                SELECT
                                    s.firstName,
                                    s.middleName,
                                    s.familyLastName,
                                    h.familyLastName AS hostFamily
                                FROM
                                    smg_students s
                                INNER JOIN
                                    smg_hosts h ON h.hostID = s.hostID
                                WHERE
                                    s.areaRepID = "#qGetRepsWithoutAdvisor.userID#"
                                ORDER BY
                                    s.familyLastName
                            </cfquery>
                            
                            <cfloop query="qGetStudents">
                                                    
                                <cfscript>
                                    // Set Row Color
                                    if ( vCurrentRow MOD 2 ) {
                                        vRowColor = 'bgcolor="##E6E6E6"';
                                    } else {
                                        vRowColor = 'bgcolor="##FFFFFF"';
                                    }
                                </cfscript>
                            
                                <tr>
                                    <td #vRowColor#>#qGetRegion.regionName#</td>
                                    <td #vRowColor#>#qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#</td>
                                    <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                    <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.userType#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.firstName# #qGetRepsWithoutAdvisor.middleName# #qGetRepsWithoutAdvisor.lastName# ###qGetRepsWithoutAdvisor.userID#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.address# #qGetRepsWithoutAdvisor.address2# #qGetRepsWithoutAdvisor.city#<cfif VAL("#qGetRepsWithoutAdvisor.state#")>, </cfif> #qGetRepsWithoutAdvisor.state# #qGetRepsWithoutAdvisor.zip#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.email#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.phone#</td>
                                    <td #vRowColor#>#qGetRepsWithoutAdvisor.fax#</td>
                                    <td #vRowColor#>#qGetStudents.firstName# #qGetStudents.middleName# #qGetStudents.familyLastName#</td>
                                    <td #vRowColor#>#qGetStudents.hostFamily#</td>
                                </tr>
                                
                                <cfscript>
                                    vCurrentRow++;
                                </cfscript>
                                
                            </cfloop>
                        
                        </cfif>
                        
                    </cfloop>
                    
                </cfoutput>
                
                <!--- Include users that have view privileges in this region --->
                <cfif FORM.includeViewOnly EQ "on">
        
                    <cfquery name="qGetUsersWithView" datasource="#APPLICATION.DSN#">
                        SELECT
                            uar.userID, 
                            u.userID, 
                            u.firstName,
                            u.middleName,
                            u.lastName,
                            u.address,
                            u.address2,
                            u.city,
                            u.state,
                            u.zip,
                            u.phone,
                            u.fax,
                            u.email,
                            t.userType
                        FROM
                            user_access_rights uar
                        INNER JOIN
                            smg_usertype t ON t.userTypeID = uar.userType
                        RIGHT JOIN
                            smg_users u ON uar.userID = u.userID
                        WHERE
                            uar.usertype = 9
                            AND
                                uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">
                           	<!--- Don't return anything for a regional advisor --->
							<cfif CLIENT.userType EQ 6>
                            	AND
                                	0 = 1
                           	</cfif>
                    </cfquery>
            
                    <cfloop query="qGetUsersWithView">
                    
                        <cfscript>
                            // Set Row Color
                            if ( vCurrentRow MOD 2 ) {
                                vRowColor = 'bgcolor="##E6E6E6"';
                            } else {
                                vRowColor = 'bgcolor="##FFFFFF"';
                            }
                        </cfscript>
                        
                        <cfoutput>
                            <tr>
                                <td #vRowColor#>#qGetRegion.regionName#</td>
                                <td #vRowColor#>#qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#</td>
                                <td #vRowColor#>#qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</td>
                                <td #vRowColor#></td>
                                <td #vRowColor#>#qGetUsersWithView.userType#</td>
                                <td #vRowColor#>#qGetUsersWithView.firstName# #qGetUsersWithView.middleName# #qGetUsersWithView.lastName# ###qGetUsersWithView.userID#</td>
                                <td #vRowColor#>#qGetUsersWithView.address# #qGetUsersWithView.address2# #qGetUsersWithView.city#<cfif VAL("#qGetUsersWithView.state#")>, </cfif> #qGetUsersWithView.state# #qGetUsersWithView.zip#</td>
                                <td #vRowColor#>#qGetUsersWithView.email#</td>
                                <td #vRowColor#>#qGetUsersWithView.phone#</td>
                                <td #vRowColor#>#qGetUsersWithView.fax#</td>
                                <cfif FORM.includeStudents EQ "on">
                                    <td #vRowColor#></td>
                                    <td #vRowColor#></td>
                                </cfif>
                            </tr>
                        </cfoutput>
                        
                        <cfscript>
                            vCurrentRow++;
                        </cfscript>
                            
                    </cfloop>
                    
                </cfif>
                
            </cfloop>
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
                
                <!--- Include Report Header --->   
                #reportHeader#
                
                <!--- No Records Found --->
                <cfif NOT VAL(qGetResults.recordCount)>
                    <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr class="on">
                            <td class="subTitleCenter">No records found</td>
                        </tr>      
                    </table>
                    <cfabort>
                </cfif>
                <table>
                
            </cfoutput>
            
            <!--- Loop Regions ---> 
            <cfloop list="#FORM.regionID#" index="currentRegionID">
        
                <cfscript>
                    // Get Regional Manager
                    qGetDirector = APPLICATION.CFC.USER.getRegionalManager(regionID=currentRegionID);
                    // Get Regional Facilitators
                    getFacilitators = APPLICATION.CFC.USER.getFacilitators();
                </cfscript>
                
                <cfquery name="qGetRegion" datasource="#APPLICATION.DSN#">
                    SELECT
                        regionName,
                        regionID,
                        regionFacilitator
                    FROM
                        smg_regions
                    WHERE
                        regionID = #currentRegionID#
                </cfquery>
                
                <cfquery name="qGetRepsByRegion" datasource="#APPLICATION.DSN#">
                    SELECT
                        u.userID,
                        u.firstName,
                        u.middleName,
                        u.lastName,
                        u.phone,
                        u.email,
                        u.fax,
                        uar.advisorID,
                        u.address,
                        u.address2,
                        u.city,
                        u.state,
                        u.zip
                    FROM
                        smg_users u
                    INNER JOIN
                        user_access_rights uar ON uar.userID = u.userID
                    INNER JOIN
                        smg_regions r ON r.regionID = uar.regionID
                    WHERE
                        uar.userType BETWEEN 5 AND 7
                        AND
                            r.regionID = #currentRegionID#
                        AND
                            u.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                       	<cfif FORM.dateCreated NEQ "">
                            AND
                                u.dateCreated >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.dateCreated#">
                        </cfif>
                        <cfif FORM.beginDate NEQ "">
                            AND
                                u.dateAccountVerified >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.beginDate#">
                            AND
                                u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        </cfif>
                        <cfif FORM.endDate NEQ "">
                            AND
                                u.dateAccountVerified <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',1,FORM.endDate)#">
                            AND
                                u.accountCreationVerified >= <cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        </cfif>
                        <!--- Regional Advisors --->
                        <cfif CLIENT.userType EQ 6>
                            AND 
                                (
                                    uar.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
                                OR
                                    u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                                )
                        </cfif>
                    GROUP BY
                        u.userID
                    ORDER BY
                        #FORM.order#
                </cfquery>
                
                <cfquery name="qGetFacilitator" dbtype="query">
                    SELECT
                        *
                    FROM
                        getFacilitators
                    WHERE
                        userID = #qGetRegion.regionFacilitator#
                </cfquery>
                
                <cfquery name="qGetAdvisors" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        u.firstName,
                        u.middleName,
                        u.lastName,
                        u.userID
                    FROM
                        smg_users u
                    INNER JOIN
                        user_access_rights uar ON uar.userID = u.userID
                    WHERE
                        uar.regionid = #currentRegionID# 
                        AND 
                            uar.usertype = 6 
                        AND 
                            u.active = 1
                        <cfif CLIENT.userType EQ 6>
                            AND
                                u.userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
                        </cfif>
                    GROUP BY
                        u.userID
                    ORDER BY
                        #FORM.order#
                </cfquery>
                
                <cfoutput>
                
                    <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px"</cfif>>
                        <tr>
                            <th class="left" width="20%" style="font-size:10px">
                                #qGetRegion.regionName#
                            </th>
                            <th class="left" valign="top" width="15%" style="font-size:10px">
                                Facilitator: #qGetFacilitator.firstName# #qGetFacilitator.middleName# #qGetFacilitator.lastName#
                                <br />
                                #qGetFacilitator.address# #qGetFacilitator.address2# <br /> #qGetFacilitator.city# <cfif VAL(#qGetFacilitator.state#)>,</cfif> #qGetFacilitator.state# #qGetFacilitator.zip#
                            </th>
                            <th class="left" valign="top" width="15%" style="font-size:10px">
                                P: #qGetFacilitator.phone#
                                <br />
                                F: #qGetFacilitator.fax#
                                <br />
                                E: #qGetFacilitator.email#
                            </th>
                            <th class="left" valign="top" width="15%" style="font-size:10px">
                                Director: #qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#
                                <br />
                                #qGetDirector.address# #qGetDirector.address2# <br /> #qGetDirector.city# <cfif VAL(#qGetDirector.state#)>,</cfif> #qGetDirector.state# #qGetDirector.zip#
                            </th>
                            <th class="left" valign="top" width="15%" style="font-size:10px">
                                P: #qGetDirector.phone#
                                <br />
                                F: #qGetDirector.fax#
                                <br />
                                E: #qGetDirector.email#
                            </th>
                            <th class="right note" width="20%" style="font-size:10px">
                                Total of #qGetRepsByRegion.recordCount# records
                            </th>
                        </tr>      
                    </table>
                    <table width="95%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">    
                        <tr class="on">
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Representative</td>
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Address</td>
                            <td class="subTitleLeft" width="20%" style="font-size:9px">Email</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Phone</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Fax</td>
                        </tr>
                        
                </cfoutput>
                
                <cfscript>
                    // Set Current Row
                    vCurrentRow = 1;			
                </cfscript>
                
                <!--- Regional Advisors --->
                <cfif CLIENT.userType NEQ 6>
                
                    <cfquery name="qGetRepsWithoutAdvisor" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetRepsByRegion
                        WHERE
                            qGetRepsByRegion.advisorID = 0
                            <cfif VAL(qGetDirector.userID)> 
                                AND
                                    qGetRepsByRegion.userID != #qGetDirector.userID#
                            </cfif>
                    </cfquery>
                
                    <cfoutput>
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#"><td colspan="5" style="font-size:9px"><strong>Representatives Directly Under #qGetDirector.firstName# #qGetDirector.middleName# #qGetDirector.lastName#</strong></td></tr>
                    </cfoutput>
                
                    <!--- Display Reps directly under the manager --->
                    <cfif qGetRepsWithoutAdvisor.recordCount GT 0>
                    
                        <cfoutput query="qGetRepsWithoutAdvisor">
                        
                            <cfscript>
                                vCurrentRow++ ;			
                            </cfscript>
                            
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">&nbsp;&nbsp;#qGetRepsWithoutAdvisor.firstName# #qGetRepsWithoutAdvisor.middleName# #qGetRepsWithoutAdvisor.lastName# ###qGetRepsWithoutAdvisor.userID#</td>
                                <td style="font-size:9px">#qGetRepsWithoutAdvisor.address# #qGetRepsWithoutAdvisor.address2# #qGetRepsWithoutAdvisor.city#<cfif VAL("#qGetRepsWithoutAdvisor.state#")>, </cfif>#qGetRepsWithoutAdvisor.state# #qGetRepsWithoutAdvisor.zip#</td>
                                <td style="font-size:9px">#qGetRepsWithoutAdvisor.email#</td>
                                <td style="font-size:9px">#qGetRepsWithoutAdvisor.phone#</td>
                                <td style="font-size:9px">#qGetRepsWithoutAdvisor.fax#</td>
                            </tr>
                            
                            <!--- Show students under each rep --->
                            <cfif FORM.includeStudents EQ "on">
                            
                                <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
                                    SELECT
                                        s.firstName,
                                        s.middleName,
                                        s.familyLastName,
                                        h.familyLastName AS hostFamily
                                    FROM
                                        smg_students s
                                    INNER JOIN
                                        smg_hosts h ON h.hostID = s.hostID
                                    WHERE
                                        s.areaRepID = "#qGetRepsWithoutAdvisor.userID#"
                                    ORDER BY
                                        s.familyLastName
                                </cfquery>
                                
                                <cfif qGetStudents.recordCount>
                                
                                    <cfscript>
                                        vCurrentRow++ ;			
                                    </cfscript>
                                    
                                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                        <td style="font-size:9px"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Student Name</strong></td>
                                        <td style="font-size:9px"><strong>Student Host Family</strong></td>
                                        <td colspan="3" style="font-size:9px"></td>
                                    </tr>
                                    
                                </cfif>
                                
                                <cfloop query="qGetStudents">
                                
                                    <cfscript>
                                        vCurrentRow++ ;			
                                    </cfscript>
                                    
                                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                        <td style="font-size:9px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#qGetStudents.firstName# #qGetStudents.middleName# #qGetStudents.familyLastName#</td>
                                        <td colspan="4" style="font-size:9px">#qGetStudents.hostFamily#</td>
                                    </tr>
                                    
                                </cfloop>
                                
                            </cfif>
                            
                        </cfoutput>
                     
                    <!--- If there are no reps directly under the manager --->     
                    <cfelse>
                
                        <cfoutput>
                        
                            <cfscript>
                                vCurrentRow++ ;			
                            </cfscript>
                            
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#"><td colspan="5">&nbsp;&nbsp;No Representatives Under This Advisor</td></tr>
                            
                        </cfoutput>
                        
                    </cfif>
                    
                </cfif>
                
                <!--- Go through each advisor --->
                <cfoutput query="qGetAdvisors">
                
                    <cfscript>
                        vCurrentRow++;			
                    </cfscript>
                    
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#"><td colspan="5" style="font-size:9px"><strong>Regional Advisor: #qGetAdvisors.firstName# #qGetAdvisors.middleName# #qGetAdvisors.lastName#</strong></td></tr>
                    
                    <cfquery name="qGetRepsUnderAdvisor" dbtype="query">
                        SELECT
                            *
                        FROM
                            qGetRepsByRegion
                        WHERE
                            qGetRepsByRegion.advisorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetAdvisors.userID#">
                    </cfquery>
                    
                    <!--- Go through all of the reps under the current advisor --->
                    <cfif qGetRepsUnderAdvisor.recordCount GT 0>
                    
                        <cfloop query="qGetRepsUnderAdvisor">
                        
                            <cfscript>
                                vCurrentRow++ ;			
                            </cfscript>
                            
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">&nbsp;&nbsp;#qGetRepsUnderAdvisor.firstName# #qGetRepsUnderAdvisor.middleName# #qGetRepsUnderAdvisor.lastName# ###qGetRepsUnderAdvisor.userID#</td>
                                <td style="font-size:9px">#qGetRepsUnderAdvisor.address# #qGetRepsUnderAdvisor.address2# #qGetRepsUnderAdvisor.city#<cfif VAL("#qGetRepsUnderAdvisor.state#")>, </cfif>#qGetRepsUnderAdvisor.state# #qGetRepsUnderAdvisor.zip#</td>
                                <td style="font-size:9px">#qGetRepsUnderAdvisor.email#</td>
                                <td style="font-size:9px">#qGetRepsUnderAdvisor.phone#</td>
                                <td style="font-size:9px">#qGetRepsUnderAdvisor.fax#</td>
                            </tr>
                            
                            <!--- Show students under each rep --->
                            <cfif FORM.includeStudents EQ "on">
                                <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
                                    SELECT
                                        s.firstName,
                                        s.middleName,
                                        s.familyLastName,
                                        h.familyLastName AS hostFamily
                                    FROM
                                        smg_students s
                                    INNER JOIN
                                        smg_hosts h ON h.hostID = s.hostID
                                    WHERE
                                        s.areaRepID = "#qGetRepsUnderAdvisor.userID#"
                                    ORDER BY
                                        s.familyLastName
                                </cfquery>
                                
                                <cfif qGetStudents.recordCount>
                                
                                    <cfscript>
                                        vCurrentRow++ ;			
                                    </cfscript>
                                    
                                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                        <td style="font-size:9px"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Student Name</strong></td>
                                        <td style="font-size:9px"><strong>Student Host Family</strong></td>
                                        <td colspan="3" style="font-size:9px"></td>
                                    </tr>
                                    
                                </cfif>
                                
                                <cfloop query="qGetStudents">
                                
                                    <cfscript>
                                        vCurrentRow++ ;			
                                    </cfscript>
                                    
                                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                        <td style="font-size:9px">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#qGetStudents.firstName# #qGetStudents.middleName# #qGetStudents.familyLastName#</td>
                                        <td colspan="4" style="font-size:9px">#qGetStudents.hostFamily#</td>
                                    </tr>
                                    
                                </cfloop>
                                
                            </cfif>
                            
                        </cfloop>
                        
                    <cfelse>
                    
                        <cfscript>
                            vCurrentRow++ ;			
                        </cfscript>
                        
                        <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#"><td colspan="5" style="font-size:9px">&nbsp;&nbsp;No Representatives Under This Advisor</td></tr>
                        
                    </cfif>
                    
                </cfoutput>
                
                <!--- Include users that have view privileges in this region --->
                <cfif isDefined('FORM.includeViewOnly') AND CLIENT.userType NEQ 6>
                    
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#"><td colspan="5" style="font-size:9px"><strong>Users That Have View Privileges In This Region</strong></td></tr>
        
                    <cfquery name="qGetUsersWithView" datasource="#APPLICATION.DSN#">
                        SELECT
                            uar.userID, 
                            u.userID, 
                            u.firstName,
                            u.middleName,
                            u.lastName,
                            u.address,
                            u.address2,
                            u.city,
                            u.state,
                            u.zip,
                            u.phone,
                            u.fax,
                            u.email
                        FROM
                            user_access_rights uar 
                        RIGHT JOIN
                            smg_users u ON uar.userID = u.userID
                        WHERE
                            uar.usertype = 9
                            AND
                                uar.regionid = #currentRegionID#
                    </cfquery>
            
                    <cfloop query="qGetUsersWithView">
                    
                        <cfscript>
                            vCurrentRow++;			
                        </cfscript>
                        
                        <cfoutput>
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">&nbsp;&nbsp;#qGetUsersWithView.firstName# #qGetUsersWithView.middleName# #qGetUsersWithView.lastName# ###qGetUsersWithView.userID#</td>
                                <td style="font-size:9px">#qGetUsersWithView.address# #qGetUsersWithView.address2# #qGetUsersWithView.city#<cfif VAL("#qGetUsersWithView.state#")>, </cfif>#qGetUsersWithView.state# #qGetUsersWithView.zip#</td>
                                <td style="font-size:9px">#qGetUsersWithView.email#</td>
                                <td style="font-size:9px">#qGetUsersWithView.phone#</td>
                                <td style="font-size:9px">#qGetUsersWithView.fax#</td>
                            </tr>
                        </cfoutput> 
                            
                    </cfloop>
                    
                </cfif>
                    
                </table>
                
            </cfloop>
            
      	</cfsavecontent>
        
        <cfif FORM.outputType EQ "flashPaper">
    
   			<cfdocument format="flashpaper" orientation="landscape" backgroundvisible="yes" overwrite="yes" fontembed="yes" margintop="0.3" marginright="0.2" marginbottom="0.3" marginleft="0.2">
    
				<!--- Page Header --->
                <gui:pageHeader
                    headerType="applicationNoHeader"
                    filePath="../"
                />
                
                <cfoutput>#report#</cfoutput>
                
          	</cfdocument>
            
       	<cfelse>
        
        	<cfoutput>#report#</cfoutput>
            
        </cfif>
        
    </cfif>
    
    <!--- Page Footer --->
    <gui:pageFooter />	
    
</cfif>    