<!--- ------------------------------------------------------------------------- ----
	
	File:		candidate_info.cfm
	Author:		Marcus Melo
	Date:		June 01, 2010
	Desc:		Candidate Information Screen.

	Updated: 	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Param variables --->
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.candidateID" default="0">
    
    <cfinclude template="../querys/get_candidate_unqid.cfm">
    <cfinclude template="../querys/countrylist.cfm">
    <cfinclude template="../querys/fieldstudy.cfm">
    <cfinclude template="../querys/program.cfm">

	<!--- Query of Queries --->
    <cfquery name="qGetProgramInfo" dbtype="query">
        SELECT 
            programID,
            programName,
            extra_sponsor
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

    <!--- Intl Rep. --->
    <cfquery name="qIntRepList" datasource="MySQL">
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
    </cfquery>
      
    <cfquery name="qGetIntlRepInfo" datasource="MySQL">
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
            u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.intrep#">
    </cfquery>
    
    <cfquery name="qCandidatePlaceCompany" datasource="MySQL">
        SELECT 
        	eh.hostCompanyID,
            eh.name,
            ecpc.status,
            ecpc.placement_date,
            ecpc.startDate,
            ecpc.endDate
        FROM
        	extra_candidate_place_company ecpc
        INNER JOIN
        	extra_hostcompany eh ON eh.hostCompanyID = ecpc.hostCompanyID
        WHERE 
        	ecpc.candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_unqid.candidateID#">
        AND 	
        	ecpc.status = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    </cfquery>
    
    <cfquery name="qHostCompanyList" datasource="MySQL">
        SELECT 
        	hostcompanyID,
            name 
        FROM 
        	extra_hostcompany
        WHERE 
        	extra_hostcompany.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="8">
        ORDER BY 
        	name
    </cfquery>
    
</cfsilent>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Candidate Info</title>

</head>
<body>

<style type="text/css">
<!-- 
	.editPage { display:none;}
-->
</style>

