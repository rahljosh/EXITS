<cfset vCurrentSeasonID = APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID>

<!--- Import CustomTag Used for Page Messages and Form Errors --->
<cfimport taglib="extensions/customTags/gui/" prefix="gui" />	
<cfparam name="submitForm" default=0>

<cfquery name="qHostParentsMembers" datasource="#APPLICATION.DSN.Source#">
    select h.fatherFirstName, h.fatherdob, h.fatherlastname, h.motherFirstName, h.motherlastname, h.motherdob, h.fatherssn, h.motherssn, h.companyid, h.regionid, h.email
    from smg_hosts h
    where h.hostID = #APPLICATION.CFC.SESSION.getHostSession().ID# 
</cfquery>

<cfquery name="qHostParentsCBC" datasource="#APPLICATION.DSN.Source#">
    select * 
    from smg_documents
    where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
</cfquery>

<cfquery name="checkFatherCBC" dbtype="query">
    select *
    from qHostParentsCBC
    where shortDesc = 'Father CBC Auth'
</cfquery>

<cfquery name="checkMotherCBC" dbtype="query">
    select *
    from qHostParentsCBC
    where shortDesc = 'Mother CBC Auth'
</cfquery>

 <cfscript>
 if ( LEN(TRIM(qHostParentsMembers.motherFirstName)) and not len(trim(qHostParentsMembers.motherdob)) )  {
                SESSION.formErrors.Add("#qHostParentsMembers.motherFirstName# is missing her date of birth on page 1 of the application.  It is required to process this page. Please click on Name & Contact info in the menu and enter the date of birth.");
			} 
			
		   if ( LEN(TRIM(qHostParentsMembers.fatherFirstName)) and not len(trim(qHostParentsMembers.fatherdob)) )  {
                SESSION.formErrors.Add("#qHostParentsMembers.fatherFirstName# is missing his date of birth on page 1 of the application.  It is required to process this page. Please click on Name & Contact info in the menu and enter the date of birth.");
			}
              
