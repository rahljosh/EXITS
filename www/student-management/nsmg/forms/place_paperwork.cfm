<!--- ------------------------------------------------------------------------- ----
	
	File:		place_paperwork.cfm
	Author:		Marcus Melo
	Date:		June 15, 2011
	Desc:		Placement Paperwork Management

	Updated:																
				
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	

	<!--- Student Info --->
    <cfinclude template="../querys/get_student_info.cfm">
    
    <cfquery name="qGetArrival" datasource="MySql">
        SELECT DISTINCT 
            dep_date
        FROM 
            smg_flight_info
        WHERE 
            studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
        AND 
            flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
        AND
            isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">  
        ORDER BY 
            dep_date DESC
    </cfquery>
    
    <cfquery name="qGetHostFamily" datasource="MySql">
        SELECT 
        	hostid, 
            familylastname, 
            fatherfirstname, 
            fatherlastname, 
            fatherdob, 
            fathercbc_form, 
            motherfirstname, 
            motherlastname, 
            motherdob,
            mothercbc_form
        FROM 
        	smg_hosts
        WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.hostid#">
    </cfquery>
    
    <cfquery name="qGetFamilyMembers" datasource="MySql">
        SELECT 
        	childid, 
            membertype, 
            name, 
            lastname, 
            birthdate, 
            cbc_form_received
        FROM 
        	smg_host_children  
        WHERE 
        	hostid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.hostid#">
        AND 
        	(DATEDIFF(now(), birthdate)/365) > 18
        AND 
        	liveathome = 'yes'
        AND
        	isDeleted = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
    </cfquery>
    
    <cfquery name="season" datasource="#application.dsn#">
    	SELECT 
        	seasonid
        FROM 
        	smg_programs
        WHERE 
        	programid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.programid#">
    </cfquery>

</cfsilent>

<!--- Page Header --->
<gui:pageHeader
	headerType="applicationNoHeader"
/>	

<cfoutput>
	<SCRIPT LANGUAGE="JavaScript">
	<!-- Begin
	function CheckDates(ckname, frname) {
		if (document.form.elements[ckname].checked) {
			document.form.elements[frname].value = '#DateFormat(now(), 'mm/dd/yyyy')#';
			}
		else { 
			document.form.elements[frname].value = '';  
		}
	}	
	//  End -->
	</script>
</cfoutput>

<style type="text/css">
.alert{
	width:550;
	height:55px;
	border:#666;
	background-color:#FF9797;
	text-align:center;
	-moz-border-radius: 15px;
	border-radius: 15px;
	vertical-align:center;
	margin-left:auto;
	margin-right:auto;
	

}
</style>

<cfif not IsDefined('url.update')>
	<cfset url.udpate = 'no'>
</cfif>

<!--- include template page header --->
<cfinclude template="placement_status_header.cfm">

<table width="560" align="center">
<tr><td><span class="application_section_header">Placement Paperwork</span></td></tr>
</table><br>

<div class="row">

<cfif get_student_info.hostid EQ 0>
	<cfoutput>
	<table width="560" align="center">
	<tr><td align="center"><h3>There is no host family assigned to this student.</h3></td></tr>
	<tr><td align="center"><h3>You cannot check placement paperworks without a host family. Please add a host family in order to continue.</h3></td></tr>
	</table><br>
	<table width="560" align="center">
	<tr><td align="center">
			<input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
		</td></tr>
	</table>
	</cfoutput>
	<cfabort>
</cfif>

<cfoutput query="get_student_info">
<cfif client.usertype GT 4>
	<cfparam name="edit" default="no">
<cfelse>
	<cfparam name="edit" default="yes">
	<form action="../querys/update_check_list.cfm?studentid=#url.studentid#&season=#season.seasonid#" name="form" method="post">
</cfif>
<cfif url.update is 'yes'>
<div align="center"><span class="get_Attention">Placement Paperwork Updated</span></div>
</cfif>

