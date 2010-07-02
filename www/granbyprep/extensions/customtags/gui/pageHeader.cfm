<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		June 15, 2010
	Desc:		This Tag displays the page header used in the login and student
				application.

	Status:		In Development

	Call Custom Tag: 

		<!--- Import CustomTag --->
		<cfimport taglib="../extensions/customtags/gui/" prefix="gui" />	
		
		<!--- Page Header --->
		<gui:pageHeader
			headerType="login/application/email"
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
                        <link rel="stylesheet" href="../linked/css/appSection.css" type="text/css" />
                        <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
                        <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/excite-bike/jquery-ui.css" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script src="../linked/js/appSection.js " type="text/javascript"></script>
                    </cfoutput>
                </head>
                <body>
                
                <!--- Start of Div Wrapper --->
                <div class="wrapper">
                    
                    <div class="topBar">
                        
                        <div class="topLeft">
                            <a href="#cgi.SCRIPT_NAME#?action=initial" title="#APPLICATION.SCHOOL.name# Application For Admission">
                                <div class="mainLogo"></div>
                                <div class="title">#APPLICATION.SCHOOL.name#</div>
                                <div class="subTitle">Application for Admission</div>
                            </a>
						</div>
                                                
						
                                                                        
                        <div class="topRight">
                            <a href="#CGI.SCRIPT_NAME#?action=home" class="ui-corner-top <cfif Find("home", CGI.QUERY_STRING)> selected </cfif>">Home</a>
                            <a href="#CGI.SCRIPT_NAME#?action=help" class="ui-corner-top <cfif Find("help", CGI.QUERY_STRING)> selected </cfif>">Get Help</a>
                            <a href="#CGI.SCRIPT_NAME#?action=faq" class="ui-corner-top <cfif Find("faq", CGI.QUERY_STRING)> selected </cfif>">FAQ</a>
                            <a href="#CGI.SCRIPT_NAME#?action=myAccount" class="ui-corner-top <cfif Find("myAccount", CGI.QUERY_STRING)> selected </cfif>">Update Login</a>
                            <a href="#CGI.SCRIPT_NAME#?action=logoff" class="ui-corner-top">Logoff</a>

                            <div class="welcomeMessage">
                                <cfif IsDate(APPLICATION.CFC.STUDENT.getStudentSession().dateLastLoggedIn)>
                                    Welcome Back #APPLICATION.CFC.STUDENT.getStudentSession().firstName# #APPLICATION.CFC.STUDENT.getStudentSession().lastName#! &nbsp;
                                    Your last login was on #DateFormat(APPLICATION.CFC.STUDENT.getStudentSession().dateLastLoggedIn, 'mm/dd/yyyy')# at #TimeFormat(APPLICATION.CFC.STUDENT.getStudentSession().dateLastLoggedIn, 'hh:mm tt')# EST
                                <cfelse>
									Welcome #APPLICATION.CFC.STUDENT.getStudentSession().firstName# #APPLICATION.CFC.STUDENT.getStudentSession().lastName#!    
								</cfif>
                            </div>

                        </div>
                        
                        
                    </div>

					<!--- Side Bar --->
                    <div class="leftSideBar ui-corner-all">
                        
                        <div class="insideBar form-container ">
                        	<a href="#CGI.SCRIPT_NAME#?action=initial" id="itemLinks" class="itemLinks">Online Application</a> 
                            <a href="#CGI.SCRIPT_NAME#?action=initial" id="itemLinks" class="itemLinks">Application CheckList</a> 
                                <ul>
                                    <li>Student Information</li>
                                    <li>Family Information</li>
                                    <li>Student Essay</li>
                                    <li>Application Fee</li>
                                    <li>Mathematics Teacher Recommendation</li>
                                    <li>English Teacher Recommendation</li>
                                    <li>Transcript for at least the last two years</li>
                                    <li>Standardized test scores</li>
                                    <li>Interview</li>
                                </ul>                
                            <a href="#CGI.SCRIPT_NAME#?action=initial" class="itemLinks">Financial Aid</a>
                            <a href="#CGI.SCRIPT_NAME#?action=initial" class="itemLinks">Print Application</a>
                            <a href="#CGI.SCRIPT_NAME#?action=initial" class="itemLinks">Submit Application</a>
                        </div>
                        
                    </div>
                    
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
                <table cellpadding="2" cellspacing="2" style="width:100%; background-color:##c2d9e9; border-bottom:10px solid ##0069aa; height:70px;">
                    <tr>
                        <td width="70px" align="center">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# Application For Admission">
                                <img src="#APPLICATION.SITE.URL.main#/images/onlineApp/logoSmall.gif" border="0" />
                            </a>
                        </td>
                        <td style="font-family: segoe ui, Arial, sans-serif; font-weight:bold; width:100%; padding-left:10px;" valign="top">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# Application For Admission" style="text-decoration:none; color:##0069aa;">
                                <span style="font-size: 1.4em;">#APPLICATION.SCHOOL.name#</span> <br />
                                <span style="font-size: 0.9em;">Application for Admission</span>
                            </a>
                        </td>
                    </tr>
                </table>                                                                    
            	
				<!--- Application Body --->
                <div style="width:100%; margin:5px 0px 5px 0px; padding:20px; background-color: ##FFF; border: ##EEE 1px solid; min-height:150px;">
                
            </cfcase>
            
    
            <!--- Default Footer --->
            <cfdefaultcase>
            
            </cfdefaultcase>
    
        </cfswitch>
    
    </cfoutput>
    	
</cfif>