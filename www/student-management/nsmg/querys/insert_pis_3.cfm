<!--- Param FORM Variables --->
<cfparam name="FORM.kid_share" default="no">

<cftransaction action="begin" isolation="serializable">
	
    <cfif isDefined("FORM.stuListID")>
    	
        <cfloop list="#FORM.stuListID#" index="x">
        
        	<!--- Not Sharing a Room - Reset Values --->
        	<cfif Evaluate("FORM." & x & "_siblingIDSharingRoom") EQ 'no'>
                      
            	<cfquery datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_host_children
				 	SET
                    	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
				 		roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
				 	WHERE
                    	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
				</cfquery>
				
				<cfquery datasource="#APPLICATION.DSN#">
                    UPDATE
                    	smg_students
                  	SET
                    	double_place_share = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                    WHERE
                    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
        	
            <!--- Sharing a Room with a Double Placement Student --->
        	<cfelseif Left(Evaluate("FORM." & x & "_siblingIDSharingRoom"), 7) EQ 'student'>
            	
                <cfset vGetSharingRoomID = ReplaceNoCase(Evaluate("FORM." & x & "_siblingIDSharingRoom"), "student_", "")>
            	
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_students
                  	SET
                    	double_place_share = <cfqueryparam cfsqltype="cf_sql_integer" value="#vGetSharingRoomID#">
                   	WHERE
                    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
            
            <!--- Sharing a Room with a host sibling --->   
            <cfelse>
             	
                <cfset vGetSharingRoomID = ReplaceNoCase(Evaluate("FORM." & x & "_siblingIDSharingRoom"), "sibling_", "")>
                
            	<cfquery datasource="#APPLICATION.DSN#">
					UPDATE
                    	smg_host_children
				 	SET
                    	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="yes">,
					 	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
				 	WHERE
                    	childid = <cfqueryparam cfsqltype="cf_sql_integer" value="#vGetSharingRoomID#">
				</cfquery>
                
                <cfquery datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_host_children
                   	SET
                    	shared = <cfqueryparam cfsqltype="cf_sql_varchar" value="no">,
				 		roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                  	WHERE
                    	childid != <cfqueryparam cfsqltype="cf_sql_integer" value="#vGetSharingRoomID#">
                   	AND
                    	roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="#x#">
                </cfquery>
            
            </cfif>
                    
        </cfloop>
    
    <cfelse>
    
    	<cfif FORM.kid_share EQ 0>
        	<cfquery datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_host_children
                SET
                    shared = "no",
                    roomsharewith = <cfqueryparam cfsqltype="cf_sql_integer" value="0">
                WHERE
                    hostID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.hostID#">
            </cfquery>
        <cfelse>
        	<cfquery datasource="#APPLICATION.DSN#">
                UPDATE
                    smg_host_children
                SET
                    shared = "yes"
                WHERE
                    childID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.kid_share#">
            </cfquery>
            <cfquery datasource="#APPLICATION.DSN#">
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
    <cfquery name="smoking_pref" datasource="#APPLICATION.DSN#">
    	UPDATE smg_hosts
        SET acceptsmoking = '#form.stu_smoke#',
            smokeconditions = '#form.smoke_conditions#',
            dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
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
                <cfquery name="update_pets" datasource="#APPLICATION.DSN#">
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
                <cfquery name="add_animal" datasource="#APPLICATION.DSN#">
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
    
    <Cfquery name="church_info" datasource="#APPLICATION.DSN#">
    	UPDATE smg_hosts
        SET attendchurch = '#form.attend_church#',
            religious_participation = '#form.religious_participation#',
            churchfam = '#form.churchfam#',
            churchtrans = '#form.churchtrans#',
            dateUpdated = <cfqueryparam cfsqltype="cf_sql_date" value="#NOW()#">,
        	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
        WHERE hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.hostID)#">
    </cfquery>
    
</cftransaction>

<cflocation url="../index.cfm?curdoc=forms/host_fam_pis_4" addtoken="no">