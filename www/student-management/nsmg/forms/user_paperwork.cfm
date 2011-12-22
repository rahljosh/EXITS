<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>AR Paperwork</title>
<cfoutput>
<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function CheckDates(ckname, frname) {
	if (document.form.elements[ckname].checked) {
		document.form.elements[frname].value = "#DateFormat(now(), 'mm/dd/yyyy')#";
		}
	else { 
		document.form.elements[frname].value = '';  
	}
}
//  End -->
</script>
</cfoutput>
</head>

<body>

<cfif NOT IsDefined('url.userid')>
	<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
		<tr valign=middle height=24>
			<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
			<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
			<td background="pics/header_background.gif"><h2>Area Representative Paperwork</h2></td>
			<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
		</tr>
	</table>
	<table border=0 cellpadding=4 cellspacing=0 width="100%" class="section">
		<tr><td align="center">An error has occurred. Please try again.</td></tr>
		<tr><td align="center"><a href="?curdoc=user_info&userid=#client.userid#"><img src="pics/back.gif" border="0"></a></td></tr>			
	</table>
	<cfinclude template="../table_footer.cfm">
	<cfabort>
</cfif>

<!--- CHECK RIGHTS --->
<cfinclude template="../check_rights.cfm">

<cfquery name="get_rep" datasource="MySQL">
	SELECT userid, firstname, lastname, active, accountCreationVerified
	FROM smg_users
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
</cfquery>

<cfquery name="get_paperwork" datasource="MySQL">
	SELECT p.paperworkid, p.userid, p.seasonid, p.ar_info_sheet, p.ar_ref_quest1, p.ar_ref_quest2, p.ar_cbc_auth_form, p.ar_agreement, p.ar_training, p.secondVisit, p.agreeSig, p.ar_cbAuthReview,
		s.season, p.cbcSig
	FROM smg_users_paperwork p
	LEFT JOIN smg_seasons s ON s.seasonid = p.seasonid
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
    <cfif client.companyid eq 10>
    	AND
        	fk_companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="10">
	<cfelse>
    	AND
        	fk_companyid != <cfqueryparam cfsqltype="cf_sql_integer" value="10"> 
    </cfif>
	ORDER BY p.seasonid DESC
</cfquery>

<cfquery name="used_seasons" datasource="MySQL">
	SELECT p.seasonid
	FROM smg_users_paperwork p
	WHERE userid = <cfqueryparam value="#url.userid#" cfsqltype="cf_sql_integer" maxlength="6">
    <cfif client.companyid eq 10>
    and fk_companyid = 10
    </cfif>
	GROUP BY p.seasonid
</cfquery>
<cfset season_list = ValueList(used_seasons.seasonid)>

<cfquery name="get_seasons" datasource="MySql">
	SELECT seasonid, season
	FROM smg_seasons
	WHERE active = '1'
	<!--- REMAINING SEASONS --->
	<cfif get_paperwork.recordcount>		
		AND ( <cfloop list="#season_list#" index="season">
			 seasonid != '#season#'
			 <cfif season NEQ #ListLast(season_list)#>AND</cfif>
		  </cfloop> )
	</cfif>
	ORDER BY season
</cfquery>

    <cfquery name="user_compliance" datasource="#application.dsn#">
        SELECT 
        	userid, 
            compliance
        FROM 
        	smg_users
        WHERE 
        	userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.userid#">
    </cfquery>

<Cfquery name="region_company_access" datasource="MySQL">
	SELECT uar.companyid, uar.regionid, uar.usertype, uar.id, uar.advisorid,
		   r.regionname,
		   c.companyshort,
		   ut.usertype as usertypename, ut.usertypeid,
		   adv.firstname, adv.lastname
	FROM user_access_rights uar
	INNER JOIN smg_regions r ON r.regionid = uar.regionid
	INNER JOIN smg_companies c ON c.companyid = uar.companyid
	INNER JOIN smg_usertype ut ON ut.usertypeid = uar.usertype
	LEFT JOIN smg_users adv ON adv.userid = uar.advisorid
	WHERE uar.userid = '#url.userid#'
	ORDER BY r.regionname
