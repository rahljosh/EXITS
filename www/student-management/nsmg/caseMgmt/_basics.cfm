<!--- ------------------------------------------------------------------------- ----
	File:		index.cfm
	Author:		Josh Rahl
	Date:		July 25, 2013
	Desc:		start a new case for student you visited the page from.
				
----- ------------------------------------------------------------------------- --->


<script type="text/javascript">
	$(document).ready(function(){
		$(".chzn-select").chosen(); 
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
	});


	function additionalInfo() {
		// Check if current state is visible
		var isVisible = $('#additionalInfoDiv').is(':visible');
			
		if ( isVisible ) {
			// handle visible state
			$("#newSchool").val(0);
			$("#additionalInfoDiv").fadeOut("slow");
			
			
		} else {
			// handle non visible state
			$("#newSchool").val(1);
			$("#additionalInfoDiv").fadeIn("slow");
		}

	}
</script>

<script type="text/javascript">
window.onload = function additionalInfo() {
		// Check if current state is visible
		var isVisible = $('#additionalInfoDiv').is(':visible');
			
		if ( isVisible ) {
			// handle visible state
			$("#newSchool").val(0);
			$("#additionalInfoDiv").fadeOut("fast");
			
			
		} else {
			// handle non visible state
			$("#newSchool").val(1);
			$("#additionalInfoDiv").fadeIn("slow");
		}

	}
</script>



<!----param needed variables---->
<cfparam name="url.student" default="">
<cfparam name="url.caseid" default="">
<cfparam name="form.caseSubject" default="">
<cfparam name="form.caseLevel" default="1">
<cfparam name="form.caseStatus" default="1">
<cfparam name="form.casePrivacy" default="1">
<cfparam name="form.caseDateOfIncident" default="#DateFormat(now(), 'yyyy-mm-dd')#">
<cfparam name="form.addNewStudent" default="">
<cfparam name="form.studentList" default="">
<cfparam name="form.caseOwner" default="#client.userid#">
<cfparam name="tagsInCase" default="">
<cfparam name="FORM.additionalInfoDiv" default="0">
<cfparam name="newCase" default="1">
<cfparam name="FORM.tags" default="">
<cfparam name="SESSION.studentList" default="">
<!----Open a New Case---->

<!----If first time, add current student to list---->
<Cfif not len(session.studentList)> 
  <cfset SESSION.studentList = ListAppend(session.studentList, url.studentid, ",")>
