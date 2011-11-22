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
<Cfquery name="questions" datasource="#application.dsn#">
select *
from areaRepQuestions
where active = 1
</cfquery>
<Cfparam name="FORM.dateInterview" default="">
<CFloop query="questions">
	<Cfparam name="FORM.#id#" default="">
</CFloop>
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
<Cfloop query="questions">
	<cfscript>
			// Data Validation - Current Address
			if ( NOT LEN(#Evaluate("form." & id)#))  {
                // Get all the missing items in a list
                SESSION.formErrors.Add("Please answer question number #id#.");
			}
	
	</cfscript>
</Cfloop>
<!--- Check if there are no errors --->
    <cfif NOT SESSION.formErrors.length()>
            <cfquery datasource="#application.dsn#">
            insert into areaRepQuestionaireTracking (dateInterview, interviewer, arearepid, fk_referencesID, season)
                                    values(#CreateODBCDate(form.dateInterview)#, #client.userid#, #url.rep#, #url.ref#, 8)
             </cfquery>
            <Cfquery name="reportID" datasource="#application.dsn#">
            select max(id) as reportID
            from areaRepQuestionaireTracking
            </cfquery>
            <cfloop query="questions">
                <cfquery datasource="#application.dsn#">
                insert into areaRepQuestionaireAnswers (fk_reportID, fk_questionID, answer)
                                    values(#reportid.reportid#, #id#, <Cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('form.' & id)#"> )
                </cfquery>
            </cfloop>
            <body onload="opener.location.reload()">
           
            <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',2000);
			//--></SCRIPT>
		
            
            <div align="center">
            
            <h1>Succesfully Submited.</h1>
            <em>this window should close shortly</em>
            </div>
            <cfabort>
     </cfif>      
</cfif>



<Cfquery name="refrences" datasource="#application.dsn#">
select *
from smg_user_references
where refid = #url.ref#
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
       
        <label>Date of Interview</label><br />
         <cfinput type="text" name="dateInterview" size="10" value="#form.dateInterview#" mask="99/99/9999"  />mm/dd/yyyy
        </p>
        <cfloop query="questions">
        <p>
         <label>#questions.currentrow#. #qtext#</label><br />
         <Textarea name="#id#" cols="60" rows="4"/>#Evaluate("form." & id)#</textarea>
          
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