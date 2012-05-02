<!--- ------------------------------------------------------------------------- ----
	
	File:		_nonComplianceReport.cfm
	Author:		James Griffiths
	Date:		May 2, 2012
	Desc:		Non-Compliance Report

	Updated:
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

    <cfscript>	
		// Param FORM Variables	
		param name="FORM.regionID" default=0;
		param name="FORM.trainingID" default=0;
		param name="FORM.outputType" default="onScreen";

		// Get Regions
		qGetRegions = APPLICATION.CFC.REGION.getRegionsByList(regionIDList=FORM.regionID, companyID=CLIENT.companyID);
	</cfscript>
    
    <!--- This gets the total number of representatives that will be displayed --->
    <cfscript>
		vTotalReps = 0;
	</cfscript>
    <cfloop query="qGetRegions">
    	<cfscript>
    		qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType);
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
	<cfheader name="Content-Disposition" value="attachment; filename=NonComplianceReport.xls"> 
	
	<table width="98%" cellpadding="4" cellspacing="0" align="center" border="1">
		<tr>
          	<th colspan="4">Training Report</th>            
       	</tr>
      	<tr style="font-weight:bold;">
            <td>Region</td>
            <td>Representative</td>
            <td>Status</td>
            <td>Training</td>
       	</tr>
        
        <cfscript>
			vCurrentRow = 1;
        </cfscript>
                
        <cfloop query="qGetRegions">
        
        	<cfscript>
				qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType);
				qGetTrainingInfo = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining',fieldID=FORM.trainingID);
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
                    	<cfif LEN(qGetResults.date_trained) AND NOT VAL(qGetResults.has_passed)>
                            <span style="color:##F00;">Failed</span>
                        <cfelseif LEN(qGetResults.date_trained) AND DateAdd("yyyy", 1, qGetResults.date_trained) LTE now()>
                            <span style="color:##F00;">Expired</span>
                        <cfelse>
                            <span style="color:##F00;">Missing</span>
                        </cfif>
                   	</td>
					<td bgcolor="#vRowColor#">#qGetTrainingInfo.name#</td>
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
                <th class="center" width="34%">Non-Compliance Report</th>
                <th class="right" width="33%">#vTotalReps# Total Representatives</th>
            </tr>
        </table>
    </cfoutput>
    
    <!--- Loop through regions --->
    <cfloop query="qGetRegions">
    
    	<cfscript>
			qGetResults = APPLICATION.CFC.USER.reportTrainingNonCompliance(regionID=qGetRegions.regionID,trainingIDList=FORM.trainingID,userID=CLIENT.userID,userType=CLIENT.userType);
			qGetTrainingInfo = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(applicationID=7,fieldKey='smgUsersTraining',fieldID=FORM.trainingID);
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
                    <th></th>
                    <th class="right">#qTotalInRegion.recordCount# Representatives</th>
                </tr>
                <tr>
                    <td class="subTitleLeft" width="50%">Representative</td>
                    <td class="subTitleLeft" width="20%">Status</td>
                    <td class="subTitleLeft" width="30%">Training</td>
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
                    <cfif LEN(qGetResults.date_trained) AND NOT VAL(qGetResults.has_passed)>
                        <span style="color:##F00;">Failed</span>
                    <cfelseif LEN(qGetResults.date_trained) AND DateAdd("yyyy", 1, qGetResults.date_trained) LTE now()>
                        <span style="color:##F00;">Expired</span>
                    <cfelse>
                        <span style="color:##F00;">Missing</span>
                    </cfif>
                </td>
                <td>
                    #qGetTrainingInfo.name#
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