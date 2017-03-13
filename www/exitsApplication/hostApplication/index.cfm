<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family App - Index

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <cfscript>
		// If Host is logged in skip the login page
		if ( VAL(APPLICATION.CFC.SESSION.getHostSession().ID) AND URL.section EQ "login" ) {
			URL.section = "overview";
		}

		// Submitted applications have access only to overview and logout pages | Make sure blocked pages cannot be accessed
		if ( NOT APPLICATION.CFC.SESSION.getHostSession().isExitsLogin AND NOT ListFindNoCase("login,checklist,overview,logout", URL.section) AND ListFindNoCase(SESSION.LEFTMENU.blockedSections, URL.section) ) {
			URL.section = "overview";
		} 
		
		// Get Host Family Info - Accessible from any page
		qGetHostFamilyInfo = APPLICATION.CFC.HOST.getCompleteHostInfo(hostID=APPLICATION.CFC.SESSION.getHostSession().ID);
		
		// Get Sections that are denied - Accessible from any page
		qGetDeniedSections = APPLICATION.CFC.HOST.getDeniedSections();
	</cfscript>
        
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='pageTitle')#</cfoutput></title>
<link href="linked/css/baseStyle.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="linked/chosen/chosen.css" />
<link rel="stylesheet" href="linked/css/wiki.css" />
<link rel="stylesheet" href="linked/css/colorbox.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="linked/chosen/chosen.jquery.js" type="text/javascript"></script>
<script src="linked/js/jquery.colorbox-min.js"></script>
<script type="text/javascript">
	//<![CDATA[
	function ShowHide(){
		$("#slidingDiv").animate({"height": "toggle"}, { duration: 300 });
	}
	//]]>
</script>
<cfif url.section eq 'overview'>
<!-- Facebook Conversion Code for Host Family App Start Page -->
<script>(function() {
  var _fbq = window._fbq || (window._fbq = []);
  if (!_fbq.loaded) {
    var fbds = document.createElement('script');
    fbds.async = true;
    fbds.src = '//connect.facebook.net/en_US/fbds.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(fbds, s);
    _fbq.loaded = true;
  }
})();
window._fbq = window._fbq || [];
window._fbq.push(['track', '6015238425693', {'value':'0.00','currency':'USD'}]);
</script>
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=6015238425693&amp;cd[value]=0.00&amp;cd[currency]=USD&amp;noscript=1" /></noscript>
</cfif>
</head>

<cfoutput>

<body>

    <div id="topBar">
    
        <div id="logoBoxB">
        
            <div class="blueBox">
                <a href="../index.cfm"><img src="images/#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='logoImage')#" alt="#APPLICATION.CFC.SESSION.getCompanySessionByKey(structKey='name')#" width="214" height="165"border="0" /></a>
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
                
                    <div class="hostApp">
                    
						<!--- Check to see which action we are taking. --->
                        <cfswitch expression="#URL.section#">
                        
                            <cfcase value="login,overview,contactInfo,familyMembers,cbcAuthorization,w9,personalDescription,hostingEnvironment,religiousPreference,familyRules,familyAlbum,schoolInfo,communityProfile,confidentialData,references,checkList,logout" delimiters=",">
                        		
                                <!--- Include template --->
                                <cfinclude template="_#URL.section#.cfm" />
                        
                            </cfcase>
                        
                            <!--- The default case is the login page --->
                            <cfdefaultcase>
                                
                                <!--- Include template --->
                                <cfinclude template="_overview.cfm" />
                        
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