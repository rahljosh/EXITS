		<!----Upload File---->
		<cffile action = "upload"
				destination = "d:\websites\nsmg\uploadedfiles\cbc_auth\household\"
				fileField = "file_upload"
				nameConflict = "overwrite">
		
		<!----Check Image Size--->

		<cffile	action="Move" 
				source="d:\websites\nsmg\uploadedfiles\cbc_auth\household\#CFFILE.ServerFile#" 
				destination="d:\websites\nsmg\uploadedfiles\cbc_auth\household\#url.id#_#url.userid#.#cffile.clientfileext#">
			 
		  <!----Check if file has been uploaded---->
		  <cfquery name="check_file" datasource="caseusa">
			  update smg_user_family
			 set  auth_received = 1,
			 		auth_received_type = '#cffile.clientfileext#'
			  WHERE userid  = '#url.userid#'
		  </cfquery>
		  <cfquery name="userid" datasource="caseusa">
		  select userid
		  from smg_users
		  where uniqueid = '#url.id#'
		  </cfquery>
		  

		 
		  <cflocation url="../index.cfm?curdoc=user_info&userid=#userid.userid#">