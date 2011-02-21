<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Get Student Information --->
    <cfquery name="qGetStudentInfo" datasource="mysql">
        SELECT 
            s.studentid, 
            s.app_indicated_program,
            s.firstname, 
            s.familylastname, 
            s.sex,
            s.city, 
            s.country, 
            cl.countryname
        FROM 
        	smg_students s
        LEFT OUTER JOIN 
        	smg_countrylist cl ON s.country = cl.countryid
        WHERE 
        	studentid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.studentid#">
    </cfquery>

	<cfparam name="subject" default="son/daughter">
	<cfparam name="subjectivePronoun" default="he/she">
   	<cfparam name="possessivePronoun" default="his/her">

    <cfscript>
		// Canada Options: 14,15,16
	
		// Set up proper peronal pronouns based on student's gender
		if ( qGetStudentInfo.sex EQ 'male' ) {
			subject = 'son';
			subjectivePronoun = 'he';
			possessivePronoun = 'his';
		} else if ( qGetStudentInfo.sex EQ 'female' ) { 
			subject = 'daughter';
			subjectivePronoun = 'she';
			possessivePronoun = 'her';
		}
		
		// Set up image path
		if ( IsDefined('url.curdoc') OR IsDefined('url.path') ) {
			path = "";
		} else if ( IsDefined('url.exits_app') )  {
			path = "nsmg/student_app/";
		} else {
			path = "../";
		}
		
		// These are used to print regular / blank agreements
		if ( ListFindNoCase(CGI.SCRIPT_NAME, "print_blankApplication.cfm", "/") ) {
			// print blank application
			subject = 'son/daughter';
			subjectivePronoun = 'he/she';
			possessivePronoun = 'his/her';
			
			cityInfo = '_____________________';
			countryInfo = '_____________________';
			dayInfo = '______';
			monthInfo = '______________';
			yearInfo = '______';
			studentInfo = '__________________________________________';
		} else {
			// Print regular application
			cityInfo = '<u> &nbsp; #qGetStudentInfo.city# &nbsp; </u>';
			countryInfo = '<u> &nbsp; #qGetStudentInfo.countryname# &nbsp; </u>';
			dayInfo = '<u> &nbsp; #DateFormat(now(),'d')# &nbsp; </u>';
			monthInfo = '<u> &nbsp; #DateFormat(now(), 'mmmm')# &nbsp; </u>';
			yearInfo = '<u> &nbsp; #dateformat(now(), 'yyyy')# &nbsp; </u>';
			studentInfo = '<u> &nbsp; #qGetStudentInfo.firstname# #qGetStudentInfo.familylastname# &nbsp; </u>';
		}
	</cfscript>

</cfsilent>

<cfoutput>

