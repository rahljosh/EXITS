<cfdump var="#FORM#">
<!----
<cfif fatherssn NEQ ''>
	<cfset EncryptFatherSSN = encrypt("#FORM.fatherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptFatherSSN = ''>
</cfif>

<cfif motherssn NEQ ''>
	<cfset EncryptMotherSSN = encrypt("#FORM.motherssn#", 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")>
<cfelse>
	<cfset EncryptMotherSSN = ''>
</cfif>
---->

<cftransaction action="BEGIN" isolation="SERIALIZABLE">

	<cfinclude template="../querys/family_info.cfm">
    
    <!------------------------------------------------------
	      ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
	------------------------------------------------------->

	<cfif family_info.recordCount
    	AND
        	(
            	FORM.address NEQ family_info.address
			OR
				FORM.address2 NEQ family_info.address2
			OR
				FORM.city NEQ family_info.city
			OR
				FORM.state NEQ family_info.state
			OR
				FORM.zip NEQ family_info.zip
            )>    
            
      	<cfsavecontent variable="vEmailMessage">
          	<cfoutput>
                <p>HOST FAMILY NOTICE OF ADDRESS CHANGE</p>
                
                <p><strong>#CLIENT.firstName# #CLIENT.lastName# (###CLIENT.userID#)</strong> has made an address change.</p>
                
                <p>Host Family: <strong>#FORM.familyname# (###family_info.hostid#)</strong>
                
                <p><strong>NEW ADDRESSS</strong></p>
                #FORM.address#<br />
                <cfif LEN(FORM.address2)>#FORM.address2#<br /></cfif>
                #FORM.city# #FORM.state# #FORM.zip#<br /><br />
           
                <p><strong>PREVIOUS ADDRESS</strong></p>
                #family_info.address#<br />
                <cfif LEN(family_info.address2)> #family_info.address2#<br /></cfif>
                #family_info.city# #family_info.state# #family_info.zip#<br /><br />
           
                <p>This is the only notification of this change that you will receive.</p>
                
                <p>Please update any records that do NOT pull information from EXITS.</p>
                
                <p>The following were notified:</p>
           
                #APPLICATION.EMAIL.hostFamilyNotification#
          	</cfoutput>
      	</cfsavecontent>
          
      	<!--- send email --->
      	<cfinvoke component="internal.extensions.components.email" method="send_mail">
          	<cfinvokeargument name="email_to" value="#APPLICATION.EMAIL.hostFamilyNotification#">
          	<cfinvokeargument name="email_subject" value="PHP - Host Family Notice of Address Change">
          	<cfinvokeargument name="email_message" value="#vEmailMessage#">            
      	</cfinvoke>
          
  </cfif>
  <!------------------------------------------------------
      END OF ADDRESS CHANGE - SEND EMAIL NOTIFICATION 
  ------------------------------------------------------->

<cfquery name="insert_host_page_1" datasource="mysql">
	UPDATE smg_hosts
	SET familylastname='#FORM.familyname#',
		fatherlastname = '#FORM.fatherlast#',
		fatherfirstname= '#FORM.fatherfirst#',
		
		fatherbirth = <cfif FORM.fatherdob EQ ''>NULL <cfelse> #FORM.fatherdob# </cfif>,
        <!---
		fatherssn = '#EncryptFatherSSN#',
		---->
		fatherworktype= '#FORM.fatherocc#',
		father_cell = '#FORM.fathercell#',
		motherfirstname='#FORM.motherfirst#',
		motherlastname='#FORM.motherlast#', 		
		emergency_contact_name = '#FORM.emergency_contact_name#',
		emergency_phone = '#FORM.emergency_phone#',
		motherbirth = <cfif FORM.motherdob EQ ''>NULL <cfelse> #FORM.motherdob# </cfif>,
        <!----
		motherssn = '#EncryptMotherSSN#',
		---->
		motherworktype='#FORM.motherocc#',
		mother_cell = '#FORM.mothercell#',
		address='#FORM.address#',
		address2= '#FORM.address2#',
		city='#FORM.city#',
		state='#FORM.state#',
		zip='#FORM.zip#',
		phone='#FORM.phone#',
		email='#FORM.email#'
	WHERE hostid = <cfqueryparam value="#FORM.hostid#" cfsqltype="cf_sql_integer">
	LIMIT 1
</cfquery>

</cftransaction>
<cfoutput>

<cflocation url="../index.cfm?curdoc=FORMs/host_fam_pis_2" addtoken="No">
</cfoutput>
</body>
</html>
