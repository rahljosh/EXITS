<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 19, 2012
	Desc:		Index file for new report section
				
				#CGI.SCRIPT_NAME#?curdoc=report/index
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfscript>
		// Param Variables
		param name="action" default="menu";

		// Get Programs
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(dateActive=1);
		
		// Get Facilitators
		qGetFacilitatorList = APPLICATION.CFC.USER.getFacilitators();

		// Get User Regions
		qGetRegionList = APPLICATION.CFC.REGION.getUserRegions(
			companyID=CLIENT.companyID,
			userID=CLIENT.userID,
			userType=CLIENT.userType
		);
		
		qGetSeasonList = APPLICATION.CFC.LOOKUPTABLES.getSeason();
	</cfscript>
	
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfswitch expression="#action#">
	
    
    <!--- List of Student Management Reports --->
    <cfcase value="studentByRegion,studentFlightInformation,studentHelpCommunityService,studentPlacementPaperworkByRegion">

        <cfinclude template="studentManagement/_#action#.cfm" />

    </cfcase>
    
    
    <!--- List of Host Family Management Reports --->
    <cfcase value="hostFamilyCBCAuthorization,hostFamilySpreadsheet,hostFamilyWelcomeByRegion">

        <cfinclude template="hostManagement/_#action#.cfm" />

    </cfcase>
    
    
    <!--- List of Representative Management Reports --->
    <cfcase value="userAreaRepPaperwork,userCBCAuthorization,userComplianceMileageReport,userPendingStudentMissingSecondVisitRep,userRegionalHierarchy,userSecondVisitCompliance,userTrainingListByRegion,userTrainingNonCompliant">

        <cfinclude template="representativeManagement/_#action#.cfm" />

    </cfcase>


    <!--- List of Office Management Reports --->
    <cfcase value="regionGoal">

        <cfinclude template="officeManagement/_#action#.cfm" />

    </cfcase>
    
    <!--- Menu Options --->
    <cfdefaultcase>
    
        <cfinclude template="_menu.cfm" />

    </cfdefaultcase>

</cfswitch>

