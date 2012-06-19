<!--- ------------------------------------------------------------------------- ----
	
	File:		_studentRelocationReport.cfm
	Author:		James Griffiths
	Date:		May 29, 2012
	Desc:		Student Relocation Report
	
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=studentRelocationReport

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../extensions/customTags/gui/" prefix="gui" />	
	
    <cfscript>	
		// Param FORM Variables
		param name="FORM.submitted" default=0;
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default="";
		param name="FORM.placedDateFrom" default="";
		param name="FORM.placedDateTo" default="";
		param name="FORM.outputType" default="onScreen";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegions(regionIDList=FORM.regionID);
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
                	hist.historyid,
                    s.studentID,
                    s.firstname, 
                    s.familylastname, 
                    s.regionassigned
                FROM 
                	smg_hosthistory hist
                INNER JOIN 
                	smg_students s ON s.studentid = hist.studentid
                WHERE 
                	s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="1"> 
              	AND 
                	hist.isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
             	AND 
                	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
                AND
                	s.regionAssigned IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionID#" list="yes"> )
            	<cfif FORM.placedDateFrom NEQ "">
                	AND
                    	s.datePlaced >= <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.placedDateFrom#">
               	</cfif>
                <cfif FORM.placedDateTo NEQ "">
                	AND
                    	s.datePlaced < <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.placedDateTo#">
               	</cfif>		
                GROUP BY 
                	s.studentid 
                ORDER BY
                	s.familyLastName
            </cfquery>

		</cfif> <!--- NOT SESSION.formErrors.length() ---->

	</cfif> <!--- FORM Submitted --->
    
</cfsilent>

