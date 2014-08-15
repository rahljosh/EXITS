<!--- ------------------------------------------------------------------------- ----
	
	File:		incentiveTripPoints.cfm
	Author:		James Griffiths
	Date:		August 11, 2014
	Desc:		Tool for adding incentive trip points that will count as placements for reps.

----- ------------------------------------------------------------------------- --->

<cfsilent>

	<!--- Ajax Call to the Component --->
    <cfajaxproxy cfc="nsmg.extensions.components.udf" jsclassname="UDFComponent">

	<!--- Get all active seasons --->
    <cfquery name="qGetSeasons" datasource="#APPLICATION.DSN#">
    	SELECT s.*, i.trip_place
        FROM smg_seasons s
        INNER JOIN smg_incentive_trip i ON i.seasonID = s.seasonID
        WHERE s.active = 1
        ORDER BY s.seasonID DESC
    </cfquery>
	
    <!--- Defualt values for parameters --->
	<cfparam name="URL.seasonID" default="#qGetSeasons.seasonID#">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.delete" default="0">
    <cfparam name="FORM.record" default="0">
    <cfparam name="FORM.userID" default="0">
    <cfparam name="FORM.studentID" default="0">
    <cfparam name="FORM.points" default="0">
    <cfparam name="FORM.notes" default="">

	<!--- Get all reps that have non deleted points for this season and list their total points --->
    <cfquery name="qGetPoints" datasource="#APPLICATION.DSN#">
    	SELECT 
        	i.*,
            CONCAT(u.firstName, " ", u.lastName, " (##", u.userID, ")") AS userName,
            CONCAT(s.firstName, " ", s.familyLastName, " (##", s.studentID, ")") AS studentName
        FROM smg_incentive_trip_points i
        INNER JOIN smg_users u ON u.userID = i.userID
        LEFT JOIN smg_students s ON s.studentID = i.studentID
        WHERE isDeleted = 0
        AND seasonID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.seasonID)#">
        ORDER BY u.firstName, u.lastName, i.dateCreated
    </cfquery>
    
    <!--- Get all active reps --->
    <cfquery name="qGetReps" datasource="#APPLICATION.DSN#">
    	SELECT u.userID, u.firstName, u.lastName
        FROM smg_users u
        INNER JOIN user_access_rights uar ON uar.userID = u.userID
        	AND uar.userType IN (5,6,7)
        WHERE u.active = 1
        GROUP BY u.userID
        ORDER BY u.userID
    </cfquery>
    
    <!--- Get all active students --->
    <cfquery name="qGetStudents" datasource="#APPLICATION.DSN#">
    	SELECT studentID, firstName, familyLastName
        FROM smg_students
        WHERE active = 1
    </cfquery>
    
    <cfset userIDs = ListToArray(ValueList(qGetReps.userID))>
    <cfset userFirstNames = ListToArray(ValueList(qGetReps.firstName))>
    <cfset userLastNames = ListToArray(ValueList(qGetReps.lastName))>
    
    <cfset studentIDs = ListToArray(ValueList(qGetStudents.studentID))>
    <cfset studentFirstNames = ListToArray(ValueList(qGetStudents.firstName))>
    <cfset studentLastnames = ListToArray(ValueList(qGetStudents.familyLastName))>
    
    <!--- Submitted form --->
    <cfif VAL(FORM.submitted)>
    	
        <cfquery datasource="#APPLICATION.DSN#">
        	INSERT INTO smg_incentive_trip_points (
            	seasonID,
                userID,
                studentID,
                points,
                notes,
                dateCreated,
                createdBy,
                UpdatedBy)
          	VALUES (
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.seasonID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.studentID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.points)#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.notes#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">)
        </cfquery>
        
        <cflocation url="?curdoc=tools/incentiveTripPoints">
        
    </cfif>
    
    <!--- Delete through form --->
	<cfif VAL(FORM.delete)>
    	
        <cfquery datasource="#APPLICATION.DSN#">
        	UPDATE smg_incentive_trip_points
            SET 
            	isDeleted = 1,
            	updatedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">
           	WHERE ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(FORM.record)#">
        </cfquery>
        
        <cflocation url="?curdoc=tools/incentiveTripPoints">
        
    </cfif>

</cfsilent>

<style type="text/css">	
	#incentiveTripDiv {
		padding: 10px;
		border: 1px solid gray;
		border-radius: 15px;
		text-align:center;
	}
</style>