</Cfquery>
<cfoutput>

<!----Header Format Table---->
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/school.gif"></td>
		<td background="pics/header_background.gif"><h2>Area Representative Paperwork </h2></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>

<cfform name="form" action="?curdoc=forms/user_paperwork_qr"method="post">
<cfinput type="hidden" name="userid" value="#userid#">
<cfinput type="hidden" name="count" value="#get_paperwork.recordcount#">

<table border=0 cellpadding=0 cellspacing=0 width="100%" class="section">

	<tr>
		<td colspan=2>#get_rep.firstname# #get_rep.lastname# (###get_rep.userid#)<br />
		
	<cfloop query="region_company_access">
		#companyshort# : #regionname# (#regionid#)<br />
									</cfloop>
			</td>
	</tr>
	
	
	<tr>
		<td width="25%" valign="top">
			<table cellpadding="4" cellspacing=0 border="0" width="100%">
				<tr><td bgcolor="e2efc7" height="28"><b><span class="get_attention">></span> <u>Paperwork</u></b></td></tr>
				<tr height="30"><td ><font color="red">*</font><b>AR Information Sheet</b></td></tr>
				<tr height="30" bgcolor="##EEEEEE"><td ><font color="red">*</font><b>AR Ref. Questionnaire ##1</b></td></tr>
				<tr height="30"><td ><font color="red">*</font><b>AR Ref. Questionnaire ##2</b></td></tr>
				<tr height="30" bgcolor="##EEEEEE"><td ><font color="red">*</font><b>CBC Authorization Form</b></td></tr>
                <tr height="30"><td ><font color="red">*</font><b>CBC Verified</b></td></tr>
				<tr height="30" bgcolor="##EEEEEE"><td><font color="red">*</font><b>AR Agreement</b></td></tr>
				<tr height="30"><td><font color="red">*</font><b>AR Training Sign-off Form</b></td></tr>
                <tr height="30" bgcolor="##EEEEEE"><td><b>2nd Visit User Info Sheet</b></td></tr>
			</table>
		</td>
		<td  valign="top">

			<!--- NEW SEASON PAPERWORK --->
			<cfif client.usertype LTE 4>
				<table cellpadding="4" cellspacing=0 border="0" align="left">
					<tr  height="36"><td bgcolor="e2efc7" align="center">
							<cfselect name="seasonid" required="yes" message="You must select a season">
								<option value="0">Contract AYP</option>
								<cfloop query="get_seasons">
								<option value="#seasonid#">#season#</option>
								</cfloop>
							</cfselect>				
						</td>
					</tr>
					<tr  height="28" <Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.recordcount eq 0> bgcolor="##FFCBC4" </cfif>><td>
                    <cfinput type="checkbox" name="ar_info_sheet_check" OnClick="CheckDates('ar_info_sheet_check', 'ar_info_sheet');">
							Date: <cfinput type="text" name="ar_info_sheet" value="" size="8" maxlength="10" validate="date">					
						</td>
					</tr>
					<tr  height="28"  bgcolor="##EEEEEE" <Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.recordcount eq 0> bgcolor="##FFCBC4" </cfif>><td><cfinput type="checkbox" name="ar_ref_quest1_check" OnClick="CheckDates('ar_ref_quest1_check', 'ar_ref_quest1');"> 
							Date: <cfinput type="text" name="ar_ref_quest1" value="" size="8" maxlength="10" validate="date">					
						</td>
					</tr>
					<tr  height="28"  <Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.recordcount eq 0> bgcolor="##FFCBC4" </cfif>><td><cfinput type="checkbox" name="ar_ref_quest2_check" OnClick="CheckDates('ar_ref_quest2_check', 'ar_ref_quest2')"> 
							Date: <cfinput type="text" name="ar_ref_quest2" value="" size="8" maxlength="10" validate="date">						
						</td>
					</tr> 
					<tr  height="28" bgcolor="##EEEEEE"  <Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.recordcount eq 0 > bgcolor="##FFCBC4" </cfif>><td><cfinput type="checkbox" name="ar_cbc_auth_form_check" OnClick="CheckDates('ar_cbc_auth_form_check', 'ar_cbc_auth_form');"> 
							Date: <cfinput type="text" name="ar_cbc_auth_form" value="" size="8" maxlength="10" validate="date">						
						</td>
					</tr>
                    <tr  height="28"  <Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.recordcount eq 0 > bgcolor="##FFCBC4" </cfif>><td>
