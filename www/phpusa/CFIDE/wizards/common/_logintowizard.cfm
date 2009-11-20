<cfsilent>
<!--- Import L10N Taglib (System Generated) --->
<cfimport prefix="admin" taglib="../../administrator/cftags/">

<!--- Establish page locale, default is english (en). --->
<cfparam name="request.locale" default="en">
<cfscript>
	if(IsDefined("FORM.locale")) { request.locale = LCase(Trim(FORM.locale)); }
	request.localeFile = "resources/general_#request.locale#.xml";
</cfscript>

<cflogout>

<!--- we need to find our web root to admin --->
<cfset thisURL = cgi.script_name>
<!--- ensure we have componentutils --->
<cfif listFindNoCase(thisURL,"wizards","/")>
	<!--- strip off endings until we have /administrator --->
	<cfscript>
		while(	listLast(thisURL,'/') neq "wizards" )
		{	
			if( listLen(thisURL,"/") eq 0 )
			{
				cfbreak;
			}
			thisURL = listDeleteAt(thisURL, listLen(thisURL,"/"), "/");
		}
	</cfscript>
	
	<cfset thisURL = thisURL & "/">
	<cfset adminURL = ListDeleteAt( thisURL, ListLen( thisURL, "/" ), "/" ) & "/administrator/" >

</cfif>
<cfoutput>#adminURL#</cfoutput>
<cfscript>
	sUserAgent = Trim(CGI.HTTP_USER_AGENT);
	if (Find("X11", sUserAgent)) 
	{	
		if 		(Find("Mozilla/4", sUserAgent)) {sStyleLocation = "cfadmin_4_unix.css";}
		else if (Find("Mozilla/5", sUserAgent)) {sStyleLocation = "cfadmin_5_unix.css";}
		else									{sStyleLocation = "cfadmin_4_unix.css";}
	}
	else if (Find("Macintosh", sUserAgent))
	{
		if 		(Find("MSIE", sUserAgent)) 		{sStyleLocation = "cfadmin.css";}
		else if (Find("Mozilla/5", sUserAgent)) {sStyleLocation = "cfadmin.css";}
		else if (Find("Mozilla/4", sUserAgent)) {sStyleLocation = "cfadmin_mac_ns.css";}
		else									{sStyleLocation = "cfadmin.css";}							
		
	}		
	else if (Find("Windows", sUserAgent))
	{
		if 		(Find("MSIE", sUserAgent)) 		{sStyleLocation = "cfadmin.css";}
		else if (Find("Mozilla/5", sUserAgent)) {sStyleLocation = "cfadmin.css";}
		else if (Find("Mozilla/4", sUserAgent)) {sStyleLocation = "cfadmin_ns.css";}
		else									{sStyleLocation = "cfadmin.css";}							
	}	
	else if (Find("MSIE", sUserAgent)) 
	{
		// All IE Browsers on all OS/desktops
		sStyleLocation = "cfadmin.css";
	} 		
	else 
	{
		// Default. Netscape and everything else
		sStyleLocation = "cfadmin.css";
	}
</cfscript>
</cfsilent>



<cfoutput>
<admin:l10n id="cfcbrowser_login" var="pagename">Wizard Login</admin:l10n>
<html>
<head>
	<title>#pagename#</title>
	<script language="JavaScript" title="WebHelpSplitCss">
	<!--
	if (navigator.appName=="Netscape")
	{   document.write("<link rel='STYLESHEET' type='text/css' href='#adminURL#cfadmin_ns.css'>");}
	else
	{   document.write("<link rel='STYLESHEET' type='text/css' href='#adminURL#cfadmin.css'>");}
	//-->
	</script>
<cfif sStyleLocation is "cfadmin_ns.css">
	<cfinclude template="#adminURL#cfadmin_ns.cfm">

<cfelseif sStyleLocation is "cfadmin_4_unix.css">
	<cfinclude template="#adminURL#cfadmin_4_unix.cfm"> 

<cfelseif sStyleLocation is "cfadmin_5_unix.css">
	<cfinclude template="#adminURL#cfadmin_5_unix.cfm"> 	

