<!--- ------------------------------------------------------------------------- ----
	
	File:		employerLetter.cfm
	Author:		Marcus Melo
	Date:		July 26, 2011
	Desc:		Employer Letter
	
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
	</cfscript>
	
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
            <p class="style1"> 
                Date: #DateFormat(now(), "long")#
            </p>
           
            <p class="style1"> 
                To: Host Company Payroll Department 
            </p>
           
            <p class="style1"> 
                To Whom it May Concern: 
            </p>
            
            <p class="style1">
                CSB International, Inc. (CSB) is a sponsor of exchange visitors (J-1) to the United States, participating in Exchange Visitor Program 
                #APPLICATION.CSB.WAT.programNumber# (Category: Summer Work/Travel), designated by the United States Department of States, 
                under the authority of the Mutual Educational and Cultural Exchange Act of 1961 (also known as the Fulbright-Hays Act). 
           	</p>
            
            <p class="style1">     
                The purpose of the Summer Work Travel Program is to enable university students from abroad to gain a greater understanding of the United States 
                by giving them the opportunity to live, work and travel in the United States for a maximum period of 4 (four) months, but within the limits of their
                official summer vacation.  
            </p>
            
            <p class="style1">   
                Please accept this letter as an official document attesting to the fact that 
                <strong>#qGetCandidate.firstname# #qGetCandidate.middlename# #qGetCandidate.lastname# (DOB: #DateFormat(qGetCandidate.dob, 'mm/dd/yyyy')#)</strong> 
                is a participant in the CSB Summer Work Travel Program.  Form DS-2019 (Certificate of Eligibility for Exchange Visitor (J-1) Status) with SEVIS ID 
                <strong>#qGetCandidate.ds2019#</strong> has been issued by CSB for the above mentioned participant. 
            </p>
            
            <p class="style1">    
                The participant is admitted to the United States under Section 101 (a) (15) (J) of the Immigration and Nationality Act (INA). 
                The J-1 visa status is evidenced by the Form DS-2019, the J-1 visa in the passport and the I-94 card (arrival-departure record).  
                These forms should serve as a <strong>confirmation of the participant’s eligibility for employment</strong>, under the Immigration Reform and Control Act of 1986 (IRCA). 
            </p>

            <p class="style1">    
				The participant is also <strong>entitled to receive compensation from employers</strong> for <cfif qGetCandidate.sex EQ 'm'>his<cfelseif qGetCandidate.sex EQ 'f'>her</cfif> 
                effort while on the program (program dates are specified on Form DS-2019). Based on <strong>IRS Publication 515</strong>, as a <strong>Non-Resident Alien Authorized to work</strong>, 
                the participant must pay local, state and federal taxes; the participant must not pay Social Security and Medicare Taxes (FICA) and/or Federal Unemployment Taxes (FUTA).                
			</p>
            
            <p class="style1">    
                For payroll purposes, the participant <strong>must obtain a Social Security Number</strong>. The participant must apply on 
				<cfif qGetCandidate.sex EQ 'm'>his<cfelseif qGetCandidate.sex EQ 'f'>her</cfif> own behalf and in person at the nearest Social Security Office. As proof of application, 
                the participant will be issued Form SSA-5028. If you wish to prepare a report of earnings before the participant has received their Social Security card, you may leave the 
                space for the Social Security number blank. For further information regarding employer responsibilities when engaging foreign personnel, please visit: 
                <a href="http://www.ssa.gov/employer/hiring.htm">http://www.ssa.gov/employer/hiring.htm</a>
			</p>
            
            <p class="style1">    
                CSB would like to thank you in advance for your cooperation. If you should have any questions or concerns, please feel free to contact us by phone at #APPLICATION.CSB.WAT.toolFreePhone#
                or by email at <a href="mailto:#APPLICATION.EMAIL.contactUs#">#APPLICATION.EMAIL.contactUs#</a>. 
            </p>
            
            <p class="style1" style="margin-top:30px;">
            	Kind Regards,  <br /> <br />            
                <img src="../../pics/ancaSignature.gif">  <br /> 
                Anca Radoi-Bodnarescu  <br />   
                Program Director
            </p>
        </td>
	</tr>
</table>            

</cfoutput>