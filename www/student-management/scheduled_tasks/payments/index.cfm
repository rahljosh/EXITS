<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		James Griffiths
	Date:		April 3, 2014
	Desc:		Run daily payment queries

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <cfsetting requesttimeout="99999">

</cfsilent>

<cfscript>

	// List the files that had errors
	vErrors = "";
	
	// ISE Payments
	if ( NOT ListFind("1,7", DayOfWeek(Now())) ) {
		try {
			include "PlacementPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "*ISE Placement Payments*" & e.message;	
		}
		try {
			include "progressReportPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "*ISE Progress Report Payments*" & e.message;;	
		}
		try {
			include "secondVisitPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "*ISE Second Visit Payments*" & e.message;;	
		}
		try {
			include "iseMultiPlaceBonus.cfm";
		} catch(any e) {
			vErrors = vErrors & "*ISE Multi Placement Bonus Payments*" & e.message;;	
		}
	}
	
	// CASE Payments
	if ( ListFind("5", DayOfWeek(Now())) ) {
		try {
			include "casePayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "*CASE Payments*" & e.message;;	
		}
		try {
			include "caseMultiPlaceBonus.cfm";
		} catch(any e) {
			vErrors = vErrors & "*CASE Multi Placement Bonus Payments* & e.message;";	
		}
	}
	
</cfscript>

<cfif LEN(vErrors)>
	<cfinvoke component="nsmg.cfc.email" method="send_mail">
        <cfinvokeargument name="email_to" value="jim@iseusa.org">
        <cfinvokeargument name="email_subject" value="Payments Queries Errors">
        <cfinvokeargument name="email_message" value="#vErrors#">
        <cfinvokeargument name="email_from" value="support@iseusa.com">
    </cfinvoke>
</cfif>

<p>Payments Scheduled task completed!</p>