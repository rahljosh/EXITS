<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">

	<cfquery name="update_student" datasource="#APPLICATION.DSN#">
		UPDATE 
        	smg_students
		SET	
			<cfif IsDefined('form.interests')>
            	interests = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.interests#">,
			<cfelse>
            	interests = '',
			</cfif>  
			app_other_interest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_other_interest#">,
			<cfif IsDefined('form.band')>
            	band = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.band#">,
			</cfif>
			<cfif IsDefined('form.orchestra')>
            	orchestra = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.orchestra#">,
			</cfif>
			app_play_instrument = <cfqueryparam value="#form.app_play_instrument#" cfsqltype="cf_sql_varchar">,
			<cfif IsDefined('form.comp_sports')>
            	comp_sports = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.comp_sports#">,
			</cfif>
			app_play_sport = <cfqueryparam value="#form.app_play_sport#" cfsqltype="cf_sql_varchar">,
          	religious_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.religious_participation#">,
			churchgroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.churchgroup#">,
			<cfif IsDefined('form.churchfam')>
            	churchfam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.churchfam#">,
			</cfif>
			<cfif IsDefined('form.smoke')>
            	smoke = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.smoke#">,
			</cfif>
			<cfif IsDefined('form.animal_allergies')>
            	animal_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal_allergies#">,
			</cfif>
			app_allergic_animal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_allergic_animal#">,
			<cfif IsDefined('form.app_take_medicine')>
            	app_take_medicine = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_take_medicine#">,
			</cfif>
			<cfif IsDefined('form.med_allergies')>
            	med_allergies = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.med_allergies#">,
			</cfif>
			app_allergic_medication = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.app_allergic_medication#">,     
			<cfif form.yearsenglish is not ''>
           		yearsenglish = <cfqueryparam value="#form.yearsenglish#" cfsqltype="cf_sql_tinyint">
			<cfelse>
            	yearsenglish = NULL
			</cfif>,
			chores_list = <cfqueryparam value="#form.chores_list#" cfsqltype="cf_sql_varchar">,
			app_reasons_student = <cfqueryparam value="#form.app_reasons_student#" cfsqltype="cf_sql_varchar">
		WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
		LIMIT 1
	</cfquery>
    
    <cfquery name="qGetPrimaryLanguage" datasource="#APPLICATION.DSN#">
    	SELECT
        	*
      	FROM
        	smg_student_app_language
      	WHERE
        	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
       	AND
        	isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <!--- Update Primary Language --->
    <cfif (qGetPrimaryLanguage.recordCount)>
    	<cfquery datasource="#APPLICATION.DSN#">
        	UPDATE
            	smg_student_app_language
          	SET
                languageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.languageID#">,
                dateUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
           	WHERE
            	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentid#">
            AND
                isPrimary = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        </cfquery>
    <!--- Insert Primary Language --->
    <cfelse>
    	<cfquery datasource="#APPLICATION.DSN#">
        	INSERT INTO
            	smg_student_app_language
               		( studentID,
                    languageID,
                    isPrimary,
                    dateCreated )
           	VALUES
            	( <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.studentID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.languageID#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#"> )
        </cfquery>
    </cfif>

	<html>
	<head>
	<script language="JavaScript">
	<!-- 
	alert("You have successfully updated this page. Thank You.");
	<cfif NOT IsDefined('url.next')>
		location.replace("?curdoc=section1/page3&id=1&p=3");
	<cfelse>
		location.replace("?curdoc=section1/page4&id=1&p=4");
	</cfif>
	//-->
	</script>
	</head>
	</html>
    
</cftransaction>
