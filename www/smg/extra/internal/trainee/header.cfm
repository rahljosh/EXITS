<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="Author" content="CSB">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>EXTRA - Exchange Training Abroad</title>
    <link rel="stylesheet" href="../style.css" type="text/css">
    <link rel="shortcut icon" href="pics/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="../linked/css/datePicker.css" type="text/css">
    <link rel="stylesheet" href="../linked/css/basescript.css" type="text/css">
	<cfoutput>
    <script src="#APPLICATION.PATH.jQuery#" type="text/javascript"></script> <!-- jQuery -->
    </cfoutput>
    <!-- required plugins -->
    <script src="../linked/js/date.js" type="text/javascript"></script>
    <!-- jquery.datePicker.js -->
    <script src="../linked/js/jquery.datePicker.js" type="text/javascript"></script>
    <!-- Basescript -->
	<script src="../linked/js/basescript.js" type="text/javascript"></script>
</head>

<body>

<Cfif NOT isdefined ('client.userid')>
	<cflocation url="../../index.cfm" addtoken="no">
</Cfif>

<cfquery name="alert_messages" datasource="mysql">
	select *
	from smg_news_messages
	where (messagetype = 'alert') and  (expires > #now()# and startdate < #now()# )
	and lowest_level >= #client.usertype#
</cfquery>

<cfquery name="update_messages" datasource="mysql">
	select *
	from smg_news_messages 
	where messagetype = 'update'  and  (expires > #now()# and startdate < #now()#)
	and lowest_level >= #client.usertype#
	and companyid = '#client.companyid#'	
</cfquery>

<cfif IsDefined('url.id')>
	<!--- SET client.COMPANYID --->
	<cfset client.companyid = #url.id#>
</cfif>

<cfinclude template="querys/get_company.cfm">

<!--- GET OTHER COMPANIES USER HAS ACCESS TO --->
<cfquery name="get_company_access" datasource="MySql">
	SELECT uar.userid, uar.companyid, uar.usertype,
		c.companyshort
	FROM user_access_rights uar
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	WHERE uar.userid = '#client.userid#'
		AND c.system_id = '4' <!--- EXTRA --->
		AND uar.companyid != '#client.companyid#'
	GROUP BY uar.companyid
	ORDER BY c.companyshort	
</cfquery>

<!--- SET LINKS --->
<cfset link7 = '../trainee/index.cfm'>
<cfset link8 = '../wat/index.cfm'>
<cfset link9 = '../h2b/index.cfm'>
<cfset countlist = 0>

<cfoutput>
  <table width=90% border=0 align="center" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
	<Tr>
		<td width=98 rowspan=4 bordercolor="##FFFFFF"><div align="center"><A href="index.cfm?curdoc=initial_welcome"><img src="../pics/extra-logo.jpg" width="60" height="81" border=0></a></div></td>
	</tr>
	<tr>
		<td width="411" valign=top bordercolor="##FFFFFF" class="style1">
			<cfif get_company_access.recordcount>
				<span class="style5"><strong>Choose another Program:</strong> &nbsp;
				<cfloop query="get_company_access"> <!--- LIST COMPANIES --->
					<a href="#Evaluate("link" & companyid)#?id=#companyid#" class="style4"><strong>#companyshort#</strong></a>
					<cfset countlist = countlist + 1>
					<cfif countlist NEQ get_company_access.recordcount>&nbsp; | &nbsp;</cfif>
				</cfloop>
				</span>
				<br><hr color="669966" size="1" width="385" align="left">
			</cfif>
			
			<strong>#get_company.companyshort# Program</strong>
		  	<span class="style5">Welcome back #client.firstname#! </span>
			[ <A href="index.cfm?curdoc=initial_welcome" class="style4"><b>Home</b></a> ] [ <a href="../logout.cfm" class="style4"><b>Logout</b></a> ]
		</td>
		<td width="105" valign=top bordercolor="##FFFFFF" class="style1">
			<cfif update_messages.recordcount neq 0 and curdoc NEQ 'initial_welcome'>
				<table bgcolor="##009966" width=100%>
					<tr>
						<td><span class="style5">
							<font color="FFFFFF"><b><u>System Updates:</u></b></font><br>
							<cfloop query="update_messages">
								<font color="FFFFFF"><b>#message#</b></font><br>
							</cfloop>
							</span>         
						</td>
					</tr>
				</table>
			</cfif>
		</td>
		<td width="105" align="right" valign="top" bordercolor="##FFFFFF" class="style1">
		<cfif alert_messages.recordcount neq 0 and curdoc is not 'initial_welcome'>
	      <table bgcolor="##CC3300" width=100%>
    	    <tr>
        	  <td><font color="FFFFFF"><b><u>Alerts:</u></b></font><br>
            	  <cfloop query="alert_messages">
                	<font color="FFFFFF"><b>#message#</b></font><br>
	              </cfloop>
    	      </td>
        	</tr>
	      </table>
		  </cfif>
		 </td>
	  <td width="174" align="right" valign="top" bordercolor="##FFFFFF" class="style5"><strong>Last Login:</strong> #DateFormat(client.lastlogin, 'mmm d, yyyy')#<br>
      <strong>at	</strong>#TimeFormat(client.lastlogin, 'h:mm tt')# </td>
	</tr>
	<tr>
		<td colspan=4 valign="bottom" bordercolor="##FFFFFF"><cfinclude template="menu.cfm"></td>
	</tr>
</table>
<table width = 90% border=0 align="center" height="5">
	<tr>
		<td width=98 ></td>
	</tr>
</table>
<script type="text/javascript">
    var ddmx = new DropDownMenuX('menu1');
    ddmx.delay.show = 0;
    ddmx.delay.hide = 400;
    ddmx.position.levelX.left = 2;
    ddmx.init();
</script>
</cfoutput>