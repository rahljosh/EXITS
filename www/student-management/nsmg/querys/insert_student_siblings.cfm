<cfif isdefined('form.update')>

	<cfloop From = "1" To = "#form.count#" Index = "x">
		<cftransaction action="BEGIN" isolation="SERIALIZABLE">
            <cfquery name="update_siblings" datasource="MySQL">
                UPDATE
                    smg_student_siblings
                SET
                    name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['name' & x]#">,
                    <cfif FORM['dob' & x] IS NOT ''>
                        birthdate = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form['dob' & x])#">,
                    </cfif>
                    sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['sex' & x]#">,
                    liveathome = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['athome' & x]#">
                WHERE
                    childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form['childid' & x]#">
            </cfquery>
		</cftransaction>
	</cfloop>
    
<cfelse>

	<!--- NEW SIBLINGS UP TO 5 PER TIME --->
	<cfloop From = "1" To = "5" Index = "x">
		<cfif form["name" & x] IS NOT ''>
			<cftransaction action="BEGIN" isolation="SERIALIZABLE">
                <cfquery name="insert_kids" datasource="MySQL">
                	INSERT INTO smg_student_siblings
                  	(
                    	name,
                        studentID,
                        <cfif FORM['dob' & x] IS NOT ''>
                        	birthdate,
                      	</cfif>
                        sex,
                        liveathome 	
                    )
                    VALUES
                    (
                    	<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM['name' & x]#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">,
                        <cfif FORM['dob' & x] IS NOT ''>
                        	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(form['dob' & x])#">,
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['sex' & x]#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['athome' & x]#">
                    )
                </cfquery>
			</cftransaction>
		</cfif>
	</cfloop>

</cfif>

<cflocation url="../index.cfm?curdoc=forms/student_app_4" addtoken="no">