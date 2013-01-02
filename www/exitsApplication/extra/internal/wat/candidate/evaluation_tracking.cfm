<!--- ------------------------------------------------------------------------- ----
	
	File:		evaluation_tracking.cfm
	Author:		James Griffiths
	Date:		December 27, 2012
	Desc:		Evaluation tracking popup

----- ------------------------------------------------------------------------- --->

<cfsilent>

    <cfimport taglib="../../../extensions/customTags/gui/" prefix="gui" />
    
    <cfajaxproxy cfc="extensions.components.candidate" jsclassname="CANDIDATE">
    
    <cfparam name="URL.uniqueID" default="">
    <cfparam name="URL.id" default="0">
    <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.action" default="">
    <cfparam name="FORM.trackingID" default="0">
    
    <cfquery name="qGetCandidate" datasource="#APPLICATION.DSN.Source#">
        SELECT candidateid, firstname, lastname
        FROM extra_candidates
        WHERE uniqueid = <cfqueryparam cfsqltype="cf_sql_char" value="#URL.uniqueID#">
    </cfquery>
    
    <cfif VAL(FORM.submitted)>
    	<cfif FORM.action EQ "add">
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	INSERT INTO extra_evaluation_tracking (
                	candidateID,
                    evaluationNumber,
                    date,
                    comment )
               	VALUES (
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.candidateID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.id)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.date#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#FORM.comment#"> )
            </cfquery>
        <cfelseif FORM.action EQ "delete">
        	<cfquery datasource="#APPLICATION.DSN.Source#">
            	DELETE FROM extra_evaluation_tracking
                WHERE id = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.trackingID#">
            </cfquery>
        </cfif>
    </cfif>
    
    <cfquery name="qGetTracking" datasource="#APPLICATION.DSN.Source#">
        SELECT *
        FROM extra_evaluation_tracking
        WHERE candidateID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.candidateID)#">
        AND evaluationNumber = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.id)#">
    </cfquery>
    
</cfsilent>

<script type="text/javascript">
	var addForm = function() {
		$("#addButton").css("display","none");
		$("#formSpan").removeAttr("style");
	}
	
	var confirmDelete = function(form) {
		if (confirm("Are you sure you want to delete this record?")) {
			$("#" + form).submit();
		}
	}
</script>

<cfoutput query="qGetCandidate">

	<!--- Page Header --->
    <gui:pageHeader
        headerType="extraNoHeader"
    />

	<table cellpadding=5 cellspacing=5 border=1 align="center" width="100%" bordercolor="C7CFDC" bgcolor="ffffff">
		<tr>
			<td bordercolor="FFFFFF">
				<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
                    <tr valign=middle height=24><td align="right" class="title1">Evaluation #URL.id# Tracking for <u>#firstname# #lastname#</u> (#candidateid#)</td></tr>
                    <tr><td>&nbsp;</td></tr>
                </table>
           	</td>
       	</tr>
  	</table>
    
    <table width="100%" border=0 cellpadding=5 cellspacing=0>
        <tr>
            <td class="style2" bgcolor="8FB6C9" width="15%">Date</td>
            <td class="style2" bgcolor="8FB6C9" width="75%">Comments</td>
            <td class="style2" bgcolor="8FB6C9" width="10%"></td>
        </tr>
        <cfif NOT VAL(qGetTracking.recordcount)>
        	<tr><td colspan="6" align="center" class="style1">There is no Tracking for this evaluation and student.</td></tr>
        <cfelse>
        	<cfloop query="qGetTracking">
            	<tr bgcolor="#iif(currentrow MOD 2 ,DE("ffffff") ,DE("F7F7F7") )#">
                    <td class="style5">#DateFormat(date,'mm/dd/yyyy')#</td>
                    <td class="style5">#comment#</td>
                    <td class="style5">
                    	<form name="deleteTracking" id="delete_#id#" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                        	<input type="hidden" name="submitted" value="1" />
                            <input type="hidden" name="action" value="delete" />
                            <input type="hidden" name="trackingID" value="#id#" />
                            <input type="button" onClick="confirmDelete('delete_#id#')" value="DELETE" class="style1" />
                        </form>
                    </td>
                </tr>
            </cfloop>
        </cfif>
  	</table>
    
    <table border=0 cellpadding=4 cellspacing=0 width=100% class="section">
        <tr>
        	<td align="center" width="50%">
            	<input type="button" value="ADD" class="style1" onClick="addForm()" />
            	<form name="trackingForm" method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
                	<input type="hidden" name="submitted" value="1" />
                    <input type="hidden" name="action" value="add" />
                    <span id="formSpan" style="display:none;">
                    	<table style="font-size:10px;">
                        	<tr>
                            	<td>Date: </td>
                                <td><input type="text" name="date" class="style1 datePicker" /></td>
                          	</tr>
                            <tr>
                            	<td>Comments: </td>
                                <td><input type="text" name="comment" class="style1" size="50" /></td>
                          	</tr>
                            <tr style="text-align:center;">
                            	<td colspan="2">
                                	<input type="submit" value="SAVE" class="style1" />
                                </td>
                            </tr>
                       	</table>
                    </span>
              	</form>
           	</td>
      	</tr>
    </table>
    
    <!--- Page Footer --->
    <gui:pageFooter
        footerType="extra"
    />
    
</cfoutput>