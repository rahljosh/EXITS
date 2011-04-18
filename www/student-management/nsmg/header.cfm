<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param URL variables --->
	<cfparam name="url.curdoc" default="initial_welcome">
    <cfparam name="url.menu" default="">
    <cfparam name="url.submenu" default="">
    <cfparam name="url.action" default="">
	
    <cfscript>
		// check to make sure we have a valid companyID
		if ( NOT VAL(CLIENT.companyID) ) {
			CLIENT.companyID = 5;
		}	
	</cfscript>

    <cfquery name="get_messages" datasource="#application.dsn#">
        SELECT 
        	*
        FROM 
        	smg_news_messages
        WHERE 
        	messagetype IN ('alert','update')
        AND 
        	expires > #now()# 
        AND 
        	startdate < #now()#
        AND 
        	lowest_level >= <cfqueryparam cfsqltype="cf_sql_integer" value="#client.usertype#">
        AND 
          <cfif CLIENT.companyID EQ 10 or CLIENT.companyID EQ 11 or CLIENT.companyid EQ 13 or CLIENT.companyid EQ 14>
          		companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
          <cfelse>
        	(
            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="0"> 
            OR 
            	companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.companyid#">
            )
            </cfif>
        ORDER BY 
        	startdate DESC
        
    </cfquery>
    
    <cfquery name="alert_messages" dbtype="query">
        SELECT 
        	*
        FROM 
        	get_messages
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="alert">
    </cfquery>
    
    <cfquery name="update_messages" dbtype="query">
        SELECT 
        	*
        FROM 
        	get_messages 
        WHERE 
        	messagetype = <cfqueryparam cfsqltype="cf_sql_varchar" value="update">
    </cfquery>

</cfsilent>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta name="Author" content="Josh Rahl">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXITS</title>
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="smg.css" type="text/css">
    <link rel="stylesheet" href="linked/css/baseStyle.css" type="text/css"> <!-- BaseStyle -->
    <link rel="stylesheet" href="linked/css/datePicker.css" type="text/css"> <!-- Date Picker Style -->
    <link media="screen" rel="stylesheet" href="linked/css/colorbox.css" /> <!-- Modal ColorBox -->
    <cfoutput><script type="text/javascript" src="#APPLICATION.PATH.jQuery#"></script></cfoutput> <!-- jQuery -->
	<script type="text/javascript" src="linked/js/jquery.tools.min.js"></script> <!-- JQuery Tools Includes: Modal tooltip, colorBox, MaskedInput -->
	<script type="text/javascript" src="linked/js/jquery.cfjs.js"></script> <!-- Coldfusion functions for jquery -->
    <script type="text/javascript" src="linked/js/date.js "></script> <!-- JQuery date picker plugin -->
    <script type="text/javascript" src="linked/js/jquery.datePicker.js "></script> <!-- JQuery.datePicker.js -->
    <script type="text/javascript" src="linked/js/basescript.js "></script> <!-- BaseScript -->
</head>
<body>

<!----
<div id="top"><cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif"  alt="" border="0" align="right"><h2>#original_company_info.companyname#</cfoutput> <Cfif client.usertype lte 4> <font size=-2>[ <a href="stats/default.htm">stats</a> ]</font></Cfif></h2>
<Cfif isdefined('client.name')><cfoutput>#client.name#</cfoutput> [<a href="index.cfm">Home</a>] [ <a href="logout.cfm">Logout</a> ] <cfif #Len(client.companies)# gt 1>[ <Cfoutput><A href="change_company_view.cfm?curdoc=#url.curdoc#">Change Company</A></Cfoutput> ]</cfif> <cfelse>[ <as href="loginform.cfm">Login</a> ]</Cfif> </div>
---->
<cfoutput>