<cfinput type="checkbox" name="ar_cbAuthReview_check" OnClick="CheckDates('ar_cbAuthReview_check', 'ar_cbAuthReview');"> 
							Date: <cfinput type="text" name="ar_cbAuthReview" value="" size="8" maxlength="10" validate="date">
                					
						</td>
					</tr>
					<tr  height="28"  bgcolor="##EEEEEE"><td><cfinput type="checkbox" name="ar_agreement_check" OnClick="CheckDates('ar_agreement_check', 'ar_agreement');"> 
							Date: <cfinput type="text" name="ar_agreement" value="" size="8" maxlength="10" validate="date">
						</td>
					</tr>
					<tr  height="28"><td><cfinput type="checkbox" name="ar_training_check" OnClick="CheckDates('ar_training_check', 'ar_training');"> 
							Date: <cfinput type="text" name="ar_training" value="" size="8" maxlength="10" validate="date">
						</td>
					</tr>	
                    <tr  height="28"  bgcolor="##EEEEEE"><td><cfinput type="checkbox" name="ar_secondVisit_check" OnClick="CheckDates('ar_secondVisit_check', 'ar_secondVisit');"> 
							Date: <cfinput type="text" name="ar_secondVisit" value="" size="8" maxlength="10" validate="date">
						</td>
					</tr>			
				</table>
			</cfif>

			<!--- EXISTING SEASON PAPERWORK --->
			<cfloop query="get_paperwork">
				<!--- OFFICE --->
				<cfif client.usertype LTE 4>
					<cfinput type="hidden" name="paperworkid_#currentrow#" value="#paperworkid#">
					<table cellpadding="4" cellspacing=0 border="0" align="left">	
						<tr bgcolor="e2efc7" height="36"><td align="center"><b><span class="get_attention">></span> <u>#season#</u></b></td></tr>
						<tr  height="28"
						<Cfif get_rep.accountCreationVerified eq 0 and get_paperwork.ar_info_sheet is ''> bgcolor="##FFCBC4" </cfif>><td >
						
						<cfif ar_info_sheet EQ ''>
							<cfinput type="checkbox" name="ar_info_sheet_check_#currentrow#" OnClick="CheckDates('ar_info_sheet_check_#currentrow#', 'ar_info_sheet_#currentrow#');">
						<cfelse>
							<cfinput type="checkbox" name="ar_info_sheet_check_#currentrow#" OnClick="CheckDates('ar_info_sheet_check_#currentrow#', 'ar_info_sheet_#currentrow#');" checked="yes">				</cfif>	
								Date: <cfinput type="text" name="ar_info_sheet_#currentrow#" value="#DateFormat(ar_info_sheet, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">					
							</td>
						</tr>
						<tr  height="28"  bgcolor="##EEEEEE"<Cfif get_rep.accountCreationVerified eq 0 and ar_ref_quest1 is ''> bgcolor="##FFCBC4" </cfif>><td><cfif ar_ref_quest1 EQ ''>
									<cfinput type="checkbox" name="ar_ref_quest1_check_#currentrow#" OnClick="CheckDates('ar_ref_quest1_check_#currentrow#', 'ar_ref_quest1_#currentrow#');"> 
								<cfelse>
									<cfinput type="checkbox" name="ar_ref_quest1_check_#currentrow#" OnClick="CheckDates('ar_ref_quest1_check_#currentrow#', 'ar_ref_quest1_#currentrow#');" checked="yes">
								</cfif>
								Date: <cfinput type="text" name="ar_ref_quest1_#currentrow#" value="#DateFormat(ar_ref_quest1, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">						
							</td>
						</tr>
						<tr  height="28" <Cfif get_rep.accountCreationVerified eq 0 and ar_ref_quest2 is ''> bgcolor="##FFCBC4" </cfif>><td ><cfif ar_ref_quest2  EQ ''>
									<cfinput type="checkbox" name="ar_ref_quest2_check_#currentrow#" OnClick="CheckDates('ar_ref_quest2_check_#currentrow#', 'ar_ref_quest2_#currentrow#')"> 
								<cfelse>	
									<cfinput type="checkbox" name="ar_ref_quest2_check_#currentrow#" OnClick="CheckDates('ar_ref_quest2_check_#currentrow#', 'ar_ref_quest2_#currentrow#')" checked="yes"> 
								</cfif>
								Date: <cfinput type="text" name="ar_ref_quest2_#currentrow#" value="#DateFormat(ar_ref_quest2, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">						
							</td>
						</tr>
						<tr  height="28"  bgcolor="##EEEEEE" <Cfif get_rep.accountCreationVerified eq 0 and ar_cbc_auth_form is ''> bgcolor="##FFCBC4" </cfif>><td ><cfif ar_cbc_auth_form EQ ''>
									<cfinput type="checkbox" name="ar_cbc_auth_form_check_#currentrow#" OnClick="CheckDates('ar_cbc_auth_form_check_#currentrow#', 'ar_cbc_auth_form_#currentrow#');"> 
								<cfelse>
                                	<cfif cbcSig is ''>
									<cfinput type="checkbox" name="ar_cbc_auth_form_check_#currentrow#" OnClick="CheckDates('ar_cbc_auth_form_check_#currentrow#', 'ar_cbc_auth_form_#currentrow#');" checked="yes"> 
                                    <Cfelse>
                                    <cfinput type="checkbox" name="ar_cbc_auth_form_check_#currentrow#" OnClick="CheckDates('ar_cbc_auth_form_check_#currentrow#', 'ar_cbc_auth_form_#currentrow#');" checked="yes" disabled="true">
                                    </cfif>
								</cfif>
								Date:
                                <cfif cbcSig is not ''>
									<Cfif user_compliance.compliance EQ 1 OR client.userid eq userid or client.usertype eq 1>
                                     <a href="javascript:openPopUp('uploadedfiles/users/#get_rep.userid#/Season#seasonid#cbcAuthorization.pdf', 640, 800);">
                                    </cfif> 
                                 #DateFormat(ar_agreement, 'mm/dd/yyyy')#
                                 <input type="hidden" name="ar_cbc_auth_form_#currentrow#" value="#DateFormat(ar_cbc_auth_form, 'mm/dd/yyyy')#" />
                                 </a>
                                <cfelse>
                                	 <cfinput type="text" name="ar_cbc_auth_form_#currentrow#" value="#DateFormat(ar_cbc_auth_form, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">						</cfif>
							</td>
						</tr>
                         <tr  height="28" <Cfif get_rep.accountCreationVerified eq 0 and ar_cbAuthReview is '' > bgcolor="##FFCBC4" </cfif>><td>
                         <cfif ar_cbAuthReview is ''>
                         <cfinput type="checkbox" name="ar_cbAuthReview_check_#currentrow#" OnClick="CheckDates('ar_cbAuthReview_check_#currentrow#', 'ar_cbAuthReview_#currentrow#');"> 
                         <Cfelse>
                         <cfinput type="checkbox" name="ar_cbAuthReview_check_#currentrow#" OnClick="CheckDates('ar_cbAuthReview_check_#currentrow#', 'ar_cbAuthReview_#currentrow#');" checked="yes"> 
                         </cfif>
							Date: <cfinput type="text" name="ar_cbAuthReview_#currentrow#" value="#DateFormat(ar_cbAuthReview, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">						
						</td>
					</tr>
                        
						<tr  height="28"  bgcolor="##EEEEEE"><td><cfif ar_agreement EQ ''>
									<cfinput type="checkbox" name="ar_agreement_check_#currentrow#" OnClick="CheckDates('ar_agreement_check_#currentrow#', 'ar_agreement_#currentrow#');"> 
								<cfelse>
                                	<cfif agreeSig is ''>
									<cfinput type="checkbox" name="ar_agreement_check_#currentrow#" OnClick="CheckDates('ar_agreement_check_#currentrow#', 'ar_agreement_#currentrow#');" checked="yes"> 
                                    <Cfelse>
                                    <cfinput type="checkbox" name="ar_agreement_check_#currentrow#" disabled="true" OnClick="CheckDates('ar_agreement_check_#currentrow#', 'ar_agreement_#currentrow#');" checked="yes"> 
                                    </cfif>
								</cfif>
								Date: 
								<cfif agreeSig is not ''>
                               		 <Cfif user_compliance.compliance EQ 1 OR client.userid eq userid or client.usertype eq 1>
                                	 	<a href="javascript:openPopUp('uploadedfiles/users/#get_rep.userid#/Season#seasonid#AreaRepAgreement.pdf', 640, 800);">
                                     </cfif>
                                     #DateFormat(ar_agreement, 'mm/dd/yyyy')#</a>
                                     <input type="hidden" name="ar_agreement_#currentrow#" value="#DateFormat(ar_agreement, 'mm/dd/yyyy')#" />
                                <cfelse>
                                	<cfinput type="text" name="ar_agreement_#currentrow#" value="#DateFormat(ar_agreement, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">				</cfif>
							</td>
						</tr>
						<tr  height="28"><td><cfif ar_training EQ ''>
									<cfinput type="checkbox" name="ar_training_check_#currentrow#" OnClick="CheckDates('ar_training_check_#currentrow#', 'ar_training_#currentrow#');"> 
								<cfelse>
									<cfinput type="checkbox" name="ar_training_check_#currentrow#" OnClick="CheckDates('ar_training_check_#currentrow#', 'ar_training_#currentrow#');" checked="yes"> 
								</cfif>
								Date: <cfinput type="text" name="ar_training_#currentrow#" value="#DateFormat(ar_training, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">
							</td>
						</tr>
                        <tr  height="28"  bgcolor="##EEEEEE"><td><cfif secondVisit EQ ''>
									<cfinput type="checkbox" name="ar_secondVisit_check_#currentrow#" OnClick="CheckDates('ar_secondVisit_check_#currentrow#', 'ar_secondVisit_#currentrow#');"> 
								<cfelse>
									<cfinput type="checkbox" name="ar_secondVisit_check_#currentrow#" OnClick="CheckDates('ar_secondVisit_check_#currentrow#', 'ar_secondVisit_#currentrow#');" checked="yes"> 
								</cfif>
								Date: <cfinput type="text" name="ar_secondVisit_#currentrow#" value="#DateFormat(secondVisit, 'mm/dd/yyyy')#" size="8" maxlength="10" validate="date">
							</td>
						</tr>
					</table>
                    
      
                   
                    
				<!--- FIELD / READ ONLY--->
				<cfelse>
					<table cellpadding="4" cellspacing=0 border="0" align="left">	
						<tr bgcolor="e2efc7" height="36"><td align="center"><b><span class="get_attention">></span> <u>#season#</u></b></td></tr>
						<tr  height="28" <Cfif get_rep.active eq 0 and ar_info_sheet is ''> bgcolor="##FFCBC4" </cfif>><td><input type="checkbox" name="ar_info_sheet_check_#currentrow#" disabled="disabled" <cfif ar_info_sheet NEQ ''>checked="checked"</cfif>>
								Date: <input name="ar_info_sheet_#currentrow#" value="#DateFormat(ar_info_sheet, 'mm/dd/yyyy')#" size="8" disabled="disabled" />				
							</td>
						</tr>
						<tr  height="28"  bgcolor="##EEEEEE" <Cfif get_rep.active eq 0 and ar_ref_quest1 is ''> bgcolor="##FFCBC4" </cfif>><td><input type="checkbox" name="ar_ref_quest1_check_#currentrow#" disabled="disabled" <cfif ar_ref_quest1 NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_ref_quest1_#currentrow#" value="#DateFormat(ar_ref_quest1, 'mm/dd/yyyy')#" size="8" disabled="disabled" />					
							</td>
						</tr>
						<tr  height="28" <Cfif get_rep.active eq 0 and ar_ref_quest2 is ''> bgcolor="##FFCBC4" </cfif>><td><input type="checkbox" name="ar_ref_quest2_check_#currentrow#" disabled="disabled" <cfif ar_ref_quest2 NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_ref_quest2_#currentrow#" value="#DateFormat(ar_ref_quest2, 'mm/dd/yyyy')#" size="8" disabled="disabled" /> 						
							</td>
						</tr>
						<tr  height="28"  bgcolor="##EEEEEE"><td <Cfif get_rep.active eq 0 and ar_cbc_auth_form is ''> bgcolor="##FFCBC4" </cfif>>><input type="checkbox" name="ar_cbc_auth_form_check_#currentrow#" disabled="disabled" <cfif ar_cbc_auth_form NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_cbc_auth_form_#currentrow#" value="#DateFormat(ar_cbc_auth_form, 'mm/dd/yyyy')#" size="8" disabled="disabled" />						
							</td>
						</tr>
 						<tr  height="28"><td <Cfif get_rep.active eq 0 and ar_cbAuthReview is ''> bgcolor="##FFCBC4" </cfif>>><input type="checkbox" name="ar_cbAuthReview_#currentrow#" disabled="disabled" <cfif ar_cbc_auth_verified NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_cbAuthReview_#currentrow#" value="#DateFormat(ar_cbAuthReview, 'mm/dd/yyyy')#" size="8" disabled="disabled" />						
							</td>
						</tr>                       
                        
                      
                        
                        
						<tr  height="28"  bgcolor="##EEEEEE"><td><input type="checkbox" name="ar_agreement_check_#currentrow#" disabled="disabled" <cfif ar_agreement NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_agreement_#currentrow#" value="#DateFormat(ar_agreement, 'mm/dd/yyyy')#" size="8" disabled="disabled" />
							</td>
						</tr>
						<tr  height="28"><td><input type="checkbox" name="ar_training_check_#currentrow#" disabled="disabled" <cfif ar_training NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_training_#currentrow#" value="#DateFormat(ar_training, 'mm/dd/yyyy')#" size="8" disabled="disabled" />
							</td>
						</tr>
                        <tr  height="28"  bgcolor="##EEEEEE"><td><input type="checkbox" name="ar_secondVisit_check_#currentrow#" disabled="disabled" <cfif ar_secondVisit NEQ ''>checked="checked"</cfif>> 
								Date: <input name="ar_secondVisit_#currentrow#" value="#DateFormat(secondVisit, 'mm/dd/yyyy')#" size="8" disabled="disabled" />
							</td>
						</tr>
					</table>				
				</cfif>	
			</cfloop>
            
		</td>
       <!----For new accounts, display instructions---->
        <Cfif get_rep.accountCreationVerified eq 0>
        <td valign="top" align=left>
           <table >
           	<tr>
               	<Td><strong>This appears to be a new account waiting to be activated.</strong><Br /><br />
                <cfset cbcCheck = 0>
                <Cfquery name="qCheckCBCRun" datasource="#application.dsn#">
                select *
                from smg_users_cbc
                where userid = #url.userid#
                </Cfquery>
               <cfif qCheckCBCRun.recordcount eq 0>
               <cfset cbcCheck = 1>
             
              <cfelse>
              <Cfquery name="qCheckHold" dbtype="query">
              select *
              from qCheckCBCRun
              where flagcbc = 1
              </Cfquery>
              	<cfif qCheckHold.recordcount neq 0> 
                <Cfset cbcCheck = 1>
              	Uh oh, CBC has been run, but has been flagged. Better look into it!<br /><br />
              	</cfif>
               </cfif>
               
                <cfif cbcCheck eq 1 or get_paperwork.ar_info_sheet is '' or get_paperwork.ar_ref_quest1 is '' OR get_paperwork.ar_ref_quest2 is '' or  get_paperwork.ar_cbc_auth_form is '' or get_paperwork.ar_cbAuthReview is ''>
                Along with the items highlited on left (if any), the CBC needs to be run<br /> before activating this account.
                You are not able to activate an account<br /> until all items have been completed. 
                <cfelse>
                <h3>Excellent!!</h3><br />  It looks like this account is ready to be activated, place your pointer<br />
                 over the "button below and click it... that's all there is to it.
                </cfif>
                <Br /><Br />
               
                
                
               
               <cfif cbcCheck eq 1 or get_paperwork.ar_info_sheet is '' or get_paperwork.ar_ref_quest1 is '' OR get_paperwork.ar_ref_quest2 is '' or  get_paperwork.ar_cbc_auth_form is ''  or get_paperwork.ar_cbAuthReview is ''>
               <img src="pics/activateNot.png" width="130" height="25" />
               <Cfelse>
               <A href="?curdoc=activateNewAccount&userid=#url.userid#"><img src="pics/activateActive.png" width="130" height="25" border="0" /></A>
               </cfif><Br /><Br />
               <cfif cbcCheck eq 1>
                Just a reminder that no CBC has been run <br /><br />
            </cfif>
        <em>When this account is activated, the user will receive the<br />
         welcome email.  The Regional Manager will also receive<Br /> 
         an email letting them know the account is active. </em>
                </Td>
           </tr>
            </table>
       </td>
         </Cfif>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<Cfif get_rep.active eq 1>
    <tr>
    	<Td colspan=30>
    <font color="red">*</font>Required for new accounts before account can be activated.</Td></Tr></Cfif>
    	
    

        
