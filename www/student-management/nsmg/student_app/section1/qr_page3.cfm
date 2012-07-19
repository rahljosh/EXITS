<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftransaction action="begin" isolation="serializable">

	<cfquery name="update_student" datasource="MySql">
		UPDATE smg_students
		SET	<cfif not IsDefined('form.interests')>interests = '',<cfelse>interests = '#form.interests#',</cfif>  
			app_other_interest = '#form.app_other_interest#',
			<cfif IsDefined('form.band')>band = '#form.band#',</cfif>
			<cfif IsDefined('form.orchestra')>orchestra = '#form.orchestra#',</cfif>
			app_play_instrument = <cfqueryparam value="#form.app_play_instrument#" cfsqltype="cf_sql_varchar">,
			<cfif IsDefined('form.comp_sports')>comp_sports = '#form.comp_sports#',</cfif>
			app_play_sport = <cfqueryparam value="#form.app_play_sport#" cfsqltype="cf_sql_varchar">,
			religious_participation = '#form.religious_participation#',
			churchgroup = '#form.churchgroup#',
			<cfif IsDefined('form.churchfam')>churchfam = '#form.churchfam#',</cfif>
			<cfif IsDefined('form.smoke')>smoke = '#form.smoke#',</cfif>
			<cfif IsDefined('form.animal_allergies')>animal_allergies = '#form.animal_allergies#',</cfif>
			app_allergic_animal = '#form.app_allergic_animal#',
			<cfif IsDefined('form.app_take_medicine')>app_take_medicine = '#form.app_take_medicine#',</cfif>
			<cfif IsDefined('form.med_allergies')>med_allergies = '#form.med_allergies#',</cfif>
			app_allergic_medication = '#form.app_allergic_medication#',
			yearsenglish = <cfif form.yearsenglish is not ''><cfqueryparam value="#form.yearsenglish#" cfsqltype="cf_sql_tinyint"><cfelse>NULL</cfif>,
			chores_list = <cfqueryparam value="#form.chores_list#" cfsqltype="cf_sql_varchar">,
			app_reasons_student = <cfqueryparam value="#form.app_reasons_student#" cfsqltype="cf_sql_varchar">
		WHERE studentid = '#form.studentid#'
		LIMIT 1
	</cfquery>
    
    <cfquery name="qGetPrimaryLanguage" datasource="MySql">
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
    	<cfquery datasource="MySql">
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
    	<cfquery datasource="MySql">
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
