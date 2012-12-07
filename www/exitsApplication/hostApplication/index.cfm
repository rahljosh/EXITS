<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family App - Index

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Param URL Variables --->
    <cfparam name="URL.section" default="login">

    <cfscript>
		if ( VAL(APPLICATION.CFC.SESSION.getHostSession().ID) AND URL.section EQ "login" ) {
			URL.section = "overview";
		}
	
		// Get Host Family Info - Accessible from any page
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getHosts(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
<script src="linked/js/jquery.colorbox-min.js"></script>
<script type="text/javascript">
	//<![CDATA[
	function ShowHide(){
		$("#slidingDiv").animate({"height": "toggle"}, { duration: 300 });
	}
	//]]>
</script>
</head>

<cfoutput>

<body>

    <div id="topBar">
    
        <div id="logoBoxB">
        
            <div class="blueBox">
                <a href="../index.cfm"><img src="images/#SESSION.COMPANY.logoImage#" width="214" height="165" alt="ISE logo" border="0" /></a>
                <!--- Include Left Menu --->
                <cfinclude template="includes/leftMenu.cfm">
            </div><!--blueBox -->
            
            <div class="blueBtm"></div>
            
        </div><!--logoBoxB -->
    
	</div><!-- end topBar -->
    
    <div id="container">
    
        <div class="spacer2"></div>
    
        <div class="title"></div><!-- end title -->
    
        <div class="tabsBar"></div><!-- end tabsBar -->
    
        <div id="mainContent">
        
            <div id="subPages">
            
                <div class="whtTop"></div>
                
                <div class="whtMiddle">
                
                    <div class="hostApp">
                    
						<!--- Check to see which action we are taking. --->
                        <cfswitch expression="#URL.section#">
                        
                            <cfcase value="login,overview,contactInfo,familyMembers,cbcAuthorization,personalDescription,hostingEnvironment,religiousPreference,familyRules,familyAlbum,schoolInfo,communityProfile,confidentialData,references,checkList,logout" delimiters=",">
                        
                                <!--- Include template --->
                                <cfinclude template="#URL.section#.cfm" />
                        
                            </cfcase>
                        
                            <!--- The default case is the login page --->
                            <cfdefaultcase>
                                
                                <!--- Include template --->
                                <cfinclude template="overview.cfm" />
                        
                            </cfdefaultcase>
                        
                        </cfswitch>
                            
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

<cfdump var="#client#">
<cfdump var="#session#">
<cfdump var="#APPLICATION#">