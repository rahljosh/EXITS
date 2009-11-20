<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>User Account Details</title>
</head>

<script>
<!--// 
var newwindow;
function NewWindow(url)
{
	newwindow=window.open(url, 'Application', 'height=400, width=600, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); 
	if (window.focus) {newwindow.focus()}
}
//-->
</script>


<body>

<!----Cookie list for recent agents accessed---->
<cfif isDefined('cookie.intagentlist')>
	<cfset intagentlist = #cookie.intagentlist#>
		<cfif listcontains(intagentlist,#url.userid#, ',')>
			<cfset cookie.intagentlist = #intagentlist#>
		<cfelse>
			<cfif listlen(intagentlist) eq 5>
				<cfset intagentlist = #ListDeleteAt(intagentlist, 1, ',')#>
				<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
			<cfelse>
				<cfset intagentlist = #ListAppend(intagentlist, #url.userid#, ',')#>
			</cfif>
		</cfif>
	<cfcookie name=intagentlist value="#intagentlist#" expires="never">
<cfelse>
	<cfcookie name=intagentlist value="#url.userid#" expires="never">
</cfif>

<Cfquery name="get_intl_rep" datasource="MySQL">
	SELECT businessname, firstname, lastname, city, smg_countrylist.countryname
	FROM smg_users
	LEFT JOIN smg_countrylist ON smg_countrylist.countryid = smg_users.country
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer">
</Cfquery>

<cfoutput>

<br />
<table width="95%" class="box" bgcolor="##ffffff" align="center" cellpadding="3" cellspacing="0">
	<tr>
		<td width="50%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="2" bgcolor="##C2D1EF"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"> <b>Overview</b></td></tr>
				<tr><td width="60%" valign="top">	
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td>Intl. Rep.: &nbsp; <b>#get_intl_rep.businessname#</b> (###userid#)</td></tr>
							<tr><td>Contact:  &nbsp; #get_intl_rep.firstname# #get_intl_rep.lastname#</td></tr>
							<tr><td>Address:  &nbsp; #get_intl_rep.city#, #get_intl_rep.countryname#</td></tr>
						</table>
					</td>
					<td width="40%" valign="top">
						<table border="0" cellpadding="3" cellspacing="0" width="100%">
							<tr><td>Balance: &nbsp;</td></tr>
							<tr><td>Last Payment: &nbsp;</td></tr>
							<tr><td>Credit: &nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<table border="0" cellpadding="3" cellspacing="0" width="100%">
				<tr><td colspan="3" bgcolor="##C2D1EF"><img src="pics/$.gif"><img src="pics/$.gif"><img src="pics/$.gif"> <b>Account Tasks</b></td></tr>
				<tr>
					<td width="34%">:: <a href="javascript:newwindow('invoice/add_charge.cfm?userid=#url.userid#');">Add Charge</a></td>
					<td width="33%">:: Create Invoice</td>
					<td width="33%">:: Issue Refund</td>
				</tr>
				<tr>
					<td>:: Receive Payment</td>
					<td>:: Credit Account</td>
					<td>:: Create Refund Receipt</td>
				</tr>
				<tr>
					<td>:: Monthly Statement</td>
					<td>:: Fee Maintenance</td>
					<td></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br /><br />


</cfoutput>


</body>
</html>
