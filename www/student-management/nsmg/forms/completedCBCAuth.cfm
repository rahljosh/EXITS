 <cfscript>
// Get User Info
		qGetUserInfo = APPLICATION.CFC.USER.getUserByID(userID=client.userID);
		FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUserInfo.SSN, displayType='user');
		
</cfscript>
<cfoutput>
<img src="https://ise.exitsapplication.com/nsmg/pics/#client.companyid#_short_profile_header.jpg" />
<p><cfif client.companyid NEQ 14>As mandated by the Department of State, a<cfelse> A</cfif> Criminal Background Check on all Office Staff, Regional Directors/
  Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is 
  required for involvement with the <cfif client.companyid NEQ 14>J-1 Secondary School</cfif> Exchange <cfif client.companyid NEQ 14>Visitor</cfif> Program. </p>

<div class="scroll">
         
  <p>I, <strong>#qGetUserInfo.firstName# #qGetUserInfo.middlename# #qGetUserInfo.lastname#</strong> do hereby authorize verification of all information in my application for involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to obtain the said records and any such disclosures.</p>
<p>Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
purposes and for the release of information that will be considered in determining any suitability for participation in the
Exchange Program.</p>
<p>Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
request from General Information Services, Inc. information about the nature and substance of all records on file about me
at the time of my request. This may include the type of information requested as well as those who requested reports from
General Information Services, Inc. within the two-year period preceding my request.  </p>

<Table>
	<Tr>
    	<Td>
             <table>
                <Tr>
                    <td><u>Current Address</u></td>
                </Tr>
                <Tr>    
                   <Td><strong>#qGetUserInfo.address#<Br>
                   <Cfif qGetUserInfo.address2 is not ''> #qGetUserInfo.address2#<Br></Cfif>
                   #qGetUserInfo.city# #qGetUserInfo.state#, #qGetUserInfo.zip#</strong>
                   </Td>
                </Tr>
            
             </table>   
          </Td>
          <td>
              <table>
                <Tr>
                    <td><u>Previous Address</u></td>
                <tr>
                	<Td>
                    <strong>#qGetUserInfo.previous_address#<br>
                    <Cfif qGetUserInfo.address2 is not ''>#qGetUserInfo.previous_address2#<Br></Cfif>
                    #qGetUserInfo.previous_city# #qGetUserInfo.previous_state# #qGetUserInfo.previous_zip#</strong>
                    </Td>
                </Tr>
             </table>     
		</td>
	</tr>
</Table> 
<hr width=50% align="center" />
<table width=100%>
	<tr>
    	<Td>Date of Birth</Td><td>#DateFormat(qGetUserInfo.dob, 'mm/dd/yyyy')#</td>
    </tr>
    <Tr>
    	<Td>Drivers License Number</Td><Td>#qGetUserInfo.drivers_license#</Td>
    </Tr>
    <tr>
    	<Td>Social Security Number</Td><Td>#form.ssn#</Td>
   
    </Td>
 </Tr>
</Table>
  </cfoutput>