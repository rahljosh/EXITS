<!--- Kill Extra Output --->
<cfsilent>

    <cfquery name="qGetCandidate" datasource="MySql">
        SELECT 
            candidateid, 
            companyID,
            programID, 
            uniqueid, 
            firstname, 
            middlename, 
            lastname,
            ds2019
        FROM 
            extra_candidates
        WHERE 
            uniqueid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.uniqueid#">
    </cfquery>
    
    <cfquery name="qGetProgram" datasource="MySql">
        SELECT 
            programID,
            programName,
            extra_sponsor
        FROM 
            smg_programs
        WHERE 
            programID = <cfqueryparam cfsqltype="cf_sql_integer" value="#qGetCandidate.programID#">
    </cfquery>

</cfsilent>

<style type="text/css">
	<!--
	.style1 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 14;
	}
	.style2 {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-size: 18;
	}
	-->
</style>

<cfoutput>

<!--- Header --->
<table width="700px" border="0">
    <tr>
        <td class="style1">
        	<img src="../../../../#APPLICATION[qGetProgram.extra_sponsor].logo#"> <br />
        </td>
        <td class="style2">
			<div align="center">
                #APPLICATION[qGetProgram.extra_sponsor].name# <br />
                119 Cooper Street <br />
                Babylon, New York 11702 <br />
                #APPLICATION[qGetProgram.extra_sponsor].toolFreePhone#
            </div>
        </td>
    </tr>
</table>

<span class="style1"> <br /> </span>

<table width="700px" border="0">
    <tr>
        <td valign="top" class="style1">TO: </td>
        <td class="style1">
        	United States Embassy/Consulate <br />
    		Social Security Administration <br /> <br />
		</td>
    </tr>
    <tr>
        <td valign="top" class="style1">From: </td>
        <td class="style1">
        	Craig Brewer <br />
            Executive Director <br />
            Responsible Officer <br />
            United States Department of State Designated Sponsor #APPLICATION[qGetProgram.extra_sponsor].programNumber#
       </td>
    </tr>
</table>

<br /> <br />
<br /> <br />

<table width="700px" border="0">
    <tr>
		<td>
            <p class="style1"> 
                To Whom it May Concern: <br /> <br /> 
            </p>
            
            <p class="style1">
                Please accept this letter as an official document attesting to the fact that 
                <strong>#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname#</strong> 
                is a participant in the #APPLICATION[qGetProgram.extra_sponsor].name# Summer Work Travel Program. <br />
                Form DS-2019 number #qGetCandidate.ds2019# has been issued for the above mentioned participant. <br /> <br />
                
                #APPLICATION[qGetProgram.extra_sponsor].name# is a sponsor of exchange visitors to the United States, participating in 
                Exchange Visitor Program #APPLICATION[qGetProgram.extra_sponsor].programNumber#, designated by the United States Department of State. 
                Such participants have been admitted under Section 101 (A) (15) (J) of the Immigration and Nationality Act. 
                Their J-1 visa status is evidenced by the DS-2019 Form and the J-1 visa in their passports. <br /> <br />
                
                According to the Immigration Reform and Control Act of 1986 (IRCA), the participants of this program are eligible for employment. 
                The participants of this program are also entitled to receive compensation from employers for theirs efforts while they are on the 
                program. For payroll purposes, the participants must obtain Social Security Numbers. <br /> <br />
                
                Each participant has been sponsored by #APPLICATION[qGetProgram.extra_sponsor].name# as indicated on the DS-2019 Form. <br /> <br />

                #APPLICATION[qGetProgram.extra_sponsor].name# would like to thank you in advance for your cooperation. 
                If you should have any questions or concerns, please feel free to contact us at #APPLICATION[qGetProgram.extra_sponsor].toolFreePhone#. <br /> <br /> <br /> 
            </p>

            <p class="style1">
            	Kind Regards,  <br /> <br />            
                <img src="http://www.student-management.com/extra/internal/uploadedfiles/craig_signature.gif">  <br /> 
                Craig Brewer <br />
                Executive Director/Responsible Officer
            </p>
            
            <br /> <br /> <br />
        </td>
	</tr>
</table>            

</cfoutput>