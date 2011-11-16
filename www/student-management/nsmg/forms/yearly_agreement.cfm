    
            <Cfscript>
                //Check if paperwork is complete for season
				qPaperWork = APPLICATION.CFC.udf.paperworkCompleted(userid=URL.userid,season=9);
			</cfscript>


    
<style type="text/css">
    .outline {
	padding: 5px;
	border: thin solid #666;
	width: 500px;
	margin-left: 30px;
}
    .yellowbox {
	background-color: #FFC;
	width: 480px;
	margin-left: 30px;
	padding-top: 20px;
	padding-right: 20px;
	padding-bottom: 10px;
	padding-left: 20px;
}
</style>
  

  <Cfif qPaperWork.complete eq 1>
	<cfset temp = DeleteClientVariable("agreement_needed")>
  	<cflocation url ="index.cfm?curdoc=initial_welcome">
  </Cfif>
<div align="Center">
<div class="yellowbox">

<p>The information below needs to be updated for the new season.  Access to <strong>EXITS</strong> has been disabled until these agreements have been signed, information submited and reference chack as well as background check is compelete.<br /><Br />  Once your information has been verified you will receive an email with further information.</p>
<p><strong>ALL FOUR SECTIONS ARE REQUIRED</strong></p>

</div><br />
<cfoutput>
<div class="outline">
<table width="100%" align="center"  cellspacing=5 cellpadding=4>
	<tr bgcolor="##666" cellspacing=0 cellpadding=4>
    	<td width="350"><h2><font color="##FFFFFF">&nbsp;&nbsp;Item</font></h2></td><Td width="100" align="center"><h2><font color="##FFFFFF">Status</font></h2></Td>
    </tr>
	<Tr>
	  	<Td><h2>Services Agreement</h2></Td>
        <td align="center" >
			<cfif qPaperWork.arAgreement is ''>
        		<a href="javascript:openPopUp('forms/displayRepAgreement.cfm?curdoc=displayRepAgreement', 640, 800);"><img src="pics/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
             <img src="pics/noInfo.png" width="120" height="30" border="0" />
          </cfif> 
        </td>
    </tr>    
    <Tr>
	  	<Td><h2>CBC Authorization</h2></Td>
        <td align="center">
        	<cfif qPaperWork.cbcAuth is ''>
            	<a href="javascript:openPopUp('forms/cbcAuthorization.cfm?curdoc=cbcAuthorization', 640, 800);"><img src="pics/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
            	 <img src="pics/noInfo.png" width="120" height="30" border="0" />
          </cfif>
        </td>
    </tr>  
    <Tr>
	  	<Td><h2>Employment History</h2></Td>
        <td align="center">
        	<cfif qPaperWork.prevExperience eq 0>
            	<a href="javascript:openPopUp('forms/employmentHistory.cfm?curdoc=employmentHistory', 640, 800);"><img src="pics/infoNeeded.png" width="120" height="30" border="0" /></a>
            <cfelse>
            	 <img src="pics/noInfo.png" width="120" height="30" border="0" />
          </cfif>
        </td>
    </tr> 
    <Tr >
	  	 <Td><h2>References</h2></Td><td align="left" <cfif qPaperWork.numberRef lt 2></cfif>>
          	<cfif qPaperWork.numberRef lt 4>
          		<a href="javascript:openPopUp('forms/repRefs.cfm?curdoc=repRefs', 640, 800);"><img src="pics/infoNeeded.png" width="120" height="30" border="0" /></a>
                
         	<cfelse>
           	  
              <cfif qPaperWork.ref1 is '' OR qPaperWork.ref2 is ''>
                Waiting on reference verification
              <cfelse>
                <img src="pics/noInfo.png" width="120" height="30" border="0" />
              </cfif>
            </cfif>
         </td>
    </Tr>
</table>
</div>
</div>
</cfoutput>