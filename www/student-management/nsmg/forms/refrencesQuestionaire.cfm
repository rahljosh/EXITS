<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Refrences Questionnaire</title>
<link rel="stylesheet" media="all" type="text/css"href="../linked/css/baseStyle.css" />

<style type="text/css">
	body{
	font-family:"Lucida Grande", "Lucida Sans Unicode", Verdana, Arial, Helvetica, sans-serif;
	font-size:12px;
	}
	p, h1, form, button{border:0; margin:0; padding:0;}
	.spacer{clear:both; height:1px;}
	/* ----------- My Form ----------- */
	.myform{
	margin:0 auto;
	width:600px;
	padding:14px;
	}
	
	/* ----------- stylized ----------- */
	#stylized{
	border:solid 2px #b7ddf2;
	background:#ebf4fb;
	}
	#stylized h1 {
	font-size:14px;
	font-weight:bold;
	margin-bottom:8px;
	}
	#stylized p{
	font-size:11px;
	color:#666666;
	margin-bottom:20px;
	border-bottom:solid 1px #b7ddf2;
	padding-bottom:10px;
	}
	#stylized label{
	display:block;
	font-weight:bold;
	text-align:left;
	

	padding-right:15px;
	}
	#stylized .small{
	color:#666666;
	display:block;
	font-size:11px;
	font-weight:normal;
	text-align:right;
	width:190px;
	}
	
	#stylized .inputLabel{
	padding-right: 15px;
	vertical-align: top;
	}
	
	#stylized button{
	clear:both;
	margin-left:150px;
	width:125px;
	height:31px;
	background:#666666 url(img/button.png) no-repeat;
	text-align:center;
	line-height:31px;
	color:#FFFFFF;
	font-size:11px;
	font-weight:bold;
	}
</style>

<cfsilent>
    <!--- Import CustomTag Used for Page Messages and Form Errors --->
    <cfimport taglib="../extensions/customTags/gui/" prefix="gui" />	
</cfsilent>
</head>

<cfquery name="questions" datasource="#application.dsn#">
	SELECT
    	*
  	FROM
    	areaRepQuestions
  	WHERE
    	active = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
</cfquery>

<cfparam name="FORM.dateInterview" default="">

<cfloop query="questions">
	<cfparam name="FORM.#id#" default="">
</cfloop>

<cfscript>
	// Get User By Userid
	qGetProspectiveRepInfo = APPLICATION.CFC.USER.getUserByID(userID=url.rep);
	// Get User By Userid
	qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=client.userid);
</cfscript>

