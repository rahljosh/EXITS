<!--- ------------------------------------------------------------------------- ----
	File:		index.cfm
	Author:		Josh Rahl
	Date:		July 25, 2013
	Desc:		This page contains all the information for an individual case.
				
----- ------------------------------------------------------------------------- --->
<cfparam name="FORM.additionialInfoDiv" default="0">
<cfparam name="FORM.fileData" default="">
<cfparam name="FORM.fileDescription" default="">
<Cfparam name="FORM.loopInEmail" default="">

<script>
jQuery(document).ready(function($) {
      $(".clickableRow").click(function() {
            window.document.location = $(this).attr("href");
      });
});
</script>

<script type="text/javascript">
	$(document).ready(function(){
		$(".chzn-select").chosen(); 
		$(".chzn-select-deselect").chosen({allow_single_deselect:true}); 
	});
	
	function additionalInfo() {
		// Check if current state is visible
		var isVisible = $('#additionalInfoDiv').is(':visible');
			
		if ( isVisible ) {
			// handle visible state
			$("#newSchool").val(0);
			$("#additionalInfoDiv").fadeOut("slow");
		} else {
			// handle non visible state
			$("#newSchool").val(1);
			$("#additionalInfoDiv").fadeIn("slow");
		}

	}
</script>
<script type="text/javascript">
window.onload = function additionalInfo() {
		// Check if current state is visible
		var isVisible = $('#additionalInfoDiv').is(':visible');
			
		if ( isVisible ) {
			// handle visible state
			$("#newSchool").val(0);
			$("#additionalInfoDiv").fadeOut("fast");
			
			
		} else {
			// handle non visible state
			$("#newSchool").val(1);
			$("#additionalInfoDiv").fadeIn("slow");
		}

	}
</script>

<Cfif not val(url.caseid)>
	<cflocation url="?curdoc=student_info&studentID=#url.studentid#">
</Cfif>



