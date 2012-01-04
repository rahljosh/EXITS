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
			SET ar_info_sheet = <cfif form["ar_info_sheet_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_info_sheet_" & x])#</cfif>,
				ar_ref_quest1 = <cfif form["ar_ref_quest1_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest1_" & x])#</cfif>,
				ar_ref_quest2 = <cfif form["ar_ref_quest2_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_ref_quest2_" & x])#</cfif>,
                <cfif form.submittedUserType NEQ 15>
				ar_cbc_auth_form = <cfif form["ar_cbc_auth_form_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_cbc_auth_form_" & x])#</cfif>,
                </cfif>
                ar_agreement = <cfif form["ar_agreement_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_agreement_" & x])#</cfif>,
				ar_training = <cfif form["ar_training_" & x] EQ ''>NULL<cfelse>#CreateODBCDate(form["ar_training_" & x])#</cfif>,
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
                ar_info_sheet, 
                ar_ref_quest1, 
                ar_ref_quest2, 
                <cfif form.submittedUserType NEQ 15>
                ar_cbc_auth_form, 
                </cfif>
                ar_agreement, 
               
                ar_training,
                secondVisit)
			VALUES 
				(#client.companyid#,
                '#form.userid#',
                '#form.seasonid#',
				<cfif form.ar_info_sheet EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_info_sheet)#</cfif>,
				<cfif form.ar_ref_quest1 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest1)#</cfif>,
				<cfif form.ar_ref_quest2 EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_ref_quest2)#</cfif>,
                <cfif form.submittedUserType NEQ 15>
					<cfif form.ar_cbc_auth_form EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_cbc_auth_form)#</cfif>,
                </cfif>
                <cfif form.ar_agreement EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_agreement)#</cfif>,
				<cfif form.ar_training EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_training)#</cfif>,
                <cfif form.ar_secondVisit EQ ''>NULL<cfelse>#CreateODBCDate(form.ar_secondVisit)#</cfif>)
		</cfquery>	
	</cftransaction>
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