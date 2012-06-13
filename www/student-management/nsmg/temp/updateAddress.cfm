<Cfquery name="oldAddy" datasource="mysql">
select userid, address, address2, city, state, zip, drivers_license, ssn, dob, previous_state
from smg_users_backup
</cfquery>

<Cfloop query="oldAddy" >

<cfquery name="UpdateAddy" datasource="mysql">
update smg_users
set address = '#address#',
	address2 = '#address2#',
    city = '#city#',
    state = '#state#', 
    zip = '#zip#', 
    drivers_license = '#drivers_license#',
    <Cfif dob is not ''>
     dob = #CreateODBCDate(dob)#,
   </Cfif>
    previous_state = '#previous_state#'
where userid = #userid#
</Cfquery>
<cfoutput>
#userid# - complete <br>
</cfoutput>
</Cfloop>

