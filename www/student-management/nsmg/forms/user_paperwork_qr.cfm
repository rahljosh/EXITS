<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Update User Paperwork</title>
</head>

<body>

<cfif NOT IsDefined('form.userid')>
	Sorry, an error has ocurred. Please go back and try again.
	<cfabort>
</cfif>

<!--- UPDATE PAPERWORK --->
<cftransaction action="begin" isolation="SERIALIZABLE">	  
	<cfloop From = "1" To = "#form.count#" Index = "x">
		<cfquery name="update_paperwork" datasource="MySQL">
			UPDATE smg_users_paperwork 
			SET 
				 <cfif form.submittedUserType NEQ 15>
               <!----  ar_info_sheet = <cfif form["ar_info_sheet_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_info_sheet_" & x])#</cfif>,---->
                ar_ref_quest1 = <cfif form["ar_ref_quest1_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest1_" & x])#</cfif>,
				ar_ref_quest2 = <cfif form["ar_ref_quest2_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest2_" & x])#</cfif>,
                ar_training = <cfif form["ar_training_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_training_" & x])#</cfif>,
               </cfif>
				ar_cbc_auth_form = <cfif form["ar_cbc_auth_form_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_cbc_auth_form_" & x])#</cfif>,
                ar_agreement = <cfif form["ar_agreement_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_agreement_" & x])#</cfif>,
				secondVisit = <cfif form["ar_secondVisit_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_secondVisit_" & x])#</cfif>
			WHERE paperworkid = '#form["paperworkid_" & x]#'
			LIMIT 1
		</cfquery>	
	</cfloop>
</cftransaction>


<!--- NEW SET OF PAPERWORK --->
<cfif form.seasonid NEQ '0'>
	<cftransaction action="begin" isolation="SERIALIZABLE">	
		<cfquery name="insert_paperwork" datasource="MySQL">
			INSERT INTO smg_users_paperwork 
				(fk_companyid,
                userid, 
                seasonid, 
               
               <cfif form.submittedUserType NEQ 15>
               <!---- ar_info_sheet, ---->
                ar_ref_quest1, 
                ar_ref_quest2,
                ar_training, 
                </cfif>

                ar_cbc_auth_form, 
                ar_agreement, 
                secondVisit)
			VALUES 
				(#client.companyid#,
                '#form.userid#',
                '#form.seasonid#',
				
                <cfif form.submittedUserType NEQ 15>
                    <!---- <cfif form.ar_info_sheet EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_info_sheet)#</cfif>,---->
					<cfif form.ar_ref_quest1 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest1)#</cfif>,
                    <cfif form.ar_ref_quest2 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest2)#</cfif>,
                    <cfif form.ar_training EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_training)#</cfif>,
                </cfif>
					<cfif form.ar_cbc_auth_form EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_cbc_auth_form)#</cfif>,
                    <cfif form.ar_agreement EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_agreement)#</cfif>,
				    <cfif form.ar_secondVisit EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_secondVisit)#</cfif>)
		</cfquery>	
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
                    
                   <a href="#client.exits_url#/nsmg/index.cfm?curdoc=user_info&userid=#userid#">View #qGetUserInfo.firstname#<cfif Right(#qGetUserInfo.firstname#, 1) is 's'>'<cfelse>'s</cfif> account.</a>
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
       

<html>
<head>
<cfoutput>
<script language="JavaScript">
<!-- 
alert("You have successfully updated this page. Thank You.");
	location.replace("?curdoc=forms/user_paperwork&userid=#form.userid#");
//-->
</script>
</cfoutput>
</head>
</html> 		

</body>
</html>