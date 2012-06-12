

<cfif NOT IsDefined('form.userid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>
<Cfif isDefined('form.deleteSeason')>
	<cfquery name="deleteSeason" datasource="#application.dsn#">
    delete from smg_users_paperwork
    where seasonid = <cfqueryparam value="#form.deleteSeason#" cfsqltype="cf_sql_integer" maxlength="6">
    and userid = <cfqueryparam value="#form.userid#" cfsqltype="cf_sql_integer" maxlength="6">
    </cfquery>
    
</Cfif>
<Cfif isDefined('form.updatePaperwork')>
<!--- UPDATE PAPERWORK --->
<cftransaction action="begin" isolation="SERIALIZABLE">	  
	<cfloop From = "1" To = "#form.count#" Index = "x">
		<cfquery name="update_paperwork" datasource="MySQL">
			UPDATE smg_users_paperwork 
			SET 
				 <cfif form.submittedUserType NEQ 15>
                ar_info_sheet = <cfif form["ar_info_sheet_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_info_sheet_" & x])#</cfif>,
                ar_ref_quest1 = <cfif form["ar_ref_quest1_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest1_" & x])#</cfif>,
				ar_ref_quest2 = <cfif form["ar_ref_quest2_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest2_" & x])#</cfif>,
                ar_training = <cfif form["ar_training_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_training_" & x])#</cfif>,
               </cfif>
				ar_cbc_auth_form = <cfif form["ar_cbc_auth_form_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_cbc_auth_form_" & x])#</cfif>,
                ar_agreement = <cfif form["ar_agreement_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_agreement_" & x])#</cfif>
			WHERE paperworkid = '#form["paperworkid_" & x]#'
			LIMIT 1
		</cfquery>	
	</cfloop>
         <cfscript>
	    SESSION.pageMessages.Add("All paperwork records have been updated.");
	</cfscript>
</cftransaction>
</Cfif>

<!--- NEW SET OF PAPERWORK --->
<cfif isDefined('form.addNewSeason')>
	<cftransaction action="begin" isolation="SERIALIZABLE">	
		<cfquery name="insert_paperwork" datasource="MySQL">
			INSERT INTO smg_users_paperwork 
				(fk_companyid,
                userid, 
                seasonid, 
               
               <cfif form.submittedUserType NEQ 15>
               ar_info_sheet,
                ar_ref_quest1, 
                ar_ref_quest2,
                ar_training, 
                </cfif>

                ar_cbc_auth_form, 
                ar_agreement 
                )
			VALUES 
				(#client.companyid#,
                '#form.userid#',
                '#form.seasonid#',
				
                <cfif form.submittedUserType NEQ 15>
                     <cfif form.ar_info_sheet EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_info_sheet)#</cfif>,
					<cfif form.ar_ref_quest1 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest1)#</cfif>,
                    <cfif form.ar_ref_quest2 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest2)#</cfif>,
                    <cfif form.ar_training EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_training)#</cfif>,
                </cfif>
					<cfif form.ar_cbc_auth_form EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_cbc_auth_form)#</cfif>,
                    <cfif form.ar_agreement EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_agreement)#</cfif>)
		</cfquery>	
        
     <cfscript>
	    SESSION.pageMessages.Add("The new season of paperwork was added.");
	</cfscript>
	</cftransaction>
</cfif>

<!----Check if this account should be reviewed---->
			<Cfscript>
                    //Check if paperwork is complete for season
                    get_paperwork = APPLICATION.CFC.udf.allpaperworkCompleted(userid=form.userid);
					//Get User Info
                    qGetUserInfo = APPLICATION.CFC.user.getUserByID(userid=form.userid);
         </cfscript>
		 <cfif val(get_paperwork.reviewAcct)>
         <cfquery name="progManager" datasource="#application.dsn#">
                  select pm_email
                  from smg_companies
                  where companyid = #client.companyid#
                  </cfquery>
                 <cfsavecontent variable="programEmailMessage">
                    <cfoutput>				
                    The references and all other paperwork appear to be in order for  #qGetUserInfo.firstname# #qGetUserInfo.lastname# (#qGetUserInfo.userID#).  A manual review is now required to actiavte the account.  Please review all paper work and submit the CBC for processing. If everything looks good, approval of the CBC will activate this account.  
                    
                   <Br><Br>
                    
                   <a href="#client.exits_url#/nsmg/index.cfm?curdoc=user_info&userid=#qGetUserInfo.userid#">View #qGetUserInfo.firstname#<cfif Right(#qGetUserInfo.firstname#, 1) is 's'>'<cfelse>'s</cfif> account.</a>
                    </cfoutput>
                    </cfsavecontent>
                    
                    <cfinvoke component="nsmg.cfc.email" method="send_mail">
                        <!----
                        **********This emai is sent to the Program Manager*******************<Br>
                    *****************#progManager.pm_email#<br>**********************
                        <cfinvokeargument name="email_to" value="gary@iseusa.com">      
                        ---->
                        <cfinvokeargument name="email_to" value="#progManager.pm_email#"> 
                        <cfinvokeargument name="email_from" value="""#client.companyshort# Support"" <#client.emailfrom#>">
                        <cfinvokeargument name="email_subject" value="Review account for #client.name#">
                        <cfinvokeargument name="email_message" value="#programEmailMessage#">
                      
                    </cfinvoke>	 
             </cfif>
      
<Cflocation url="index.cfm?curdoc=forms/user_paperwork&userid=#form.userid#">


		

</body>
</html>