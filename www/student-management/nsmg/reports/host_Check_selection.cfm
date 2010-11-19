<div class="application_section_header">Assignment Report - host / student /reps</div><br>
This report should be used to make sure that a Host is assigned to the correct region, reps, and company, and that all people linked to them, students and 
reps are also correctly linked up. 
There should be relativily few errors on this report once all old imported data has been updated.<br><br>
Please select the company you would like to run the report on.  <br>
This is a resource intensive report, it will take a few moments to run so please be patient.<br><br>
<cfquery name="get_company" datasource="MySQL">
select companyshort, companyid
from smg_companies
<Cfif client.usertype is 4>
where companyid = #client.companyid#
</Cfif>
</cfquery>
<form method="post" action="?curdoc=reports/region_selection">
If you want to check on just one Family, enter there ID number here: <input type="text" name="hostid" size=5><br><br>

Company:	 <select name="companyid">
		
		<cfoutput query="get_company">
		<option value="#companyid#">#companyshort#</option>
		</cfoutput>
		
		</select><br><br>
		

		Sort By: <input type="radio" name="orderby" value="familylastname" checked>Host Last Name</td><td><input type="radio" name="orderby" value="hostid">Host ID
	<br><br>

<div class="button"><input name="submit" type="image" src="pics/next.gif" align="right" border=0></div>