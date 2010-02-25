<!--- ------------------------------------------------------------------------- ----
	
	File:		new_transaction_programid.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Gets a list with uninsured students, set them as insured.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param variables --->
	<cfparam name="URL.uniqueID" default="">

	<cfinclude template="../querys/get_candidate_unqID.cfm">
    <cfinclude template="../querys/countrylist.cfm">
    <cfinclude template="../querys/fieldstudy.cfm">
    <cfinclude template="../querys/program.cfm">

	<!--- Query of Queries --->
    <cfquery name="qGetProgramInfo" dbtype="query">
        SELECT 
            programName
        FROM 
			program
		WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.programID)#">
    </cfquery>
    
    <cfquery name="qGetHomeCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.home_country)#">
    </cfquery>

    <cfquery name="qGetBirthCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.birth_country)#">
    </cfquery>

    <cfquery name="qGetCitizenCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.citizen_country)#">
    </cfquery>

    <cfquery name="qGetResidenceCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			countrylist
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.citizen_country)#">
    </cfquery>

    <Cfquery name="qIntRepList" datasource="MySQL">
        SELECT 
        	userid, 
            firstname, 
            lastname,
            businessname,
            country
        FROM 
        	smg_users
        WHERE 
        	usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        AND 
        	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        ORDER BY 
        	businessname
    </Cfquery>
    
    <Cfquery name="qGetIntlRepInfo" datasource="MySQL">
        SELECT 
        	u.userid, 
            u.businessname, 
            u.extra_insurance_typeid,
            type.type
        FROM 
        	smg_users u
        LEFT JOIN 
        	smg_insurance_type type ON type.insutypeid = u.extra_insurance_typeid
        WHERE 
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.intrep#">
    </Cfquery>
    
    <Cfquery name="qCandidatePlacedCompany" datasource="MySQL">
        SELECT 
        	*
        FROM 
        	extra_candidate_place_company
        WHERE 
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.candidateID#">
        ORDER BY 
        	candCompID DESC
        LIMIT 1
    </Cfquery>

    <Cfquery name="qGetHostCompanyList" datasource="MySQL">
        SELECT 
        	name, 
            hostCompanyID
        FROM 
        	extra_hostcompany
        WHERE 
        	extra_hostcompany.companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="7">
        ORDER BY 
        	name
    </Cfquery>

    <Cfquery name="qGetHostCompanyInfo" dbtype="query">
        SELECT 
            name           
        FROM 
        	qGetHostCompanyList
        WHERE 
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.hostCompanyID#">
    </Cfquery>

    <cfquery name="qCheckNewCandidate" datasource="mysql">
        SELECT 
        	candidateID, 
            firstname, 
            lastname, 
            dob, 
            uniqueID, 
            smg_companies.companyshort
        FROM 
        	extra_candidates
        LEFT JOIN 
        	smg_companies on smg_companies.companyid = extra_candidates.companyid 
        WHERE 
        	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_candidate_unqID.firstname#"> 
        AND	
        	lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_candidate_unqID.lastname#">
        AND 
        	DOB = <cfqueryparam cfsqltype="cf_sql_date" value="#get_candidate_unqID.dob#">
        AND 
        	candidateID != <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.candidateID#">
    </cfquery>

    <cfquery name="qGetExtraJobs" datasource="mysql">
        SELECT 
        	id, 
            title, 
            extra_jobs.hostCompanyID, 
            wage, 
            low_wage, 
            wage_type, 
            hours, 
            extra_hostcompany.name
        FROM 
        	extra_jobs
        INNER JOIN 
        	extra_hostcompany ON extra_hostcompany.hostCompanyID = extra_jobs.hostCompanyID
        INNER JOIN 
        	extra_candidate_place_company ON extra_candidate_place_company.jobid = extra_jobs.id
        WHERE 
        	status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND 
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.candidateID#">
    </cfquery>

    <cfquery name="getCategory" datasource="MySql">
        SELECT DISTINCT 
        	fieldstudy
        FROM 
        	extra_sevis_fieldstudy
        WHERE 
        	fieldstudyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.fieldstudyid)#">
    </cfquery>

    <cfquery name="getSubCategory" datasource="MySql">
        SELECT DISTINCT 
        	subfield
        FROM 
        	extra_sevis_sub_fieldstudy
        WHERE 
        	subfieldid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(get_candidate_unqID.subfieldid)#">
    </cfquery>

    <cfquery name="qDepartureInfo" datasource="mysql">
        SELECT 
			*
        FROM
        	extra_flight_info
        WHERE
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.candidateID#"> 
        AND
        	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
		ORDER BY
        	dep_date DESC            
    </cfquery>
    
    <cfquery name="qArrivalInfo" datasource="mysql">
        SELECT 
        	*
        FROM 
        	extra_flight_info
        WHERE	
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqID.candidateID#">  
        AND
        	flight_type = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
		ORDER BY
        	dep_date DESC            
    </cfquery>

