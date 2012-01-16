<!--- use cfsetting to block output of HTML outside of cfoutput tags --->
<cfsetting enablecfoutputonly="Yes">

<!-----Company Information----->
<cfinclude template="../querys/get_company_short.cfm">

<!--- get Students  --->
<Cfquery name="get_students" datasource="MySQL">
	SELECT 
		s.studentid, 
        s.firstname, 
        s.familylastname, 
        s.programid, 
        s.regionassigned, 
        s.grades, 
        s.email, 
        s.ds2019_no, 
        s.sex,
		p.programname,
		h.familylastname as hostfamily, 
        h.address as hostaddress, 
        h.address2 as hostaddress2, 
		h.city as hostcity, 
        h.state as hoststate, 
        h.zip as hostzip,
		sch.schoolname, 
        sch.address as schooladdress, 
        sch.city as schoolcity, 
        sch.state as schoolstate, 
        sch.zip as schoolzip, 
        sch.principal,
		area.firstname as areafirst, 
        area.lastname as arealast, 
        area.userid as areaid,
		r.regionname,
		c.companyshort,
		country.countryname
	FROM 
    	smg_students s 
	INNER JOIN 
    	smg_programs p		ON 	s.programid = p.programid
	INNER JOIN 
    	smg_hosts h 	ON 	s.hostid = h.hostid
	INNER JOIN 
    	smg_companies c ON s.companyid = c.companyid
	INNER JOIN 	
    	smg_countrylist country ON s.countryresident = country.countryid 
	INNER JOIN 
    	smg_regions r ON r.regionid = s.regionassigned 
	LEFT JOIN 
    	smg_schools sch ON 	s.schoolid = sch.schoolid
	LEFT JOIN 
    	smg_users area ON s.arearepid = area.userid
	WHERE     	
        <!--- Do not get cancelled students | Get Active/Inactive Students --->
        <!---
			s.active = <cfqueryparam cfsqltype="cf_sql_bit" value="1"> 
		--->
        cancelDate IS <cfqueryparam cfsqltype="cf_sql_date" null="yes">
    
	AND
    	s.programID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.programid#" list="yes"> )
        
	<cfif CLIENT.companyID EQ 5>
        AND
            companyID IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="#APPLICATION.SETTINGS.COMPANYLIST.ISESMG#" list="yes"> )
    <cfelse>
        AND
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyID#">
    </cfif>
    
	<cfif VAL(FORM.regionid)>
        AND 
        	s.regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.regionid#">
    </cfif>

	<cfif isdefined('FORM.grade')>
    	AND 
        	s.grades IN ( <cfqueryparam cfsqltype="cf_sql_integer" value="11,12" list="yes"> )
    </cfif>
   
	ORDER BY 
    	s.familylastname
</cfquery>

<!--- set content type --->
<cfcontent type="application/msexcel">

<!--- suggest default name for XLS file --->
<cfheader name="Content-Disposition" value="attachment; filename=studentList.xls"> 

<!--- Format data using cfoutput and a table. Excel converts the table to a spreadsheet.
The cfoutput tags around the table tags force output of the HTML when using cfsetting enablecfoutputonly="Yes" --->
<cfoutput>
    <table border="1" cellpadding="3" cellspacing="0">
        <tr>
            <td><b>Company</b></td>
            <td><b>ID</b></td>
            <td><b>First Name</b></td>
            <td><b>Last Name</b></td>
            <td><b>Sex</b></td>
            <td><b>Country</b></td>
            <td><b>#CLIENT..DSFormName#</b></td>
            <td><b>Email</b></td>
            <td><b>Program</b></td>
            <td><b>Region</b></td>						
            <td><b>Host Family</b></td>
            <td><b>Address</b></td>	
            <td><b>City</b></td>	
            <td><b>State</b></td>	
            <td><b>Zip</b></td>	
            <td><b>School Name</b></td>
            <td><b>School Address</b></td>
            <td><b>School City</b></td>
            <td><b>School State</b></td>
            <td><b>School Zip</b></td>
            <td><b>School Contact</b></td>
            <td><b>Supervising Representative</b></td>
        </tr>
        <cfloop query="get_students">	
            <tr>
                <td>#companyshort#</td>
                <td>#studentid#</td>
                <td>#firstname#</td>
                <td>#familylastname#</td>
                <td>#sex#</td>
                <td>#countryname#</td>
                <td>#ds2019_no#</td>
                <td>#email#</td>
                <td>#programname#</td>
                <td>#regionname#</td>
                <td>#hostfamily#</td>
                <td><cfif hostaddress is ''>#hostaddress2#<cfelse>#hostaddress#</cfif></td>
                <td>#hostcity#</td>
                <td>#hoststate#</td>
                <td>#hostzip#</td>
                <td>#schoolname#</td>	
                <td>#schooladdress#</td>	
                <td>#schoolcity#</td>	
                <td>#schoolstate#</td>
                <td>#schoolzip#</td>
                <td>#principal#</td>
                <td>#areafirst# #arealast#</td>
            </tr>		
        </cfloop>
    </table>
</cfoutput>