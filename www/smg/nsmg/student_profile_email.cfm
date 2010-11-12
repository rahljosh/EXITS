<!--- ------------------------------------------------------------------------- ----
	
	File:		student_profile_email.cfm
	Author:		Marcus Melo
	Date:		March 25, 2010
	Desc:		This page emails the simplified student profile, student letter and parent letter.

	Updated:	06/01/2010 - Letters contain personal information and should not be included in the email.	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="extensions/customtags/gui/" prefix="gui" />	
    
    <!--- CHECK SESSIONS --->
    <cfinclude template="check_sessions.cfm">
    
    <cfparam name="uniqueID" default="">
    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.isIncludeLetters" default="0">
    <cfparam name="FORM.emailTo" default="">

    <cfscript>	
		// Get Student by uniqueID
		qGetStudentInfo = APPCFC.STUDENT.getStudentByID(uniqueID=uniqueID);
				
		// Get Company
		qGetCompany = APPCFC.COMPANY.getCompanies(companyID=CLIENT.companyID);
		
		// Variables to store letters
		studentLetterContent = '';
		parentLetterContent = '';
		
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);
		
		// FORM SUBMITTED
		if ( VAL(FORM.submitted) ) {

			// Data Validation
			if ( NOT IsValid("email", FORM.emailTo) ) {
				ArrayAppend(Errors.Messages, "Please enter a valid email address");
			}

		}
	</cfscript>
    
    <cfdirectory directory="#AppPath.onlineApp.picture#" name="studentPicture" filter="#qGetStudentInfo.studentID#.*">    

	<cfdirectory directory="#AppPath.onlineApp.studentLetter#" name="studentLetter" filter="#qGetStudentInfo.studentid#.*">
    
	<cfdirectory directory="#AppPath.onlineApp.parentLetter#" name="parentLetter" filter="#qGetStudentInfo.studentid#.*">    
    
</cfsilent>

<!--- <link rel="stylesheet" href="linked/css/student_profile.css" type="text/css"> --->

<cfif NOT LEN(uniqueID)>
	You have not specified a valid studentID.
	<cfabort>
</cfif>

<cfoutput>

<link rel="stylesheet" type="text/css" href="smg.css">

<!--- Table Header --->
<gui:tableHeader
	width="380px"
    imageName="students.gif"
	tableTitle="Email Student Profile and Letters"
	tableRightTitle=""
/>

<form name="#cgi.SCRIPT_NAME#" method="post">
    <input type="hidden" name="submitted" value="1" />
    <input type="hidden" name="uniqueID" value="#uniqueID#" />
    
    <table width="380px" border="0" cellpadding="5" cellspacing="5" class="section" style="padding:15px;">
    
		<!--- Display Errors --->
        <cfif VAL(ArrayLen(Errors.Messages))>
            <tr>
                <td>
                    <font color="##FF0000">Please review the following items:</font> <br />
        
                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                        #Errors.Messages[i]#    	
                    </cfloop> <br />
                </td>
            </tr>
        </cfif>	
    
		<tr>	
			<td><b>Student: #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (###qGetStudentInfo.studentid#)</b></td>
		</tr>
		<tr>	
			<td>Please enter an email address below and click on submit.</td>
		</tr>
		<tr>	
			<td>
            	Email Address: &nbsp; <input type="text" name="emailTo" value="" size="30" maxlength="100" />			
			</td>
		</tr>
		<tr>	
			<td>
            	<input type="checkbox" name="isIncludeLetters" id="isIncludeLetters" value="1" <cfif FORM.isIncludeLetters> checked="checked" </cfif> /> 
                &nbsp; 
                <label for="isIncludeLetters">Include Student and Parent Letters</label>
			</td>
		</tr>
        <tr>	
			<td align="center">
            	<input name="Submit" type="image" src="pics/submit.gif" border=0 alt=" Send Email ">
				&nbsp; &nbsp; &nbsp;
                <input type="image" value="close window" src="pics/close.gif" alt=" Close this Screen " onClick="javascript:window.close()">
			</td>
		</tr>	
    </table>

</form>
    		
<!--- Table Footer --->
<gui:tableFooter
	width="380px"
