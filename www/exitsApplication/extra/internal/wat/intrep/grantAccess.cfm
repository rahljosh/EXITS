<!--- ------------------------------------------------------------------------- ----
	
	File:		grantAccess.cfm
	Author:		Marcus Melo
	Date:		November 04, 2010
	Desc:		Grant Access to Intl. Rep. Accounts

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />	
    
    <!--- Param URL Variables --->
    <cfparam name="URL.uniqueID" default="">
    <!--- Param FORM Variables --->    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userID" default="0">
    
    <cfscript>
		// Get User By UniqueID
		qGetIntlRep = APPLICATION.CFC.USER.getUserByUniqueID(uniqueID=URL.uniqueID);
		
		if ( FORM.submitted ) {
			
			// Grant Access to Intl. Rep.
			APPLICATION.CFC.USER.grantAccess(
				userID=VAL(FORM.userID),
				userType=8
			);
			
			// Set Page Message
			SESSION.pageMessages.Add("Access to Extra successfully granted. This window will close in 2 seconds");
			
		} 
	</cfscript>
    
</cfsilent> 

<!--- Copy of Header.cfm - Place in a custom tag in the future --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="CSB International">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXTRA - Exchange Training Abroad</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../../style.css" type="text/css">
    <link rel="stylesheet" href="../../linked/css/onlineApplication.css" type="text/css">
    <link rel="stylesheet" href="../../linked/css/datePicker.css" type="text/css">
    <link rel="stylesheet" href="../../linked/css/baseStyle.css" type="text/css">
    <!-- Combine these into one single file -->
    <cfoutput>
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
    <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
    </cfoutput>
    <script type="text/javascript" src="../../linked/js/jquery.popupWindow.js"></script> <!-- Jquery PopUp Window -->
    <script type="text/javascript" src="../../linked/js/jquery.validate.js"></script> <!-- jquery form validation -->
    <script type="text/javascript" src="../../linked/js/jquery.metadata.js"></script> <!-- jquery form validation -->
    <script type="text/javascript" src="../../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
    <script type="text/javascript" src="../../linked/js/basescript.js"></script> <!-- baseScript -->
</head>
<body>

<cfif FORM.submitted>

	<script language="JavaScript"> 
        $(document).ready(function() {
			// Close Window			
			window.setTimeout("close();", 2000);
			// Refresh Opener
			//opener.location.reload();
        });
	</script>

</cfif>

<cfoutput>

<!--- TABLE HOLDER --->
<table width="700px" border="1" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##F4F4F4">
    <tr>
        <td>

			<br />
            
            <table width="650px" align="center" cellpadding="0" cellspacing="0">	
                <tr>
                    <td valign="top">

						<!--- Page Messages --->
                        <gui:displayPageMessages 
                            pageMessages="#SESSION.pageMessages.GetCollection()#"
                            messageType="section"
                            />
                        
                        <!--- Form Errors --->
                        <gui:displayFormErrors 
                            formErrors="#SESSION.formErrors.GetCollection()#"
                            messageType="section"
                            />
                            
					</td>
				</tr>
			</table>
                                                
            <form name="grantAccess" id="grantAccess" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
            <input type="hidden" name="submitted" value="1">
            <input type="hidden" name="userID" id="userID" value="#qGetIntlRep.userID#">
            
            <table width="650px" align="center" cellpadding="3" cellspacing="3" border="1" bordercolor="##C7CFDC" bgcolor="##ffffff">
                <tr>
                    <td>

                        <table width="100%" cellpadding="3" cellspacing="3" border="0">
                            <tr bgcolor="##C2D1EF">
                                <td colspan="2" class="style2" bgcolor="##8FB6C9">&nbsp;:: Intl. Representative - Grant Access to Extra</td>
                            </tr>
                            <tr>
                                <td width="35%" class="style1" align="right"><strong>Intl. Representative:</strong></td>
                                <td class="style1">#qGetIntlRep.businessName#</td>
                            </tr>
                            <tr>
                                <td width="35%" class="style1" align="right"><strong>Email Address:</strong></td>
                                <td class="style1">#qGetIntlRep.email#</td>
                            </tr>
                            <tr>
                                <td class="style1" align="right"><strong>Username:</strong></td>
                                <td class="style1">
                                	#qGetIntlRep.username#
                                    <cfif NOT LEN(qGetIntlRep.username)>
                                    	Email address as default.
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td class="style1" align="right"><strong>Password:</strong></td>
                                <td class="style1">
                                	#qGetIntlRep.password#
                                    <cfif NOT LEN(qGetIntlRep.password)>
                                    	Password will be generated.
                                    </cfif>
                                </td>
                            </tr>
                            <tr>
                                <td class="style1" colspan="2" align="center">
                                    <p><strong>PS:</strong> Login information is the same used for EXITS. </p>
                                    <p>Intl. Rep. is going to receive a Welcome to Extra email.</p>
                                </td>
                            </tr>
                        </table>

                    </td>
                </tr>
            </table> 
            
            <br/>

			<!---- EDIT/UPDATE BUTTONS ---->
            <cfif ListFind("1,2,3,4", CLIENT.userType)>
                <table width="650px" align="center" border="0" cellpadding="0" cellspacing="0" align="center">	
                    <tr>
                        <td align="center">
                            <input name="Submit" type="image" src="../../pics/save.gif" alt="Grant Access" border="0">
                        </td>
                    </tr>
                </table>
                <br />
            </cfif>
			
            </form>
            
		</td>		
	</tr>
</table>
<!--- END OF TABLE HOLDER --->

</cfoutput>

