<cfquery name="check_state" datasource="MySql">
	SELECT statechoiceid, studentid, state1, state2, state3
	FROM smg_student_app_state_requested
	WHERE studentid =  <cfqueryparam value="#client.studentid#" cfsqltype="cf_sql_integer">
</cfquery>
<cfquery name="check_guarantee" datasource="MySQL">
	SELECT app_region_guarantee
	FROM smg_students
	WHERE studentid = '#client.studentid#'
</cfquery>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link rel="stylesheet" type="text/css" href="app.css">
	<title>Page [21] - State Choice</title>
</head>
<body <cfif check_state.recordcount GT '0' AND check_state.state1 GT '0'>onLoad="hideAll(); changeDiv('1','block');"</cfif>>

<!--- relocate users if they try to access the edit page without permission --->
<cfinclude template="../querys/get_latest_status.cfm">

<cfif (client.usertype EQ 10 AND (get_latest_status.status GTE 3 AND get_latest_status.status NEQ 4 AND get_latest_status.status NEQ 6))  <!--- STUDENT ---->
	OR (client.usertype EQ 11 AND (get_latest_status.status GTE 4 AND get_latest_status.status NEQ 6))  <!--- BRANCH ---->
	OR (client.usertype EQ 8 AND (get_latest_status.status GTE 6 AND get_latest_status.status NEQ 9)) <!--- INTL. AGENT ---->
	OR (client.usertype GTE 5 AND client.usertype LTE 7 OR client.usertype EQ 9)> <!--- FIELD --->
    <!--- Office users should be able to edit online apps --->
    <!--- OR (client.usertype LTE 4 AND get_latest_status.status GTE 7) <!--- OFFICE USERS ---> --->
	<cflocation url="?curdoc=section4/page21print&id=4&p=21" addtoken="no">
</cfif>

<!-----Script to show certain fileds---->
<script type="text/javascript">
<!--
function changeDiv(the_div,the_change)
{
  var the_style = getStyleObject(the_div);
  if (the_style != false)
  {
    the_style.display = the_change;
  }
}
function hideAll()
{
  changeDiv("1","none");
  changeDiv("2","none");
}
function getStyleObject(objectId) {
  if (document.getElementById && document.getElementById(objectId)) {
    return document.getElementById(objectId).style;
  } else if (document.all && document.all(objectId)) {
    return document.all(objectId).style;
  } else {
    return false;
  }
}
function CheckLink()
{
  if (document.page21.CheckChanged.value != 0)
  {
    if (confirm("You have made changes on this page that have not been submited.\n\These changes will be lost if you navigate away from this page.\n\Click OK to contine and discard changes, or click cancel and submit to save your changes."))
      return true;
    else
      return false;
  }
}
function DataChanged() {
  document.page21.CheckChanged.value = 1;
}
function CheckStates() {
	if ((document.page21.state_select[0].checked) && ((document.page21.state1.value == '0') || (document.page21.state2.value == '0') ||  (document.page21.state3.value == '0'))) {
	 	alert("If you would like a State Choice, you must select three options.");
		  return false; }			  	
}
function NextPage() {
	document.page21.action = '?curdoc=section4/qr_page21&next';
	}
//-->
</script>
<!--- 
	if ( (document.page21.state_select[0].checked) && ((document.page21.state1.value == document.page21.state2.value) || (document.page21.state1.value == document.page21.state3.value) ||  (document.page21.state2.value == document.page21.state3.value))) {
	 	alert("You must select 3 different states, please review your choices and submit this page again.");
		  return false; }
	alert("If you would like a State Preference, you must select three different options."); 
--->

<Cfset doc = 'page21'>

<cfinclude template="../querys/get_student_info.cfm">
<cfset closedList = ''>
<!---- International Rep - EF ACCOUNTS ---->
<cfquery name="int_agent" datasource="MySQL">
	SELECT u.businessname, u.userid, u.master_account, u.master_accountid
	FROM smg_users u
	WHERE u.userid = <cfif get_student_info.branchid EQ '0'>'#get_student_info.intrep#'<cfelse>'#get_student_info.branchid#'</cfif>
</cfquery>


