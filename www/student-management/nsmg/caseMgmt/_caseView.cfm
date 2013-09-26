<!--- ------------------------------------------------------------------------- ----
	File:		index.cfm
	Author:		Josh Rahl
	Date:		July 25, 2013
	Desc:		This page contains all the information for an individual case.
				
----- ------------------------------------------------------------------------- --->

<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">View Case Details</span> 
        <em></em>
    </div>
    
    <div class="rdbox">
     <!--- Page Messages --->
    <gui:displayPageMessages 
        pageMessages="#SESSION.pageMessages.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
    
    <!--- Form Errors --->
    <gui:displayFormErrors 
        formErrors="#SESSION.formErrors.GetCollection()#"
        messageType="divOnly"
        width="98%"
        />
        <form>
        <table width=90%>
        	<Tr>
            	<td>Student: #caseInfo.StudentName# (#caseInfo.studentid#)</td>
                <td>Case Opened: <em>#caseInfo.dateOpened#</em></td>
                <td>Subject: <strong>#caseInfo.Subject#</strong></td>
                <td rowspan=3 width=80 align="center"><input type="Submit" value="Edit"></td>
                <td rowspan=3>Waiting on.... <br>
                	#caseInfo.lastDatePosted#<Br>
                    <font size=-2>Follow up by: #caseInfo.followUpDate#</font>
                </td>
            </Tr>
            <tr>
            	<td>Student: #caseInfo.programName# </td>
                <td>Case Closed: <em>#caseInfo.dateClosed#</em></td>
                <td>Tags: <strong></strong></td>
            </tr>
            <tr>
            	<td>Agent: #caseInfo.intAgent# </td>
                <td>Case Owner: <em>#caseInfo.caseOwner#</em></td>
                <td>Level: <strong>#caseInfo.level#</strong>  Status: <strong>#caseInfo.status#</strong></td>
            </tr>
            
       </table>
       </form>
       <br>
       			<hr width=80% height=1>     	
       <br>         

   
     <table align="center" width="80%">
       	<Tr>
        	<th align="left">Note</th>
            <Th align="left">Type</Th>
            <th align="left">Creator</th>
            <th align="left">Date</th>
            <th align="left">Wating On</th>
            <th align="left">Action</th>
        </tr>
        <!----Loop goes here---->
        <tr>
        	<td>#caseHistory.subject#</td>
            <Td>#caseHistory.contactType#</Td>
            <Td>#caseHistory.creator#</Td>
            <td>#caseHistory.dateOfNote#</td>
            <td>#caseHistory.waitingOn#</td>
            <td>Edit View</td>
        </tr>
        <!----End of Loop---->
	</table>
    
    <br><br>
    <form>
    <table width=80% align="center">
    	<tr>
        	<td align="right">Loop someone in:</td>
            	<td><input type="text" name="loopInEmail" size=25></td>
            <td align="right">Already in the loop:</td>
            <td><!----start loop---->#inTheLoop.email <img src=""#<!----end loop----></td>
         	<td align="right">
            <!----Only admins can delete a case---->
            <Cfif client.usertype lte 2>
           			 <input type="submit" value="Delete Case">
            </Cfif>
            </td>
         </tr>
         <tr>
         	<td colspan=4 align="center">
            	<font color="#CCCCCC">(<em>when looping someone in, they will receive notifications from here on out, they will not receive previous notifications</em>)</font>
            </td>
    </table>
    </form> 
           </div>
    <div class="rdbottom"></div> <!-- end bottom --> 
	</div>