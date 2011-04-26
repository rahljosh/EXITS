<!--- ------------------------------------------------------------------------- ----
	
	File:		_searchStudent.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Searches for a student by name or ID
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <!--- Param URL Variables --->
	<cfparam name="URL.orderBy" default="studentID">
    <cfparam name="user" default="0">
    
	<!--- Representative not selected - Display error message --->
	<cfif NOT VAL(user)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&displaySplitPaymentError=1" addtoken="no">
	</cfif>

    <Cfquery name="qGetRepInfo" datasource="MySQL">
        SELECT 
        	userid,
            firstname, 
            lastname             
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#user#">
    </Cfquery>
    
    <cfquery name="qGetSupervisingPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
            paymentType != <cfqueryparam cfsqltype="cf_sql_varchar" value="Placement"> 
    </cfquery>
    
    <cfquery name="qGetPlacingPaymentType" datasource="MySql">
        SELECT 
        	id, 
            type
        FROM 
        	smg_payment_types
        WHERE 
        	paymentType != <cfqueryparam cfsqltype="cf_sql_varchar" value="Supervision"> 
    </cfquery>
    
	<!----Regardless of where rep selected, pull all students supervised by that rep---->
    <cfquery name="qGetSupervisedStudents" datasource="MySQL">
        SELECT DISTINCT 
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.programid, 
            programname
        FROM 
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        WHERE 
        	s.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#user#">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        
        UNION
        
        SELECT DISTINCT 
        	s.studentid, 
            s.familylastname, 
            s.firstname,
            s.programid, 
            programname
		FROM 
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        INNER JOIN 
        	smg_hosthistory h ON h.studentid = s.studentid
         WHERE 
         	h.arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#user#">
         AND 
         	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            
        GROUP BY 
        	studentid        
        ORDER BY 
        	studentid DESC
    </cfquery>
    
    <!----Regardless of where rep selected, pull all students placed by that rep---->
    <cfquery name="qGetPlacedStudents" datasource="mysql">
        SELECT DISTINCT 
        	s.studentid, 
            s.familylastname, 
            s.firstname, 
            s.programid, 
            programname
        FROM 
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        WHERE 
        	s.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#user#">
        AND 
        	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
        
        UNION
        
        SELECT DISTINCT 
        	s.studentid, 
            s.familylastname, 
            s.firstname,
            s.programid, 
            programname
		FROM 
        	smg_students s
        LEFT JOIN 
        	smg_programs p ON p.programid = s.programid
        INNER JOIN 
        	smg_hosthistory h ON h.studentid = s.studentid
         WHERE 
         	h.placerepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#user#">
         AND 
         	s.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
            
        GROUP BY 
        	studentid        
        ORDER BY 
        	studentid DESC
    </cfquery>
        
</cfsilent>    

<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	var checkflag = "false";
	function check(field) {
	if (checkflag == "false") {
	for (i = 0; i < field.length; i++) {
	field[i].checked = true;}
	checkflag = "true";
	return "Uncheck All"; }
	else {
	for (i = 0; i < field.length; i++) {
	field[i].checked = false; }
	checkflag = "false";
	return "Check All"; }
	}
	//  End -->
	<!-- Begin
	var checkflag2 = "false";
	function check2(field) {
	if (checkflag2 == "false") {
	for (i = 0; i < field.length; i++) {
	field[i].checked = true;}
	checkflag2 = "true";
	return "Uncheck All"; }
	else {
	for (i = 0; i < field.length; i++) {
	field[i].checked = false; }
	checkflag2 = "false";
	return "Check All"; }
	}
	//  End -->
</script>

<cfoutput>

<div class="application_section_header">Supervising & Placement Payments</div>

<h2>Representative: #qGetRepInfo.firstname# #qGetRepInfo.lastname# (#qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
<a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a></h2>

<cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&split=yes">
<input type="hidden" name="user" value="#user#">

<table width=90% cellpadding=4 cellspacing=0>
	<tr><td colspan="6">Check each student you want to apply payments for.</td></tr>
	<tr>
		<td colspan="6">
		Please, select type of payment for the supervised students: 
		<cfselect name="qGetSupervisingPaymentType" query="qGetSupervisingPaymentType" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=6 bgcolor="##010066"><font color="white"><strong>Supervised Students &nbsp; - &nbsp; #qGetSupervisedStudents.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check2(this.form.supervisedStudentIDList)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="qGetSupervisedStudents">
	<tr>
		<td><input type="checkbox" name="supervisedStudentIDList" value=#studentid#></td>
		<Td>
			<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#studentid#</a>
        </Td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#familylastname#, #firstname#</a>
        </td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<tr>
	 	<td colspan=6 align="right"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
	<!--- PLACED STUDENTS --->
	<tr>
		<td colspan="6">
		Please, select type of payment for the placed students: 
		<cfselect name="qGetPlacingPaymentType" query="qGetPlacingPaymentType" value="id" display="type" queryPosition="below">
			<option value=""></option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan=6 bgcolor="##010066"><font color="white"><strong>Placed Students &nbsp; - &nbsp; #qGetPlacedStudents.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check(this.form.placedStudentIDList)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="qGetPlacedStudents">
	<tr>
		<td><input type="checkbox" name="placedStudentIDList" value=#studentid#></td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#studentid#</a>
		</Td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#familylastname#, #firstname#</a>
	    </td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
   </cfloop>
	<tr>
		<td colspan=6 align="right">  <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
</table>
</cfform>
</cfoutput>