<!--- ------------------------------------------------------------------------- ----
	
	File:		sevisFeeLetter.cfm
	Author:		Marcus Melo
	Date:		July 26, 2011
	Desc:		SEVIS Fee Letter
	
	Updates:	

----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output --->
<cfsilent>

    <!--- Param URL Variables --->
	<cfparam name="URL.uniqueID" default="">

    <!--- Param URL Variables --->
	<cfparam name="FORM.uniqueID" default="">

	<cfscript>
		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;	
		}
	</cfscript>

    <!--- Param URL Variables --->
	<cfparam name="URL.uniqueID" default="">

    <!--- Param URL Variables --->
	<cfparam name="FORM.uniqueID" default="">

	<cfscript>
		if ( LEN(URL.uniqueID) ) {
			FORM.uniqueID = URL.uniqueID;	
		}
		
		// Get Candidate Information
		qGetCandidate = APPLICATION.CFC.CANDIDATE.getCandidateByID(uniqueID=FORM.uniqueID);

		// List of Countries
		qGetCountryList = APPLICATION.CFC.LOOKUPTABLES.getCountry();
	</cfscript>
	
    <cfquery name="qGetBirthCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.birth_country)#">
    </cfquery>

    <cfquery name="qGetCitizenCountry" dbtype="query">
        SELECT 
            countryName
        FROM 
			qGetCountryList
		WHERE
        	countryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#VAL(qGetCandidate.citizen_country)#">
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
<table width="800px" border="0" align="center">
    <tr>
        <td colspan="2">
        	<img src="../../pics/csbLetterHead.jpg"  align="center">
        </td>
    </tr>
</table>

<table width="800px" border="0" align="center" style="padding-left:30px; padding-right:10px; margin-top:30px;">
    <tr>
		<td style="text-align:justify;">
            <h3 style="margin-bottom:50px;">Sevis Fee Payment - Instruction Letter</h3>
            
            <p class="style1">   
                Please accept this letter as an official document attesting to the fact that 
                <strong>#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (DOB: #DateFormat(qGetCandidate.dob, 'mm/dd/yyyy')#)</strong> 
                is a participant in the CSB Summer Work Travel Program.  Form DS-2019 (Certificate of Eligibility for Exchange Visitor (J-1) Status) with SEVIS ID 
                <strong>#qGetCandidate.ds2019#</strong> has been issued by CSB for the above mentioned participant. 
            </p>
            
            <p class="style1">    
				If an appointment to apply for the J-1 visa at the United States Consulate in the participant’s home country has not yet been scheduled, please make sure that is done at this time. 
                In the meantime, please find the necessary information below in order to pay the required SEVIS fee ($35.00) to the United States Department of Homeland Security (DHS).
            </p>
            
            <p class="style1">    
                This fee can be paid by accessing form I-901 at the following web site: <a href="https://www.fmjfee.com/index.jhtml">https://www.fmjfee.com/index.jhtml</a>
                The SEVIS fee must be paid <u>before applying for the J-1 visa</u>. The program participant will need to bring the electronic or original receipt for the visa interview. 
                Below is the information needed to complete Form I-901 exactly as it appears on the Form DS-2019 form issued by CSB:
            </p>
            
            <p class="style1">    
                <strong>Last Name:</strong> #qGetCandidate.lastname# <br />
                <strong>First Name:</strong> #qGetCandidate.firstname# <br />
                <strong>Middle Name:</strong> #qGetCandidate.middlename# <br />
                <strong>Address:</strong> #APPLICATION.CSB.WAT.address#, #APPLICATION.CSB.WAT.city#, #APPLICATION.CSB.WAT.state# #APPLICATION.CSB.WAT.zipCode#, #APPLICATION.CSB.WAT.country# <br />
                <strong>Date of Birth:</strong> #DateFormat(qGetCandidate.dob, 'mm/dd/yyyy')# <br />
                <strong>Gender:</strong> <cfif qGetCandidate.sex EQ 'm'>male<cfelseif qGetCandidate.sex EQ 'f'>female</cfif>  <br />
                <strong>City of Birth:</strong> #qGetCandidate.birth_city# <br />
                <strong>Country of Birth:</strong> #qGetBirthCountry.countryName# <br />
                <strong>Country of Citizenship:</strong> #qGetCitizenCountry.countryName# <br />
                <strong>Exchange Visitor Program Number:</strong> #APPLICATION.CSB.WAT.programNumber# <br />
                <strong>SEVIS Identification Number:</strong> #qGetCandidate.ds2019# <br />
                <strong>Passport Number (if available):</strong> #qGetCandidate.passport_number# <br />
                <strong>Exchange Visitor Category:</strong> Summer Work/Travel ($35.00) <br />
			</p>            
            
            <p class="style1">    
				Please do not hesitate to contact CSB Summer Work Travel Program staff should you have any questions. 
                CSB can be reached by phone at #APPLICATION.CSB.WAT.toolFreePhone# or by email at <a href="mailto:#APPLICATION.EMAIL.contactUs#">#APPLICATION.EMAIL.contactUs#</a>.             
            </p>
        </td>
	</tr>
</table>            

</cfoutput>