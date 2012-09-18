<!--- ------------------------------------------------------------------------- ----
	
	File:		agreementCBC.cfm
	Author:		Marcus MElo
	Date:		July 26, 2012
	Desc:		CBC Contract
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output ---> 
<cfsilent>

	<cfscript>
		// SSN
		FORM.SSN = APPLICATION.CFC.UDF.displaySSN(varString=qGetUser.SSN, displayType='user');
	</cfscript>

</cfsilent>

<cfoutput>

<img src="https://ise.exitsapplication.com/nsmg/pics/#CLIENT.companyID#_short_profile_header.jpg" />

<p>
	<cfif CLIENT.companyID NEQ 14>As mandated by the Department of State, a<cfelse> A</cfif> Criminal Background Check on all Office Staff, Regional Directors/
    Managers, Regional Advisors, Area Representatives and all members of the host family aged 18 and above is 
    required for involvement with the <cfif CLIENT.companyID NEQ 14>J-1 Secondary School</cfif> Exchange <cfif CLIENT.companyID NEQ 14>Visitor</cfif> Program. 
</p>

<p>
	I, <strong>#qGetUser.firstName# #qGetUser.middlename# #qGetUser.lastname#</strong> do hereby authorize verification of all information in my application for 
    involvement with the Exchange Program from all necessary sources and additionally authorize any duly recognized agent of General Information Services, Inc. to 
    obtain the said records and any such disclosures.
</p>

<p>
	Information appearing on this Authorization will be used exclusively by General Information Services, Inc. for identification
	purposes and for the release of information that will be considered in determining any suitability for participation in the
	Exchange Program.
</p>

<p>	
	Upon proper identification and via a request submitted directly to General Information Services, Inc., I have the right to
    request from General Information Services, Inc. information about the nature and substance of all records on file about me
    at the time of my request. This may include the type of information requested as well as those who requested reports from
    General Information Services, Inc. within the two-year period preceding my request.  
</p>

<table width="100%">
    <tr>
        <td>
             <table width="100%">
                <tr>
                    <td><u>Current Address</u></td>
                </tr>
                <tr>    
                    <td>
                        <strong>
                            #qGetUser.address#<br />
                            <cfif LEN(qGetUser.address2)>#qGetUser.address2# <br /></cfif>
                            #qGetUser.city# #qGetUser.state#, #qGetUser.zip#
                        </strong>
                    </td>
                </tr>
             </table>   
          </td>
          <td>
              <table width="100%">
                <tr>
                    <td><u>Previous Address</u></td>
                <tr>
                    <td>
                        <strong>
                            #qGetUser.previous_address#<br />
                            <cfif LEN(qGetUser.address2)>#qGetUser.previous_address2# <br /></cfif>
                            #qGetUser.previous_city# #qGetUser.previous_state# #qGetUser.previous_zip#
                        </strong>
                    </td>
                </tr>
             </table>     
        </td>
    </tr>
</table> 

<hr width=50% align="center" />

<table width="100%">
    <tr>
        <td><u>Date of Birth</u></td>
        <td>#DateFormat(qGetUser.dob, 'mm/dd/yyyy')#</td>
    </tr>
    <tr>
        <td><u>Social Security Number</u></td>
        <td>#FORM.SSN#</td>
    </tr>
</table>

</cfoutput>