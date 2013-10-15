<cfparam name="form.fullName" default="">
<cfparam name="form.email" default="">
<cfparam name="form.process" default="">
<cfparam name="form.fileData" default="">
<cfparam name="form.submitted" default="">
 <cfparam name="submitSuccess" default="0">
 

 
  <div class="column1">
  <div class="darkBox">
  WIN A BAG OF ISE SWAG!
   
  </div>
  <div class="boxClear">&nbsp;</div>

       <div class="column3">
         <div class="promoLine">&nbsp;</div>
       <p><span class="promoHeader">Rules:</span><br />Submit a picture for the contest & Vote on a picture in our gallery.</p>
  <p><span class="promoHeader">The contest will run October 21st through November 8th.</span><br />
    </p>
    <div class="promoLine">&nbsp;</div>
<p><span class="promoHeader">To Enter Contest</span>
  <br />

  <cfif (not len(form.email) or not len(form.fileData) or not len(form.fullName)) and val(form.submitted)>
  	<table align="center" bgcolor="#ffa510">
    	<Tr>
        	<td>
            <img src="images/booAlert.jpg" />
            </td>
        	<td valign="center">
            <cfif not len(form.fullName)>
            Please enter your full name.<br />
            </cfif>
            <cfif not len(form.email)>
            Please enter your email address.<br />
            </cfif>
            <cfif not len(form.fileData)>
            Please select an image to be entered into the contest.<br />
            </cfif>
            </td>
        </Tr>
    </table>
  </cfif>
 
  <cfif len(form.fullName) and len(form.email) and len(form.fileData)>
  	<Cfset uuid = '#createuuid()#'>
     <cffile 
        	action="upload" 
            filefield="FORM.fileData" 
            destination="C:\websites\student-management\nsmg\uploadedfiles\promotions\1\" 
            nameconflict="makeunique">
    <cffile action="rename" source="C:\websites\student-management\nsmg\uploadedfiles\promotions\1\#file.ServerFilename#.#file.ServerFileExt#" 
    		destination = "C:\websites\student-management\nsmg\uploadedfiles\promotions\1\#uuid#.#file.ServerFileExt#">
    <cfquery name="insertInfo" datasource="mysql">        
    insert into smg_promotion_entries (name, email, fileName, promoID, dateSubmitted, uuid)
    							values(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fullName#">,
                                 		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.email#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#.#file.ServerFileExt#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
                                        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#uuid#">
                                        )
                                        
    </cfquery>
	<cfset submitSuccess = 1>
    <cfmail to="#form.email#" subject="Halloween Pic Submission" from="support@iseusa.com" type="html">
    The attached picture was submitted.  
    
    To approve click here:  <a href="https://www.iseusa.com/promotions/approve.cfm?uuid=#uuid#"><strong>Approve</strong></a><br /><br />
    To deny click here: <a href="https://www.iseusa.com/promotions/deny.cfm?uuid=#uuid#"><strong>Deny</strong></a><br /><br />
    
    If you click <strong>Approve</strong>, the image will be approved and instantly visable on the site and the person submitting will be notified.<br />
   	If you click <strong>Deny</strong>, the image and entry will be deleted and the person submitting will be notified.
   <br /><br />
   	 <cfmailparam file="C:\websites\student-management\nsmg\uploadedfiles\promotions\1\#uuid#.#file.ServerFileExt#" 
        disposition="inline" 
        contentID="image1"> 
    </cfmail>
  </cfif>
   <cfquery name="picEntries" datasource="mysql">
 select *
 from smg_promotion_entries
 where promoID = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
 </cfquery>
<a name="contestEntry"></a>Upload your Halloween Costume photos here to automatically be entered into the contest.</p>
<cfoutput>
<cfif val(submitSuccess)>
	<table align="center" cellspacing="4" bgcolor="##ffa510" width=450>
    	<Tr>
        	
        	<td valign="center">
            Your entry has been received.  Once it is approved, it will appear on this page and be available for voting.<br /><br /> Check back often to vote for your favorite!
            </td>
            <td>
            <img src="images/spiderAlert.jpg" />
            </td>
        </Tr>
    </table>
<cfelse>
<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#&amp;##contestEntry" method="post" enctype="multipart/form-data">
<input type="hidden" name="submitted" value="1"/>
<table width="571" cellpadding="3" cellspacing="6">
	<tr>
    	<td width="334">
        <table>
            <tr>
                <td>Full Name</td><td><input name="fullName" value="#form.fullName#" type="text" size=30></td>
             </tr>
             <tr>
                <Td>Email </td><td><input name="email" value="#form.email#" type="text" size=30></td>
             <tr>
                <td>Picture</td><td><input type="file" name="fileData" size=25/></td>
             </tr>
            <tr>
                <td colspan=2 align="center"><input name="send" type="submit" value="Submit"></td>
            </tr>
        </table>
        </td>
        <td width="255" valign="top">
        
        <em><font size=-1>Your name and email address will NOT be posted. They will only be used for contact by ISE.</font></em>

        </td>
      </tr>
   </tr>
  </table>      	
</form>
</cfif>

<br /><br />
<!--end column3 --></div>

<div class="clearfix"> </div>

   <div class="column2">
   <Cfloop query="picEntries">
   <cfif isApproved neq 1>
  <div class="photos"><img src="promotions/images/Approval.jpg" width="200" height="180" /><div align="right"></div></div>
   <cfelse>
    <div class="photos"><img src="https://ise.exitsapplication.com/nsmg/uploadedfiles/promotions/1/#fileName#" width="200" height="180" /><div align="right"><input name="send" type="submit" value="vote"></div></div>
   </cfif>
   </Cfloop>
  </cfoutput>
<!--end column2 --></div>
	


     <div class="clearfix"> </div>
<!--end column1 --></div>