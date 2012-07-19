<CFIF not isdefined("FORM.share_room")>
	<CFSET FORM.share_room = "no">
</cfif>
<cftransaction action="BEGIN" isolation="SERIALIZABLE">

	<!---- Share Room ---->
    <cfif isDefined('FORM.stulist')>
	
        <cfloop list = #FORM.stulist# index='x'>
        
            <cfif #Evaluate("FORM." & x & "_share_room")# is 'yes'>
            
                <cfif #Evaluate("FORM." & x & "_kid_share")# eq 00>
                
                    <cfquery name="get_double_place_id" datasource="mysql">
                        SELECT 
                            doubleplace 
                        FROM 
                            smg_students
                        WHERE 
                            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                    </cfquery>
                    
                    <cfquery name="insert_dbl_room_share" datasource="mysql">
                        UPDATE 
                            smg_students
                        SET 
                            double_place_share = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_double_place_id.doubleplace#">
                        WHERE 
                            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                    </cfquery>
                    
                <cfelse>
                
                    <cfquery name="insert_room_share" datasource="mysql">
                        UPDATE 
                            smg_host_children
                        SET 
                            shared = "yes",
                            roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_studentidsharing')#">
                        WHERE 
                            childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('FORM.' & x & '_kid_share')#">
                    </cfquery>
                
                </cfif>			
    
            <cfelseif #Evaluate("FORM." & x & "_share_room")# is 'no'>
                    
                <cfquery name="insert_room_share" datasource="mysql">
                    UPDATE 
                        smg_host_children
                    SET 
                        shared = "no",
                        roomsharewith = 0
                    WHERE 
                        roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
                    
                <cfquery name=insert_dbl_room_share datasource="mysql">
                    UPDATE 
                        smg_students
                    SET 
                        double_place_share = 0
                    WHERE 
                        studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
                
            </cfif>
        
        </cfloop>
    
	<cfelse>
    
		<cfif #FORM.share_room# is 'yes'>
            <cfquery name="insert_room_share" datasource="mysql">
                UPDATE 
                    smg_host_children
                SET 
                    shared = "yes",
                    roomsharewith = 0
                WHERE 
                    childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.kid_share#">
            </cfquery>
        </cfif>

		<cfif #FORM.share_room# is 'no'>
            <cfquery name="insert_room_share" datasource="mysql">
          		UPDATE 
                	smg_host_children
             	SET 
                	shared = "no",
                 	roomsharewith = 0
             	WHERE 
                	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
            </cfquery>
        </cfif>
        
	</cfif>
    
	<!----Smoking & Allergy Preferences---->
    <cfquery name="smoking_pref" datasource="mysql">
        UPDATE
            smg_hosts
        SET
            acceptsmoking = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.stu_smoke#">
        WHERE
            hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
    </cfquery>

	<!----Add animals to db---->
    <cfif isDefined('FORM.pets_exist')>
	
		<cfif isdefined('FORM.animal1')>
            <cfquery name="update_pets" datasource="mysql">
            UPDATE 
            	smg_host_animals
          	SET 
            	animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animaltype1#">,
              	indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#">,
               	number = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">
          	WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal1#">
            </cfquery>
		</cfif>
        
        <cfif isdefined('FORM.animal2')>
            <cfquery name="update_pets" datasource="mysql">
            UPDATE 
            	smg_host_animals
          	SET 
            	animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animaltype1#">,
              	indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#">,
               	number = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">
          	WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal2#">
            </cfquery>
		</cfif>
        
        <cfif isdefined('FORM.animal3')>
            <cfquery name="update_pets" datasource="mysql">
            UPDATE 
            	smg_host_animals
          	SET 
            	animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animaltype1#">,
              	indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#">,
               	number = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">
          	WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal3#">
            </cfquery>
		</cfif>
        
        <cfif isdefined('FORM.animal4')>
            <cfquery name="update_pets" datasource="mysql">
            UPDATE 
            	smg_host_animals
          	SET 
            	animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animaltype1#">,
              	indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#">,
               	number = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">
          	WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal4#">
            </cfquery>
		</cfif>
        
        <cfif isdefined('FORM.animal5')>
            <cfquery name="update_pets" datasource="mysql">
            UPDATE 
            	smg_host_animals
          	SET 
            	animaltype = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animaltype1#">,
              	indoor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#">,
               	number = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">
          	WHERE 
            	animalid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal5#">
            </cfquery>
		</cfif>
        
	<cfelse>
    
		<cfif #FORM.animal1# is not ''>
            <cfquery name="add_animal" datasource="mysql">
                INSERT INTO 
                    smg_host_animals (
                        hostid, 
                        animaltype, 
                        number, 
                        indoor )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal1#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets1#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor1#"> )
            </cfquery>
        </cfif>
        
        <cfif #FORM.animal2# is not ''>
            <cfquery name="add_animal" datasource="mysql">
                INSERT INTO 
                    smg_host_animals (
                        hostid, 
                        animaltype, 
                        number, 
                        indoor )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal2#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets2#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor2#"> )
            </cfquery>
        </cfif>
        
        <cfif #FORM.animal3# is not ''>
            <cfquery name="add_animal" datasource="mysql">
                INSERT INTO 
                    smg_host_animals (
                        hostid, 
                        animaltype, 
                        number, 
                        indoor )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal3#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets3#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor3#"> )
            </cfquery>
        </cfif>
        
        <cfif #FORM.animal4# is not ''>
            <cfquery name="add_animal" datasource="mysql">
                INSERT INTO 
                    smg_host_animals (
                        hostid, 
                        animaltype, 
                        number, 
                        indoor )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal4#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets4#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor4#"> )
            </cfquery>
        </cfif>
        
        <cfif #FORM.animal5# is not ''>
            <cfquery name="add_animal" datasource="mysql">
                INSERT INTO 
                    smg_host_animals (
                        hostid, 
                        animaltype, 
                        number, 
                        indoor )
                VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.animal5#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.number_pets5#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.indoor5#"> )
            </cfquery>
        </cfif>
        
  	</cfif>

    <cfquery name="church_info" datasource="mysql">
    	UPDATE 
        	smg_hosts
      	SET 
        	attendchurch = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.attend_church#">,
            religious_participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.religious_participation#">,
            churchfam = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.churchfam#">
      	WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#client.hostid#">
    </cfquery>

</cftransaction>

<!--- Move to next page in the form --->
<cflocation url="../index.cfm?curdoc=FORMs/host_fam_pis_4" addtoken="no">