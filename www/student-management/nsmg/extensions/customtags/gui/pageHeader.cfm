<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		February 23, 2011
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
			includeTopBar="1"
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
		name="ATTRIBUTES.includeTopBar"
		type="integer"
        default="1"
		/>

	<cfparam 
		name="ATTRIBUTES.companyID"
		type="integer"
        default="#CLIENT.companyID#"
		/>

    <cfswitch expression="#CLIENT.companyID#">
        
        <cfcase value="1,2,3,4,12,13">
            <cfset setCompanyColor='##0054A0'>
        </cfcase>
    
        <cfcase value="10">
            <cfset setCompanyColor='##98012E'>
        </cfcase>
    
        <cfcase value="11">
            <cfset setCompanyColor='##00b3d9'>
        </cfcase>
    
        <cfdefaultcase>
            <cfset setCompanyColor='##0054A0'> 
        </cfdefaultcase>
    
    </cfswitch>

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
               	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                    <title>EXITS</title>
                    <meta name="description" content="EXITS" />
                    <meta name="keywords" content="EXITS Online Application, Host Family, Exchange Program, Students" />
                    <link rel="shortcut icon" href="../pics/favicon.ico" type="image/x-icon" />
                    <link rel="stylesheet" href="../smg.css" type="text/css">
                    <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
					<link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
					<cfoutput>
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
                        <script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
                        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                    </cfoutput>        
                    <script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
                    <script type="text/javascript" src="../linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
                    <script type="text/javascript" src="../linked/js/basescript.js "></script> <!-- BaseScript -->
                </head>
                <body>
            </cfcase>

    
            <!--- Application Header --->
            <cfcase value="application">

            </cfcase>


            <!--- Print Header --->
            <cfcase value="Print">

			</cfcase>
            
            
            <!--- PDF Header --->
            <cfcase value="pdf">     
                <table cellspacing="1" style="width: 100%;">
                    <tr>
                        <td>
                            <img src="#APPLICATION.SITE.URL.pics#/#CLIENT.companyID#_short_profile_header.jpg" />
						</td>
					</tr>
				</table>                                                            
            </cfcase>

        </cfswitch>
    
    </cfoutput>
    	
</cfif>