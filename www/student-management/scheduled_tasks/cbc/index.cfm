<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Re-Run CBC Index File. It calls users and host family files.

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="99999">
    
    <cfparam name="CLIENT.companyID" default="1">

</cfsilent>


<!--- 	
	User
--->

<!--- User CBC --->
<cfscript>
	userType = 'user';
</cfscript>

<!--- Get expires CBCs for User and adds a record to be re-run --->
<cfinclude template="getExpiredUsers.cfm">

<!--- Run User CBCs --->
<cfinclude template="runUsers.cfm">



<!--- 
	User Member CBC 
--->
<cfscript>
	userType = 'member';
</cfscript>

<!--- Get expires CBCs for User Members and adds a record to be re-run --->
<cfinclude template="getExpiredUsers.cfm">

<!--- Run User Members CBCs --->
<cfinclude template="runUsers.cfm">



<!--- 	
	Host Family - Current Students 
--->

<!--- 
	Host Father 
--->
<cfscript>
	userType = 'father';
</cfscript>

<!--- Host Father - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Father - Run CBCs --->
<cfinclude template="runHosts.cfm">



<!--- 
	Host Mother 
--->
<cfscript>
	userType = 'mother';
</cfscript>

<!--- Host Mother - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Mother - Run CBCs --->
<cfinclude template="runHosts.cfm">



<!--- 
	Host Member 
--->    
<cfscript>
	userType = 'member';
</cfscript>

<!--- Host Member - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Member - Run CBCs --->
<cfinclude template="runHosts.cfm">




<!--- 	
	Host Family - Upcoming Students 
--->

<!--- 
	Host Father - Upcoming Students  
--->
<cfscript>
	userType = 'father';
	isUpcomingProgram = 1;
</cfscript>

<!--- Host Father - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Father - Run CBCs --->
<cfinclude template="runHosts.cfm">



<!--- 
	Host Mother - Upcoming Students  
--->
<cfscript>
	userType = 'mother';
	isUpcomingProgram = 1;
</cfscript>

<!--- Host Mother - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Mother - Run CBCs --->
<cfinclude template="runHosts.cfm">



<!--- 
	Host Member - Upcoming Students 
--->    
<cfscript>
	userType = 'member';
	isUpcomingProgram = 1;
</cfscript>

<!--- Host Member - Get expires CBCs for and adds a record to be re-run --->
<cfinclude template="getExpiredHosts.cfm">

<!--- Host Member - Run CBCs --->
<cfinclude template="runHosts.cfm">


<p>CBC Scheduled task completed!</p>
