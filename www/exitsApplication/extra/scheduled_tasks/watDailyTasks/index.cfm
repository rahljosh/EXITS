<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		June 18, 2012
	Desc:		Runs all the WAT daily scheduled tasks

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Set Request Timeout --->
    <cfsetting requesttimeout="99999">

</cfsilent>


<!--- Inactivate Records --->
<cfinclude template="inactivateRecords.cfm">
<h1>Inactivate Records Task</h1>


<!--- Flight Information Report (for Trainee and WAT)--->
<cfset companyID = 8>
<cfinclude template="flightInformationReport.cfm">
<h1>Flight Information Report Task for WAT</h1>

<cfset companyID = 7>
<cfinclude template="flightInformationReport.cfm">
<h1>Flight Information Report Task for Trainee</h1>


<!--- Online Application Uploaded Document Report --->
<cfinclude template="uploadedDocumentReport.cfm">
<h1>Online Application Uploaded Document Report Task</h1>


<!--- Evaluation Email link to evaluation report 20, 50, 80, and 110 days after check in date. --->
<cfinclude template="evaluationEmail.cfm">
<h1>Evaluation Email Task</h1>

<!--- Check in reminder and warning emails. --->
<cfinclude template="checkInWarning.cfm">
<h1>Check-in Warning Task</h1>


<!--- Document Expiration --->
<cfinclude template="documentExpiration.cfm">
<h1>Document Expiration Task</h1>


<!--- Document Expiration --->
<cfinclude template="Ds2019-Issued.cfm">
<h1>Ds2019 Report</h1>
