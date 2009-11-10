<cfabort>


<!--- check for students with non-matching company and region --->
<cfquery name="dump_students" datasource="#application.dsn#">
    SELECT smg_students.studentid, smg_students.companyid AS student_co, smg_regions.company AS region_co
    FROM smg_students
    INNER JOIN smg_regions ON smg_students.regionassigned = smg_regions.regionid
    WHERE smg_students.companyid <> smg_regions.company
</cfquery>
<cfdump var="#dump_students#">




<!--- check for students without matching country --->
<cfquery name="test" datasource="#application.dsn#">
    SELECT smg_students.countryresident
    FROM smg_students
    LEFT JOIN smg_countrylist ON smg_students.countryresident = smg_countrylist.countryid
    WHERE smg_countrylist.countryid IS NULL
</cfquery>

<cfdump var="#test#">



<!--- this query gets orphaned records in a table so they can be deleted to add the database relationship. --->
<cfquery name="test" datasource="MySQL">
    SELECT smg_school_dates.schooldateid, smg_school_dates.schoolid
    FROM smg_school_dates LEFT JOIN smg_schools ON smg_school_dates.schoolid = smg_schools.schoolid
    WHERE smg_schools.schoolid IS NULL
</cfquery>

<cfloop query="test">
    <cfquery datasource="MySQL">
        DELETE FROM smg_school_dates
        WHERE schooldateid = #test.schooldateid#
    </cfquery>
</cfloop>

<cfdump var="#test#">