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
			vErrors = vErrors & "<b>*ISE Placement Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
		try {
			include "iseProgressReportPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ISE Progress Report Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
		try {
			include "iseSecondVisitPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ISE Second Visit Payments - " & e.message & ":</b> " & e.detail & "<br/>";
		}
		try {
			include "iseMultiPlaceBonus.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ISE Multi Placement Bonus Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
		try {
			include "iseDeparturePayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ISE Departure Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
	}
	
	// CASE Payments
	if ( NOT ListFind("1,7", DayOfWeek(Now())) ) {
		try {
			include "casePayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*CASE Payments - " & e.message & ":</b> " & e.detail & "<br/>";
		}
		try {
			include "caseMultiPlaceBonus.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*CASE Multi Placement Bonus Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
	}
	
	// CASE Payment - only run on Tuesdays
	if ( DayOfWeek(Now()) EQ 3 ) {
		try {
			include "caseDeparturePayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*CASE Departure Payments - " & e.message & ":</b> " & e.detail & "<br/>";	
		}
	}
	
	if (NOT LEN(vErrors)) {
		vErrors = "All of the payment queries ran properly";	
	}
	
	// ESI Payments
	if ( NOT ListFind("1,7", DayOfWeek(Now())) ) {
		try {
			include "esiProgressReportPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ESI Payments - " & e.message & ":</b> " & e.detail & "<br/>";
		}
		try {
			include "esiPlacementPayments.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ESI Payments - " & e.message & ":</b> " & e.detail & "<br/>";
		}
		try {
			include "esiHostApplicationBonus.cfm";
		} catch(any e) {
			vErrors = vErrors & "<b>*ESI Payments - " & e.message & ":</b> " & e.detail & "<br/>";
		}
	}
	
</cfscript>

<cfinvoke component="nsmg.cfc.email" method="send_mail">
    <cfinvokeargument name="email_to" value="jim@iseusa.org">
    <cfinvokeargument name="email_subject" value="Payments Queries Errors">
    <cfinvokeargument name="email_message" value="#vErrors#">
    <cfinvokeargument name="email_from" value="support@iseusa.org">
</cfinvoke>

<p>Payments Scheduled task completed!</p>