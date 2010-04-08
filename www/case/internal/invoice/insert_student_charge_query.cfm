<!--- CHECK INVOICE RIGHTS ---->
<cfinclude template="check_rights.cfm">

<cftransaction action="begin" isolation="serializable">

	<cfloop list=#form.studentid# index="x">
		<cfif #Evaluate("FORM." & x & "deposit_amount")# is not ''>
		<Cfquery name="create_Student_charges" datasource="caseusa">
			insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
			values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "deposit_type")#', #now()#, #Evaluate("FORM." & x & "deposit_amount")#, #client.userid#, '#Evaluate("FORM." & x & "deposit_description")#', #client.companyid#, #Evaluate("FORM." & x & "deposit_amount")#)
		</Cfquery>
		</cfif>
	<!----Check if final charge field is valid---->
	
			<cfif #Evaluate("FORM." & x & "final_amount")# is not ''>
			<cfset amount_deposit = #Evaluate("FORM." & x & "final_amount")# - 500>
				<Cfquery name="input_final_charge" datasource="caseusa">
				insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid,amount_due)
				values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "final_type")#', #now()#, #Evaluate("FORM." & x & "final_amount")#, #client.userid#, '#Evaluate("FORM." & x & "final_description")#', #client.companyid#, #amount_deposit#)
			    </Cfquery>
			</cfif>
			
	<!----Check if insurance field is valid---->
			<cfif #Evaluate("FORM." & x & "insurance_amount")# is not ''>
				<Cfquery name="input_final_charge" datasource="caseusa">
				insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
				values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "insurance_type")#', #now()#, #Evaluate("FORM." & x & "insurance_amount")#, #client.userid#, '#Evaluate("FORM." & x & "insurance_description")#', #client.companyid#, #Evaluate("FORM." & x & "insurance_amount")#)
			    </Cfquery>
			</cfif>
			
	<!----Check if guarantee field is valid---->
			<cfif #Evaluate("FORM." & x & "guarantee_amount")# is not ''>
				<Cfquery name="input_final_charge" datasource="caseusa">
				insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
				values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "guarantee_type")#', #now()#, #Evaluate("FORM." & x & "guarantee_amount")#, #client.userid#, '#Evaluate("FORM." & x & "guarantee_description")#', #client.companyid#, #Evaluate("FORM." & x & "guarantee_amount")#)
			    </Cfquery>
			</cfif>
	<!----Check if sevis field is valid---->
			<cfif #Evaluate("FORM." & x & "sevis_amount")# is not ''>
				<Cfquery name="input_final_charge" datasource="caseusa">
				insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
				values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "sevis_type")#', #now()#, #Evaluate("FORM." & x & "sevis_amount")#, #client.userid#, '#Evaluate("FORM." & x & "sevis_description")#', #client.companyid#, #Evaluate("FORM." & x & "sevis_amount")#)
			    </Cfquery>
			</cfif>		
			
	<!----Check if direct placement field is valid---->
			<cfif #Evaluate("FORM." & x & "direct_placement")# is not ''>
				<Cfquery name="input_final_charge" datasource="caseusa">
				insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
				values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "direct_placement")#', #now()#, #Evaluate("FORM." & x & "direct_placement_amount")#, #client.userid#, '#Evaluate("FORM." & x & "direct_placement_description")#', #client.companyid#, #Evaluate("FORM." & x & "direct_placement_amount")#)
			    </Cfquery>
			</cfif>		
			
	<!----Check if direct placement field is valid---->
		<cfif #Evaluate("FORM." & x & "direct_placement_guarantee_disc")# is not ''>
			<Cfquery name="input_final_charge" datasource="caseusa">
			insert into smg_charges	(agentid, stuid, programid, type, date, amount, userinput, description, companyid, amount_due)
			values(#form.agentid#, #x#, '#Evaluate("FORM." & x & "programid")#', '#Evaluate("FORM." & x & "direct_placement_guarantee_disc")#', #now()#, #Evaluate("FORM." & x & "direct_placement_guarantee_disc_amount")#, #client.userid#, '#Evaluate("FORM." & x & "direct_placement_guarantee_disc_desc")#', #client.companyid#, #Evaluate("FORM." & x & "direct_placement_guarantee_disc_amount")#)
			</Cfquery>
		</cfif>	
	
	</cfloop>
</cftransaction>
<cflocation url="add_charge.cfm?userid=#form.agentid#" addtoken="yes">
