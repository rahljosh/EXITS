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

    <cfcase value="menu,studentManagementMenu,hostFamilyManagementMenu,representativeManagementMenu" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>
	
    <!--- List of Student Management Reports --->
    <cfcase value="studentListByRegion" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>
    
    <!--- List of Host Family Management Reports --->
    <cfcase value="welcomeFamilyByRegion" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>
    
    <!--- List of Representative Management Reports --->
    

    <!--- The default case is the login page --->
    <cfdefaultcase>
        
        <!--- Include template --->
        <cfinclude template="_menu.cfm" />

    </cfdefaultcase>

</cfswitch>

