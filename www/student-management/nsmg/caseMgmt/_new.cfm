<!--- ------------------------------------------------------------------------- ----
	File:		index.cfm
	Author:		Josh Rahl
	Date:		July 25, 2013
	Desc:		start a new case for student you visited the page from.
				
----- ------------------------------------------------------------------------- --->
        <style type="text/css">
.boxWithTitle {
	font-family: Arial, Helvetica, sans-serif;
	margin: 15px;
	padding: 15px;
	height: auto;
	width: 70%;
	border: medium solid #CCC;
	Margin-right: auto;
	Margin-left: auto;
	min-width:600px;
}

#title {
font-family: Arial, Helvetica, sans-serif;
font-size: 16px;
color: #999;
background-color: #FFF;
position: relative;
z-index: 25;
top: -25px;
min-width:200px;
width:15%;

padding-right: 10px;
padding-left: 10px;
}
.dottedLineAbove {
	padding-top: 8px;
	border-top-width: thin;
	border-top-style: dashed;
	border-top-color: #CCC;
	width: 100%;
}
.dottedLineBelow {
	padding-bottom: 8px;
	border-bottom-width: thin;
	border-bottom-style: dashed;
	border-bottom-color: #CCC;
	width: 100%;
}


</style>

<script type="text/javascript">
	$(document).ready(function(){
		$(".chzn-select").chosen(); 
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
	});
</script>

<!----param needed variables---->
<cfparam name="url.student" default="">
<cfparam name="form.caseSubject" default="">
<cfparam name="form.caseLevel" default="">
<cfparam name="form.caseStatus" default="1">
<cfparam name="form.casePrivacy" default="">
<cfparam name="form.caseDateOfIncident" default="">
<cfparam name="form.addNewStudent" default="">
<cfparam name="form.studentList" default="">
<cfparam name="url.caseid" default="">


<!----Open a New Case---->
<cfif isDefined('form.opencase')>
	<cfscript>
    
            vCaseID = APPLICATION.CFC.CASEMGMT.openCase(studentList=form.studentlist,
                                                        caseDateOfIncident=FORM.caseDateOfIncident,
                                                        caseSubject=FORM.caseSubject,
                                                        caseStatus=form.caseStatus,
                                                        casePrivacy=form.casePrivacy,
                                                        caseLevel=form.caseLevel); 
    </cfscript>
    
    <cflocation url="index.cfm?curdoc=caseMgmt/index&action=addDetails&caseID=#vCaseID#" addtoken="no">
    
 
    <cfabort>
</cfif>

<!---Add to list of students if adding more students---->
<cfif len(form.studentList)>
	<cfset studentList = #form.studentList#>
<cfelse>
	<cfset studentList = #url.studentid#>