<script type='text/javaScript'>
	$(document).ready(function() {
		$(".formField").attr("disabled","disabled");
		$(".dp-choose-date").fadeOut("fast");
	});

	function populateDate(dateValue) {
		if ($('#ds2019Check').attr('checked')) {
			$("#verification_received").val(dateValue);
		} else {
			$("#verification_received").val("");
		}
	}

	function openWindow(url, setHeight, setWidth) {
		newwindow = window.open(url, 'Application', 'height=' + setHeight + ', width=' + setWidth + ', location=no, scrollbars=yes, menubar=no, toolbars=no, resizable=yes'); 
		if(window.focus) {
			newwindow.focus()
		}
	}
	
	function readOnlyEditPage() {
		if( $(".readOnly").css("display") == "none" ) {			
			// Hide editPage and display readOnly
			$(".editPage").fadeOut("slow");
			$(".readOnly").fadeIn("slow");
			$(".formField").attr("disabled","disabled");
		} else {
			// Hide readOnly and display editPage
			$(".readOnly").fadeOut("fast");
			$(".editPage").fadeIn("slow");	
			$(".formField").removeAttr("disabled");
			$(".dp-choose-date").fadeIn("fast");
		}
	}

	function displayCancelation(selectedValue) {
		if (selectedValue == 'canceled') {
			$("#divCancelation").slideDown(1000);
		} else {
			$("#divCancelation").fadeOut("slow");
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
			$("#host_startdate").val("");
			$("#host_enddate").val("");
			$("#reason_host").focus();
		} else if (currentHostPlaceID == selectedHostID) {
			$("#host_history").fadeOut("slow");
		}
	}
	
	// Check History
	function checkHistory() {
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

<!--- candidate does not exist --->
<cfif NOT VAL(get_candidate_unqid.recordcount)>
	The candidate ID you are looking for was not found. This could be for a number of reasons.<br /><br />
	<ul>
		<li>the candidate record was deleted or renumbered
		<li>the link you are following is out of date
		<li>you do not have proper access lefts to view the candidate
	</ul>
	If you feel this is incorrect, please contact <a href="mailto:support@student-management.com">Support</a>
	<cfabort>
</cfif>

<cfoutput>

<cfform name="CandidateInfo" method="post" action="?curdoc=candidate/qr_edit_candidate&uniqueid=#get_candidate_unqid.uniqueid#" onsubmit="return checkHistory();">
<input type="hidden" name="candidateID" value="#get_candidate_unqid.candidateID#">
<input type="hidden" name="submitted" value="1">

<!--- TABLE HOLDER --->
<table width="100%" height="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##F4F4F4">
    <tr>
        <td bordercolor="##FFFFFF">

			<!--- TABLE HEADER --->
            <table width="95%" cellpadding="0" cellspacing="0" border="0" align="center" height="25" bgcolor="##E4E4E4">
                <tr bgcolor="##E4E4E4">
                	<td class="title1"><font size="2">&nbsp; &nbsp; Candidate Information</font></td>
                </tr>
            </table>

			<br />
            
            <!--- TOP SECTION --->
            <table width="800px" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##ffffff">	
                <tr>
                    <td valign="top">
                    
                    	<!--- CANDIDATE PHOTO --->
                        <table width="135px" align="left" cellpadding="2">
                            <tr>
                                <td valign="top">
                                    <cfif FileExists(expandPath("../uploadedfiles/web-candidates/#get_candidate_unqid.candidateID#.jpg"))>
                                        <img src="../uploadedfiles/web-candidates/#get_candidate_unqid.candidateID#.jpg" width="135">
                                    <cfelse>
                                        <img src="../pics/no_stupicture.jpg" width="137" height="137">
                                    </cfif>
                                </td>
                            </tr>
						</table>
    
                        <!--- CANDIDATE INFO - READ ONLY --->
                        <table width="635px" align="right" cellpadding="2" class="readOnly">
                            <tr>
                                <td align="center" colspan="2" class="title1">#get_candidate_unqID.firstname# #get_candidate_unqID.middlename# #get_candidate_unqID.lastname# (###get_candidate_unqID.candidateID#)</td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <span class="style4">[ <a href='candidate/candidate_profile.cfm?uniqueid=#get_candidate_unqid.uniqueid#' target="_blank"><span class="style4">profile</span></a> ]</span> 
                                    <span class="style4">[ <a href='candidate/immigrationLetter.cfm?uniqueid=#get_candidate_unqid.uniqueid#' target="_blank"><span class="style4">Immigration Letter</span></a> ]</span>
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2" class="style1">
                                    <cfif NOT LEN(get_candidate_unqID.dob)>n/a<cfelse>#dateFormat(get_candidate_unqID.dob, 'mm/dd/yyyy')# - #datediff('yyyy',get_candidate_unqID.dob,now())# year old</cfif> 
                                    - 
                                    <cfif get_candidate_unqID.sex EQ 'm'>Male<cfelse>Female</cfif>
                                </td>
                            </tr> 
                            <tr>
                                <td align="right" class="style1"><b>Intl. Rep.:</b></td>
                                <td class="style1">#qGetIntlRepInfo.businessName#</td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><b>Date of Entry: </b></td>
                                <td class="style1">#dateFormat(get_candidate_unqID.entrydate, 'mm/dd/yyyy')#</td>
                            </tr>
                            <tr>
                                <td align="right">&nbsp;</td>
                                <td class="style1">
                                	Candidate is <b>
									<cfif get_candidate_unqID.status EQ 1>
                                        ACTIVE 
                                    <cfelseif get_candidate_unqID.status EQ 0>
                                        INACTIVE 
                                    <cfelseif get_candidate_unqID.status EQ 'canceled'>
                                        CANCELED
                                    </cfif> </b>
                                </td>
                            </tr>													
                        </table>
                        
                        <!--- CANDIDATE INFO - EDIT PAGE --->
                        <table width="635px" align="right" cellpadding="2" class="editPage">
                            <tr>
                                <td align="right" class="style1"><b>Last Name:</b> </td>
                                <td><input type="text" name="lastname" class="style1" size="32" value="#get_candidate_unqID.lastname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><b>First Name:</b></td>
                                <td><input type="text" name="firstname" class="style1" size="32" value="#get_candidate_unqID.firstname#" maxlength="100"></td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><b>Middle Name:</b> </td>
                                <td><input type="text" name="middlename" class="style1" size="32" value="#get_candidate_unqID.middlename#" maxlength="100"></td>
                            <tr>
                                <td align="center" class="style1"><b>Date of Birth:</b></td>
                                <td class="style1">
                                    <cfinput type="text" name="dob" class="date-pick style1" size="12" value="#dateFormat(get_candidate_unqID.dob, 'mm/dd/yyyy')#" maxlength="35" validate="date" message="Date of Birth (MM/DD/YYYY)" required="yes">
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
                                            <option value="#qIntRepList.userid#" <cfif qIntRepList.userid EQ get_candidate_unqID.intrep> selected </cfif>>#qIntRepList.businessname#</option>
                                        </cfloop>
                                    </select>
                              </td>
                            </tr>
                            <tr>
                                <td align="right" class="style1"><b>Date of Entry: </b></td>
                                <td class="style1">#dateFormat(get_candidate_unqID.entrydate, 'mm/dd/yyyy')#</td>
                            </tr>												
                            <tr>
                                <td align="right" class="style1"><b>Status: </b></td>
                                <td class="style1">
                                	<select id="status" name="status" <cfif get_candidate_unqID.status NEQ 'canceled'> onchange="javascript:displayCancelation(this.value);" </cfif> >
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
            <!--- END OF TOP SECTION --->
            
            <br>                                    
            
			<!--- INFORMATION SECTION --->
            <table width="800px" border="0" cellpadding="0" cellspacing="0" align="center">	
                <tr>
                    <!--- LEFT SECTION --->
                    <td width="49%" valign="top">
                        
                        <!--- PERSONAL INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
								<td bordercolor="##FFFFFF">
                                                                	
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="C2D1EF" bordercolor="##FFFFFF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Personal Information</td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right" width="50%"><b>Place of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF" width="50%">
                                            	<span class="readOnly">#get_candidate_unqID.birth_city#</span>
                                                <input type="text" class="style1 editPage" name="birth_city" size="32" value="#get_candidate_unqID.birth_city#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Country of Birth:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetBirthCountry.countryName#</span>
                                                <select name="birth_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.birth_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>		
                                        <tr>
                                            <td class="style1" align="right"><b>Country of Citizenship:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetCitizenCountry.countryName#</span>
                                                <select name="citizen_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.citizen_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Country of Permanent Residence:</b></td>
                                            <td class="style1" bordercolor="##FFFFFF">
                                                <span class="readOnly">#qGetResidenceCountry.countryName#</span>
                                                <select name="residence_country" class="style1 editPage">
                                                    <option value="0"></option>		
                                                    <cfloop query="countrylist">
                                                        <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.residence_country> selected </cfif>>#countryname#</option>
                                                    </cfloop>
                                                </select>			
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Passport Number:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqid.passport_number#</span>
                                            	<input name="passport_number" class="style1 editPage" value="#get_candidate_unqid.passport_number#" type="text" size=32 maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>				
                                            <td class="style1" colspan="2">
            
                                                <table width="100%" cellpadding="3" cellspacing="3" bordercolor="##C7CFDC" bgcolor="F7F7F7">
                                                    <tr>
                                                        <td colspan="4" class="style1">
                                                        	<b>Mailing Address:</b> 
															<span class="readOnly">#get_candidate_unqID.home_address#</span>
                                                            <input type="text" class="style1 editPage" name="home_address" size=49 value="#get_candidate_unqID.home_address#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                    <tr>
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
                                                    <tr>
                                                        <td class="style1" align="right"><b>Country:</b></td>
                                                        <td class="style1" colspan="3">                                                        
                                                            <span class="readOnly">#qGetHomeCountry.countryName#</span>
                                                            <select name="home_country" class="style1 editPage">
                                                                <option value="0"></option>		
                                                                <cfloop query="countrylist">
                                                                    <option value="#countryid#" <cfif countryid EQ get_candidate_unqID.home_country> selected </cfif>>
																		<cfif len(countryname) GT 55>
                                                                        	#Left(countryname, 52)#...
                                                                        <cfelse>
                                                                        	#countryname#
                                                                        </cfif>
                                                                    </option>
                                                                </cfloop>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><b>Phone:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#get_candidate_unqID.home_phone#</span>
                                                            <input type="text" class="style1 editPage" name="home_phone" size=38 value="#get_candidate_unqID.home_phone#" maxlength="50">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style1" align="right"><b>Email:</b></td>
                                                        <td class="style1" colspan="3">
                                                        	<span class="readOnly">#get_candidate_unqID.email#</span>
                                                            <input type="text" class="style1 editPage" name="email" size=38 value="#get_candidate_unqID.email#" maxlength="100">
                                                        </td>
                                                    </tr>
                                                </table>
                                            
                                            </td>					
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Social Security ##:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqid.ssn#</span>
                                                <input name="ssn" value="#get_candidate_unqid.ssn#" type="text" class="style1 editPage" size="32" maxlength="100">
                                            </td>
                                        </tr>					
                                        <tr>
                                            <td class="style1" align="right"><b>English Assessment:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqid.personal_info#</span>
                                                <textarea name="personal_info" class="style1 editPage" cols="30" rows="5">#get_candidate_unqid.personal_info#</textarea>
                                            </td>
                                        </tr>
                                    </table>

                                </td>
                            </tr>
                        </table> 
                        
                        <br />

                        <!--- DATES OF VACATION --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                        	<td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Dates of the Official Vacation</td>
                                        </tr>
                                        <tr>
                                            <td width="23%" class="style1" align="right"><b>Start Date:</b></td>
                                            <td class="style1">
                                            	<span class="readOnly">#dateFormat(get_candidate_unqid.wat_vacation_start, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_start" class="date-pick style1 editPage" value="#dateFormat(get_candidate_unqid.wat_vacation_start, 'mm/dd/yyyy')#" maxlength="10">
                                                <font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><b>End Date:</b></td>
                                        	<td class="style1">	
                                            	<span class="readOnly">#dateFormat(get_candidate_unqid.wat_vacation_end, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="wat_vacation_end" class="date-pick style1 editPage" value="#dateFormat(get_candidate_unqid.wat_vacation_end, 'mm/dd/yyyy')#" maxlength="10"> 
                                                <font size="1">(mm/dd/yyyy)</font>
                                        	</td>
                                        </tr>
                                    </table>	
                   
                                </td>
                            </tr>
                        </table> 

						<br />

						<!--- EMERGENCY CONTACT --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Emergency Contact</td>
                                        </tr>
                                        <tr>
                                            <td width="15%" class="style1" align="right"><b>Name:</b></td>
                                            <td class="style1">
                                                <span class="readOnly">#get_candidate_unqid.emergency_name#</span>
                                                <input type="text" name="emergency_name" class="style1 editPage" size="32" value="#get_candidate_unqid.emergency_name#" maxlength="100">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>Phone:</b></td>
                                            <td class="style1">
                                                <span class="readOnly">#get_candidate_unqid.emergency_phone#</span>                          
                                                <input type="text" name="emergency_phone" class="style1 editPage" size="32" value="#get_candidate_unqid.emergency_phone#" maxlength="50">
                                           </td>
                                        </tr>
                                    </table>	
                   
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                        <!--- DOCUMENTS CONTROL --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Documents Control</td>
                                        </tr>
                                        <tr>
                                            <td width="46%" class="style1">
                                                <input type="checkbox" name="wat_doc_agreement" id="wat_doc_agreement" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_agreement)> checked </cfif> > 
                                                <label for="wat_doc_agreement">Agreement</label>
                                            </td>
                                            <td width="54%" class="style1">
                                                <input type="checkbox" name="wat_doc_college_letter" id="wat_doc_college_letter" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_college_letter)> checked </cfif> >
                                                <label for="wat_doc_college_letter">College Letter</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_passport_copy" id="wat_doc_passport_copy" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_passport_copy)> checked </cfif> > 
                                                <label for="wat_doc_passport_copy">Passport Copy</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_job_offer" id="wat_doc_job_offer" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_job_offer)> checked </cfif> >
                                                <label for="wat_doc_job_offer">Job Offer</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_orientation" id="wat_doc_orientation" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_orientation)> checked </cfif> > 
                                                <label for="wat_doc_orientation">Orient. Sign Off</label>
                                            </td>
                                            <td class="style1">
                                                <input type="checkbox" name="wat_doc_walk_in_agreement" id="wat_doc_walk_in_agreement" value="1" class="formField" disabled <cfif VAL(get_candidate_unqID.wat_doc_walk_in_agreement)> checked </cfif> > 
                                                <label for="wat_doc_walk_in_agreement">Walk-In Agreement</label>
                                            </td>
                                        </tr>
                                    </table>
                   
                                </td>
                            </tr>
                        </table> 

						<br />

						<!--- INSURANCE INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding="3" cellspacing="3" border="0">
                                        <tr bgcolor="##C2D1EF">
                                            <td colspan="3" class="style2" bgcolor="8FB6C9">
                                                &nbsp;:: Insurance &nbsp; &nbsp; &nbsp; &nbsp; 
                                                [ <a href="javascript:openWindow('insurance/insurance_mgmt.cfm?uniqueid=#uniqueid#', 500, 800);"><font class="style2" color="FFFFFF">Insurance Management</font></a> ]
                                            </td>
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
                                                <cfif qGetIntlRepInfo.extra_insurance_typeid GT 1 AND get_candidate_unqID.insurance_date EQ ''>
                                                    not insured yet
                                                <cfelseif get_candidate_unqID.insurance_date NEQ ''>
                                                    #dateFormat(get_candidate_unqID.insurance_date, 'mm/dd/yyyy')#
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
                                            <td class="style1">#dateFormat(get_candidate_unqID.insurance_cancel_date, 'mm/dd/yyyy')#</td>
                                        </tr>
                                    </table>
                   
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                	</td>        
					<!--- END OF LEFT SECTION --->
				
					<!--- DIVIDER --->
                    <td width="2%" valign="top">&nbsp;</td>
                	
                    <!--- RIGHT SECTION --->	    
                    <td width="49%" valign="top">

                    	<!--- CANCELATION --->
                    	<div id="divCancelation" <cfif get_candidate_unqID.status NEQ 'canceled'> style="display:none;" </cfif> >
                            <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                                <tr>
                                    <td bordercolor="##FFFFFF">
                                
                                        <table width="100%" cellpadding=5 cellspacing="0" border="0">
                                            <tr bgcolor="##C2D1EF">
                                                <td colspan="3" class="style2" bgcolor="8FB6C9">&nbsp;:: Cancelation	</td>
                                            </tr>
                                            <tr>
                                                <td width="12%" class="style1"><b>Date: </b></td>
                                                <td colspan="2" class="style1">
                                                    <span class="readOnly">#dateFormat(get_candidate_unqid.cancel_date, 'mm/dd/yyyy')#</span>
                                                    <input type="text" class="style1 editPage date-pick" name="cancel_date" value="#dateFormat(get_candidate_unqid.cancel_date, 'mm/dd/yyyy')#">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="style1" align="right" valign="top"><b>Reason:</b></td>
                                                <td class="style1">
                                                    <span class="readOnly">#get_candidate_unqid.cancel_reason#</span>
                                                    <input type="text" class="style1 editPage" name="cancel_reason" size="50" value="#get_candidate_unqid.cancel_reason#">
                                                </td>								
                                            </tr>
                                        </table>	
                                
                                    </td>
                                </tr>
                            </table> 
							
                            <br />
                        
                        </div>
                        
						<!--- HOST COMPANY INFO / PLACEMENT INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=5 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
            	                            <td colspan="2" class="style2" bgcolor="8FB6C9">&nbsp;:: Placement Information [<a href="javascript:openWindow('candidate/candidate_host_history.cfm?unqid=#get_candidate_unqid.uniqueid#', 400, 750);" class="style2"> History </a> ]</span></td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="Left" colspan=2><b>Company Name:</b></td>
                                        </tr>
                                        <tr>
                                            <td class="style1" colspan=2 align="left">
                                            	<span class="readOnly">
                                                    <a href="?curdoc=hostcompany/hostcompany_profile&hostcompanyID=#qCandidatePlaceCompany.hostcompanyID#" class="style4"><b>#qCandidatePlaceCompany.name#</b></a>
                                                </span>
                                                
                                                <select name="hostcompanyID_combo" class="style1 editPage" onChange="displayHostReason(#VAL(qCandidatePlaceCompany.hostCompanyID)#, this.value);"> 
	                                                <option value="0"></option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostcompanyID#" <cfif qCandidatePlaceCompany.hostCompanyID EQ qHostCompanyList.hostcompanyID>selected</cfif> > 
															<cfif LEN(qHostCompanyList.name) GT 55>
                                                                #Left(qHostCompanyList.name, 52)#...
                                                            <cfelse>
                                                                #qHostCompanyList.name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="host_history" bgcolor="FFBD9D" style="display:none;">
                                            <td class="style1" align="right"><b>Reason:</b></td>
                                            <td class="style1"><input type="text" name="reason_host" id="reason_host" size="50" class="style1"></td>
                                        </tr>
                                        <tr>
                                            <td width="30%" class="style1" align="right"><b>Status:</b></td>
                                            <td class="style1">
                                                <input type="radio" name="hostcompany_status" id="hostStatus1" value="1" class="formField" disabled <cfif VAL(qCandidatePlaceCompany.status)>checked="yes" </cfif>>
                                                <label for="hostStatus1">Active</label>
                                                &nbsp;
                                                <input type="radio" name="hostcompany_status" id="hostStatus0" value="0" class="formField" disabled <cfif NOT VAL(qCandidatePlaceCompany.status)>checked="yes" </cfif>>
                                                <label for="hostStatus0">Inactive</label>
                                            </td>
                                        </tr>
                                        <tr class="readOnly">
                                        	<td class="style1" align="right"><b>Placement Date:</b></td>
                                            <td class="style1" align="left">
	                                        	#dateFormat(qCandidatePlaceCompany.placement_date, 'mm/dd/yyyy')#
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><b>Start Date:</b></td>
                                        	<td class="style1">
												<span class="readOnly">#dateFormat(qCandidatePlaceCompany.startdate, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="host_startdate" id="host_startdate" class="date-pick editPage" value="#dateFormat(qCandidatePlaceCompany.startdate, 'mm/dd/yyyy')#" maxlength="10">
                                                <font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><b>End Date:</b></td>
                                        	<td class="style1">
												<span class="readOnly">#dateFormat(qCandidatePlaceCompany.enddate, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="host_enddate" id="host_enddate" class="date-pick editPage" value="#dateFormat(qCandidatePlaceCompany.enddate, 'mm/dd/yyyy')#" maxlength="10">
                                                <font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>								
                                    </table>	
                        
                                </td>
                            </tr>
                        </table> 

						<br />

						<!--- PROGRAM INFO --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=5 cellspacing="0" border="0">
                                        <tr bgcolor="##C2D1EF" bordercolor="##FFFFFF">
                                        	<td class="style2" bgcolor="8FB6C9" colspan="4">&nbsp;:: Program Information &nbsp;  [<a href="javascript:openWindow('candidate/candidate_program_history.cfm?unqid=#uniqueid#', 400, 600);"><font class="style3" color="FFFFFF"> History </font></a> ]</span></td>
                                        </tr>						
                                        <tr>
                                        	<td class="style1" align="right" width="27%"><b>Program:</b></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly">#qGetProgramInfo.programName#</span>
                                                <select name="programid" class="style1 editPage" onChange="displayProgramReason(#VAL(get_candidate_unqID.programid)#, this.value);">
                                                    <option value="0">Unassigned</option>
                                                    <cfloop query="program">
                                                        <option value="#program.programid#" <cfif get_candidate_unqid.programid EQ program.programid> selected </cfif> >#program.programname#</option>
                                                    </cfloop>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr id="program_history" bgcolor="FFBD9D" style="display:none;">
                                        	<td class="style1" align="right"><b>Reason:</b></td>
                                        	<td class="style1" colspan="3"><input type="text" name="reason" id="reason" size="50" class="style1"></td>
                                        </tr>
                                        <tr>
                                        	<!--- Placement--->
                                        	<td class="style1" align="right"><b>Option:</b></td>
                                        	<td class="style1" colspan="3">
												<span class="readOnly">#get_candidate_unqid.wat_placement#</span>
                                                <select name="wat_placement" class="style1 editPage">
                                                    <option value="">Select....</option>
                                                    <option value="Self-Placement" <cfif get_candidate_unqid.wat_placement EQ 'Self-Placement'>selected="selected"</cfif>>Self-Placement</option>
                                                    <option value="CSB-Placement" <cfif get_candidate_unqid.wat_placement EQ 'CSB-Placement'>selected="selected"</cfif>>CSB-Placement</option>
                                                     <option value="Walk-In" <cfif get_candidate_unqid.wat_placement EQ 'Walk-In'>selected="selected"</cfif>>Walk-In</option>
                                                </select>
	                                        </td>
                                        </tr>		
                                        <tr>
                                        	<td class="style1" align="left" colspan="4">
                                            	<b>Number of Participation in the Program:</b>
                                        		<span class="readOnly">#get_candidate_unqid.wat_participation#</span>
                                                <select name="wat_participation" class="style1 editPage">
                                                	<cfloop from="0" to="15" index="i">
                                                    	<option value="#i#" <cfif get_candidate_unqid.wat_participation EQ i> selected </cfif> >#i#</option>                                                    
                                                    </cfloop>
                                 				</select>               
	                                        </td>
                                        </tr>
                                        <tr>
    	                                    <td class="style1" align="left" colspan=2><b>Requested Placement:</b>
                                        </tr>
                                        <tr>
                                        	<td class="style1" colspan="4"> 
												<span class="readOnly">#qCandidatePlaceCompany.name#</span>
                                                <select name="requested_placement" class="style1 editPage">
                                                    <option value="0"></option>
                                                    <cfloop query="qHostCompanyList">
                                                    	<option value="#qHostCompanyList.hostcompanyID#" <cfif get_candidate_unqid.requested_placement EQ qHostCompanyList.hostcompanyID>selected</cfif>> 
															<cfif LEN(qHostCompanyList.name) GT 55>
                                                                #Left(qHostCompanyList.name, 52)#...
                                                            <cfelse>
                                                                #qHostCompanyList.name#
                                                            </cfif>
                                                        </option>
                                                    </cfloop>
                                                </select>
 	                                       </td>
                                        </tr>			
                                        <tr>
	                                        <td class="style1" align="right"><b>Comment:</b></td>
    	                                    <td class="style1" colspan="3">
        	                                	<span class="readOnly">#get_candidate_unqid.change_requested_comment#</span>
            		                            <textarea name="change_requested_comment" class="style1 editPage" value="change_requested_comment" cols="40" rows="3">#get_candidate_unqid.change_requested_comment#</textarea>
                    	                    </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><b>Start Date:</b></td>
                                        	<td class="style1" colspan="3">
                                            	<span class="readOnly">#dateFormat(get_candidate_unqid.startdate, 'mm/dd/yyyy')#</span>
                                            	<input type="text" class="date-pick editPage" name="program_startdate" value="#dateFormat(get_candidate_unqid.startdate, 'mm/dd/yyyy')#" maxlength="10"><font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><b>End Date:</b></td>
                                            <td class="style1" colspan="3">
                                                <span class="readOnly">#dateFormat(get_candidate_unqid.enddate, 'mm/dd/yyyy')#</span>
                                                <input type="text" class="date-pick editPage" name="program_enddate" value="#dateFormat(get_candidate_unqid.enddate, 'mm/dd/yyyy')#" maxlength="10"><font size="1">(mm/dd/yyyy)</font>
                                            </td>
                                        </tr>
                                    </table>
                        
                                </td>
                            </tr>
                        </table> 

						<br />
                        
						<!--- DS2019 Form --->
                        <table cellpadding="3" cellspacing="3" border="1" align="center" width="100%" bordercolor="##C7CFDC" bgcolor="##ffffff">
                            <tr>
                                <td bordercolor="##FFFFFF">
                        
                                    <table width="100%" cellpadding=3 cellspacing="0" border="0">
                                    	<tr bgcolor="##C2D1EF">
                                    		<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Form DS-2019</td>
                                    	</tr>	
                                        <tr>
                                            <td class="style1" align="left" colspan="2"><strong>Sponsor</strong>&nbsp; 
                                                <cfif LEN(qGetProgramInfo.extra_sponsor)>
                                                    #qGetProgramInfo.extra_sponsor#
                                                <cfelse>
                                                    n/a
                                                </cfif>	
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="left" colspan="2"><strong><label for="ds2019Check">DS-2019 Verification Report Received</label></strong>&nbsp; 
                                            	<input type="checkbox" name="ds2019Check" id="ds2019Check" class="formField" disabled onClick="populateDate('#DateFormat(now(), 'mm/dd/yyyy')#');" <cfif LEN(get_candidate_unqid.verification_received)> checked </cfif> > Yes 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" width="35%" align="right"><strong>Date:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#dateFormat(get_candidate_unqid.verification_received, 'mm/dd/yyyy')#</span>
                                                <input type="text" name="verification_received" id="verification_received" class="date-pick style1 editPage" value="#dateFormat(get_candidate_unqid.verification_received, 'mm/dd/yyyy')#" maxlength="10">
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="style1" align="right"><strong>DS-2019 Number:</strong></td>
                                            <td class="style1">
                                            	<span class="readOnly">#get_candidate_unqid.ds2019#</span>
                                                <input type="text" name="ds2019" class="style1 editPage" value="#get_candidate_unqid.ds2019#" size="12" maxlength="20">
                                            </td>
                                        </tr>
                                        <tr>	
                                            <td class="style1" colspan="2" align="left">
                                            	<b>Intl. Rep. Accepts Sevis Fee</b>&nbsp; &nbsp;
                                            	<input type="checkbox" name="agent_accepts_sevis" class="formField" disabled value="1" <cfif VAL(get_candidate_unqid.agent_accepts_sevis)> checked="checked" </cfif>> Yes
                                            </td>
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
                                        	<td colspan="4" class="style2" bgcolor="8FB6C9">&nbsp;:: Arrival Verification</td>
                                        </tr>	
                                        <tr>
                                        	<td class="style1" width="52%" align="right"><label for="verification_address"><strong>House Address Verified:</strong></label></td>
                                            <td class="style1">
                                            	<input type="checkbox" name="verification_address" id="verification_address" value="1" class="formField" disabled <cfif VAL(get_candidate_unqid.verification_address)>checked="checked"</cfif> >
                                            </td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="verification_sevis"><strong>SEVIS Activated:</strong></label></td>
                                        	<td class="style1">
                                        		<input type="checkbox" name="verification_sevis" id="verification_sevis" value="1" class="formField" disabled <cfif VAL(get_candidate_unqid.verification_sevis)>checked="checked"</cfif> >
                                        	</td>
                                        </tr>
                                        <tr>
                                        	<td class="style1" align="right"><label for="verification_arrival"><strong>Arrival Questionaire Received:</strong></label></td>
                                            <td class="style1">
                                                <input type="checkbox" name="verification_arrival" id="verification_arrival" value="1" class="formField" disabled <cfif VAL(get_candidate_unqid.verification_arrival)>checked="checked"</cfif> >
                                            </td>
                                        </tr>
                        			</table>
                                    
                                </td>
                            </tr>
                        </table> 

						<br />
                        
                    </td>
                    <!--- END OF RIGHT SECTION --->
                </tr>
        	</table>
        
            <!--- END OF INFORMATION SECTION ---> 
            
            <br/>

			<!---- EDIT/UPDATE BUTTONS ---->
            <cfif client.usertype LTE 4>
                
                <table width="800px" border="0" cellpadding="0" cellspacing="0" align="center">	
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

		</td>		
	</tr>
</table>
<!--- END OF TABLE HOLDER --->

</cfform>

</cfoutput>

</body>
</html>