<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		April 17, 2012
	Desc:		Index file of the user section
				
				#CGI.SCRIPT_NAME#?curdoc=user/index?action=
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<cfscript>
		// Param local variables
		param name="action" default="welcome";
		
		// Param URL variables
		param name="URL.uniqueID" default="";
		param name="URL.userID" default=0;
	</cfscript>		
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfswitch expression="#action#">

    <cfcase value="welcome,displayAgreement,cbcAuthorization,employmentHistory,reference,trackUserPaperwork,traincasterLogin" delimiters=",">

        <!--- Include template --->
        <cfinclude template="_#action#.cfm" />

    </cfcase>

    <!--- The default case is the welcome page --->
    <cfdefaultcase>
        
        <!--- Include template --->
        <cfinclude template="_welcome.cfm" />

    </cfdefaultcase>

</cfswitch>