<cftry>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Inserts Section</title>
	<script type="text/javascript">
        <!--
        function CheckLink() {
            return true;
        }
        //-->
    </script>    
</head>
<body>

<cfinclude template="querys/get_student_info.cfm">

<cfquery name="get_intl_rep" datasource="#APPLICATION.DSN#">
	SELECT businessname
	FROM smg_users
	WHERE userid = <cfqueryparam value="#get_student_info.intrep#" cfsqltype="cf_sql_integer">
</cfquery>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Inserts Section</h2></td>
		<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<div class="section"><br>
<cfoutput>
<table width="670" border=0 cellpadding=0 cellspacing=0 align="center">	
	<tr>
		<td><br><br>
			<div align="justify">
			The <b>Inserts</b> section contains seven (12) pages and all pages in this 
			section require original signatures. Pages [15], [16], [17], [18]<cfif CLIENT.companyID NEQ 13>, [24]</cfif> are 
			mandatory and they must be filled out, printed, signed and uploaded back 
			into the system with original signatures. Page [19] must be filled out 
			by #get_intl_rep.businessname#, and this page will be uploaded after you have 
			submitted your application. Pages [20] and [21] are optional, but if 
			regional or state guarantees are selected, these pages must also be 
			filled out, printed, signed and uploaded back into the system with 
			original signatures. Page [22] is a Supplements page that allows for the 
			loading of all supplemental documents required by #get_intl_rep.businessname#.
			Supplements may include (but not be limited to) the ELTIS Test Answer 
			Sheet and English Certificates. 
			<cfif CLIENT.companyID NEQ 13>
				Page [23] is optional, but must be uploaded if you choose to authorize a double placement.
			</cfif>
			Pages [25], [26] and [27] are mandatory and must be uploaded.
			</div>
			<br><br>
		</td>
	</tr>
</table>
</cfoutput>
</div>

<table width=100% border=0 cellpadding=0 cellspacing=0 class="section" align="center">
	<tr>
		<td align="center" valign="bottom" class="buttontop">
			<a href="index.cfm?curdoc=section4/page15&id=4&p=15"><img src="pics/next.gif" border="0"></a>
		</td>
	</tr>
</table>

<!--- FOOTER OF TABLE --->
<cfinclude template="footer_table.cfm">

<cfcatch type="any">
	<cfinclude template="error_message.cfm">
</cfcatch>
</cftry>