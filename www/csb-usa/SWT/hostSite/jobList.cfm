<Cfparam name="url.sortby" default="employer">



<cfif isDefined('url.redo')>
	<cfloop list="#GetClientVariablesList()#" index="ThisVarName">
		<cfset temp = DeleteClientVariable(ThisVarName)>
	</cfloop>
</cfif>
<cfif isDefined('form.pass')>
	<cfset client.pass = form.pass>
</cfif>
<cfif isDefined('form.user')>
	<cfset client.user = form.user>
</cfif>
<style type="text/css">
.hsText {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
	color: #000;
}
.white {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
	color: #FFF;
}
.JLtext {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	color: #000;
	}
.BLinks {
	font-family: Verdana, Geneva, sans-serif;
	color: #374C87;
	font-weight: bold;
	padding-bottom: 5px;
	font-size: 10px;
}
.BLinks:link {
	color: #374C87;
	text-decoration: none;
}
.BLinks:visited {
	text-decoration: none;
	color: #374C87;
}
.BLinks:hover {
	text-decoration: underline;
	color: #000;
}
.BLinks:active {
	text-decoration: none;
	color: #364B86;
}
.table {
	border: thin solid #666;
	margin-right: auto;
	margin-left: auto;
}
</style>
<br />
  <h2>List of Available Host Sites</h2>	
<p>By choosing the CSB-placement option of the program, participants have a job placement through the sponsor. </p>
<p>To ensure a smooth access to the list of available host sites, CSB has designed an online listing available solely for the current partner organizations. Below please find the list, categorized by season. Each flyer will include the name of the company, its location, position(s) available, skills required, employment benefits, housing, transportation and other information essential to determine the conditions of employment. To confirm acceptance, an interview must be passed and a job offer will need to be signed.</p>

		      <cfif NOT isDefined('client.user')>
              <form action="hostsite.cfm?loged=yes" method="post" >
              <table width="220" border="0" align="center" bgcolor="#666666">
	            <tr>
	              <td class="white">Login</td>
                </tr>
	            <tr>
	              <td bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="5" cellspacing="0" class="text">
	                <tr>
	                  <td width="21%" class="hsText">Username:</td>
	                  <td width="79%"><input name="user" type="text" class="text" id="user" size="20"></td>
                    </tr>
	                <tr>
	                  <td class="hsText">Password:</td>
	                  <td><input name="pass" type="password" class="text" id="pass" size="20"></td>
                    </tr>
	                <tr bgcolor="#EFEFEF">
	                  <td colspan="2" align="right"><input type="submit" name="Submit" class="hsText" value="Submit"></td>
                    </tr>
                  </table>
                 
                  </td>
                </tr>
              </table>
              </form><br />
              <p> <strong><em>Note:</em></strong><em> CSB will accept participants on a first come, first served basis. CSB and the host sites reserve the right to make the final decision.</em></p>
              <cfelse>
	              	<cfif client.user EQ 'csbagent' AND client.pass EQ 'listjobs-2012'>
						<SCRIPT LANGUAGE="JavaScript"> 
<!-- Begin
function formHandler2(form){
var URL = document.formmonth.month.options[document.formmonth.month.selectedIndex].value;
window.location.href = URL;
}
// End -->
</SCRIPT>
<cfparam name="url.section" default="viewJobListing">
<cfparam name="url.season" default="0">
<h4>PLEASE CHOOSE A PROGRAM SEASON TO VIEW THE CURRENT JOBS AVAILABLE:</h4>
<table border=0>
	<tr>
    	<td valign="middle" class="hsText">Viewing jobs available in:</td><td valign="top"> <form name="formmonth">
		<select name="month" onChange="javascript:formHandler2()">
        <option value="http://www.csb-usa.com/SWT/hostsite.cfm?"></option>
		<option value="http://www.csb-usa.com/SWT/hostsite.cfm?season=spring" <cfif url.season is 'spring'>selected</cfif>>Spring</option>
		<option value="http://www.csb-usa.com/SWT/hostsite.cfm?season=summer" <cfif url.season is 'summer'>selected</cfif>>Summer</option>
        <option value="http://www.csb-usa.com/SWT/hostsite.cfm?season=winter" <cfif url.season is 'winter'>selected</cfif>>Winter</option>
		</select>
	</form>
    </td>
    <td align="right" > &nbsp;<a href="http://www.csb-usa.com/SWT/hostsite.cfm?section=logout" class="BLinks">LOG OUT</a></td>
  </tr>
