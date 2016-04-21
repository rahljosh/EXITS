<!--- ------------------------------------------------------------------------- ----
	
	File:		agrementAreaRep.cfm
	Author:		Marcus Melo
	Date:		July 31, 2012
	Desc:		Agreement Contract
	
	Notes:		
	
----- ------------------------------------------------------------------------- --->

<!--- Kill Extra Output ---> 
<cfsilent>

	<cfscript>
		// Get Company Information
		qGetCompanyInfo = APPLICATION.CFC.COMPANY.getCompanyByID(companyID=CLIENT.companyID);
	</cfscript>

</cfsilent>

<style type="text/css">
	ol.letters { list-style-type: lower-alpha }
</style>

<cfoutput>

<div align="center">
    #qGetCompanyInfo.companyname# <br />
    #qGetCompanyInfo.companyname# - (#qGetCompanyInfo.companyshort_nocolor# <br />
    AYP 2016-2017 Services Agreement
</div> <br />

<p>
	This SERVICES AGREEMENT is entered into this <strong><u>#DateFormat(now(), 'd')#</u></strong> day of <strong><u>#DateFormat(now(), 'mmmm')#</u></strong>, 
    <strong><u>#DateFormat(now(), 'yyyy')#</u></strong> (the "Effective Date") by and between #qGetCompanyInfo.companyname# (#qGetCompanyInfo.companyshort_nocolor#) 
    a not-for-profit corporation located at #qGetCompanyInfo.address#, #qGetCompanyInfo.city#, #qGetCompanyInfo.state# #qGetCompanyInfo.zip# and
    <strong><u>#qGetUser.firstname# #qGetUser.lastname#</u></strong>, an individual residing at <strong><u>#qGetUser.address# #qGetUser.address2# 
    #qGetUser.city#, #qGetUser.state#, #qGetUser.zip#</u></strong> (the "Area Representative" or "AR").
</p>

<p>
	WHEREAS, #qGetCompanyInfo.companyshort_nocolor# assists international foreign exchange students who wish to study in
  	the United States with the process of coming to and staying in the U.S., including placing the students with U.S. host families; and
</p>
  
<p> 
	WHEREAS, to further its objectives, #qGetCompanyInfo.companyshort_nocolor# desires to engage the services of the Area
  	Representative to locate and interact with the host families, schools and exchange students as
  	required by the <cfif client.companyid neq 15>U.S. State Department and the </cfif>Council on Standards for International Educational Travel; and
</p>
  
<p>  
	WHEREAS, #qGetCompanyInfo.companyshort_nocolor# wishes to engage the Area Representative as an independent
    contractor, but not an employee, agent, legal representative, partner or joint venture of #qGetCompanyInfo.companyshort_nocolor#,
    and the Area Representative wishes to be so engaged pursuant to the terms and conditions of this Agreement.
</p>

<p>
	NOW, THEREFORE, in consideration of the foregoing and the mutual agreements and covenants contained herein, the parties hereto agree as follows:
</p>
 
