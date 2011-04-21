<cfoutput>

    <!--- Param URL Variables --->
	<cfparam name="URL.orderBy" default="">
    <cfparam name="studentID" default="0">
    <cfparam name="familyLastName" default="">

	<!--- none information was entered --->
	<cfif NOT LEN(familyLastName) AND NOT VAL(studentID)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&searchstu=0" addtoken="no">
	<!--- both informations were entered --->
	<cfelseif LEN(familyLastName) AND VAL(studentID)>
		<cflocation url="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&searchstu=2" addtoken="no">
	</cfif>

    <cfquery name="qSearchStudent" datasource="MySql">
        SELECT 
            studentid, 
            firstname, 
            familylastname
        FROM 
            smg_students 
        WHERE 
            companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">

		<cfif LEN(familyLastName)>
            AND 
                familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#familyLastName#%">
        </cfif>
        
        <cfif VAL(studentID)>
            AND 
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#studentID#">
        </cfif>

        ORDER BY 
            <cfswitch expression="#URL.orderBy#">
            
                <cfcase value="studentID">
                    studentID,
                    familylastname, 
                </cfcase>
                
                <cfcase value="firstName">
                    firstName, 
                    familylastname, 
                </cfcase>
        
                <cfcase value="familylastname">
                    familylastname, 
                    firstName
                </cfcase>
    
                <cfdefaultcase>
                    familylastname, 
                    firstName
                </cfdefaultcase>
    
            </cfswitch>
                 
    </cfquery>

<HEAD>
<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	function countChoices(obj) {
	max = 1; // max. number allowed at a time
	
	<cfloop from="1" to="#qSearchStudent.recordcount#" index='i'>
	student#i# = obj.form.student#i#.checked; </cfloop>
	
	count = <cfloop from="1" to="#qSearchStudent.recordcount#" index='i'> (student#i# ? 1 : 0) <cfif qSearchStudent.recordcount is #i#>; <cfelse> + </cfif> </cfloop>
	// If you have more checkboxes on your form
	// add more  (box_ ? 1 : 0)  's separated by '+'
	if (count > max) {
	alert("Oops!  You can only choose up to " + max + " choice! \nUncheck an option if you want to pick another.");
	obj.checked = false;
	   }
	}
	//  End -->
</script>

</HEAD>

<div class="application_section_header">Student Finder</div>

<Br>Specify ONLY ONE Student from the list below:<br><br>

<form method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=processStudentPayment" name="myform">
<input type="hidden" name="student" value="0"><input type="hidden" name="supervising" value="0">
<table width=90% cellpadding="4" cellspacing="0">
	<tr>
		<td colspan="4" bgcolor="##010066"><font color="white"><strong>Student</strong></font></td>
	    <td>&nbsp;</td>
	</tr>
	<tr bgcolor="##CCCCCC">
		<td>&nbsp;</td>
		<Td><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=studentid&familylastname=#form.familyLastName#&userid=#form.studentID#">ID</a></Td>
		<td><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=familylastname&familylastname=#form.familyLastName#&userid=#form.studentID#">Last Name</a>, 
			<a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=firstname&familylastname=#form.familyLastName#&userid=#form.studentID#">First Name</a></td>
		<td>&nbsp;</td>
	</tr>
	<cfif qSearchStudent.recordcount is '0'>
	<tr>
		<td colspan="3">Sorry, none students have matched your criteria. <br>Please change your criteria and try again.</td>
	</tr>
	<Tr>
		<td align="center" colspan="3"><div class="button"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
	</Tr>
	<cfelse>
	<cfloop query="qSearchStudent">	
	<tr>
		<td><input type="checkbox" value="#studentid#" name="studentid" id="student#currentrow#" onClick="countChoices(this)"></td>
		<Td>
          	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">
            	#studentid#
			</a>
		</td>
		<td>
          	<a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentid=#studentid#', 700, 500);" class="nav_bar">
            	#firstname# #familylastname#
			</a>
		</td>
		<td>&nbsp;</td>
	</tr>
	</cfloop>
	<Tr>
		<td align="center" colspan="3"><div class="button"><input name="submit" type="image" src="pics/next.gif" align="right" border="0" alt="Next"></td>
	</Tr>
	</cfif>
</table>
</form><br>
</cfoutput>