</table>
<br />
<cfquery name="available_posistions" datasource="MySQL">
select title, file, employer, state, (#url.season#) as spots
from extra_web_jobs

where #url.season# > 0
order by #url.sortby#
</cfquery>
<cfoutput>


<table width="650" cellpadding=4 cellspacing=0 class="table">
	
	<tr bgcolor="##999999">
   	  <Td width="224" align="center" bgcolor="##999999" class="white"><u><a href="hostsite.cfm?season=#url.season#&sortby=employer">Host Employer</a></Td>
      <Td width="53" align="center" class="white"><u><a href="hostsite.cfm?season=#url.season#&sortby=state">State</a></Td>
   	  <Td width="191" align="center" bgcolor="##999999" class="white"><u><a href="hostsite.cfm?season=#url.season#&sortby=title">Position Name</a></Td>
   	  <Td width="146" align="center" bgcolor="##999999" class="white"><u><a href="hostsite.cfm?season=#url.season#&sortby=spots">Spots Available</td>
    </tr>
<cfloop query="available_posistions">
	<Tr <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
    	<Td align="center" class="hsText"><cfif file is not ''>
        <a href="http://ise.exitsapplication.com/nsmg/uploadedfiles/extra_jobs/#file#" class="BLinks">
		</cfif>
		#employer#</Td><Td align="center" class="JLtext">#state#</td><Td align="center" class="JLtext">#title#</td><Td align="center" class="JLtext">#spots#</td>
    </Tr>	
</cfloop>
</table>

</cfoutput>
                   	<cfelseif client.user EQ 'anca' AND client.pass eq 'qaz123'>
 	                   <cfparam name="url.section" default="adminJobListing">
<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
order by #url.sortby#
</cfquery>
<br />
<cfoutput>


<table width="650" cellpadding=4 cellspacing=0 class="table">
	<Tr>
	  <td colspan=8 align="center" bgcolor="##999999" class="white">List of Available Host Sites</td>
	  <Tr>
   	  <td colspan="3" align="center" bgcolor="##E6E6E6" class="hsText">&nbsp;</td>
   	  <td colspan="3" align="center" bgcolor="##FFFFCC" class="hsText">SPOTS AVAILABLE</td>
   	  <td colspan="2" align="center" bgcolor="##E6E6E6" class="hsText">&nbsp;</td>
   	  <tr align="center">
    	<Td width="162"><a href="hostsite.cfm?sortby=employer" class="swtblack">Host Employer</a></Td>
        <Td width="32" class="hsText">State</Td>
    	<Td width="165" class="hsText">Position Name</Td>
        <Td width="52" class="hsText">Spring</Td>
        <Td width="52" class="hsText">Summer</Td>
        <td width="54" class="hsText">Winter</td>
    	<td width="31" class="hsText">Edit</td>
    	<td width="34" class="hsText">Delete</td>
    </tr>
<cfloop query="available_posistions">
	<Tr align="center" <cfif available_posistions.currentrow mod 2>bgcolor="cccccc"</cfif>>
	  <Td class="hsText"><cfif file is not ''>
        <a href="http://ise.exitsapplication.com/nsmg/uploadedfiles/extra_jobs/#file#" class="BLinks">
		</cfif>#employer#</Td>
        <Td>
		  <span class="JLtext">#state#</span></Td>
    	<Td>
		  <span class="JLtext">#title#</span></Td>
          <Td class="JLtext">#spring#</Td>
          <Td class="JLtext">#summer#</Td>
          <td class="JLtext">#winter#</td>
          <td><a href="hostsite.cfm?edit&jobid=#jobid#"><img src="http://ise.exitsapplication.com/nsmg/pics/edit.png" border="0"></a></td>
          <td><a href="hostSite/delete_job.cfm?jobid=#jobid#"><img src="http://ise.exitsapplication.com/nsmg/pics/delete.png" border="0"></a>
    </Tr>	
</cfloop>
</table >
<table width="650" border="0" cellspacing="5">
  <tr>
    <td align="right"><a href="http://www.csb-usa.com/SWT/hostsite.cfm?section=logout" class="BLinks">LOG OUT</a></td>
  </tr>
</table>

<br />
<hr />
<br />

<Cfif isDefined('url.edit')>

<cfquery name="available_posistions" datasource="MySQL">
select *
from extra_web_jobs
where jobid = #url.jobid#
</cfquery>
<cfoutput>




<cfform method="post" action="http://www.csb-usa.com/SWT/hostSite/insert_job.cfm" enctype="multipart/form-data">

 		<table width="450" class="table" cellspacing=4>
            <tr>
              <td colspan="2"align="center" bgcolor="##999999" class="white">Edit Job</td>
              </tr>
              <tr>
        
                <td align="right" class="hsText">Host Employer:</td>
                <Td><cfinput type="text" name="employer" size = 30 value="#available_posistions.employer#"   /></Td>
            </tr>
                  <tr>
        
                <td align="right" class="hsText">State:</td>
                <Td><cfinput type="text" name="state" size = 10 value="#available_posistions.state#" /></Td>
            </tr>
        
            <tr>
        
                <td align="right" class="hsText">Position Name:</td><Td><cfinput type="text" name="title" size = 30 value="#available_posistions.title#"  /></Td>
            </tr>
            <tr>
                
                <Td align="right" class="hsText">Spring</Td><Td><cfinput type="text" name="spring" size = 10 value="#available_posistions.spring#"/></Td>
            </tr>
            <tr><Td align="right" class="hsText">Summer</Td><Td><cfinput type="text" name="summer" size = 10  value="#available_posistions.summer#" /></Td>
            </tr>
            <tr><td align="right" class="hsText">Winter</td><Td><cfinput type="text" name="winter" size = 10  value="#available_posistions.winter#" /></Td>
            </tr>
   			<tr valign="middle">
            <td align="right" class="hsText">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" class="hsText" size= "35"> </td>
            </tr>
            <tr align="center" bgcolor="##999999">
            <td colspan="2" class="hsText"> <input type="hidden" name="editJob" value=#url.jobid# />
         <input type="submit" class="hsText" value="Post Job" /></td>
            </tr>
         </table>
         </cfform>
	</cfoutput>

<cfelse>

        <cfform method="post" action="http://www.csb-usa.com/SWT/hostSite/insert_job.cfm" enctype="multipart/form-data">
        <table width="450" class="table" cellspacing=4>
            <tr>
              <td colspan="2"align="center" bgcolor="##999999" class="white">Add a Job</td>
              </tr>
              <tr>
        
                <td align="right" class="hsText">Host Employer:</td>
                <Td><cfinput type="text" name="employer" size = 30  /></Td>
            </tr>
                  <tr>
        
                <td align="right" class="hsText">State:</td>
                <Td><cfinput type="text" name="state" size = 10  /></Td>
            </tr>
        
            <tr>
        
                <td align="right" class="hsText">Position Name:</td><Td><cfinput type="text" name="title" size = 30  /></Td>
            </tr>
            <tr>
                
                <Td align="right" class="hsText">Spring</Td><Td><cfinput type="text" name="spring" size = 10 value="0"/></Td>
            </tr>
            <tr><Td align="right" class="hsText">Summer</Td><Td><cfinput type="text" name="summer" size = 10 value="0" /></Td>
            </tr>
            <tr><td align="right" class="hsText">Winter</td><Td><cfinput type="text" name="winter" size = 10  value="0" /></Td>
            </tr>
            <tr valign="middle">
            <td align="right" class="hsText">Additional File (PDF ONLY):</td><td><cfinput type="file" name="additional_file" class="hsText" size= "35"> </td>
            </tr>
            <tr align="center" bgcolor="##999999">
            <td colspan="2" class="hsText"> <input type="hidden" name="insertJob" />
         <input type="submit" class="hsText" value="Post Job" /></td>
            </tr>
         </table>
        
        </cfform>    
</Cfif>
</cfoutput>
					<cfelse>
	                  	<p>Wrong User or password!</p><br /><br />
                      	<span class="hsText"><a href="hostsite.cfm" class="BLinks">TRY AGAIN</a>
                  	    </span>
	              	</cfif>
              </cfif>
           
<h2>&nbsp;</h2>