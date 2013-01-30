<!--- ------------------------------------------------------------------------- ----
	
	File:		errorMessage.cfm
	Author:		Marcus Melo
	Date:		January 30, 2013
	Desc:		Host Application Error Message
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <cfscript>
		// If Host is logged in skip the login page
		if ( VAL(APPLICATION.CFC.SESSION.getHostSession().ID) AND URL.section EQ "login" ) {
			URL.section = "overview";
		}
		
		// Submitted applications have access only to overview and logout pages
		if ( APPLICATION.CFC.SESSION.getHostSession().isMenuBlocked AND NOT APPLICATION.CFC.SESSION.getHostSession().isExitsLogin AND NOT ListFind("login,checkList,overview,logout", URL.section) ) {
			URL.section = "overview";
		} 
		
		// Param ERRROR ID
		param name="vErrorID" default="###APPLICATION.CFC.SESSION.getHostSession().ID#-#dateformat(now(),'mmddyyyy')#-#timeformat(now(),'hhmmss')#";
	</cfscript>
        
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#SESSION.COMPANY.pageTitle#</cfoutput></title>
<link href="linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="linked/chosen/chosen.css" />
<link rel="stylesheet" href="linked/css/wiki.css" />
<link rel="stylesheet" href="linked/css/colorbox.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
<script src="linked/js/jquery.colorbox-min.js"></script>
</head>

<cfoutput>

<body>

    <div id="topBar">
    
        <div id="logoBoxB">
        
            <div class="blueBox">
                <a href="../index.cfm"><img src="images/#SESSION.COMPANY.logoImage#" alt="#SESSION.COMPANY.name#" width="214" height="165" border="0" /></a>
				<!--- Include Left Menu --->
                <cfinclude template="includes/leftMenu.cfm">
            </div><!--blueBox -->
            
            <div class="blueBtm"></div>
            
        </div><!--logoBoxB -->
    
	</div><!-- end topBar -->
    
    <div id="container">
    
        <div class="spacer2"></div>
    
        <div id="mainContent">
        
            <div id="subPages">
            
                <div class="whtTop"></div>
                
                <div class="whtMiddle">
                
                    <div class="hostApp" style="height:500px;">
                    
						<h2 class="enter">An Error Has Occurred</h2>
                        
                        <p>We are sorry, a system error has occurred.</p>
                        
                        <p>Error ID: #vErrorID#</p>
                        
                        <p>Do not worry, an email has been submitted to the support folks and they will fix it as soon as possible.</p>
                        
                        <p>
                            If you would like to specify more information that you feel would help, please follow this link or reference the ID number in an email to:
                            <a href="mailto:#SESSION.COMPANY.email.support#?subject=ErrorID: #vErrorID#">#SESSION.COMPANY.email.support#</a>
                        </p>
                       
                        <p>You may or may not receive an email asking about more information or status update of the issue, depending on what the error is.</p>
                        
                        <p>Please close this window or click on your browser's back button and try again.</p>
                        
                        <p>
                            Thank you,<br />
                            #SESSION.COMPANY.name#<br />
                            <a href="#SESSION.COMPANY.siteURL#">#SESSION.COMPANY.siteURL#</a>
                        </p>
                        
                        <div id="main" class="clearfix"></div>
                        
                    </div><!-- hostApp -->
                    
                    <div id="main" class="clearfix"></div>
                    
                </div><!-- end whtMiddle -->
                
                <div class="whtBottom"></div>
                
            </div><!-- end subPages -->
        
        </div><!-- end mainContent -->
        
    </div><!-- end container -->
    
    <div id="main" class="clearfix"></div>
    
    <div id="footer">
        <div class="clear"></div>
    </div><!-- end footer -->

</body>
</html>

</cfoutput>