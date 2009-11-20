<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>School Fax Cover</title>
<link rel="stylesheet" href="reports.css" type="text/css">
</head>

<body>

<!--- <cftry> --->

<Cfif not isdefined ('client.userid')>
	<cflocation url="../axis.cfm?to" addtoken="no">
</Cfif>

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<cfif NOT IsDefined('form.fax_comments')>

	<cfif NOT IsDefined('url.sc')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfquery name="get_school" datasource="mysql">
		SELECT *
		FROM php_schools
		WHERE schoolid = <cfqueryparam value="#url.sc#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfoutput>
	<cfform name="comments" action="school_fax_cover.cfm" method="post">
		<cfinput type="hidden" name="sc" value="#url.sc#">
		<table align="center" width="600" cellpadding="1" cellspacing="1" frame="box" bordercolor="##S003300">	
		<tr><td width="100%">
				<table align="center" width="100%">
					<tr>
						<td width="200" align="center"><img src="../pics/dmd-logo.jpg" alt="" border="0" align="center"></td>
						<th><span class="application_section_header">Fax Cover Letter </span> <br /><br /> School: </span> &nbsp; #get_school.schoolname# (###get_school.schoolid#)</th>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td align="right">Subject: </td><td><input type="text" name="subject" size="40"></td></tr>
					<tr><td align="right">Number of Pages: </td><td><input type="text" name="npages" size="2"></td></tr>
					<tr><td colspan="2">Please use the box below to include any comments you wish to print on the fax cover:</td></tr>
					<tr><td colspan="2"><textarea name="fax_comments" cols="70" rows="4">#Replace(get_school.fax_comments,"<br>","#chr(10)#","all")#</textarea></td></tr>
					<tr><td colspan="2" align="center"><cfinput type="submit" name="submit" value="Submit"></td></tr>
				</table>
			</td>
		</tr>
		</table>	
	</cfform>
	</cfoutput>

<cfelse>

	<cfif NOT IsDefined('form.sc')>
		<cfinclude template="../error_message.cfm">
		<cfabort>
	</cfif>

	<cfset fax_comments = #Replace(form.fax_comments,"#chr(10)#","<br>","all")#>

	<cfquery name="update_fax_comments" datasource="MySql">
		UPDATE php_schools
		SET fax_comments = <cfqueryparam value="#fax_comments#" cfsqltype="cf_sql_longvarchar">
		WHERE schoolid =  <cfqueryparam value="#form.sc#" cfsqltype="cf_sql_integer">
		LIMIT 1
	</cfquery>

	<cfquery name="get_school" datasource="mysql">
		SELECT *
		FROM php_schools
		WHERE schoolid = <cfqueryparam value="#form.sc#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfoutput query="get_school">
	
	<!--- Page Header --->
	<table width="680" align="center" border=0> 
		<tr>
			<td align="left" width="130"><img src="../pics/dmd-logo.jpg"  alt="" border="0" align="left"></td>
			<td align="left" valign="top">
				<b>#companyshort.companyname#</b><br>
				#companyshort.address#<br>
				#companyshort.city#, #companyshort.state# #companyshort.zip#<br><br></td>
			<td align="right" valign="top">
				<cfif companyshort.phone NEQ ''> Phone: #companyshort.phone#<br></cfif>
				<cfif companyshort.toll_free NEQ ''> Toll Free: #companyshort.toll_free#<br></cfif>
				<cfif companyshort.fax NEQ ''> Fax: #companyshort.fax#<br></cfif></td>
		</tr>
	</table>
	
	<table width="680" align="center" border=0>
		<tr><td><hr width=90% align="center"></td></tr>
	</table><br><br><br>
	
	<table width="600" align="center" border=0>
		<tr><th><font size="+6"> F A X </font></th></tr>
	</table><br><br><br>

	<table width="680" align="center" Cellpadding="1" cellspacing="1">
		<tr>
			<td width="10%" class="style1">To:</td><td width="40%" class="style1">#schoolname#</td>
			<td width="10%" class="style1">From:</td><td width="40%" class="style1">Luke Davis</td>
		</tr>
		<tr>
			<td width="10%" class="style1">Fax:</td><td width="40%" class="style1">#fax#</td>
			<td width="10%" class="style1">Pages:</td><td width="40%" class="style1">#form.npages#</td>
		</tr>
		<tr>
			<td width="10%" class="style1">Phone:</td><td width="40%" class="style1">#phone#</td>
			<td width="10%" class="style1">Date:</td><td width="40%" class="style1">#DateFormat(now(), 'dddd, mmmm dd, yyyy')#</td>
		</tr>
		<tr><td width="10%" class="style1">Re:</td><td colspan="3" class="style1">#form.subject#</td></tr>			
	</table><br><br><br>

	<table align="center" width="680" cellpadding="1" cellspacing="1">
		<tr><th>M E S S A G E</th></tr>
		<tr><td><hr width=90% align="center"></td></tr>
	</table><br><br>
	
	
	<table width="680" align="center" border=0 cellpadding="1" cellspacing="1">
		<tr><td class="style1">#fax_comments#<br><br></td></tr>
		<tr><td>&nbsp;<br /></td></tr>
		<tr><td>Kind Regards,</td></tr>	
		<tr><td>&nbsp;<br /></td></tr>
		<tr><td><img src="../pics/lukesign.jpg" border="0"></td></tr>
		<tr><td>Luke Davis</td></tr>	
		<tr><td>Program Director</td></tr>	
		<tr><td>#companyshort.companyname#</td></tr>			
	</table><br /><br />
	</cfoutput>

</cfif>

<!--- <cfcatch type="any">
	<cfinclude template="../error_message.cfm">
</cfcatch>

</cftry> --->
</body>
</html>