<table width="100%"  bgcolor="##FFFFFF" cellpadding=0 cellspacing=0 border=0 background="pics/#client.companyid#_header.png">
	<tr>
		<td valign="top">
            <table>
                <tr> 
                    <td>
                    <div style="font: bold Arial,sans-serif; margin:0px; padding: 2px;" >
                    	<font style="font: 150%">#client.companyname#</font> <img src="pics/logos/#client.companyid#_header_icon.png"><br>
                        Program Manager is #client.programmanager#<br>
						<cfif client.levels gt 1>
                        	<a href="index.cfm?curdoc=forms/change_access_level" title="Change Access Level">#client.accesslevelname#</a>
                        <cfelse>
                        	#client.accesslevelname#
                        </cfif>
                    </div>
                    <div style="padding: 2px;">
						#client.name# [<a href="index.cfm">Home</a>] [ <a href="logout.cfm">Logout</a> ]
                    </div>
                    </td>
                    <!----<td>
                    <a href="http://spreadfirefox.com/community/?q=affiliates&amp;id=114920&amp;t=82"><img border="0" alt="Firefox 2" title="Firefox 2"  src="http://sfx-images.mozilla.org/affiliates/Buttons/firefox2/firefox-spread-btn-1.png"/ align="absmiddle"></a>
                    </td>---->
                </tr>
            </table>
		</td>
   		<!----<td align="left">
		<cfinclude template="tools/region_access.cfm">
		</td>---->

		<cfif not isDefined('url.novelaro')>
            <cfif client.usertype eq 8 >
                <td>		
                    <!-- http://www.LiveZilla.net Chat Button Link Code --><a href="javascript:void(window.open('http://www.exitsapplication.com/livezilla/livezilla.php','','width=600,height=600,left=0,top=0,resizable=yes,menubar=no,location=yes,status=yes,scrollbars=yes'))"><img src="https://www.exitsapplication.com/livezilla/image.php?id=04" width="128" height="42" border="0" alt="LiveZilla Live Help"></a><noscript><div></div></noscript><!-- http://www.LiveZilla.net Chat Button Link Code --><!-- http://www.LiveZilla.net Tracking Code --><div id="livezilla_tracking" style="display:none"></div><script language="JavaScript" type="text/javascript">var script = document.createElement("script");script.type="text/javascript";var src = "http://www.exitsapplication.com/livezilla/server.php?request=track&output=jcrpt&nse="+Math.random();setTimeout("script.src=src;document.getElementById('livezilla_tracking').appendChild(script)",1);</script><!-- http://www.LiveZilla.net Tracking Code -->
                         
                </td>
               <cfelse>
                        <td>	
				<!----	
                  <!-- http://www.LiveZilla.net Tracking Code --><div id="livezilla_tracking" style="display:none"></div><script language="JavaScript" type="text/javascript">var script = document.createElement("script");script.type="text/javascript";var src = "http://www.exitsapplication.com/livezilla/server.php?request=track&output=jcrpt&nse="+Math.random();setTimeout("script.src=src;document.getElementById('livezilla_tracking').appendChild(script)",1);</script><!-- http://www.LiveZilla.net Tracking Code -->      
               ---->
			    </td>
               
            </cfif> 
        </cfif>
		
		<td valign="top">
            <u>Site Stats</u><br>
			<cfif client.usertype LTE 4>
            	<a href="?curdoc=trackman">Users Online: #structcount(Application.Online)#</a>
            <cfelse>
            	Users Online: #structcount(Application.Online)#
            </cfif>
            <br>
            
		</td>
		
		<cfif alert_messages.recordcount NEQ 0>
			<td bgcolor="##cc0000" valign="top">
                <div class="alerts"> 
                <h3>Alerts & Notifications</h3> 
                <cfloop query="alert_messages">
                    <a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#alert_messages.message#</font></a><br>
                </cfloop>
				</div>
			</td>
        </cfif>
		
		<cfif update_messages.recordcount NEQ 0>
			<td bgcolor="##005b01" valign="top">
                <div class="updates">
                <h3>System Updates</h3>
                <cfloop query="update_messages">
                	<a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#update_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white">#message#</font></a><br>
                </cfloop>
                </div>
			</td>
		</cfif>

        <td align="right" rowspan="2" valign="top">
            <cfif client.usertype EQ 8 OR client.usertype EQ 11>
                <cfif client.usertype eq 11>
                    <cfquery name="get_intrep" datasource="#application.dsn#">
                        select intrepid
                        from smg_users
                        where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    </cfquery>
                </cfif>
                <cfquery name="logo" datasource="#application.dsn#">
                    select logo
                    from smg_users 
                    <cfif client.usertype eq 11>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_intrep.intrepid#">
                    <cfelse>
                    	where userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">
                    </cfif>
                </cfquery>
                
				<cfif NOT LEN(logo.logo)>

                    <cfdirectory directory="#AppPath.companyLogo#" name="file" filter="#client.companyid#_header_logo.png">
                        <cfif file.recordcount>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/#file.name#">
                       <cfelse>
                            <!--- SMG LOGO --->
                            <img src="pics/logos/smg_clear.gif">
                        </cfif>
                    <cfelse>
                        <!--- INTL. AGENT LOGO --->
                        <img src="pics/logos/#logo.logo#" height="71">
                    </cfif>
                    
                <cfelse>
                    <img src="pics/logos/#client.companyid#_header_logo.png">
                </cfif>
        </td>
    </tr>
    <tr height="10">
        <td colspan=8 valign="bottom" align="right"><img src="pics/logos/#client.companyid#_px.png" height=12 width="100%"></td>
    </tr>
</table>
<table width="100%" cellspacing=0 cellpadding=0 bgcolor="eeeeee">
	<tr> 
		<td>
           <cfinclude template="menu.cfm">
		</td>
	</tr>
</table>
<table width="100%" cellspacing=0 cellpadding=0>
	<tr> 
		<td><img src="pics/logos/#client.companyid#_px.png" width="100%" height="1"></td>
	</tr>
</table>
</cfoutput>
<br>