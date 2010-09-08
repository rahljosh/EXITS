<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		September 7, 2010
	Desc:		This Tag displays the page header used in the login and student
				application.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
		
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
		type="string"
        default="1"
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
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        <title>#APPLICATION.Metadata.pageTitle#</title>
                        <meta name="description" content="#APPLICATION.Metadata.pageDescription#" />
                        <meta name="keywords" content="#APPLICATION.Metadata.pageKeywords#" />
                        <link rel="stylesheet" href="../linked/css/appLogin.css" type="text/css" />
                        <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
                        <script src="#APPLICATION.Path.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="../linked/js/jquery.pstrength-min.1.2.js" type="text/javascript"></script>
                        <script src="../linked/js/appLogin.js" type="text/javascript"></script>
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
                        <title>#APPLICATION.Metadata.pageTitle#</title>
                        <meta name="description" content="#APPLICATION.Metadata.pageDescription#" />
                        <meta name="keywords" content="#APPLICATION.Metadata.pageKeywords#" />
                        <link rel="stylesheet" href="../../../internal/linked/css/appSection.css" type="text/css" />
                        <link rel="stylesheet" href="../../../internal/linked/css/baseStyle.css" type="text/css" />
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script src="../../../internal/linked/js/appSection.js " type="text/javascript"></script> <!-- UDF -->
						<script src="../../../internal/linked/js/jquery.metadata.js" type="text/javascript"></script> <!-- JQuery Validation -->
						<script src="../../../internal/linked/js/jquery.validate.js " type="text/javascript"></script> <!-- JQuery Validation -->
                    </cfoutput>
                </head>
                <body>
                
                <!--- Start of Div Wrapper --->
                <div class="wrapper">
                    
                    <div class="topBar">
                        
                        <div class="topLeft">
                            <a href="#cgi.SCRIPT_NAME#?action=initial" title="#APPLICATION.CSB.name# Application For Admission">
                                <div class="mainLogo"></div>
                                <div class="title">#APPLICATION.CSB.name#</div>
                                <div class="subTitle">#APPLICATION.CSB.programName#</div>
                            </a>
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
                    <div class="leftSideBar ui-corner-all">
                        
                        <div class="insideBar form-container">
                            <a href="#CGI.SCRIPT_NAME#?action=initial" id="itemLinks" class="itemLinks">Start Application</a> 
                            
                            <a href="#CGI.SCRIPT_NAME#?action=checkList" id="itemLinks" class="itemLinks">Application Checklist</a> 
                                <ul>
                                    <li class="no"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=0">Candidate Information</a></li>
                                    <li class="no"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=1">Family Information</a></li>
                                    <li class="no"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=3">Other</a></li>
                                    <!---
										<li class="#YesNoFormat(APPLICATION.CFC.CANDIDATE.getCandidateSession().isSection5Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=4">Candidate Essay</a></li>
									--->
                                </ul>    
                            
                            <a href="#CGI.SCRIPT_NAME#?action=documents" class="itemLinks <cfif Find("documents", CGI.QUERY_STRING)> selected </cfif>">Upload Documents</a>
                            <a href="#CGI.SCRIPT_NAME#?action=download" class="itemLinks <cfif Find("download", CGI.QUERY_STRING)> selected </cfif>">Download Forms</a>
                            <a href="#CGI.SCRIPT_NAME#?action=printApplication" class="itemLinks">Print Application</a>
                            <a href="#CGI.SCRIPT_NAME#?action=applicationFee" class="itemLinks <cfif Find("applicationFee", CGI.QUERY_STRING)> selected </cfif>">Application Fee</a>
                            <a href="#CGI.SCRIPT_NAME#?action=submit" class="itemLinks <cfif Find("submit", CGI.QUERY_STRING)> selected </cfif>">Submit Application</a>
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
                        <title>#APPLICATION.Metadata.pageTitle#</title>
                        <meta name="description" content="#APPLICATION.Metadata.pageDescription#" />
                        <meta name="keywords" content="#APPLICATION.Metadata.pageKeywords#" />
                        <link rel="stylesheet" href="../linked/css/appSection.css" type="text/css" />
                        <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
                        <script src="../linked/js/appSection.js " type="text/javascript"></script>
                    </cfoutput>
                </head>
                <body>
                    
                    <cfif ATTRIBUTES.includeTopBar>
                        <div class="topBar">
                            
                            <div class="topLeft">
                                <div class="printLogo">&nbsp;</div>
                                <div class="title">#APPLICATION.CSB.name#</div>
                                <div class="subTitle">Application for Admission</div>
                                <!---
                                <div class="title">#APPLICATION.CSB.name#</div>
                                <div class="subTitle">Application for Admission</div>
								--->
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
                    <title>#APPLICATION.Metadata.pageTitle#</title>
                </head>
                <body>

                <!--- Start of Div Wrapper --->
                <table cellpadding="2" cellspacing="2" style="width:100%; border-bottom:10px solid ##fb7f18; height:70px;">
                    <tr>
                        <td width="70px" align="center">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.name#">
                                <img src="#APPLICATION.SITE.URL.main#/internal/pics/extra-logo.jpg" border="0" />
                            </a>
                        </td>
                        <td style="font-family: segoe ui, Arial, sans-serif; font-weight:bold; width:100%; padding-left:10px;" valign="top">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.CSB.name#" style="text-decoration:none; color:##000000;">
                                <span style="font-size: 1.4em;">#APPLICATION.CSB.name#</span> <br />
                                <span style="font-size: 0.9em;">#APPLICATION.CSB.programName#</span>
                            </a>
                        </td>
                    </tr>
                </table>                                                                    
            	
				<!--- Application Body --->
                <div style="width:100%; margin:5px 0px 5px 0px; padding:20px; background-color: ##FFF; border: ##EEE 1px solid; min-height:150px;">
            </cfcase>
    
        </cfswitch>
    
    </cfoutput>
    	
</cfif>