</cfscript>
<cfif SESSION.formErrors.length()>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
<cfabort>
</cfif>
<!--- Process Form Submission --->
    <cfif isDefined('FORM.processCBC')>
    
    	<!----Validate Father SSN, if needed---->
  		<cfif isDefined('FORM.fatherssn')>
    	    <cfscript>
            // Data Validation
			
			// Valid SSN
           if  ( LEN(TRIM(FORM.fatherssn)) NEQ 11) {
               SESSION.formErrors.Add("The SSN for #FORM.fatherFirstName# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
           }	
		   if (not len(trim(FORM.fathersig))){
               SESSION.formErrors.Add("The signature for #FORM.fatherFirstName# is missing");
           }	
		 </cfscript>
   		</cfif>	
        <!----Validate Mother ssn, if needed---->
        <cfif isDefined('FORM.motherssn')>
    	    <cfscript>
            // Data Validation
			
			// Valid SSN
           if  ( LEN(TRIM(FORM.motherssn)) NEQ 11) {
               SESSION.formErrors.Add("The SSN for #FORM.motherFirstName# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
           }	
		   if (not len(trim(FORM.mothersig))){
               SESSION.formErrors.Add("The signature for #FORM.motherFirstName# is missing");
           }
		 </cfscript>
   		</cfif>	
        <!----check to make sure that the person should have a background check run---->
 
        
        <cfloop list="#famList#" index="x">
        	<cfif structKeyExists(form, "#x#_ssn")>
        	
            <cfquery name="cbcCheck" datasource="#APPLICATION.DSN.Source#">
            select k.name, k.lastName, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
            from smg_host_children k
            where k.childid = #x# 
            </cfquery>
            <cfif  ( LEN(TRIM('#form[x & "_ssn"]#')) NEQ 11)>
        	<cfif #DateDiff('yyyy',cbcCheck.birthdate,now())# gte 18 and cbcCheck.liveathome is 'yes'>
            
				<cfscript>
                    // Data Validation
                    
                    // Valid SSN
                   if  ( LEN(TRIM(#form[x & "_ssn"]#)) NEQ 11) {
                               SESSION.formErrors.Add("The SSN for #form[x & "_name"]# does not appear to be a valid SSN. <br> Please make sure the SSN is entered in the 999-99-9999 format.");
                   }	
                    // Valid Signature
                   if  ( NOT LEN(TRIM(#form[x & "_sig"]#))) {
                               SESSION.formErrors.Add("The signature for #form[x & "_name"]# is missing.");
                   }	
                
                </cfscript>
        	</cfif>
            </cfif>
            </cfif>
        </cfloop>

        <!--- Check if there are no errors --->
        <cfif NOT SESSION.formErrors.length()>
			<!--- the key for encrypting and decrypting the ssn. --->
            <cfset ssn_key = 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR'>
            <!----insert fathers ssn if defiend---->
            <cfif isDefined('FORM.fatherssn')>
				 <cfset encfatherssn = encrypt("#trim(FORM.fatherssn)#", "#ssn_key#", "desede", "hex")>
                    <cfquery name="insertFatherSSN" datasource="#APPLICATION.DSN.Source#">
                    update smg_hosts
                    set fatherSSN = '#encfatherssn#'
                    where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
                    </cfquery>
                    <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##FORM.fatherSig#_cbcAuthorization.pdf" overwrite="yes">
                    <cfset FORM.report_mode = 'print'>
                    <cfset FORM.pdf = 1>
                    <cfinclude template="cbcAuthorizationText.cfm">
                    <br /><br />
                    <cfoutput>
                    Electronically Signed<br />
                    #FORM.fatherSig#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #cgi.REMOTE_ADDR# 
                    </cfoutput>
                </cfdocument>   
                
                <cfquery name="insertDocInfo" datasource="#APPLICATION.DSN.Source#">
                	insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userID, userType, hostID, seasonID)
	                values('#FORM.fatherSig#_cbcAuthorization.pdf', 'pdf', #now()#, '#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#', 'CBC Authorization for #FORM.fatherSig#','Father CBC Authorization',#APPLICATION.CFC.SESSION.getHostSession().ID#, 'hostFather',#APPLICATION.CFC.SESSION.getHostSession().ID#, #vCurrentSeasonID#)
                </cfquery> 

                <cfquery name="cbcInfo" datasource="#APPLICATION.DSN.Source#">
                select cbcfamID 
                from smg_hosts_cbc
                where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID# and cbc_type = 'father'
                </cfquery>    
                
             </cfif>
             
             <!----Insert mothers ssn if defined---->
             <cfif isDefined('FORM.motherssn')>
				 <cfset encmotherssn = encrypt("#trim(form.motherssn)#", "#ssn_key#", "desede", "hex")>
                    <cfquery name="insertMotherSSN" datasource="#APPLICATION.DSN.Source#">
                    update smg_hosts
                    set motherSSN = '#encmotherssn#'
                    where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
                    </cfquery>
                    
				
                    <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##FORM.motherSig#_cbcAuthorization.pdf" overwrite="yes">
                    <cfset FORM.report_mode = 'print'>
                    <cfset FORM.pdf = 1>
                    <cfinclude template="cbcAuthorizationText.cfm">
                    <br /><br />
                    <cfoutput>
                    Electronically Signed<br />
                    #FORM.motherSig#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #cgi.REMOTE_ADDR# 
                    </cfoutput>
                </cfdocument> 
                <cfquery name="insertDocInfo" datasource="#APPLICATION.DSN.Source#">
                insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userID, usertype, hostID, seasonID)
                				values('#FORM.motherSig#_cbcAuthorization.pdf', 'pdf', #now()#, '#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#', 'CBC Authorization for #FORM.motherSig#','Mother CBC Authorization',#APPLICATION.CFC.SESSION.getHostSession().ID#,'hostMother',#APPLICATION.CFC.SESSION.getHostSession().ID#, #vCurrentSeasonID#)
                </cfquery> 

             </cfif>
              <cfloop list="#famList#" index="x">
              <cfif structKeyExists(form, "#x#_ssn")>
               <cfquery name="cbcCheck" datasource="#APPLICATION.DSN.Source#">
                select k.name, k.lastName, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
                from smg_host_children k
                where k.childid = #x# 
                </cfquery>
        			<cfif #DateDiff('yyyy',cbcCheck.birthdate,now())# gte 18 and cbcCheck.liveathome is 'yes'>
            
					 <cfset encssn = encrypt("#trim(form[x & "_ssn"])#", "#ssn_key#", "desede", "hex")>
                        <cfquery name="insertkidsssn" datasource="#APPLICATION.DSN.Source#">
                        update smg_host_children
                        set ssn = '#encssn#'
                        where childid = #x#
                        </cfquery>
                     </cfif>
                      
                    <cfdocument format="PDF" filename="#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS##form[x & "_sig"]#_cbcAuthorization.pdf" overwrite="yes">
                    <cfset FORM.report_mode = 'print'>
                    <cfset FORM.pdf = 1>
                    <cfset FORM.childid = #x#>
                    
                    <cfinclude template="cbcAuthorizationText.cfm">
                    <br /><br />
                    <cfoutput>
                    Electronically Signed<br />
                    #form[x & "_sig"]#<br />
                    #DateFormat(now(), 'mmm d, yyyy')# at #TimeFormat(now(), 'h:mm:ss tt')#<br />
                    IP: #cgi.REMOTE_ADDR# 
                    </cfoutput>
                </cfdocument> 
                 <cfquery name="insertDocInfo" datasource="#APPLICATION.DSN.Source#">
                insert into smg_documents (fileName, type, dateFiled, filePath, description, shortDesc, userID, usertype, hostID, seasonID)
                				values('#form[x & "_sig"]#_cbcAuthorization.pdf', 'pdf', #now()#, '#APPLICATION.CFC.SESSION.getHostSession().PATH.DOCS#', 'CBC Authorization for family member #form[x & "_sig"]#','Member CBC Authorization', #x#, 'hostMember',#APPLICATION.CFC.SESSION.getHostSession().ID#, #vCurrentSeasonID#)
                </cfquery> 
                </cfif>
              	</cfloop>
            
			<!----Update Lead Table that Application is in process---->
            <cfquery datasource="#APPLICATION.DSN.Source#">
                UPDATE 
                	smg_host_lead 
                SET 
                	statusID = 8
                WHERE 
                	email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#APPLICATION.CFC.SESSION.getHostSession().email#">
            </cfquery>
            
           
            
 <!----Get all cbc's and email them to host.  Notify the PM and Facilitator that CBC's are ready to review.---->
            <cfquery name="getCBCs" datasource="#APPLICATION.DSN.Source#">
            select *
            from smg_documents
            where hostID = #APPLICATION.CFC.SESSION.getHostSession().ID#
            </cfquery>
            
             <cfsavecontent variable="hostCBCEmailMessage">
              <cfoutput>	
              
                Attached are copies of the Criminal Background Check Authorization you and any members of your family have electronically signed.  
                <br /><br />
                Regards-<br />
                ISE Support
              </cfoutput>
                </cfsavecontent>

            <cfinvoke component="extensions.components.email" method="send_mail">
                <cfinvokeargument name="emailTo" value="#qHostParentsMembers.email#">       
                <cfinvokeargument name="emailFrom" value="hostApp@iseusa.com">
                <cfinvokeargument name="email_subject" value="CBC Authorization Forms">
                <cfinvokeargument name="email_message" value="#hostCBCEmailMessage#">
                
                <cfloop query="getCBCs">
                    <cfif getCBCs.currentRow eq 1>
                        <cfinvokeargument name="email_file" value="#filePath##fileName#">
                    <cfelse>
                        <cfinvokeargument name="email_file#currentRow#" value="#filePath##fileName#">
                    </cfif>
               </cfloop>
            
            </cfinvoke>	
          <!---Facilitator and Program Manager Email---->
          
          
        <cfquery name="programManager" datasource="#APPLICATION.DSN.Source#">
        select pm_email
        from smg_companies
        where companyid = #qHostParentsMembers.companyid#
        </cfquery>
        <cfquery name="facilitator" datasource="#APPLICATION.DSN.Source#">
        select uar.userID, u.email
        from user_access_rights uar
        left join smg_users u on u.userID = uar.userID
        where regionid = #qHostParentsMembers.regionid#
        </cfquery>
            <cfsavecontent variable="hostCBCEmailMessage">
              <cfoutput>	
              
                The following CBC Authorization forms have been submitted for the <strong>#qHostParentsMembers.fatherlastname#</strong> family.  Please review and process the CBC's when possible.  
                <br /><br />
                You can process the CBC's here: 
                http://ise.exitsapplication.com/nsmg/index.cfm?curdoc=cbc/hosts_cbc&hostID=#APPLICATION.CFC.SESSION.getHostSession().ID#
                <br /><br />
                Regards-<br />
                ISE Support
              </cfoutput>
                </cfsavecontent>

            <cfinvoke component="extensions.components.email" method="send_mail">
                <cfinvokeargument name="emailTo" value="programManager.pm_email,facilitator.email">       
                <cfinvokeargument name="emailFrom" value="hostApp@iseusa.com">
                <cfinvokeargument name="email_subject" value="CBC Authorization Forms">
                <cfinvokeargument name="email_message" value="#hostCBCEmailMessage#">
                
                <cfloop query="getCBCs">
                    <cfif getCBCs.currentRow eq 1>
                        <cfinvokeargument name="email_file" value="#filePath##fileName#">
                    <cfelse>
                        <cfinvokeargument name="email_file#currentRow#" value="#filePath##fileName#">
                    </cfif>
               </cfloop>
               
            </cfinvoke>	
            <cflocation url="?section=personalDescription" addtoken="no">
                
                <cfsetting requesttimeout="9999">
            
                <cftry>
                    <!--- param variables --->
                    <cfparam name="hostID" type="numeric" default="#APPLICATION.CFC.SESSION.getHostSession().ID#">
                    <!--- param FORM variables --->
                    <cfparam name="FORM.submitted" type="numeric" default="1">
                    <cfparam name="FORM.memberIDs" default="0">
                    
                   <cfif isDefined('FORM.motherssn')>
                        <cfparam name="FORM.mothercompanyID" default="1">
                        <cfparam name="FORM.motherdate_authorized" default="#now()#">
                        <cfparam name="FORM.motherIsNoSSN" default="0">
                    <cfelse>
                    	 <cfparam name="FORM.mothercompanyID" default="0">
       					 <cfparam name="FORM.motherSeasonID" default="0">
       					 <cfparam name="FORM.motherdate_authorized" default="">
      					 <cfparam name="FORM.motherIsNoSSN" default="0">
                    </cfif>
                    
                    <cfif isDefined('FORM.fatherssn')>
                    	<cfparam name="FORM.fathercompanyID" default="1">
                    	<cfparam name="FORM.fatherdate_authorized" default="#now()#">
                    	<cfparam name="FORM.fatherIsNoSSN" default="0">
                   	<cfelse>
                    	<cfparam name="FORM.fathercompanyID" default="">
                    	<cfparam name="FORM.fatherSeasonID" default="0">
                    	<cfparam name="FORM.fatherdate_authorized" default="">
                    	<cfparam name="FORM.fatherIsNoSSN" default="0">
                    </cfif> 
                    <cfcatch type="any">
                    
                        <cfscript>
                            // set default values
                            hostID = 0;
                            FORM.submitted = 0;
                        </cfscript>
                        
                    </cfcatch>
                </cftry>  

            <cflocation url="?section=personalDescription" addtoken="no">
			
		</cfif>	

 </cfif>
 
<cfquery name="qHostFamilyMembers" datasource="#APPLICATION.DSN.Source#">
select k.name, k.lastName, k.birthdate, k.cbc_form_received, k.childid, k.membertype, k.ssn, k.liveathome
from smg_host_children k
where k.hostID = #APPLICATION.CFC.SESSION.getHostSession().ID# 
</cfquery>
<cfquery name="qActiveSeasons" datasource="#APPLICATION.DSN.Source#">
select s.seasonID, s.season 
from smg_seasons s
where active = 1
</cfquery>
<h2>Criminal Background Check</h2>
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="section"
        />
        
Due to Department of State Regulations&dagger;, criminal background checks will need to be run on the following persons.  Please provide the following information on each person so that we can complete the background check. <br />
<br />

<cfform method="post" action="?section=cbcAuthorization">

<cfoutput>
<input type="hidden" name="processCBC"/>
<input type="hidden" name="hostID" value="#APPLICATION.CFC.SESSION.getHostSession().ID#" />
<input type="hidden" name="submitted" value="1" />

<h3>Family Members</h3>
<table width="100%" cellspacing="0" cellpadding="4" class="border">
   <tr>
   	<th>Name</th><th>Relation</th><th>Date of Birth</th><th>Age</th><th>Social Security</th>
    </tr>
   <cfif qHostParentsMembers.recordcount eq 0>
    <tr>
    	<td>Currently, no family members require a backgroundcheck.</td>
    </tr>
    <cfelse>
    <cfloop query="qHostParentsMembers">
    <cfif fatherFirstName is not ''>
        <tr <cfif currentRow MOD 2> bgcolor="##deeaf3"</cfif>>
            <td width="20%"><h3><p class="p_uppercase">#fatherFirstName# #fatherlastname#</h3></td>
            <td width="20%"><h3><p class="p_uppercase">Host Father</h3></td>
            <td width="20%"><h3>#DateFormat(fatherdob, 'mmm d, yyyy')#</h3></td>
            <td width="10%"><h3>#DateDiff('yyyy',fatherdob,now())#</h3></td> 
             <input type="hidden" value="#fatherFirstName#" name="fatherFirstName" />
            <td width="30%">
            
          	<cfif checkFatherCBC.recordcount eq 0>
            	<cfinput type="text"  name="fatherssn"  mask="999-99-9999" size=12 typeahead="no" showautosuggestloadingicon="true" >
                <cfset submitForm = 1>
      		<cfelse>
            	Request Submitted
            </cfif>
            </td>
      </tr>
    </cfif>
    <cfif motherFirstName is not ''>
        <tr>
            <td><h3><p class="p_uppercase">#motherFirstName# #motherlastname#</h3></td>
            <td><h3><p class="p_uppercase">Host Mother</h3></td>
            <td><h3>#DateFormat(motherdob, 'mmm d, yyyy')#</h3></td>
            <td><h3>#DateDiff('yyyy',motherdob,now())#</h3></td> 
           <input type="hidden" value="#motherFirstName#" name="motherFirstName" />
           
            <td>
            <cfif checkMotherCBC.recordcount eq 0>
            	<cfinput type="text"  name="motherssn"  mask="999-99-9999" size=12 typeahead="no" showautosuggestloadingicon="true" >
                <cfset submitForm = 1>
      		<cfelse>
            	Request Submitted
            </cfif>
            </td>

        </tr>
    </cfif>
    </cfloop>
    <cfif qHostFamilyMembers.recordcount gt 0>
    <tr>
    	<td colspan=7><hr width=60% align="center"></td>
    </tr>
    </cfif>
    <cfset famMembersList =''>
    <cfloop query="qHostFamilyMembers">
    <cfif #DateDiff('yyyy',birthdate,now())# gte 18>
		<cfset famMembersList = #ListAppend(famMembersList,#qHostFamilyMembers.childid#)#>
	</cfif>
        <tr <cfif currentRow MOD 2> bgcolor="##deeaf3"</cfif>>
            <td><h3><p class="p_uppercase">#name# #lastName#</h3></td>
            <td><h3><p class="p_uppercase">#membertype#</h3></td>
            <td><h3>#DateFormat(birthdate, 'mmm d, yyyy')#</h3></td>
            <td><h3>#DateDiff('yyyy',birthdate,now())#</h3></td> 
			<cfif #DateDiff('yyyy',birthdate,now())# gte 18 and liveathome is 'yes'>
                
                <td>
                <input type="hidden" name="#qHostFamilyMembers.childid#_name" value="#name#" />
              <cfif ssn is not ''>
              	Request Submitted
              <cfelse>
                <cfinput type="text" name="#qHostFamilyMembers.childid#_ssn" mask="999-99-9999" size=12 typeahead="no"  showautosuggestloadingicon="true" value="#ssn#">
                <cfset submitForm = 1></td>
              </cfif>	
            <cfelse>
                <td colspan="2" >Background check is not required for #name#.</td>
            </cfif> 
        </tr>

    </cfloop>
    <input type="hidden" name="famList" value="#famMembersList#" />
    </cfif>
   </table>
<h3>Signature(s)</h3>
	<table width="100%" cellspacing="0" cellpadding="2" class="border">
   <tr  bgcolor="##deeaf3">
   	<th align="center">I/We are submitting this authorization for a criminal background check on the above individuals.  Please use our typed name in place of a signature to initiate the background check process.<br />
    
    </th>
    
    </tr>
    <tr  bgcolor="##deeaf3">
    
    	<td>
        <table align="center">
 
        

        	<cfloop query="qHostParentsMembers">
            
				<cfif fatherFirstName is not ''>
                    <tr>
                        <td><h3><p class="p_uppercase">#fatherFirstName# #fatherlastname#</h3></td>
                        <td>
                        <cfif checkFatherCBC.recordcount eq 0>
                            <input type="text" name="FatherSig" class="largeField"/></td>
                        <cfelse>
                            <a href="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeDocs##checkfatherCBC.fileName#" target="_blank">View CBC Authoriaztion</a>
                        </cfif>
                    </tr>    
                </cfif>
                
                <cfif motherFirstName is not ''>
                    <tr>
                        <td><h3><p class="p_uppercase">#motherFirstName# #motherlastname#</h3></td>
                        <td>
                        <cfif checkMotherCBC.recordcount eq 0>
                            <input type="text" name="MotherSig" class="largeField"/>
                        <cfelse>
                            <a href="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeDocs##checkMotherCBC.fileName#" target="_blank">View CBC Authoriaztion</a>
                        </cfif>
                        </td>
                    </tr>    
                </cfif>
            </cfloop>
        
            <cfloop query="qHostFamilyMembers">
                <cfquery name="cbcInfo" datasource="#APPLICATION.DSN.Source#">
                    select 
                    	*
                    from 
                    	smg_documents
                    where 
                    	userID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qHostFamilyMembers.childID#">
                    AND
                    	shortDesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="Member CBC Auth">
                </cfquery>
				<cfif DateDiff('yyyy',birthdate,now()) gte 18 and liveathome is 'yes'>
                    <tr>
                		<td><h3><p class="p_uppercase">#name# #lastName#</p></h3></td><td>
                        <cfif cbcInfo.recordCount>
                        <a href="#APPLICATION.CFC.SESSION.getHostSession().PATH.relativeDocs##cbcInfo.fileName#" target="_blank">View CBC Authoriaztion
                        <cfelse>
                        <input type="text" name="#qHostFamilyMembers.childid#_sig" />
                        </cfif>
                        </td>
                    </tr>
                </cfif>
			</cfloop>
        	</table>
        </td>
     </tr>
    </table>
</cfoutput>

<p>&nbsp;</p>
<p><br />
</p>
<p>By providing this information and clicking on submit I do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and such disclosures.</p>
<p>Information entered on this Authorization will be used exclusively by General Information Services, Inc. for identification purposes and for the release of information that will be considered in determining any suitability for participation in the Exchange Program. </p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to request from General Information Services, Inc. information about the nature and substance of all records on file about me at the time of my request.  This may include the type of information requested as well as those who requested reports from General Information Services, Inc.  within the two-year period preceding my request.</p>
<table border="0" cellpadding="4" cellspacing="0" width="100%" class="section">
	<tr>
		<td align="right">
        <input name="Submit" type="image" src="images/buttons/BlkSubmit.png" border="0">
		</td>
	</tr>
</table>
</cfform>

<p><b>As part of our background check, reports from several sources may be obtained.  Reports may include, but not be limited to, criminal history reports, Social Security verifications, address histories, and Sex Offender Registries.  Should any results from the aforementioned reports indicate that driving history records will need to be reviewed during a more comprehensive assessment, an additional authorization and release will be requested at that time.  You have a the right, upon written request, to complete and accurate disclosure of the nature and scope of the background check. 
</b></p>

<h3><u>Department Of State Regulations</u></h3>
<p>&dagger;<strong><a href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22" target="_blank" class=external>CFR Title 22, Part 62, Subpart B, &sect;62.25 (j)(7)</a></strong><br />
<em> Verify that each member of the host family household 18 years of age and older, as well as any new adult member added to the household, or any member of the host family household who will turn eighteen years of age during the exchange student's stay in that household, has undergone a criminal background check (which must include a search of the Department of Justice's National Sex Offender Public Registry);</em>

<br /><br />