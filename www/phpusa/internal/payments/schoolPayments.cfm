<!--- ------------------------------------------------------------------------- ----
	
	File:		schoolPayments.cfm
	Author:		James Griffiths
	Date:		July 5, 2012
	Desc:		List of school payments

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<cfscript>
		param name="FORM.order" default="familyLastName,firstName";
		param name="FORM.active" default="";
		param name="FORM.schoolID" default="";
		param name="FORM.programID" default="";
	</cfscript>
	
    <cfquery name="qGetStudents" datasource="MySql">
    	SELECT
        	s.studentID,
            smg.firstName,
            smg.familyLastName,
            smg.uniqueID,
            sc.schoolName,
            sc.schoolID,
            p.programID,
            p.programName,
            (SELECT SUM(amount) FROM php_school_payments WHERE studentID = s.studentID AND schoolID = sc.schoolID AND programID = p.programID) AS totalAmount
      	FROM
        	php_students_in_program s
       	INNER JOIN
        	smg_students smg ON smg.studentID = s.studentID
      	LEFT JOIN
        	smg_programs p ON p.programID = s.programID
       	LEFT JOIN
        	php_schools sc ON sc.schoolID = s.schoolID
      	WHERE
        	1 = 1
      	<cfif FORM.active EQ 0 OR FORM.active EQ 1>
        	AND
        		s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.active#">
            AND
                s.cancelDate IS <cfqueryparam null="yes">
       	<cfelseif FORM.active EQ 2>
        	AND
        		s.active = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
            AND
                s.cancelDate IS NOT <cfqueryparam null="yes">
        </cfif>
        <cfif LEN(FORM.schoolID)>
        	AND
            	sc.schoolID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.schoolID#">
        </cfif>
        <cfif LEN(FORM.programID)>
        	AND
            	s.programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programID#">
        </cfif>
        ORDER BY
        	#FORM.order#
    </cfquery>
    
    <cfquery name="qGetSchools" datasource="MySql">
    	SELECT DISTINCT
        	schoolID,
            schoolName
      	FROM
        	php_schools
       	WHERE
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
       	ORDER BY
        	schoolName
    </cfquery>
    
    <cfquery name="qGetPrograms" datasource="MySql">
    	SELECT
        	*
      	FROM
        	smg_programs
       	WHERE
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      	AND
        	companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="6">
       	ORDER BY
        	programName
    </cfquery>
    
</cfsilent>

<script type="text/javascript">

	function resubmit(order) {
		$("#order").val(order);
		$("#filters").submit();
	}
	
	function editPayment(studentID,schoolID,programID) {
		window.open("../internal/payments/editSchoolPayments.cfm?studentID=" + studentID + "&schoolID=" + schoolID + "&programID=" + programID,"EDIT","height=500, width=600");
	}
	
</script>

<cfoutput>

	<form name="filters" id="filters" action="?curdoc=payments/schoolPayments" method="post">
        <input type="hidden" name="order" id="order" value="familyLastName,firstName" />
        
        <table width="98%" align="center" cellpadding="2" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
        	<tr>
            	<th style="font-size:14px;">School Payments<span style="font-size:12px;"> - #qGetStudents.recordCount# Records</span></th>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr align="center">
                <td>
                    Status:
                    <select name="active" id="active" style="width:100px">
                        <option value="" <cfif FORM.active EQ "">selected</cfif>>All</option>
                        <option value="1" <cfif FORM.active EQ "1">selected</cfif>>Active</option>
                        <option value="0" <cfif FORM.active EQ "0">selected</cfif>>Inactive</option>
                        <option value="2" <cfif FORM.active EQ "2">selected</cfif>>Cancelled</option>
                    </select>
                    &nbsp;
                    Program:
                    <select name="programID" id="programID" style="width:100px">
                        <option value="" <cfif FORM.programID EQ "">selected</cfif>>All</option>
                        <cfloop query="qGetPrograms">
                     		<option value="#programID#" <cfif FORM.programID EQ #programID#>selected</cfif>>#programName#</option>
                        </cfloop>
                    </select>
                    &nbsp;
                    School:
                    <select name="schoolID" id="schoolID">
                        <option value="" <cfif FORM.schoolID EQ "">selected</cfif>>All</option>
                        <cfloop query="qGetSchools">
                        	<cfif schoolID NEQ 243>
                        		<option value="#schoolID#" <cfif FORM.schoolID EQ #schoolID#>selected</cfif>>#schoolName#</option>
                            </cfif>
                        </cfloop>
                    </select>
                    &nbsp;
                	<input style="vertical-align:bottom;" type="image" src="pics/submit.gif" />
                </td>
            </tr>
            <tr><td>&nbsp;</td></tr>
        </table>
  	
    </form>
    
    <table width="98%" align="center" cellpadding="1" bgcolor="##e9ecf1" border=0 cellpadding=0 cellspacing=0>
    	   		
        <tr>
        	<th background="images/back_menu2.gif" align="left" width="8%"><a href="javascript:resubmit('studentID')">ID</a></td>
            <th background="images/back_menu2.gif" align="left" width="15%"><a href="javascript:resubmit('familyLastName,firstName')">Student</a></td>
            <th background="images/back_menu2.gif" align="left" width="8%"><a href="javascript:resubmit('schoolID')">ID</a></td>
            <th background="images/back_menu2.gif" align="left" width="20%"><a href="javascript:resubmit('schoolName')">School</a></td>
            <th background="images/back_menu2.gif" align="left" width="20%"><a href="javascript:resubmit('programName')">Program</a></td>
            <th background="images/back_menu2.gif" align="left" width="20%"><a href="javascript:resubmit('amount')">Total</a></td>
            <th background="images/back_menu2.gif" align="left" width="9%"></td>
        </tr>
        
        <cfloop query="qGetStudents">
        
        	<tr bgcolor="#iif(qGetStudents.currentrow MOD 2 ,DE("e9ecf1") ,DE("white") )#">
            	<td class="style1"><a href="?curdoc=student/student_info&unqid=#uniqueID#">#studentID#</a></td>
                <td class="style1"><a href="?curdoc=student/student_info&unqid=#uniqueID#">#firstName# #familyLastName#</a></td>
                <td class="style1"><a href="?curdoc=forms/view_school&sc=#schoolID#">#schoolID#</a></td>
                <td class="style1"><a href="?curdoc=forms/view_school&sc=#schoolID#">#schoolName#</a></td>
                <td class="style1">#programName#</td>
                <td class="style1"><cfif VAL(totalAmount)>$#totalAmount#<cfelse>$0.00</cfif></td>
                <td class="style1" align="center"><input type="image" src="pics/view.gif" onclick="editPayment(#studentID#,#schoolID#,#programID#);"/></td>
            </tr>
        
        </cfloop>
        
    </table>
    
</cfoutput>