<ol>
    <li>
        <u>Recitals</u>
        <p>The recitals hereinabove set forth are hereby incorporated into and made a part of this Agreement.</p>
    </li>
  
    <li> 
        <u>Term</u>
        <p>
            The Term of this Agreement shall commence on the Effective Date and shall cease on #DateFormat(qGetSeason.datePaperworkEnded, 'mmmm d, yyyy')#, <!--- August 31, 2013, --->
            unless otherwise agreed in writing between the parties or unless earlier terminated pursuant to Section "Termination" hereof.
        </p>
    </li>

    <li>
        <u>Services</u>
        <p>
            In connection with the conduct of #qGetCompanyInfo.companyshort_nocolor#'s activities, the Area Representative will perform
            the following services: locate, screen and secure placements in homes of high quality families for #qGetCompanyInfo.companyshort_nocolor#-sponsored 
            students for AYP #qGetSeason.years#; secure school acceptance in writing for those student(s); and supervise designated AYP #qGetSeason.years# student(s) 
            stay in the United States (collectively, the "Services"). 
            The Area Representative acknowledges that the performance of the Services is subject to the regulations and guidelines of <cfif client.companyid neq 15>the
            U.S. State Department ("State Department"), and</cfif> the Council on Standards for International Educational Travel ("CSIET"). 
            All Services shall be performed to the highest professional standard and shall be performed to #qGetCompanyInfo.companyshort_nocolor#'s 
            reasonable satisfaction in accordance with <cfif client.companyid neq 15>State Department regulations and </cfif>CSIET guidelines, which are reviewed during the annual AR training. 
            Failure to adhere to these standards may result in termination of this Agreement.
        </p>
    </li>

    <li>
        <u>Independent Contractor</u>
        <p>
            (a) In the performance of Services pursuant to this Agreement, the Area
            Representative will be an independent contractor of #qGetCompanyInfo.companyshort_nocolor# and will not be
            deemed to be an employee or to be in a joint venture, partnership or agency relationship.
        </p>
  
        <p>
            (b) The Area Representative understands and agrees that there is no
            obligation on the part of #qGetCompanyInfo.companyshort_nocolor# to give the Area Representative any student
            placement assignment over any specific period, and any such assignment
            is in the sole and absolute discretion of #qGetCompanyInfo.companyshort_nocolor#.
        </p>
        
        <p>
            (c) This Agreement is not exclusive. The Area Representative may perform services for others during the Term of this Agreement, in accordance with
            the nondisclosure statement contained herein and that the Area Representative does not violate the confidentiality provisions thereof.
        </p>
        
        <p>
            (d) The Area Representative will make all reports and file all returns and pay all taxes to all appropriate governmental agencies, including the Internal
            Revenue Service, reflecting that the Area Representative is an independent contractor of #qGetCompanyInfo.companyshort_nocolor#. 
            #qGetCompanyInfo.companyshort_nocolor# will not be required to withhold any amounts from
            compensation for federal, state or local taxes, or for Social Security,  unemployment insurance or other related taxes.
        </p>
        
        <p>
            (e) The Area Representative will be responsible for payment of his/her own business expenses incurred in connection with his/her 
            activities as the Area Representative, including without limitation, travel, entertainment, maintenance and operation of automobiles, 
            postage, supplies and telephone expenses.  The Area Representative will supply at his/her own expense all tools required to perform the Services.
        </p>
        
        <p>
            (f) References
            For each Service Agreement cycle, an Independent Contractor, the Area Representative is required to complete an Area Representative
            Information form and provide two (2) personal and professional references prior to placing any students with host families.
        </p>
        
        <p>
            (g) Criminal Background Check
            For each Service Agreement cycle, #qGetCompanyInfo.companyshort_nocolor# will process a Criminal Background
            Check for the Area Representative.
        </p>
        
        <li>
            <u>#qGetCompanyInfo.companyshort_nocolor# Representative</u>
            <p>
                #qGetCompanyInfo.companyshort_nocolor# shall designate in writing a supervisor to review the performance and quality of the
                Services on a discretionary basis and take any necessary steps to ensure performance by the Area Representative of such Services is 
            commensurate with the standards set forth in Section 3 above and as established by <cfif client.companyid neq 15>the U.S. Department of State and </cfif>CSIET. </p>
        </li>
        
        <li>
            <u>Charges for Services</u>
            <p>
                In full consideration of the Area Representative providing and furnishing the Services hereunder, #qGetCompanyInfo.companyshort_nocolor# 
                shall pay the Area Representative the fee(s) set forth in Schedule 1 attached hereto.
            </p>
        </li>
       
       <cfif client.companyid neq 15>             
        <li>
            <u>Community Service Requirement</u>
            <p>
                Area Representatives are required to organize or coordinate a five (5) hour community
                service project (or projects) for the students that they supervise. All community service
                hours for participating student must be entered in to the #qGetCompanyInfo.companyshort_nocolor# 
                database by April 20, #Year(qGetSeason.datePaperworkEnded)#. <!--- Date --->
            </p>
        </li>
        </cfif>    
        <li>
            <u>Training Requirement</u>
            <p>The Area Representative is required to participate in an annual training session, either in person or via internet training.</p>
        </li>
          
        <li>
            <u>Non-Disclosure</u>
            <p>
                The #qGetCompanyInfo.companyshort_nocolor# Area Representative agrees not to disclose or otherwise publish any
                information related to Area Representatives, Managers, host families, and schools contained in the #qGetCompanyInfo.companyshort_nocolor# database. 
                Any materials or information provided by #qGetCompanyInfo.companyshort_nocolor# to the
                Area Representative shall be the sole property of #qGetCompanyInfo.companyshort_nocolor# and shall be returned 
                to #qGetCompanyInfo.companyshort_nocolor# at the conclusion of this agreement.
            </p>
        </li>
        
        <li>
            <u>Termination</u>
            <p>
                This Agreement may be terminated at will by either party at any time. Upon termination of this Agreement, 
                the Area Representative shall receive all payments earned prior to such termination.
            </p>
        </li>
                
        <li>
            <u>Interpretation of Contract</u>
            <p>
                This Agreement shall be deemed to have been entered into in the State of <cfif CLIENT.companyID EQ 10>New Jersey<cfelse>New York</cfif>
                and shall be governed and controlled as to validity, enforcement, interpretation,
                construction, effect, and in all other respects by the internal laws of the State of <cfif CLIENT.companyID EQ 10>New Jersey<cfelse>New York</cfif>  
                applicable to contracts made in that State, without regard to its laws of conflict of laws. 
                The Area Representative agrees that the Area Representative will be subject to the
                personal jurisdiction of the courts of the State of <cfif CLIENT.companyID EQ 10>New Jersey<cfelse>New York</cfif> for any matter relating to
                this Agreement; <u>provided</u>, <u>however</u>, nothing herein shall be deemed to preclude or
                prevent #qGetCompanyInfo.companyshort_nocolor# from bringing any action or claim to enforce the provisions of this
                Agreement in any other appropriate state or from having jurisdiction over the Area Representative. 
                This Agreement shall not be construed either in favor of or against either party. To the extent that any specific provision of 
                this Agreement is deemed illegal, unenforceable or void, the illegal, unenforceable or void provision of this
                Agreement shall not affect the remaining provisions of this Agreement, which shall remain in full force and effect.
            </p>
        </li>
                        
        <li>
            <u>Miscellaneous</u>
            <p>
            	(a)	This Agreement and the Exhibits and Schedule attached hereto shall constitute the entire understanding between 
                the parties and supersede any previous communications, representations or agreements, whether verbal or written; 
            </p>
            
            <p>
            	(b)	No change or modifications of any of the terms or conditions herein shall be valid or binding on either party 
                unless made in writing and signed by an authorized representative of each party; 
			</p>
            
            <p>
                (c) Any waiver by either party of a provision of this Agreement, or any right or option hereunder, shall not be deemed a continuing waiver and shall
                not prevent or stop such party from thereafter enforcing such provision, right or option, and the failure of either party to insist in any one or more
                instances upon the strict performance of any of the terms or provisions of this Agreement by the other party shall not be construed as a waiver or
                relinquishment for the future of any such term or provision but the same shall continue in full force and effect;
            </p>
            
            <p>(d) The captions set forth herein are for convenience only and shall not define or limit any of the terms hereof;</p>
                
            <p>
                (e) This Agreement shall be binding upon, and shall inure to the benefit of the parties hereto, and to their respective heirs, next of kin, executors,
                administrators, successors, and, where applicable, assigns;
            </p>

            <p>
                (f) Both parties shall have the right to delegate to any agent, subcontractor or corporation any part or all of such party's duties hereunder, 
                provided said delegation and such agent, subcontractor or corporation shall carry out the terms of this Agreement;
            </p>
            
            <p>
                (g) Nothing herein shall be construed as a license, grant or right to use any #qGetCompanyInfo.companyshort_nocolor# trademarks, logos, 
                or materials without the express written consent of #qGetCompanyInfo.companyshort_nocolor# in each and every case.
            </p>
        </li>
    
    </li>            

