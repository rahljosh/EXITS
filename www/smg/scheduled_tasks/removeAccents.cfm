<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetActiveStudents" datasource="MySql">
        SELECT
            studentID,
            firstName,
            familyLastName,
            middleName,
            cityBirth        
        FROM 
            smg_students
        WHERE
            active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
            ds2019_no = <cfqueryparam cfsqltype="cf_sql_varchar" value="">
        AND
            companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="1,2,3,4,5,10,12,13" list="yes"> )
        ORDER BY
            studentID DESC
    </cfquery>

</cfsilent>

<cfoutput>

Total of: #qGetActiveStudents.recordCount#
<table width="80%">
    <tr>
        <td><b>StudentID</b></td>
        <td><b>FirstName</b></td>
        <td><b>New FirstName</b></td>
        <td><b>familyLastName</b></td>
        <td><b>New familyLastName</b></td>
        <td><b>middleName</b></td>
        <td><b>New middleName</b></td>
        <td><b>cityBirth</b></td>
        <td><b>New cityBirth</b></td>
    </tr>
    <cfloop query="qGetActiveStudents">
        <tr>
            <td>###qGetActiveStudents.studentID#</td>
            <td>#qGetActiveStudents.firstName#</td>
            <td>#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.firstName))#</td>
            <td>#qGetActiveStudents.familyLastName#</td>
            <td>#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.familyLastName))#</td>
            <td>#qGetActiveStudents.middleName#</td>
            <td>#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.middleName))#</td>
            <td>#qGetActiveStudents.cityBirth#</td>
            <td>#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.cityBirth))#</td>
        </tr>
        
        <cfquery datasource="MySql">
            UPDATE
                smg_students
            SET
                firstName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.firstName))#">,
                familyLastName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.familyLastName))#">,
                middleName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.middleName))#">,
                cityBirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.UDF.ProperCase(APPLICATION.CFC.UDF.removeAccent(qGetActiveStudents.cityBirth))#">
            WHERE
                studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetActiveStudents.studentID#">
            LIMIT 1
        </cfquery>
        
    </cfloop>    
</table>    

Done!

</cfoutput>