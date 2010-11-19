		<!----Upload File---->
		<cffile action = "upload"
				destination = "d:\websites\nsmg\uploadedfiles\cbc_auth\"
				fileField = "file_upload"
				nameConflict = "overwrite">
		
		<!----Check Image Size--->

		<cffile	action="Move" 
				source="d:\websites\nsmg\uploadedfiles\cbc_auth\#CFFILE.ServerFile#" 
				destination="d:\websites\nsmg\uploadedfiles\cbc_auth\#url.id#.#cffile.clientfileext#">
			 
		  <!----Check if file has been uploaded---->
		  <cfquery name="check_file" datasource="mysql">
			  update smg_users
			 set  cbc_auth_received = 1,
			 		cbc_auth_type = '#cffile.clientfileext#'
			  WHERE uniqueid  = '#url.id#'
		  </cfquery>
		  
		  <cfquery name="userid" datasource="mysql">
		  select userid
		  from smg_users
		  where uniqueid = '#url.id#'
		  </cfquery>
		  

		 
		  <cflocation url="../index.cfm?curdoc=user_info&userid=#userid.userid#">