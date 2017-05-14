<!--- ------------------------------------------------------------------------- ----
	
	File:		accountActivation.cfm
	Author:		Marcus Melo
	Date:		September 09, 2010
	Desc:		Account Activatio

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Param URL Variables --->
    <cfparam name="URL.uniqueID" default="uniqueID">
    
    <cfscript>
		// Check if we have a valid student
		qGetCandidate = APPLICATION.CFC.candidate.getCandidateByID(uniqueID=URL.uniqueID);

        applicationIsOffice = APPLICATION.CFC.ONLINEAPP.isOfficeApplication(foreignTable=APPLICATION.foreignTable, foreignID=qGetCandidate.candidateID);
		
		// Activate Account
		if (( qGetCandidate.recordCount AND qGetCandidate.applicationStatusID EQ 1 ) OR (qGetCandidate.recordCount AND qGetCandidate.applicationStatusID EQ 12)) {
			
			// Update Candidate Session Variables
			APPLICATION.CFC.CANDIDATE.setCandidateSession(
				candidateID=qGetCandidate.candidateID,
				doLogin=0
			);

			// Activate Application
			APPLICATION.CFC.ONLINEAPP.submitApplication(candidateID=qGetCandidate.candidateID);
			
			/*
			APPLICATION.CFC.candidate.activateApplication(
				candidateID=qGetCandidate.candidateID,
				email=qGetCandidate.email
			);
			*/
						
		}
	</cfscript>
    
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXTRA - Exchange Training Abroad - Account Activation</title>
    <link href="internal/style.css" rel="stylesheet" type="text/css" />
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
</head>
<body>

<cfoutput>
            
<table width="720" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-top:150px;">
    <tr>
        <td height="389" background="login.gif">
            
            <table width="91%" border="0" cellspacing="0" cellpadding="0" style="margin-top:50px;">
                <tr>
                    <td width="55%">&nbsp;</td>
                    <td width="45%">
                        
                        <table width="300px"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="##999999">
                            <tr>
                                <td bgcolor="##FFFFFF" class="style1">
                                
                                    <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="1" bordercolor="##DDE0E5">
                                        <tr>
                                            <td bordercolor="##E9ECF1" bgcolor="##FF7E0D" class="style4">
                                                <span class="style2" style="margin-left:5px; font-weight:bold">Account Activation:</span> 
                                            </td>
                                        </tr>
                                        
                                        <!--- Account Activated --->
										<cfif (qGetCandidate.recordCount AND qGetCandidate.applicationStatusID EQ 1) OR (qGetCandidate.recordCount AND qGetCandidate.applicationStatusID EQ 12)>
                                            <tr>
                                                <td>
                                                    Dear #qGetCandidate.firstname# #qGetCandidate.lastName#, <br /><br />
                                                    
                                                    <strong> Your account has been activated. </strong> <br /><br />
                                                    
                                                    <cfif qGetCandidate.applicationStatusID NEQ 12 >
                                                        An email has been sent to you with your login information. <br /><br />
                                                    </cfif>
                                                    
                                                    <cfif applicationIsOffice NEQ 1>
                                                        Please <a href="index.cfm">click here</a> to login into E<font color="##FF6600">X</font>TRA. <br />
                                                    </cfif><br />

                                                </td>
                                            </tr>
                                        <!--- Account Already Active --->
                                        <cfelseif qGetCandidate.applicationStatusID NEQ 1 AND qGetCandidate.applicationStatusID NEQ 12>
                                            <tr>
                                                <td>
                                                    Dear Candidate, <br /><br />
                                                   
                                                    <strong> Your account is already activated. </strong> <br /><br />
													
                                                    <cfif applicationIsOffice NEQ 1>
                                                    Please <a href="index.cfm">click here</a> to login into E<font color="##FF6600">X</font>TRA. <br />
                                                    </cfif><br />
                                                </td>
                                            </tr>
										<!--- Could not locate account --->
										<cfelse>
                                            <tr>
                                                <td>
                                                    Dear Candidate, <br /><br />
                                                   
                                                    We could not locate your account. <br /><br />
                                                    
                                                    <strong> Your account has NOT been activated. </strong> <br /><br />
                                                    
                                                    Your welcome e-mail includes a link for beginning the activation process. 
                                                    Please make sue you clicked on the link emailed to you from E<font color="##FF6600">X</font>TRA. <br /><br />
													
                                                    In the event that you lose the account activation link, 
                                                    please contact your International Representative for assistance. <br /><br />
                                                </td>
                                            </tr>
                                        </cfif>
                                        
                                    </table>
                                    
                            	</td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table>
    
        </td>
    </tr>
</table>

</cfoutput>

</body>
</html>
