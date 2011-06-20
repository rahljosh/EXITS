<!--- ------------------------------------------------------------------------- ----
	
	File:		_searchStudent.cfm
	Author:		Marcus Melo
	Date:		April 20, 2011
	Desc:		Searches for a student by name or ID
				
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<cfscript>
		// Data Validation
		if ( NOT LEN(FORM.familyLastName) AND NOT LEN(FORM.studentID) ) {
			// Error Message
			SESSION.formErrors.Add('You must enter one of the criterias below');			
		} else if ( LEN(FORM.familyLastName) AND LEN(FORM.studentID) ) {
			// Error Message
			SESSION.formErrors.Add('You must select only ONE of the criterias below');		
		}
		
		// Check if there are errors
		if ( SESSION.formErrors.length() ) {			
			// Relocate to Inital page and display error message
			Location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&errorSection=searchStudent", "no");
		}
	</cfscript>

    <cfquery name="qSearchStudent" datasource="MySql">
        SELECT 
            s.studentID, 
            s.firstName, 
            s.familyLastName,
            p.programName
        FROM 
            smg_students s
        INNER JOIN
        	smg_programs p ON p.programID = s.programID
                AND
                    p.startDate >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('yyyy', -1, now())#">
        WHERE 
            s.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">

		<cfif LEN(FORM.familyLastName)>
            AND 
                s.familyLastName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#FORM.familyLastName#%">
        </cfif>
        
        <cfif VAL(FORM.studentID)>
            AND 
                s.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">
        </cfif>

        ORDER BY 
            <cfswitch expression="#URL.orderBy#">
            
                <cfcase value="studentID">
                    s.studentID,
                    s.familyLastName 
                </cfcase>
                
                <cfcase value="firstName">
                    s.firstName, 
                    s.familyLastName 
                </cfcase>
        
                <cfcase value="familyLastName">
                    s.familyLastName, 
                    s.firstName
                </cfcase>
    
                <cfdefaultcase>
                    s.familyLastName, 
                    s.firstName
                </cfdefaultcase>
    
            </cfswitch>
                 
    </cfquery>
	
    <cfscript>
		// If only one student is found, locate to select representative page
		if ( qSearchStudent.recordCount EQ 1 ) {
			location("#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=listStudentRepresentatives&studentID=#qSearchStudent.studentID#", "no");
		}
	</cfscript>
    
</cfsilent>

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

<cfoutput>

    <div style="margin-top:10px;">Specify ONLY ONE Student from the list below:</div>
    
    <form name="myform" method="post" action="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=selectPayment">
        <table width="100%" cellpadding="4" cellspacing="0" style="border:1px solid ##010066; margin-top:20px;">
            <tr>
                <td colspan="5" style="background-color:##010066; color:##FFFFFF; font-weight:bold;">Student Search</td>
            </tr>
            <tr style="background-color:##E2EFC7; font-weight:bold;">
                <td width="4%">&nbsp;</td>
                <td width="10%"><a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=studentID&familyLastName=#form.familyLastName#&userid=#form.studentID#">ID</a></td>
                <td width="25%">
					<a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=familyLastName&familyLastName=#form.familyLastName#&userid=#form.studentID#">Last Name</a>, 	
                    <a href="#CGI.SCRIPT_NAME#?curdoc=userPayment/index&action=searchStudent&order=firstName&familyLastName=#form.familyLastName#&userid=#form.studentID#">First Name</a>                
                </td>
                <td width="25%">Program</td>
                <td width="36%">Actions</td>
            </tr>
            
            <cfloop query="qSearchStudent">	
                <tr bgcolor="###iif(qSearchStudent.currentRow MOD 2 ,DE("FFFFFF") ,DE("FFFFE6") )#">
                    <td><input type="checkbox" name="studentID" id="student#qSearchStudent.currentrow#" value="#qSearchStudent.studentID#" onClick="countChoices(this)"></td>
                    <Td>
                        <label for="student#qSearchStudent.currentrow#">#qSearchStudent.studentID#</label>
                    </td>
                    <td>
                        <label for="student#qSearchStudent.currentrow#">#qSearchStudent.firstName# #qSearchStudent.familyLastName#</label>
                    </td>
                    <td>
                    	#qSearchStudent.programName#
                    </td>
                    <td>
                        <a href="javascript:openPopUp('userPayment/index.cfm?action=studentPaymentHistory&studentID=#studentID#', 700, 500);" class="nav_bar">[ Payment History ]</a>
                    </td>
                </tr>
            </cfloop>
        
            <cfif VAL(qSearchStudent.recordCount)>
                <tr style="background-color:##E2EFC7;">
                    <td colspan="5" align="center"> <input name="submit" type="image" src="pics/next.gif" border="0" alt="next"></td>
                </tr>
            <cfelse>
                <tr>
                    <td colspan="5" align="center">Sorry, none students have matched your criteria. <br>Please change your criteria and try again.</td>
                </tr>
                <tr style="background-color:##E2EFC7;">
                    <td align="center" colspan="5"><img border="0" src="pics/back.gif" onClick="javascript:history.back()"></td>
                </tr>
            </cfif>
            
        </table>
    
    </form>
    
</cfoutput>