</ol>

<div align="center">SCHEDULE 1 - <u>SCHEDULE OF PAYMENTS</u></div>

<p>All payments will follow the schedule outlined below:</p>

<strong>1. Semester Programs (5 months)</strong><br /><br />

<strong>Fall Semester</strong><br />

<table width="80%">
    <tr>
        <td><strong><u>Type of Fee</u></strong></u></td>
        <td><strong><u>Date of Payment</u></strong></td>
        <td><strong><u>Amount of Payment</u></strong></td>
    </tr>
    <tr bgcolor="##F8F8F8">
        <td>Placement*</td>
        <td>Paperwork*</td>
        <td><cfif client.companyid eq 15>$300<cfelse>$175</cfif></td>
    </tr>
    <tr>
        <td>Supervision Phase 1**</td>
        <td>October 15</td>
        <td><cfif client.companyid eq 15>$150<cfelse>$100</cfif></td>
    </tr>    
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 2</td>
        <td>December 15</td>
        <td><cfif client.companyid eq 15>$150<cfelse>$100</cfif></td>
    </tr>
   <cfif client.companyid neq 15>
    <tr>
        <td>Supervision Phase 3</td>
        <td>February 15</td>
        <td>$100</td>
    </tr>   
   </cfif>
</table> <br />

<strong>Spring Semester</strong><br />

