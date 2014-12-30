<!--- ------------------------------------------------------------------------- ----
	
	File:		_welcomeFamilyByRegion.cfm
	Author:		James Griffiths
	Date:		April 20, 2012
	Desc:		Welcome Family By Region
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=welcomeFamilyByRegion
				
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
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.studentStatus" default="Active";
		param name="FORM.placementStatus" default="Placed";
		param name="FORM.dateFrom" default="";
		param name="FORM.dateTo" default="";
		param name="FORM.reportBy" default="placeRepID";
		param name="FORM.outputType" default="flashPaper";

		// Set Report Title To Keep Consistency
		vReportTitle = "Host Family Management - Welcome Host Family";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
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
    	
        <!--- No Errors Found --->
        <cfif NOT SESSION.formErrors.length()>

            <cfquery name="qGetResults" datasource="#APPLICATION.DSN#">
                SELECT 
                    s.studentID,
                    s.firstName,
                    s.familyLastName,
                    CAST(CONCAT(s.firstName, ' ', s.familyLastName,  ' ##', s.studentID) AS CHAR) AS studentName,
                    s.sex,
                    s.active,
                    s.cancelDate,
                    s.host_fam_approved,
                    s.datePlaced,
                    s.placement_notes,
                    sh.hostID,
                    sh.schoolID,
                    sh.placeRepID,
                    sh.areaRepID,
                    sh.isRelocation,
                    sh.isWelcomeFamily,
                    sh.datePlaced,
                    sh.isActive AS isActivePlacement,
                    <!--- Program --->
                    p.programName,
                    <!--- Region --->
                    r.regionID,
                    r.regionName,
                    <!--- Country --->
                    c.countryName,
                    <!--- Host Family --->            
                    h.familyLastName as hostFamilyLastName,
                    CONCAT(h.city, ' ', h.state) AS hostAddress,
                    h.city AS hostCity,
                    h.state AS hostState,
                    h.phone AS hostPhone,
                    <!--- School --->
                    ss.schoolName,
                    <!--- Facilitator --->
                    CONCAT(fac.firstName, ' ', fac.lastName) AS facilitatorName,
                    <!--- Placing / Supervising Representative --->
                    u.userID repID,
                    u.email as repEmail,
                    CONCAT(u.firstName, ' ', u.lastName) AS repName
                FROM 
                    smg_students s
                INNER JOIN
                    smg_programs p on p.programID = s.programID
                INNER JOIN
                    smg_regions r ON r.regionID = s.regionAssigned
                        AND	
                            r.regionID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
                INNER JOIN 
                    smg_countrylist c ON s.countryresident = countryid                
                LEFT OUTER JOIN	
                    smg_hosthistory sh ON sh.studentID = s.studentID
                        AND
                            isActive = <cfqueryparam cfsqltype="cf_sql_bit" value="1">   
                LEFT OUTER JOIN 
                    smg_hosts h ON h.hostID = sh.hostID
                LEFT OUTER JOIN 
                    smg_schools ss ON ss.schoolID = sh.schoolID
                LEFT OUTER JOIN 
                    smg_users fac ON r.regionFacilitator = fac.userID            
                LEFT OUTER JOIN 
                    smg_users u ON sh.#FORM.reportBy# = u.userID
                WHERE 
                    s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> ) 
                    AND
                        sh.isWelcomeFamily = '1'
                    AND
                        s.active = '1'
                    AND
                        s.hostid != '0'
                    AND
                        s.host_fam_approved < '5'
               	<!--- Regional Advisors --->
				<cfif LEN(vListOfAdvisorUsers)>
                	AND
                        (
                       		s.areaRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        OR
                     		s.placeRepID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#vListOfAdvisorUsers#" list="yes"> )
                        )
				</cfif> 
                ORDER BY   
                    regionName,          
                    studentName
            </cfquery>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=hostFamilyWelcomeByRegion" name="welcomeFamily" id="welcomeFamily" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">#vReportTitle#</th></tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Program: <span class="required">*</span></td>
                    <td>
                        <select name="programID" id="programID" class="xLargeField" multiple size="6" required>
                            <cfloop query="qGetProgramList"><option value="#qGetProgramList.programID#">#qGetProgramList.programName#</option></cfloop>
                        </select>
                    </td>
                </tr>
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
                        This report will list all of the current welcome families assigned to your region, listed by student.
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
   
    <!--- Output in Excel - Do not use GroupBy --->
    <cfif FORM.outputType EQ 'excel'>
        
        <!--- set content type --->
        <cfcontent type="application/msexcel">
        
        <!--- suggest default name for XLS file --->
        <cfheader name="Content-Disposition" value="attachment; filename=studentListByRegion.xls"> 
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
            <tr>
                <th colspan="10">#vReportTitle#</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Facilitator</td>
                <td>Student ID</td>
                <td>Student First Name</td>
                <td>Student Last Name</td>
                <td>Program</td>
                <td>Host Family</td>
                <td>Host Phone</td>
                <td>Date Placed</td>
                <td>Placement Notes</td>
            </tr>      
            
            <cfoutput query="qGetResults">
                
                <cfscript>
                    // Set Row Color
                    if ( qGetResults.currentRow MOD 2 ) {
                        vRowColor = 'bgcolor="##E6E6E6"';
                    } else {
                        vRowColor = 'bgcolor="##FFFFFF"';
                    }
                </cfscript>
            
                <tr>
                    <td #vRowColor#>#qGetResults.regionName#</td>
                    <td #vRowColor#>#qGetResults.facilitatorName#</td>
                    <td #vRowColor#>#qGetResults.studentID#</td>
                    <td #vRowColor#>#qGetResults.firstName#</td>
                    <td #vRowColor#>#qGetResults.familyLastName#</td>
                    <td #vRowColor#>#qGetResults.programName#</td>
                    <td #vRowColor#>
                        <cfif VAL(qGetResults.hostID)>
                            #qGetResults.hostFamilyLastName#
        
                            <span class="note">
                                (
                                    <cfif VAL(qGetResults.isActivePlacement)>
                                        Current
                                    <cfelse>
                                        Previous
                                    </cfif>
        
                                    <cfif VAL(qGetResults.isRelocation)>
                                        - Relocation
                                    </cfif>
                                )
                            </span>         
                        </cfif>                                         
                    </td>
                    <td #vRowColor#>#qGetResults.hostPhone#</td>
                    <td #vRowColor#>#DateFormat(datePlaced, 'mm/dd/yyyy')#</td>
                    <td #vRowColor#>#placement_notes#</td>	
                </tr>
                
            </cfoutput>
    
        </table>
    
    <!--- On Screen Report --->
    <cfelse>
    
    	<cfsavecontent variable="report">
    
			<cfoutput>
                
                <!--- Include Report Header --->   
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                    <tr>
                        <th>#vReportTitle#</th>            
                    </tr>
                    <tr>
                        <td class="center">
                            <strong>Program(s) included in this report: </strong> <br />
                            <cfloop query="qGetPrograms">
                                #qGetPrograms.programName# <br />
                            </cfloop>
                            <strong>Total of Students in this report:</strong> #qGetResults.recordcount# <br />
                            
                            <cfif FORM.placementStatus EQ 'Placed' AND ( isDate(FORM.dateFrom) OR isDate(FORM.dateTo) )>
                                <strong>Placed from</strong> #FORM.dateFrom# <strong>to</strong> #FORM.dateTo#
                            </cfif>
                        </td>
                    </tr>
                </table>
                
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
                    SELECT
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
                                    &nbsp; - &nbsp; 
                                    Facilitator - #qGetStudentsInRegion.facilitatorName#
                                </th>
                                <th class="right note">
                                    Total of #qGetStudentsInRegion.recordCount# records
                                </th>
                            </tr>      
                        </table>
                    
                    </cfoutput>
                
                </cfif>
                
                <cfoutput query="qGetStudentsInRegion" group="#FORM.reportBy#">
        
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">    
                        <tr class="on">
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Student</td>
                            <td class="subTitleLeft" width="10%" style="font-size:9px">Program</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Host Family</td>
                            <td class="subTitleLeft" width="8%" style="font-size:9px">HF Phone</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Date Placed</td>
                            <td class="subTitleLeft" width="15%" style="font-size:9px">Placement Notes</td>
                        </tr>      
                        
                        <cfscript>
                            // Set Current Row
                            vCurrentRow = 0;			
                        </cfscript>
                        
                        <!--- Loop Through Query --->
                        <cfoutput>
        
                            <cfscript>
                                // Set Current Row
                                vCurrentRow ++;			
                            </cfscript>
                            
                            <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                                <td style="font-size:9px">
                                    #qGetStudentsInRegion.studentName#
                                </td>
                                <td style="font-size:9px">#qGetStudentsInRegion.programName#</td>
                                <td style="font-size:9px">
                                    <cfif VAL(qGetStudentsInRegion.hostID)>
                                        #qGetStudentsInRegion.hostFamilyLastName# ###qGetStudentsInRegion.hostID#
                                        
                                        <span class="note">
                                            (
                                                <cfif VAL(qGetStudentsInRegion.isActivePlacement)>
                                                    Current
                                                <cfelse>
                                                    Previous
                                                </cfif>
            
                                                <cfif VAL(qGetStudentsInRegion.isRelocation)>
                                                    - Relocation
                                                </cfif>
                                                
                                            )
                                        </span> 
                                    </cfif>                                                         
                                </td>
                                <td style="font-size:9px">#qGetStudentsInRegion.hostPhone#</td>
                                <td style="font-size:9px">#DateFormat(datePlaced, 'mm/dd/yyyy')#</td>
                                <td align="left" style="font-size:9px">#placement_notes#</td>	
                            </tr>
            
                        </cfoutput>
                    
                    </table>
            
                </cfoutput>
        
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

	<!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    