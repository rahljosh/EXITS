<Cfquery name="countries" datasource="#application.dsn#">
select countryid, countryname, countrycode 
from smg_countrylist
</cfquery>
<table>
	<Tr>
    	<Td>CountryID</Td><Td>Country Name</Td><td>Country Code</td><Td>Number of Students</Td>
    </Tr>
    <cfoutput>
        <Cfloop query="countries">
            <cfquery name="countrylist" datasource="#application.dsn#">
            select count(countryresident) as count_result
            from smg_students
            where countryresident = #countryid#
            and active = 1 and companyid < 5
            </Cfquery>
            <Tr>
                <td>#countryid#</td><Td>#countryname#</Td><Td>#countrycode#</Td><td>#countrylist.count_result#</td>
            </Tr>
        </Cfloop>
	</cfoutput>
</table>