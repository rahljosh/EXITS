<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		May 20, 2010
	Desc:		Re-Run CBC Index File. It calls users and host family files.

	Updated:  	10/19/11 - Re-running CASE CBCs

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="99999">
    
    <cfparam name="CLIENT.companyID" default="1">

    <!--- Param Variables --->
    <cfparam name="userType" default="">
    <cfparam name="isUpcomingProgram" default="0">

</cfsilent>


<!-------------------------------------------------------------	
	User
-------------------------------------------------------------->

<cfscript>
	// Get Expired CBCs
	userType = 'user';
	
	// Users - Get expires CBCs for and adds a record to be re-run 
	include "getExpiredUsers.cfm";
	
	
	// User ISE - Run CBCs
	include "runUsers.cfm";

	// User CASE - Run CBCs
	include "runUsersCase.cfm";
</cfscript>


<!-------------------------------------------------------------	
	User Member CBC 
-------------------------------------------------------------->

<cfscript>
	// Get Expired CBCs
	userType = 'member';
	
	// Host Members - Get expires CBCs for and adds a record to be re-run 
	include "getExpiredUsers.cfm";
	
	
	// User Member ISE - Run CBCs
	include "runUsers.cfm";
	
	// User Member CASE - Run CBCs
	include "runUsersCase.cfm";
</cfscript>

<!-------------------------------------------------------------	
	Hosts
-------------------------------------------------------------->

<cfscript>
	// Current Students
	//isUpcomingProgram = 0;
	//include "getExpiredHosts.cfm";

	// Upcoming Students 
	//isUpcomingProgram = 1;
	//include "getExpiredHosts.cfm";
	
	// Run for father
	userType = 'father';
	include "runHosts.cfm";
	include "runHostsCase.cfm";
	
	// Run for mother
	userType = 'mother';
	include "runHosts.cfm";
	include "runHostsCase.cfm";
	
	// Run for members
	userType = 'member';
	include "runHosts.cfm";
	include "runHostsCase.cfm";
	
	//Send Email listing Hosts that are still in processing
    APPLICATION.CFC.CBC.sendProcessingHostsEmail();

</cfscript>

<!---
<!-------------------------------------------------------------	
	Host Father
-------------------------------------------------------------->

<cfscript>
	// Get Expired CBCs - Current Students
	userType = 'father';
	isUpcomingProgram = 0;

	// Host Father - Get expires CBCs for and adds a record to be re-run 
	include "getExpiredHosts.cfm";


	// Upcoming Students 
	isUpcomingProgram = 1;

	// Host Father - Run CBCs for upcoming students 
	include "getExpiredHosts.cfm";


	// Host Father ISE - Run CBCs
	include "runHosts.cfm";
	
	// Host Father CASE - Run CBCs
	include "runHostsCase.cfm";
</cfscript>


<!-------------------------------------------------------------	
	Host Mother
-------------------------------------------------------------->

<cfscript>
	// Get Expired CBCs - Current Students
	userType = 'mother';
	isUpcomingProgram = 0;

	// Host Mother - Get expires CBCs for and adds a record to be re-run 
	include "getExpiredHosts.cfm";


	// Upcoming Students
	isUpcomingProgram = 1;
	
	// Host Mother - Run CBCs for upcoming students 
	include "getExpiredHosts.cfm";
	

	// Host Mother ISE - Run CBCs
	include "runHosts.cfm";
	
	// Host Mother CASE - Run CBCs
	include "runHostsCase.cfm";
</cfscript>


<!-------------------------------------------------------------	
	Host Member
-------------------------------------------------------------->

<cfscript>
	// Get Expired CBCs - Current Students
	userType = 'member';
	isUpcomingProgram = 0;
	
	// Host Member - Get expires CBCs for and adds a record to be re-run
	include "getExpiredHosts.cfm";


	// Upcoming Students
	isUpcomingProgram = 1;
	
	// Host Member - Run CBCs for upcoming students
	include "getExpiredHosts.cfm";
	
	
	// Host Member ISE - Run CBCs
	include "runHosts.cfm";
	
	// Host Member CASE - Run CBCs
	include "runHostsCase.cfm";
</cfscript>--->


<p>CBC Scheduled task completed!</p>