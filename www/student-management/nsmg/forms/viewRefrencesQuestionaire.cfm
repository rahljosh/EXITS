<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Refrences Questionaire</title>
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
</head>

<Cfquery name="questionTracking" datasource="#application.dsn#">
select *
from smg_users_references_tracking
where ID = #url.reportid#
</cfquery>

<Cfquery name="questions" datasource="#application.dsn#">
select *, SURQ.qText, SURQ.id
from smg_users_references_answers SURA
left join smg_users_references_questions SURQ on SURQ.id = SURA.fk_questionID
where fk_reportID = #url.reportid#
order by SURQ.id
</cfquery>


<!----Report is Approved--->
<Cfif isDefined('form.approve')>
	<cfquery datasource="#application.dsn#">
    update smg_user_references
    set approved = #form.approve#
    where refID = #questionTracking.fk_ReferencesID#
    </Cfquery>
    
    <CFIF form.approve is 2>
        <CFquery name="checkRefPaperwork" datasource="#application.dsn#">
        select ar_ref_quest1, ar_ref_quest2
        from smg_users_paperwork
        where userid = #questionTracking.areaRepID#
        and seasonid = #APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#
        </CFquery>
       
			<Cfif checkRefPaperwork.ar_ref_quest1 is ''>
                <Cfquery name="updatePaperWork" datasource="#application.dsn#">
                update smg_users_paperwork
                    set ar_ref_quest1 = #now()#
                where userid = #questionTracking.areaRepID#
                and seasonid = #APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#
                </CFquery>
            <cfelse>
                  <Cfquery name="updatePaperWork" datasource="#application.dsn#">
                update smg_users_paperwork
                    set ar_ref_quest2 = #now()#
                where userid = #questionTracking.areaRepID#
                and seasonid = #APPLICATION.CFC.LOOKUPTABLES.getCurrentPaperworkSeason().seasonID#
                </CFquery>
            </Cfif>

     </CFIF>
	
     <SCRIPT LANGUAGE="JavaScript"><!--
			setTimeout('self.close()',2000);
			//--></SCRIPT>
</Cfif>

<cfscript>
		// Get User By Userid
		qGetProspectiveRepInfo = APPLICATION.CFC.USER.getUserByID(userID=questionTracking.areaRepID);
		// Get User By Userid
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=questionTracking.interviewer);
</cfscript>



<Cfquery name="refrences" datasource="#application.dsn#">
select *
from smg_user_references
where refid = #questionTracking.fk_ReferencesID#
</cfquery>
<cfquery name="currentStatus" datasource="#application.dsn#">
    select *
    from  smg_user_references
    where refID = #questionTracking.fk_ReferencesID#
    </Cfquery>
 <cfparam name="FORM.submitted" default="0">
    <cfparam name="FORM.pr_action" default="">
    <cfparam name="FORM.performEdit" default="0">
<body onload="opener.location.reload()">
<cfoutput>
<div id="stylized" class="myform">
  <h1>References Questionaire</h1>

  
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
      
       <form method="post" action="viewRefrencesQuestionaire.cfm?reportid=#url.reportid#">
        <label>Date of Interview</label><br />
         <Cfif client.usertype lte 4 and currentStatus.approved neq 2>
         	<input type="text" name="dateInterview" value="#DateFormat(questionTracking.dateInterview, 'mm/dd/yyyy')#" /> mm/dd/yyyy
         <cfelse>
         	#DateFormat(questionTracking.dateInterview, 'mmm. d, yyyy')#
         </Cfif>
        </p>
        <cfloop query="questions">
        <p>
        <label>#questions.currentrow#. #qtext#</label><br />
        <Cfif client.usertype lte 4 and currentStatus.approved neq 2>
         	<input type="text"  name="#id#" value="#answer#" />
         <cfelse>
         	#answer#
         </Cfif>
         
          
        </p>
    	 </cfloop>
         <Cfif client.usertype lte 5 and currentStatus.approved neq 2>
        
   			<input type=hidden name="refid" value="#questionTracking.fk_ReferencesID#" />
        	<table width=100%>
       			<tr>
            		<td>
						<input type="radio" name="approve" value="1" checked="checked">Needs Further Review<br/>
						<input type="radio" name="approve" value="2">Approve<br/>
						<input type="radio" name="approve" value="3">Reject<br/>
           			</td>
               		<td>
                   		<div align="right" >
	                   		<input type="hidden" name="submit" />
	                   		<button type="submit">Submit Information</button>
                   		</div>
        			</td>
            	</tr>
          	</table>
        
        <Cfelse>
        <div align="Ceter">
             	SUBMITTED
         </div>
    	</Cfif>
        </form>
</div>
</cfoutput>
</body>
</html>