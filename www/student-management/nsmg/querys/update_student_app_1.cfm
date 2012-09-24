<cftransaction action="BEGIN" isolation="SERIALIZABLE">
<cfif #form.heightcm# is ''>
<Cfset height = #form.height#>
<cfelse>
<cfset feet = (#form.heightcm# / 30.48)>
<cfset inches = (#RemoveChars(feet, 1,1)# * 30.48 / 2.54)>
<cfset height = #Left(feet,1)# & "'" & #Round(inches)# & "''" >
</cfif>
<cfquery name="update_student_app_1" datasource="MySQL">
	UPDATE
    	smg_students
  	SET
    	familylastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.familyname#">,
        firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.firstname#">,
        middlename = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.middlename#">,
        address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address#">,
        address2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.address2#">,
        city = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.city#">,
   		country = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.country#">,
		zip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.zip#">,
        phone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.phone#">,
        fax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.fax#">,
        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.email#">,
        <cfif IsDefined('form.sex')>
        	sex = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.sex#">,
		</cfif>        
        countryresident = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countryresidence#">,
        countrycitizen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.countrycitizinship#">,
        passportnumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.passport#">,
        dob = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.dob)#">,
        citybirth = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.citybirth#">,
        countrybirth = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.countrybirth#">,
        haircolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.haircolor#">,
        eyecolor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.eyecolor#">,
        height = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.height#">,
        weight = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.weight#">
  	WHERE
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.studentID)#">				
</cfquery>

<cfoutput>
<cflocation url="../index.cfm?curdoc=forms/student_App_2" addtoken="No">
</cfoutput>
</body>
</html>
