<!--- ------------------------------------------------------------------------- ----
	
	File:		editSchoolPayments.cfm
	Author:		James Griffiths
	Date:		July 6, 2012
	Desc:		Edit popup for school payments

----- ------------------------------------------------------------------------- --->

<link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css">
<cfoutput>
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
</cfoutput>
<script type="text/javascript" src="../SpryAssets/SpryMenuBar.js"></script> <!-- Menu Script -->
<script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker --> 
<script type="text/javascript" src="../linked/js/basescript.js"></script> <!-- Base Script -->

<cfsilent>

	<cfajaxproxy cfc="internal.extensions.components.payments" jsclassname="PAYMENTS">

	<cfscript>
		param name="URL.studentID" default=0;
		param name="URL.schoolID" default=0;
		param name="URL.programID" default=0;
		param name="FORM.newAmount" default=0;
		param name="FORM.newDate" default="";
		param name="FORM.newCheckNumber" default="";
	</cfscript>
    
    <cfquery name="qGetPayments" datasource="MySql">
    	SELECT
        	*
       	FROM
        	php_school_payments
       	WHERE
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
       	<cfif VAL(URL.studentID)>
        	AND
        		studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.studentID#">
       	</cfif>
        <cfif VAL(URL.schoolID)>
        	AND
        		schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.schoolID#">
       	</cfif>
		<cfif VAL(URL.programID)>
        	AND
        		programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.programID#">
       	</cfif>
        ORDER BY
        	date
    </cfquery>
    
    <cfquery name="qGetInfo" datasource="#APPLICATION.DSN#">
    	SELECT
        	s.firstName,
            s.familyLastName,
            sc.schoolName,
            p.programName
       	FROM
        	smg_students s,
            smg_programs p,
            php_schools sc
       	WHERE
        	s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.studentID#">
       	AND
        	p.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.programID#">
       	AND
        	sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.schoolID#">
    </cfquery>

</cfsilent>

<cfoutput>
	
    <span style=" font-weight:bold; font-size:14px;"><center>Payment History for #qGetInfo.firstName# #qGetInfo.familyLastName# at #qGetInfo.schoolName# in #qGetInfo.programName#</center></span>
    <br />
    
    <table width="98%" align="center" cellpadding="1" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
        <cfif VAL(qGetPayments.recordCount)>
            <tr style="font-size:12px;">
                <th background="../images/back_menu2.gif" align="left" width="28%">Amount</th>
                <th background="../images/back_menu2.gif" align="left" width="28%">Check Number</th>
                <th background="../images/back_menu2.gif" align="left" width="28%">Date</th>
                <th background="../images/back_menu2.gif" align="left" width="16%">&nbsp;</th>
            </tr>
       	</cfif>
        <cfloop query="qGetPayments">
            <tr bgcolor="#iif(qGetPayments.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#" style="font-size:12px;">
                <td>$#qGetPayments.amount#</td>
                <td>#qGetPayments.checkNumber#</td>
                <td>#DateFormat(qGetPayments.date,'mm/dd/yyyy')#</td>
                <td><input type="image" src="../pics/delete.gif" onClick="deletePayment(#ID#);"/></td>
            </tr>
        </cfloop>
        <tr style="font-size:12px;">
            <th background="../images/back_menu2.gif" align="left" width="28%">Amount</th>
           	<th background="../images/back_menu2.gif" align="left" width="28%">Check Number</th>
            <th background="../images/back_menu2.gif" align="left" width="28%">Date</th>
            <th background="../images/back_menu2.gif" align="left" width="16%">&nbsp;</th>
        </tr>
        <tr>
            <td><input type="text" name="newAmount" id="newAmount" class="mediumField" /></td>
            <td><input type="text" name="newCheckNumber" id="newCheckNumber" class="mediumField" /></td>
            <td><input type="text" name="newDate" id="newDate" class="datePicker" /></td>
            <td><input type="image" src="../pics/submit.gif" onClick="addPayment();"/></td>
        </tr>
    </table>
    
    <center>
    	<br />
        <input type="image" src="../pics/close.gif" onClick="refreshAndClose()" />
  	</center>
    
</cfoutput>

<script type="text/javascript">
	
	function addPayment() {
		var p = new PAYMENTS();
		var studentID = <cfoutput>#URL.studentID#</cfoutput>;
		var schoolID = <cfoutput>#URL.schoolID#</cfoutput>;
		var programID = <cfoutput>#URL.programID#</cfoutput>;
		var amount = $("#newAmount").val();
		if (!isNumber(amount)) {
			alert("Please enter a valid amount");
		}
		var checkNumber = $("#newCheckNumber").val();
		var date = $("#newDate").val();
		if (isNumber(amount)) {
			if (date == "") {
				alert("Please enter a date");
			} else {
				var result = p.addSchoolPayment(
					studentID,
					schoolID,
					programID,
					amount,
					checkNumber,
					date
				);
				if (!result) {
					alert("The information was not added, please check your input and try again.");
				}
				window.location.reload();
				window.opener.document.filters.submit();
			}
		}
	}
	
	function deletePayment(ID) {
		var p = new PAYMENTS();
		p.deleteSchoolPayment(ID);
		window.location.reload();
		window.opener.document.filters.submit();
	}
	
	function refreshAndClose() {
		window.opener.document.filters.submit();
		window.close();	
	}
	
	function isNumber(n) {
	  return !isNaN(parseFloat(n)) && isFinite(n);
	}

</script>