<cfif isDefined('form.submit')>
	<cfscript>
		// Data Validation - Current Address
		if ( NOT LEN(form.dateInterview))  {
			// Get all the missing items in a list
			SESSION.formErrors.Add("Please enter the date of the interview.");
		}
	</cfscript>
	<cfloop query="questions">
		<cfscript>
            // Data Validation - Current Address
            if ( NOT LEN(#Evaluate("form." & id)#))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer question number #id#.");
            }
        </cfscript>
	</cfloop>
    
	<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
  		<cfquery datasource="#application.dsn#">
            INSERT INTO
            	areaRepQuestionaireTracking
                (
                	dateInterview,
                    interviewer,
                    arearepid,
                    fk_referencesID,
                    season
                )
          	VALUES
            	(
                	<cfqueryparam cfsqltype="cf_sql_date" value="#CreateODBCDate(FORM.dateInterview)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(CLIENT.userID)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.rep)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.ref)#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="8">
                )
     	</cfquery>
        
        <cfquery name="reportID" datasource="#APPLICATION.DSN#">
        	SELECT
            	MAX(id) AS reportID
          	FROM
            	areaRepQuestionaireTracking
        </cfquery>
        
        <cfif CLIENT.userType LTE 5>
        
        	<cfquery datasource="#APPLICATION.DSN#">
            	UPDATE
                	smg_user_references
               	SET
                	approved = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                WHERE
                	refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ref#">
            </cfquery>
     		
			<!---check if References in paperwork have been udpated.  If they havn't approve them---->
			<cfscript>
				// Get Paperwork Info
				qGetSeasonPaperwork = APPLICATION.CFC.USER.getSeasonPaperwork(userID=URL.rep);
            </cfscript>
            
			<cfif NOT isDate(qGetSeasonPaperwork.ar_ref_quest1)>

            	<cfquery name="updatePaperwork" datasource="#APPLICATION.DSN#">
                	UPDATE 
                    	smg_users_paperwork
                  	SET
                    	ar_ref_quest1 = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#now()#">
                 	WHERE
                    	paperworkID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetSeasonPaperwork.paperworkID)#">
           		</cfquery>
       		
			<cfelseif NOT isDate(qGetSeasonPaperwork.ar_ref_quest2)>
            
          		<cfquery name="updatePaperwork" datasource="#APPLICATION.DSN#">
                	UPDATE
                    	smg_users_paperwork
                 	SET
                    	ar_ref_quest2 = <cfqueryparam cfsqltype="CF_SQL_DATE" value="#now()#">
                 	WHERE
                    	paperworkID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetSeasonPaperwork.paperworkID)#">
           		</cfquery>
                
        	</cfif>
            
			<cfscript>
				// Check if we need to send out a notification to the program manager - Only accounts that needs review
				APPLICATION.CFC.USER.papeworkSubmittedOfficeNotification(userID=URL.rep);
         	</cfscript>
                        
      	</cfif>
        
    	<cfloop query="questions">
     		<cfquery datasource="#APPLICATION.DSN#">
          		INSERT INTO
                	areaRepQuestionaireAnswers
                    (
                    	fk_reportID,
                        fk_questionID,
                        answer
                   	)
              	VALUES
                	(
                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(reportID.reportID)#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(ID)#">,
                      	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('form.' & id)#">
                 	)
          	</cfquery>
      	</cfloop>
		<body onload="opener.location.reload()">
			<script type="text/javascript">
                setTimeout('self.close()',2000);
            </script>
            <div align="center">
            	<h1>Succesfully Submited.</h1>
                <br />
            	<em>this window should close shortly</em>
            	<br />
         	</div>
        	<cfabort>
     	</cfif>      
	</cfif>
	<cfquery name="refrences" datasource="#application.dsn#">
		SELECT
        	*
      	FROM
        	smg_user_references
     	WHERE
        	refid = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(URL.ref)#">
   	</cfquery>
 	<cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.performEdit" default="0">
	<body onload="opener.location.reload()">
		<cfoutput>
 			<gui:displayFormErrors 
                formErrors="#SESSION.formErrors.GetCollection()#"
                messageType="tableSection"
                width="98%"
                />
			<div id="stylized" class="myform">
 				<h1>References Questionnaire</h1>
                <p>
        			<strong>Representative:</strong> #qGetProspectiveRepInfo.firstname# #qGetProspectiveRepInfo.lastname# (#qGetProspectiveRepInfo.userID#)<br />
	   				<strong>Interviewer:</strong> #qGetUserInfo.firstname# #qGetUserInfo.lastname# (#qGetUserInfo.userID#)<br />
             	</p>
      			<h1>Reference Information</h1>
         		<p>
         			<strong>Name:</strong> #refrences.firstname# #refrences.lastname# <br />
               		<strong>Phone:</strong> #refrences.phone#<br />
                    <strong>Email:</strong> #refrences.email#<br />
                    <strong>Address:</strong> #refrences.address# #refrences.address2# #refrences.city# #refrences.state#, #refrences.zip#<Br />
                    <strong>Relationship:</strong> #refrences.relationship# (#refrences.howLong#)
            	</p>
                <br />
       			<cfform method="post" action="refrencesQuestionaire.cfm?rep=#url.rep#&ref=#url.ref#">
       				<label>Date of Interview</label>
                    <br />
         			<cfinput type="text" name="dateInterview" size="10" value="#form.dateInterview#" mask="99/99/9999"  />mm/dd/yyyy
        			<br />
                    <br />
        			<cfloop query="questions">
        				<p>
         					<label>#questions.currentrow#. #qtext#</label>
                         	<br />
         					<textarea name="#id#" cols="60" rows="4"/>#Evaluate("form." & id)#</textarea>
          				</p>
    	 			</cfloop>
             		<div align="right" >
        				<input type="hidden" name="submit" />
            			<button type="submit">Submit Information</button>
      				</div>
        		</cfform>
			</div>
		</cfoutput>
	</body>
</html>