<script type="text/javascript">
	<cfoutput>
		var #toScript(userIDs,"userIDs")#;
		var #toScript(userFirstNames,"userFirstNames")#;
		var #toScript(userLastNames,"userLastNames")#;
		
		var #toScript(studentIDs,"studentIDs")#;
		var #toScript(studentFirstNames,"studentFirstNames")#;
		var #toScript(studentLastNames,"studentLastNames")#;
	</cfoutput>

	$(document).ready(function() {
		$("#userID").autocomplete({source:userIDs});
		$("#studentID").autocomplete({source:studentIDs});
	});

	function toggleNewRecordDiv() {
		if ($("#newRecordDiv").is(":visible")) {
			$("#newRecordDiv").hide();
			$("#newRecordButton").attr("value","  Add Points  ");
		} else {
			$("#newRecordDiv").show();
			$("#newRecordButton").attr("value","    Cancel    ");
		}
	}
	
	function validateUserID(id) {
		index = userIDs.indexOf(id);
		if (index > -1) {
			$("#noUserFound").hide();
			$("#userName").html(userFirstNames[index] + " " + userLastNames[index] + " (#" + id + ")");
		} else {
			$("#noUserFound").show();
			$("#userName").html("");
		}
	}
	
	function validateStudentID(id) {
		index = studentIDs.indexOf(id);
		if (index > -1) {
			$("#noStudentFound").hide();
			$("#studentName").html(studentFirstNames[index] + " " + studentLastNames[index] + " (#" + id + ")");
		} else {
			$("#noStudentFound").show();
			$("#studentName").html("");
		}
	}
	
	function validateForm() {
		userID = $("#userID").val();
		studentID = $("#studentID").val();
		errorMsg = "";
		if (userIDs.indexOf(userID) < 0) {
			errorMsg = errorMsg + "You must enter a valid representative ID.\n";
		}
		if (studentIDs.indexOf(studentID) < 0 && studentID != "" && studentID != 0) {
			errorMsg = errorMsg + "You must enter a valid student ID or leave that field blank.\n";
		}
		if (errorMsg != "") {
			alert(errorMsg);
			return false;	
		} else {
			return true;
		}
	}
</script>

<cfoutput>

	<!--- Page container --->
	<div id="incentiveTripDiv">
    
    	<!--- Top section --->
        <div>
        
			<!--- Page title --->
            <span style="float:left;"><b>Incentive Trip Point Management</b></span>
        
            <!--- Season selection --->
            <span style="float:right;">
                <b>Season:</b>&nbsp;
                <select name="seasonID" onchange="location='?curdoc=tools/incentiveTripPoints&seasonID='+this.value">
                    <cfloop query="qGetSeasons">
                        <option value="#seasonID#" <cfif seasonID EQ URL.seasonID>selected="selected"</cfif>>#season# - #trip_place#</option>
                    </cfloop>
                </select>
            </span>
       	
        </div>
        
        <br />        
        <hr />
    
        <!--- Show all point records --->
        <table width="800px;" style="margin:auto; text-align:left; border:thin solid gray;" cellpadding="0" cellspacing="0">
            <tr>
            	<td width="200px;" style="border-bottom:thin solid gray;"><b>Representative:</b></td>
                <td width="200px;" style="border-bottom:thin solid gray;"><b>Student:</b></td>
                <td width="50px;" style="border-bottom:thin solid gray;"><b>Points:</b></td>
                <td width="150px;" style="border-bottom:thin solid gray;"><b>Notes:</b></td>
                <td width="100px;" style="border-bottom:thin solid gray;"><b>Date:</b></td>
                <td width="100px;" style="border-bottom:thin solid gray;"></td>
            </tr>
            <cfset x = 1>
            <cfloop query="qGetPoints">
        		<tr bgcolor="<cfif x MOD 2 EQ 0>lightgray</cfif>">
                	<td>#userName#</td>
                    <td>#studentName#</td>
                    <td>#points#</td>
                    <td>#notes#</td>
                    <td>#DateFormat(dateCreated,'mm/dd/yyyy')#</td>
                    <td>
                    	<form action="?curdoc=tools/incentiveTripPoints" method="post">
                        	<input type="hidden" name="delete" value="1" />
                            <input type="hidden" name="record" value="#ID#" />
                            <input type="submit" value="Delete" />
                        </form>
                    </td>
                </tr>
                <cfset x = x + 1>
        	</cfloop>
     	</table>
        
        <br />
        
        <!--- Add points --->
        <input id="newRecordButton" type="button" value="  Add Points  " style="margin:auto;" onclick="toggleNewRecordDiv()" />
        
        <div id="newRecordDiv" style="display:none;">
            <form id="newPointsForm" action="?curdoc=tools/incentiveTripPoints" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="submitted" value="1" />
                <table width="800px" style="margin:auto; margin-top:20px; margin-bottom:40px; border:thin solid gray; text-align:left;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="250px;" style="border-bottom:thin solid gray;"><b>Representative:</b></td>
                        <td width="250px;" style="border-bottom:thin solid gray;"><b>Student:</b></td>
                        <td width="100px;" style="border-bottom:thin solid gray;"><b>Points:</b></td>
                        <td width="200px;" style="border-bottom:thin solid gray;"><b>Notes:</b></td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="userID" id="userID" size="5" />
                            <input type="button" value="Select" onclick="validateUserID($('##userID').val())" />
                            <br/>
                            <span id="noUserFound" style="display:none; background-color:red; font-weight:bold;">This rep could not be found.</span>
                            <span id="userName"></span>
                        </td>
                        <td>
                        	<input type="text" name="studentID" id="studentID" size="5" />
                            <input type="button" value="Select" onclick="validateStudentID($('##studentID').val())" />
                            <br/>
                            <span id="noStudentFound" style="display:none; background-color:yellow; font-weight:bold;">This student could not be found.</span>
                            <span id="studentName"></span>
                      	</td>
                        <td><select name="points"><cfloop from="1" to="7" index="i"><option value="#i#" <cfif FORM.points EQ i>selected="selected"</cfif>>#i#</option></cfloop></select></td>
                        <td><textarea name="notes" maxlength="100">#FORM.notes#</textarea></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align:center; border-top:thin solid gray;"><input type="submit" value="Submit" /></td>
                    </tr>
                </table>
            </form>
        </div>
        
    </div>

</cfoutput>