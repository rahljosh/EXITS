<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		September 7, 2010
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
        default="0"
		/>

	<cfscript>
		// Get what company candidate/user is logged in
		if ( StructKeyExists(SESSION.CANDIDATE, "companyID") AND VAL(SESSION.CANDIDATE.companyID) ) {
			ATTRIBUTES.companyID = SESSION.CANDIDATE.companyID;
		} else if ( StructKeyExists(CLIENT, "companyID") AND VAL(CLIENT.companyID) ) {
			ATTRIBUTES.companyID = CLIENT.companyID;
		}
	</cfscript>

</cfsilent>

<!--- 
	Check to see which tag mode we are in. We only want to output this 
	in the start mode. 
--->
<cfif NOT CompareNoCase(THISTAG.ExecutionMode, "Start")>

	<cfoutput>
    	
        <!--- Set Up Header Information According to Program --->
        <cfswitch expression="#ATTRIBUTES.companyID#">
        	
            <!--- Trainee --->
            <cfcase value="7">

				<cfsavecontent variable="csbMetaData">            
                    <title>#APPLICATION.METADATA.Trainee.pageTitle#</title>
                    <meta name="description" content="#APPLICATION.METADATA.Trainee.pageDescription#" />
                    <meta name="keywords" content="#APPLICATION.METADATA.Trainee.pageKeywords#" />
				</cfsavecontent>   
            
				<cfsavecontent variable="csbHeader">            
                    <a href="#cgi.SCRIPT_NAME#?action=initial" title="#APPLICATION.CSB.Trainee.name# #APPLICATION.CSB.Trainee.programName#">
                        <div class="mainLogo"></div>
                        <div class="title">#APPLICATION.CSB.Trainee.name#</div>
                        <div class="subTitle">#APPLICATION.CSB.Trainee.programName#</div>
                    </a>
				</cfsavecontent>   

            	<cfsavecontent variable="csbEmailHeader">
                    <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.Trainee.name#" style="text-decoration:none; color:##000000;">
                        <span style="font-size: 1.4em;">#APPLICATION.CSB.Trainee.name#</span> <br />
                        <span style="font-size: 0.9em;">#APPLICATION.CSB.Trainee.programName#</span>
                    </a>
				</cfsavecontent>                
                                 
            </cfcase>
    		
            <!--- WAT --->
            <cfcase value="8">

				<cfsavecontent variable="csbMetaData">            
                    <title>#APPLICATION.METADATA.WAT.pageTitle#</title>
                    <meta name="description" content="#APPLICATION.METADATA.WAT.pageDescription#" />
                    <meta name="keywords" content="#APPLICATION.METADATA.WAT.pageKeywords#" />
				</cfsavecontent>   
            
				<cfsavecontent variable="csbHeader">	            
                    <a href="#cgi.SCRIPT_NAME#?action=initial" title="#APPLICATION.CSB.WAT.name# #APPLICATION.CSB.WAT.programName#">
                        <div class="mainLogo"></div>
                        <div class="title">#APPLICATION.CSB.WAT.name#</div>
                        <div class="subTitle">#APPLICATION.CSB.WAT.programName#</div>
                    </a>
				</cfsavecontent>   
                
            	<cfsavecontent variable="csbEmailHeader">
                    <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.WAT.name#" style="text-decoration:none; color:##000000;">
                        <span style="font-size: 1.4em;">#APPLICATION.CSB.WAT.name#</span> <br />
                        <span style="font-size: 0.9em;">#APPLICATION.CSB.WAT.programName#</span>
                    </a>
				</cfsavecontent>                
                                 
            </cfcase>
    		
            <!--- Default Header --->
            <cfdefaultcase>

				<cfsavecontent variable="csbMetaData">            
                    <title>#APPLICATION.METADATA.pageTitle#</title>
                    <meta name="description" content="#APPLICATION.METADATA.pageDescription#" />
                    <meta name="keywords" content="#APPLICATION.METADATA.pageKeywords#" />
				</cfsavecontent>   
            
            	<cfsavecontent variable="csbHeader">
                    <a href="#cgi.SCRIPT_NAME#?action=initial" title="#APPLICATION.CSB.name#">
                        <div class="mainLogo"></div>
                        <div class="title">#APPLICATION.CSB.name#</div>
                        <div class="subTitle">&nbsp;</div>
                    </a>
				</cfsavecontent>     

            	<cfsavecontent variable="csbEmailHeader">
                    <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.name#" style="text-decoration:none; color:##000000;">
                        <span style="font-size: 1.4em;">#APPLICATION.CSB.name#</span> <br />
                        <span style="font-size: 0.9em;">&nbsp;</span>
                    </a>
				</cfsavecontent>                
                               
            </cfdefaultcase>
            
        </cfswitch>                            
    
    
        <cfswitch expression="#ATTRIBUTES.headerType#">
    	
            <!--- Login Header --->
            <cfcase value="login">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        #csbMetaData#
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/appLogin.css" />
                        <link rel="stylesheet" media="all" type="text/css"href="../../../internal/linked/css/baseStyle.css" />
                        <script src="#APPLICATION.Path.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="../../../internal/linked/js/jquery.pstrength-min.1.2.js" type="text/javascript"></script>
                        <script src="../../../internal/linked/js/appLogin.js" type="text/javascript"></script>
                    </cfoutput>
                </head>
                <body>
            </cfcase>
    
    	
            <!--- Application with no top and left columns --->
            <cfcase value="applicationNoHeader">
               	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        #csbMetaData#
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/appSection.css" />
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/baseStyle.css" />
                        <link media="screen" rel="stylesheet" href="../../../internal/linked/css/colorbox.css" /> <!-- Modal ColorBox -->
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
                        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script type="text/javascript" src="../../../internal/linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
                        <script type="text/javascript" src="../../../internal/linked/js/ajaxUpload.js"></script> <!-- Ajax - Upload File -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.metadata.js"></script> <!-- JQuery Validation -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.validate.js"></script> <!-- JQuery Validation -->
                        <script type="text/javascript" src="../../../internal/linked/js/appSection.js"></script> <!-- UDF -->
                    </cfoutput>
                </head>
                <body>
            </cfcase>


            <!--- Application Header --->
            <cfcase value="application">
               	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        #csbMetaData#
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/appSection.css" />
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/baseStyle.css" />
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
                        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script type="text/javascript" src="../../../internal/linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
                        <script type="text/javascript" src="../../../internal/linked/js/ajaxUpload.js"></script> <!-- Ajax - Upload File -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.metadata.js"></script> <!-- JQuery Validation -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.validate.js"></script> <!-- JQuery Validation -->
                        <script type="text/javascript" src="../../../internal/linked/js/appSection.js"></script> <!-- UDF -->
                    </cfoutput>
                </head>
                <body>
                
                <!--- Start of Div Wrapper --->
                <div class="wrapper"> <!-- Start of Div Wrapper -->  
                    
                    <div class="topBar">
                        
                        <div class="topLeft">
                            #csbHeader#                     
						</div>
                                                
                        <div class="topRight">
                            <a href="#CGI.SCRIPT_NAME#?action=home" class="ui-corner-top <cfif Find("home", CGI.QUERY_STRING)> selected </cfif>">Home</a>
                            <a href="#CGI.SCRIPT_NAME#?action=help" class="ui-corner-top <cfif Find("help", CGI.QUERY_STRING)> selected </cfif>">Get Help</a>
                            <a href="#CGI.SCRIPT_NAME#?action=faq" class="ui-corner-top <cfif Find("faq", CGI.QUERY_STRING)> selected </cfif>">FAQ</a>
                            <a href="#CGI.SCRIPT_NAME#?action=myAccount" class="ui-corner-top <cfif Find("myAccount", CGI.QUERY_STRING)> selected </cfif>">Update Login</a>
                            <a href="#CGI.SCRIPT_NAME#?action=logoff" class="ui-corner-top">Logoff</a>

                            <div class="welcomeMessage">
                                <cfif IsDate(APPLICATION.CFC.CANDIDATE.getCandidateSession().dateLastLoggedIn)>
                                    Welcome Back #APPLICATION.CFC.CANDIDATE.getCandidateSession().firstName# #APPLICATION.CFC.CANDIDATE.getCandidateSession().lastName#! &nbsp;
                                    Your last login was on #DateFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().dateLastLoggedIn, 'mm/dd/yyyy')# at #TimeFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().dateLastLoggedIn, 'hh:mm tt')# EST
                                <cfelse>
									Welcome #APPLICATION.CFC.CANDIDATE.getCandidateSession().firstName# #APPLICATION.CFC.CANDIDATE.getCandidateSession().lastName#!    
								</cfif>
                            </div>

                        </div>
                        
                    </div>
		
					<!--- Side Bar --->
                    <div class="leftSideBar ui-corner-all"> <!-- Side Bar -->  
                        
                        <div class="insideBar form-container">
                            <a href="#CGI.SCRIPT_NAME#?action=initial" id="itemLinks" class="itemLinks">Start Application</a> 
                            
                            <a href="#CGI.SCRIPT_NAME#?action=checkList" id="itemLinks" class="itemLinks">Application Checklist</a> 
                                <ul>
                                    <li class="#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection1Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=0">Candidate Information</a></li>
                                    <li class="#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection2Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=1">Agreement</a></li>
                                    <li class="#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection3Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=2">English Assessment</a></li>
                                </ul>    
							
                            <a href="#CGI.SCRIPT_NAME#?action=download" class="itemLinks <cfif Find("download", CGI.QUERY_STRING)> selected </cfif>">Download Forms</a>
                            <a href="#CGI.SCRIPT_NAME#?action=documents" class="itemLinks <cfif Find("documents", CGI.QUERY_STRING)> selected </cfif>">Upload Documents</a>
                            <a href="#CGI.SCRIPT_NAME#?action=printApplication" class="itemLinks">Print Application</a>
                            <a href="#CGI.SCRIPT_NAME#?action=flightInfo" class="itemLinks <cfif Find("flightInfo", CGI.QUERY_STRING)> selected </cfif>">Flight Information</a>                            
							<cfif CLIENT.loginType NEQ 'user'>
                            	<a href="#CGI.SCRIPT_NAME#?action=submit" class="itemLinks <cfif Find("submit", CGI.QUERY_STRING)> selected </cfif>">Submit Application</a>
                            <cfelse>    
                                <a href="#CGI.SCRIPT_NAME#?action=submit" class="itemLinks <cfif Find("submit", CGI.QUERY_STRING)> selected </cfif>">Approve/Deny Application</a>
                            </cfif> 
                        </div>                            
                    
                    </div>
            </cfcase>


            <!--- Print Header --->
            <cfcase value="Print">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        #csbMetaData#
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/appSection.css" />
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/baseStyle.css" />
                        <script type="text/javascript" src="../../../internal/linked/js/appSection.js"></script>
                    </cfoutput>
                </head>
                <body>
                    <cfif ATTRIBUTES.includeTopBar>
                        <div class="topBar">
                                
                            <div class="topLeft">
                                #csbHeader#                     
                            </div>
                            
                        </div>
					</cfif>
			</cfcase>
            
            
            <!--- Email Header --->
            <cfcase value="email">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <title>#APPLICATION.METADATA.pageTitle#</title>
                </head>
                <body>

                <!--- Start of Div Wrapper --->
                <table cellpadding="2" cellspacing="2" style="width:100%; border-bottom:10px solid ##FF7E0D; height:70px;">
                    <tr>
                        <td width="70px" align="center">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.name#">
                                <img src="#APPLICATION.SITE.URL.main#/internal/pics/extra-logo.jpg" border="0" />
                            </a>
                        </td>
                        <td style="font-family: segoe ui, Arial, sans-serif; font-weight:bold; width:100%; padding-left:10px;" valign="top">
                            #csbEmailHeader#
                        </td>
                    </tr>
                </table>                                                                    
            	
				<!--- Application Body --->
                <div style="width:95%; margin:0px; padding:20px; background-color: ##FFF; border: ##EEE 1px solid; min-height:150px;">
            </cfcase>


            <!--- Extra with no top menu --->
            <cfcase value="extraNoHeader">
               	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        #csbMetaData#
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/appSection.css" />
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/baseStyle.css" />
                        <link rel="stylesheet" media="all" type="text/css" href="../../../internal/linked/css/extraBaseStyle.css" /> <!-- Extra -->
                        <link media="screen" rel="stylesheet" href="../../../internal/linked/css/colorbox.css" /> <!-- Modal ColorBox -->
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
                        <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script type="text/javascript" src="../../../internal/linked/js/basescript.js"></script> <!-- Basescript -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput, TimePicker -->
                        <script type="text/javascript" src="../../../internal/linked/js/ajaxUpload.js"></script> <!-- Ajax - Upload File -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.metadata.js"></script> <!-- JQuery Validation -->
						<script type="text/javascript" src="../../../internal/linked/js/jquery.validate.js"></script> <!-- JQuery Validation -->
                        <script type="text/javascript" src="../../../internal/linked/js/appSection.js"></script> <!-- UDF -->
                    </cfoutput>
                </head>
                <body>
            </cfcase>
    
        </cfswitch>

    </cfoutput>
    	
</cfif>