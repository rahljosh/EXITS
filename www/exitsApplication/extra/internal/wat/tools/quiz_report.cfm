<!--- ------------------------------------------------------------------------- ----
	
	File:		montlyEvaluations.cfm
	Author:		Marcus Melo
	Date:		July 7, 2011
	Desc:		Monthly Evaluation Update Tool 

	Updated:  	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

	<!--- Import CustomTag --->
    <cfimport taglib="/extensions/customTags/gui/" prefix="gui" />
    
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.intlRep" default="0">
    <cfparam name="FORM.programID" default="0">
    <cfparam name="FORM.evaluationID" default="0">
    <cfparam name="FORM.reportType" default="0">
    
    <cfscript>
		// Get International Representatives List
		qIntlRep = APPLICATION.CFC.USER.getIntlRepAssignedToCandidate();	

		// Get Program List
		qGetProgramList = APPLICATION.CFC.PROGRAM.getPrograms(companyID=CLIENT.companyID);
		
		if (VAL(FORM.submitted)) {
			qGetEvaluationList = APPLICATION.CFC.CANDIDATE.getMonthlyEvaluationList(
				intRep=FORM.intlRep,
				programID=FORM.programID,
				evaluationID=FORM.evaluationID,
				reportType=FORM.reportType);
		}
	</cfscript>
    
</cfsilent>    

<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extensions.components.candidate" jsclassname="candidate">

