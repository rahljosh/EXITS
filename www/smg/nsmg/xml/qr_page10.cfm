

	<!--- NEW DPT-DT --->

		<cfquery name="insert_dpt" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, shot1, shot2, shot3, shot4, shot5, booster)
				VALUES ('#client.studentid#', 'StudentXMLFile.applications.application[i].page10.vaccines.dose.description.XmlText#', 
					StudentXMLFile.applications.application[i].page10.vaccines.dose.description.XmlText
					<cfif form.dpt2 is ''>null,<cfelse>#CreateODBCDate(form.dpt2)#,</cfif>
					<cfif form.dpt3 is ''>null,<cfelse>#CreateODBCDate(form.dpt3)#,</cfif>
					<cfif form.dpt4 is ''>null,<cfelse>#CreateODBCDate(form.dpt4)#,</cfif>
					<cfif form.dpt5 is ''>null,<cfelse>#CreateODBCDate(form.dpt5)#,</cfif>
					<cfif form.dpt_booster is ''>null<cfelse>#CreateODBCDate(form.dpt_booster)#</cfif>	)
		</cfquery>

	
	<!--- NEW TOPV --->
	<cfif IsDefined('form.new_topv')>
		<cfquery name="insert_topv" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, disease, shot1, shot2, shot3, booster)
				VALUES ('#form.studentid#', '#form.new_topv#', 
					<cfif form.topv_disease is ''>null,<cfelse>#CreateODBCDate(form.topv_disease)#,</cfif>
					<cfif form.topv1 is ''>null,<cfelse>#CreateODBCDate(form.topv1)#,</cfif>
					<cfif form.topv2 is ''>null,<cfelse>#CreateODBCDate(form.topv2)#,</cfif>
					<cfif form.topv3 is ''>null,<cfelse>#CreateODBCDate(form.topv3)#,</cfif>
					<cfif form.topv_booster is ''>null<cfelse>#CreateODBCDate(form.topv_booster)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE TOPV --->
	<cfif IsDefined('form.upd_topv')>
		<cfquery name="update_topv" datasource="MySql">
			UPDATE smg_student_app_shots
				SET disease = <cfif form.topv_disease is ''>null,<cfelse>#CreateODBCDate(form.topv_disease)#,</cfif>
					shot1 = <cfif form.topv1 is ''>null,<cfelse>#CreateODBCDate(form.topv1)#,</cfif>
					shot2 = <cfif form.topv2 is ''>null,<cfelse>#CreateODBCDate(form.topv2)#,</cfif>
					shot3 = <cfif form.topv3 is ''>null,<cfelse>#CreateODBCDate(form.topv3)#,</cfif>
					booster = <cfif form.topv_booster is ''>null<cfelse>#CreateODBCDate(form.topv_booster)#</cfif>
				WHERE vaccineid = '#form.upd_topv#'
		</cfquery>	
	</cfif>
	
	<!--- NEW MEASLES --->
	<cfif IsDefined('form.new_measles')>
		<cfquery name="insert_measles" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, disease, shot1, shot2, booster)
				VALUES ('#form.studentid#', '#form.new_measles#', 
					<cfif form.measles_disease is ''>null,<cfelse>#CreateODBCDate(form.measles_disease)#,</cfif>
					<cfif form.measles1 is ''>null,<cfelse>#CreateODBCDate(form.measles1)#,</cfif>
					<cfif form.measles2 is ''>null,<cfelse>#CreateODBCDate(form.measles2)#,</cfif>
					<cfif form.measles_booster is ''>null<cfelse>#CreateODBCDate(form.measles_booster)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE MEASLES --->
	<cfif IsDefined('form.upd_measles')>
		<cfquery name="update_measles" datasource="MySql">
			UPDATE smg_student_app_shots
				SET disease = <cfif form.measles_disease is ''>null,<cfelse>#CreateODBCDate(form.measles_disease)#,</cfif>
					shot1 = <cfif form.measles1 is ''>null,<cfelse>#CreateODBCDate(form.measles1)#,</cfif>
					shot2 = <cfif form.measles2 is ''>null,<cfelse>#CreateODBCDate(form.measles2)#,</cfif>
					booster = <cfif form.measles_booster is ''>null<cfelse>#CreateODBCDate(form.measles_booster)#</cfif>
				WHERE vaccineid = '#form.upd_measles#'
		</cfquery>	
	</cfif>	
	
	<!--- NEW MUMPS --->
	<cfif IsDefined('form.new_mumps')>
		<cfquery name="insert_mumps" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, disease, shot1, shot2, booster)
				VALUES ('#form.studentid#', '#form.new_mumps#', 
					<cfif form.mumps_disease is ''>null,<cfelse>#CreateODBCDate(form.mumps_disease)#,</cfif>
					<cfif form.mumps1 is ''>null,<cfelse>#CreateODBCDate(form.mumps1)#,</cfif>
					<cfif form.mumps2 is ''>null,<cfelse>#CreateODBCDate(form.mumps2)#,</cfif>
					<cfif form.mumps_booster is ''>null<cfelse>#CreateODBCDate(form.mumps_booster)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE MUMPS --->
	<cfif IsDefined('form.upd_mumps')>
		<cfquery name="update_mumps" datasource="MySql">
			UPDATE smg_student_app_shots
				SET disease = <cfif form.mumps_disease is ''>null,<cfelse>#CreateODBCDate(form.mumps_disease)#,</cfif>
					shot1 = <cfif form.mumps1 is ''>null,<cfelse>#CreateODBCDate(form.mumps1)#,</cfif>
					shot2 = <cfif form.mumps2 is ''>null,<cfelse>#CreateODBCDate(form.mumps2)#,</cfif>
					booster = <cfif form.mumps_booster is ''>null<cfelse>#CreateODBCDate(form.mumps_booster)#</cfif>
				WHERE vaccineid = '#form.upd_mumps#'
		</cfquery>	
	</cfif>	

	<!--- NEW RUBELLA --->
	<cfif IsDefined('form.new_rubella')>
		<cfquery name="insert_rubella" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, disease, shot1, shot2, booster)
				VALUES ('#form.studentid#', '#form.new_rubella#', 
					<cfif form.rubella_disease is ''>null,<cfelse>#CreateODBCDate(form.rubella_disease)#,</cfif>
					<cfif form.rubella1 is ''>null,<cfelse>#CreateODBCDate(form.rubella1)#,</cfif>
					<cfif form.rubella2 is ''>null,<cfelse>#CreateODBCDate(form.rubella2)#,</cfif>
					<cfif form.rubella_booster is ''>null<cfelse>#CreateODBCDate(form.rubella_booster)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE RUBELLA --->
	<cfif IsDefined('form.upd_rubella')>
		<cfquery name="update_rubella" datasource="MySql">
			UPDATE smg_student_app_shots
				SET disease = <cfif form.rubella_disease is ''>null,<cfelse>#CreateODBCDate(form.rubella_disease)#,</cfif>
					shot1 = <cfif form.rubella1 is ''>null,<cfelse>#CreateODBCDate(form.rubella1)#,</cfif>
					shot2 = <cfif form.rubella2 is ''>null,<cfelse>#CreateODBCDate(form.rubella2)#,</cfif>
					booster = <cfif form.rubella_booster is ''>null<cfelse>#CreateODBCDate(form.rubella_booster)#</cfif>
				WHERE vaccineid = '#form.upd_rubella#'
		</cfquery>	
	</cfif>		

	<!--- NEW VARICELLA --->
	<cfif IsDefined('form.new_varicella')>
		<cfquery name="insert_varicella" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, disease, shot1, shot2, booster)
				VALUES ('#form.studentid#', '#form.new_varicella#', 
					<cfif form.varicella_disease is ''>null,<cfelse>#CreateODBCDate(form.varicella_disease)#,</cfif>
					<cfif form.varicella1 is ''>null,<cfelse>#CreateODBCDate(form.varicella1)#,</cfif>
					<cfif form.varicella2 is ''>null,<cfelse>#CreateODBCDate(form.varicella2)#,</cfif>
					<cfif form.varicella_booster is ''>null<cfelse>#CreateODBCDate(form.varicella_booster)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE VARICELLA --->
	<cfif IsDefined('form.upd_varicella')>
		<cfquery name="update_varicella" datasource="MySql">
			UPDATE smg_student_app_shots
				SET disease = <cfif form.varicella_disease is ''>null,<cfelse>#CreateODBCDate(form.varicella_disease)#,</cfif>
					shot1 = <cfif form.varicella1 is ''>null,<cfelse>#CreateODBCDate(form.varicella1)#,</cfif>
					shot2 = <cfif form.varicella2 is ''>null,<cfelse>#CreateODBCDate(form.varicella2)#,</cfif>
					booster = <cfif form.varicella_booster is ''>null<cfelse>#CreateODBCDate(form.varicella_booster)#</cfif>
				WHERE vaccineid = '#form.upd_varicella#'
		</cfquery>	
	</cfif>

	<!--- NEW HEPATITIS --->
	<cfif IsDefined('form.new_hepatitis')>
		<cfquery name="insert_hepatitis" datasource="MySql">
			INSERT INTO smg_student_app_shots (studentid, vaccine, shot1, shot2, shot3)
				VALUES ('#form.studentid#', '#form.new_hepatitis#', 
					<cfif form.hepatitis1 is ''>null,<cfelse>#CreateODBCDate(form.hepatitis1)#,</cfif>
					<cfif form.hepatitis2 is ''>null,<cfelse>#CreateODBCDate(form.hepatitis2)#,</cfif>
					<cfif form.hepatitis3 is ''>null<cfelse>#CreateODBCDate(form.hepatitis3)#</cfif>	)
		</cfquery>
	</cfif>
	<!--- UPDATE HEPATITIS --->
	<cfif IsDefined('form.upd_hepatitis')>
		<cfquery name="update_hepatitis" datasource="MySql">
			UPDATE smg_student_app_shots
				SET shot1 = <cfif form.hepatitis1 is ''>null,<cfelse>#CreateODBCDate(form.hepatitis1)#,</cfif>
					shot2 = <cfif form.hepatitis2 is ''>null,<cfelse>#CreateODBCDate(form.hepatitis2)#,</cfif>
					shot3 = <cfif form.hepatitis3 is ''>null<cfelse>#CreateODBCDate(form.hepatitis3)#</cfif>
				WHERE vaccineid = '#form.upd_hepatitis#'
		</cfquery>	
	</cfif>
