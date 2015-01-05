<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate_info.cfm
	Author:		Marcus Melo
	Date:		October 07, 2009
	Desc:		Candidate Information Screen.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill extra output --->
<cfsilent>
	
    <!--- Param variables --->
	<cfparam name="URL.uniqueID" default="">

	<cfscript>
		// Get Candidate Information
		qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=URL.uniqueID);
		
		// Get Incident Report
		qGetIncidentReport = APPLICATION.CFC.CANDIDATE.getIncidentReport(candidateID=qGetCandidate.candidateID);

		// List of Countries
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();

		// List of Intl. Reps.
		qGetIntlRepList = APPLICATION.CFC.USER.getUsers(userType=8);
	</cfscript>

    <cfinclude template="../querys/fieldstudy.cfm">
    <cfinclude template="../querys/program.cfm">

	<!--- Query of Queries --->
    <cfquery name="qGetProgramInfo" dbtype="query">
        SELECT 
            programName
        FROM 
			program
		WHERE
        	programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.programID)#">
    </cfquery>
    
    <cfquery name="qGetHomeCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.home_country)#">
    </cfquery>

    <cfquery name="qGetBirthCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.birth_country)#">
    </cfquery>

    <cfquery name="qGetCitizenCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.citizen_country)#">
    </cfquery>

    <cfquery name="qGetResidenceCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.citizen_country)#">
    </cfquery>

    <Cfquery name="qGetIntlRepInfo" datasource="#APPLICATION.DSN.Source#">
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
        	u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.intrep#">
    </Cfquery>
    
    <Cfquery name="qCandidatePlacedCompany" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	*
        FROM 
        	extra_candidate_place_company
        WHERE 
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">
        ORDER BY 
        	candCompID DESC
        LIMIT 1
    </Cfquery>

    <Cfquery name="qGetHostCompanyList" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	name, 
            hostCompanyID,
            comments
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
        	hostCompanyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.hostCompanyID#">
    </Cfquery>

    <cfquery name="qCheckNewCandidate" datasource="#APPLICATION.DSN.Source#">
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
        	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidate.firstname#"> 
        AND	
        	lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#qGetCandidate.lastname#">
        AND 
        	DOB = <cfqueryparam cfsqltype="cf_sql_date" value="#qGetCandidate.dob#">
        AND 
        	candidateID != <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">
    </cfquery>

    <cfquery name="qGetExtraJobs" datasource="#APPLICATION.DSN.Source#">
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
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">
    </cfquery>

    <cfquery name="getCategory" datasource="#APPLICATION.DSN.Source#">
        SELECT DISTINCT 
        	fieldstudy
        FROM 
        	extra_sevis_fieldstudy
        WHERE 
        	fieldstudyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.fieldstudyid)#">
    </cfquery>

    <cfquery name="getSubCategory" datasource="#APPLICATION.DSN.Source#">
        SELECT DISTINCT 
        	subfield
        FROM 
        	extra_sevis_sub_fieldstudy
        WHERE 
        	subfieldid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.subfieldid)#">
    </cfquery>

    <cfquery name="qDepartureInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
			*
        FROM
        	extra_flight_information
        WHERE
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#"> 
        AND
        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrival">
		ORDER BY
        	departDate DESC            
    </cfquery>
    
    <cfquery name="qArrivalInfo" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	*
        FROM 
        	extra_flight_information
        WHERE	
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">  
        AND
        	flightType = <cfqueryparam cfsqltype="cf_sql_varchar" value="departure">
		ORDER BY
        	departDate DESC            
    </cfquery>
	
    <cfquery name="qGetQuarterlyEvaluation" datasource="#APPLICATION.DSN.Source#">
        SELECT 
        	candidateID,
            monthEvaluation,
            dateApproved
        FROM 
        	extra_evaluation
        WHERE	
        	candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.candidateID#">  
    </cfquery>

    <cfquery name="qGetFebQuarterlyEvaluation" dbtype="query">
        SELECT 
        	dateApproved
        FROM 
        	qGetQuarterlyEvaluation
        WHERE	
        	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="2">  
    </cfquery>

    <cfquery name="qGetMayQuarterlyEvaluation" dbtype="query">
        SELECT 
        	dateApproved
        FROM 
        	qGetQuarterlyEvaluation
        WHERE	
        	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="5">  
    </cfquery>

    <cfquery name="qGetAugQuarterlyEvaluation" dbtype="query">
        SELECT 
        	dateApproved
        FROM 
        	qGetQuarterlyEvaluation
        WHERE	
        	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="8">  
    </cfquery>

    <cfquery name="qGetNovQuarterlyEvaluation" dbtype="query">
        SELECT 
        	dateApproved
        FROM 
        	qGetQuarterlyEvaluation
        WHERE	
        	monthEvaluation = <cfqueryparam cfsqltype="cf_sql_integer" value="11">  
    </cfquery>
    
    <cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
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
		
		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:true,
			onClosed:function(){ window.location.reload(); }
		});
		
		// Pop Up Flight Information 
		$('.popUpFlightInformation').popupWindow({ 
			height:600, 
			width:1100,
			centerBrowser:1,
			scrollbars:1,
			resizable:1,
			windowName:'flightInformation'
		}); 
		
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
	
	function populateDate(dateValue, checkFieldID, fieldID) {
		if (document.getElementById(checkFieldID).checked == true) {
			$("#" + fieldID).val(dateValue);
		} else {
			$("#" + fieldID).val('');
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

<body onLoad="init(#VAL(qGetCandidate.subfieldid)#, #VAL(qCandidatePlacedCompany.jobid)#);">

<!--- candidate does not exist --->
<cfif NOT VAL(qGetCandidate.recordcount)>
	The candidate ID you are looking for was not found. This could be for a number of reasons.<br /><br />
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
			<br />

			<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate&uniqueid=#qGetCandidate.uniqueid#" onsubmit="return checkHistory(#VAL(qGetCandidate.programid)#, #VAL(qCandidatePlacedCompany.hostCompanyID)#);">
			<input type="hidden" name="candidateID" value="#qGetCandidate.candidateID#">
			<input type="hidden" name="uniqueID" value="#qGetCandidate.uniqueID#">
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
												<cfif '#FileExists('#expandPath("../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.#qGetCandidate.picture_type#")#')#'>
													<img src="../uploadedfiles/web-candidates/#qGetCandidate.candidateID#.#qGetCandidate.picture_type#" width="135" /><br />
													<a  class="style4Big" href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueID=#uniqueID#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><b><center>Change Picture</center></b></a>
												<cfelse>
													<a class=nav_bar href="" onClick="javascript: win=window.open('candidate/upload_picture.cfm?uniqueID=#qGetCandidate.uniqueID#', 'Settings', 'height=305, width=636, location=no, scrollbars=yes, menubars=no, toolbars=no, resizable=yes'); win.opener=self; return false;"><img src="../pics/no_logo.jpg" width="135" border="0"></a>
												</cfif>						
											</td>
										</tr>
									</table>
									
								</td>
								<td valign="top">
                            		
                                    <!--- Read Only --->
                                    <table width="100%" cellpadding="2" class="readOnly">
                                        <tr>
                                            <td align="center" colspan="2" class="title1">#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (###qGetCandidate.candidateID#)</td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2"><span class="style4">[ <a href='candidate/candidate_profile.cfm?uniqueID=#qGetCandidate.uniqueID#' target="_blank"><span class="style4">profile</span></a> ]</span></td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2" class="style1"><cfif qGetCandidate.dob EQ ''>n/a<cfelse>#dateformat(qGetCandidate.dob, 'mm/dd/yyyy')# - #datediff('yyyy',qGetCandidate.dob,now())# year old</cfif> - <cfif qGetCandidate.sex EQ 'm'>Male<cfelse>Female</cfif></td>
                                        </tr> 
                                        <tr>
                                            <td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
    		                                <td width="82%" class="style1">#qGetIntlRepInfo.businessName#</td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Date of Entry: </b></td>
                                            <td class="style1">#DateFormat(qGetCandidate.entrydate, 'mm/dd/yyyy')#</td>
                                        </tr>
                                        <tr>
                                            <td align="right">&nbsp;</td>
                                            <td class="style1">Candidate is <b><cfif qGetCandidate.status EQ 1>ACTIVE <cfelseif qGetCandidate.status EQ 0>INACTIVE <cfelseif qGetCandidate.status EQ 'canceled'>CANCELED</cfif> </b></td>
                                        </tr>													
                                    </table>
                                
                                    <!--- Edit Page --->
                                    <table width="100%" cellpadding="2" class="editPage">
                                        <tr>
                                            <td align="right" class="style1"><b>First Name:</b></td>
                                            <td><cfinput type="text" name="firstname" class="style1" size="32" value="#qGetCandidate.firstname#" maxlength="200" required="yes"></td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Middle Name:</b> </td>
                                            <td><cfinput type="text" name="middlename" class="style1" size="32" value="#qGetCandidate.middlename#" maxlength="200"></td>
                                        <tr>
                                            <td align="right" class="style1"><b>Last Name:</b> </td>
                                            <td><cfinput type="text" name="lastname" class="style1" size="32" value="#qGetCandidate.lastname#" maxlength="200" required="yes"></td>
                                        </tr>
                                        <tr>
                                            <td align="center" class="style1"><b>Date of Birth:</b></td>
                                            <td class="style1">
                                            	<cfinput type="text" name="dob" class="style1" size=12 value="#dateformat(qGetCandidate.dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)" required="yes">
                                            	&nbsp; 
                                                <b>Sex:</b> 
                                                <input type="radio" name="sex" value="M" required message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'M'>checked="checked"</cfif>>Male &nbsp; &nbsp;
                                                <input type="radio" name="sex" value="F" required message="You must specify the candidate's sex." <cfif qGetCandidate.sex Eq 'F'>checked="checked"</cfif>>Female 
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td width="18%" align="right" class="style1"><b>Intl. Rep.:</b></td>
                                            <td width="82%" class="style1">
                                            	<select name="intrep" class="style1">
                                                    <option value="0"></option>		
                                                    <cfloop query="qGetIntlRepList">
                                                        <option value="#userid#" <cfif userid EQ qGetCandidate.intrep> selected </cfif>><cfif #len(qGetIntlRepList.businessname)# gt 45>#Left(qGetIntlRepList.businessname, 42)#...<cfelse>#qGetIntlRepList.businessname#</cfif></option>
                                                    </cfloop>
                                                </select>
                                          </td>
                                        </tr>
                                        <tr>
                                            <td align="right" class="style1"><b>Date of Entry: </b></td>
                                            <td class="style1">#DateFormat(qGetCandidate.entrydate, 'mm/dd/yyyy')#</td>
                                        </tr>												
                                        <tr>
                                            <td align="right" class="style1"><b>Status: </b> <!---- <input type="checkbox" name="active" <cfif active EQ 1>checked="Yes"</cfif> > ----></td>
                                            <td class="style1"><select id="status" name="status" <cfif qGetCandidate.status NEq 'canceled'> onchange="javascript:displayCancelation(this.value);" </cfif> >
                                                <option value="1" <cfif qGetCandidate.status EQ 1>selected="selected"</cfif>>Active</option>
                                                <option value="0" <cfif qGetCandidate.status EQ 0>selected="selected"</cfif>>Inactive</option>
                                                <option value="canceled" <cfif qGetCandidate.status Eq 'canceled'>selected="selected"</cfif>>Canceled</option>
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
			
			<br />
        
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
                <br />
            </cfif>

            <table width="770" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <td width="49%" valign="top">
                    
                        <!--- PERSONAL INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" width="100px" align="right"><b>Place of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                            	<span class="readOnly">#qGetCandidate.birth_city#</span>
                                                <input type="text" class="style1 editPage" name="birth_city" size="32" value="#qGetCandidate.birth_city#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>Country of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetBirthCountry.countryName#</span>
                                                <select name="birth_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.birth_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
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
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.citizen_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
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
                                                    <cfloop query="qGetCountryList">
                                                        <option value="#countryid#" <cfif countryid EQ qGetCandidate.residence_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
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
															<span class="readOnly">#qGetCandidate.home_address#</span>
                                                            <input type="text" class="style1 editPage" name="home_address" size=49 value="#qGetCandidate.home_address#" maxlength="200">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>City:</b></td>
                                                        <td class="style1">
															<span class="readOnly">#qGetCandidate.home_city#</span>
                                                            <input type="text" class="style1 editPage" name="home_city" size=11 value="#qGetCandidate.home_city#" maxlength="100">
                                                        </td>
                                                        <td class="style1" align="right"><b>Zip:</b></td>
                                                        <td class="style1">
                                                        	<span class="readOnly">#qGetCandidate.home_zip#</span>
                                                            <input type="text" class="style1 editPage" name="home_zip" size=11 value="#qGetCandidate.home_zip#" maxlength="15">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Country:</b></td>
                                                        <td colspan="3" class="style1">                                                        
                                                            <span class="readOnly">#qGetHomeCountry.countryName#</span>
                                                            <select name="home_country" class="style1 editPage">
                                                                <option value="0"></option>		
                                                                <cfloop query="qGetCountryList">
                                                                    <option value="#countryid#" <cfif countryid EQ qGetCandidate.home_country> selected </cfif>><cfif #len(countryname)# gt 45>#Left(countryname, 42)#...<cfelse>#countryname#</cfif></option>
                                                                </cfloop>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Phone:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#qGetCandidate.home_phone#</span>
                                                            <input type="text" class="style1 editPage" name="home_phone" size=38 value="#qGetCandidate.home_phone#" maxlength="50">
                                                        </td>
                                                    </tr>
                                                    <tr bordercolor="F7F7F7">
                                                        <td class="style1" align="right"><b>Email:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#qGetCandidate.email#</span>
                                                            <input type="text" class="style1 editPage" name="email" size=38 value="#qGetCandidate.email#" maxlength="100">
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
												<span class="readOnly">#qGetCandidate.degree#</span>
                                                <input type="text" class="style1 editPage" name="degree" size=34 value="#qGetCandidate.degree#" maxlength="200">                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" valign="top"><b>Other Degree:</b></td>
                                            <td class="style1">
                                                 <span class="readOnly">
                                                     <cfif NOT LEN(qGetCandidate.degree_other)> 
                                                          n/a 
                                                     <cfelse>
                                                          #qGetCandidate.degree_other#
                                                     </cfif>
                                                 </span>
                                                 <input type="text" class="style1 editPage" name="degree_other" size=34 value="#qGetCandidate.degree_other#" maxlength="200">
                                            </td>
                                        </tr>
                                    </table>
                                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
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
                                            	<span class="readOnly">#qGetCandidate.emergency_name#</span>
                                                <input type="text" class="style1 editPage" name="emergency_name" size="32" value="#qGetCandidate.emergency_name#" maxlength="200">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Phone:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.emergency_phone#</span>
                                                <input type="text" class="style1 editPage" name="emergency_phone" size="32" value="#qGetCandidate.emergency_phone#" maxlength="50">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Relationship:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#qGetCandidate.emergency_relationship#</span>
                                                <input type="text" class="style1 editPage" name="emergency_relationship" size="32" value="#qGetCandidate.emergency_relationship#" maxlength="50">
                                            </td>
                                        </tr>
                                    </table>	
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
                        <!---DOCUMENTS CONTROL --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
                                        </tr>
                                        <tr>
                                            <td width="48%" class="style1" colspan="2">
                                                <input type="checkbox" name="doc_application" id="doc_application" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_application)> checked </cfif> > 
                                                <label for="doc_application">Application</label>
                                            </td>
                                            <td width="52%" class="style1" colspan="2">
												<input type="checkbox" name="doc_proficiency" id="doc_proficiency" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_proficiency)> checked </cfif> >
												<label for="doc_proficiency">Interview Report</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_insu" id="doc_insu" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_insu)> checked </cfif> >
												<label for="doc_insu">Medical Insurance App.</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_hostEmployerInformation" id="doc_hostEmployerInformation" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_hostEmployerInformation)> checked </cfif> >												
												<label for="doc_hostEmployerInformation">Host Employer Information</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_sponsor_letter" id="doc_sponsor_letter" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_sponsor_letter)> checked </cfif> >
												<label for="doc_sponsor_letter">Home Sponsor Letter</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_agreement" id="doc_agreement" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_agreement)> checked </cfif> >
												<label for="doc_agreement">Agreement</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="2">
												<input type="checkbox" name="doc_passportphoto" id="doc_passportphoto" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_passportphoto)> checked </cfif> >
												<label for="doc_passportphoto">Passport Copy</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_resume" id="doc_resume" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_resume)> checked </cfif> >												
												<label for="doc_resume">Resume</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="2">
												<input type="checkbox" name="doc_recom_letter" id="doc_recom_letter" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_recom_letter)> checked </cfif> >
                                                <label for="doc_recom_letter">Letters of Recommendation</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_degreeCopy" id="doc_degreeCopy" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_degreeCopy)> checked </cfif> >
                                                <label for="doc_degreeCopy">Degree/Certificate Copy</label>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="2">
												<input type="checkbox" name="doc_DS7002_applicant" id="doc_DS7002_applicant" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_DS7002_applicant)> checked </cfif> >												
												<label for="doc_DS7002_applicant">Form DS-7002 Applicant</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="doc_ISEInterviewReport" id="doc_ISEInterviewReport" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_ISEInterviewReport)> checked </cfif> >												
												<label for="doc_ISEInterviewReport">ISE Interview Report</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1"> Missing Documents:</td>
                                            <td class="style1" colspan="3">
												<span class="readOnly">
                                                	#qGetCandidate.missing_documents#
                                                </span>
                                                <textarea name="missing_documents" class="style1 editPage" cols="25" rows="3">#qGetCandidate.missing_documents#</textarea>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
                        <!--- LETTERS --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Letters</td>
                                        </tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/enrollment_confirmation.cfm?uniqueID=#qGetCandidate.uniqueID#' class="style4Big", target="_blank"><b>Enrollment Confirmation</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/SevisFeeLetter.cfm?uniqueID=#qGetCandidate.uniqueID#' class="style4Big", target="_blank"><b>Sevis Fee Instruction Letter</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/SponsorLetter.cfm?uniqueID=#qGetCandidate.uniqueID#' class="style4Big", target="_blank"><b>Sponsorship Letter</b></a></td></tr>
                                        <tr><td width="15%" class="style4" colspan="2" align="center"><a href='reports/VisaAppInst.cfm?uniqueID=#qGetCandidate.uniqueID#' class="style4Big", target="_blank"><b>Visa Application Instructions</b></a></td></tr>
                                    </table>	
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
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
                                                <select name="programid" class="style1 editPage" onChange="displayProgramReason(#VAL(qGetCandidate.programid)#, this.value);">
                                                    <option value="0">Unassigned</option>
                                                    <cfloop query="program">
														<cfif qGetCandidate.programid EQ programid>
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
                                            <td class="style1" bordercolor="##FFFFFF" align="right"><b>Remarks:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF" colspan="3">
												<span class="readOnly">#qGetCandidate.remarks#</span>
                                                <textarea name="remarks" class="style1 editPage" cols="25" rows="3">#qGetCandidate.remarks#</textarea>
                                            </td>
                                        </tr>	
                                    </table>
                                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
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
                                                <input type="checkbox" name="insurance_date" disabled <cfif LEN(qGetCandidate.insurance_date)> checked </cfif>>
                                            </td>
                                            <td class="style1" align="right"><b>Filed Date:</b></td>
                                            <td class="style1">
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid GT '1' AND qGetCandidate.insurance_date EQ ''>
                                                    not insured yet
                                                <cfelseif qGetCandidate.insurance_date NEQ ''>
                                                    #DateFormat(qGetCandidate.insurance_date, 'mm/dd/yyyy')#
                                                <cfelse>
                                                    n/a
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <input type="checkbox" name="insurance_Cancel" disabled="disabled" <cfif LEN(qGetCandidate.insurance_cancel_date)> checked </cfif> >
                                            </td>
                                            <td class="style1" align="right"><b>Cancel Date:</b></td>
                                            <td class="style1">#DateFormat(qGetCandidate.insurance_cancel_date, 'mm/dd/yyyy')#</td>
                                        </tr>
                                    </table>
                                    
                                </td>	
                            </tr>
                        </table>

                    </td>
                    
                    <td width="2%" valign="top">&nbsp;</td>
                    
                    <td width="49%" valign="top">
                    
                    	<!--- HOST COMPANY INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF" valign="top">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Host Company Information [<a href="javascript:openWindow('candidate/candidate_host_history.cfm?unqid=#uniqueID#', 400, 750);"><font class="style3" color="FFFFFF"> History </font></a>]</span></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" width="100px"><b>Company Name:</b></td>
                                            <td class="style1">
                                                <span class="readOnly">#qGetHostCompanyInfo.name#</span>
                                                <select name="hostCompanyID" id="hostCompanyID" class="style1 editPage" onChange="displayHostReason(#VAL(qCandidatePlacedCompany.hostCompanyID)#, this.value); loadOptionsHostPosition('jobID');">
                                                    <cfloop query="qGetHostCompanyList">
                                                        <option 
                                                        	value="#hostCompanyID#" 
															<cfif qGetHostCompanyList.hostCompanyID EQ qCandidatePlacedCompany.hostCompanyID> selected </cfif>
                                                            <cfif LEN(TRIM(comments))>style="color:red"</cfif> >
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
                                        	<td class="style1" align="right" width="100px"><b>Form DS-7002 Host Company:</b> </td>
                                        	<td class="style1">
												<input type="checkbox" name="doc_ds7002_hostCompany" id="doc_ds7002_hostCompany" value="1" class="formField" disabled <cfif VAL(qGetCandidate.doc_ds7002_hostCompany)> checked </cfif> >												
                                            </td>
                                      	</tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Start Date:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	#dateformat(qCandidatePlacedCompany.startdate, 'mm/dd/yyyy')#
                                                 </span>
                                                 <input type="text" name="host_startdate" class="style1 editPage" size=30 value="#dateformat(qCandidatePlacedCompany.startdate, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>End Date:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">
                                                	#dateformat(qCandidatePlacedCompany.enddate, 'mm/dd/yyyy')#
                                                </span>    
                                                <input type="text" name="host_enddate" class="style1 editPage" size=30 value="#dateformat(qCandidatePlacedCompany.enddate, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        
                                    </table>	
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
                        <!--- CANCELATION --->
                    	<div id="divCancelation" <cfif qGetCandidate.status NEQ 'canceled'> style="display:none;" </cfif> >
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
                                                    	#DateFormat(qGetCandidate.cancel_date, 'mm/dd/yyyy')#
                                                    </span>
                                                    <input type="text" class="style1 datePicker" name="cancel_date" size=20 value="#DateFormat(qGetCandidate.cancel_date, 'mm/dd/yyyy')#" maxlength="10">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" bordercolor="##FFFFFF" align="right" valign="top"><b>Reason:</b></td>
                                                <td class="style1">
                                                	<span class="readOnly">#qGetCandidate.cancel_reason#</span>
                                                    <input type="text" class="style1 editPage" name="cancel_reason" size=40 value="#qGetCandidate.cancel_reason#">
                                                </td>								
                                            </tr>
                                        </table>
                                        
                                    </td>
                                </tr>
                            </table>                        
                            <br />
                        </div>
                        
                        <!----DS2019 Form---->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
                                        </tr>	
                                        
                                        <!--- Verification Received --->
                                        <tr>
                                            <td class="style1" align="right" width="80px">
                                                <label for="ds2019Check"> <strong>  Verific. Rcvd. </strong> </label>
                                            </td>                                            
                                            <td class="style1" colspan="3">
												<input type="checkbox" name="ds2019Check" id="ds2019Check" value="1" class="formField" onClick="populateDate('#DateFormat(now(), 'mm/dd/yyyy')#', this.id, 'verification_received');" disabled <cfif isDate(qGetCandidate.verification_received)>checked="checked"</cfif> >                                                
                                                
                                                &nbsp; 
                                                
                                                <strong> <label for="verification_received"> Date: </label> </strong>
                                                
                                                &nbsp; 
                                                
                                                <span class="readOnly">#DateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')#</span>                                                
                                                <input type="text" name="verification_received" id="verification_received" class="style1 editPage datePicker" value="#DateFormat(qGetCandidate.verification_received, 'mm/dd/yyyy')#" maxlength="100">                                              
                                            </td>
                                        </tr>
                                        <!--- End of Verification Received --->			
                                        
                                        <tr>	
                                            <td align="right" class="style1"><b>No.:</b></td>
                                            <td class="style1" colspan="3">
                                            	<span class="readOnly">#qGetCandidate.ds2019#</span>
                                                <input type="text" class="style1 editPage" name="ds2019" size="15" value="#qGetCandidate.ds2019#" maxlength="100">
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
                                                        <option value="#fieldstudyid#" <cfif fieldstudyid EQ qGetCandidate.fieldstudyid>selected</cfif>><cfif len(fieldstudy) GT 35>#Left(fieldstudy,30)#...<cfelse>#fieldstudy#</cfif></option>
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
                                            <td class="style1" align="right"><b>Start:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.ds2019_startdate, 'mm/dd/yyyy')#</span>
                                                <cfinput type="text" class="style1 editPage" name="ds2019_startdate" size=20 value="#DateFormat(qGetCandidate.ds2019_startdate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 Start Date (MM/DD/YYYY)">
                                            </td>
                                            <td class="style1" align="right"><b>End:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.ds2019_enddate, 'mm/dd/yyyy')#</span>
                                            	<cfinput type="text" class="style1 editPage" name="ds2019_enddate" size=20 value="#DateFormat(qGetCandidate.ds2019_enddate, 'mm/dd/yyyy')#" maxlength="12" validate="date" message="DS-2019 End Date(MM/DD/YYYY)">
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>	
                            </tr>
                        </table>
                        
                        <br />
                        
                        <!--- FLIGHT INFO --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">
                                            	&nbsp;:: Flight Information
                                                <span style="float:right; padding-right:20px;">
                                                	<a href="onlineApplication/index.cfm?action=flightInfo&uniqueID=#qGetCandidate.uniqueID#&completeApplication=0" class="style2 popUpFlightInformation">[ Add/Edit ]</a>
                                                </span>
                                          	</td>
                                        </tr>	
                                        <tr>
                                            <td class="style1">Depart Home</td><td class="style1"><cfif LEN(qDepartureInfo.departDate)>#DateFormat(qDepartureInfo.departDate, 'mm/dd/yyyy')#<cfelse>No Flights on Record</cfif> </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">Depart US</td><td class="style1"><cfif LEN(qArrivalInfo.departDate)>#DateFormat(qArrivalInfo.departDate, 'mm/dd/yyyy')#<cfelse>No Flights on Record</cfif></td>
                                        </tr>
                                    </table>
                                </td>	
                            </tr>
                        </table>
                        
                        <br />
                        
                        <!---- Arrival Verification --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="4" class="style2" bgcolor="##8FB6C9">
                                            	&nbsp;:: Arrival Verification
                                            	<!--- Office View Only --->  
                                            	<cfif ListFind("1,2,3,4", CLIENT.userType)>    
                                                	<span style="float:right; padding-right:20px;">
                                                    	<a href="javascript:openWindow('candidate/arrival_history.cfm?uniqueID=#URL.uniqueid#', 400, 600);" class="style2">[ History ]</a>
                                                    </span>
                                            	</cfif>
                                         	</td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="watDateCheckedIn"><strong>Check-in Date:</strong></label></td>
                                        	<td class="style1" width="70%">
                                                <span class="readOnly">#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="watDateCheckedIn" id="watDateCheckedIn" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.watDateCheckedIn, 'mm/dd/yyyy')#" maxlength="10">
                                        		<cfif NOT LEN(qGetCandidate.watDateCheckedIn)><font size="1">(mm/dd/yyyy)</font></cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>U.S. Phone:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.us_phone#</span>
                                                <input type="text" name="usPhone" id="usPhone" class="style1 editPage" value="#qGetCandidate.us_phone#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>Address:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_address#</span>
                                                <input type="text" name="arrival_address" id="arrival_address" class="style1 editPage" value="#qGetCandidate.arrival_address#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>City:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_city#</span>
                                                <input type="text" name="arrival_city" id="arrival_city" class="style1 editPage" value="#qGetCandidate.arrival_city#">
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="usPhone"><strong>State:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">
                                                	<cfloop query="qGetStateList">
                                                    	<cfif id EQ qGetCandidate.arrival_state>
                                                        	#state#
                                                        </cfif>
                                                   	</cfloop>
                                             	</span>
                                                <select name="arrival_state" id="arrival_state" class="style1 editPage">
                                                	<option value="0"></option>
                                                	<cfloop query="qGetStateList">
                                                    	<option value="#id#" <cfif id EQ qGetCandidate.arrival_state>selected="selected"</cfif>>#state#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" width="30%" align="right"><label for="arrival_zip"><strong>Zip:</strong></label></td>
                                        	<td class="style1" width="70%">
                                            	<span class="readOnly">#qGetCandidate.arrival_zip#</span>
                                                <input type="text" name="arrival_zip" id="arrival_zip" class="style1 editPage" value="#qGetCandidate.arrival_zip#" size="5" maxlength="5">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right">
                                            	<label for="ds2019_dateActivatedCheck"> <strong>SEVIS Activation:</strong> </label>
                                            </td>
                                            <td class="style1" colspan="3">
												<input type="checkbox" name="ds2019_dateActivatedCheck" id="ds2019_dateActivatedCheck" value="1" class="formField" onClick="populateDate('#DateFormat(now(), 'mm/dd/yyyy')#', this.id, 'ds2019_dateActivated');" disabled <cfif isDate(qGetCandidate.ds2019_dateActivated)>checked="checked"</cfif> >                                                

                                                &nbsp; 
                                                
                                                <label for="ds2019_dateActivated"> <strong> Date: </strong> </label>
                                                
                                                &nbsp; 
                                                
                                                <span class="readOnly">#dateFormat(qGetCandidate.ds2019_dateActivated, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="ds2019_dateActivated" id="ds2019_dateActivated" class="datePicker style1 editPage" value="#dateFormat(qGetCandidate.ds2019_dateActivated, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>  
                        			</table>
                                    
                                </td>
                            </tr>
                        </table>
                        
                        <br />
                        
                    	<!--- EVALUATIONS --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding="5" cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Evaluations</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="ckDoc_midterm_evaluation" id="ckDoc_midterm_evaluation" value="1" class="formField" onClick="checkInsertDate('ckDoc_midterm_evaluation','doc_midterm_evaluation');" disabled <cfif LEN(qGetCandidate.doc_midterm_evaluation)> checked </cfif> >												
												<label for="ckDoc_midterm_evaluation">Midterm Evaluation</label>
                                            </td>
                                            <td class="style1" colspan="2">
                                            	<span class="readOnly">#DateFormat(qGetCandidate.doc_midterm_evaluation, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="doc_midterm_evaluation" id="doc_midterm_evaluation" value="#DateFormat(qGetCandidate.doc_midterm_evaluation, 'mm/dd/yyyy')#" class="style1 editPage datePicker" size="12" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan="2">
												<input type="checkbox" name="ckDoc_summative_evaluation" id="ckDoc_summative_evaluation" value="1" class="formField" onClick="checkInsertDate('ckDoc_summative_evaluation','doc_summative_evaluation');" disabled <cfif LEN(qGetCandidate.doc_summative_evaluation)> checked </cfif> >												
												<label for="ckDoc_summative_evaluation">Summative Evaluation</label>
                                            </td>
                                            <td class="style1" colspan="2">
												<span class="readOnly">#DateFormat(qGetCandidate.doc_summative_evaluation, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="doc_summative_evaluation" id="doc_summative_evaluation" value="#DateFormat(qGetCandidate.doc_summative_evaluation, 'mm/dd/yyyy')#" class="style1 editPage datePicker" size="12" maxlength="10">
                                            </td>
                                        </tr>
									</table>
								</td>
							</tr>                                                                    
						</table>                            

                        <br />
                        
                        <!--- Quarterly Questionnaires --->
                        <table cellpadding="5" cellspacing="5" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                                
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Quarterly Questionnaire</td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="style1" align="right"><b>February:</b></td>
                                            <td width="70%" class="style1">
                                            	<cfif isDate(qGetFebQuarterlyEvaluation.dateApproved)>
                                                	#dateformat(qGetFebQuarterlyEvaluation.dateApproved, 'mm/dd/yyyy')#
                                                <cfelse>                                                
                                                	n/a
												</cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>May:</b></td>
                                            <td class="style1">
                                            	<cfif isDate(qGetMayQuarterlyEvaluation.dateApproved)>
                                                	#dateformat(qGetMayQuarterlyEvaluation.dateApproved, 'mm/dd/yyyy')#
                                                <cfelse>                                                
                                                	n/a
												</cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>August:</b></td>
                                            <td class="style1">
                                            	<cfif isDate(qGetAugQuarterlyEvaluation.dateApproved)>
                                                	#dateformat(qGetAugQuarterlyEvaluation.dateApproved, 'mm/dd/yyyy')#
                                                <cfelse>                                                
                                                	n/a
												</cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>November:</b></td>
                                            <td class="style1">
                                            	<cfif isDate(qGetNovQuarterlyEvaluation.dateApproved)>
                                                	#dateformat(qGetNovQuarterlyEvaluation.dateApproved, 'mm/dd/yyyy')#
                                                <cfelse>                                                
                                                	n/a
												</cfif>
                                            </td>
                                        </tr>
                                    </table>
                                    
                                </td>	
                            </tr>
                        </table>     

                        <br />
                        
                        <!---- Incident Report --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="##8FB6C9">
                                                &nbsp;:: Incident Report
                                                <span style="float:right; padding-right:20px;">
                                                    <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#" class="style2 jQueryModal">[ New Incident ]</a>
                                                </span>
                                            </td>
                                        </tr>	
                                        <tr>
                                            <td class="style1"><strong>Date</strong></td>
                                            <td class="style1"><strong>Nature of Complaint</strong></td>
                                            <td class="style1"><strong>Host Company</strong></td>
                                            <td class="style1"><strong>Solved</strong></td>
                                        </tr>
                                        
                                        <cfloop query="qGetIncidentReport">
                                            <tr <cfif qGetIncidentReport.currentRow mod 2>bgcolor="##E4E4E4"</cfif>>     
                                                <td class="style1">
                                                    <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#&incidentID=#qGetIncidentReport.ID#" class="style4 jQueryModal">
                                                        #DateFormat(qGetIncidentReport.dateIncident, 'mm/dd/yy')#
                                                    </a>
                                                </td>
                                                <td class="style1">
                                                    <a href="candidate/incidentReport.cfm?uniqueID=#qGetCandidate.uniqueID#&incidentID=#qGetIncidentReport.ID#" class="style4 jQueryModal">
                                                        #qGetIncidentReport.subject#
                                                    </a>
                                                </td>
                                                <td class="style1">#qGetIncidentReport.hostCompanyName#</td>
                                                <td class="style1">#YesNoFormat(VAL(qGetIncidentReport.isSolved))#</td>
                                            </tr>
                                        </cfloop>
                                        
                                        <cfif NOT VAL(qGetIncidentReport.recordCount)>
                                            <tr bgcolor="##E4E4E4">
                                                <td colspan="4" class="style1" align="center">There are no incidents recorded</td>                                                
                                            </tr>
                                        </cfif> 
                                                                                       
                                    </table>
                                    
                                </td>
                            </tr>
                        </table>
                        
                    </td>	
                </tr>
            </table>
            
            <br />
                    
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
                
                <br />
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