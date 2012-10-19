<!----get all students that were relocated---->
<cfquery name="studentsRelocated" datasource="#application.dsn#">
select distinct stu.studentid, stu.familylastname
from smg_students stu
left join smg_hosthistory hh on hh.studentid = stu.studentid
where 
<Cfif client.companyid lte 5>
stu.companyid < 6
<cfelse>
stu.companyid = #client.companyid#
</Cfif>
and hh.relocation = 'yes'
and (stu.programid = 291 or 
    stu.programid = 305 or 
stu.programid = 314
 or stu.programid = 316
  or stu.programid = 311 or
      stu.programid = 315 or 
   stu.programid = 324 or 
   stu.programid = 323
   or stu.programid = 312
   or stu.programid = 309) 

</cfquery>
<cfoutput>
<Table border=0>
	<Tr>
 	   <Td>Program Number</Td><Td>Program Name</Td><Td>Participant's Last Name</Td><Td>Participant's First Name</Td><Td>Home Country</Td><td>SEVIS ID</td><td>Sevis Status</td>
       <Td>Host Family Number</Td><Td>Date Student Joined Host Family</Td><Td>Host Father Last Name</Td><Td>Host Father First Name</Td><td>Host Mother Last Name</td><Td>Host Mother First Name</Td><Td>Welcome Perm / Temp</Td><Td>Address</Td>
       <td>City</td><td>State</td><td>Zip</td><td>School Number</td><td>School Name</td><Td>Address</Td><td>City</td><td>State</td><td>Zip</td><td>Local Coordinaor Last Name</td><td>Local Coordinaor First Name</td><Td>Local Coordinator Zip</Td><Td>Change of Home Code</Td><Td>Reason</Td>
    </Tr>
    
