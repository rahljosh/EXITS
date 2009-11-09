<cfif #form.hostid# is ''>
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
where companyid = #form.companyid#
</Cfif>
</cfquery>
<Cfquery name="region" datasource="MySQL">
select regionid, regionname
from smg_regions where company = #form.companyid#
</Cfquery>
<Cfoutput>
<form method="post" action="?curdoc=reports/host_breakdown">
Company:	#get_company.companyshort# <input type="hidden" name="companyid" value=#get_company.companyid#><br><br>
Sort By: #form.orderby# <input type="hidden" name="orderby" value=#form.orderby#><br><br>
Region:	 <select name="region">
		
		<cfloop query="region">
		<option value="#regionid#">#regionname#</option>
		</cfloop>
		<option value=0>Hosts with No Region</option>
		</select><br><br>
		
		

		
	
</cfoutput>
When checking to see if changes have made a difference, please do not re-run this report after every change.  Please make sure things look right within the system before re-running this report. 
<br><br>
	
Please click Next only once, depending on server load and region this report may time out before all records are returned, the frist 200-1000 will be returned though. 
<div class="button"><input name="submit" type="image" src="pics/next.gif" align="right" border=0></div>
<Cfelse>
<cfoutput>
<cflocation url="index.cfm?curdoc=reports/host_breakdown&hostid=#form.hostid#">
</cfoutput>
</cfif>