<cfelseif sStyleLocation is "cfadmin_mac_ns.css">
	<cfinclude template="#adminURL#cfadmin_mac_ns.cfm"> 	
	
<cfelse>
	<link rel="STYLESHEET" type="text/css" href="#adminURL##sStyleLocation#">
</cfif>	
	<meta name="Author" content="Copyright 1996-#year(now())# Adobe Macromedia Software LLC. All rights reserved.">
</head>

<!-- frame buster - code by Gordon McComb -->
<script language="JavaScript" type="text/javascript">
	<!-- Hide script from older browsers

	function changePage() 
	{
		if(top != self) top.location = document.location;
	}

	function openWin( windowURL, windowName, windowFeatures ) { 
		return window.open( windowURL, windowName, windowFeatures ) ; 
	} 
	function open_on_entrance(url,name)
	{ 
	new_window = window.open(url, name, ' menubar,scrollBars,resizable,dependent,status,width=525,height=300')
	}
// -->
</script>
<body bgcolor="C8D3DC" 
	background="#adminURL#images/mx_loginbg.gif" 
	text="666666" link="003399" vlink="997799" alink="339900" 
	topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" 
	onload="changePage();document.forms.loginform.j_password.focus();">
<admin:l10n id="coldfusionmx" var="coldfusionmx">ColdFusion MX</admin:l10n>
<cfform name="loginform" action="" method="POST">
<br />

<table border="0" cellpadding="1" cellspacing="0" align="center" width="506" bgcolor="003366"><tr><td>
<table border="0" cellpadding="0" cellspacing="0" align="center" width="506">
<tr bgcolor="003350" valign="top"><td height="277" align="center">
<img src="#adminURL#images/mx_login.gif" width="506" height="192" border="0" alt=" " vspace="0">
	<table border="0" cellpadding="0" cellspacing="0" align="center">
	<tr><td><img src="#adminURL#images/mx_copyrframe.gif" width="2" height="57" border="0" alt="#coldfusionmx#" hspace="10"></td>
	<td>
	<font class="label" color="8EA4BB"><strong style="color:##3184C2;"><admin:l10n id="componentbrowser">Wizard Login</admin:l10n></strong><br />
	<admin:l10n id="copyright">Copyright (c) 1995-2006 Adobe Macromedia Software LLC. All rights reserved.<br />
	Macromedia, the Macromedia logo, Macromedia ColdFusion and ColdFusion are<br />
	trademarks or registered trademarks of Macromedia, Inc.</admin:l10n><br />
	</font>
	</td>
	<td><img src="#adminURL#images/mx_copyrframe.gif" width="2" height="57" border="0" alt=" " hspace="10"></td></tr>
	</table>
<br>
</td>
</tr>
<tr bgcolor="6688aa">
	<th align="center" height="18">		
			<center><b class="label" style="color:ddeeff;"><label for="admin_login"><admin:l10n id="enterrdsoradminpasswordlogin">Enter your RDS or Admin password below</admin:l10n></label></b></center>
	</th>
</tr>
<tr><td height="1"></td></tr>
<tr>
	<td bgcolor="8EA4BB" align="center" height="35">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td nowrap>					
				<admin:l10n id="required_password" var="required_password">Password Required</admin:l10n>
				<input name="j_password_required" type="hidden" value="#required_password#">
				<cfinput name="j_password" type="Password" size="15" style="width:15em;" class="label" maxlength="100" required="Yes" message="#required_password#" id="admin_login">
			</td>
			<td>&nbsp;</td>
			<td>
				<admin:l10n id="password_button" var="password_button">Login</admin:l10n>
				<input name="submit" type="submit" value="#password_button#" class="buttn-fix">
			</td>
		</tr>
		</table>
				
	</td>
</tr>
<cfif IsDefined('InvalidPasswordEntered')>
<tr bgcolor="993300">
	<td align="center" height="17">		
			<b class="label" style="color:white;"><admin:l10n id="invalid_password">Invalid password. Please try again.</admin:l10n></b>
	</td>
</tr>
</cfif>
</table>
</td></tr></table>
</cfform>
</body></html></cfoutput>


