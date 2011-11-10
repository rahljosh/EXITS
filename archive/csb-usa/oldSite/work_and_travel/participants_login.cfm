<!--- ------------------------------------------------------------------------- ----
	
	File:		participants_login.cfm
	Author:		Marcus Melo
	Date:		January, 15 09
	Desc:		

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="fileName" default="">    
    
	<!--- Param Form Variables --->
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.userName" default="">
    <cfparam name="FORM.password" default="">

	<cfscript>
		// Create Structure to store errors
		Errors = StructNew();
		// Create Array to store error messages
		Errors.Messages = ArrayNew(1);

		// Declare file List
		fileList = "W&T_StudHandbook.pdf,Job_Offer_Agreement_FULL.pdf"; 	
	</cfscript>

	<!--- Check if we have a valid file request --->
	<cfif NOT ListFind(fileList, fileName)>
		<cflocation url="participants.cfm" addtoken="no">
    </cfif>

	<!--- Check if user is already logged in --->
	<cfif VAL(APPLICATION.WAT.isLoggedIn)>        
        <cflocation url="files/#fileName#" addtoken="no">
    </cfif>

	<!--- FORM submitted --->
	<cfif VAL(FORM.submitted)>
    	
		<cfscript>
            // Data Validation

            // userName
            if ( NOT LEN(FORM.userName) ) {
                ArrayAppend(Errors.Messages, "Enter a username.");			
            }
			
            // userName
            if ( LEN(FORM.userName) AND FORM.userName NEQ APPLICATION.WAT.userName ) {
                ArrayAppend(Errors.Messages, "Username is invalid. Please try again");			
            }

            // Password
            if ( NOT LEN(FORM.password) ) {
                ArrayAppend(Errors.Messages, "Enter a password.");			
            }
			
            // Password
            if ( LEN(FORM.password) AND FORM.password NEQ APPLICATION.WAT.password ) {
                ArrayAppend(Errors.Messages, "Password is invalid. Please try again");			
            }
		</cfscript>

        <!--- There are no errors --->
        <cfif NOT VAL(ArrayLen(Errors.Messages))>

			<cfscript>
				// Set logged in = 1
				APPLICATION.WAT.isLoggedIn = 1;
			</cfscript>

			<cflocation url="files/#fileName#" addtoken="no">

		</cfif>
            
    </cfif>

</cfsilent>

<html>
<head>
<title>:: CSB International : Participants :: Login ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="style.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<cfoutput>
<table width="871" height="600" border="0" align="center" cellpadding="0" cellspacing="0" id="Table_01">
	<tr>
		<td height="131" background="images/top.jpg"><table width="99%" border="0">
		  <tr>
		    <td height="90" colspan="2">&nbsp; &nbsp; &nbsp; &nbsp; <a href="../index.cfm"><img src="images/transparent.gif" alt="" width="250" height="83" border="0"></a></td>
	      </tr>
		  <tr>
		    <td width="325">&nbsp;</td>
		    <td><cfinclude template="menu.cfm"></td>
	      </tr>
	    </table></td>
	</tr>
	<tr>
		<td height="417" valign="top" background="images/back-table.png"><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%" height="26">&nbsp;</td>
		    <td width="90%" valign="bottom" class="top"><a href="##" class="LinkItens">Home</a> &gt; <a href="participants.cfm" class="LinkItens">Participants</a> &gt; Log In</td>
		    <td width="5%">&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="17" colspan="3"><hr width="94%" color="##CCCCCC"></td>
	      </tr>
		  <tr>
		    <td colspan="3">&nbsp;</td>
	      </tr>
		  </table>
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		  <tr>
		    <td width="5%">&nbsp;</td>
		    <td width="90%" class="text" align="center">

                <form name="login" action="#cgi.SCRIPT_NAME#" method="post">
                	<input type="hidden" name="submitted" value="1">
                    <input type="hidden" name="fileName" value="#fileName#">
                    
                    <table width="220" border="0" align="center" bgcolor="##666666">
						
                        <tr>
                            <td class="MenuItens">Login:</td>
                        </tr>
                        <tr>
                            <td bgcolor="##FFFFFF">

                                <table width="100%" border="0" cellpadding="5" cellspacing="0" class="text">
									<!--- Display Errors --->
									<cfif VAL(ArrayLen(Errors.Messages))>
                                        <tr>
                                            <td class="MenuItens" colspan="2" align="center">
                                                <p style="color:##FF0000">
                                                    Please review the following items: <br>
                                                    <cfloop from="1" to="#ArrayLen(Errors.Messages)#" index="i">
                                                       <span style="padding-left:25px;">
                                                           #Errors.Messages[i]# <br> 
                                                       </span>       	
                                                    </cfloop>
                                                </p>
                                            </td>
                                        </tr>                                                    
                                    </cfif>	
                                    <tr>
                                        <td width="21%"><strong>Username:</strong></td>
                                        <td width="79%"><input type="userName" name="userName" value="#FORM.userName#" class="text" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Password:</strong></td>
                                        <td><input type="password" name="password" value="#FORM.password#" class="text" size="30"></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="center"><input type="submit" name="Submit" class="text" value="Submit"></td>
                                    </tr>
                                </table>
                                
							</td>                                           
						</tr>
					</table>                                                    
                    
                </form>
                
            </td>
		    <td width="5%">&nbsp;</td>
	      </tr>
      </table>
		</td>
	</tr>
	<tr>
		<td height="52" background="images/bottom.png" align="center"><cfinclude template="bottom.cfm"></td>
	</tr>
</table>

</cfoutput>

</body>
</html>