<table width="80%">
    <tr>
        <td><strong><u>Type of Fee</u></strong></td>
        <td><strong><u>Month of Payment</u></strong></td>
        <td><strong><u>Amount of Payment</u></strong></td>
    </tr>
    <tr bgcolor="##F8F8F8">
        <td>Placement*</td>
        <td>Paperwork*</td>
        <td><cfif client.companyid eq 15>$300<cfelse>$175</cfif></td>
    </tr>
    <tr>
        <td>Supervision Phase 3**</td>
        <td>February 15</td>
        <td><cfif client.companyid eq 15>$150<cfelse>$100</cfif></td>
    </tr>    
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 4</td>
        <td>April 15</td>
        <td><cfif client.companyid eq 15>$150<cfelse>$100</cfif></td>
    </tr>  
    <cfif client.companyid neq 15>
        <tr>
            <td>Supervision Phase 5</td>
            <td>June 15</td>
            <td>$100</td>
        </tr>   
    </cfif>
    <tr>
        <td colspan="3" align="right"><strong>Total Payment for a semester student : <cfif client.companyid eq 15>$600<cfelse>$475</cfif></strong></td>
    </tr>
</table> <br />

<strong>2. School Year Program (10 months)</strong>

<table width="80%">
    <tr>
        <td><strong><u>Type of Fee</u></strong></td>
        <td><strong><u>Month of Payment</u></strong></td>
        <td><strong><u>Amount of Payment</u></strong></td>
    </tr>
    <tr>
        <td>Placement*</td>
        <td>Paperwork*</td>
        <td><cfif client.companyid eq 15>$400<cfelse>$175</cfif></td>
    </tr>
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 1**</td>
        <td>October <cfif client.companyid eq 15>20<cfelse>15</cfif> </td>
        <td><cfif client.companyid eq 15>$150<cfelse>$80</cfif></td>
    </tr>    
    <tr>
        <td>Supervision Phase 2</td>
        <td>December <cfif client.companyid eq 15>20<cfelse>15</cfif> </td>
        <td><cfif client.companyid eq 15>$150<cfelse>$80</cfif></td>
    </tr>
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 3</td>
        <td>February <cfif client.companyid eq 15>20<cfelse>15</cfif> </td>
        <td><cfif client.companyid eq 15>$150<cfelse>$80</cfif></td>
    </tr> 
    <tr>
        <td>Supervision Phase 4</td>
        <td>April <cfif client.companyid eq 15>20<cfelse>15</cfif></td>
        <td><cfif client.companyid eq 15>$150<cfelse>$80</cfif></td>
    </tr>  
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 5</td>
        <td>June <cfif client.companyid eq 15>20<cfelse>15</cfif></td>
        <td><cfif client.companyid eq 15>$150<cfelse>$80</cfif></td>
    </tr>  
    <cfif client.companyid neq 15>
    <tr>
        <td>Departure</td>
        <td>June 30</td>
        <td>$175</td>
    </tr>   
    </cfif>
    <tr>
        <td colspan="3" align="right"><strong>Total Payment  : <Cfif client.companyid eq 15>$1000<cfelse>$750</Cfif></strong></td>
    </tr>
