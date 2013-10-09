 	<Cfparam name="queryName" default="qBasicCaseDetails">
	<Cfparam name="studentList" default="">
    <Cfparam name="loopedIn" default="">
    <Cfparam name="rowcount" default="1">

<cfoutput>

        <table width=80% border=0 align="Center" cellpadding="5" cellspacing="0">
        <!----Don't show the label for the list of cases---->
        <cfif url.action neq 'viewCaseList'>
        <tr>
                <td colspan=6 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">Basic Info</div>
                </td>
        	</tr>
        </cfif>
        
        	 <tr <cfif rowcount mod 2>bgcolor="##efefef"</cfif>>
              <cfif url.action eq 'viewCaseList'>
             	<td rowspan="2"><a href="index.cfm?curdoc=caseMgmt/index&amp;action=viewCase&amp;caseID=#caseID#" class="basicOrangeButton">View</a></td>
             <cfelse>
             	 <td rowspan="2"><a href="index.cfm?curdoc=caseMgmt/index&amp;action=basics&amp;caseID=#caseID#" class="basicOrangeButton">Edit</a></td>  
             </cfif>  
            	<td colspan=2 width=50%>Subject: <strong>#qBasicCaseDetails.caseSubject#</strong></td>
                <td width=25%>Level: <strong>#qBasicCaseDetails.levelDescription#</strong></td>
                <td width=25%>Privacy <strong>#qBasicCaseDetails.privacyDescription#</strong></td>
             
            </tr>
            <Tr <cfif rowcount mod 2>bgcolor="##efefef"</cfif>>
            	<td colspan=2 valign="top"> Opened: #DateFormat(qBasicCaseDetails.caseDateOpened, 'mmm. d, yyyy')#</td>
                <td valign="top">Case <cfif isDate(qBasicCaseDetails.caseDateClosed)>Closed<cfelse>Status</cfif>: <cfif isDate(qBasicCaseDetails.caseDateClosed)> #DateFormat(qBasicCaseDetails.caseDateClosed, 'mmm. d, yyyy')#<cfelse>#qBasicCaseDetails.statusDescription#</cfif></td>
                <td valign="top">Case Owner: #qBasicCaseDetails.caseOwnerInfo#
                
                <cfif qBasicCaseDetails.fk_caseCreatedBy neq qBasicCaseDetails.fk_caseOwner><br /> <em>Created By: #qBasicCaseDetails.caseCreatorInfo#</em></cfif>
                </td>
            </Tr>
       <!----Dont show the student info if showing the whole list of cases---->
      <cfif url.action neq 'viewCaseList'>
           </table>
           <br />

           <table width=80% border=0 align="Center" cellpadding="5" cellspacing="0">
            <tr>
                <td colspan=5 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">Who's Involved</div>
                </td>
            </tr>
        	<tr>
            	<Th align="left">Student</Th><Th align="left">Program</Th><th align="left">Host Family</th><th align="left">Area Representative</th><th align="left">Regional Manager</th>
            </tr>
      
          <Cfloop query="qUsersInvolved">
                <Tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                    <td><A href="?curdoc=caseMgmt/index&action=viewCaseList&studentID=#studentid#">#stuFirstName# #stuLastName# (#studentid#)</A></td>
                    <td>#programName#</td>
                    <td>#fatherFirstname# <cfif #fatherFirstName# is not ''>&amp;</cfif> #motherFirstName# #hostLastName# (#hostid#)</td>
                    <td>#areaRepFirstName# #areaRepLastName# (#arearepid#) </td>  
                      <td>#regManFirstName# #regManLastName# (#regManid#) </td> 
                </Tr>
            </Cfloop>
      	</cfif>
		</table>
        <cfif val(qGetFiles.recordcount) and  url.action neq 'viewCaseList'>
 <br />

           <table width=80% border=0 align="Center" cellpadding="5" cellspacing="0">
            <tr>
                <td colspan=5 align="left">
                    <div class="dottedLineBelow" style="font-size:14px; font-weight:bold;">#qGetFiles.recordcount# Supporting Document<Cfif qGetFiles.recordcount gt 1>s</Cfif></div>
                </td>
        	<tr>
            	<Th align="left">Description</Th><Th align="left">Date Added</Th><th align="left">Added By</th><th align="left">Delete</th>
            </tr>
      
          <Cfloop query="qGetFiles">
                <Tr <cfif currentrow mod 2>bgcolor="##efefef"</cfif>>
                    <td><a href="uploadedfiles/casemgmt/#url.caseid#/#qGetFiles.servername#.#qGetFiles.serverext#" target="_new">#qGetFiles.description#</a></td>
                    <td>#DateFormat(qGetFiles.dateCreated,'mmm. d, yyyy')#</td>
                    <td>#firstname# #lastname#</td>
                    <td><cfif client.userid eq uploadedBy or client.usertype lte 2><a href="index.cfm?curdoc=caseMgmt/index&action=viewCase&delete=#id#&caseid=#url.caseid#"><img src="pics/invalid.png" border=0/></a><cfelse>---</cfif></td>
                </Tr>
            </Cfloop>
            </table>
      	</cfif>
		

      </cfoutput>