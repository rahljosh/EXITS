<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
</head>

<body>

<cfoutput>

---------------------------------- INVOICE - UPDATE CURRENT AGENT - AGENT ON INVOICE ---------------------------------- <br /><br />

<!---
<cfif client.userid EQ 510>
	<cfquery name="get_info" datasource="MySql">
		SELECT php.studentid, 
			s.intrep,
			c.invoiceid 
		FROM php_students_in_program php
		INNER JOIN smg_students s ON php.studentid = s.studentid
		INNER JOIN egom_charges c ON php.studentid = c.studentid
		GROUP BY c.invoiceid
	</cfquery>
	<cfloop query="get_info">
		<cfquery name="update_invoices" datasource="MySql">
			UPDATE egom_invoice
			SET intrepid = '#intrep#'
			WHERE invoiceid = '#invoiceid#'	
		</cfquery>
	</cfloop>
</cfif>
--->

---------------------------------- INVOICE - CHECK IF PAYMENTS = PAYMENT CHARGES ---------------------------------- <br /><br />

<!--- CHECK IF PAYMENTS = PAYMENT CHARGES --->

<cfif client.userid eq 510>
	<cfquery name="get_payments" datasource="MySql">
		SELECT  paymentid, paymenttypeid, userid, intrepid, transaction, date_applied, date_received, total_amount, description, full_applied,
			companyid 
		FROM egom_payments
	</cfquery>
	<TABLE width="100%" align="center" bgcolor="white">
	<cfloop query="get_payments">
		<cfquery name="get_payment_charges" datasource="MySql">
			SELECT paymentchargeid, chargeid, paymentid, sum(amount_paid) as total
			FROM egom_payment_charges 
			WHERE paymentid = #paymentid#
			GROUP BY paymentid
			ORDER BY paymentid
		</cfquery>
		<cfif total_amount NEQ get_payment_charges.total>
			<TR><TD>PAYMENT ID: #paymentid# / Total #total_amount# / TOTAL PAYMENT CHARGES AMOUNT = #get_payment_charges.total#<br /><br /></TD></TR>
		</cfif>
	</cfloop>
	</TABLE>
</cfif>

---------------------------------- UPDATE FLIGHT INFO (SET COMPANYID = 6) ---------------------------------- <br /><br />

<!---
<cfquery name="get_students" datasource="mysql">
	SELECT  s.familylastname, s.firstname, s.studentid,  s.flight_info_notes,
			u.insurance_typeid, u.businessname, 
			p.insurance_startdate
	FROM smg_students s
	INNER JOIN php_students_in_program stu_prog ON stu_prog.studentid = s.studentid
	INNER JOIN smg_users u ON u.userid = s.intrep
	INNER JOIN smg_programs p ON p.programid = stu_prog.programid
	LEFT JOIN php_schools ON php_schools.schoolid = stu_prog.schoolid
</Cfquery>

<cfloop query="get_students">
	<cfquery name="get_arrival" datasource="mysql">
		SELECT flightid, studentid, dep_date, flight_type
		FROM smg_flight_info
		WHERE studentid = '#get_students.studentid#' 
			AND flight_type = 'arrival'
			AND companyid = '0'
		ORDER BY flightid <!--- dep_date, dep_time --->
	</cfquery>

	<cfset studentid = #get_students.studentid#>

	<cfloop query="get_arrival">
		<cfif DateFormat(dep_date, 'yyyy') EQ 2007>
			<cfquery name="update" datasource="MySql">
				UPDATE smg_flight_info
				SET companyid = '#client.companyid#'
				WHERE flightid = '#get_arrival.flightid#'
				LIMIT 1
			</cfquery>
			arrival: #studentid# - flight '#get_arrival.flightid#' <br />
		</cfif>
	</cfloop>
	
	<cfquery name="get_depart" datasource="mysql">
		SELECT flightid, studentid, dep_date, flight_type
		FROM smg_flight_info
		WHERE studentid = '#get_students.studentid#' 
			AND flight_type = 'departure'
			AND companyid = '0' OR companyid = NULL
		ORDER BY flightid <!--- dep_date, dep_time --->
	</cfquery>

	<cfloop query="get_depart">
		<cfif DateFormat(dep_date, 'yyyy') EQ 2008>
			<cfquery name="update" datasource="MySql">
				UPDATE smg_flight_info
				SET companyid = '#client.companyid#'
				WHERE flightid = '#get_depart.flightid#'
				LIMIT 1
			</cfquery>
			departure: #studentid# - flight '#get_arrival.flightid#' <br />
		</cfif>
	</cfloop>
</cfloop>

<!--- <cfquery name="update" datasource="mYSql">
	update smg_flight_info
	SET companyid = NULL
</cfquery> --->
---->

<br /><br />

</cfoutput>

</body>
</html>