</table> <br />
<cfif client.companyid neq 15>
<strong>3. Calendar Year Program (12 months)</strong>

<table width="80%">
    <tr>
        <td><strong><u>Type of Fee</u></strong></td>
        <td><strong><u>Month of Payment</u></strong></td>
        <td><strong><u>Amount of Payment</u></strong></td>
    </tr>
    <tr>
        <td>Placement*</td>
        <td>Paperwork*</td>
        <td>$175</td>
    </tr>
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 3**</td>
        <td>February 15 </td>
        <td>$85</td>
    </tr> 
    <tr>
        <td>Supervision Phase 4</td>
        <td>April 15</td>
        <td>$85</td>
    </tr>  
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 5</td>
        <td>June 15</td>
        <td>$85</td>
    </tr>  
    <tr>
        <td>Supervision Phase 1</td>
        <td>October 15</td>
        <td>$85</td>
    </tr>    
    <tr bgcolor="##F8F8F8">
        <td>Supervision Phase 2</td>
        <td>December 15</td>
        <td>$85</td>
    </tr>
    <tr>
        <td>Departure</td>
        <td>December 30</td>
        <td>$175</td>
    </tr>   
    <tr>
        <td colspan="3" align="right"><strong>Total Payment : $860</strong></td>
    </tr>
</table> <br />

<p>
    * See Terms and Conditions for details about placement paperwork requirements <br />
    ** See Terms and Conditions for details about supervision paperwork requirements
</p>