<!--- FORM NOT submitted --->
<cfif NOT VAL(FORM.Submitted)>

    <!--- Call the basescript again so it works when ajax loads this page --->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->

	<cfoutput>

        <form action="report/index.cfm?action=studentRelocationReport" name="studentRelocationReport" id="studentRelocationReport" method="post" target="blank">
            <input type="hidden" name="submitted" value="1" />
            <table width="50%" cellpadding="4" cellspacing="0" class="blueThemeReportTable" align="center">
                <tr><th colspan="2">Student Management - Placement Relocation</th></tr>
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
                    <td class="subTitleRightNoBorder">Placed From:</td>
                    <td><input type="text" name="placedDateFrom" id="placedDateFrom" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>
                <tr class="on">
                    <td class="subTitleRightNoBorder">Placed To: </td>
                    <td><input type="text" name="placedDateTo" id="placedDateTo" value="" size="7" maxlength="10" class="datePicker"> <span class="note">mm-dd-yyyy</span></td>
                </tr>                                    
                <tr class="on">
                    <td class="subTitleRightNoBorder">Output Type: <span class="required">*</span></td>
                    <td>
                        <select name="outputType" id="outputType" class="xLargeField">
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
                        This report will provide you with a list, by student, of any relocation information. 
                    </td>		
                </tr>
                <tr>
                    <th colspan="2" align="center"><input type="image" src="pics/view.gif" align="center" border="0"> </th>
                </tr>
            </table>
        </form>            

	</cfoutput>

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
        <cfheader name="Content-Disposition" value="attachment; filename=student_relocation_report.xls">
        
        <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
      		<tr>
                <th colspan="5">Student Management - Student Relocation Report</th>            
            </tr>
            <tr style="font-weight:bold;">
                <td>Region</td>
                <td>Student</td>
                <td>Host Family</td>
                <td>Date Of Change</td>
                <td>Reason</td>
            </tr>
            
            <cfscript>
				vCurrentRow = 0;
			</cfscript>
       		
            <!--- Loop Regions ---> 
        	<cfloop query="qGetRegions">
    
                <cfquery name="qGetStudentsInRegion" dbtype="query">
                    SELECT
                        *
                    FROM
                        qGetResults
                    WHERE
                        regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">               
                </cfquery>
                
                <cfoutput query="qGetStudentsInRegion">
                
                	<cfscript>
						vCurrentRow++;
						if ( vCurrentRow MOD 2 ) {
							vRowColor = 'bgcolor="##E6E6E6"';
						} else {
							vRowColor = 'bgcolor="##FFFFFF"';
						}
					</cfscript>
                    
                    <cfquery name="qGetPrevHF" datasource="#APPLICATION.DSN#">
                    	SELECT 
                        	hist.hostid, 
                            hist.reason, 
                            hist.dateofchange, 
                            h.familylastname,
							u.firstname, 
                            u.lastname, 
                            u.userid
						FROM 
                        	smg_hosthistory hist
                        LEFT JOIN 
                        	smg_hosts h ON hist.hostid = h.hostid
                        LEFT JOIN 
                        	smg_users u ON hist.changedby = u.userid
						WHERE 
                        	hist.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
						AND 
                        	isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						ORDER BY 
                        	hist.dateofchange DESC, 
                            hist.historyid DESC
                    </cfquery>
                    
                    <cfquery name="qGetCurrentHF" datasource="#APPLICATION.DSN#">
                 		SELECT 
                            h.familylastname,
                            s.hostid
						FROM 
                        	smg_students s
						LEFT JOIN 
                        	smg_hosts h ON s.hostid = h.hostid
						WHERE 
                        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
                    </cfquery>
                    
                    <cfloop query="qGetPrevHF">
                    	<tr>
                        	<td #vRowColor#>#qGetRegions.regionName#</td>
                            <td #vRowColor#>#qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# (###qGetStudentsInRegion.studentID#)</td>
                            <td #vRowColor#>Previous: #qGetPrevHF.familyLastName#</td>
                            <td #vRowColor#>#DateFormat(qGetPrevHF.dateOfChange, "mm/dd/yyyy")# By #qGetPrevHF.firstName# #qGetPrevHF.lastName# (###qGetPrevHF.userID#)</td>
                            <td #vRowColor#>#qGetPrevHF.reason#</td>
                        </tr>
                    </cfloop>
                    
                    <tr>
                    	<td #vRowColor#>#qGetRegions.regionName#</td>
                  		<td #vRowColor#>#qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# (###qGetStudentsInRegion.studentID#)</td>
                        <td #vRowColor#>Current: #qGetCurrentHF.familyLastName#</td>
                        <td #vRowColor#></td>
               			<td #vRowColor#></td>
                  	</tr>
                    
                </cfoutput>
    
        	</cfloop>
            
     	</table>
           
    <!--- On Screen Report --->
    <cfelse>
    
        <cfoutput>
        
			<!--- Run Report --->
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th>Student Management - Relocation</th>            
                </tr>
                <tr>
                    <td class="center">
                        Program(s) included in this report: <br />
                        <cfloop query="qGetPrograms">
                            #qGetPrograms.programName# <br />
                        </cfloop>
                        
                        <cfif isDate(FORM.placedDateFrom) AND isDate(FORM.placedDateTo)>
                            Placed From #FORM.placedDateFrom# to #FORM.placedDateTo# <br />
                        </cfif>
                    </td>
                </tr>
            </table><br />
            
        </cfoutput>
                
		<!--- Loop Regions ---> 
        <cfloop query="qGetRegions">
        
			<cfscript>
                // Get Regional Manager
               	qGetRegionalManager = APPLICATION.CFC.USER.getRegionalManager(regionID=qGetRegions.regionID);
            </cfscript>
    
            <cfquery name="qGetStudentsInRegion" dbtype="query">
                SELECT
                    *
                FROM
                    qGetResults
                WHERE
                    regionAssigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetRegions.regionID#">               
            </cfquery>
            
            <!--- Only display if there are records in this region --->
            <cfif VAL(qGetStudentsInRegion.recordCount)>
            
				<cfoutput>
                    <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                        <tr>
                            <th class="left" colspan="3">#qGetRegions.regionName# Region - #qGetRegionalManager.firstName# #qGetRegionalManager.lastName# (###qGetRegionalManager.userID#)</th>
                            <th class="right">#qGetStudentsInRegion.recordCount#</th>
                        </tr>      
                        <tr class="on">
                            <td class="subTitleLeft" width="20%">Student</td>
                            <td class="subTitleLeft" width="20%">Host Family</td>
                            <td class="subTitleLeft" width="20%">Date Of Change</td>
                            <td class="subTitleLeft" width="40%">Reason</td>
                        </tr>  
                </cfoutput>
                
                <cfscript>
					// Set Current Row
					vCurrentRow = 0;			
				</cfscript>
                
                <cfoutput query="qGetStudentsInRegion">      
                        
					<cfscript>
						vCurrentRow++;
					</cfscript>
                    
                    <cfquery name="qGetPrevHF" datasource="#APPLICATION.DSN#">
                    	SELECT 
                        	hist.hostid, 
                            hist.reason, 
                            hist.dateofchange, 
                            h.familylastname,
							u.firstname, 
                            u.lastname, 
                            u.userid
						FROM 
                        	smg_hosthistory hist
                        LEFT JOIN 
                        	smg_hosts h ON hist.hostid = h.hostid
                        LEFT JOIN 
                        	smg_users u ON hist.changedby = u.userid
						WHERE 
                        	hist.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
						AND 
                        	isRelocation = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
						ORDER BY 
                        	hist.dateofchange DESC, 
                            hist.historyid DESC
                    </cfquery>
                    
                    <cfquery name="qGetCurrentHF" datasource="#APPLICATION.DSN#">
                 		SELECT 
                            h.familylastname,
                            s.hostid
						FROM 
                        	smg_students s
						LEFT JOIN 
                        	smg_hosts h ON s.hostid = h.hostid
						WHERE 
                        	s.studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentsInRegion.studentid#">
                    </cfquery>
                        
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                        <td>#qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# (###qGetStudentsInRegion.studentID#)</td>
                        <td colspan="3">
                        	<table width="100%">
                            	<cfscript>
									i = 0;
								</cfscript>
								<cfloop query="qGetPrevHF">
									<cfscript>
										i++;
									</cfscript>
                                    <tr>
                                    	<td width="25%">
											PREVIOUS #i#: #qGetPrevHF.familyLastName#
                                       	</td>
                                        <td width="25%">
                                        	#DateFormat(qGetPrevHF.dateOfChange, "mm/dd/yyyy")# By #qGetPrevHF.firstName# #qGetPrevHF.lastName# (###qGetPrevHF.userID#)
                                        </td>
                                        <td width="50%">
                                        	#qGetPrevHF.reason#
                                  		</td>
                                   	</tr> 
								</cfloop>
                                <tr>
                                	<td colspan="3">
                                    	<cfif VAL(qGetCurrentHF.recordCount)>
                                            CURRENT: #qGetCurrentHF.familyLastName#
                                        <cfelse>
                                            CURRENT: THIS STUDENT IS CURRENTLY UNPLACED
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                       	</td>
                    </tr>
            
                </cfoutput>
                
                <cfoutput>
                	</table>
              	</cfoutput>
                
          	</cfif>
    
        </cfloop>
    
    </cfif>
    
    <!--- Page Header --->
    <gui:pageFooter />	
    
</cfif>    