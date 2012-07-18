<cfif NOT isDefined("FORM.kid_share")>
	<cfset FORM.kid_share = "no">
</cfif>

<cftransaction action="begin" isolation="serializable">
	
    <cfif isDefined("FORM.stulist")>
    	
        <cfloop list="#FORM.stulist#" index="x">
        
        	<cfif #Evaluate("FORM." & x & "_kid_share")# EQ 'no'>
                      
            	<cfquery name="insert_room_share" datasource="MySQL">
					UPDATE
                    	smg_host_children
				 	SET
                    	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
				 		roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				 	WHERE
                    	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_studentidsharing')#">
				</cfquery>
				
				<cfquery name="insert_dbl_room_share" datasource="mysql">
                    UPDATE
                    	smg_students
                  	SET
                    	double_place_share = 0
                    WHERE
                    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_studentidsharing')#">
                </cfquery>
        
        	<cfelseif #Evaluate("FORM." & x & "_kid_share")# EQ 00>
            
            	<cfquery name="get_double_place_id" datasource="MySql">
					SELECT
                    	doubleplace
                   	FROM
                    	smg_students
                  	WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
				</cfquery>
                <cfquery name="insert_dbl_room_share" datasource="MySql">
                	UPDATE
                    	smg_students
                  	SET
                    	double_place_share = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_double_place_id.doubleplace#">
                   	WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
                
            <cfelse>
             
            	<cfquery datasource="MySQL">
					UPDATE
                    	smg_host_children
				 	SET
                    	shared = "yes",
					 	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_studentidsharing')#">
				 	WHERE
                    	childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_kid_share')#">
				</cfquery>
                
                <cfquery datasource="MySql">
                	UPDATE
                    	smg_host_children
                   	SET
                    	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
				 		roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                  	WHERE
                    	childid != <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_kid_share')#">
                   	AND
                    	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_studentidsharing')#">
                </cfquery>
            
            </cfif>
                    
        </cfloop>
    
    <cfelse>
    
    	<cfif FORM.kid_share EQ 0>
        	<cfquery datasource="MySQL">
                UPDATE
                    smg_host_children
                SET
                    shared = "no",
                    roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="MySQL">
                UPDATE
                    smg_host_children
                SET
                    shared = "yes"
                WHERE
                    childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.kid_share#">
            </cfquery>
            <cfquery datasource="MySql">
                UPDATE
                    smg_host_children
                SET
                    shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
                    roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE
                    childid != <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.kid_share#">
              	AND
                	hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
            </cfquery>
        </cfif>
        
    </cfif>
    
    <!----Smoking & Allergy Preferences---->
    <cfquery name="smoking_pref" datasource="MySQL">
    update smg_hosts
        set acceptsmoking = '#form.stu_smoke#',
            smokeconditions = '#form.smoke_conditions#'
        where hostid = #client.hostid#
    </cfquery>


	<!----Add animals to db---->
    <cfloop from="1" to="#FORM.numberPets#" index="i">
		<cfif LEN(#Evaluate('FORM.animal' & i)#)>
        	<cfscript>
				animal = Evaluate('FORM.animal' & i);
				animalID = Evaluate('FORM.animalID' & i);
				indoor = Evaluate('FORM.indoor' & i);
				number = Evaluate('FORM.number_pets' & i);
			</cfscript> 
            <cfif VAL(animalID)>
                <cfquery name="update_pets" datasource="MySql">
                    UPDATE
                        smg_host_animals
                    SET
                        animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#animal#">,
                        indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#indoor#">,
                        number = <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">
                    WHERE
                        animalid = <cfqueryparam cfsqltype="cf_sql_integer" value="#animalID#">
                </cfquery>
            <cfelse>
                <cfquery name="add_animal" datasource="MySql">
                    INSERT INTO
                        smg_host_animals 
                        (
                            hostID,
                            animalType,
                            number,
                            indoor
                        )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#animal#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#number#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#indoor#">
                    )
                </cfquery>
            </cfif>
        </cfif>
 	</cfloop>
    
    <Cfquery name="church_info" datasource="MySQL">
    Update smg_hosts
        set attendchurch = '#form.attend_church#',
            religious_participation = '#form.religious_participation#',
            churchfam = '#form.churchfam#',
            churchtrans = '#form.churchtrans#'
        where hostid = #client.hostid#
    </cfquery>
    
</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_4" addtoken="no">