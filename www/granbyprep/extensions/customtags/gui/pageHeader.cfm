<!--- ------------------------------------------------------------------------- ----
	
	File:		pageHeader.cfm
	Author:		Marcus Melo
	Date:		June 15, 2010
	Desc:		This Tag displays the page header used in the login and student
				application.

	Status:		In Development

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

            <!--- AdminTool Login Header --->
            <cfcase value="adminToolLogin">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <cfoutput>
                        <title>#APPLICATION.Metadata.pageTitle#</title>
                        <meta name="description" content="#APPLICATION.Metadata.pageDescription#" />
                        <meta name="keywords" content="#APPLICATION.Metadata.pageKeywords#" />
                        <link rel="stylesheet" href="../linked/css/adminToolLogin.css" type="text/css" />
                        <link rel="stylesheet" href="../linked/css/baseStyle.css" type="text/css" />
                        <script src="#APPLICATION.Path.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                    </cfoutput>
                </head>
                <body>
            </cfcase>


            <!--- Application Login Header --->
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
    
    
            <!--- AdminTool Header --->
            <cfcase value="adminTool">
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
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script src="../linked/js/appSection.js " type="text/javascript"></script> <!-- UDF -->
						<script src="../linked/js/jquery.metadata.js" type="text/javascript"></script> <!-- JQuery Validation -->
						<script src="../linked/js/jquery.validate.js " type="text/javascript"></script> <!-- JQuery Validation -->
                    </cfoutput>
                </head>
                <body>
                
                <!--- Start of Div Wrapper --->
                <div class="wrapper">
                    
                    <div class="topBar">
                        
                        <div class="topLeft">
                            <a href="#cgi.SCRIPT_NAME#?action=home" title="#APPLICATION.SCHOOL.name# Application For Admission">
                                <div class="mainLogo"></div>
                                <div class="title">#APPLICATION.SCHOOL.name#</div>
                                <div class="subTitle">#APPLICATION.SETTINGS.adminToolVersion#</div>
                            </a>
						</div>
                                                
                        <div class="topRight">
                            <a href="#CGI.SCRIPT_NAME#?action=home" class="ui-corner-top <cfif Find("home", CGI.QUERY_STRING)> selected </cfif>">Home</a>
                            <!---
                            <a href="#CGI.SCRIPT_NAME#?action=home" class="ui-corner-top <cfif Find("contentList", CGI.QUERY_STRING)> selected </cfif>">Content</a>
							--->
                            <a href="#CGI.SCRIPT_NAME#?action=studentList" class="ui-corner-top <cfif Find("studentList", CGI.QUERY_STRING)> selected </cfif>">Students</a>
                            <a href="#CGI.SCRIPT_NAME#?action=userList" class="ui-corner-top <cfif Find("userList", CGI.QUERY_STRING)> selected </cfif>">Users</a>
                            <a href="#CGI.SCRIPT_NAME#?action=userDetail&ID=#APPLICATION.CFC.USER.getUserID()#" class="ui-corner-top <cfif Find("myAccount", CGI.QUERY_STRING)> selected </cfif>">My Info</a>
                            <a href="#CGI.SCRIPT_NAME#?action=logoff" class="ui-corner-top">Logoff</a>

                            <div class="welcomeMessage">
                                <cfif IsDate(APPLICATION.CFC.USER.getUserSession().dateLastLoggedIn)>
                                    Welcome Back #APPLICATION.CFC.USER.getUserSession().firstName# #APPLICATION.CFC.USER.getUserSession().lastName#! &nbsp;
                                    Your last login was on #DateFormat(APPLICATION.CFC.USER.getUserSession().dateLastLoggedIn, 'mm/dd/yyyy')# at #TimeFormat(APPLICATION.CFC.USER.getUserSession().dateLastLoggedIn, 'hh:mm tt')# EST
                                <cfelse>
									Welcome #APPLICATION.CFC.USER.getUserSession().firstName# #APPLICATION.CFC.USER.getUserSession().lastName#!    
								</cfif>
                            </div>

                        </div>
                        
                    </div>
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
                        <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab --> 
						<script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
                        <script src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab -->
                        <script src="../linked/js/appSection.js " type="text/javascript"></script> <!-- UDF -->
						<script src="../linked/js/jquery.metadata.js" type="text/javascript"></script> <!-- JQuery Validation -->
						<script src="../linked/js/jquery.validate.js " type="text/javascript"></script> <!-- JQuery Validation -->
                        <!--- <script src="../linked/js/jquery.validate.creditcard2.js " type="text/javascript"></script> <!-- JQuery Credit Card Validation --> --->
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
                        
                        <div class="insideBar form-container">
                            <a href="#CGI.SCRIPT_NAME#?action=initial" id="itemLinks" class="itemLinks">Start Application</a> 
                            
                            <a href="#CGI.SCRIPT_NAME#?action=checkList" id="itemLinks" class="itemLinks">Application Checklist</a> 
                                <ul>
                                    <li class="#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection1Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=0">Student Information</a></li>
                                    <li class="#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection2Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=1">Family Information</a></li>
									
									<!--- Only Display If Addtional Family Information is Checked --->
                                    <cfif VAL(APPLICATION.CFC.STUDENT.getStudentSession().hasAddFamInfo)>
                                    	<li class="#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection3Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=2">Additional Family Information</a></li>
                                    </cfif>
                                    
                                    <li class="#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection4Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=3">Other</a></li>
                                    <li class="#YesNoFormat(APPLICATION.CFC.STUDENT.getStudentSession().isSection5Complete)#"><a href="#CGI.SCRIPT_NAME#?action=initial&currentTabID=4">Student Essay</a></li>
                                </ul>    
                            
                            <a href="#CGI.SCRIPT_NAME#?action=documents" class="itemLinks <cfif Find("documents", CGI.QUERY_STRING)> selected </cfif>">Upload Documents</a>
                            <a href="#CGI.SCRIPT_NAME#?action=download" class="itemLinks <cfif Find("download", CGI.QUERY_STRING)> selected </cfif>">Download Forms</a>
                            <a href="#CGI.SCRIPT_NAME#?action=printApplication" class="itemLinks">Print Application</a>
                            <a href="#CGI.SCRIPT_NAME#?action=applicationFee" class="itemLinks <cfif Find("applicationFee", CGI.QUERY_STRING)> selected </cfif>">Application Fee</a>
                            <a href="#CGI.SCRIPT_NAME#?action=submit" class="itemLinks <cfif Find("submit", CGI.QUERY_STRING)> selected </cfif>">Submit Application</a>
                        </div>                            
                    
                    </div>
            </cfcase>


            <!--- Application Print Header --->
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
                                <div class="title">#APPLICATION.SCHOOL.name#</div>
                                <div class="subTitle">Application for Admission</div>
                                <!---
                                <div class="title">#APPLICATION.SCHOOL.name#</div>
                                <div class="subTitle">Application for Admission</div>
								--->
                            </div>
                            
                        </div>
					</cfif>
			</cfcase>
            
            
            <!--- AdminTool Email Header --->
            <cfcase value="AdminToolEmail">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <title>#APPLICATION.Metadata.pageTitle#</title>
                </head>
                <body>

                <!--- Start of Div Wrapper --->
                <table cellpadding="2" cellspacing="2" style="width:100%; background-color:##FFFFFF; border-bottom:10px solid ##641c20; height:70px;">
                    <tr>
                        <td width="70px" align="center">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# #APPLICATION.SETTINGS.adminToolVersion#">
                                <img src="#APPLICATION.SITE.URL.main#/images/onlineApp/logoSmall.gif" border="0" />
                            </a>
                        </td>
                        <td style="font-family: segoe ui, Arial, sans-serif; font-weight:bold; width:100%; padding-left:10px;" valign="top">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# Application For Admission" style="text-decoration:none; color:##641c20;">
                                <span style="font-size: 1.4em;">#APPLICATION.SCHOOL.name#</span> <br />
                                <span style="font-size: 0.9em;">#APPLICATION.SETTINGS.adminToolVersion#</span>
                            </a>
                        </td>
                    </tr>
                </table>                                                                    
            	
				<!--- Application Body --->
                <div style="width:100%; margin:5px 0px 5px 0px; padding:20px; background-color: ##FFF; border: ##EEE 1px solid; min-height:150px;">
            </cfcase>


            <!--- Application Email Header --->
            <cfcase value="email">
                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                    <title>#APPLICATION.Metadata.pageTitle#</title>
                </head>
                <body>

                <!--- Start of Div Wrapper --->
                <table cellpadding="2" cellspacing="2" style="width:100%; background-color:##FFFFFF; border-bottom:10px solid ##641c20; height:70px;">
                    <tr>
                        <td width="70px" align="center">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# Application For Admission">
                                <img src="#APPLICATION.SITE.URL.main#/images/onlineApp/logoSmall.gif" border="0" />
                            </a>
                        </td>
                        <td style="font-family: segoe ui, Arial, sans-serif; font-weight:bold; width:100%; padding-left:10px;" valign="top">
                            <a href="#APPLICATION.SITE.URL.main#" title="#APPLICATION.SCHOOL.name# Application For Admission" style="text-decoration:none; color:##641c20;">
                                <span style="font-size: 1.4em;">#APPLICATION.SCHOOL.name#</span> <br />
                                <span style="font-size: 0.9em;">Application for Admission</span>
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