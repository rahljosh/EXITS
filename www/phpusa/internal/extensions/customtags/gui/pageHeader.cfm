<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		May 5, 2011
	Desc:		This Tag displays the page header used in the login and student
				application.

	Status:		In Development
				Need to combine javascripts into one file using combine.cfc

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
		
		<!--- Page Header --->
		<gui:pageHeader
			headerType="login/application/print/email/cssOnly"
		/>
	
----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>

	<!--- Param tag attributes --->
	<cfparam 
		name="ATTRIBUTES.headerType"
		type="string"
        default=""
		/>

	<cfparam 
		name="ATTRIBUTES.width"
		type="string"
        default="100%"
		/>

	<cfparam 
		name="ATTRIBUTES.imagePath"
		type="string"
        default=""
		/>

</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>
    	
        <cfswitch expression="#ATTRIBUTES.headerType#">
    	
            <!--- Login Header --->
            <cfcase value="login">
            
            </cfcase>
    
    	
            <!--- Application with no top and left columns --->
            <cfcase value="applicationNoHeader">
                <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
                <html>
                <head>
                    <meta name="Author" content="Private High School Program">
                    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                    <title>Private High School Program</title>
                    <link rel="shortcut icon" href="../pics/favicon.ico" type="image/x-icon" />
                    <link rel="stylesheet" href="../phpusa.css" type="text/css">
                    <link rel="stylesheet" href="../linked/css/colorBox.css" type="text/css"> <!-- Color Box -->
                    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css"> <!-- Base Style -->
                    <cfoutput>
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
                        <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                    </cfoutput>
                    <script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
                    <script type="text/javascript" src="../linked/js/basescript.js"></script> <!-- Base Script -->
                </head>
                <body>

                    <table width="#ATTRIBUTES.width#" align="center" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="12" align="right" background="#ATTRIBUTES.imagePath#images/top_02.gif" >
                                <img src="#ATTRIBUTES.imagePath#images/top_01.gif" width="11" height="12">
                            </td>
                            <td width="99%" background="#ATTRIBUTES.imagePath#images/top_02.gif" height="12">&nbsp;</td>
                            <td height="12" align="left" background="#ATTRIBUTES.imagePath#images/top_02.gif" >
                                <img src="#ATTRIBUTES.imagePath#images/top_03.gif" width="11" height="12">
                            </td>
                        </tr>
                    </table>
                
					<!--- Start of Table Body --->
                    <table align="center" width="#ATTRIBUTES.width#" cellpadding="0" cellspacing="0" border="0" bgcolor="##e9ecf1" style="padding-bottom:15px;"> 
                        <tr>
                            <td>
            </cfcase>

    
            <!--- Application Header --->
            <cfcase value="application">

            </cfcase>


            <!--- Print Header --->
            <cfcase value="Print">

			</cfcase>
            
            
            <!--- PDF Header --->
            <cfcase value="pdf">     
                <table cellspacing="1" style="width:100%;">
                    <tr>
                        <td valign="top">
                            <img src="#APPLICATION.site_url#/images/logo.png" />
						</td>
                        <td valign="top">
                        	<h2>Private High School Program</h2>
                        </td>
					</tr>
				</table>                                                            
            </cfcase>

        </cfswitch>
    
    </cfoutput>
    	
</cfif>