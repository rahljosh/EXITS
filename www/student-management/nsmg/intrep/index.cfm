<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		May 11, 2011
	Desc:		Index file of the international representative section
				
				#CGI.SCRIPT_NAME#?curdoc=intRep/index
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="action" default="list">
    <cfparam name="URL.uniqueID" default="" />
    
</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->

<cfswitch expression="#action#">

	<cfcase value="flightInformationList" delimiters=",">

		<!--- Include template --->
		<cfinclude template="_#action#.cfm" />

	</cfcase>


	<!--- The default case is the login page --->
	<cfdefaultcase>
		
		<!--- Include template --->
		<cfinclude template="_flightInformationList.cfm" />

	</cfdefaultcase>

</cfswitch>
