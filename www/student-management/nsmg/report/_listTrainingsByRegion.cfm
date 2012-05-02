<!--- ------------------------------------------------------------------------- ----
	
	File:		_listTrainingsByRegion.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		List Trainings By Region

	Updated:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables
		param name="FORM.programID" default=0;	
		param name="FORM.regionID" default=0;
		param name="FORM.trainingID" default=0;
		param name="FORM.outputType" default="onScreen";
		
		// Get Regions
      	qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);
		
		// Programs
		qGetProgramsListIn = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
	</cfscript>
    
    <cfquery name="qGetPrograms" dbtype="query">
    	SELECT 
        	*
        FROM 
        	qGetProgramsListIn
        WHERE
        	qGetProgramsListIn.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#" list="yes"> )
    </cfquery>
    
    <!--- This gets the total number of representatives that will be displayed --->
    <cfscript>
		vTotalReps = 0;
	</cfscript>
    <cfloop query="qGetRegions">
    	<cfscript>
    		qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
		</cfscript>
        <cfquery name="qTotal" dbtype="query">
        	SELECT DISTINCT
            	userID
           	FROM
            	qGetResults
        </cfquery>
     	<cfscript>
			vTotalReps += qTotal.RecordCount;
        </cfscript>
    </cfloop>
    
</cfsilent>    

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	


<!--- Output in Excel - Do not use GroupBy --->
<cfif FORM.outputType EQ 'excel'>
	
	<!--- set content type --->
	<cfcontent type="application/msexcel">
	
	<!--- suggest default name for XLS file --->
	<cfheader name="Content-Disposition" value="attachment; filename=TrainingReport.xls"> 
	
	<table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
		<tr>
          	<th colspan="3">Training Report</th>            
       	</tr>
      	<tr style="font-weight:bold;">
            <td>Region</td>
            <td>Representative</td>
            <td>Training</td>
       	</tr>
        
        <cfscript>
			vCurrentRow = 1;
        </cfscript>
                
        <cfloop query="qGetRegions">
        
        	<cfscript>
				qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
			</cfscript>
			
			<cfoutput query="qGetResults">
            	
                <cfscript>
					// Set Row Color
					if ( vCurrentRow MOD 2 ) {
						vRowColor = '##E6E6E6';
					} else {
						vRowColor = '##FFFFFF';
					}
				</cfscript>
                
				<tr>
					<td bgcolor="#vRowColor#">#qGetResults.regionName#</td>
					<td bgcolor="#vRowColor#">#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
					<td bgcolor="#vRowColor#">
						<cfif LEN(qGetResults.date_trained)>
                            Date: #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.trainingName#
                            <cfif LEN(qGetResults.score)> 
                                - Score: #qGetResults.score#
                            </cfif>
                        </cfif>
                   	</td>
				</tr>
                
                <cfscript>
					vCurrentRow++;
				</cfscript>
                
			</cfoutput>
            
		</cfloop>
        		       
	</table>    

<!--- On Screen Report --->
<cfelse>

	<cfoutput>
    	<table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
            <tr>
            	<th width="33%"></th>
                <th class="center" width="34%"> Training Report</th>
                <th class="right" width="33%">#vTotalReps# Total Representatives</th>
            </tr>
            <tr>
                <td class="center" colspan="3">
                    Program(s) included in this report: <br />
                    <cfloop query="qGetPrograms">
                        #qGetPrograms.programName# <br />
                    </cfloop>
                </td>
            </tr>
        </table>
    </cfoutput>
    
    <!--- Loopt through regions --->
    <cfloop query="qGetRegions">
    
    	<cfscript>
			qGetResults = APPLICATION.CFC.USER.reportTrainingByRegion(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType,programID=FORM.programID);
		</cfscript>
        
        <cfquery name="qTotalInRegion" dbtype="query">
        	SELECT DISTINCT
            	userID
           	FROM 
            	qGetResults
        </cfquery>
    	
        <cfoutput>
            <table width="98%" cellpadding="4" cellspacing="0" align="center" class="blueThemeReportTable">
                <tr>
                    <th class="left">#qGetResults.regionName# Region</th>
                    <th class="right">#qTotalInRegion.recordCount# Representatives</th>
                </tr>
                <tr>
                    <td class="subTitleLeft" width="50%">Representative</td>
                    <td class="subTitleLeft" width="50%">Training</td>
                </tr>
       	</cfoutput>
       	
        <cfscript>
			vCurrentRow = 0;
        </cfscript>
        
		<cfoutput query="qGetResults" group="userID">
        	
			<cfscript>
				if (vCurrentRow MOD 2)
					vClass = "class='off'";
				else
					vClass = "class='on'";
            </cfscript>
            
            <tr #vClass#>
				<td>#qGetResults.firstName# #qGetResults.lastName# ###qGetResults.userID#</td>
                <td>
                    <cfoutput>
                        <cfif LEN(qGetResults.date_trained)>
                            Date: #DateFormat(qGetResults.date_trained, 'mm/dd/yyyy')# - #qGetResults.trainingName#
                            <cfif LEN(qGetResults.score)> 
                                - Score: #qGetResults.score#
                            </cfif>
                            <br />
                        </cfif>  
                    </cfoutput> 
                </td>
            </tr>
            
            <cfscript>
				vCurrentRow++;
			</cfscript>
            
        </cfoutput>
            
       	</table>
                
    </cfloop>
        
</cfif>


<!--- Page Header --->
<gui:pageFooter />