<cfif cgi.http_host is 'jan.case-usa.org' or cgi.http_host is 'www.case-usa.org'>
	<cfset client.org_code = 10>
	<cfset bgcolor ='ffffff'>    
<cfelse>
    <cfset client.org_code = 5>
    <cfset bgcolor ='B5D66E'>  
</cfif>
<cfquery name="org_info" datasource="mysql">
select *
from smg_companies
where companyid = #client.org_code#
</cfquery>

<div align="justify">
<Cfif CLIENT.companyID NEQ 14>
    Starting with students arriving in January 2006, students can choose a state choice.
    Any state in the union, except for Hawaii and Alaska, can now be requested.  As always, Florida and California can still be requested.  If the state requested is not available, the International Representative will be informed
    at the time of acceptance.<br>
    <br>
    The student exchange company reserves the right in August, if a placement is not forthcoming, to place a student out of their State Choice area. No extra fee is then collected.
    <br>
    <br>
    Both state and regional choices are available for all students, both semester, and academic year students.<br><br>
    If you would like to specify states, select yes at the bottom of this page, select three states of choice and print this page,
    sign it and upload it back into the system with original signatures.<br><br>
<Cfelse>
	*** Due to student enrollment limitations, placed upon the schools by the district, we, the organization, cannot guarantee 100% placement of student to chosen school. Therefore, we ask that the student select multiple areas in which they wish to attend. ***<br /><br />
</Cfif>
</div>