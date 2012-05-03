<!--- ------------------------------------------------------------------------- ----
	
	File:		_hostFamilyCBCAuthorizationNotReceived.cfm
	Author:		James Griffiths
	Date:		April 20, 2012
	Desc:		Hosts Authorization Not Received
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=hostsAuthorizationNorReceived
				
	Updated: 				
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <cfsetting requesttimeout="9999">
    
	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.type" default=0;

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
	</cfscript>	

    <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
        SELECT DISTINCT
        	<!--- Student --->
        	CAST(CONCAT(s.firstName, ' ', s.familyLastName, ' ##', s.studentID) AS CHAR) AS studentName,
            s.active,
            s.cancelDate,
            s.host_fam_approved,
            s.datePlaced,
            s.placement_notes,
            s.isWelcomeFamily,
            s.active AS isActivePlacement,
            <!--- Program --->
            p.programID,
            p.programName,
            <!--- Region --->
            r.regionID,
            r.regionName,
            <!--- Host Family --->            
            h.familyLastName as hostFamilyLastName,
            h.phone AS hostPhone,
            h.fatherFirstName as hostFatherName,
            h.motherFirstName as hostMotherName,
            h.hostID,
            <!--- Host Children (if selected) --->
            <cfif #FORM.type# EQ 1>
            	c.name,
                c.birthdate,
            </cfif>
            <!--- Placement Rep --->
            CAST(CONCAT(u.firstName, ' ', u.lastName, ' ##', u.userID) AS CHAR) AS placementRepName
        FROM 
            smg_students s
        INNER JOIN
            smg_programs p on p.programID = s.programID
        INNER JOIN
            smg_regions r ON r.regionID = s.regionAssigned
       	INNER JOIN
        	smg_users u ON u.userID = s.placerepid
       	INNER JOIN
        	smg_hosts h ON h.hostID = s.hostID
       	<cfif #FORM.type# EQ 1>
        	INNER JOIN
            	smg_host_children c ON c.hostID = s.hostID
        <cfelse>
       		LEFT JOIN 
            	smg_hosts_cbc cbc ON cbc.hostID = h.hostID
        </cfif>
        WHERE 
            	s.active = '1'
         	AND
            	h.active = '1'
           	AND
            	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
            AND
            	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
           	AND
            	r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
          	<cfif #FORM.type# EQ 1>
            	AND
                	c.liveathome = 'yes'
                AND 
                	c.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
				AND 
                	(DATEDIFF(now(), c.birthdate)/365) > 18
              	AND
                	c.cbc_form_received IS NULL
            	AND 
                	c.childid NOT IN (SELECT familyid FROM smg_hosts_cbc WHERE cbc_type = 'member')
           	<cfelse>
            	AND
            		cbc.hostID IS NULL
               	AND 
                	( h.hostid NOT IN (SELECT hostid FROM smg_hosts_cbc WHERE cbc_type = 'father') OR h.hostid NOT IN (SELECT hostid FROM smg_hosts_cbc WHERE cbc_type = 'mother') )
            </cfif>
        GROUP BY
        	studentName
        ORDER BY   
		    regionName,          
          	studentName
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
                <th>Host Family Management - Hosts Authorization Not Received</th>            
            </tr>
            <tr>
                <td class="center">
                    <strong>Program(s) included in this report: </strong> <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                    <strong>Total of Students in this report:</strong> #qGetResults.recordcount# <br />
                    
                </td>
            </tr>
        </table>
    
    </cfsavecontent>
    
    <cfif NOT LEN(FORM.programID) OR NOT LEN(FORM.regionID)>
        
        <!--- Include Report Header --->
        #reportHeader#
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr class="on">
                <td class="subTitleCenter">
                    <p>You must select Program and Region information. Please close this window and try again.</p>
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
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
    	<cfif #FORM.type# EQ 0>
    		<tr><th colspan="9">Host Family Management - Hosts Authorization Not Received</th></tr>
       	<cfelse>
        	<tr><th colspan="8">Host Family Management - Host Children Authorization Not Received</th></tr>
  		</cfif>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Student</td>
            <td>Program</td>
            <td>Host Family</td>
            <td>HF Phone</td>
            <td>Date Placed</td>
            <cfif #FORM.type# EQ 0>
                <td>Host Father CBC</td>
                <td>Host Mother CBC</td>
            <cfelse>
                <td>Host Children</td>
            </cfif>
            <td>Placing Rep.</td>
        </tr>
        <cfscript>
			vCurrentRow = 0;
		</cfscript>
        <cfoutput query="qGetResults">
            <cfif #FORM.type# EQ 0>
            	<cfscript>
					// Set Row Color
					if ( vCurrentRow MOD 2 ) {
						vRowColor = 'bgcolor="##E6E6E6"';
					} else {
						vRowColor = 'bgcolor="##FFFFFF"';
					}
				</cfscript>
                <tr>
                    <td #vRowColor#>#qGetResults.regionName#</td>
                    <td #vRowColor#>#qGetResults.studentName#</td>
                    <td #vRowColor#>#qGetResults.programName#</td>
                    <td #vRowColor#>#qGetResults.hostFamilyLastName# ###qGetResults.hostID#</td>
                    <td #vRowColor#>#qGetResults.hostPhone#</td>
                    <td #vRowColor#>#DateFormat(datePlaced, 'mm/dd/yyyy')#</td>                
                    <td #vRowColor#><cfif #qGetResults.hostFatherName# NEQ "">#qGetResults.hostFatherName# #qGetResults.hostFamilyLastName#</cfif></td>
                    <td #vRowColor#><cfif #qGetResults.hostMotherName# NEQ "">#qGetResults.hostMotherName# #qGetResults.hostFamilyLastName#</cfif></td>
                    <td #vRowColor#>#qGetResults.placementRepName#</td>	
                </tr>
                <cfscript>
					vCurrentRow++;
				</cfscript>
           	<cfelse>
            	<cfquery name="qGetChildren" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        CONCAT(c.name, ' ', c.middleName, ' ', c.lastName) AS childName,
                        c.birthdate AS childBirthDate
                    FROM
                        smg_host_children c
                    WHERE
                        c.hostID = #hostID#
                        AND                                            
                            c.liveathome = 'yes'
                        AND 
                            c.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        AND 
                            (DATEDIFF(now(), c.birthdate)/365) > 18
                        AND
                            c.cbc_form_received IS NULL
                        AND 
                            c.childid NOT IN (SELECT familyid FROM smg_hosts_cbc WHERE cbc_type = 'member')
                </cfquery>
                <cfloop query="qGetChildren">
                	<cfscript>
						// Set Row Color
						if ( vCurrentRow MOD 2 ) {
							vRowColor = 'bgcolor="##E6E6E6"';
						} else {
							vRowColor = 'bgcolor="##FFFFFF"';
						}
					</cfscript>
                    <tr>
                        <td #vRowColor#>#qGetResults.regionName#</td>
                        <td #vRowColor#>#qGetResults.studentName#</td>
                        <td #vRowColor#>#qGetResults.programName#</td>
                        <td #vRowColor#>#qGetResults.hostFamilyLastName# ###qGetResults.hostID#</td>
                        <td #vRowColor#>#qGetResults.hostPhone#</td>
                        <td #vRowColor#>#DateFormat(qGetResults.datePlaced, 'mm/dd/yyyy')#</td>                
                        <td #vRowColor#>#childName# - #DateDiff('yyyy', childBirthDate, now())# years old</td>
                        <td #vRowColor#>#qGetResults.placementRepName#</td>	
                    </tr>
                    <cfscript>
						vCurrentRow++;
					</cfscript>
                </cfloop>
            </cfif>
        </cfoutput>
  	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetResults.recordCount)>
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

		<cfscript>
            // Get Regional Manager
            qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=currentRegionID);
        </cfscript>

        <cfquery name="qGetStudentsInRegion" dbtype="query">
            SELECT DISTINCT
                *
            FROM
                qGetResults
            WHERE
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">               
        </cfquery>
        
        <cfif qGetStudentsInRegion.recordCount>
        
			<cfoutput>
            
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                    <tr>
                        <th class="left">
                            #qGetStudentsInRegion.regionName#
                        </th>
                        <th class="right note">
                        	Total of #qGetStudentsInRegion.recordCount# records
                        </th>
                    </tr>      
                </table>
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">    
                    <tr class="on">
                        <td class="subTitleLeft" width="15%">Student</td>
                        <td class="subTitleLeft" width="10%">Program</td>
                        <td class="subTitleLeft" width="15%">Host Family</td>
                        <td class="subTitleLeft" width="8%">HF Phone</td>
                        <td class="subTitleLeft" width="7%">Date Placed</td>
                        <cfif #FORM.type# EQ 0>
                            <td class="subTitleLeft" width="15%">Host Father CBC</td>
                            <td class="subTitleLeft" width="15%">Host Mother CBC</td>
                        <cfelse>
                            <td class="subTitleLeft" width="30%">Host Children</td>
                        </cfif>
                        <td class="subTitleLeft" width="20%">Placing Rep.</td>
                    </tr>
                    
        	</cfoutput>
        
        </cfif>
        
        <cfscript>
			// Set Current Row
			vCurrentRow = 0;			
		</cfscript>
        
		<cfoutput query="qGetStudentsInRegion">
           
            <cfif #FORM.type# EQ 0>
            	<tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                <td>#qGetStudentsInRegion.studentName#</td>
                <td>#qGetStudentsInRegion.programName#</td>
                <td><cfif VAL(qGetStudentsInRegion.hostID)> #qGetStudentsInRegion.hostFamilyLastName# ###qGetStudentsInRegion.hostID# </cfif></td>
                <td>#qGetStudentsInRegion.hostPhone#</td>
               	<td>#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yyyy')#</td>
                <td><cfif #hostFatherName# NEQ "">#hostFatherName# #hostFamilyLastName#</cfif></td>
            	<td><cfif #hostMotherName# NEQ "">#hostMotherName# #hostFamilyLastName#</cfif></td>
                <td>#qGetStudentsInRegion.placementRepName#</td>
                </tr>
                <cfscript>
					// Set Current Row
					vCurrentRow ++;			
				</cfscript>
            <cfelse>
            	<cfquery name="qGetChildren" datasource="#APPLICATION.DSN#">
                    SELECT DISTINCT
                        CONCAT(c.name, ' ', c.middleName, ' ', c.lastName) AS childName,
                        c.birthdate AS childBirthDate
                    FROM
                        smg_host_children c
                    WHERE
                        c.hostID = #hostID#
                        AND                                            
                            c.liveathome = 'yes'
                        AND 
                            c.isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
                        AND 
                            (DATEDIFF(now(), c.birthdate)/365) > 18
                        AND
                            c.cbc_form_received IS NULL
                        AND 
                            c.childid NOT IN (SELECT familyid FROM smg_hosts_cbc WHERE cbc_type = 'member')
                </cfquery>
                <cfloop query="qGetChildren">
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    <td>#qGetStudentsInRegion.studentName#</td>
                    <td>#qGetStudentsInRegion.programName#</td>
                    <td><cfif VAL(qGetStudentsInRegion.hostID)> #qGetStudentsInRegion.hostFamilyLastName# ###qGetStudentsInRegion.hostID# </cfif></td>
                    <td>#qGetStudentsInRegion.hostPhone#</td>
                    <td>#DateFormat(qGetStudentsInRegion.datePlaced, 'mm/dd/yyyy')#</td>
                    <td>#childName# - #DateDiff('yyyy', childBirthDate, now())# years old</td>                
                    <td>#qGetStudentsInRegion.placementRepName#</td>
                    </tr>
                    <cfscript>
						// Set Current Row
						vCurrentRow ++;			
					</cfscript>
                </cfloop>
            </cfif>
                        
    	</cfoutput>
            
        </table>
        
	</cfloop>

</cfif>

<!--- Page Footer --->
<gui:pageFooter />	