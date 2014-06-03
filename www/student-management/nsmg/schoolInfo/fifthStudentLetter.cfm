<cfquery name="checkLetterUploaded" datasource="#application.dsn#">
select *
from document
where foreign_table = 'school_info'
and foreignID = <cfqueryparam cfsqltype="cf_sql_integer" value="url.schoolid"> and season = <cfqueryparam cfsqltype="cf_sql_integer" value="url.seasonid">
 </cfquery>
 <table>
 	<cfif checkLetterUploaded.recordcount eq 0>
    <Tr>
    	<td>No letter has been uploaded for this season.</td>
    </Tr>
    <cfelse>
	<Tr>
    	<th>Letter</th>
        <th>Receieved</th>
        <th>Uploaded By</th>
    </Tr>
    </cfif>
</table>