<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables ---->
    <cfparam name="studentID" default="0">

    <!--- Param Form Variables ---->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.errors" default="">
    <cfparam name="FORM.messages" default="">
    <cfparam name="FORM.check_project_help" default="">
    <cfparam name="FORM.field_project_help" default="">
    
    <cfscript>
		// Get Student Information 
		qStudentInfo = AppCFC.STUDENT.getStudents(studentID=studentID); 
	</cfscript>
	
    <!--- Form submitted --->
	<cfif VAL(FORM.submitted)>
		
    	<cfscript>
			if (LEN(FORM.field_project_help) AND NOT IsDate(FORM.field_project_help) ) {
				FORM.errors = "Please enter a valid date (mm/dd/yyyy)";
				FORM.field_project_help = '';
			}		
			
			// There are no errors
			if (NOT LEN(FORM.errors)) {
				// Insert Training
				APPCFC.STUDENT.setProjectHelpDate (
					studentID=VAL(FORM.studentID),
					dateProjectHelp=FORM.field_project_help
				);

				// Re-set Form Variables
				FORM.check_project_help = '';
				FORM.field_project_help = '';
				
				// Set Successfull message
				FORM.messages = '<span class="get_Attention">Page updated successfully</span>';
				
				// Get updated query
				qStudentInfo = AppCFC.STUDENT.getStudents(studentID=studentID); 
			}
		</cfscript>

	</cfif>

    <cfscript>
        if ( LEN(qStudentInfo.date_project_help_completed) ) {
            FORM.check_project_help = 1;		 
        }			
        FORM.field_project_help = qStudentInfo.date_project_help_completed;
    </cfscript>

	<!--- Page Footer --->
	<cfsavecontent variable="pageFooter">
        <table width="100%" cellpadding="0" cellspacing="0" border="0">
            <tr valign="bottom" >
                <td width="9" valign="top" height=12><img src="../pics/footer_leftcap.gif" ></td>
                <td width="100%" background="../pics/header_background_footer.gif"></td>
                <td width="9" valign="top"><img src="../pics/footer_rightcap.gif"></td>
            </tr>
        </table>
    </cfsavecontent>
    
</cfsilent>

<cfoutput>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="../smg.css" type="text/css">
<script src="../linked/js/jquery.js" type="text/javascript"></script>
<script src="../linked/js/basescript.js" type="text/javascript"></script>
<title>Project Help - Student: #qStudentInfo.firstName# #qStudentInfo.familyLastName# (###qStudentInfo.studentID#)</title>
</head>

<body bgcolor="white" background="white.jpg">

<div id="information_window"> 	
    
    <!--- Header --->
    <table width="100%" cellpadding="0" cellspacing="0" border="0" height="24">
        <tr valign=middle height="24">
            <td height="24" width=13 background="../pics/header_leftcap.gif">&nbsp;</td>
            <td width="26" background="../pics/header_background.gif"><img src="../pics/students.gif"></td>
            <td background="../pics/header_background.gif"><h2>Project Help Check Off</h2></td>
            <td width="17" background="../pics/header_rightcap.gif">&nbsp;</td>
        </tr>
    </table>

	<!--- Check if we have a valid student --->
	<cfif NOT VAL(qStudentInfo.recordCount)>
    
        <table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">
            <tr>	
                <td>
					The system could not find student ###VAL(studentID)#. <br />
                    Please try again.                
                </td>
            </tr>
        </table>

		<!--- Display Page Footer --->
		#pageFooter#
        
		<cfabort>
        
    </cfif>

	<!--- Check if we have a valid user logged in --->
	<cfif CLIENT.usertype GT 5>
    
        <table width="100%" border="0" cellpadding="4" cellspacing="0" class="section">
            <tr>	
                <td>
					You do not have access rights to see this page. If you think this is an error, please re-login into the system.                
                </td>
            </tr>
        </table>

		<!--- Display Page Footer --->
		#pageFooter#
        
		<cfabort>
        
    </cfif>

    <form action="#cgi.SCRIPT_NAME#" method="post">
   		<input type="hidden" name="submitted" value="1" />
    	<input type="hidden" name="studentID" value="#studentID#" />
   
        <table width="100%" border="0" cellpadding="4" cellspacing="4" class="section">
            <cfif LEN(FORM.messages) OR LEN(FORM.errors)>
            <tr>
                <td colspan="2" align="center">
                    <!--- Updated message --->
					<cfif LEN(FORM.messages)>                        
                        #FORM.messages#
                    </cfif>

					<!--- Error messages --->
					<cfif LEN(FORM.errors)>
                        Please review the following: <br />
                        <div style="color:##F00">
                            #FORM.errors#
                        </div>
                    </cfif>
                </td>
            </tr>
            </cfif>
            
            <tr>
                <td>
                	
                    <input type="checkbox" name="check_project_help" id="check_project_help" value="1" OnClick="checkInsertDate('check_project_help', 'field_project_help');" <cfif LEN(FORM.field_project_help)>checked="checked"</cfif> >
                    &nbsp;
                	<label for="check_project_help">Project Help Check Off</label>
                </td>
                <td align="left">
                	<label for="field_project_help">Date:</label>
                    &nbsp;
                    <input type="text" name="field_project_help" id="field_project_help" size="9" value="#DateFormat(FORM.field_project_help, 'mm/dd/yyyy')#">
                </td>
            </tr>
            
            <tr>
            	<td colspan="2">
                	<strong>Project Help Verification form must be sent to program manager.</strong>                     
                </td>
			</tr>          
        </table>
                
        <table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
            <tr>
                <td align="right" width="50%">
                    <input name="Submit" type="image" src="../pics/update.gif" border="0" alt=" update ">
                    &nbsp;
                </td>
                <td align="left" width="50%">
                    &nbsp;
                    <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
                </td>
            </tr>
        </table>
        
    </form>
    
	<!--- Display Page Footer --->
    #pageFooter#
    	
</div>

</body>
</html>

</cfoutput>