<script type="text/javascript">
	// Function to find the index in an array of the first entry with a specific value. 
	// It is used to get the index of a column in the column list. 
	Array.prototype.findIdx = function(value){ 
		for (var i=0; i < this.length; i++) { 
			if (this[i] == value) { 
				return i; 
			} 
		} 
	}
	
	$(document).ready(function() {
	
		// JQuery Modal
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:true
		});
		
	});
	
	var evaluationTrackingPopup = function(unqID, trackID) {
		var url = "candidate/evaluation_tracking.cfm?uniqueID=" + unqID + "&id=" + trackID;
		$(".jQueryModal").colorbox( {
			width:"50%", 
			height:"60%", 
			iframe:true,
			overlayClose:false,
			escKey:false,
			href:url,
			onClosed:function(){}
		});	
	}
	
	// --- START OF VERICATION RECEIVED --- //
	var setEvaluationReceived = function(candidateID, evaluationID) {
		
		// Create an instance of the proxy. 
		var c = new candidate();

		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		c.setCallbackHandler(checkInReceived(candidateID)); 
		c.setErrorHandler(myErrorHandler); 
		
		// This time, pass the intlRep ID to the getCandidateList CFC function. 
		c.confirmEvaluationReceived(candidateID, evaluationID);
		
	}
	
	var checkInReceived = function(candidateID) {
		
		// Set up page message, fade in and fade out after 2 seconds
		$("#updateMessage").text("Evaluation for candidate #" + candidateID + " received").fadeIn().fadeOut(3000);

		// Fade out record from search list
		$("#" + candidateID).fadeOut("slow");
		
	}
	// --- END OF VERICATION RECEIVED --- //

	// Error handler for the asynchronous functions. 
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
        tableTitle="Quiz Results"
    />

	<!--- This holds the candidate information messages --->
    <div id="updateMessage" class="pageMessage"></div>

    <!--- List Options --->
    <form action="" method="post" enctype="multipart/form-data">
    	<input type="hidden" name="submitted" value="1" />
        
        <table cellpadding="0" cellspacing="0" align="center" class="section listTable">
            <tr>
                <td class="formTitle">
                    Intl. Rep: 
                    &nbsp;
                    <select name="intlRep" id="intlRep" onchange="getCandidateList();">
                        <option value="">All</option>
                        <cfloop query="qIntlRep">
                            <option value="#qIntlRep.userID#" <cfif FORM.intlRep EQ qIntlRep.UserID>selected="selected"</cfif> >
                                <cfif LEN(qIntlRep.businessName) GT 50>
                                    #MID(qIntlRep.businessName,1,50)#...
                                <cfelse>
                                    #qIntlRep.businessName#
                                </cfif>
                            </option>
                        </cfloop>
                    </select>
                </td>
                <td class="formTitle">	
                    Program:
                    <select name="programID" id="programID">
                        <option value="">All</option>
                        <cfloop query="qGetProgramList">
                            <option value="#programID#" <cfif FORM.programID EQ programID>selected="selected"</cfif>>#programname#</option>
                        </cfloop>
                    </select>
                </td>
                <td class="formTitle">	
                    Evaluation:
                    <select name="evaluationID" id="evaluationID">
                        <option value="1" <cfif FORM.evaluationID EQ 1>selected="selected"</cfif>>Month 1</option>
                        <option value="2" <cfif FORM.evaluationID EQ 2>selected="selected"</cfif>>Month 2</option>
                        <option value="3" <cfif FORM.evaluationID EQ 3>selected="selected"</cfif>>Month 3</option>
                        <option value="4" <cfif FORM.evaluationID EQ 4>selected="selected"</cfif>>Month 4</option>
                    </select>
                </td>
                <td class="formTitle">
                    Show:
                    <select name="reportType" id="reportType">
                        <option value="0" <cfif FORM.reportType EQ 0>selected="selected"</cfif>>All</option>
                        <option value="1" <cfif FORM.reportType EQ 1>selected="selected"</cfif>>Warning</option>
                        <option value="2" <cfif FORM.reportType EQ 2>selected="selected"</cfif>>Non-Compliant</option>
                    </select>
                </td>              
            </tr>
            <tr>
                <td class="formTitle" colspan="4">
                    <center><input name="send" type="submit" value="Submit" /></center>
                </td>
            </tr>  
        </table>
  	</form>

    <!--- Candidate List --->
    <cfif VAL(FORM.submitted)>
        <table id="candidateList" cellpadding="4" cellspacing="0" align="center" class="section" width="95%">
        	<tr>
            	<td class="listTitle style2">ID</td>
                <td class="listTitle style2">Last Name</td>
                <td class="listTitle style2">First Name</td>
                <td class="listTitle style2">DS-2019</td>
                <td class="listTitle style2">Host Company</td>
                <td class="listTitle style2">Email</td>
                <td class="listTitle style2">Intl. Rep.</td>
                <td class="listTitle style2">Quiz Completed </td>
               
        
            </tr>
            <cfif NOT VAL(qGetEvaluationList.recordCount)>
            	<tr><th colspan='10'>Your search did not return any results.</th></tr>
            <cfelse>
            	<cfloop query="qGetEvaluationList">
                	<cfscript>
						rowClass = "rowOn";
						if (qGetEvaluationList.currentRow % 2 EQ 0) {
							rowClass = "rowOff";
						}
						checkIn = qGetEvaluationList.checkInDate;
						if (NOT LEN(checkIn)) {
							checkIn = "missing";
						}
						if (NOT LEN(comment)) {
							comment = "";
						}
						daysSinceCheckIn = 0;
						nComplianceDays = 0;
						nCloseDays = 0;
						if (checkIn NEQ "missing") {
							daysSinceCheckIn = DateDiff('d',checkIn,NOW());	
						}
						switch(FORM.evaluationID) {
							case 1:
								nComplianceDays = 30;
								nCloseDays = 25;
								break;
							case 2:
								nComplianceDays = 60;
								nCloseDays = 55;
								break;
							case 3:
								nComplianceDays = 90;
								nCloseDays = 85;
								break;
							default: // 4
								nComplianceDays = 120;
								nCloseDays = 115;
						}
					</cfscript>
                	<tr id="#candidateID#" class="#rowClass#">
                    	<td class="style5"><a href="" class="style4" target="_blank">#candidateID#</a></td>
                        <td class="style5"><a href="" class="style4" target="_blank">#lastName#</a></td>
                        <td class="style5"><a href="" class="style4" target="_blank">#firstName#</a></td>
                        <td class="style5">#ds2019#</td>
                        <td class="style5">#hostCompanyName#</td>
                        <td class="style5"><a href="mailto:# email#" class="style4">#email#</a></td>
                        <cfif ListFind("1,2",FORM.reportType)>
                            <td class="style5">#phone#</td>
                        </cfif>
                        <td class="style5">#businessName#</td>
                        <td class="style5">#startDate#</td>
                        <td class="style5">#endDate#</td>
                        <td class="style5">#checkIn#</td>
                        <cfif checkIn NEQ "missing">
							<cfif DateAdd('d',nComplianceDays,checkIn) LTE NOW()>
                                <td class="style5" style="background-color:##F00; text-align:center;">#daysSinceCheckIn#</td>
                            <cfelseif DateAdd('d',nCloseDays,checkIn) LTE NOW()>
                                <td class="style5" style="background-color:##F90; text-align:center;">#daysSinceCheckIn#</td>
                            <cfelse>
                                <td class="style5" style="text-align:center;">#daysSinceCheckIn#</td>
                            </cfif>
                      	<cfelse>
                        	<td class="style5" style="text-align:center;">#daysSinceCheckIn#</td>
                        </cfif>
                        <td align="center" class="style5">
                        <a href="../wat/candidate/culturalActivityReport.cfm?uniqueID=#uniqueID#&refresh=no" class="style4 jQueryModal">Add</a></td>
						<td align="center" class="style5">
                        	<a href="" onClick="javascript:evaluationTrackingPopup(#uniqueID#,#FORM.evaluationID#)" class="style4 jQueryModal">Track</a>
                        	<br/>#comment#
                        </td>
                        <td align="center" class="style5"><a href="javascript:setEvaluationReceived(#candidateID#,#FORM.evaluationID#);" class="style4">Received</a></td>
                    </tr>
                </cfloop>
            </cfif>
        </table>
    </cfif>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    