<cfloop query="studentsRelocated">
<!----get Original Placement Info---->
	<Cfquery name="OriginalPlacement" datasource="#application.dsn#">
        select comp.iap_auth, p.programname, stu.familylastname, stu.firstname, c.countryname, stu.ds2019_no, stu.sevis_batchid, h.hostid, hh.dateofchange, 	h.fatherlastname,h.fatherfirstname, h.motherlastname,h.motherfirstname, hh.welcome_family, h.address, h.city, h.state, h.zip, sch.schoolID,
    sch.phone,sch.schoolname, sch.address as sch_Address, sch.city as sch_city, sch.state as sch_state, sch.zip as sch_Zip, u.lastname as repLast, u.firstname as repFirst, u.zip as repZip, hh.reason
    from smg_students stu
    left join smg_hosthistory hh on hh.studentid = stu.studentid
    left join smg_countrylist c on c.countryid = stu.countryresident
    left join smg_hosts h on h.hostid = hh.hostid
    left join smg_users u on u.userid = hh.arearepid
    left join smg_schools sch on sch.schoolid = hh.schoolid
    left join smg_programs p on p.programid = stu.programid
    left join smg_companies comp on comp.companyid = stu.companyid
    WHERE stu.studentid = #studentid# and hh.original_place = 'yes'
    </cfquery>
    <!----Need to use arrival date as date original placement date, instead of placement date---->
    <cfquery name="originalPlaceDate" datasource="#application.dsn#">
    select max(dep_date) as originalPlaceDate
    from smg_flight_info
    where studentID = #studentid# 
    and flight_type = 'arrival'
    </cfquery>
	<Tr <cfif studentsRelocated.currentrow mod 2>bgcolor="##F0F0F0"</cfif> >
    	<td>#OriginalPlacement.iap_auth#</td>
        <td>#OriginalPlacement.programname#</td>
        <td>#OriginalPlacement.familylastname#</td>
        <td>#OriginalPlacement.firstname#</td>
        <td>#OriginalPlacement.countryname#</td>
        <td>#OriginalPlacement.ds2019_no#</td>
        <td>Active</td>
       <!----since this is the original placement, it has the be the 1st host family---->
        <td>1</td>
        <td>#DateFormat(originalPlaceDate.originalPlaceDate,'mm/dd/yyyy')#</td>
        <td>#OriginalPlacement.fatherlastname#</td>
        <td>#OriginalPlacement.fatherfirstname#</td>
        <td>#OriginalPlacement.motherlastname#</td>
        <td>#OriginalPlacement.motherfirstname#</td>
        <td><Cfif OriginalPlacement.welcome_family eq 0>Permanent<cfelse>Welcome</Cfif></td>
        <td>#OriginalPlacement.address#</td>
        <td>#OriginalPlacement.city#</td>
        <td>#OriginalPlacement.state#</td>
        <td>#OriginalPlacement.zip#</td>
        <!----since this is the original placement, it has the be the 1st school---->
        <td>1</td>
        <td>#OriginalPlacement.schoolname#</td>
        <td>#OriginalPlacement.sch_Address#</td>
        <td>#OriginalPlacement.sch_city#</td>
        <td>#OriginalPlacement.sch_state#</td>
        <td>#OriginalPlacement.sch_Zip#</td>
        <td>#OriginalPlacement.repLast#</td>
        <td>#OriginalPlacement.repFirst#</td>
        <td>#OriginalPlacement.repZip#</td>
        <!----Blank for Code---->
        <td></td>
        <td>#OriginalPlacement.reason#</td>
	</Tr>
    <Cfset currSchool = 1>
    <cfset currHost = 1>
    <cfset currSchoolID = #OriginalPlacement.schoolid#>
    <cfset currHostID = #OriginalPlacement.hostid#>
    <!---Get All changes---->
      	<Cfquery name="Relocations" datasource="#application.dsn#">
        select comp.iap_auth, p.programname, stu.familylastname, stu.firstname, c.countryname, stu.ds2019_no, stu.sevis_batchid, h.hostid, hh.dateofchange, 	h.fatherlastname,h.fatherfirstname, h.motherlastname,h.motherfirstname, hh.welcome_family, h.address, h.city, h.state, h.zip, sch.schoolid,
    sch.phone,sch.schoolname, sch.address as sch_Address, sch.city as sch_city, sch.state as sch_state, sch.zip as sch_Zip, u.lastname as repLast, u.firstname as repFirst, u.zip as repZip, hh.reason
    from smg_students stu
    left join smg_countrylist c on c.countryid = stu.countryresident
    left join smg_hosthistory hh on hh.studentid = stu.studentid
    left join smg_hosts h on h.hostid = hh.hostid
    left join smg_users u on u.userid = hh.arearepid
    left join smg_schools sch on sch.schoolid = hh.schoolid
    left join smg_programs p on p.programid = stu.programid
    left join smg_companies comp on comp.companyid = stu.companyid
    WHERE stu.studentid = #studentid# and hh.relocation = 'yes'
    order by dateofchange
    </cfquery>
    <Cfloop query="Relocations">
    <Cfif currSchoolID neq #relocations.schoolid#>
    	<Cfset currSchool = #currSchool# + 1>
        <cfset currSchoolID = #schoolid#>
    </Cfif>
     <Cfif currHostID neq #relocations.HostID#>
    	<Cfset currHost = #currHost# + 1>
         <cfset currHostID = #Hostid#>
    </Cfif>
    
    	<Tr <cfif studentsRelocated.currentrow mod 2>bgcolor="##F0F0F0"</cfif>>
    	<td>#Relocations.iap_auth#</td>
        <td>#Relocations.programname#</td>
        <td>#Relocations.familylastname#</td>
        <td>#Relocations.firstname#</td>
        <td>#Relocations.countryname#</td>
        <td>#Relocations.ds2019_no#</td>
        <td>Active</td>
       <!----shows calculated current family number---->
        <td>#currHost#</td>
        <td>#DateFormat(Relocations.dateofchange,'mm/dd/yyyy')#</td>
        <td>#Relocations.fatherlastname#</td>
        <td>#Relocations.fatherfirstname#</td>
        <td>#Relocations.motherlastname#</td>
        <td>#Relocations.motherfirstname#</td>
        <td><Cfif Relocations.welcome_family eq 0>No<cfelse>Yes</Cfif></td>
        <td>#Relocations.address#</td>
        <td>#Relocations.city#</td>
        <td>#Relocations.state#</td>
        <td>#Relocations.zip#</td>
        <!----Shows current school number---->
        <td>#currSchool#</td>
        <td>#Relocations.schoolname#</td>
        <td>#Relocations.sch_Address#</td>
        <td>#Relocations.sch_city#</td>
        <td>#Relocations.sch_state#</td>
        <td>#Relocations.sch_Zip#</td>
        <td>#Relocations.repLast#</td>
        <td>#Relocations.repFirst#</td>
        <td>#Relocations.repZip#</td>
        <!----Blank for Code---->
        <td></td>
        <td>#Relocations.reason#</td>
	</Tr>

    </Cfloop>
	
    <!----Get the Final (current) placement---->
    <Cfquery name="CurrentPlacement" datasource="#application.dsn#">
        select comp.iap_auth, p.programname, stu.familylastname, stu.firstname, c.countryname, stu.ds2019_no, stu.sevis_batchid, h.hostid, 	h.fatherlastname,h.fatherfirstname, h.motherlastname,h.motherfirstname,  h.address, h.city, h.state, h.zip, sch.schoolID, stu.date_host_fam_approved,
    sch.phone,sch.schoolname, sch.address as sch_Address, sch.city as sch_city, sch.state as sch_state, sch.zip as sch_Zip, u.lastname as repLast, u.firstname as repFirst, u.zip as repZip 
    from smg_students stu
    
    left join smg_countrylist c on c.countryid = stu.countryresident
    left join smg_hosts h on h.hostid = stu.hostid
    left join smg_users u on u.userid = stu.arearepid
    left join smg_schools sch on sch.schoolid = h.schoolid
    left join smg_programs p on p.programid = stu.programid
    left join smg_companies comp on comp.companyid = stu.companyid
    WHERE stu.studentid = #studentid# 
    </cfquery>
      <Cfif currSchoolID neq #CurrentPlacement.schoolid#>
    	<Cfset currSchool = #currSchool# + 1>
        <cfset currSchoolID = #schoolid#>
    </Cfif>
     <Cfif currHostID neq #CurrentPlacement.HostID#>
    	<Cfset currHost = #currHost# + 1>
         <cfset currHostID = #Hostid#>
    </Cfif>
    	<Tr <cfif studentsRelocated.currentrow mod 2>bgcolor="##F0F0F0"</cfif> >
    	<td>#CurrentPlacement.iap_auth#</td>
        <td>#CurrentPlacement.programname#</td>
        <td>#CurrentPlacement.familylastname#</td>
        <td>#CurrentPlacement.firstname#</td>
        <td>#CurrentPlacement.countryname#</td>
        <td>#CurrentPlacement.ds2019_no#</td>
        <td>Active</td>
       <!----calculated host---->
        <td>#currHost#</td>
        <td>#DateFormat(CurrentPlacement.date_host_fam_approved,'mm/dd/yyyy')#</td>
        <td>#CurrentPlacement.fatherlastname#</td>
        <td>#CurrentPlacement.fatherfirstname#</td>
        <td>#CurrentPlacement.motherlastname#</td>
        <td>#CurrentPlacement.motherfirstname#</td>
        <td><Cfif CurrentPlacement.welcome_family eq 0>Permanent<cfelse>Welcome</Cfif></td>
        <td>#CurrentPlacement.address#</td>
        <td>#CurrentPlacement.city#</td>
        <td>#CurrentPlacement.state#</td>
        <td>#CurrentPlacement.zip#</td>
        <!----calculated school---->
        <td>#currSchool#</td>
        <td>#CurrentPlacement.schoolname#</td>
        <td>#CurrentPlacement.sch_Address#</td>
        <td>#CurrentPlacement.sch_city#</td>
        <td>#CurrentPlacement.sch_state#</td>
        <td>#CurrentPlacement.sch_Zip#</td>
        <td>#CurrentPlacement.repLast#</td>
        <td>#CurrentPlacement.repFirst#</td>
        <td>#CurrentPlacement.repZip#</td>
        <!----Blank for Code---->
        <td></td>
        <td>Final Placement</td>
	</Tr>

</cfloop>
	<Tr>
    	<td colsspan=29>&nbsp;</td>
    </Tr>
</Table>

</cfoutput>