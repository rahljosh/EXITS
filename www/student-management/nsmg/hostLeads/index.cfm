<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		June 14, 2010
	Desc:		Host Family Leads Index Page

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
	<!--- Param local variables --->
	<cfparam name="id" default="0" />
	<cfparam name="action" default="list">

    <!--- Param URL variables --->
	<cfparam name="URL.hashID" default="">

</cfsilent>
	
<!--- 
	Check to see which action we are taking. 
--->
<cfswitch expression="#action#">

	<cfcase value="list,detail,needAttention,export,report,leadList,officeHostLeads,app_sent" delimiters=",">

		<!--- Include template --->
		<cfinclude template="_#action#.cfm" />

	</cfcase>


	<!--- The default case is the login page --->
	<cfdefaultcase>
		
		<!--- Include template --->
		<cfinclude template="_list.cfm" />

	</cfdefaultcase>

</cfswitch>
