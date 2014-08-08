
<cfparam name="form.details" default="">
<cfparam name="form.process" default="0">
<cfparam name="url.item" default="0">

<Cfif val(form.process)>
	<cfscript>
		//add the details to the case
		APPLICATION.CFC.CASEMGMT.addDetails(caseID=url.caseID,caseNote=form.details,contactType=form.typeOfContact,itemID=url.item);
	</cfscript>
     <cflocation url="index.cfm?curdoc=caseMgmt/index&action=viewCase&caseID=#url.caseid#" addtoken="no">
</Cfif>
	

<Cfoutput>

<div class="rdholder" style="width:100%; float:right;"> 
                
    <div class="rdtop"> 
        <span class="rdtitle">Add Details</span> 
        <div style="float:right;"></div> 
    </div>
    
    <div class="rdbox">
   <cfinclude template="basicCaseDetails.cfm">
       <br />
   
       <cfif val(url.item)>
       <cfquery name="previousDetails" dbtype="query">
           select *
           from qFullCaseDetails
           where id = <Cfqueryparam cfsqltype="cf_sql_integer" value="#url.item#">
       </cfquery>
     
       <table width=80% border=0 align="Center" cellpadding="5" cellspacing="0">
       	<Tr>
       		<th align="left">On #DateFormat(previousDetails.caseDate, 'mm/dd/yyyy')# #previousDetails.firstname# #previousDetails.firstname#  posted:</th>
       	</Tr>
        <Tr>
        	<td width=800><p>#ParagraphFormat(previousDetails.caseNote)#</p></td>
        </Tr>
        
       </table> 
       <br />
       </cfif>
       <form method="post" action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#">
       <input type="hidden" name="process" value="1" >
       <table align="center"  width=80%>
       <cfif isDefined('url.item')>
       <Tr>
       		<th align="left">Your response (if needed): </th>
       	</Tr>
       </cfif>
       	<tr>
        	<td><textarea name="details" cols=150 rows=15 placeholder'Please enter as much information as possible.'>#form.details#</textarea> </td>
        </tr>
        
           <tr>
           	<td colspan=4>
            
            	<div class="dottedLineAbove"><p style="text-align:right;">
                This is a 
                	<input name="typeOfContact" id="phoneCall" type="submit" value="Phone Call"  alt="Phone Call" border="0" class="basicOrangeButton" />&nbsp; &nbsp; &nbsp; &nbsp;  
                	<input name="typeOfContact" id="email" type="submit" value="Copy of Email"  alt="Email" border="0" class="basicOrangeButton" />&nbsp; &nbsp; &nbsp; &nbsp;  
                	<input name="typeOfContact" id="note" type="submit" value="Note"  alt="Note" border="0" class="basicOrangeButton" />&nbsp; &nbsp; &nbsp; &nbsp;  
                	<input name="typeOfContact" id="cancel" type="submit" value="Cancel"  alt="Cancel" border="0" class="basicOrangeButton" /></p></div>
                	
               
            </td>
          </Tr>
        </table>
       
</cfoutput>
 </div>
  <div class="rdbottom"></div> <!-- end bottom --> 
</div>
   