<!--- Public High School Agreement --->
<cfsavecontent variable="publicAgreement">
    <p style="padding-left:10px;">
        In the City of #cityInfo#, country of #countryInfo#, on the #dayInfo# day of #monthInfo# in the year of #yearInfo#, I/We the undersigned parents of #studentInfo# my/our #subject#, 
        and I, the student applicant, agree to the following terms and conditions. The above-named student is applying to participate in a cultural exchange program sponsored by the exchange 
        organization and we give our #subject# permission to participate in this program.
    </p>
    
    <ol>
    
        <li>
            We understand the program is designed to increase understanding among people of the world and is not to be used for the sole purpose of foreign language training.  
            We have discussed the importance of good behavior with our #subject# and #subjectivePronoun# understands the significance of acting in a manner which will reflect well on our family and our country. 
        </li>
        
        <li>
            We understand and agree that the enrollment of our #subject# in the exchange program is primarily for the cultural exchange and that a <b><u>diploma, graduation, athletic 
            eligibility and/or athletic participation is not guaranteed of any student.</u></b>
        </li>
        
        <li>
            We understand student placements are based on compatibility with a selection by a host family.  A specific geographical area can be selected by a student in the AYP school 
            year program or the semester program for an additional fee.  See insert / section REGIONAL GUARANTEES.
        </li>
        
        <li>
            Upon receipt of the Student Handbook, we all agree to read and discuss its contents.  Should we not understand any part thereof, we will contact our international representative for 
            clarification before the program participant leaves our country.  We understand that problems are to be resolved first by discussion between the host family and the program participant, 
            then with the assistance of the exchange organization.  The program participant is not to discuss problems of a personal nature with the members of the community or school. We understand 
            the program participant will have responsibilities as a member of the family, including attending religious services.  Although not required, the exchange organization strongly recommends 
            they do so as part of family life. We understand that the participant is expected to participate in 5 hours of community service sponsored by the school, church, student exchange company, 
            or as permitted by the host family. 
        </li>
        
        <li>
            We agree that the program participant will try to adjust, will obey the disciplinary rules of the host family and school, will give respect and obedience to the host family and 
            school officials, and will keep communications open at all times.
        </li>
        
        <li>
            We understand and agree that the program participant will not take any unprescribed drugs, drink alcoholic beverages, possess false identification, drive any motorized vehicle,
            or participate in any dangerous sports such as hang gliding, bungee jumping, etc.  If the program participant does any of the above, we understand that #subjectivePronoun# may be immediately 
            returned home at our family's expense, and we accept full responsibility for any situation arising from #possessivePronoun# involvement with the above.
        </li>
        
        <li>We understand that prolonged or inappropriate use of the internet, including email or chat rooms, may result in a first warning and then program termination.</li>
        
        <li>We agree that the program participant may not take any action that may change the nature of #possessivePronoun# life, i.e. getting married, changing religions.</li>
        
        <li>
            We understand and agree that the program participant will be subject to all the laws of the host country.  In the case of serious infraction of the rules and requirements 
            governing the conduct of the program participant, or in the case of extreme homesickness, or poor adjustment to the host family or school, the participant may be returned 
            home immediately at the discretion of the exchange organization's Executive Committee and at the expense of our family.
        </li>
        
        <li>
            We understand and agree that the program participant may not drive any motorized vehicle that requires an operator's license, nor be a pilot or  passenger in a private plane.  
            A student is allowed to register for school-sponsored driver education classes.  If a license is obtained through this program, the license must be immediately given to the exchange 
            organization's local representative.  It will be returned to the student on the day of departure for home.
        </li>
        
        <li>
            We understand that as natural parents we are responsible for providing funds necessary for day to day expenses for our child.  The suggested amount is approximately $300.00 a month.
        </li>
        
        <li>
            We agree that the program participants are not allowed to go home during the program unless under emergency conditions and only with prior approval from the exchange organization's main office.  
            Visits from the natural parents and friends during the program are strongly discouraged and must have prior approval from the main office.  
            Independent travel is not allowed at any time during the program.
        </li>
        
        <li>We agree that the program participant is to return home within 5 days after the last day of school.</li>
        
        <li>
            We agree to pay for the early return of our child if it is deemed necessary for medical reasons after consultation between ourselves, 
            program personnel, and the designated medical authorities.
        </li>
        
        <li>We agree to pay for any medical and dental bills not covered by the accident and sickness insurance.  We agree to pay for any deductible amount due that the insurance policy might not cover.</li>
         
        <li>
            We agree that the program participant is to possess a return flight ticket from the airport located nearest the host family to the participant's country.  
            This return ticket is to be carried to the United States by the participant and is to be kept in safekeeping by the participant until time for the participant to return home.
        </li>
        
        <li>
            We agree to pay for any and all telephone calls made by the program participant including those calls made which might appear on the host family's telephone bill after
            the departure of the program participant.
        </li>
        
        <li>
            We give the exchange organization the right to use the participant's name and photograph for reproduction in any medium for the purposes of publication, 
            advertising, trade, display, or editorial use.
        </li>
        
        <li>We agree to attend meetings that are scheduled to prepare us for the exchange experience.</li>
    
    </ol>
</cfsavecontent>
    