/>


<!--- FORM Submitted --->
<cfif FORM.submitted AND NOT VAL(ArrayLen(Errors.Messages))>

	<!--- Student Profile --->
    <cfsavecontent variable="studentProfile">
        
        <!--- Include Profile Template --->
		<cfinclude template="studentProfileTemplate.cfm">
            
    </cfsavecontent>
    <!--- End of Student Profile --->
    
    
    <!--- Student Letter --->
    <cfif LEN(qGetStudentInfo.letter)>
        
        <cfsavecontent variable="studentLetterContent">  
            <div style="page-break-after:always"></div>
            <table align="center" class="profileTable">
                <tr><td><span class="profileTitleSection">STUDENT LETTER OF INTRODUCTION</span></td></tr>
                <tr>
                    <td>
                        <div class="comments">
                            #qGetStudentInfo.letter# 
                        </div> <br/>
                    </td>
                </tr>
            </table>
        </cfsavecontent>        
    
    </cfif>
    <!--- End of Student Letter --->
    
    
    <!--- Parent Letter --->
    <cfif LEN(qGetStudentInfo.familyletter)>
    
        <cfsavecontent variable="parentLetterContent"> 
            <div style="page-break-after:always"></div>
            <table align="center" class="profileTable">
                <tr><td><span class="profileTitleSection">PARENTS LETTER OF INTRODUCTION</span></td></tr>
                <tr>
                    <td>
                        <div class="comments">
                            #qGetStudentInfo.familyletter# 
                        </div> <br/>
                    </td>
                </tr>
            </table>
        </cfsavecontent>        
        
    </cfif>
    <!--- End of Parent Letter --->
    
    
    <cfsavecontent variable="emailMessage">
        
        <cfif FORM.isIncludeLetters>
	        <p>Please see attached student profile, student letter and parent letter.</p>
        <cfelse>
        	<p>Please see attached student profile.</p>
        </cfif>
        
        <p>Student Name: #qGetStudentInfo.firstName# (###qGetStudentInfo.studentid#) student profile attached.</p>
        
        <p>
            Thank you, <br />
            #qGetCompany.companyName#   
        </p>        
    </cfsavecontent>
    
    
    <!--- Create PDF File - Include Profile and Letters --->
    <cfdocument name="profile" format="pdf">
        
        <!--- Student Profile --->
        #studentProfile#	
        
        <cfif FORM.isIncludeLetters>
			<!--- Student Letter --->
            #studentLetterContent#
            
            <!--- Parent Letter --->
            #parentLetterContent#  
        </cfif>
                
    </cfdocument>
    
    
    <!--- Save PDF File --->
    <cffile action="write" file="#AppPath.temp##qGetStudentInfo.studentID#-profile.pdf" output="#profile#" nameconflict="overwrite">    
    
    
    <!--- send email --->
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
        <cfinvokeargument name="email_to" value="#FORM.emailTo#">
        <cfinvokeargument name="email_subject" value="#qGetCompany.companyShort_noColor# Student Profile - #qGetStudentInfo.firstName# (###qGetStudentInfo.studentid#)">
        <cfinvokeargument name="email_message" value="#emailMessage#">
        <cfinvokeargument name="email_from" value="#CLIENT.support_email#">
    
        <!--- Attach Students Profile --->
        <cfinvokeargument name="email_file" value="#AppPath.temp##qGetStudentInfo.studentID#-profile.pdf">
 
 		<cfif FORM.isIncludeLetters>
			<!--- Attach Students Letter --->
            <cfif studentLetter.recordcount>
                <cfinvokeargument name="email_file2" value="#AppPath.onlineApp.studentLetter##studentLetter.name#">
            </cfif>
            
            <!--- Attach Parents Letter --->
            <cfif parentLetter.recordcount>
                <cfinvokeargument name="email_file3" value="#AppPath.onlineApp.parentLetter##parentLetter.name#">
            </cfif>
		</cfif>    	
        
    </cfinvoke>

    <script language="JavaScript">
	// Close Window
    <!--
      window.close();
    //-->
    </script>

</cfif>

</cfoutput>