</table>
<table border=0 cellpadding=2 cellspacing=0 width="100%" class="section">
	<tr><td colspan="2" valign="top" align="center">
			<div class="button">
				<a href="?curdoc=user_info&userid=#url.userid#"><img src="pics/back.gif" border="0"></a> &nbsp; &nbsp; &nbsp; &nbsp;
				<cfif client.usertype LTE 4><cfinput name="Submit" type="image" src="pics/update.gif" border=0></cfif>
			</div>
		</td>
	</tr>	
</table>
</cfform>

<cfinclude template="../table_footer.cfm">

</cfoutput>	

<!--- UPDATE NEW TABLE --->
<!---
<cfif client.userid eq 510>
	<cfquery name="get_users" datasource="MySql">
		SELECT userid, ar_info_sheet, ar_ref_quest1, ar_ref_quest2, ar_cbc_auth_form, ar_agreement, ar_training
		FROM smg_users
		WHERE active = '1' 
			AND (ar_info_sheet IS NOT NULL 
			OR ar_ref_quest1 IS NOT NULL
			OR ar_ref_quest2 IS NOT NULL 
			OR ar_cbc_auth_form IS NOT NULL 
			OR ar_agreement IS NOT NULL 
			OR ar_training)
	</cfquery>
	<cfloop query="get_users">
		<!--- SEASON 07/08 = 4 --->
		<cfquery name="insert" datasource="MySql">
			INSERT INTO smg_users_paperwork
			(userid, seasonid, ar_info_sheet, ar_ref_quest1, ar_ref_quest2, ar_cbc_auth_form, ar_agreement, ar_training)
			VALUES
			('#userid#', '4', 
			<cfif ar_info_sheet NEQ ''>#CreateODBCDate(ar_info_sheet)#<cfelse>NULL</cfif>, 
			<cfif ar_ref_quest1 NEQ ''>#CreateODBCDate(ar_ref_quest1)#<cfelse>NULL</cfif>, 
			<cfif ar_ref_quest2 NEQ ''>#CreateODBCDate(ar_ref_quest2)#<cfelse>NULL</cfif>, 
			<cfif ar_cbc_auth_form NEQ ''>#CreateODBCDate(ar_cbc_auth_form)#<cfelse>NULL</cfif>, 
			<cfif ar_agreement NEQ ''>#CreateODBCDate(ar_agreement)#<cfelse>NULL</cfif>, 
			<cfif ar_training NEQ ''>#CreateODBCDate(ar_training)#<cfelse>NULL</cfif>)
		</cfquery>
	</cfloop>
</cfif>
--->
</body>
</html>
