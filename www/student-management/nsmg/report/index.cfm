<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Index file for new report section
				
				#CGI.SCRIPT_NAME#?curdoc=report/index
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="list">
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfswitch expression="#action#">

    <cfcase value="menu,studentManagementMenu,hostFamilyManagementMenu,representativeManagementMenu,officeManagementMenu" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>
	
    
    <!--- List of Student Management Reports --->
    <cfcase value="studentListByRegion,placementPaperworkByRegion" delimiters=",">

        <!--- Include template --->
        <cfinclude template="studentManagement/_#action#.cfm" />

    </cfcase>
    
    
    <!--- List of Host Family Management Reports --->
    <cfcase value="welcomeFamilyByRegion,hostFamilyCBCAuthorizationNotReceived,usersCBCAuthorizationNotReceived" delimiters=",">

        <!--- Include template --->
        <cfinclude template="hostManagement/_#action#.cfm" />

    </cfcase>
    
    
    <!--- List of Representative Management Reports --->
    <cfcase value="userHierarchyReport,complianceMileageReport,secondVisitRepCompliance,pendingStudentMissingSecondVisitRep,userTrainingListByRegion,userTrainingNonCompliant" delimiters=",">
    
    <!--- List of Office Management Reports --->
    

        <!--- Include template --->
        <cfinclude template="representativeManagement/_#action#.cfm" />

    </cfcase>


    <!--- List of Office Management Reports --->
    <!---
    <cfcase value="" delimiters=",">

        <!--- Include template --->
        <cfinclude template="officeManagement/_#action#.cfm" />

    </cfcase>
	--->
    

    <!--- The default case is the login page --->
    <cfdefaultcase>
        
        <!--- Include template --->
        <cfinclude template="_menu.cfm" />

    </cfdefaultcase>

</cfswitch>

