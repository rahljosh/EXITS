<cfif not IsDefined('form.studentid')>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<cftry>

    <cffunction name="insertVaccine">
        <cfargument name="studentID" required="yes">
        <cfargument name="vaccine" required="yes">
        <cfargument name="disease" default="">
        <cfargument name="shot1" default="">
        <cfargument name="shot2" default="">
        <cfargument name="shot3" default="">
        <cfargument name="shot4" default="">
        <cfargument name="shot5" default="">
        <cfargument name="booster" default="">
        
        <cfquery datasource="#APPLICATION.DSN#">
            INSERT INTO smg_student_app_shots(
                studentID,
                vaccine,
                disease,
                shot1,
                shot2,
                shot3,
                shot4,
                shot5,
                booster )
            VALUES(
                <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.studentID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#ARGUMENTS.vaccine#">,
                <cfif ARGUMENTS.disease EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.disease)#"></cfif>,
                <cfif ARGUMENTS.shot1 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot1)#"></cfif>,
                <cfif ARGUMENTS.shot2 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot2)#"></cfif>,
                <cfif ARGUMENTS.shot3 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot3)#"></cfif>,
                <cfif ARGUMENTS.shot4 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot4)#"></cfif>,
                <cfif ARGUMENTS.shot5 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot5)#"></cfif>,
                <cfif ARGUMENTS.booster EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.booster)#"></cfif> )
        </cfquery>
    
    </cffunction>
    
    <cffunction name="updateVaccine">
        <cfargument name="vaccineID" required="yes">
        <cfargument name="disease" default="">
        <cfargument name="shot1" default="">
        <cfargument name="shot2" default="">
        <cfargument name="shot3" default="">
        <cfargument name="shot4" default="">
        <cfargument name="shot5" default="">
        <cfargument name="booster" default="">
        
        <cfquery datasource="#APPLICATION.DSN#">
            UPDATE smg_student_app_shots
            SET
            	disease = <cfif ARGUMENTS.disease EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.disease)#"></cfif>,
                shot1 = <cfif ARGUMENTS.shot1 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot1)#"></cfif>,
                shot2 = <cfif ARGUMENTS.shot2 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot2)#"></cfif>,
                shot3 = <cfif ARGUMENTS.shot3 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot3)#"></cfif>,
                shot4 = <cfif ARGUMENTS.shot4 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot4)#"></cfif>,
                shot5 = <cfif ARGUMENTS.shot5 EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.shot5)#"></cfif>,
                booster = <cfif ARGUMENTS.booster EQ "">NULL<cfelse><cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(ARGUMENTS.booster)#"></cfif>
            WHERE vaccineID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.vaccineID#">
        </cfquery>
    
    </cffunction>
    
    <cfscript>
		// DTaP
        if (IsDefined('FORM.new_dpt')) {
            insertVaccine(FORM.studentID,FORM.new_dpt,"",FORM.dpt1,FORM.dpt2,FORM.dpt3,FORM.dpt4,FORM.dpt5,FORM.dpt_booster);
        } else if (IsDefined('FORM.upd_dpt')) {
            updateVaccine(FORM.upd_dpt,"",FORM.dpt1,FORM.dpt2,FORM.dpt3,FORM.dpt4,FORM.dpt5,FORM.dpt_booster);
        }
		// TOPV
		if (IsDefined('FORM.new_dpt')) {
            insertVaccine(FORM.studentID,FORM.new_topv,FORM.topv_disease,FORM.topv1,FORM.topv2,FORM.topv3,"","",FORM.topv_booster);
        } else if (IsDefined('FORM.upd_dpt')) {
            updateVaccine(FORM.upd_topv,FORM.topv_disease,FORM.topv1,FORM.topv2,FORM.topv3,"","",FORM.topv_booster);
        }
		// MEASLES
		if (IsDefined('FORM.new_measles')) {
            insertVaccine(FORM.studentID,FORM.new_measles,FORM.measles_disease,FORM.measles1,FORM.measles2,"","","",FORM.measles_booster);
        } else if (IsDefined('FORM.upd_measles')) {
            updateVaccine(FORM.upd_measles,FORM.measles_disease,FORM.measles1,FORM.measles2,"","","",FORM.measles_booster);
        }
		// MUMPS
		if (IsDefined('FORM.new_mumps')) {
            insertVaccine(FORM.studentID,FORM.new_mumps,FORM.mumps_disease,FORM.mumps1,FORM.mumps2,"","","",FORM.mumps_booster);
        } else if (IsDefined('FORM.upd_mumps')) {
            updateVaccine(FORM.upd_mumps,FORM.mumps_disease,FORM.mumps1,FORM.mumps2,"","","",FORM.mumps_booster);
        }
		// RUBELLA
		if (IsDefined('FORM.new_rubella')) {
            insertVaccine(FORM.studentID,FORM.new_rubella,FORM.rubella_disease,FORM.rubella1,FORM.rubella2,"","","",FORM.rubella_booster);
        } else if (IsDefined('FORM.upd_rubella')) {
            updateVaccine(FORM.upd_rubella,FORM.rubella_disease,FORM.rubella1,FORM.rubella2,"","","",FORM.rubella_booster);
        }
		// VARICELLA
		if (IsDefined('FORM.new_varicella')) {
            insertVaccine(FORM.studentID,FORM.new_varicella,FORM.varicella_disease,FORM.varicella1,FORM.varicella2,"","","",FORM.varicella_booster);
        } else if (IsDefined('FORM.upd_varicella')) {
            updateVaccine(FORM.upd_varicella,FORM.varicella_disease,FORM.varicella1,FORM.varicella2,"","","",FORM.varicella_booster);
        }
		// HEPATITIS A
		if (IsDefined('FORM.new_hepatitisA')) {
            insertVaccine(FORM.studentID,FORM.new_hepatitisA,"",FORM.hepatitisA1,FORM.hepatitisA2,"","","","");
        } else if (IsDefined('FORM.upd_hepatitisA')) {
            updateVaccine(FORM.upd_hepatitisA,"",FORM.hepatitisA1,FORM.hepatitisA2,"","","","");
        }
		// HEPATITIS B
		if (IsDefined('FORM.new_hepatitis')) {
            insertVaccine(FORM.studentID,FORM.new_hepatitis,"",FORM.hepatitis1,FORM.hepatitis2,FORM.hepatitis3,"","","");
        } else if (IsDefined('FORM.upd_hepatitis')) {
            updateVaccine(FORM.upd_hepatitis,"",FORM.hepatitis1,FORM.hepatitis2,FORM.hepatitis3,"","","");
        }
		// MENINGOCOCCAL
		if (IsDefined('FORM.new_meningococcal')) {
            insertVaccine(FORM.studentID,FORM.new_meningococcal,"",FORM.meningococcal1,FORM.meningococcal2,"","","","");
        } else if (IsDefined('FORM.upd_meningococcal')) {
            updateVaccine(FORM.upd_meningococcal,"",FORM.meningococcal1,FORM.meningococcal2,"","","","");
        }
    </cfscript>
    
    <cfcatch type="any">
		<cfinclude template="../error_message.cfm">
	</cfcatch>
</cftry>

<html>
    <head>
		<script type="text/javascript">
        	alert("You have successfully updated this page. Thank You.");
        	<cfif NOT IsDefined('url.next')>
            	location.replace("?curdoc=section3/page13&id=3&p=13");
        	<cfelse>
            	location.replace("?curdoc=section3/page14&id=3&p=14");
        	</cfif>
        </script>
    </head>
</html>