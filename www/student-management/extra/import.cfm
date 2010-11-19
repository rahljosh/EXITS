<!----Importing of Host Companies
<cfquery name="oc" datasource="wat">
select * 
from company
</cfquery>

<cfoutput query="oc">
<cfquery name="state" datasource="mySQL">
select id
from smg_states
where state = '#comp_sta#'
</cfquery>
<cfquery name="insert" datasource="mysql">
insert into extra_hostcompany (business_typeid, entrydate, name, address, city, state, zip, phone, fax, email, homepage, supervisor, supervisor_title, 
								description, closest_airport, observations, recruteddirectly, enteredby, housing_options, accomidation_desc, oldid)
						values (<cfif typeofbusiness is ''>0<cfelse>#typeofbusiness#</cfif>, #now()#, '#comp_name#', '#comp_add#', '#comp_city#', <cfif state.recordcount eq 0>0<cfelse>#state.id#</cfif>, '#comp_zip#', '#comp_pho#', '#comp_fax#', '#comp_email#', '#homepage#', '#comp_supervisor#', '#comp_supervisor_title#', '#description#', '#closestairport#', '#observations#', <cfif recruteddirectly eq 'yes'>1<cfelse>0</cfif>, 1, <cfif typaccommodation is ''>0<cfelse>#typaccommodation#</cfif>, '#description#', #comp_id#)
</cfquery>
</cfoutput>
---->

<!----Importing of Students---->
<cfquery name="candidates" datasource="wat">
select *
from ws_student
where stu_stay_Active = 1
</cfquery>

<cfoutput query="candidates">
	<cfquery name="insert_candidates" datasource="MySQL">
	insert into extra_candidates (companyid, programid, intrep, uniqueid, subfield, fieldstudyid, entrydate, firstname, middlename, lastname, sex, dob, home_address, home_city, home_zip, home_country, home_phone, birth_city, birth_country, citizen_country, residence_country, emergency_phone, emergency_name, emergency_relationship, email, status, cancel_Date, insu_Date, insu_Cancel_date, placeby, remarks, degree, degree_other, degree_comments, personal_info, missing_documents, doc_application, doc_resume, doc_proficiency, doc_passportphoto, doc_recom_letter, doc_insu, doc_sponsor_letter, trainee_sponser, earliestarrival, latestarrival, arrivaldate, startdate, enddate, ds2019, ds2019_posistion, ds2019_subject, ds2019_street, ds2019_city, ds2019_state, ds2019_zip, ds2019_startdate, ds2019_enddate, housing, hostcompanyid, h2b_participated, passport_number, passport_Date, passport_country, passport_expires, ssn, oldid)
		values(9, 
	</cfquery>
</cfoutput>

<!----Importing Jobs---->
<!---- Had the edit tables to get to import
<cfquery name="jobs" datasource="wat">
select *
from WS_jobsavailablepercompany
</cfquery>

<cfoutput query="jobs">
	<cfquery name="companyid" datasource="mysql">
	select hostcompanyid
	from extra_hostcompany
	where oldid = #WS_jobavailable#
	</cfquery>
	<cfquery name="insert_jobs" datasource="MySQL">
	insert into extra_jobs  (title, description, wage,  wage_type, hours, hostcompanyid, avail_posistion, sex)
				value ('#job#','#description#',<cfif wage is ''>0.00<cfelse>#wage#</cfif>,
				<cfif wage_type is '' or wage_type is 'hourly'>'hourly'
				<cfelseif wage_type is 'per week' or wage_type is 'weekly'>'weekly'
				<cfelseif wage_type is 'shift'>'shift'<cfelse>'hourly'</cfif>,'#hoursweek#', #companyid.hostcompanyid#, <cfif number is ''>0<cfelse>#number#</cfif>, <cfif stu_sex is 'E'>0<cfelseif stu_sex is 'M'>1<cfelseif stu_sex is 'F'>2<cfelse>0</cfif>)
	</cfquery>
</cfoutput>
---->