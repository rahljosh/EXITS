<!--- ------------------------------------------------------------------------- ----
	
	File:		acceptance_letter.cfm
	Author:		Marcus Melo
	Date:		May 4, 2011
	Desc:		Student Acceptance Letter

	Updated:  	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

    <cfparam name="URL.studentID" default="0">
	
    <cfscript>
		if ( VAL(URL.studentID) ) {
			CLIENT.studentID = URL.studentID;
		}	
		
		// Get Student Info
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentByID(studentID=CLIENT.studentID);
	</cfscript>

	<!-----Company Information----->
    <cfinclude template="../querys/get_company_short.cfm">
    
    <!-----Intl. Agent----->
    <cfquery name="GetIntlReps" datasource="MySQL">
        SELECT 
        	companyid, 
            firstName,
            lastName,
            businessname, 
            fax, 
            email
        FROM 
        	smg_users 
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.intrep#">
    </cfquery>
    
    <!-----Program Name----->
    <cfquery name="qGetProgramName" datasource="MySQL">
        SELECT 
        	programname, 
            programtype
        FROM 
        	smg_programs
        INNER JOIN 
        	smg_program_type ON type = programtypeid
        WHERE 
        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.programid#">
    </cfquery>

    <cfquery name="qGetCurrentUser" datasource="MySql">
	    SELECT 
        	userID,
            email, 
            firstname, 
            lastname
    	FROM 
        	smg_users
	    WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userID#">
    </cfquery>
    
    <!-----Facilitator----->
    <Cfquery name="qGetFacilitator" datasource="MySQL">
        SELECT
 	      concat(vuh.`facilitator first name`, ' ',vuh.`facilitator last name`) as facilitatorname,
          vuh.`facilitator email` AS facilitatoremail  
        FROM 
        	v_user_hierarchy vuh
        LEFT OUTER JOIN
            smg_students s on vuh.`Area Rep ID` = s.arearepID   
        WHERE 
        	arearepid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetStudentInfo.arearepid)#">
        LIMIT 1
    </Cfquery>
    
	<!--- Display only for ESI --->
    <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>

        <cfquery name="qESIDistrictChoice" datasource="MySQL">
            SELECT 
                opt1.name as option1,
                opt2.name as option2,
                opt3.name as option3
            FROM 
                smg_student_app_options appo
            LEFT OUTER JOIN
                applicationLookup opt1 ON opt1.fieldID = appo.option1 
                    AND 
                        opt1.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIDistrictChoice">
            LEFT OUTER JOIN
                applicationLookup opt2 ON opt2.fieldID = appo.option2 
                    AND 
                        opt2.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIDistrictChoice">
            LEFT OUTER JOIN
                applicationLookup opt3 ON opt3.fieldID = appo.option3 
                    AND 
                        opt3.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIDistrictChoice">
            WHERE 
                appo.studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.studentid#">
            AND
                appo.fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIDistrictChoice">
        </cfquery>

   	</cfif>     

</cfsilent>

<link rel="stylesheet" href="reports.css" type="text/css">

<style type="text/css">
	<!--
	.style1 {font-size: 13px}
	.application_section_header{
		border-bottom: 1px dashed Gray;
		text-transform: uppercase;
		letter-spacing: 5px;
		width:100%;
		text-align:center;
		background;
		background: DCDCDC;
		font-size: small;
	}
	.acceptance_letter_header {
		border-bottom: 1px dashed Gray;
		text-transform: capitalize;
		letter-spacing: normal;
		width:100%;
		text-align:left;
	}
	-->
</style>

<cfoutput>