<cfif isDefined('form.loopIn')>
	<cfif not len(form.loopinemail)>
		  <cfscript>
                    // Data Validation
                    // Student Transportation
                    if  ( NOT  len(TRIM(FORM.loopinemail)) ) {
                        SESSION.formErrors.Add("Please enter a name in the looped in box.");
                    }
            </cfscript>
  	<cfelse>
        <cfquery name="LoopSomeoneIn" datasource="#application.dsn#">
        insert into smg_casemgmt_loopedin (fk_caseid, email)
                            values(<cfqueryparam cfsqltype="cf_sql_integer" value="#url.caseid#">, 
                                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.loopInEmail#">)
                                
        </cfquery>
    </cfif>
   
    
</cfif>

<cfscript>
		//Student, Rep and Host Info
		qAvailableUsers = APPLICATION.CFC.CASEMGMT.availableUsers(regionID=client.regionid); 
		qLoopedInEmails = APPLICATION.CFC.CASEMGMT.loopedInEmails(caseid=url.caseid); 
</cfscript>
<Cfset loopedin = ''>
<Cfloop query="qLoopedInEmails">
	<cfset loopedin = ListAppend(loopedIn,#loopedInInfo#)>
</Cfloop>


<div class="rdholder" style="width:100%; float:right;"> 
     <div align="center">
<!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        />
	
	<!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        />
</div>           
    <div class="rdtop"> 
        <span class="rdtitle">View Case Details</span> 
        <div style="float:right;"><img src="pics/betaTesting.png"></div>
        <em></em>
    </div>
    
    <div class="rdbox">

        
      <cfinclude template="basicCaseDetails.cfm">
       
                

    <cfoutput>
    <br /><br />
     <table align="center" width="80%" cellpadding=4 cellspacing="0" border=0 >
       <tr>
                <td colspan=5 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">Details...</div>
                </td>
            </tr>
    	<cfif qFullCaseDetails.recordcount eq 0>
        	<tr>
            	<th>No details have been added to this case yet...</th>
            </tr>
        <cfelse>
    
    
       	<Tr>
        
        	<th align="left" width=700>Note</th>
            <Th align="left">Type</Th>
            <th align="left">Who</th>
            <th align="left">Date</th>
            <!---<th align="left">Wating On</th>---->
            
        </tr>
       </table>
        <cfset mainRowCheck = 0>
        <cfset subRowCheck = 0>
    <table align="center" width="80%" cellpadding=4 cellspacing="0" border=0 id=clickableRow>
        <Cfloop query="qFullCaseDetails">
        <cfquery datasource="#application.dsn#">
			insert into smg_casemgmt_case_views (fk_userid, fk_caseid, fk_messageID, Viewed)
							values(<cfqueryparam cfsqltype="cf_sql_integer" value="#client.userid#">, 
                            	   <cfqueryparam cfsqltype="cf_sql_integer" value="#url.caseid#">,
                                   <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">,
                                   <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		</cfquery>
            <tr class='clickableRow' href='index.cfm?curdoc=caseMgmt/index&action=addDetails&caseID=#url.caseID#&item=#id#' <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
           
                <td width=700>#Left(caseNote, 350)#<cfif len(caseNote) gt 350>...</cfif></td>
                <Td>#fk_contactType#</Td>
                <Td>#firstname# #lastname#</Td>
                <td>#DateFormat(caseDate, 'mmm. d, yyyy')#</td>
                <!----<td></td>---->
               
            </tr>

        </Cfloop>
      </table>
        <table align="center" width="80%" cellpadding=4 cellspacing="0" border=0 >
        </cfif>
		<TR>
        	<TD colspan=5 align="Center"><br /><a href="?curdoc=caseMgmt/index&action=addDetails&caseid=#url.caseid#" class="basicOrangeButton">Add Details</a></TD>
        </TR>
	</table>
    </cfoutput>
    <br />
    <div class="DotArrows"><div id="text">&#x25BC; <a onclick="additionalInfo();" href="##">Additional Options</a> &#x25BC;</div></div>
    <br><br>
    <div id="additionalInfoDiv"  > 
    
    <table width=80% align="center" border=0>
    	<tr>
        	<td align="right">Add File:</td>
            	<td>
                <cfoutput>
                <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data">
                <input type="hidden" value=1 name="uploadFile"/>
                	<input name="fileData" type="file" size="60" value="#form.fileData#">
                    
                    </td>
                 <td> <font size="-50%"><input type="submit" name="addFile" value="Add File" class="basicOrangeButton"/></font>
               
                </td>
           
            <td colsan=2>
           	<input type="text" placeholder="Brief Descrption..." name="fileDescription" size=20 > 
          		 </form>
                </cfoutput>
                
                <font color="#CCCCCC">(<em>have a document that pertains to this case? Add it here.</em>)</font>
            </td>
          <td align="right" rowspan=2 valign="middle">
            <!----Only admins can delete a case---->
            <Cfif client.usertype lte 2>
            <cfoutput>
             <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" enctype="multipart/form-data">
           			 <input type="submit" name="DeleteCase" value="Delete Case" class="basicRedButton">
             </form>
             </cfoutput>
            </Cfif>
            </td>
         	
         </tr>
    	<tr>
        	<td align="right">Loop someone in:</td>
            	<td>
                <cfoutput>
                 <form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post" >
                	
                	 <select name="loopInEmail" data-placeholder="Enter name or ID" class="chzn-select" tabindex="2" size=20>
                       
                       <option value=""></option>
                       <cfloop query="qAvailableUsers">
                       	<cfif not listFind(#loopedin#, '#firstName# #lastname#')>
                           <option value="#userid#">#firstName# #lastname# (#userid#)</option>
                     	</cfif>
                       </cfloop>
                   </select>
                 </td>
                 <td><font size="-50%"><input type="submit" name="loopIn" value="Loop In " class="basicOrangeButton"/></font>
           		</form>
           		</cfoutput>
                </td>
            <td><font color="#CCCCCC">(<em>when looping someone in, they will receive notifications from here on out</em>)</font></td>
          
         	
         </tr>
         <tr>
         	<td align="right">Already in the loop:</td>
         	<td colspan=3 align="left">
            	 <Cfoutput><cfif len(loopedIn)>#loopedIn#<cfelse><em>No one, yet.</em></cfif></Cfoutput>
            </td>
    </table>
  
    			</div>
           </div>
    <div class="rdbottom"></div> <!-- end bottom --> 
	</div>