</cfif>
	<cfset studentList = ListAppend(studentList, #form.addNewStudent#)>

<cfif val(studentList)>
	<cfscript>
		//Student, Rep and Host Info
		qGetStudentInfo = APPLICATION.CFC.STUDENT.getStudentFullInformationByID(studentID=studentList); 
		
		//Tags for the tag section
		qGetTags = APPLICATION.CFC.CASEMGMT.getTags(system='caseMgmt'); 
	</cfscript>
    
    <cfquery name="qGetOtherStudentsInRegion" datasource="#application.dsn#">
    select firstname, familylastname, studentid
    from smg_students
    where regionassigned = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetStudentInfo.regionassigned#">
    and active = 1
    </cfquery>


</cfif>

      
    
<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Case Management</span> 
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
  <div id="title">Create New Case</div>
  <cfoutput>
        <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
      	<input type="hidden" value="#studentList#" name="studentList" />
        
        <table width=95% border=0 align="Center" cellpadding="5" cellspacing="0">
        	<Tr>
            	<th colspan=3 align="left"></th>
                <th align="left">Case Owner: #client.name#</th>
            </Tr>
            <tr>
                <td colspan=4 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">Who's Involved</div>
                </td>
        	<tr>
            	<Th align="left">Student</Th><th align="left">Host Family</th><th align="left">Regional Manager</th><th align="left">Area Representative</th>
            </tr>
        <Cfloop query="#qGetStudentInfo#">
        	<Tr>
            	<td>#qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.studentid#)</td>
                <td>#qGetStudentInfo.fatherfirstname# <cfif #qGetStudentInfo.fatherfirstname# is not ''>&amp;</cfif> #qGetStudentInfo.motherfirstname# #qGetStudentInfo.familylastname# (#qGetStudentInfo.hostid#)</td>
                <td><!----#qGetStudentInfo.areaRepFirstName#----></td>
                <td>#qGetStudentInfo.areaRepFirstName# #qGetStudentInfo.areaRepLastName# (#qGetStudentInfo.arearepid#) </td>   
            </Tr>
        </Cfloop>
          <tr bgcolor="##eae8e8">
         	
            	<td align="right">Another student involved? Add them here:</td><td colspan=3>
                    <select name="addNewStudent" data-placeholder="Enter ID or Name of Student" class="chzn-select xxLargeField" tabindex="2" onchange="this.FORM.submit(addStudent);" size=20>
                        <option value=""></option>
                        <cfloop query="#qGetOtherStudentsInRegion#">
                            <option value="#studentID#">#firstName# #familylastname# - #studentID#</option>
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
         		<td>Date of Incident: <input type="date" name="caseDateOfIncident" value="#form.caseDateOfIncident#"></td>
            </Tr>
         	<Tr>
            	<Td colspan=6>Subject: <input type="text" name="caseSubject" value="#form.caseSubject#" size=120 placeholder="Enter a brief summary of this case."></td>
            </Tr>
            <tr>
            	<td>Level:</td>
                <Td><select name="caseLevel">
                		<option value=0></option>
                		<option value=1 <cfif form.caseLevel eq 1>selected</cfif>>Level 1</option>
                        <option value=2 <cfif form.caseLevel eq 2>selected</cfif>>Level 2</option>
                        <option value=3 <cfif form.caseLevel eq 3>selected</cfif>>Level 3</option>
                    </select>
                </Td>
                <td>Status:</td>
                <Td><select name="caseStatus">
                		<option value=''></option>
                		<option value='1' <cfif form.caseStatus eq '1'>selected</cfif>>Open</option>
                        <option value='2' <cfif form.caseStatus eq '2'>selected</cfif>>Pending</option>
                        <option value='3' <cfif form.caseStatus eq '3'>selected</cfif>>Closed</option>
                    </select>
                </Td>
                <td>Privacy:</td>
                <Td><select name="casePrivacy">
                		<option value=''></option>
                		<option value='1' <cfif form.casePrivacy eq '1'>selected</cfif>>Open</option>
                        <option value='2' <cfif form.casePrivacy eq '2'>selected</cfif>>Partial</option>
                        <option value='3' <cfif form.casePrivacy eq '3'>selected</cfif>>Limited</option>
                    </select>
                </Td>
         </tr>
           <tr>
            	<td>Tags:</td>
                <Td><select name="availTags">
                		<option value=0></option>
                        <cfloop query="qGetTags">
                			<option value=#id#>#tagName#</option>
                       	</cfloop>  
                       
                    </select>
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
                	<input name="cancelCase" id="cancelCase" type="submit" value="Cancel"  alt="Cancel" border="0" class="basicOrangeButton" />&nbsp; &nbsp; &nbsp; &nbsp;  
                	<input name="openCase" id="openCase" type="submit" value="Open Case"  alt="Open Case" border="0" class="basicOrangeButton" /></p></div>
                
               
            </td>
          </Tr>
</table>
        
    </form> 
     </cfoutput></div>

  </div>
  <div class="rdbottom"></div> <!-- end bottom --> 
</div>
   