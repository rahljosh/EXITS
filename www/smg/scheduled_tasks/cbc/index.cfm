<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Re-Run CBC Index File. It calls users and host family files.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="9999">
    
    <cfparam name="CLIENT.companyID" default="1">

</cfsilent>



<!--- User CBC --->
<cfscript>
	userType = 'user';
</cfscript>

<!--- Get expires CBCs for User and adds a record to be re-run --->
<cfinclude template="getExpiredUsers.cfm">

<!--- Run User CBCs --->
<cfinclude template="runUsers.cfm">



<!--- User Member CBC --->
<cfscript>
	userType = 'member';
</cfscript>

<!--- Get expires CBCs for User Members and adds a record to be re-run --->
<cfinclude template="getExpiredUsers.cfm">

<!--- Run User Members CBCs --->
<cfinclude template="runUsers.cfm">



<!--- Host Father --->
<cfscript>
	userType = 'father';
</cfscript>

<!--- Get expires CBCs for Host Fathers and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Run Host Fathers CBCs --->
<cfinclude template="runHosts.cfm">



<!--- Host Mother --->
<cfscript>
	userType = 'mother';
</cfscript>

<!--- Get expires CBCs for Host Mothers and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Run Host Mothers CBCs --->
<cfinclude template="runHosts.cfm">



<!--- Host Member --->    
<cfscript>
	userType = 'member';
</cfscript>

<!--- Get expires CBCs for Host Members and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Run Host Members CBCs --->
<cfinclude template="runHosts.cfm">


<p>CBC Scheduled task completed!</p>
