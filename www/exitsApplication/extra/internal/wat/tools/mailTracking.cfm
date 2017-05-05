<!--- ------------------------------------------------------------------------- ----
	
	File:		mailTracking.cfm
	Author:		Bruno Lopes
	Date:		Sep 11, 2016

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

	</cfscript>

	<cfif VAL(FORM.submitted) >
		<cfif VAL (FORM.IntRep)>
			<cfquery dbtype="query" name="qIntlRepSubmitted">
				SELECT *
				FROM qIntlRep
				WHERE userID = #FORM.intRep#
			</cfquery>
		<cfelse>
			<cfset qIntlRepSubmitted = qIntlRep />
		</cfif>
	</cfif>
    
</cfsilent>


<!--- Ajax Call to the Component --->
<cfajaxproxy cfc="extensions.components.user" jsclassname="user">

<script type="text/javascript">
	var setMailTracking = function(userID) {
		// Create an instance of the proxy. 
		var u = new user();	
		// Setting a callback handler for the proxy automatically makes the proxy's calls asynchronous. 
		u.setCallbackHandler(mailTrackingSet(userID)); 
		u.setErrorHandler(myErrorHandler); 

		var extra_cost = $("#"+userID+"_extra_cost").val();

		if ($("#"+userID+"_extra_cost").val() == '') {
			extra_cost = 0.00;
		}

		u.setMailTracking(userID, $("#"+userID+"_program_id").val(), $("#"+userID+"_ds2019Date option:selected").val(), $("#"+userID+"_date").val(), $("#"+userID+"_tracking").val(), extra_cost);

		//alert(userID, $("#"+userID+"_date").val(), $("#"+userID+"_tracking").val(), $("#"+userID+"_extra_cost").val());
	}
	
	var mailTrackingSet = function(userID) {
		// Set up page message, fade in and fade out after 2 seconds
		$("#returnDetailMessage").text("Mail tracking added for Int. Rep. #" + userID).fadeIn().fadeOut(5000);

		var user_date = $('#' + userID + '_date').val();
		var user_ds2019date = $('#' + userID + '_ds2019Date option:selected').val();
		var user_tracking = $('#' + userID + '_tracking').val();
		var user_extra_cost = $('#' + userID + '_extra_cost').val();

		$('<tr class="rowOff"><td class="style5">' + user_ds2019date + '</td><td class="style5">' + user_tracking + '</td><td class="style5">' + user_date + '</td><td class="style5">' + user_extra_cost + '</td></tr>').insertAfter('#' + userID);
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
        tableTitle="Mail Tracking"
    />

	<!--- This holds the candidate information messages --->
    <div id="returnDetailMessage" class="pageMessage"></div>

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

    <!--- Mail Tracking List --->
    <cfif VAL(FORM.submitted)>

        <table cellpadding="4" cellspacing="0" align="center" class="section" width="95%">
            
            
     		<cfloop query="qIntlRepSubmitted">
     			<cfscript>
     				getVerification = APPLICATION.CFC.USER.getVerificationDate(qIntlRepSubmitted.userID,FORM.programID);
     			</cfscript>
     			
     			<cfif getVerification.recordCount GT 0  AND VAL(getVerification.VERIFICATIONRECEIVED)>

         			<cfset qGetTrackingResults = APPLICATION.CFC.USER.getMailTracking(intRep=qIntlRepSubmitted.userID, programID=FORM.programID) />

		         	<tr>
		        		<td class="style5" style="padding-top:10px">
		        			<a href="/internal/wat/index.cfm?curdoc=intRep/intlRepInfo&uniqueID=#qIntlRepSubmitted.uniqueID#" class="style4">#qIntlRepSubmitted.BUSINESSNAME# (#qIntlRepSubmitted.userID#)</a> - Total Mail Trackings: #qGetTrackingResults.recordCount#
		        		</td>
		        	</tr>
		            <tr id="#qIntlRepSubmitted.userID#">
		            	<td class="listTitle style2">DS2910 Date</td>
		                <td class="listTitle style2">Tracking ##</td>
		                <td class="listTitle style2">Shipped Date</td>
		                <td class="listTitle style2">Extra Cost</td>
		            </tr>

	            	<cfloop query="qGetTrackingResults">
	              		<tr <cfif currentRow % 2 EQ 0>class="rowOff"<cfelse>class="rowOn"</cfif>>
	                        <td class="style5">#ds2019_date#</td>
	                        <td class="style5">#tracking#</td>
	                        <td class="style5">#DateFormat(date, 'mm/dd/yyyy')#</td>
	                        <td class="style5">$#extra_cost#</td>
	                	</tr>
	                </cfloop>

	                <tr>
	                	<td colspan='3' align="right" class="style5"  style="border-bottom:1px solid ##333;">
	                		Program: <select name="#qIntlRepSubmitted.userID#_program_id" id="#qIntlRepSubmitted.userID#_program_id">
				                        <cfloop query="qGetProgramList">
				                            <option value="#programID#" <cfif FORM.programID EQ programID>selected="selected"</cfif> >#programname#</option>
				                        </cfloop>
				                    </select> &nbsp;
				            DS2019 Ver. Date: 
				            <select name="#qIntlRepSubmitted.userID#_ds2019Date" id="#qIntlRepSubmitted.userID#_ds2019Date">
		                        <option value="0">- Select -</option>
		                        <cfloop query="getVerification">
		                            <option value="#getVerification.VERIFICATIONRECEIVED#">#getVerification.VERIFICATIONRECEIVEDDISPLAY#</option>
		                        </cfloop>
		                    </select>

	                		Tracking ##:<input id="#qIntlRepSubmitted.userID#_tracking" type="text"/> &nbsp;
	                		Shipped Date: <input id="#qIntlRepSubmitted.userID#_date" type="text" class="datePicker"/> &nbsp;
	                		Extra Cost: $<input id="#qIntlRepSubmitted.userID#_extra_cost" type="text" /> <button onclick="setMailTracking(#qIntlRepSubmitted.userID#)">Save Tracking</button>
	                	</td>
	                </tr>

	            </cfif>
            </cfloop>
       		
        </table>
  	</cfif>
                                            
    <!--- Table Footer --->    
    <gui:tableFooter />
    
</cfoutput>    
