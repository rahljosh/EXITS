<!--- ------------------------------------------------------------------------- ----
	
	File:		errorMessage.cfm
	Author:		Marcus Melo
	Date:		July 12, 2012
	Desc:		This page is called by Application.cfc onError Method
				It should not include any code from outside otherwise 
				a infinite loop of errors might happen.

	Updated:

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfscript>
		// Set Error ID
		vErrorID = "#CLIENT.userID#-#dateformat(now(),'mmddyyyy')#-#timeformat(now(),'hhmmss')#";
	</cfscript>
	
</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>EXITS - System Error</title>
    <meta name="description" content="EXITS" />
    <meta name="keywords" content="EXITS Online Application, Host Family, Exchange Program, Students" />
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="smg.css" type="text/css">
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
</head>
<body>

<cfoutput>

<!--- Table Header --->
<table width="80%" align="center" cellpadding="0" cellspacing="0" border="0" style="margin-top:30px;">
    <tr valign="middle" height="24">
        <td width="13" height="24" background="pics/header_leftcap.gif">&nbsp;</td>
        <td width="26" background="pics/header_background.gif"><img src="pics/students.gif"></td>
        <td background="pics/header_background.gif"><h2>EXITS - System Error</h2></td>
        <td width="17" background="pics/header_rightcap.gif">&nbsp;</td>
    </tr>
</table>

<!--- Error Message --->
<table width="80%"align="center" cellpadding="4" cellspacing="0" border="0" class="section">
	<tr>
    	<td width="10%">&nbsp;</td>
    	<td width="80%">
        	
            <table width="100%" cellSpacing="0" cellPadding="0" border="0">
                <tr>
                    <td width="6"><img src="http://www.phpusa.com/internal/pics/table-borders/red-err-lefttopcorner.gif" width="6" height="6"></td>
                    <td bgColor="##bb0000" height="6"><img src="pics/p_spacer.gif" height="6" width="1"></td>
                    <td width="6"><img src="http://www.phpusa.com/internal/pics/table-borders/red-err-righttopcorner.gif" width="6" height="6"></td>
                </tr>                
                <tr>
                	<td bgColor="##bb0000" colspan="3" height="50">
                    	
                        <table width="100%" cellSpacing="0" cellPadding="0" border="0">
                            <tr>
                            	<td align="center"><img src="http://www.phpusa.com/internal/pics/error-exclamate.gif"></td>
                            	<td align="left" style="color:##FFFFFF">
                                    <p style="font-weight:bold;">
                                        Oops!! An error has ocurred.
                            		</p>
                                    
                                    <p>Error ID: #vErrorID#</p>
	                            </td>
                            </tr>
                        </table>
                    </td>
                </tr>  
                <tr>
                    <td width="6"><img src="http://www.phpusa.com/internal/pics/table-borders/red-err-leftbottcorner.gif" width="6" height="6"></td>
                    <td bgColor="##bb0000" height="6"><img src="pics/p_spacer.gif" height="6" width="1"></td>
                    <td width="6"><img src="http://www.phpusa.com/internal/pics/table-borders/red-err-rightbottomcorner.gif" width="6" height="6"></td>
                </tr>
            </table> <br />
			
            <p>Do not worry, an email has been submitted to the support folks and they will fix it as soon as possible.</p>
            
            <p>
            	If you would like to specify more information that you feel would help, please follow this link or reference the ID number in an email to:
	            <a href="mailto:#APPLICATION.CFC.UDF.getSessionEmail(emailType='support')#?subject=ErrorID: #vErrorID#">#APPLICATION.CFC.UDF.getSessionEmail(emailType='support')#</a>
            </p>
            
            <p>You may or may not receive an email asking about more information or status update of the issue, depending on what the error is.</p>
            
            <p>Please close this window or click on your browser's back button.</p>
        </td>
    	<td width="10%">&nbsp;</td>
    </tr>
</table>    

<!--- Footer of Table --->
<table width="80%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr valign="bottom">
		<td width="9" valign="top" height=12><img src="pics/footer_leftcap.gif"></td>
		<td width="100%" background="pics/header_background_footer.gif"></td>
		<td width="9" valign="top"><img src="pics/footer_rightcap.gif"></td>
	</tr>
</table>

</cfoutput>