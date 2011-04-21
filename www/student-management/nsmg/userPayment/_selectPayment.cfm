<!--- ------------------------------------------------------------------------- ----
	
	File:		_selectPayment.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Process Representative Payment
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param FORM Variables --->
    <cfparam name="FORM.supervising" default="0">
    <cfparam name="FORM.placing" default="0">
    <cfparam name="FORM.student" default="0">

    <!----If coming from User Profile, don't check for form vaiables--->
    <Cfif isDefined('url.user')>
        
		<cfset FORM.supervising = url.user>
    
	<cfelse>
    
        <cfif NOT VAL(FORM.placing) AND NOT VAL(FORM.supervising) AND NOT VAL(FORM.student)>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=0&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.placing) AND ( VAL(FORM.supervising) OR VAL(FORM.student) )>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.supervising) AND ( VAL(FORM.placing) OR VAL(FORM.student) )> 
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        <cfelseif VAL(FORM.student) AND ( VAL(FORM.placing) OR VAL(FORM.supervising) )>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&selected=2&placing=#FORM.placing#&supervising=#FORM.supervising#&student=#FORM.student#" addtoken="no">
        </cfif>
        
        <!--- If student is selected it's redirected to another page --->
        <cfif VAL(FORM.student) AND FORM.placing is 0 AND FORM.supervising is 0>
            <cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment&studentid=#FORM.student#" addtoken="no">
        </cfif>	
        
    </cfif>
    
    <cfquery name="payment_type_super" datasource="MySql">
        SELECT id, type
        FROM smg_payment_types
        WHERE active = '1' AND (paymenttype = 'Supervision' or paymenttype = '')
    </cfquery>
    
    <cfquery name="payment_type_place" datasource="MySql">
        SELECT id, type
        FROM smg_payment_types
        WHERE active = '1' AND (paymenttype = 'Placement' or paymenttype = '')
    </cfquery>

	<!----Regardless of where rep selected, pull all students placed by that rep---->
    <cfquery name="get_placed_students" datasource="mysql">
        SELECT studentid, familylastname, firstname, smg_students.programid, programname
        FROM smg_students
        LEFT JOIN smg_programs p ON p.programid = smg_students.programid
        WHERE 1=1
        <Cfif FORM.placing gt 0>
        AND	placerepid = #FORM.placing#
        <cfelseif FORM.supervising gt 0>
        AND	placerepid = #FORM.supervising#
        </Cfif> 
        AND smg_students.companyid = #client.companyid#
        ORDER BY studentid DESC
    </cfquery>
    
    <!----Regardless of where rep selected, pull all students supervised by that rep---->
    <cfquery name="get_supervised_students" datasource="MySQL">
        select studentid, familylastname, firstname, smg_students.programid, programname
        from smg_students
        LEFT JOIN smg_programs p ON p.programid = smg_students.programid
        where 1=1
        <Cfif FORM.placing gt 0>
        AND arearepid = #FORM.placing#
        <cfelseif FORM.supervising gt 0>
        AND arearepid = #FORM.supervising#
        </Cfif> 
        AND smg_students.companyid = #client.companyid#
        ORDER BY studentid DESC
    </cfquery>
    
    <Cfquery name="qGetRepInfo" datasource="MySQL">
        select firstname, lastname, userid
        from smg_users
        where 
        <Cfif VAL(FORM.placing)>
            userid = #FORM.placing#
        <cfelseif VAL(FORM.supervising)>
            userid = #FORM.supervising#
        </cfif>
    </Cfquery>
    
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

<div class="application_section_header">Supervising & Placement Payments</div>

<cfoutput>

<h2>
	Representative: #qGetRepInfo.firstname# #qGetRepInfo.lastname# (#qGetRepInfo.userid#) &nbsp; <span class="get_attention"><b>::</b></span>
	<a href="javascript:openPopUp('userPayment/index.cfm?action=paymentHistory&userid=#qGetRepInfo.userid#', 700, 500);" class="nav_bar">Payment History</a>
</h2>

<cfform method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processPayment">
<input type="hidden" name="user" value="#qGetRepInfo.userid#">

<table width=90% cellpadding=4 cellspacing=0>
	<tr><td colspan="5">Check each student you want to apply payments for.</td></tr>
	<tr>
		<td colspan="5">
		Please, select type of payment for the supervised students: 
		<cfselect name="payment_type_super" query="payment_type_super" value="id" display="type" queryPosition="below">
			<option value="">-- Select a Type --</option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan="5" bgcolor="##010066"><font color="white"><strong>Supervised Students &nbsp; - &nbsp; #get_supervised_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check2(this.FORM.supervised_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name, First Name</td>
		<td>Program</td>
	    <td>&nbsp;</td>
	</tr>
	<cfloop query="get_supervised_students">
	<tr>
		<td><input type="checkbox" name="supervisedStudentIDList" value="#studentid#"></td>
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
	 	<td colspan="5" align="right"> <input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
	<!--- PLACED STUDENTS --->
	<tr>
		<td colspan="5">
		Please, select type of payment for the placed students: 
		<cfselect name="payment_type_place" query="payment_type_place" value="id" display="type" queryPosition="below">
			<option value="">-- Select a Type --</option>
		</cfselect>
		</td>
	</tr>
	<tr>
		<td colspan="5" bgcolor="##010066"><font color="white"><strong>Placed Students &nbsp; - &nbsp; #get_placed_students.recordcount#</strong></font></td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td><input type="checkbox" value="Check All" onClick="this.value=check(this.FORM.placed_selected_student)"></td>
		<Td>ID</Td>
		<td>Last Name>, First Name</td>
		<td>Program</td>
		<td>&nbsp;</td>
	</tr>
	<cfloop query="get_placed_students">
	<tr>
		<td><input type="checkbox" name="placedStudentIDList" value="#studentid#"></td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#studentid#</a>
		</td>
		<td>
        	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">#familylastname#, #firstname#</a>
        </td>
		<Td>#programname#</Td>  
		<td>&nbsp;</td>
	</tr>
   </cfloop>
	<tr>
		<td colspan="5" align="right"><input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="search"></td>
	</Tr>
</table>
</cfform>
</cfoutput>