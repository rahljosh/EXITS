<!--- ------------------------------------------------------------------------- ----
	
	File:		header.cfm
	Author:		Marcus Melo
	Date:		October 10, 2011
	Desc:		Student Trip Header
	
	Updates:	
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param Variables --->
	<cfparam name="setPageTitle" default="#APPLICATION.MetaData.pageTitle#">    
	<cfparam name="setPageDescription" default="#APPLICATION.MetaData.pageDescription#">    
	<cfparam name="setPageKeywords" default="">    

	<cfscript>
		// Get Metadata for current page
		qGetMetadata = APPLICATION.CFC.MetaData.getPageMetadata(URL=CGI.SCRIPT_NAME); 
		
		// Check if there is a valid metadata for this page
		if ( qGetMetadata.recordCount ) {
			// Set up this page metadata
			setPageTitle = qGetMetadata.pageTitle;
			setPageDescription = qGetMetadata.pageDescription;
			setPageKeywords = qGetMetadata.pageKeywords;
		}

		// Force SSL
		if ( NOT APPLICATION.isServerLocal AND NOT CGI.SERVER_PORT_SECURE AND LEN(CGI.QUERY_STRING) ) {
			
			Location("https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" "no");
			
		} else if ( NOT APPLICATION.isServerLocal AND NOT CGI.SERVER_PORT_SECURE  ) {
			
			Location("https://#CGI.SERVER_NAME##CGI.SCRIPT_NAME#" "no");
			
		}
	</cfscript>

</cfsilent>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><cfoutput>
    <title>#setPageTitle#</title>
    <meta name="description" content="#setPageDescription#" />
    <meta name="keywords" content="#setPageKeywords#" />
    <link href="extensions/css/baseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="#APPLICATION.PATH.jQueryTheme#" type="text/css" /> <!-- JQuery UI 1.8 Tab Style Sheet --> 
    <script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script> <!-- jQuery -->
    <script type="text/javascript" src="#APPLICATION.PATH.jQueryUI#"></script> <!-- JQuery UI 1.8 Tab --></cfoutput>                      
    <script type="text/javascript" src="extensions/js/jquery.maskedinput-1.2.2.min.js"></script>  <!-- jQuery Mask -->
    <script type="text/javascript" src="extensions/js/baseScript.js"></script>  <!-- BaseScript -->
    <script type="text/javascript">
    </script>
</head>
<body class="oneColFixCtr">

    <div id="mpdtopBar">
        <div id="logoBox"><a href="/"><img src="extensions/images/mpdLogo.png" width="140" height="140" alt="MPD Tour America, Inc." border="0" /></a></div>
    </div><!-- end mpdtopBar -->
    
    <div id="container">
        <div class="spacer2"></div>
        <div class="title">
            <table width="725" border="0">
                <tr>
                    <th width="100" rowspan="2" scope="row"><img src="extensions/images/spacer.gif" width="100" height="33" /></th>
                    <td width="615" rowspan="2"><img src="extensions/images/title.png" width="615" height="67" /></td>
                </tr>
            </table>
    	</div><!-- end title -->
        
        <!--- Include Menu --->
        <div class="mpdtabsBar">
        
            <ul id="menu">
                <li><a href="exchange-student-trips.cfm" target="_self" title="Student Trips" <cfif ListFind("/exchange-student-trips.cfm,/index.cfm", CGI.SCRIPT_NAME)>class="current"</cfif> >Student Trips</a></li>
                <li><a href="rules-policy.cfm" target="_self" title="Rules & Policies" <cfif CGI.SCRIPT_NAME EQ "/rules-policy.cfm">class="current"</cfif>>Rules & Policies</a></li>
                <li><a href="frequently-asked-questions.cfm" target="_self" title="Frequently Asked Questions" <cfif CGI.SCRIPT_NAME EQ "/frequently-asked-questions.cfm">class="current"</cfif>>Questions</a></li>
                <li><a href="contact-us.cfm" target="_self" title="Contact Us" <cfif CGI.SCRIPT_NAME EQ "/contact-us.cfm">class="current"</cfif>>Contact Us</a></li>
            </ul>
            
        </div>       
        
        <div id="mainContent">
        
            <div id="subPages">
        
                <div class="whtMiddletours2">

                    <div class="main_view">
                    
                        <div class="window">
                        
                            <div class="image_reel">
                               
                                <img src="extensions/images/header/reel_2.png" alt="" />
                                <img src="extensions/images/header/reel_3.png" alt="" />
                                <img src="extensions/images/header/reel_4.png" alt="" />
                            </div>
                            
                        </div> <!-- window -->
                        
                        <div class="paging">
                         
                            <a href="#" rel="1">1</a>
                            <a href="#" rel="2">2</a>
                            <a href="#" rel="3">3</a>
                        </div>
                        
                      <div class="blackBar"></div>
                      
                    </div> <!-- main_view -->
                    
                    <div class="tripsTours">