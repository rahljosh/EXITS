<!--- ------------------------------------------------------------------------- ----
	
	File:		visaInterview.cfm
	Author:		James Griffiths
	Date:		July 30, 2013
	Desc:		Visa Interview list - shows all candidates that are missing a date 
				for their Visa Interview and allows the dates to be added.	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.intRep" default="0">
    <cfparam name="FORM.programID" default="0">

	<!--- Import CustomTag --->
    <cfimport taglib="/extensions/customTags/gui/" prefix="gui" /> 

    <cfsetting requesttimeout="9999">
    
    <cfscript>
		// Get International Representative List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	
		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		// Get Results
		if (VAL(FORM.submitted)) {
			qGetResults = APPLICATION.CFC.CANDIDATE.getMissingVisaInterviewStudentList(intRep=FORM.intRep,programID=FORM.programID);	
		}
	</cfscript>
    
	<cfquery name="qGetStateList" datasource="#APPLICATION.DSN.Source#">
        SELECT id, state, stateName
        FROM smg_states
      	ORDER BY stateName
    </cfquery>
    
</cfsilent>

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extensions.components.candidate" jsclassname="candidate">

<script type="text/javascript">
	var setVisaInterviewDate = function(candidateID) {
		// Create an instance of the proxy. 
		var c = new candidate();	
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(visaInterviewDateSet(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		c.setVisaInterviewDate(candidateID,$("#"+candidateID+"_date").val());
	}
	
	var visaInterviewDateSet = function(candidateID) {
		// Set up page message, fade in and fade out after 2 seconds
		$("#candidateDetailMessage").text("Visa Interview Date for candidate #" + candidateID + " set").fadeIn().fadeOut(3000);
		// Fade out record from search list
		//$("#" + candidateID).fadeOut("slow");
	}
	
	var myErrorHandler = function(statusCode, statusMsg) { 
		alert('Status: ' + statusCode + ', ' + statusMsg); 
	}
	
</script>


<style>
	input { 
		border: 1px solid #999; 
		margin-bottom: 0.5em;  
	}
	
	select {
		border: 1px solid #999; 
		margin-bottom: .5em;
	}
	
	.listTable {
		width:95%;
		padding:10px 15px 10px 15px;
		border:1px solid #CCCCCC;
		margin-top:10px;
		margin-bottom:10px;
		font-size: 0.9em;
	}
			
	.listTitle { 
		font-weight:bold;
		background-color:#4F8EA4;
	}

	.rowOn {
		background-color:#e9ecf1;
	}
	
	.rowOff {
		background-color:#FFFFFF;
	}
	
	.formTitle { 
		padding-top:10px;
		font-weight:800;
	}

	.largeField {
		width:250px;
	}

	.smallField {
		width:120px;
	}

	.pageMessage {
		display:none;
		margin:10px 0px 10px 0px;
		text-align:center;
		font-weight:bold;
		color:#006699;
	}

	.verList {
		display:none;
	}

	.candidateDetail {
		font-size:1.1em;
		font-family:Georgia, "Times New Roman", Times, serif;
		display:none;
		padding-top:10px;
	}
</style>

<cfoutput>

	<!--- Table Header --->    
    <gui:tableHeader
        tableTitle="Visa Interview"
    />

	<!--- This holds the candidate information messages --->
    <div id="candidateDetailMessage" class="pageMessage"></div>

    <!--- List Options --->
    <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
        <tr>
            <td class="formTitle">
            	<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" name="form" id="theForm" onSubmit="return formValidation()">
					<input type="hidden" name="submitted" value="1" />
					<cfif ListFind("1,2,3,4", CLIENT.userType)>
                        International Representative: 
                        &nbsp;
                        <select name="intRep" id="intRep" onchange="$('##theForm').submit()">
                            <option value="0">All</option>
                            <cfloop query="qIntlRep">
                                <option value="#qIntlRep.userID#" <cfif FORM.intRep EQ userID> selected="selected" </cfif> >#qIntlRep.businessName#</option>
                            </cfloop>
                        </select>
                    <cfelse>
                        <cfloop query="qIntlRep">
                            <cfif userID EQ VAL(CLIENT.userID)>
                                <input type="hidden" name="intRep" id="intRep" value="#userID#"/>
                            </cfif>
                        </cfloop>
                    </cfif>
                    &nbsp;
                    &nbsp;	
                    Program:
                    <select name="programID" id="programID">
                        <option value="0">All</option>
                        <cfloop query="qGetProgramList">
                            <option value="#programID#" <cfif FORM.programID EQ programID>selected="selected"</cfif> >#programname#</option>
                        </cfloop>
                    </select>
                    &nbsp;
                    <input type="submit" value="Submit"/>
              	</form>
            </td>                
        </tr>   
         
    </table>

    <!--- Visa Interview List --->
    <cfif VAL(FORM.submitted)>
        <table cellpadding="4" cellspacing="0" align="center" class="section" width="95%">
            <tr>
                <td class="listTitle style2">ID</td>
                <td class="listTitle style2">Last Name</td>
                <td class="listTitle style2">First Name</td>
                <td class="listTitle style2">Email</td>
                <td class="listTitle style2">Gender</td>
                <td class="listTitle style2">Country</td>
                <td class="listTitle style2">DS 2019</td>
                <td class="listTitle style2">Intl. Rep.</td>
                <td class="listTitle style2">Program</td>
                <td class="listTitle style2">Program <br /> Start Date</td>
                <td class="listTitle style2">Program <br /> End Date</td>
                <td class="listTitle style2" align="center">Visa Interview Date</td>                                                       
            </tr>
            
            <cfif NOT VAL(qGetResults.recordCount)>
            	<tr><th colspan='13'>Your search did not return any results.</th></tr>
         	<cfelse>
            	<cfloop query="qGetResults">
              		<tr id="#candidateID#" <cfif currentRow % 2 EQ 0>class="rowOff"<cfelse>class="rowOn"</cfif>>
                        <td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=#uniqueID#" class="style4" target="_blank">###candidateID#</a></td>
                        <td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=#uniqueID#" class="style4" target="_blank">#lastName#</a></td>
                        <td class="style5"><a href="?curdoc=candidate/candidate_info&uniqueID=#uniqueID#" class="style4" target="_blank">#firstName#</a></td>
                        <td class="style5">#email#</td>
                        <td class="style5">#sex#</td>
                        <td class="style5">#countryName#</td>
                        <td class="style5">#ds2019#</td>
                        <td class="style5">#businessName#</td>
                        <td class="style5">#programName#</td>
                        <td class="style5">#startDate#</td>
                        <td class="style5">#endDate#</td>
                        <td align="center" class="style5"><input id="#candidateID#_date" value="#visaInterview#" type="text" class="datePicker" onchange="setVisaInterviewDate(#candidateID#)"/></td>
                	</tr>
                </cfloop>
       		</cfif>
        </table>
  	</cfif>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    
