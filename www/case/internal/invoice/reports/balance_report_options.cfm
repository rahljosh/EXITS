<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="../check_rights.cfm">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<div class="application_section_header">Report Options</div><br>
Depending on the number of variables you select, the report will take a while to run (up to 2 minuts), please be patient.<br>
<cfquery name="companies" datasource="caseusa">
select companyid, companyshort
from smg_companies
</cfquery>

<cfquery name="int_Agents" datasource="caseusa">
select userid, businessname
from smg_users where usertype = 8
and active = 1
order by businessname
</cfquery>

<cfquery name="programs" datasource="caseusa">
select smg_programs.programname, smg_programs.programid, smg_programs.companyid, smg_companies.companyshort
from smg_programs left join smg_companies on smg_programs.companyid = smg_companies.companyid
order by programname
</cfquery>
<form action="invoice/reports/program_balance.cfm?RequestTimeout=600" method="post"><br>
<cfoutput>
Date Range to include: <input type="text" value='09/01/2004' name=beg_date> thru <input type="text" name="end_date" value=#DateFormat(now(),'mm/dd/yyyy')#> *defaults to include all dates in system.
	</cfoutput>	<!----Programs to include in the report---->
<br><br>
Select the programs you want to include in the report:<br>
<font size=-2>*hold down shift to select a consecutive range of  programs</font><br>
<font size=-2>**hold down ctrl to select individual programs</font><br><br>
<select name="programs" multiple>
<cfoutput query="programs">

<option value=#programid#>#programname# - #companyshort#</option>
</cfoutput>
</select>
		<br><br>
		<!----Agents to include in the report---->

Select the agents you want to include in the report:<br>
<font size=-2>**hold down ctrl to de-select individual programs</font><br>
<font size=-2>*hold down shift to select a consecutive range of  programs</font><br>
<font size=-2>**hold down ctrl to select individual programs</font><br><br>

<select name="agents" multiple>
<cfoutput query="int_Agents">

<option value=#userid# selected>#businessname#</option>
</cfoutput>
</select>
<br><br>
		<!----Companies to include in the report---->

Select the companies you want to include in the report:<br>
<font size=-2>**hold down ctrl to de-select individual programs</font><br>
<font size=-2>*hold down shift to select a consecutive range of  programs</font><br>
<font size=-2>**hold down ctrl to select individual programs</font><br><br>

<select name="companies" multiple>
<cfoutput query="companies">
<option value=#companyid# selected>#companyshort#</option>
</cfoutput>
</select>
<br><br>

<input type=submit value="submit">
</form>


</body>
</html>