<cfquery name="states" datasource="#application.dsn#">
select s.statename, s.id
from smg_states s
where (s.id < 52 AND s.id !=11 and s.id !=2)
</cfquery>

<Cfquery name="statesClosed" datasource="#application.dsn#">
select sc.fk_stateID, s.statename
from regionStateClosure sc 
LEFT join smg_states s on s.id = sc.fk_stateID
where  sc.fk_programid = #get_student_info.programid#
<Cfif client.companyid lte 5 or client.companyid eq 12>
and sc.fk_companyid = 1
<Cfelse>
and sc.fk_companyid = #client.companyid#
</Cfif>
</cfquery>

<Cfloop query="statesClosed">
	<cfset closedList = #ListAppend(closedList, fk_stateID)#>
</Cfloop>

<cfquery name="check_if_answered" datasource="MySQL">
	SELECT smg_students.regionalguarantee, smg_students.regionguar, smg_regions.regionname
	FROM smg_students, smg_regions
	WHERE studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
</cfquery>

<cfquery name="states_requested" datasource="MySQL">
	SELECT 
    	state1, 
        sta1.statename as statename1, 
        state2, 
        sta2.statename as statename2, 
        state3, 
        sta3.statename as statename3
	FROM 
    	smg_student_app_state_requested 
	LEFT JOIN 
    	smg_states sta1 ON sta1.id = state1
	LEFT JOIN 
    	smg_states sta2 ON sta2.id = state2
	LEFT JOIN 
    	smg_states sta3 ON sta3.id = state3
	WHERE 
    	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
</cfquery>

<cfquery name="qESIDistrictChoice" datasource="MySQL">
	SELECT 
    	option1, 
        option2, 
        option3
	FROM 
    	smg_student_app_options 
	WHERE 
    	studentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_student_info.studentid#">
    AND
    	fieldKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="ESIDistrictChoice">
</cfquery>

<cfscript>
	// Get List of Canada Districts
	qGetESIDistrictChoice = APPLICATION.CFC.LOOKUPTABLES.getApplicationLookUp(
		applicationID=APPLICATION.CONSTANTS.type.publicHighSchool,
		fieldKey='ESIDistrictChoice',
		sortBy='sortOrder'
	);
</cfscript>

<!--- HEADER OF TABLE --->
<table width="100%" cellpadding="0" cellspacing="0">
	<tr height="33">
		<td width="8" class="tableside"><img src="pics/p_topleft.gif" width="8"></td>
		<td width="26" class="tablecenter"><img src="../pics/students.gif"></td>
		<td class="tablecenter"><h2>Page [21] - <cfif CLIENT.companyID NEQ 14>State<cfelse>District</cfif> Choice </h2></td>
		<!--- Do not display for Canada Application --->
        <cfif NOT ListFind("14,15,16", get_student_info.app_indicated_program)> 
	        <td align="right" class="tablecenter"><a href="" onClick="javascript: win=window.open('section4/page21print.cfm', 'Reports', 'height=600, width=800, location=no, scrollbars=yes, menubars=no, toolbars=yes, resizable=yes'); win.opener=self; return false;"><img src="pics/printhispage.gif" border="0" alt="Click here to print this page"></img></A>&nbsp; &nbsp;</td>
		</cfif>
    	<td width="42" class="tableside"><img src="pics/p_topright.gif" width="42"></td>
	</tr>
</table>

<cfoutput>

<cfform method="post" name="page21" action="?curdoc=section4/qr_page21" onSubmit="return CheckStates();">
<!--- NOT ESI / PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
<cfif check_guarantee.app_region_guarantee gt 0> 
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>You have already requested a Region Preference.  You can not select both a Regional and State Preference.  If you would like to request a State Preference, please remove your requested Region Preference. </td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>	
</cfif>
<!--- NOT ESI / PROGRAM TYPES 1 = AYP 10 AUG / 2 = AYP 5 AUG / 3 = AYP 5 JAN / 4 = AYP 12 JAN --->
<cfif CLIENT.companyID NEQ 14 AND NOT ListFind("7,8,10,11", get_student_info.app_current_status) AND (DateFormat(now(), 'mm') EQ 4 ) AND (get_student_info.app_indicated_program EQ '1' OR get_student_info.app_indicated_program EQ '2')> 
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>State Choices are no longer available.</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>	
</cfif>