<ol>

    <li>
        <strong>Area Representative Bonus</strong>
        <p>
            (a) <strong>Fast-Track Placement Bonus:</strong> A bonus of $1,500 will be paid by #qGetCompanyInfo.companyshort_nocolor# to
            the AR each time the AR has successfully placed a group of five (5) August arriving students in five (5) permanent homes and 
            submitted all Department of State and CSIET mandated documentation prior to April 30, #Year(qGetSeason.datePaperworkEnded)#. <!--- Date --->
        </p>
        
        <p>
            Placements qualifying for this bonus will not be applied to the Early Placement Bonus or the On-Time Paperwork Bonus. Multiple bonuses can be
            earned for placement of additional groups of five students.
        </p>

        <table width="80%">
            <tr>
                <th align="center"><u>Complete August Arriving <br /> Fast Track Placements <br /> Prior to April 15<sup>th</sup></u></th>
                <th align="center" valign="top"><u>Total Fast Track Bonus</u></th>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">5</td>
                <td align="center">$1,500</td>
            </tr>
            <tr>
                <td align="center">10</td>
                <td align="center">$3,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">15</td>
                <td align="center">$4,500</td>
            </tr>
            <tr>
                <td align="center">20</td>
                <td align="center">$6,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">25</td>
                <td align="center">$7,500</td>
            </tr>
        </table> <br />

        <p>
            (b)<strong> Early Placement Bonus:</strong> A bonus of $1,000 will be paid by #qGetCompanyInfo.companyshort_nocolor# to the AR each
            time the AR has successfully placed a group of five (5) August arriving students in five (5) permanent homes prior to June 15<sup>th</sup> of the applicable
            calendar year and upon receipt, prior to June 15<sup>th</sup>, submitted the Department of State and CSIET mandated documentation.
        </p>
        
        <p>
            There is no limit to the number of $1,000 Early Placement Bonuses an AR can earn. For example, placing 50 students by June 15<sup>th</sup> will earn ten (10) Early
            Placement Bonuses, equal to $10,000.
        </p>
        
        <p>
            Placements qualifying for this bonus will not be applied to the On-Time	Paperwork Bonus. Placements that qualified for the Fast Start Bonus cannot
            be applied to the Early Placement Bonus. Multiple bonuses can be earned for placement of additional groups of five students.
        </p>

        <table width="80%">
            <tr>
                <th align="center"><u>Complete August Arriving Early<br /> Placements Prior to June 3<sup>rd</sup></u></th>
                <th align="center" valign="top"><u>Total Early Placement Bonus</u></th>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">5</td>
                <td align="center">$1,000</td>
            </tr>
            <tr>
                <td align="center">10</td>
                <td align="center">$2,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">15</td>
                <td align="center">$3,000</td>
            </tr>
            <tr>
                <td align="center">20</td>
                <td align="center">$4,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">25</td>
                <td align="center">$5,000</td>
            </tr>
        </table> <br />
        
        <p>
            (c) <strong>Placement Paperwork Bonus:</strong> A bonus of $500 will be paid by #qGetCompanyInfo.companyshort_nocolor# to the AR
        each time the AR has successfully placed a group of five (5) August arriving students in five (5) permanent homes prior to August 31<sup>st</sup> 
            of the applicable calendar year and upon receipt, prior to August 31<sup>st</sup>, submitted the Department of State and CSIET mandated documentation.
        </p>
        
        <p>
            There is no limit to the number of $500 Placement Paperwork Bonuses an AR can earn. For example, placing fifty (50) 
            students will earn ten (10) Placement Paperwork Bonuses, equal to $5,000
        </p>
        
        <p>Placements that qualified for the Fast Start Bonus or Early Placement Bonus cannot be applied to the Placement Paperwork Bonus.</p>

        <table width="80%">
            <tr>
                <th align="center"><u>Complete August Arriving <br /> Placements Prior to August 1<sup>st</sup></u></th>
                <th align="center" valign="top"><u>Total Placement Paperwork Bonus</u></th>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">5</td>
                <td align="center">$500</td>
            </tr>
            <tr>
                <td align="center">10</td>
                <td align="center">$1,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">15</td>
                <td align="center">$1,500</td>
            </tr>
            <tr>
                <td align="center">20</td>
                <td align="center">$2,000</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">25</td>
                <td align="center">$2,500</td>
            </tr>
            <tr>
                <td align="center">&darr;</td>
                <td align="center">&darr;</td>
            </tr>
            <tr bgcolor="##F8F8F8">
                <td align="center">50</td>
                <td align="center">$5,000</td>
            </tr>
        </table> <br />

        <p>
            (d) <strong>Payment of Bonuses:</strong> The Early Placement Bonus and the Placement Paperwork Bonus will be paid as soon as the manager submits the bonus
            request form for the AR and the <cfif CLIENT.companyID EQ 10>New Jersey<cfelse>New York</cfif> office approves it.
    </p>
    </li> 
    </cfif>
    <br />

    <li><strong>Terms and Conditions</strong></li> <br />
	
    <ul>
        <li>#qGetCompanyInfo.companyshort_nocolor# will accept placements on a first-come, first-serve basis and will not be obligated to make any payment for a placement that it does not accept.</li>
    
        <li>
            AR should notify #qGetCompanyInfo.companyshort_nocolor# of a potential placement as soon as possible and submit all
            paperwork (described below) within seven (7) days of such notification. Failure to submit required paperwork could result in forfeiture of all payments.<br />
        </li>
        
        <li> 
            Placement payments will be made upon receipt of the completed and signed Host Family Application with pictures, School and Community Profile, Criminal
            Background Check Forms and School Acceptance Form in the #qGetCompanyInfo.companyshort_nocolor# main office. As
            indicated by a * in the payment schedule, placement payments will be made within 30 days of receipt of the required documents.
        </li>
        
        <li>
            Supervision payments will be triggered by #qGetCompanyInfo.companyshort_nocolor# having complete student evaluations for the months preceding the payment period. 
            Supervision payments will not be made unless signed Student and Host Family Orientation Signoff forms have been received in the #qGetCompanyInfo.companyshort_nocolor# main office. 
            To avoid delay or forfeiture of payment, approved evaluations must be submitted by the 1<sup>st</sup> of the evaluative month. 
            Evaluations submitted beyond 30 days from the due date listed on each report will not be eligible for payment.
        </li>
        
        <li>The #qGetCompanyInfo.state# office will pro-rate all supervision fees for students who depart from the program early.</li>
        
        <li>Unpaid fees relating to placement of a student that has to move and/or change AR will move with the student to the new AR.</li>
        
        <li>In the case of a re-location, the requirements above will apply just as if it were a new placement. Relocations must be reported to the immediate supervisor.</li>
        
        <li>
            If #qGetCompanyInfo.companyshort_nocolor# collects a cancellation fee for any placement that is canceled by a student for
            an inappropriate reason, a <cfif client.companyid neq 15>$175<cfelse>$300 or $400 </cfif> placement fee will be paid <cfif client.companyid eq 15>respectivly</cfif>. In order to receive this payment all placements must have been completed and the signed Host Family
            Application with pictures, School and Community Profile and School Acceptance Form in the #qGetCompanyInfo.companyshort_nocolor# main office within two weeks of the cancellation.
        </li>
        
        <li> 
            A deduction in the amount of $100 will be applied towards the placement fee for all placements that are generated by host family leads from Google ad leads. Any leads
            produced from Google ads that result in a placement will require this $100 deduction to be applied to the placement fee.
        </li>
        
    </ul> <br />
    
    <li><strong>Definitions</strong></li>
    
    <p>
        For purposes of this Schedule, the following definitions shall apply:
        
        <ol class="letters">
            <li> 
                "Placement" means the act of locating and securing a confirmed homestay and school acceptance for an #qGetCompanyInfo.companyshort_nocolor#-sponsored exchange student, as further
                defined in the <cfif client.companyid neq 15>State Department regulations and </cfif>CSIET guidelines.
            </li>
            
            <li> 
                "Supervise" or "Supervision" means contact with the student(s) placed by the  Area Representative as defined in the <cfif client.companyid neq 15>State Department Regulations and</cfif>
                CSIET guidelines. This includes conducting the host family and the student orientation, and in-person visitation at least every other month.            
            </li>
            
            <li>"Semester" refers to one-half a school year. The first semester starts approximately September 1<sup>st</sup> and ends mid-January. The second semester begins mid-January and ends mid-June.</li>
            
            <li>"School year" means the academic year commencing approximately September 1<sup>st</sup> of any calendar year and ending on or about mid-June of the following year.</li>
            
            <li>"Calendar year" refers to a 12-month academic program commencing on or about January 1<sup>st</sup> and ending on or about mid-December of the same year.</li>
            
            <li>
                "Program" shall mean the homestay of an international exchange student while he/she is simultaneously attending a high school as an 
                #qGetCompanyInfo.companyshort_nocolor#-sponsored exchange student.
            </li>
        </ol>
    
    </p>

</ol>

</cfoutput>