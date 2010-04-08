<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta name="Author" content="Josh Rahl">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<title>CASE - Cultural Academic Student Exchange</title>


<link rel="stylesheet" href="smg.css" type="text/css">

<style type="text/css">
<!--
.smlink         		{font-size: 11px;}
.section        		{border-top: 1px solid #c6c6c6;; border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6;border-bottom: 0px; background: #Ffffe6;}
.sideborders				{ border-right: 2px solid #c6c6c6;border-left: 2px solid #c6c6c6; background: #Ffffe6;}
.sectionFoot    		{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;font-size:2px;}
.sectionBottomDivider 	{border-bottom: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionTopDivider 		{border-top: 1px solid #BB9E66; background: #FAF7F1;line-height:1px;}
.sectionSubHead			{font-size:11px;font-weight:bold;}

-->
</style>

</head>
<body>

<cfinclude template="trackman_non_student.cfm">

<CFIF not isdefined("url.curdoc")>
	<CFSET url.curdoc = "initial_welcome">
</cfif>
<CFIF not isdefined("url.menu")>
	<CFSET url.menu = "">
</cfif>
<cfif not isdefined("url.submenu")>
	<cfset url.submenu= "">
</cfif>
<cfif not isdefined("url.action")>
	<cfset url.action= "">
</cfif>

<cfif not isdefined ('client.companyid')>
<cfoutput><cflocation url="loginform.cfm?prevdoc=#url.curdoc#"></cfoutput>
</cfif>
<Cfif not isdefined ('client.userid')>
<cflocation url="loginform.cfm">
</Cfif>
<Cfif client.companyid eq 0>
	<cfset client.companyid = 5>
</Cfif>

<cfquery name="alert_messages" datasource="caseusa">
select *
from smg_news_messages
where messagetype = 'alert' and  (expires > #now()# and startdate < #now()# )
and lowest_level >= #client.usertype#
order by startdate
</cfquery>
<cfquery name="update_messages" datasource="caseusa">
select *
from smg_news_messages 
where messagetype = 'update'  and  (expires > #now()# and startdate < #now()#)
and lowest_level >= #client.usertype#
order by startdate
</cfquery>
<cfquery name="news_messages" datasource="caseusa">
select *
from smg_news_messages
where messagetype = 'news'  and  (expires > #now()# and startdate < #now()#)
and lowest_level >= #client.usertype#
order by startdate
</cfquery>

<cfquery name="original_company_info" datasource="caseusa">
select *
from smg_companies
where companyid = #client.companyid#
</cfquery>
<!----
<div id="top"><cfoutput><img src="pics/logos/#original_company_info.companyshort#_logo.gif"  alt="" border="0" align="right"><h2>#original_company_info.companyname#</cfoutput> <Cfif client.usertype lte 4> <font size=-2>[ <a href="stats/default.htm">stats</a> ]</font></Cfif></h2>
<Cfif isdefined('client.name')><cfoutput>#client.name#</cfoutput> [<a href="index.cfm">Home</a>] [ <a href="logout.cfm">Logout</a> ] <cfif #Len(client.companies)# gt 1>[ <Cfoutput><A href="change_company_view.cfm?curdoc=#url.curdoc#">Change Company</A></Cfoutput> ]</cfif> <cfelse>[ <as href="loginform.cfm">Login</a> ]</Cfif> </div>
---->
<cfoutput>
<table width=100% bgcolor="##D1E0EF" cellpadding=0 cellspacing=0 border=0>
	<tr>
		<td valign="top">
		<table>
			<tr> 
				<td>
				<div style="font: bold 150% Arial,sans-serif; 	margin:0px; padding: 2px;">#original_company_info.companyname#  </div>
		</div><div style="padding: 2px;"><Cfif isdefined('client.name')><cfoutput>#client.name#</cfoutput> [<a href="index.cfm">Home</a>] [ <a href="logout.cfm">Logout</a> ]  <cfelse>[ <as href="loginform.cfm">Login</a> ]</Cfif>
		
				</td>
				<td>
				<!----
				<a href="http://spreadfirefox.com/community/?q=affiliates&amp;id=114920&amp;t=82"><img border="0" alt="Firefox 2" title="Firefox 2"  src="http://sfx-images.mozilla.org/affiliates/Buttons/firefox2/firefox-spread-btn-1.png"/ align="absmiddle">----></a>
</td>
			</tr>
		</table>
		<td align="left">
		
		</td>
		<!----
		<cfinclude template="tools/region_access.cfm">
		---->
		</td>
		<td>
		
				<td>
			 </cfoutput>
		
	
		
	<cfif client.usertype eq 8 or client.usertype eq 1 or client.userid eq 8530> <!--- 9672 deb bowen 9272 Brigetta klemek --->
						  
			<cfoutput>
<table cellpadding="0" cellspacing="0" border="0"><tr><td align="center"></td></tr><tr><td align="center"></td></tr></table>
			</cfoutput>
			
		
			
					</cfif> 
					
					
			
			 <cfoutput>
			
			</td>
		
		
		</td>
		<td valign="top">
		
		<u>Site Stats</u><br>
		Users Online: <cfif client.usertype eq 1>
		<a href="?curdoc=trackman">
		</cfif>
		 #structcount(Application.Online)#
		 </a><br>
		 Students Online:<cfif client.usertype eq 1>
		<a href="?curdoc=trackstu">
		</cfif>  #structcount(Application.stuOnline)#
		 </a><br>
		 
		
		   <!---- BoldchatPlus Live Chat Button HTML v1.10 (Type=Web,ChatButton=- None -,ChatWindow=- None -,Website=- None -) 
<table cellpadding="0" cellspacing="0" border="0">
<tr><td align="center"><a href="http://chat.boldcenter.com/aid/7039641255287299138/bc.chat?vr=#client.userid#&amp;vn=#client.name#&amp;vi=#client.email#" target="_blank"><img alt="Live chat by BoldchatPlus" src="https://cbi.boldcenter.com/aid/7039641255287299138/bc.cbi" width="133" height="34" border="0"></a></td></tr>
<tr><td align="center"><font size="1" face="Arial"><a href="http://www.boldcenter.com" style="text-decoration: none"><font color="black">CRM by </font><b><font color="##AD3100">Bold</font><font color="##003163">center</font></b></a></font></td></tr>
</table>
 /BoldchatPlus Live Chat Button HTML v1.10 ---->
		</td>
		
		<cfif alert_messages.recordcount eq 0 >
		<td>
		<Cfelse>
		<td bgcolor=##cc0000 valign="top">
			 <div class="alerts"> 
			<h3>Alerts & Notifications</h3> 
		
			<cfloop query=alert_messages>
				<Cfif companyid is 0 or companyid is #client.companyid#>
					<cfif #alert_messages.details# is not ''><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#alert_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white"></cfif>#alert_messages.message#</font><br></a>
				</Cfif>
			</cfloop>
				
				</div>
			</td></cfif>
		
		<cfif update_messages.recordcount eq 0 >
		<td>
		<cfelse>
		<td bgcolor="##005b01" valign="top">
			
			<div class="updates">
			<h3>System Updates</h3>
			
			<cfloop query="update_messages">
				<Cfif companyid is 0 or companyid is #client.companyid#>
					<cfif #update_messages.details# is not ''><a class=nav_bar href="" onClick="javascript: win=window.open('message_details.cfm?id=#update_messages.messageid#', 'Details', 'height=480, width=450, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><font color="white"></cfif>#message#</font><br></a>
				</cfif>
			</cfloop>
			
			</div>
			</td></cfif>

	<td align="right">
		<cfif client.usertype EQ '8' OR client.usertype EQ '11'>
			<cfif client.usertype eq 11>
				<cfquery name="get_intrep" datasource="caseusa">
					select intrepid
					from smg_users
					where userid = #client.userid#
				</cfquery>
			</cfif>
			<cfquery name="logo" datasource="caseusa">
				select logo
				from smg_users 
				<cfif client.usertype eq 11>
				where userid = #get_intrep.intrepid#
				<Cfelse>
				where userid = #client.userid#
				</cfif>
			</cfquery>
			<cfif logo.logo EQ ''>
				<!--- SMG LOGO --->
				<img src="pics/logos/smg_clear.gif">
			<cfelse>
				<!--- INTL. AGENT LOGO --->
				<img src="pics/logos/#logo.logo#" height=71>
			</cfif>
		<cfelse>
			<img src="pics/logos/#LCase(original_company_info.companyshort)#_clear.gif">
		</cfif></td>
	</td>
</tr>
</table>


<Cfinclude template="menu.cfm">
<Table width=100% cellspacing=0 cellpadding=0>
	<tr> 
		<Td><img src="pics/orange_pixel.gif" width="100%" height="1"></Td>
	</tr>
</Table>
</cfoutput>
<br>