<cfinput type="hidden" name="studentid" value="#get_student_info.studentid#">
<cfinput type="hidden" name="CheckChanged" value="0">

<!--- HIDE GUARANTEE FOR EF AND INTERSTUDIES 8318 --->
<cfif IsDefined('client.usertype') AND client.usertype EQ 10 AND (int_agent.master_accountid EQ 10115 OR int_agent.userid EQ 10115 OR int_agent.userid EQ 8318)>
	<div class="section"><br><br>
	<table width="670" cellpadding=2 cellspacing=0 align="center">
		<tr>
			<td>Currently, you are unable to request a State Choice online.  You are still able to request them, you just need to contact your
			#int_agent.businessname# Representative.  Contact information is listed above.  
			</td>
		</tr>
	</table><br><br>
	</div>
	<!--- FOOTER OF TABLE --->
	<cfinclude template="../footer_table.cfm">
	<cfabort>
</cfif>


<!--- Do not display for Canada Application --->
<cfif ListFind("14,15,16", get_student_info.app_indicated_program)> 

    <div class="section"><br>
        <br><Br><br>
        <h2 align=center>This page does not apply to your program.</h2>
        <Br><br><BR>
    </div>

<cfelse>

    <div class="section"><br>

        <!--- Check uploaded file - Upload File Button --->
        <cfinclude template="../check_uploaded_file.cfm">
        
        <table width="670" border=0 cellpadding=3 cellspacing=0 align="center">
            <tr>
                <td>
                    <div align="justify"><cfinclude template="state_guarantee_text.cfm"></div>
                    
                    <cfif CLIENT.companyID NEQ 14>
                        <!--- Regular State Guarantee Choice --->
                        
                        <table>
                            <tr>
                                <td>State Choice Price:</td>
                                <td>Please contact your rep for current prices for state guarantees.</td>
                            </tr>
                        </table>
                        <img src="pics/usa-map.gif" width="642" height="331" align="middle"><br>
                        
                        <input type="radio" name="state_select" id="stateSelectYes" value="yes" onClick="hideAll(); changeDiv('1','block'); DataChanged();" <cfif check_state.recordcount GT '0' AND check_state.state1 GT '0'>checked</cfif> >
                        <label for="stateSelectYes">Yes, submit my choices as indicated below.</label>
                        <input type="radio" name="state_select" id="stateSelectNo" value="no" onClick="hideAll(); changeDiv('2','block'); DataChanged();" <cfif check_state.recordcount NEQ '0' AND check_state.state1 EQ '0'>checked</cfif> >
                        <label for="stateSelectNo">No, I am not interested in a state choice.</label>
                            
                        <div id ="1" style="display:none"><br>
                            <table>
                            	<tr>
                                	<Td colspan=6 bgcolor="##FFFFCC">If you already have made a state selection and are making a change:  If your current selection is no longer showing in the drop down and you make a change, you will NOT be able to re-select your current state. 
                                </tr>
                                <tr>
                                <td>1st:</td>
                                <td>
                               Selected: 
                                 <Cfquery name="State1" datasource="#application.dsn#">
                                     select statename
                                     from smg_states
                                     where id = #val(states_requested.state1)#
                                 </cfquery>
                              	<cfif val(states_requested.state1)>
                                    <strong>#state1.statename#</strong>
								<cfelse>
                                 	<strong>No State Selected</strong>
                                 </cfif>  <br>
                                    
                               
                                 
                                <cfif get_student_info.app_current_status lte 7>
                                 Available:
                                <cfselect name="state1" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="states">
                                        	<cfif not ListFind(closedList, id)>
                                        		<option value="#id#" <cfif states_requested.state1 EQ id> selected </cfif> >#statename#</option>
                                        	</cfif>
                                        </cfloop>
                                    </cfselect>
                                 <cfelse>
                                	 <input type="hidden" name="state1" value="#val(states_requested.state1)#"><br>
                                 </cfif>
                                 
                                </td>
                                <td>&nbsp; 2nd:</td>
                                <td>
                                 Selected:
                                 <Cfquery name="State2" datasource="#application.dsn#">
                                     select statename
                                     from smg_states
                                     where id = #val(states_requested.state2)#
                                 </cfquery>
                              	<cfif val(states_requested.state2)>
                                	<strong>#state2.statename#	</strong>                                    
								<cfelse>
                                 	<strong>No State Selected</strong>
                                 </cfif>   
                                  <br>
                                 
                                <cfif get_student_info.app_current_status lte 7>
                                Available:
                                <cfselect name="state2" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="states">
                                        	<cfif not ListFind(closedList, id)>
                                            	<option value="#id#" <cfif states_requested.state2 EQ id> selected </cfif> >#statename#</option>
                                        	</cfif>
                                        </cfloop>
                                    </cfselect>
                               <cfelse>
                                	 <input type="hidden" name="state2" value="#val(states_requested.state2)#"><br>
                                 </cfif>
                               
                                </td>
                                <td>&nbsp; 3rd:</td>
                                <td>
                                Selected:
                                 <Cfquery name="State3" datasource="#application.dsn#">
                                     select statename
                                     from smg_states
                                     where id = #val(states_requested.state3)#
                                 </cfquery>
                                 <cfif val(states_requested.state3)>
                              		<strong>#state3.statename#</strong>
                                 <cfelse>
                                 	<strong>No State Selected</strong>
                                  
                                 </cfif>
                                    
                                    	
                                 
                                <br>
                                 <cfif get_student_info.app_current_status lte 7>
                                 Available:
                                 <cfselect name="state3" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="states">
                                        	<cfif not ListFind(closedList, id)>
                                       			<option value="#id#" <cfif states_requested.state3 EQ id> selected </cfif> >#statename#</option>
                                        	</cfif>
                                        </cfloop>
                                    </cfselect>
                                  <cfelse>
                                	 <input type="hidden" name="state3" value="#val(states_requested.state3)#"><br>
                                  </cfif>
                            
                                </td>							
                                </tr>
                            </table>
                        </div>
        
                        <div id=2 style="display:none"><br>
                            Assign me to any state in the United States, do NOT put me down for a State Choice.
                        </div>
                        
                    <cfelse>
                        <!--- Exchange Service International Application --->
                        
                        <img src="pics/ESI-Map.gif" width="650" height="369" align="middle"><br>
                        
                        <table cellpadding="2" cellspacing="2" style="margin:10px;">
                            <tr>
                                <td>1st Choice:</td>
                                <td><select name="option1" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="qGetESIDistrictChoice">
                                        	<option value="#qGetESIDistrictChoice.fieldID#" <cfif qESIDistrictChoice.option1 EQ qGetESIDistrictChoice.fieldID>selected</cfif>>#qGetESIDistrictChoice.sortOrder# - #qGetESIDistrictChoice.name#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr>                        
                                <td>2nd Choice:</td>
                                <td><select name="option2" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="qGetESIDistrictChoice">
                                        	<option value="#qGetESIDistrictChoice.fieldID#" <cfif qESIDistrictChoice.option2 EQ qGetESIDistrictChoice.fieldID>selected</cfif>>#qGetESIDistrictChoice.sortOrder# - #qGetESIDistrictChoice.name#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr>                        
                                <td>3rd Choice:</td>
                                <td><select name="option3" onClick="DataChanged();">
                                        <option value="0"></option>
                                        <cfloop query="qGetESIDistrictChoice">
                                        	<option value="#qGetESIDistrictChoice.fieldID#" <cfif qESIDistrictChoice.option3 EQ qGetESIDistrictChoice.fieldID>selected</cfif>>#qGetESIDistrictChoice.sortOrder# - #qGetESIDistrictChoice.name#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr> 
                        </table>
                        
                    </cfif>
                    
                </td>
            </tr>
        </table><br><br>
    
    </div>
     
    <!--- PAGE BUTTONS --->
    <cfinclude template="../page_buttons.cfm">

</cfif>
    

</cfform>

</cfoutput>

<!--- FOOTER OF TABLE --->
<cfinclude template="../footer_table.cfm">