</cfsilent>    

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate Info</title>

<cfif NOT LEN(URL.uniqueID)>
	<cfinclude template="../error_message.cfm">
	<cfabort>
</cfif>

<style type="text/css">
<!-- 
	.editPage { display:none;}
-->
</style>

<!--// load the Client/Server Gateway API //-->
<script src="./candidate/lib/gateway.js"></script> 	

<!--// load the Client/Server Gateway API //-->
<script src="./candidate/lib/functions.js"></script> 	

<script language="JavaScript"> 
	$(document).ready(function() {
		$(".formField").attr("disabled","disabled");
	});
	
	function readOnlyEditPage() {
		if( $(".readOnly").css("display") == "none" ) {			
			// Hide editPage and display readOnly
			$(".editPage").fadeOut("fast");
			$(".readOnly").fadeIn("slow");
			$(".formField").attr("disabled","disabled");
		} else {
			// Hide readOnly and display editPage
			$(".readOnly").fadeOut("fast");
			$(".editPage").fadeIn("slow");	
			$(".formField").removeAttr("disabled");
		}
	}
	
	function populateDate(dateValue) {
		if (document.getElementById('ds2019Check').checked == true) {
			document.getElementById('verification_received').value = dateValue;
		} else {
			document.getElementById('verification_received').value = '';
		}
	}

	//open window
	function openWindow(url, height, width) {
		newWindow=window.open(url, "NewWindow", "width=" + width + ",height=" + height +", location=no, scrollbars=yes, menubar=yes, toolbars=no, resizable=yes"); 
		if (window.focus) {
			newWindow.focus();
		}
	}

	function displayProgramReason(currentProgramID, selectedProgramID) {
		if ( currentProgramID > '0' && currentProgramID != selectedProgramID && $("#program_history").css("display") == "none" ) {
			$("#program_history").fadeIn("slow");
			$("#reason").focus();
		} else if (currentProgramID == selectedProgramID) {
			$("#program_history").fadeOut("slow");
		}
	}

	function displayHostReason(currentHostPlaceID, selectedHostID) {
		if ( currentHostPlaceID > '0' && currentHostPlaceID != selectedHostID && $("#host_history").css("display") == "none" ) {
			$("#host_history").fadeIn("slow");
			$("#reason_host").focus();
		} else if (currentHostPlaceID == selectedHostID) {
			$("#host_history").fadeOut("slow");
		}
	}

	function displayCancelation(selectedValue) {
		if (selectedValue == 'canceled') {
			$("#divCancelation").fadeIn("slow");
		} else {
			$("#divCancelation").fadeOut("slow");
		}
	}
	
	// Check History
	function checkHistory(currentprogram, currenthost) {
		// PROGRAM HISTORY
		if( $("#program_history").css("display") != "none" && $("#reason").val() == '' ){
			alert("In order to change the program you must enter a reason (for history purpose).");
			$("#reason").focus();
			return false; 
		}
		
		// HOST HISTORY
		if( $("#host_history").css("display") != "none" && $("#reason_host").val() == '' ){
			alert("In order to change the host company you must enter a reason (for history purpose).");
			$("#reason_host").focus();
			return false; 
		}
	}
	//-->
</script> 

</head>

<cfoutput>

<body onLoad="init(#VAL(get_candidate_unqID.subfieldid)#, #VAL(qCandidatePlacedCompany.jobid)#);">

