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
                    <link rel="stylesheet" href="../linked/css/datePicker.css" type="text/css"> <!-- Date Picker Style -->
					<link media="screen" rel="stylesheet" href="../linked/css/colorbox.css" /> <!-- Modal ColorBox -->
					<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
                    <script type="text/javascript" src="../linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput -->
                    <script type="text/javascript" src="../linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
                    <script type="text/javascript" src="../linked/js/date.js "></script> <!-- JQuery date picker plugin -->
                    <script type="text/javascript" src="../linked/js/jquery.datePicker.js "></script> <!-- JQuery.datePicker.js -->
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
            
            
            <!--- Email Header --->
            <cfcase value="email">

            </cfcase>
    
        </cfswitch>
    
    </cfoutput>
    	
</cfif>