<!--- Canada Agreement --->
<cfsavecontent variable="canadaAgreement">
    <p style="padding-left:10px;">
        In the City of #cityInfo#, country of #countryInfo#, on the #dayInfo# day of #monthInfo# in the year of #yearInfo#, I/We the undersigned parents of #studentInfo# my/our #subject#, 
        and I, the student applicant, agree to the following terms and conditions. The above-named student is applying to participate in a cultural exchange program sponsored by the exchange 
        organization and we give our #subject# permission to participate in this program.
    </p>
    
    <ol>
    
        <li>
            We understand the program is designed to increase understanding among people of the world and is not to be used for the sole purpose of foreign language training. We have discussed the 
            importance of good behavior with our #subject# and #subjectivePronoun# understands the significance of acting in a manner which will reflect well on our family and our country. 
        </li>
    
        <li>We understand and agree that the enrollment of our #subject# in the exchange program is primarily for the cultural exchange and that a diploma or graduation is not guaranteed of any student.</li>
    
        <li>
            Upon receipt of the Student Handbook, we all agree to read and discuss its contents. Should we not understand any part thereof, we will contact our international representative for clarification 
            before the program participant leaves our country. We understand that problems are to be resolved first by discussion between the host family and the program participant, then with the assistance 
            of the exchange organization. The program participant is not to discuss problems of a personal nature with the members of the community or school. We understand the program participant will have 
            responsibilities as a member of the family including attending religious services. Although not required, the exchange organization strongly recommends they do so as part of family life. 
        </li>
    
        <li>
            We agree that the program participant will try to adjust, will obey the disciplinary rules of the host family and school, will give respect and obedience to the host family and school officials, 
            and will keep communications open at all times.    
        </li>
    
        <li>
            We understand and agree that the program participant will not take any unprescribed drugs, drink alcoholic beverages, possess false identification, drive any motorized vehicle, or participate in 
            any dangerous sports such as hang gliding, bungee jumping, etc. If the program participant does any of the above, we understand that #subjectivePronoun# may be immediately returned home at our family's expense, 
            and we accept full responsibility for any situation arising from #possessivePronoun# involvement with the above.
        </li>
    
        <li>
            We give permission for our #subject# to use the internet but also understand that prolonged or inappropriate use of the internet, including email or chat rooms, may result in a first warning and then 
            program termination.
        </li>
    
        <li>
            We agree that the program participant may not take any action that may change the nature of #possessivePronoun# life, i.e. getting married, changing religions.
        </li>
    
        <li>
            We understand and agree that the program participant will be subject to all the laws of the host country. In the case of serious infraction of the rules and requirements governing the conduct 
            of the program participant, or in the case of extreme homesickness, or poor adjustment to the host family or school, the participant may be returned home immediately at the discretion of the 
            exchange organization's Executive Committee and at the expense of our family.
        </li>
    
        <li>
            We understand and agree that the program participant may not drive any motorized vehicle that requires an operator's license, nor be a pilot or passenger in a private plane. A student is allowed 
            to register for school-sponsored driver education classes. If a license is obtained through this program, the license must be immediately given to the exchange organization's local representative. 
            It will be returned to the student on the day of departure for home.
        </li>
    
        <li>We understand that as natural parents we are responsible for providing funds necessary for day to day expenses for our child. The suggested amount is approximately $300.00 a month.</li>
    
        <li>We agree to pay the early return of our child if it is deemed necessary for medical reasons after consultation between ourselves, program personnel, and the designated medical authorities.</li>
    
        <li>We agree to pay for any medical and dental bills not covered by the accident and sickness insurance. We agree to pay for any deductible amount due that the insurance policy might not cover.</li>
    
        <li>We agree that the program participant is to possess a return flight ticket from the airport located nearest the host family to the participant's country. </li>
    
        <li>
            We agree to pay for any and all telephone calls made by the program participant including those calls made which might appear on the host family's telephone bill after the departure of the 
            program participant.
        </li>
    
        <li>We give the exchange organization the right to use the participant's name and photograph for reproduction in any medium for the purposes of publication, advertising, trade, display, or editorial use.</li>
    
        <li>
            We agree to attend meetings that are scheduled to prepare us for the exchange experience.
        </li>
    
        <li>
            We confirm that all statements made and all information in this application are true and will be relied upon by the school district and supporting organizations. Any inaccuracy in this application 
            is grounds to terminate the agreement and send the students home (without any refund and at the parents’ expense). 
        </li>
        
    </ol>    
</cfsavecontent>

<table width="670px" cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td>
			<p style="font-weight:bold;">Please read carefully, print, sign and date where indicated.</p>
            
			<div align="justify">
				<!--- Canada Agreement --->
                <cfif ListFind("14,15,16", qGetStudentInfo.app_indicated_program)>            	
					#canadaAgreement#
                <!--- Public High School Agreement --->
                <cfelse>
                	#publicAgreement#
                </cfif>            
            </div>
		</td>
	</tr>
</table>

<table width="660px" border=0 cellpadding=0 cellspacing=0 align="center">
    <tr>
        <td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
        <td width="5"></td>
        <td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>		
        <td width="40"></td>
        <td width="210"><br><img src="#path#pics/line.gif" width="210" height="1" border="0" align="absmiddle"></td>
        <td width="5"></td>
        <td width="100"> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; / &nbsp; &nbsp; &nbsp; &nbsp; / <br><img src="#path#pics/line.gif" width="100" height="1" border="0" align="absmiddle"></td>
    </tr>
    <tr>
        <td>Signature of Parent</td>
        <td></td>
        <td>Date</td>
        <td></td>
        <td>Signature of Student</td>
        <td></td>
        <td>Date</td>	
    </tr>
</table>

<br />


</cfoutput>