<!--- candidate does not exist --->
<cfif NOT VAL(get_candidate_unqID.recordcount)>
	The candidate ID you are looking for, <cfoutput>#url.candidateID#</cfoutput>, was not found. This could be for a number of reasons.<br><br>
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access rights to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##f4f4f4">
	<tr>
		<td bordercolor="##FFFFFF">

			<!----Header Table---->
			<table width=95% cellpadding=0 cellspacing="0" border="0" align="center" height="25" bgcolor="##E4E4E4">
				<tr bgcolor="##E4E4E4">
					<td class="title1">&nbsp; &nbsp; Candidate Information </td>
				</tr>
			</table>
			<br>

			<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate" onsubmit="return checkHistory(#VAL(get_candidate_unqID.programid)#, #VAL(qCandidatePlacedCompany.hostCompanyID)#);">
			<input type="hidden" name="candidateID" value="#get_candidate_unqID.candidateID#">
			<input type="hidden" name="uniqueID" value="#get_candidate_unqID.uniqueID#">
			<input type="hidden" name="candCompID" value="#qCandidatePlacedCompany.candCompID#">
            
			<table width="770" border="1" align="center" cellpadding=8 cellspacing=8 bordercolor="##C7CFDC" bgcolor="##ffffff">	
				<tr>
					<td valign="top" width="770" class="box">
					
						<table width="100%" align="Center" cellpadding="2">				
							<tr>
								<td width="135">
								
									<table width="100%" cellpadding="2">
										<tr>
											<td width="135" valign="top">			
												<cfif '#FileExists("/var/www/html/student-management/extra/internal/uploadedfiles/web-candidates/#get_candidate_unqID.candidateID#.#get_candidate_unqID.picture_type#")#'>
													<img src="../uploadedfiles/web-candidates/#get_candidate_unqID.candidateID#.#get_candidate_unqID.picture_type#" width="135" /><br>
													<a  class="style4Big" href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueID=#uniqueID#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><b><center>Change Picture</center></b></a>
												<cfelse>
													<a class=nav_bar href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueID=#get_candidate_unqID.uniqueID#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border="0"></a>
												</cfif>						
											</td>
										</tr>
									</table>
									
								</td>
								<td valign="top">
                            		
                                    <!--- Read Only --->
                                    <table width="100%" cellpadding="2" class="readOnly">
                                        <tr>
                                            <td align="center" colspan="2" class="title1">#get_candidate_unqID.firstname# #get_candidate_unqID.middlename# #get_candidate_unqID.lastname# (###get_candidate_unqID.candidateID#)</td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2"><span class="style4">[ <a href='candidate/candidate_profile.cfm?uniqueID=#get_candidate_unqID.uniqueID#' target="_blank"><span class="style4">profile</span></a> ]</span></td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2" class="style1"><cfif get_candidate_unqID.dob EQ ''>n/a<cfelse>#dateformat (get_candidate_unqID.dob, 'mm/dd/yyyy')# - #datediff('yyyy',get_candidate_unqID.dob,now())# year old</cfif> - <cfif get_candidate_unqID.sex EQ 'm'>Male<cfelse>Female</cfif></td>
                                        </tr> 
                                        <tr>
                                            <td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
    		                                <td width="82%" class="style1">#qGetIntlRepInfo.businessName#</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Date of Entry: </b></td>
                                            <td class="style1">#DateFormat(get_candidate_unqID.entrydate, 'mm/dd/yyyy')#</td>
                                        </tr>
                                        <tr>
                                            <td align="right">&nbsp;</td>
                                            <td class="style1">Candidate is <b><cfif get_candidate_unqID.status EQ 1>ACTIVE <cfelseif get_candidate_unqID.status EQ 0>INACTIVE <cfelseif get_candidate_unqID.status EQ 'canceled'>CANCELED</cfif> </b></td>
                                        </tr>													
                                    </table>
                                
                                    <!--- Edit Page --->
                                    <table width="100%" cellpadding="2" class="editPage">
                                        <tr>
                                            <td align="right" class="style1"><b>First Name:</b></td>
                                            <td><cfinput type="text" name="firstname" class="style1" size=32 value="#get_candidate_unqID.firstname#" maxlength="200" required="yes"></td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Middle Name:</b> </td>
                                            <td><cfinput type="text" name="middlename" class="style1" size=32 value="#get_candidate_unqID.middlename#" maxlength="200"></td>
                                        <tr>
                                            <td align="right" class="style1"><b>Last Name:</b> </td>
                                            <td><cfinput type="text" name="lastname" class="style1" size=32 value="#get_candidate_unqID.lastname#" maxlength="200" required="yes"></td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="style1"><b>Date of Birth:</b></td>
                                            <td class="style1">
                                            	<cfinput type="text" name="dob" class="style1" size=12 value="#dateformat (get_candidate_unqID.dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)" required="yes">
                                            	&nbsp; 
                                                <b>Sex:</b> 
                                                <input type="radio" name="sex" value="M" required="yes" message="You must specify the candidate's sex." <cfif get_candidate_unqID.sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
                                                <input type="radio" name="sex" value="F" required="yes" message="You must specify the candidate's sex." <cfif get_candidate_unqID.sex Eq 'F'>checked="checked"</cfif>>Female 
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
                                            <td width="82%" class="style1">
                                            	<select name="intrep" class="style1">
                                                    <option value="0"></option>		
                                                    <cfloop query="qIntRepList">
                                                        <option value="#userid#" <cfif userid EQ get_candidate_unqID.intrep> selected </cfif>><cfif #len(qIntRepList.businessname)# gt 45>#Left(qIntRepList.businessname, 42)#...<cfelse>#qIntRepList.businessname#</cfif></option>
                                                    </cfloop>
                                                </select>
                                          </td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Date of Entry: </b></td>
                                            <td class="style1">#DateFormat(get_candidate_unqID.entrydate, 'mm/dd/yyyy')#</td>
                                        </tr>												
                                        <tr>
                                            <td align="right" class="style1"><b>Status: </b> <!---- <input type="checkbox" name="active" <cfif active EQ 1>checked="Yes"</cfif> > ----></td>
                                            <td class="style1"><select id="status" name="status" <cfif get_candidate_unqID.status NEq 'canceled'> onchange="javascript:displayCancelation(this.value);" </cfif> >
                                                <option value="1" <cfif get_candidate_unqID.status EQ 1>selected="selected"</cfif>>Active</option>
                                                <option value="0" <cfif get_candidate_unqID.status EQ 0>selected="selected"</cfif>>Inactive</option>
                                                <option value="canceled" <cfif get_candidate_unqID.status Eq 'canceled'>selected="selected"</cfif>>Canceled</option>
                                              </select>
                                            </td>
                                        </tr>													
                                    </table>
																	
								</td>
							</tr>
					  </table>
						
					</td>	
				</tr>
			</table>
			
			<br>
        
            <cfif qCheckNewCandidate.recordcount gt 0>
                <table width="770" border="0" cellpadding="0" cellspacing="0" align="center">	
                    <tr>
                        <td width="49%" valign="top">
                            <!--- Duplicate Check - Display link to other profile with W&T or Trainee --->
                            <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td colspan=5>
                                    	This candidate is also in the system as 
                                        <a href="?curdoc=candidate/candidate_info&uniqueID=#qCheckNewCandidate.uniqueID#">
                                        	#qCheckNewCandidate.firstname# #qCheckNewCandidate.lastname# (###qCheckNewCandidate.candidateID#)
                                        </a> with #qCheckNewCandidate.companyshort#
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br>
            </cfif>

            <table width="770" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <td width="49%" valign="top">
                    
                        <!--- PERSONAL INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" width="100px" align="right"><b>Place of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#get_candidate_unqID.birth_city#</span>
                                                <input type="text" class="style1 editPage" name="birth_city" size=32 value="#get_candidate_unqID.birth_city#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>Country of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetBirthCountry.countryName#</span>
                                                <select name="birth_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.birth_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>C. of Citizenship:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetCitizenCountry.countryName#</span>
                                                <select name="citizen_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.citizen_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>C. Perm. Resid.:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetResidenceCountry.countryName#</span>
                                                <select name="residence_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.residence_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
                                                    </cfloop>
                                                </select>			
                                            </td>
                                        </tr>
                                        <tr>				
                                            <td class="style1" bordercolor="##FFFFFF" colspan="2">
            
                                                <table width="100%" cellpadding=1 cellspacing=2 border="1" bordercolor="##C7CFDC" bgcolor="F7F7F7">
                                                    <tr bordercolor="F7F7F7">
                                                        <td colspan="4" class="style1">
                                                        	<b>Mailing Address:</b> 
															<span class="readOnly">#get_candidate_unqID.home_address#</span>
                                                            <input type="text" class="style1 editPage" name="home_address" size=49 value="#get_candidate_unqID.home_address#" maxlength="200">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>City:</b></td>
                                                        <td class="style1">
															<span class="readOnly">#get_candidate_unqID.home_city#</span>
                                                            <input type="text" class="style1 editPage" name="home_city" size=11 value="#get_candidate_unqID.home_city#" maxlength="100">
                                                        </td>
                                                        <td class="style1" align="right"><b>Zip:</b></td>
                                                        <td class="style1">
                                                        	<span class="readOnly">#get_candidate_unqID.home_zip#</span>
                                                            <input type="text" class="style1 editPage" name="home_zip" size=11 value="#get_candidate_unqID.home_zip#" maxlength="15">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Country:</b></td>
                                                        <td colspan="3" class="style1">                                                        
                                                            <span class="readOnly">#qGetHomeCountry.countryName#</span>
                                                            <select name="home_country" class="style1 editPage">
                                                                <option value="0"></option>		
                                                                <cfloop query="countrylist">
                                                                    <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.home_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
                                                                </cfloop>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Phone:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#get_candidate_unqID.home_phone#</span>
                                                            <input type="text" class="style1 editPage" name="home_phone" size=38 value="#get_candidate_unqID.home_phone#" maxlength="50">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Email:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#get_candidate_unqID.email#</span>
                                                            <input type="text" class="style1 editPage" name="email" size=38 value="#get_candidate_unqID.email#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                </table>
                                            
                                            </td>					
                                        </tr>
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Degree Information</td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="top" class="style1"><b>Degree:</b></td>
                                            <td class="style1">
												<span class="readOnly">#get_candidate_unqID.degree#</span>
                                                <input type="text" class="style1 editPage" name="degree" size=34 value="#get_candidate_unqID.degree#" maxlength="200">                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><b>Other Degree:</b></td>
                                            <td class="style1">
                                                 <span class="readOnly">
                                                     <cfif NOT LEN(get_candidate_unqID.degree_other)> 
                                                          n/a 
                                                     <cfelse>
                                                          #get_candidate_unqID.degree_other#
                                                     </cfif>
                                                 </span>
                                                 <input type="text" class="style1 editPage" name="degree_other" size=34 value="#get_candidate_unqID.degree_other#" maxlength="200">
                                            </td>
                                        </tr>
                                    </table>
                                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br>
                        
                        <!--- EMERGENCY CONTACT --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
                                        </tr>
                                        <tr>
                                            <td width="15%" class="style1" align="right"><b>Name:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqID.emergency_name#</span>
                                                <input type="text" class="style1 editPage" name="emergency_name" size=32 value="#get_candidate_unqID.emergency_name#" maxlength="200">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Phone:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqID.emergency_phone#</span>
                                                <input type="text" class="style1 editPage" name="emergency_phone" size=32 value="#get_candidate_unqID.emergency_phone#" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Relationship:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqID.emergency_relationship#</span>
                                                <input type="text" class="style1 editPage" name="emergency_relationship" size=32 value="#get_candidate_unqID.emergency_relationship#" maxlength="50">
                                            </td>
                                        </tr>
                                    </table>	
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br>
                        
                        <!--- LETTERS --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Letters</td>
                                        </tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/enrollment_confirmation.cfm?uniqueID=#get_candidate_unqID.uniqueID#' class="style4Big", target="_blank"><b>Enrollment Confirmation</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/SevisFeeLetter.cfm?uniqueID=#get_candidate_unqID.uniqueID#' class="style4Big", target="_blank"><b>Sevis Fee Instruction Letter</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/SponsorLetter.cfm?uniqueID=#get_candidate_unqID.uniqueID#' class="style4Big", target="_blank"><b>Sponsorship Letter</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/VisaAppInst.cfm?uniqueID=#get_candidate_unqID.uniqueID#' class="style4Big", target="_blank"><b>Visa Application Instructions</b></a></td></tr>
                                    </table>	
                                </td>
                            </tr>
                        </table>
                        
                        <br>
                
                        
                        <!---DOCUMENTS CONTROL --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
                                        </tr>
                                        <tr>
                                            <td width="46%" class="style1" colspan="2">
                                                <input type="checkbox" name="doc_application" id="doc_application" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_application)> checked </cfif> > 
                                                <label for="doc_application">Application</label>
                                            </td>
                                            <td width="54%" class="style1" colspan="2">
												<input type="checkbox" name="doc_passportphoto" id="doc_passportphoto" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_passportphoto)> checked </cfif> >
												<label for="doc_passportphoto">Passport Photocopy</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_resume" id="doc_resume" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_resume)> checked </cfif> >												
												<label for="doc_resume">Resume</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_insu" id="doc_insu" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_insu)> checked </cfif> >
												<label for="doc_insu">Medical Insurance Appl.</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_proficiency" id="doc_proficiency" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_proficiency)> checked </cfif> >												
												<label for="doc_proficiency">Proficiency Verification</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_sponsor_letter" id="doc_sponsor_letter" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_sponsor_letter)> checked </cfif> >
												<label for="doc_sponsor_letter">Home Sponsor Letter</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="4">
												<input type="checkbox" name="doc_recom_letter" id="doc_recom_letter" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.doc_recom_letter)> checked </cfif> >
                                                <label for="doc_recom_letter">Letters of Recommendation</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1"> Missing Documents:</td>
                                            <td class="style1" colspan="3">
												<span class="readOnly">
                                                	#get_candidate_unqID.missing_documents#
                                                </span>
                                                <textarea name="missing_documents" class="style1 editPage" cols="25" rows="3">#get_candidate_unqID.missing_documents#</textarea>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>
                            </tr>
                        </table>
                        
                    </td>
                    
                    <td width="2%" valign="top">&nbsp;</td>
                    
                    <td width="49%" valign="top">
                    
                    	<!--- CANCELATION --->
                    	<div id="divCancelation" <cfif get_candidate_unqID.status NEQ 'canceled'> style="display:none;" </cfif> >
                            <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
                                    
                                        <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                            <tr bgcolor="##C2D1EF">
                                                <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
                                            </tr>
                                            <tr>
                                                <td class="style1" bordercolor="##FFFFFF" align="right" valign="top"><b>Date:</b></td>
                                                <td class="style1" width="85%">
                                                	<span class="readOnly">
                                                    	#DateFormat(get_candidate_unqID.cancel_date, 'mm/dd/yyyy')#
                                                    </span>
                                                    <input type="text" class="style1 date-pick" name="cancel_date" size=20 value="#DateFormat(get_candidate_unqID.cancel_date, 'mm/dd/yyyy')#" maxlength="10">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" bordercolor="##FFFFFF" align="right" valign="top"><b>Reason:</b></td>
                                                <td class="style1">
                                                	<span class="readOnly">#get_candidate_unqID.cancel_reason#</span>
                                                    <input type="text" class="style1 editPage" name="cancel_reason" size=40 value="#get_candidate_unqID.cancel_reason#">
                                                </td>								
                                            </tr>
                                        </table>
                                        
                                    </td>
                                </tr>
                            </table>                        
                            <br>
                        </div>
                        
                        <!--- HOST COMPANY INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF" valign="top">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Host Company Information [<a href="javascript:openWindow('candidate/candidate_host_history.cfm?unqid=#uniqueID#', 400, 750);"><font class="style3" color="FFFFFF"> History </font></a>]</span></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" width="100px"><b>Company Name:</b></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetHostCompanyInfo.name#</span>
                                                <select name="hostCompanyID" id="hostCompanyID" class="style1 editPage" onChange="displayHostReason(#VAL(qCandidatePlacedCompany.hostCompanyID)#, this.value); loadOptionsHostPosition('jobID');">
                                                    <cfloop query="qGetHostCompanyList">
                                                        <option value="#hostCompanyID#" <cfif qGetHostCompanyList.hostCompanyID EQ qCandidatePlacedCompany.hostCompanyID> selected </cfif> >
                                                            <cfif len(name) gt 35>
                                                                #Left(name, 32)#...
                                                            <cfelse>
                                                                #name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="host_history" bgcolor="FFBD9D" style="display:none;">
                                            <td class="style1" align="right"><b>Reason:</b></td>
                                            <td class="style1"><input name="reason_host" id="reason_host" type="text" class="style1" size="40"></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Position:</b> </td>
                                            <td class="style1">
                                                <span class="readOnly">
                                                    #qGetExtraJobs.title# 
                                                </span>
                                                <select name="jobID" class="style1 editPage">
                                                    <option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                 </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Start Date:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	#dateformat (qCandidatePlacedCompany.startdate, 'mm/dd/yyyy')#
                                                 </span>
                                                 <input type="text" name="host_startdate" class="style1 editPage" size=30 value="#dateformat (qCandidatePlacedCompany.startdate, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>End Date:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	#dateformat (qCandidatePlacedCompany.enddate, 'mm/dd/yyyy')#
                                                </span>    
                                                <input type="text" name="host_enddate" class="style1 editPage" size=30 value="#dateformat (qCandidatePlacedCompany.enddate, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        
                                    </table>	
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br>
                        
                        <!--- PROGRAM INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td class="style2" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;  [<a href="javascript:openWindow('candidate/candidate_program_history.cfm?unqid=#uniqueID#', 400, 600);"><font class="style3" color="FFFFFF"> History </font></a>]</span></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right" width="27%"><b>Program:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF" width="73%" colspan="3">
												<span class="readOnly">#qGetProgramInfo.programName#</span>                                                                                                	
                                                <select name="programid" class="style1 editPage" onChange="displayProgramReason(#VAL(get_candidate_unqID.programid)#, this.value);">
                                                    <option value="0">Unassigned</option>
                                                    <cfloop query="program">
														<cfif get_candidate_unqID.programid EQ programid>
                                                            <option value="#programid#" selected>#programname#</option>
                                                        <cfelse>
                                                            <option value="#programid#">#programname#</option>
                                                        </cfif>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="program_history" bgcolor="FFBD9D" style="display:none;">
                                            <td class="style1" align="right"><b>Reason:</b></td>
                                            <td class="style1" colspan="3"><input name="reason" id="reason" type="text" class="style1" size="40"></td>
                                        </tr>                                        
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>Arrival Date:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF" colspan="3">
												<span class="readOnly">#dateformat(get_candidate_unqID.arrivaldate, 'mm/dd/yyyy')#</span>
                                                <cfinput type="text" class="style1 editPage" name="arrivaldate" size=35 value="#dateformat(get_candidate_unqID.arrivaldate, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Arrival Date(MM/DD/YYYY)">
                                            </td>
                                        </tr>	
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>Remarks:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF" colspan="3">
												<span class="readOnly">#get_candidate_unqID.remarks#</span>
                                                <textarea name="remarks" class="style1 editPage" cols="25" rows="3">#get_candidate_unqID.remarks#</textarea>
                                            </td>
                                        </tr>	
                                    </table>
                                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br>
                                        
                        <!----DS2019 Form---->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
                                        </tr>	
                                        
                                        <!--- Verification Received --->
                                        <tr>
                                            <td class="style1" align="right" width="80px">
                                                <strong> <label for="ds2019Check"> Verific. Rcvd. </label> </strong>
                                            </td>                                            
                                            <td class="style1" colspan="3">
												<input type="checkbox" name="ds2019Check" id="ds2019Check" value="1" class="formField" onClick="populateDate('#DateFormat(now(), 'mm/dd/yyyy')#');" disabled <cfif LEN(get_candidate_unqID.verification_received)>checked="checked"</cfif> >                                                
                                                
                                                &nbsp; 
                                                
                                                <strong> <label for="verification_received"> Date: </label> </strong>
                                                
                                                &nbsp; 
                                                
                                                <span class="readOnly">#DateFormat(get_candidate_unqID.verification_received, 'mm/dd/yyyy')#</span>                                                
                                                <input type="text" class="style1 editPage" name="verification_received" id="verification_received" value="#DateFormat(get_candidate_unqID.verification_received, 'mm/dd/yyyy')#" maxlength="100">                                              
                                            </td>
                                        </tr>
                                        <!--- End of Verification Received --->			
                                        
                                        <tr>	
                                            <td align="right" class="style1"><b>No.:</b></td>
                                            <td class="style1" colspan="3">
                                            	<span class="readOnly">#get_candidate_unqID.ds2019#</span>
                                                <input type="text" class="style1 editPage" name="ds2019" size="15" value="#get_candidate_unqID.ds2019#" maxlength="100">
                                            </td>
                                        </tr>
                                        
                                        <tr>
                                            <td class="style1" valign="top" align="right"><b>Category:</b></td>
                                            <td class="style1" colspan=4>
                                                <span class="readOnly">
                                                    <cfif 'getCategory.recordcount' eq 0>
                                                    	n/a 
                                                    <cfelse>
                                                    	#getCategory.fieldstudy# 
                                                    </cfif>
                                                </span>
                                                <select name="fieldstudyid" class="style1 editPage" onChange="loadOptionsSubCat('listSubCat');">
                                                    <option value="0">Select...</option>
                                                    <cfloop query="fieldstudy">
                                                        <option value="#fieldstudyid#" <cfif fieldstudyid EQ get_candidate_unqID.fieldstudyid>selected</cfif>><cfif len(fieldstudy) GT 35>#Left(fieldstudy,30)#...<cfelse>#fieldstudy#</cfif></option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                          <td class="style1" valign="top" align="right"><b>Sub Category:</b></td>
                                            <td class="style1" colspan=4>
                                                <span class="readOnly">
                                                    <cfif 'getSubCategory' eq 0>
                                                    	n/a 
                                                    <cfelse>
                                                    	#getSubCategory.subfield#
                                                	</cfif>
                                                </span>
                                                <select name="listSubCat" class="style1 editPage">
                                                    <option> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                    <option></option><option></option><option></option><option></option><option></option><option></option>
                                                 </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Street:</b></td>
                                            <td colspan="3" class="style1">
                                            	<span class="readOnly">#get_candidate_unqID.ds2019_street#</span>
                                                <input type="text" class="style1 editPage" type="text" name="ds2019_street" size=50 value="#get_candidate_unqID.ds2019_street#" maxlength="150">
                                            </td>
                                        </tr>
                                        <tr>
                                          	<td class="style1" align="right"><b>City:</b></td>
                                          	<td class="style1">
										  		<span class="readOnly">#get_candidate_unqID.ds2019_city#</span>
                                          		<input class="style1 editPage" type="text" name="ds2019_city" size=20 value="#get_candidate_unqID.ds2019_city#" maxlength="100">
                                        	</td>
                                            <td align="right" class="style1"><b>Zip:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqID.ds2019_zip#</span>
                                                <input type="text" class="style1 editPage" name="ds2019_zip" size=12 value="#get_candidate_unqID.ds2019_zip#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>State:</b></td>
                                            <td class="style1">
                                              <span class="readOnly">#get_candidate_unqID.ds2019_state#</span>                                            
                                              <input type="text" class="style1 editPage" name="ds2019_state" size=12 value="#get_candidate_unqID.ds2019_state#" maxlength="12">
                                            </td>
                                            <td align="right" class="style1">&nbsp;</td>
                                            <td class="style1">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Home Phone:</b></td>
                                            <td class="style1">
                                              <span class="readOnly">#get_candidate_unqID.ds2019_phone#</span>
                                              <input type="text" class="style1 editPage" name="ds2019_phone" size=20 value="#get_candidate_unqID.ds2019_phone#" maxlength="12">
                                            </td>
                                            <td align="right" class="style1"><b>Cell.:</b></td>
                                            <td class="style1">
                                              <span class="readOnly">#get_candidate_unqID.ds2019_cell#</span>
                                              <input type="text" class="style1 editPage" name="ds2019_cell" size=20 value="#get_candidate_unqID.ds2019_cell#" maxlength="12">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Start:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(get_candidate_unqID.ds2019_startdate, 'mm/dd/yyyy')#</span>
                                                <cfinput type="text" class="style1 editPage" name="ds2019_startdate" size=20 value="#DateFormat(get_candidate_unqID.ds2019_startdate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 Start Date (MM/DD/YYYY)">
                                            </td>
                                            <td class="style1" align="right"><b>End:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(get_candidate_unqID.ds2019_enddate, 'mm/dd/yyyy')#</span>
                                            	<cfinput type="text" class="style1 editPage" name="ds2019_enddate" size=20 value="#DateFormat(get_candidate_unqID.ds2019_enddate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 End Date(MM/DD/YYYY)">
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>	
                            </tr>
                        </table>
                        
                        <br> 
                       
                        <!--- INSURANCE INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">		
                                    
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Insurance &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; [<a href="javascript:openWindow('insurance/insurance_mgmt.cfm?uniqueID=#uniqueID#', 500, 800);"><font class="style2" color="FFFFFF">Insurance Management</font></a>]</td>
                                        </tr>
                                        <tr>
                                          	<td width="2%">
                                                <input type="checkbox" name="insurance_check" disabled <cfif qGetIntlRepInfo.extra_insurance_typeid GT 1> checked </cfif> >
                                          	</td>
                                            <td width="30%" class="style1" align="right"><b>Policy Type:</b></td>
                                            <td width="68%" class="style1">
												<cfif qGetIntlRepInfo.extra_insurance_typeid EQ 0>
                                                	<font color="FF0000">Missing Policy Type</font>
                                                <cfelse>
                                                	#qGetIntlRepInfo.type#
                                             	</cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="insurance_date" disabled <cfif LEN(get_candidate_unqID.insurance_date)> checked </cfif>>
                                            </td>
                                            <td class="style1" align="right"><b>Filed Date:</b></td>
                                            <td class="style1">
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid GT '1' AND get_candidate_unqID.insurance_date EQ ''>
                                                    not insured yet
                                                <cfelseif get_candidate_unqID.insurance_date NEQ ''>
                                                    #DateFormat(get_candidate_unqID.insurance_date, 'mm/dd/yyyy')#
                                                <cfelse>
                                                    n/a
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="insurance_Cancel" disabled="disabled" <cfif LEN(get_candidate_unqID.insurance_cancel_date)> checked </cfif> >
                                            </td>
                                            <td class="style1" align="right"><b>Cancel Date:</b></td>
                                            <td class="style1">#DateFormat(get_candidate_unqID.insurance_cancel_date, 'mm/dd/yyyy')#</td>
                                        </tr>
                                    </table>
                                    
                                </td>	
                            </tr>
                        </table>
                        
                        <br>
                        
                        <!--- FLIGHT INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Flight Info</td>
                                        </tr>	
                                        <tr>
                                            <td class="style1">Depart Home</td><td class="style1"><cfif LEN(qDepartureInfo.dep_date)>#DateFormat(qDepartureInfo.dep_date, 'mm/dd/yyyy')#<cfelse>No Flights on Record</cfif> </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">Depart US</td><td class="style1"><cfif LEN(qArrivalInfo.dep_date)>#DateFormat(qArrivalInfo.dep_date, 'mm/dd/yyyy')#<cfelse>No Flights on Record</cfif></td>
                                        </tr>
                                        <tr>
                                            <Td align="Center" colspan=2 class="style1"><a href="" onClick="javascript: win=window.open('flight_info/flight_info.cfm?candidateID=#get_candidate_unqID.candidateID#', 'Settings', 'height=500, width=740, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;">View / Edit  Itinerary</A></Td>
                                        </tr>
                                    </table>
                                </td>	
                            </tr>
                        </table>
                        
                    </td>	
                </tr>
            </table>
            
            <br>
                    
			<!---- EDIT/UPDATE BUTTONS ---->
			<cfif client.usertype LTE 4>
				
                <table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="section">	
                    <tr>
                        <td align="center">
                            
                            <!---- EDIT BUTTON ---->
                            <div class="readOnly">                            
	                            <img src="../pics/edit.gif" onClick="readOnlyEditPage();">
                            </div>
                            
                            <!---- UPDATE BUTTON ----> 
                            <div class="editPage">                            
	                            <input name="Submit" type="image" src="../pics/update.gif" alt="Update Profile" border="0">
                            </div>
                            
                        </td>
                    </tr>
                </table>
                
                <br>
			</cfif>

            </cfform>

		</td>
	</tr>
</table>

<!--- Fire oGatewaySubCat --->
<script language="javascript">
	// place this on the page where you want the gateway to appear
	oGatewaySubCat.create();
	// Host Company Position
	oGatewayHostPosition.create();
</script>

</body>

</cfoutput>

</html>