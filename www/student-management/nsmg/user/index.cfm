<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 17, 2012
	Desc:		Index file of the user section
				
				#CGI.SCRIPT_NAME#?curdoc=user/index?action=
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="list">
    <cfparam name="URL.uniqueID" default="" />
    <cfparam name="URL.userID" default="0" />
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfswitch expression="#action#">

    <cfcase value="traincasterLogin" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>

    <!--- The default case is the login page --->
    <!---
    <cfdefaultcase>
        
        <!--- Include template --->
        <cfinclude template="_traincasterLogin.cfm" />

    </cfdefaultcase>
	--->

</cfswitch>