</Cfif>
<!---if case is open and adding more kids, we need to get kids already assigned to the case---->
<Cfif val(url.caseid) and not len(session.studentlist)>		
            <cfquery name="kidsInCase" datasource="#application.dsn#">
            select fk_studentid
            from smg_casemgmt_users_involved
            where fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value='#url.caseid#'>
            </cfquery>
            <cfloop query="kidsInCase">
                <cfset session.studentList = ListAppend(studentList,#fk_studentid#)>
            </cfloop>
            
</Cfif>
<!---Add Student to List---->
<cfif val(form.addNewStudent)>
	<cfif not ListFind(SESSION.studentList, form.addNewStudent,",")>
		<cfset SESSION.studentlist =  ListAppend(session.studentList, form.addNewStudent, ",")>
    </cfif>
</cfif>

<cfif isDefined('form.opencase')>

	<cfscript>    
            vCaseID = APPLICATION.CFC.CASEMGMT.openCase(studentList=SESSION.studentlist,
                                                        caseDateOfIncident=FORM.caseDateOfIncident,
                                                        caseSubject=FORM.caseSubject,
                                                        caseStatus=form.caseStatus,
                                                        casePrivacy=form.casePrivacy,
                                                        caseLevel=form.caseLevel,
														tags=form.tags,
														caseID=url.caseid,
														caseOwner=form.caseOwner); 
    </cfscript>
	<cfset session.studentlist = ''>
    <cflocation url="index.cfm?curdoc=caseMgmt/index&action=addDetails&caseID=#vCaseID#" addtoken="no">
    <cfabort>
</cfif>

<cfif val(url.caseid)>
	<cfset newCase = 0>
	<Cfquery name="caseDetails" datasource="#APPLICATION.dsn#">
    select *
    from smg_casemgmt_cases
    where caseID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.caseid#">
    </Cfquery>

		<cfscript>
			// Set FORM Values 
			FORM.caseSubject = caseDetails.caseSubject;
			FORM.caseLevel = caseDetails.caseLevel;
			FORM.caseStatus = caseDetails.caseStatus;
			FORM.casePrivacy = caseDetails.casePrivacy;
			FORM.caseDateOfIncident = caseDetails.caseDateOfIncident;
			FORM.caseowner = caseDetails.fk_caseOwner;
        </cfscript>

	<Cfif not len(SESSION.studentlist)>
		
            <cfquery name="kidsInCase" datasource="#application.dsn#">
            select fk_studentid
            from smg_casemgmt_users_involved
            where fk_caseid = <cfqueryparam cfsqltype="cf_sql_integer" value='#url.caseid#'>
            </cfquery>
            <cfloop query="kidsInCase">
                <cfset session.studentList = ListAppend(studentList,#fk_studentid#)>
            </cfloop>
    </Cfif>
	<cfquery name="currentTags" datasource="#APPLICATION.dsn#">
    select tagid
    from smg_casemgmt_case_tags
    where caseid = <cfqueryparam cfsqltype="cf_sql_integer" value='#url.caseid#'>
    </cfquery>
   
     <cfloop query="currentTags">
		<cfset tagsInCase = ListAppend(tagsInCase,#tagid#)>
    </cfloop>

</cfif>

<!---Add to list of students if adding more students
<cfif len(form.studentList)>
	<cfset studentList = #form.studentList#>
<cfelse>
	<cfset studentList = #url.studentid#>
</cfif>
<cfoutput>
#studentlist# <br />
</cfoutput>
---->
<!----
<cfif val(form.addNewStudent)  AND not ListFind(studentList, form.addNewStudent,",")>
	<cfset studentList = ListAppend(studentList, form.addNewStudent)>
</cfif>
---->

<!----Get list of users for Loop in and Case Ownership----->
<cfscript>
		//Student, Rep and Host Info
		qAvailableUsers = APPLICATION.CFC.CASEMGMT.availableUsers(regionID=client.regionid); 
</cfscript>
<!---Remove student from list... this is only available on new cases---->
<Cfif isDefined('form.removeStudent')>
	<cfset SESSION.studentList = ListDeleteAt( SESSION.studentList, (ListFind(SESSION.studentList,form.studentToRemove,",")), ",") />
</Cfif>

	<!----Information on students, this is only used on first case, tags are used for assigning tags to case---->
	<cfscript>
		//Student, Rep and Host Info
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentFullInformationByID(studentID=SESSION.studentList); 
		
		//Tags for the tag section
		qGetTags = APPLICATION.CFC.CASEMGMT.getTags(system='caseMgmt'); 
	</cfscript>
        <!----Other students that could be associated with this case---->
    <cfquery name="qGetOtherStudentsInRegion" datasource="#application.dsn#">
    select firstname, familylastname, studentid
    from smg_students
    where regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
    and active = 1
    </cfquery>


<cfquery name="caseStatus" datasource="#APPLICATION.dsn#">
    select *
    from smg_casemgmt_casestatus
    where isActive = 1
    </cfquery>
    
    <cfquery name="caseLevel" datasource="#APPLICATION.dsn#">
     select *
     from smg_casemgmt_caselevel
     where isActive = 1
    </cfquery>



 <Cfif newCase eq 1>
	<cfquery name="regionalManager" datasource="#application.dsn#">
    select u.userid, u.firstname, u.lastname
    from smg_users u
    left join user_access_rights uar on uar.userid = u.userid
    where uar.regionid = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
    and uar.usertype = <cfqueryparam cfsqltype="cf_sql_integer" value="5">
    </cfquery>
 </cfif>

<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Case Management</span> 
        <div style="float:right;"><img src="pics/betaTesting.png"></div> 
  </div>
    
    <div class="rdbox">
     <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />

       
<div class="boxWithTitle">
  <div id="title">Case Details</div>
  <cfoutput>
        <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
      	<input type="hidden" value="#studentList#" name="studentList" />
        
        <table width=95% border=0 align="Center" cellpadding="5" cellspacing="0">
        	<Tr>
            	<th colspan=4 align="left"></th>
                <th align="left" colspan=2>Case Owner:
                  <select name="caseOwner" data-placeholder="Enter ID or Name of Student" class="chzn-select" tabindex="2" size=20>
                       <option value=""></option>
                       <cfloop query="qAvailableUsers">
                       
                           <option value="#userid#" <Cfif form.caseOwner eq #userid#>selected</cfif>>#firstName# #lastname# (#userid#)</option>
                     
                       </cfloop>
                   </select>
                
                 </th>
            </Tr>
            <tr>
                <td colspan=6 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">Who's Involved</div>
                </td>
        	<tr>
            	<Th align="left">Student</Th> 
                <Th align="left">Program</Th>
                <th align="left">Host Family</th>
                <th align="left">Area Representative</th>
                <th align="left">Regional Manager</th>
                <th align="left"></th>
            </tr>
            
       <cfif val(newCase)>
        <Cfloop query="qGetStudentInfo">
        	<Tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
            	<td>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)</td>
                <td>#programname#</td>
                <td>#qGetStudentInfo.fatherfirstname# <cfif #qGetStudentInfo.fatherfirstname# is not ''>&amp;</cfif> #qGetStudentInfo.motherfirstname# #qGetStudentInfo.hostLastName# (#qGetStudentInfo.hostid#)</td>
                <td>#qGetStudentInfo.areaRepFirstName# #qGetStudentInfo.areaRepLastName# (#qGetStudentInfo.arearepid#) </td>  
                <td>#regionalManager.FirstName# #regionalManager.lastname# (#regionalManager.userid#)</td> 
                <td align="Center">
               	<cfif url.studentid neq #qGetStudentInfo.studentid#>
                	<form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                    <input type="hidden" value="#studentList#" name="studentList" />
                    <input type="hidden" value="#qGetStudentInfo.studentid#" name="studentToRemove" />
                     <font size="-50%"><input type="submit" name="removeStudent" value="Remove" class="basicRedButton"/></font>
                    </form>
                 </cfif>
                </td>
                
            </Tr>
        </Cfloop>
        	 
        </tr>    
      <cfelse>
      
      
     <Cfloop query="qUsersInvolved">
                <Tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                    <td>#stuFirstName# #stuLastName# (#studentid#)</td>
                    <td>#programName#</td>
                    <td>#fatherFirstname# <cfif #fatherFirstName# is not ''>&amp;</cfif> #motherFirstName# #hostLastName# (#hostid#)</td>
                    <td>#areaRepFirstName# #areaRepLastName# (#arearepid#) </td>  
                      <td>#regManFirstName# #regManLastName# (#regManid#) </td> 
                </Tr>
            </Cfloop>
        	
     
      
      </cfif>  
        </table>
    </cfoutput>
       <br />
    <div class="DotArrows"><div id="text">&#x25BC; <a onclick="additionalInfo();" href="##">Add More Students</a> &#x25BC;</div></div>
    <br><br>
    <Cfoutput>
  <div id="additionalInfoDiv" <!----style="display: none;"---->>

       <table width=95% border=0 align="Center" cellpadding="5" cellspacing="0">
         <tr bgcolor="##eae8e8">
       
           <td align="Center">Another student involved? Add them here:
                   <select name="addNewStudent" data-placeholder="Enter ID or Name of Student" class="chzn-select" tabindex="2" onchange="this.FORM.submit(addStudent);" size=20>
                       <option value=""></option>
                       <cfloop query="qGetOtherStudentsInRegion">
                       <cfif not ListFind(SESSION.studentList,studentid, ",")>
                           <option value="#studentID#">#firstName# #familylastname# - #studentID#</option>
                       </cfif>
                       </cfloop>
                   </select>
           </td>
             
           </tr>
          <tr>
          <td colspan=4 align="right">
           <div class="dottedLineBelow"><p style="text-align:center;">
               <input name="addStudent" id="addStudent" type="submit" value="Add Student"  alt="Add Student" border="0" class="basicOrangeButton" /></font></a></p></div>
           </td>
         </Tr>
        </table>
              </div>
       <br />
     
        <table width=95%  align="center" cellspacing="0"  cellpadding="5" >
          <tr>
                <td colspan=4 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">The Details</div>
                </td>
        	</tr>
        	<Tr>
            	<td align="center">
         <table border=0 align="center" cellspacing="0" cellpadding="8">
         	<Tr>
         		<td colspan=6>Date of Incident: <input type="date" name="caseDateOfIncident" value="#DateFormat(form.caseDateOfIncident,'yyyy-mm-dd')#"></td>
            </Tr>
         	<Tr>
            	<Td colspan=6>Subject: <input type="text" name="caseSubject" value="#form.caseSubject#" size=120 placeholder="Enter a brief summary of this case."></td>
            </Tr>
            <tr>
            	
                <td>Status:
                   
                   <select name="caseStatus">
                		<option value=''></option>
                        <cfloop query="caseStatus">
                		<option value='#id#' <cfif form.caseStatus eq #id#>selected</cfif>>#status#</option>
                        </cfloop>
                      
                    </select>
                </Td>
                <td>Level:
                   
                   <select name="caseLevel">
                		<option value=0></option>
                        <Cfloop query="caseLevel">
                		<option value=#id# <cfif form.caseLevel eq #id#>selected</cfif>>#caseLevel#</option>
						</Cfloop>
                    </select>
                </Td>
                <td>Privacy:
                
                    <select name="casePrivacy">
                		<option value=''></option>
                		<option value='1' <cfif form.casePrivacy eq '1'>selected</cfif>>Open</option>
                        <option value='2' <cfif form.casePrivacy eq '2'>selected</cfif>>Partial</option>
                        <option value='3' <cfif form.casePrivacy eq '3'>selected</cfif>>Limited</option>
                    </select>
                </Td>
         </tr>
           <tr>
            	<td colspan=3><strong>Tags</strong>:
                 <div>
                
                        <table>
                        	<tr>
                        <cfloop query="qGetTags">
                            	<td>
                            <input type="checkbox" name='tags' value='#id#' class="check-with-label" <cfif listFind(#tagsInCase#, #id#)>checked</cfif> />
                           <label style="font-weight: normal;" class="label-for-check">#tagName#</label>
                           		</td>
                            <cfif currentrow mod 5 eq 0>
                             </tr>
                             <tr>
                            </cfif>
                        </cfloop>
                		</table>
                      
                   </div>
                </Td>
                <td colspan=2>
                
                </Td>
         </tr>

         </table>
    </td>
  </tr>
   <tr>
           	<td colspan=4>
            	<div class="dottedLineAbove"><p style="text-align:right;">
                	<a href="?curdoc=caseMgmt/index&action=viewCase&caseID=#url.caseid#&studentid=#url.studentid#&reset" class="basicOrangeButton">Cancel</a>
                    
                    &nbsp; &nbsp; &nbsp; &nbsp;  
                	<cfif val(url.caseID)>
                    	 <input name="openCase" id="openCase" type="submit" value="Update Case"  alt="Open Case" border="0" class="basicOrangeButton" />
                    <cfelse>
                    	<input name="openCase" id="openCase" type="submit" value="Open Case"  alt="Open Case" border="0" class="basicOrangeButton" />    
                    </cfif>
                     </p></div>
                
               
            </td>
          </Tr>
</table>
        
    </form> 
     </cfoutput></div>

  </div>
  <div class="rdbottom"></div> <!-- end bottom --> 
</div>
   