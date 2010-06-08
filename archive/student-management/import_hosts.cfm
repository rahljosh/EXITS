<cfquery name="get_old_hosts" datasource="oldphp">
select *
from hosts
</cfquery>

<cfloop query="get_old_hosts">
<cfset unqid='#CreateUUID()#'>
	<cfquery name="insert_hosts" datasource="mysql">
	insert into smg_hosts 
			(familylastname, fatherlastname, fatherfirstname,
			  fatherbirth,
			   fathercompany,
			    fatherworkphone,
				 fatherworkposition, 
			fatherworktype, 
			 motherlastname,
			  motherfirstname, 
			   motherbirth,
			    mothercompany,
				 motherworkphone, 
				 motherworkposition,
				  motherworktype, 
			 address,
			  city,
			   state,
			    zip,
				 phone,
				   email,
				     nearbigcity,
					  
					   airport_city,
					    airport_state, 
			imported,
			 uniqueid)
	 values('#hos_last_name#',
	 '#hos_father_last_name#',
	 '#hos_father_name#',
	 <cfif hos_father_birth_year is ''>0<cfelse>#hos_father_birth_year#</cfif>,
	  '#hos_father_company#',
	  '#hos_father_bus_phone#', '#hos_father_occ#', 		            '#hos_father_occ_type#',
	        '#hos_mother_last_name#', '#hos_mother_name#', <cfif hos_mother_birth_year is ''>0<cfelse>#hos_mother_birth_year#</cfif>, '#hos_mother_company#', '#hos_mother_bus_phone#',  '#hos_mother_occ#', '#hos_mother_occ_type#',
			'#hos_street#', '#hos_city#', '#hos_state#', '#hos_zip#', '#hos_phone#', '#hos_email#', '#hos_near_city#', '#hos_airport_city#', '#hos_airport_state#', 		   			1,'#unqid#')
	</cfquery>
</cfloop>
