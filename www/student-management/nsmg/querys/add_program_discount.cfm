
<Cfquery name="programs" datasource="MySQL">
select *
from smg_programs
<cfif #client.companyid# is 5>
<cfelse> 
where companyid = #client.companyid#
</cfif>
</Cfquery>

<cfoutput query="programs">

	<cfif isDefined('form.#programid#_discount_amount')>
		<cfquery name="add_discount" datasource="MySQL">
		insert into smg_program_discount (programid, userid, dicount_amount, discount_type)
								values(#form.
						
		</cfquery>
		
	</cfif>
	
</cfoutput>