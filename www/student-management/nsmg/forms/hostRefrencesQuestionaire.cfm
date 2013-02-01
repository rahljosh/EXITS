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
<script type="text/javascript">
		function zp(n){
		return n<10?("0"+n):n;
		}
		function insertDate(t,format){
		var now=new Date();
		var DD=zp(now.getDate());
		var MM=zp(now.getMonth()+1);
		var YYYY=now.getFullYear();
		var YY=zp(now.getFullYear()%100);
		format=format.replace(/DD/,DD);
		format=format.replace(/MM/,MM);
		format=format.replace(/YYYY/,YYYY);
		format=format.replace(/YY/,YY);
		t.value=format;
		}
		</script>
<Cfquery name="questions" datasource="#application.dsn#">
select *
from smg_host_reference_questions
where active = 1
</cfquery>
<Cfparam name="FORM.dateInterview" default="">
<CFloop query="questions">
	<Cfparam name="FORM.#id#" default="">
</CFloop>
<cfscript>
		// Get User By Userid
		qGetProspectiveHost = APPLICATION.CFC.HOST.getHosts(hostID=url.hostID);
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
            insert into smg_host_reference_tracking (dateInterview, interviewer, arearepid, fk_referencesID, hostid)
                                    values(#CreateODBCDate(form.dateInterview)#, #client.userid#, #url.rep#, #url.ref#, #url.hostid#)
             </cfquery>
    
            <Cfquery name="reportID" datasource="#application.dsn#">
            select max(id) as reportID
            from smg_host_reference_tracking
            </cfquery>
            <Cfif client.usertype lte 5>
            	<cfquery datasource="#application.dsn#">
                update smg_family_references
                set approved = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
                where refID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ref#">
                </Cfquery>
            </Cfif>
            <cfloop query="questions">
                <cfquery datasource="#application.dsn#">
                insert into smg_host_reference_answers (fk_reportID, fk_questionID, answer)
                                    values(#reportID.reportID#, #id#, <Cfqueryparam cfsqltype="cf_sql_varchar" value="#Evaluate('form.' & id)#"> )
                </cfquery>
            </cfloop>
            
        <cfquery name="markApproved" datasource="#application.dsn#">
        update smg_host_reference_tracking
        set
        	isSubmitted = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
    	<Cfif client.usertype eq 7>
            areaRepStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">,
            areaRepDateStatus = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        <cfelseif client.usertype eq 6>
            regionalAdvisorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">,
            regionalAdvisorDateStatus = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        <cfelseif client.usertype eq 5>
            regionalManagerStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">,
            regionalManagerDateStatus = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        <cfelseif client.usertype lte 4>
            facilitatorStatus = <cfqueryparam cfsqltype="cf_sql_varchar" value="approved">,
            facilitatorDateStatus = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        </Cfif>
    	where  id = <cfqueryparam cfsqltype="cf_sql_integer" value="#reportID.reportID#">
    	</cfquery>
        
        
		<cfscript>
			// Get List of Host Family Applications
			qGetHostInfo = APPLICATION.CFC.HOST.getApplicationList(hostID=URL.hostID);	
		
            // Use same approval process of the host family sections
            APPLICATION.CFC.HOST.updateReferenceStatus(
                hostID=qGetHostInfo.hostID,
                referenceID=reportID.reportID,
                action="approve",
                notes="",
                areaRepID=qGetHostInfo.areaRepID,
                regionalAdvisorID=qGetHostInfo.regionalAdvisorID,
                regionalManagerID=qGetHostInfo.regionalManagerID
            );
        </cfscript>       
        
            <body onload="opener.location.reload()">
           
			<script language="javascript">
                // Close Window After 1.5 Seconds
                setTimeout(function() { parent.$.fn.colorbox.close(); }, 1500);
            </script>
		
            
            <div align="center">
            
            <h1>Succesfully Submited.</h1>
            <em>this window should close shortly</em>
            </div>
            <cfabort>
     </cfif>      
</cfif>



<Cfquery name="refrences" datasource="#application.dsn#">
select *
from smg_family_references
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
        	<strong>Host Family:</strong> #qGetProspectiveHost.fatherfirstname# <cfif #qGetProspectiveHost.motherlastname# is not '#qGetProspectiveHost.fatherlastname#'> #qGetProspectiveHost.fatherlastname#</cfif> <cfif #qGetProspectiveHost.fatherfirstname# is not '' and #qGetProspectiveHost.motherfirstname# is not ''>&amp;</cfif> #qGetProspectiveHost.motherfirstname# #qGetProspectiveHost.motherlastname#    (#qGetProspectiveHost.hostID#)<br />
	   
            <strong>Interviewer:</strong> #qGetUserInfo.firstname# #qGetUserInfo.lastname# (#qGetUserInfo.userID#)<br />
      </p>
      
         
 		 <h1>Reference Information</h1>
         <p>
         <strong>Name:</strong> #refrences.firstname# #refrences.lastname# <br />
         <strong>Phone:</strong> #refrences.phone#<br />
         <strong>Email:</strong> #refrences.email#<br />
         <strong>Address:</strong> #refrences.address# #refrences.address2# #refrences.city# #refrences.state#, #refrences.zip#<Br />
         <!----<strong>Relationship:</strong> #refrences.relationship# (#refrences.howLong#)---->
        </p>
 		
        <br />
       	<cfform method="post" action="hostRefrencesQuestionaire.cfm?hostid=#qGetProspectiveHost.hostID#&rep=#url.rep#&ref=#url.ref#">
       
        <label>Date of Interview</label><br />
        <cfinput type="text" name="dateInterview" size="10" value="#form.dateInterview#" mask="99/99/9999" onfocus="insertDate(this,'MM/DD/YYYY')" />
        
        
    
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