
 <Cfif isDefined('form.childID')>
	  
	  <cfquery 
			name="qGetMemberInfo" 
			datasource="MYSQL">
                SELECT
					childID,
                    hostID,
                    memberType,
                    birthDate,
                    sex,
                    liveAtHome,
                    name,
                    middleName,
                    lastName,
                    SSN,
                    cbc_form_received,
                    shared,
                    roomShareWith
                FROM 
                    smg_host_children
                WHERE
                	
                        childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(form.childID)#">
              
				
		</cfquery>
       
     

 </Cfif>
   <cfquery 
			name="qGetUserInfo" 
			datasource="MYSQL">
                SELECT
                	hostID,
                    uniqueID,
                    familyLastName,
                    fatherLastName,
                    fatherFirstName,
                    fatherMiddleName,
                    fatherBirth,
                    fatherDOB,
                    fatherSSN,
                    father_cell,
                    fatherCBC_form,
                    fatherDriver,
                    fatherCompany,
                    fatherWorkPhone,
                    fatherWorkPosition,
                    fatherWorkType,
                    motherLastName,
                    motherFirstName,
                    motherMiddleName,
                    motherBirth,
                    motherDOB,
                    motherSSN,
                    mother_cell,
                    motherCBC_form,
                    motherDriver,
                    motherCompany,
                    motherWorkPhone,
                    motherWorkPosition,
                    motherWorkType,
                    address,
                    address2,
                    city,
                    state,
                    zip,
                    datesOfResidence,
                    mailAddress,
                    mailCity,
                    mailState,
                    mailZip,
                    phone,
                    fax,
                    email,
                    emergency_contact_name,
                    emergency_phone,
                    yrsAtAddress,
                    regionID,
                    schoolID,
                    schoolCosts,
                    schoolDistance,
                    schoolTransportation,
                    cityPopulation,
                    communityType,
                    nearBigCity,
                    bigCityDistance,
                    local_air_code,
                    major_air_code,
                    airport_city,
                    airport_state,
                    sexPref,
                    hostSmokes,
                    acceptSmoking,
                    smokeConditions,
                    areaRepID,
                    active,
                    dateProcessed,
                    current_state,
                    approved,
                    interests,
                    interests_other,
                    band,
                    orchestra,
                    comp_sports,
                    pet_allergies,
                    religion,
                    churchID,
                    religious_participation,
                    churchFam,
                    churchTrans,
                    attendChurch,
                    houserules_smoke,
                    houserules_curfewWeekNights,
                    houserules_curfewWeekends,
                    houserules_chores,
                    houserules_church,
                    houserules_other,
                    population,
                    near_city,
                    near_city_dist,
                    near_pop,
                    neighborhood,
                    community,
                    terrain1,
                    terrain2,
                    terrain3,
                    terrain3_desc,
                    winterTemp,
                    summerTemp,
                    special_cloths,
                    point_interest,
                    school_trans,
                    other_trans,
                    familyLetter,
                    pictures,
                    applicationSent,
                    applicationApproved,
                    previousHost,
                    home_first_call,
                    home_last_visit,
                    home_visited,
                    pert_info,
                    companyID,
                    host_start_date,
                    host_end_date,
                    studentHosting,
                    imported         
                FROM 
                    smg_hosts
                    
               
                    WHERE
                        hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
               
                    
                ORDER BY 
                    familyLastName
		</cfquery>
     

<cfoutput>
<img src="https://ise.exitsapplication.com/nsmg/pics/#client.companyid#_short_profile_header.jpg" />
<p>As mandated by the Department of State, a Criminal Background Check on all Office Staff, Regional Directors/
  Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is 
  required for involvement with the J-1 Secondary School Exchange Visitor Program.. </p>

<div class="scroll">
         
  <p>I, 
  <cfif isDefined('form.childID')>
  <strong>#qGetMemberInfo.name# #qGetMemberInfo.lastname# </strong>
  <cfelse>
  <strong>#qGetUserInfo.firstName# #qGetUserInfo.middlename# #qGetUserInfo.lastname#</strong></cfif> do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and any such disclosures.</p>
<p>Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
purposes and for the release of information that will be considered in determining any suitability for participation in the
Exchange Program.</p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
request from General Information Services, Inc. information about the nature and substance of all records on file about me
at the time of my request. This may include the type of information requested as well as those who requested reports from
General Information Services, Inc. within the two-year period preceding my request.  </p>

<Table>
	<Tr>
    	<Td>
             <table>
                <Tr>
                    <td><u>Current Address</u></td>
                </Tr>
                <Tr>    
                   <Td><strong>#qGetUserInfo.address#<Br>
                   <Cfif qGetUserInfo.address2 is not ''> #qGetUserInfo.address2#<Br></Cfif>
                   #qGetUserInfo.city# #qGetUserInfo.state#, #qGetUserInfo.zip#</strong>
                   </Td>
                </Tr>
            
             </table>   
          </Td>
         
	</tr>
</Table> 
<hr width=50% align="center" />

  </cfoutput>