<cfsavecontent variable="emailAcceptanceLetter">
    
    <cfinclude template="email_intl_header.cfm">

    <hr width="520" align="center"><br>
    
    <table width="650" border="0" align="center" cellspacing="2" cellpadding="4">
        <tr>
            <td>
                <div align="justify">
                
                    <span class="application_section_header">
                        <font size=+1><b><u>RECEIPT AND ACCEPTANCE NOTIFICATION</u></b></font>
                    </span>
                    
                    <!--- Do Not Display for ESI --->
                    <cfif NOT ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                        <p style="margin-top:15px; margin-bottom:15px">
                            The application for the following student(s) has been accepted. Not only is this a
                            notification of acceptance but it is also, in some cases, a notice that additional
                            information is needed in order to adhere to United States Department of State regulations
                            and to ensure that the student will be easily placed. Please send the requested information
                            <b>in English </b>as soon as possible. It is extremely important!!! If a student has been denied you will be
                            notified with a separate letter. (If a student has scheduled dates  for upcoming 
                            immunizations, please make sure that he/she obtains proof in writing from their doctor that
                            the immunizations have been completed).
                        </p>
                        <p style="margin-top:15px; margin-bottom:15px">
                        From this point on, the student facilitator will serve as the primary contact for questions 
      					regarding specific students. Student facilitator information can be found below and also by clicking on the 
                        &quot;Students&quot; tab of your EXITS homepage and clicking on the student you wish to find. From there, 
                        you will be directed to the student homepage. On the left side of the page, beneath the student photo, 
                        you will see the name of the student facilitator listed. If you click on the student facilitator name, an 
                        email window will open automatically for you to contact the student facilitator directly. </p>
                    </cfif>  
                                      
                </div>
            </td>
        </tr>
    </table>
    

    <table width="650" border="0" align="center" cellspacing="2" cellpadding="4">
        <tr>
            <td colspan="4">
                <b>Program:</b> #qGetProgramName.programname# &nbsp; - &nbsp; #qGetProgramName.programtype#
          </td>
		</tr>            
        <tr>
            <td colspan="4"><hr width=100% align="center"></td>
        </tr>
        <tr>
            <td>
                <strong>Student ID</strong>
            </td>
            <td>
                <strong>Student Name</strong>
            </td>
            <td>
                <strong>Missing Documents</strong>
            </td>
            <!--- Display only for ESI --->
            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                <td>
                    <strong>District Applied For</strong>
                </td>
            </cfif>
        </tr>
        <tr>
            <td valign="top">
                <span class="style1">###qGetStudentInfo.studentID#</span>
            </td>
            <td valign="top">
                <span class="style1">#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname#</span>
            </td>
            <td valign="top">
                <span class="style1">#qGetStudentInfo.other_missing_docs#</span>
            </td>
            <!--- Display only for ESI --->
            <cfif ListFind(APPLICATION.SETTINGS.COMPANYLIST.ESI, CLIENT.companyID)>
                <td valign="top">
                    <p>1st Choice: #qESIDistrictChoice.option1#</p>	
                    <p>2nd Choice: #qESIDistrictChoice.option2#</p>	
                    <p>3rd Choice: #qESIDistrictChoice.option3#</p>	
                </td>
            </cfif>
        </tr>    
        
        <tr>
            <td colspan="4"><hr width="100%" align="center"></td>
        </tr>        

        <!--- Display Message if student is assigned to Brian - Approved region --->
        <cfif qGetStudentInfo.regionAssigned EQ 1462>
            <tr>
                <td colspan="4">
                    We thank you for submitting your application early but we have not begun assigning applications to regions for your program yet. 
                    Therefore, you will find that this application has been assigned to the approved region for the time being.
                </td>
            </tr>                        
        </cfif>
    </table>

    <table width="650" border="0" align="center" cellspacing="2" cellpadding="4">
        <tr>
            <td>
                <p>Thanks,</p>
                <p>#qGetFacilitator.facilitatorname#<br> 
                    International Student Exchange Facilitator
              </p>                
            </td>
        </tr>
    </table>
    
    </body>
    </html>
    
</cfsavecontent>

<!--- Send Out Email --->
<cfinvoke component="nsmg.cfc.email" method="send_mail">
	<cfinvokeargument name="email_to" value="#GetIntlReps.email#">
	<cfinvokeargument name="email_bcc" value="#qGetCurrentUser.email#">
    <cfinvokeargument name="email_replyto" value="#qGetCurrentUser.email#">
	<cfinvokeargument name="email_from" value="#CLIENT.support_email#">
	<cfinvokeargument name="email_subject" value="Receipt and Acceptance Letter for #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# ( ###qGetStudentInfo.studentid# )">
	<cfinvokeargument name="email_message" value="#emailAcceptanceLetter#">
	<cfinvokeargument name="includeTemplate" value="0">
</cfinvoke>       


<!--- Display Message --->   
<span class="application_section_header">Acceptance Letter</span>

<div class="row"><br />

    <div align="center"><h2><u>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# ( #qGetStudentInfo.studentid# )</u></h2></div>

    <table border="0" align="center" width="99%" bordercolor="C0C0C0" valign="top" cellpadding="3" cellspacing="1">
        <tr align="center" bgcolor="ACB9CD">
            <td><span class="get_Attention">The Acceptance Letter has been sent to #GetIntlReps.businessname# at #GetIntlReps.email#</span></td>
        </tr>
        <tr>
            <td align="center" bgcolor="ACB9CD">
                <input type="image" value="back" src="../pics/back.gif" onClick="javascript:history.back()">  &nbsp;  &nbsp;  &nbsp;  &nbsp;
                <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
            </td>
        </tr>
    </table>

</div>

</cfoutput>