<!--- ------------------------------------------------------------------------- ----
	
	File:		_helpCommunityService.cfm
	Author:		James Griffiths
	Date:		May 4, 2012
	Desc:		Help Community Service - report by hours
				
				#CGI.SCRIPT_NAME#?curdoc=report/index?action=helpCommunityService
				
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
		param name="FORM.activityStatus" default="";
		param name="FORM.studentStatus" default="";
		param name="FORM.noHours" default=0;		
		param name="FORM.minHours" default=0;
		param name="FORM.maxHours" default=21;
		param name="FORM.outputType" default="onScreen";

		// Get Programs
		qGetPrograms = APPLICATION.CFC.PROGRAM.getPrograms(programIDList=FORM.programID);
		
		// Get Students
		qGetStudents = APPCFC.STUDENT.getProjectHelpReport(
					userID=CLIENT.userID,					
					regionID=FORM.regionID,
					userType=CLIENT.userType,
					isActive=FORM.studentStatus,
					programID=FORM.programID,
					statusKey = FORM.activityStatus,
					noHours = FORM.noHours,
					minimumHours = FORM.minHours,
					maxHours = FORM.maxHours
				);
	</cfscript>	
    
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
                <th>Student Management - Help Community Service Hours</th>            
            </tr>
            <tr>
                <td class="center">
                    <strong>Program(s) included in this report: </strong> <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                </td>
            </tr>
            <tr>
            	<td class="center"><strong>Total of #qGetStudents.recordCount# students in this report</strong></td>
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
	<cfheader name="Content-Disposition" value="attachment; filename=helpCommunityServiceHours.xls"> 
    
    <table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
        <tr>
            <th colspan="5">Student Management - Help Community Service Hours</th>            
        </tr>
        <tr style="font-weight:bold;">
            <td>Region</td>
            <td>Area Representative</td>
            <td>Student</td>
            <td>Program</td>
            <td>Hours</td>
        </tr>      
		
		<cfoutput query="qGetStudents">
			
            <cfscript>
				// Set Row Color
				if ( qGetStudents.currentRow MOD 2 ) {
					vRowColor = 'bgcolor="##E6E6E6"';
				} else {
					vRowColor = 'bgcolor="##FFFFFF"';
				}
            </cfscript>
        
            <tr>
            	<td #vRowColor#>#qGetStudents.regionName#</td>
            	<td #vRowColor#>#qGetStudents.rep_firstName# #qGetStudents.rep_lastName# ###qGetStudents.areaRepID#</td>
                <td #vRowColor#>#qGetStudents.firstName# #qGetStudents.familyLastName# ###qGetStudents.studentID#</td>
                <td #vRowColor#>#qGetStudents.programName#</td>
                <td #vRowColor#>#qGetStudents.hours#</td>
            </tr>
            
    	</cfoutput>

	</table>

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
        
        <!--- Include Report Header --->   
		#reportHeader#
        
        <!--- No Records Found --->
        <cfif NOT VAL(qGetStudents.recordCount)>
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

        <cfquery name="qGetStudentsInRegion" dbtype="query">
            SELECT
                *
            FROM
                qGetStudents
            WHERE
                regionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#currentRegionID#">            
        </cfquery>
        
        <cfif qGetStudentsInRegion.recordCount>
        
			<cfoutput>
                
                <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable" <cfif ListGetAt(FORM.regionID, 1) NEQ currentRegionID>style="margin-top:30px;"</cfif>>
                    <tr>
                        <th class="left">#qGetStudentsInRegion.regionName# Region</th>
                        <th class="right note">Total of #qGetStudentsInRegion.recordCount# records</th>
                    </tr>      
                </table>
                
                 <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">      
                    <tr class="on">
                        <td class="subTitleLeft" width="30%">Area Representative</td>
                        <td class="subTitleLeft" width="30%">Student</td>
                        <td class="subTitleLeft" width="20%">Program</td>
                        <td class="subTitleLeft" width="20%">Hours</td>
                    </tr>
            
            </cfoutput>
        
        </cfif>
        
            <cfscript>
				// Set Current Row
				vCurrentRow = 0;			
			</cfscript>
        
       		<cfoutput query="qGetStudentsInRegion" group="rep_lastName">

                <!--- Loop Through Query --->
                <cfoutput>

					<cfscript>
                        // Set Current Row
                        vCurrentRow ++;			
                    </cfscript>
                    
                    <tr class="#iif(vCurrentRow MOD 2 ,DE("off") ,DE("on") )#">
                    	<td>#qGetStudentsInRegion.rep_firstName# #qGetStudentsInRegion.rep_lastName# ###qGetStudentsInRegion.areaRepID#</td>
                        <td>#qGetStudentsInRegion.firstName# #qGetStudentsInRegion.familyLastName# ###qGetStudentsInRegion.studentID#</td>
                        <td>#qGetStudentsInRegion.programName#</td>
                        <td>#qGetStudentsInRegion.hours#</td>
                    </tr>
    
                </cfoutput>
            
        	</cfoutput>
            
     	</table>

	</cfloop>

</cfif>

<!--- Page Header --->
<gui:pageFooter />	