<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfset client.org_code = 10>
	<cfset bgcolor ='ffffff'>    
<cfelse>
    <cfset client.org_code = 5>
    <cfset bgcolor ='B5D66E'>  
</cfif>
<cfquery name="org_info" datasource="#APPLICATION.DSN#">
select *
from smg_companies
where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.org_code#">
</cfquery>

<div align="justify">
<Cfif CLIENT.companyID NEQ 14>
  <p>Students may select state preferences for an additional fee.  You may select any three states, except Alaska or Hawaii.</p>
  <p>A good-faith effort will be made to place the student in any one of their three choices, but makes no guarantee that the student will be placed in one of the three selected states. </p>
  <p>If a placement is not available in the selected states, the student will be placed in another state and ISE will notify the student's international representative.  The student may not reject a placement because it is not in one of their preferred states. </p>
  <p>The state preference fee will also be waived if the student is not placed in a preferred state. </p>
  <p>Please enter you three state preferences below, sign and upload the form.</p>
  <br>
<Cfelse>
	Due to student enrollment limitations placed upon the schools by the district, we, the organization, cannot guarantee 100% placement of student in the  chosen school.  Therefore, we ask that the student select multiple areas in which they wish to study.<br /><br />
</Cfif>
</div>