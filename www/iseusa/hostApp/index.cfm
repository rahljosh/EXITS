<!--- ------------------------------------------------------------------------- ----
	
	File:		index.cfm
	Author:		Marcus Melo
	Date:		November 6, 2012
	Desc:		Host Family App - Index

	Updated:	

----- ------------------------------------------------------------------------- --->

<cfsilent>
	
    <!--- Param URL Variables --->
    <cfparam name="URL.page" default="hello">
    
    <cfscript>
		// Default Values
		vPageTitle = '(ISE) International Student Exchange - Host Family Application';
		vLogoImage = 'logoISE.png';
		
		if ( ListFindNoCase(CGI.SERVER_NAME, 'caseusa', '.') ) {
			vPageTitle = '(CASE) Cultural Academic Student Exchange - Host Family Application';
			vLogoImage = 'logoCASE.png';
		} 
	</cfscript>
    
</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><cfoutput>#vPageTitle#</cfoutput></title>
<link href="css/baseStyle.css" rel="stylesheet" type="text/css" />
<link href="css/hostApp.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="chosen/chosen.css" />
<link rel="stylesheet" href="../css/wiki.css" />
<link rel="stylesheet" href="../css/colorbox2.css" />
<script src="http://code.jquery.com/jquery-latest.js" type="text/javascript"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script src="../linked/js/jquery.colorbox.js"></script>
<script type="text/javascript">
//<![CDATA[
	function ShowHide(){
	$("#slidingDiv").animate({"height": "toggle"}, { duration: 1000 });
	}

	$(document).ready(function(){
		//Examples of how to assign the ColorBox event to elements
		$(".iframe").colorbox({width:"80%", height:"80%", iframe:true, 
			onClosed:function(){ location.reload(false); } });
	});
//]]>
</script>
</head>

<body class="oneColFixCtr">

<cfoutput>

    <div id="topBar">
    
        <div id="logoBoxB">
        
            <div class="blueBox">
                <a href="../index.cfm"><img src="images/#vLogoImage#" width="214" height="165" alt="ISE logo" border="0" /></a>
                <cfif VAL(CLIENT.hostID) AND URL.page NEQ 'hostLogin'>
                    <cfinclude template="includes/leftMenu.cfm">
                </cfif>
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
                
                <div class="whtMiddletours2">
                
                    <div class="hostApp">
                    
                        <div class="app_spacing">
                            <cfinclude template="#URL.page#.cfm">
                        </div>
                        
                        <div id="main" class="clearfix"></div>
                        
                    </div><!-- hostApp -->
                    
                    <div id="main" class="clearfix"></div>
                    
                </div><!-- end whtMiddletours2 -->
                
                <div class="whtBottom"></div>
                
            </div><!-- end subPages -->
        
        </div><!-- end mainContent -->
        
    </div><!-- end container -->
    
    <div id="main" class="clearfix"></div>
    
    <div id="footer">
        <div class="clear"></div>
    </div><!-- end footer -->

</cfoutput>

</body>
</html>