<input type="hidden" name="hostid" value="#get_student_info.hostid#">
<cfif client.totalfam eq 1 and season.seasonid gt 7>
<div class="alert">
<h1>Single Person Placement - additional screening will be required.</h1>
<em>2 additional references and  Single Person Placement Authorization Form required</em> </div>
<br />
</cfif>
<Table width="560" align="center" cellpadding=4 cellspacing="0">
	<tr>
		<td colspan=3><u>Paperwork Received</u></td>
	</tr>
    <Cfif client.totalfam eq 1 and season.seasonid gt 7>
    <tr> <!-- 0 - SINGLE PLACEMENT VEROFOCASTOPM --->
        <td width="5%"><Cfif #get_student_info.doc_single_place_auth# EQ ''>
                <input type="checkbox" name="single_auth" OnClick="CheckDates('single_auth', 'doc_single_place_auth');" <cfif edit is 'no'>disabled</cfif>>
            <cfelse>
                <input type="checkbox" name="single_auth" OnClick="CheckDates('single_auth', 'doc_single_place_auth');" checked <cfif edit is 'no'>disabled</cfif>>		
            </cfif>
        </td>
        <td width="55%">Single Person Placement Verification</td>
        <td align="left" width="40%">Date: &nbsp;<input type="text" name="doc_single_place_auth" class="datePicker" size="9" value="#DateFormat(doc_single_place_auth, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr><tr> <!-- 8 - REFERENCE FORM 1 --->
		<td><Cfif #get_student_info.doc_single_ref_form_1# EQ ''>
				<input type="checkbox" name="single_check_form1" OnClick="CheckDates('single_check_form1', 'doc_single_ref_form_1');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="single_check_form1" OnClick="CheckDates('single_check_form1', 'doc_single_ref_form_1');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Single Person Placement Reference 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_single_ref_form_1" class="datePicker" size="9" value="#DateFormat(doc_single_ref_form_1, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- REFERENCE CHECK FORM 1 --->
		<td>&nbsp;</td>
		<td>Date of S.P. Reference Check 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_single_ref_check1" class="datePicker" size="9" value="#DateFormat(doc_single_ref_check1, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 9 - REFERENCE FORM 2 --->
		<td><Cfif #get_student_info.doc_single_ref_form_2# EQ ''>
				<input type="checkbox" name="single_check_form2" OnClick="CheckDates('single_check_form2', 'doc_single_ref_form_2');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="single_check_form2" OnClick="CheckDates('single_check_form2', 'doc_single_ref_form_2');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Single Person Placement Reference 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_single_ref_form_2" class="datePicker" size="9" value="#DateFormat(doc_single_ref_form_2, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!--Single  REFERENCE CHECK FORM 2 --->
		<td>&nbsp;</td>
		<td>Date of S.P. Reference Check 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_single_ref_check2" class="datePicker" size="9" value="#DateFormat(doc_single_ref_check2, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>		
    </Cfif>    
	<tr> <!-- 1 - Host Application Received --->
		<td><Cfif #get_student_info.doc_full_host_app_date# EQ ''>
				<input type="checkbox" name="check_app" OnClick="CheckDates('check_app', 'doc_full_host_app_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_app" OnClick="CheckDates('check_app', 'doc_full_host_app_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Application Received</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_full_host_app_date" class="datePicker" size="9" value="#DateFormat(doc_full_host_app_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!-- 2 - Host Family Letter --->
		<td><Cfif #get_student_info.doc_letter_rec_date# EQ ''>
				<input type="checkbox" name="check_let" OnClick="CheckDates('check_let', 'doc_letter_rec_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_let" OnClick="CheckDates('check_let', 'doc_letter_rec_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Letter Received</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_letter_rec_date" class="datePicker" size="9" value="#DateFormat(doc_letter_rec_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 3 - Host Family Rules Form --->
		<td><Cfif #get_student_info.doc_rules_rec_date# EQ ''>
				<input type="checkbox" name="check_rul" OnClick="CheckDates('check_rul', 'doc_rules_rec_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_rul" OnClick="CheckDates('check_rul', 'doc_rules_rec_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Rules Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_rules_rec_date" class="datePicker" size="9" value="#DateFormat(doc_rules_rec_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 4 - Host Family Photos --->
		<td><Cfif #get_student_info.doc_photos_rec_date# EQ ''>
				<input type="checkbox" name="check_photos" OnClick="CheckDates('check_photos', 'doc_photos_rec_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_photos" OnClick="CheckDates('check_photos', 'doc_photos_rec_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Host Family Photos</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_photos_rec_date" class="datePicker" size="9" value="#DateFormat(doc_photos_rec_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 5 - SCHOOL AND COMMUNITY PROFILE --->
		<td><Cfif #get_student_info.doc_school_profile_rec# EQ ''>
				<input type="checkbox" name="check_profile" OnClick="CheckDates('check_profile', 'doc_school_profile_rec');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_profile" OnClick="CheckDates('check_profile', 'doc_school_profile_rec');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>School & Community Profile Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_school_profile_rec" class="datePicker" size="9" value="#DateFormat(doc_school_profile_rec, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 6 - CONFIDENTIAL HOST FAMILY VISIT FORM --->
		<td><Cfif #get_student_info.doc_conf_host_rec# EQ ''>
				<input type="checkbox" name="check_confi" OnClick="CheckDates('check_confi', 'doc_conf_host_rec');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_confi" OnClick="CheckDates('check_confi', 'doc_conf_host_rec');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Confidential Host Family Visit Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_conf_host_rec" class="datePicker" size="9" value="#DateFormat(doc_conf_host_rec, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	

	<tr> <!-- 7 - VISIT DATE --->
		<td>&nbsp;</td>
		<td><!--- <Cfif #get_student_info.doc_date_of_visit# EQ ''>
				<input type="checkbox" name="check_visit" OnClick="CheckDates('check_visit', 'doc_date_of_visit');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_visit" OnClick="CheckDates('check_visit', 'doc_date_of_visit');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif> &nbsp; --->
			Date of Visit</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_date_of_visit" class="datePicker" size="9" value="#DateFormat(doc_date_of_visit, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
    <!----
         <Cfif client.totalfam eq 1 >
	<tr> <!---- 6 - CONFIDENTIAL HOST FAMILY VISIT FORM FOR SINGLES --->
		<td><Cfif #get_student_info.doc_conf_host_single_rec# EQ ''>
				<input type="checkbox" name="check_confi_single" OnClick="CheckDates('check_confi_single', 'doc_conf_host_single_rec');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_confi_single" OnClick="CheckDates('check_confi_single', 'doc_conf_host_single_rec');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Confidential SINGLE Host Family Visit </td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_conf_host_single_rec" class="datePicker" size="9" value="#DateFormat(doc_conf_host_single_rec, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!---- 7 - VISIT DATE --->
		<td>&nbsp;</td>
		<td><!--- <Cfif #get_student_info.doc_date_of_visit# EQ ''>
				<input type="checkbox" name="check_visit" OnClick="CheckDates('check_visit', 'doc_date_of_visit');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_visit" OnClick="CheckDates('check_visit', 'doc_date_of_visit');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif> &nbsp; --->
			Date of Visit</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_date_of_single_visit" class="datePicker" size="9" value="#DateFormat(doc_date_of_single_visit, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
    </Cfif>
    <br>---->
	<cfif season.seasonid gt 7>
    	<tr> <!-- 6 - CONFIDENTIAL HOST FAMILY 2 VISIT FORM --->
            <td><input type="checkbox" name="check_confi2" <Cfif isDate(qGetSecondVisitReport.pr_sr_approved_date)> checked="checked" </cfif> disabled="disabled" ></td>
            <td>2nd Confidential Host Family Visit Form</td>
            <td align="left">Date: &nbsp;<input type="text" name="doc_conf_host_rec2" class="datePicker" size="9" value="#DateFormat(qGetSecondVisitReport.pr_sr_approved_date, 'mm/dd/yyyy')#"  disabled="disabled"></td>
        </tr>	
   
        <tr> <!-- 7 - VISIT DATE --->
            <td>&nbsp;</td>
            <td>Date of 2nd Visit</td>
			<td align="left">Date: &nbsp;<input type="text" name="doc_date_of_visit2" class="datePicker" value="#DateFormat(qGetSecondVisitReport.dateOfVisit, 'mm/dd/yyyy')#" disabled="disabled"></td>
        </tr>
	</cfif>
	<tr> <!-- 8 - REFERENCE FORM 1 --->
		<td><Cfif #get_student_info.doc_ref_form_1# EQ ''>
				<input type="checkbox" name="check_form1" OnClick="CheckDates('check_form1', 'doc_ref_form_1');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_form1" OnClick="CheckDates('check_form1', 'doc_ref_form_1');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Reference Form 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_form_1" class="datePicker" size="9" value="#DateFormat(doc_ref_form_1, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- REFERENCE CHECK FORM 1 --->
		<td>&nbsp;</td>
		<td>Date of Reference Check 1</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_check1" class="datePicker" size="9" value="#DateFormat(doc_ref_check1, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	<tr> <!-- 9 - REFERENCE FORM 2 --->
		<td><Cfif #get_student_info.doc_ref_form_2# EQ ''>
				<input type="checkbox" name="check_form2" OnClick="CheckDates('check_form2', 'doc_ref_form_2');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_form2" OnClick="CheckDates('check_form2', 'doc_ref_form_2');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Reference Form 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_form_2" class="datePicker" size="9" value="#DateFormat(doc_ref_form_2, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!-- REFERENCE CHECK FORM 2 --->
		<td>&nbsp;</td>
		<td>Date of Reference Check 2</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_ref_check2" class="datePicker" size="9" value="#DateFormat(doc_ref_check2, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
    <tr> <!---- 3 - Income Verificaiont --->
		<td><Cfif #get_student_info.doc_income_ver_date# EQ ''>
				<input type="checkbox" name="income_ver" OnClick="CheckDates('income_ver', 'doc_income_ver_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="income_ver" OnClick="CheckDates('income_ver', 'doc_income_ver_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>Income Verification Form</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_income_ver_date" class="datePicker" size="9" value="#DateFormat(doc_income_ver_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>		
</table><br>

<!--- ARRIVAL DATE COMPLIANCE - SCHOOL + CBC FORMS --->
<Table width="560" align="center" cellpadding=4 cellspacing="0">
	<tr>
		<td colspan="2"><u>Arrival Date Compliance</u></td>
		<td bgcolor="##CCCCCC">Arrival Date: <b><cfif qGetArrival.dep_date EQ ''>n/a<cfelse>#DateFormat(qGetArrival.dep_date, 'mm/dd/yyyy')#</cfif></b></td>
	</tr>
	<tr> <!-- SCHOOL ACCEPTANCE FORM --->
		<td width="5%"><Cfif #get_student_info.doc_school_accept_date# EQ ''>
				<input type="checkbox" name="check_school" OnClick="CheckDates('check_school', 'doc_school_accept_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_school" OnClick="CheckDates('check_school', 'doc_school_accept_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td width="55%">School Acceptance Form</td>
		<td width="40%" align="left">Date: &nbsp;<input type="text" name="doc_school_accept_date" class="datePicker" size="9" value="#DateFormat(doc_school_accept_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!-- SCHOOL ACCEPTANCE SIGNATURE DATE --->
		<td>&nbsp;</td>
		<td>Date of Signature</td>
		<td align="left">Date: &nbsp;<input type="text" name="doc_school_sign_date" class="datePicker" size="9" value="#DateFormat(doc_school_sign_date, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
	
	<tr>
		<td colspan=3>CBC Forms</td>
	</tr>	
	<tr>
		<td><input type="checkbox" name="fathercbc_form_check" OnClick="CheckDates('fathercbc_form_check', 'fathercbc_form');" <cfif qGetHostFamily.fathercbc_form NEQ''>checked</cfif> <cfif edit is 'no'>disabled</cfif>></td>
		<td>Host Father</td>
		<td align="left">Date: &nbsp;<input type="text" name="fathercbc_form" class="datePicker" size="9" value="#DateFormat(qGetHostFamily.fathercbc_form, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> 
		<td><input type="checkbox" name="mothercbc_form_check" OnClick="CheckDates('mothercbc_form_check', 'mothercbc_form');" <cfif qGetHostFamily.mothercbc_form NEQ''>checked</cfif> <cfif edit is 'no'>disabled</cfif>></td>
		<td>Host Mother</td>
		<td align="left">Date: &nbsp;<input type="text" name="mothercbc_form" class="datePicker" size="9" value="#DateFormat(qGetHostFamily.mothercbc_form, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr>
		<td colspan=3>CBC Host Members 18+</td>
	</tr>	
	<input type="hidden" name="total_members" value="#qGetFamilyMembers.recordcount#">
	<cfif qGetFamilyMembers.recordcount>
		<cfloop query="qGetFamilyMembers">
		<input type="hidden" name="childid_#currentrow#" value="#childid#">
		<tr> 
			<td><input type="checkbox" name="member#currentrow#_check" OnClick="CheckDates('member#currentrow#_check', 'cbc_form_received#currentrow#');" <cfif cbc_form_received NEQ''>checked</cfif> <cfif edit is 'no'>disabled</cfif>></td>
			<td>#name# #lastname# - #DateDiff('yyyy', birthdate, now())# years old</td>
			<td align="left">Date: &nbsp;<input type="text" name="cbc_form_received#currentrow#" class="datePicker" size="9" value="#DateFormat(cbc_form_received, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
		</tr>
		</cfloop>
	<cfelse>
	<tr><td colspan="3">No family members older than 18 years old.</td></tr>
	</cfif>
</Table><br>

<Table width="560" align="center" cellpadding=4 cellspacing="0">
	<tr>
		<td><u>Student Application</u></td>
	</tr>
	<tr>
		<Td><cfif copy_app_school is 'no'>
			<input type="radio" name="copy_app_school" value="yes" <cfif edit is 'no'>disabled</cfif>>Yes <input type="radio" name="copy_app_school" value="no" checked <cfif edit is 'no'>disabled</cfif>>No<cfelse>
			<input type="radio" name="copy_app_school"  value="yes" checked <cfif edit is 'no'>disabled</cfif>>Yes <input type="radio" name="copy_app_school" value="no" <cfif edit is 'no'>disabled</cfif>>No</cfif>&nbsp;&nbsp;&nbsp;Copy to School</td>
	
	</tr>
</table><br>

<!--- Arrival Orientation --->
<Table width="560" align="center" cellpadding=4 cellspacing="0">
	<tr>
		<td colspan=3><u>Arrival Orientation</u></td>
	</tr>
	<tr> <!-- 1 - Student --->
		<td width="5%"><Cfif stu_arrival_orientation EQ ''>
				<input type="checkbox" name="check_stu" OnClick="CheckDates('check_stu', 'stu_orientation_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_stu" OnClick="CheckDates('check_stu', 'stu_orientation_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td width="55%">Student Orientation</td>
		<td align="left" width="40%">Date: &nbsp;<input type="text" name="stu_orientation_date" class="datePicker" size="9" value="#DateFormat(stu_arrival_orientation, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!-- 1 - Student --->
		<td><Cfif host_arrival_orientation EQ ''>
				<input type="checkbox" name="check_host" OnClick="CheckDates('check_host', 'host_orientation_date');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_host" OnClick="CheckDates('check_host', 'host_orientation_date');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td>HF Orientation</td>
		<td align="left">Date: &nbsp;<input type="text" name="host_orientation_date" class="datePicker" size="9" value="#DateFormat(host_arrival_orientation, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>
	<tr> <!-- CLASS SCHEDULE --->
		<td width="5%"><Cfif #get_student_info.doc_class_schedule# EQ ''>
				<input type="checkbox" name="check_class_schedule" OnClick="CheckDates('check_class_schedule', 'doc_class_schedule');" <cfif edit is 'no'>disabled</cfif>>
			<cfelse>
				<input type="checkbox" name="check_class_schedule" OnClick="CheckDates('check_class_schedule', 'doc_class_schedule');" checked <cfif edit is 'no'>disabled</cfif>>		
			</cfif>
		</td>
		<td width="55%">Class Schedule</td>
		<td width="40%" align="left">Date: &nbsp;<input type="text" name="doc_class_schedule" class="datePicker" size="9" value="#DateFormat(doc_class_schedule, 'mm/dd/yyyy')#" <cfif edit is 'no'>readonly</cfif>></td>
	</tr>	
</table><br>

<table width="560" align="center">
<tr>
	<cfif client.usertype GT 4>
        <td align="center">
            <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
        </td>
	<cfelse>
        <td align="right" width="50%"><font size=-1><br>
            <input name="submit" type="image" src="../pics/update.gif" align="right" border=0>&nbsp;&nbsp;</form></td>
        <td align="left" width="50%">
            <font size=-1><Br>&nbsp;&nbsp;
            <input type="image" value="close window" src="../pics/close.gif" onClick="javascript:window.close()">
        </td>
	</cfif>
</tr>
</table>
</cfoutput>

<!--- PLACEMENT HISTORY --->
<cfquery name="history_dates" datasource="MySQL">
	SELECT dateofchange
	FROM smg_hosthistory
	WHERE smg_hosthistory.studentid = #client.studentid#
	GROUP BY dateofchange
	ORDER BY smg_hosthistory.dateofchange desc
</cfquery>

<Cfif history_dates.recordcount is not 0>
	<!--- PLACEMENT HISTORY --->
	<cfquery name="placement_history" datasource="MySQL">
		SELECT hist.*, 
			   h.familylastname,
	    	   place.firstname as placefirstname, place.lastname as placelastname,
			   changedby.firstname as changedbyfirstname, changedby.lastname as changedbylastname
		FROM smg_hosthistory hist
		INNER JOIN smg_hosts h ON hist.hostid = h.hostid
		LEFT OUTER JOIN smg_users place ON hist.placerepid = place.userid
		LEFT OUTER JOIN smg_users changedby ON hist.changedby = changedby.userid
		WHERE hist.studentid = #client.studentid#
			  AND hist.hostid <> '0' AND original_place = 'no'
		ORDER BY hist.dateofchange desc, hist.historyid DESC
	</cfquery>
  	<Table width=580 cellpadding=3 cellspacing=0 align="center" class="history">
	<tr><td colspan="5" align="center"><font color="a8a8a8">P A P E R W O R K &nbsp; L O G </font><br><br></td></tr>
	<cfoutput query="placement_history">
		<!--- If Paperwork is complete --->
		<cfif placement_history.doc_full_host_app_date is not '' and placement_history.doc_letter_rec_date is not ''
		and placement_history.doc_rules_rec_date is not '' and placement_history.doc_photos_rec_date is not '' and placement_history.doc_school_accept_date is not ''
		and placement_history.doc_school_profile_rec is not '' and placement_history.doc_conf_host_rec is not '' and placement_history.doc_ref_form_1 is not ''
		and placement_history.doc_ref_form_2 is not ''>
			<cfset paperwork_image = 'check_ok'>  <!--- paperwork complete image --->
		<cfelse>
			<cfset paperwork_image = 'check_notok'>  <!--- paperwork incomplete image --->
		</cfif>
		<tr bgcolor="D5DCE5"><td colspan="6">Date : &nbsp; #DateFormat(dateofchange, 'mm/dd/yyyy')#</td></tr>
		<tr><td width="90"><u>Host Fam.</u></td>
		<td width="100"><u> Doc History.</u></td>
		<td width="110"><u>Place Rep.</u></td>
		<td width="160"><u>Reason</u></td>
		<td width="120"><u>Changed By</u></td>
		<td width="50" align="center"><u>Status</u></td></tr>	
		<tr bgcolor="#iif(placement_history.currentrow MOD 2 ,DE("WhiteSmoke") ,DE("white") )#">
			<td><cfif hostid is not '0'>
		
			#familylastname# (#hostid#)</a></cfif></td>
			
			<td><cfif hostid is not '0'>
			<a class=nav_bar href="" onClick="window.open('place_paperwork_log.cfm?historyid=#historyid#', 'mywindow', 'height=600, width=400, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); return false;">
			Paperwork</a></cfif></td>
			
			
			
			<td><cfif placerepid is not '0'>#placefirstname# #placelastname# (#placerepid#)</cfif></td>
			<td>#reason#</td>
			<td>#changedbyfirstname# #changedbylastname# (#changedby#)</td>
			<td align="center"><a class=nav_bar href="" onClick="window.open('place_paperwork_log.cfm?historyid=#historyid#', 'mywindow', 'height=600, width=400, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); return false;">
			<img src="../pics/#paperwork_image#.gif" border="0"></a></td>
		</tr>
	</cfoutput>
	</table>
</cfif>
<br></div>


<!--- Page Footer --->
<gui:pageFooter
	footerType="application"
/>
