<!--- Kill Extra Output --->
<cfsilent>
	
    <!--- Get Student Information --->
    <cfquery name="qGetStudentInfo" datasource="#APPLICATION.DSN#">
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
	
    <cfif client.companyid eq 14>
    	<cfset progDesig = "F-1">
    <cfelse>
    	<cfset progDesig = "J-1">
    </cfif>
    
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
		if ( LEN(URL.curdoc) OR IsDefined('url.path') ) {
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
<!----PHP Agreement---->

<cfsavecontent variable="phpAgreement">
<p>
In the City of  #cityInfo#   , country of #countryInfo#, on the  #dayInfo#  day of  #monthInfo#  in the year of  #yearInfo#  , I/We the undersigned parents “Parents” of   #studentInfo# my/our #subject#, and I, the “Exchange Student”,  understand and agree that this agreement shall constitute a binding contract between the undersigned and "DMD/PHP". "DMD/PHP" is defined to include: KCK International, Inc., its affiliates, and their owners, directors, officers, and employees.
</p>
<p>
The F-1 Private School Program is a cultural exchange program where the Exchange Student will live with a family in the United States and attend school during the entire length of the program.  
</p>
<p>
The host families are screened by DMD/PHP by closely following the CSIET guidelines and vary in many ways including family composition, geographic location, size of the home, standard of accommodation and numerous other factors. 
</p>
<p>
The Exchange Student will accept placement with a family of any race, creed, or color or family composition.  Live as a member of your host family, respect your host family and their rules and customs, and accept the responsibilities given to you. DMD/PHP, in its sole discretion, is responsible for choosing a student’s host family placement.  Rejection of a placement or a request to be relocated from my host family after arrival without material cause, can result in termination from DMD’PHP’s exchange program.
</p>
<p>
The Exchange Student agrees to follow the regulations of the F-1 Exchange Visitor Visa and the U.S. State as well as all DMD/PHP program rules that are detailed in the DMD/PHP student handbook.
</p>
<p>
The Exchange Student will abide by the federal, state, and local laws of the United States and any state, city, town, county or other jurisdictional region.
</p>
<p>Under these laws, consumption of alcoholic beverages by anyone under the age of 21, and the use or possession of illegal or un-prescribed prescription drugs, and the use of tobacco product by anyone under the age of 18 is prohibited.</p>
<p>The Exchange Student will attend the arrival orientation.</p>
<p>The Exchange Student will read and carefully consider all materials made available that relate to safety, health, legal, environmental, political, cultural and religious conditions in your host town. Be aware of local conditions that may present health or safety risks when making daily choices and decisions.</p>
<p>The Exchange Student will respect the host high school’s guidelines and policies, including those with regard to conduct, delinquency, grade levels, participation in graduation ceremonies, and issuance of a high school diploma.  The exchange student will obey all lawful orders of school officials.</p>
<p>The Exchange Student must maintain a C+ average or higher in all courses at the host high school, evaluated on a quarterly basis. Courses must include English (other than English as a second language) and an American History course and two other academic courses. Attend school every day that it is in session and follow school policies with regards to absences.</p>
<p>The Exchange Student may be required to hire tutors, at their own expense, if in the opinion of DMD/PHP and/or school officials, their language skills are inadequate for the program.</p>
<p>The Exchange Student will travel only with adult members of the Host Family, the DMD/PHP Area or School Representative, on official school trips, or DMD/PHP sponsored trips.   Travel home during the program is discouraged.  Travel with or visits from natural family members are also discouraged.  </p>
<p>The Exchange Student understands that driving or purchasing a motorized vehicle (car, motorcycle, boat, or any other vehicle requiring a driver’s license) is prohibited. Driving is permitted with the instructor of an official driver’s education course and only during class hours. This is solely for the purpose of obtaining a driving license and does not allow the student to drive after a license is obtained. </p>
<p>The Exchange Student will have access to a minimum of $300 U.S. dollars per month to cover personal expenses. Do not borrow money from your host family. Do not lend money to your host family.</p>
<p>The Exchange Student will arrive no more than five days prior to the start of the school and depart no more than five days after the end of school.</p>
<p>Participation in extra-curricular activities or athletics is not guaranteed. Employment is not allowed on either a full or part-time basis while on the F-1 visa high school program. However, students may accept sporadic or intermittent employment such as babysitting or yard work.</p>
<p>Exchange Student’s primary intention for participation in the program, and primary focus during the program, should be the cultural exchange experience and academic success.  Graduation from an American high school is not uncommon, but is at the discretion of the school. </p>
<p>The Exchange Student may not initiate any life-changing decisions or actions while on the program, including changing religions (though a student is free to explore the tenets of any religion), pregnancy, adoption or marriage. Students may not alter their body in any way while on the program (for example, with tattoos or body piercings).</p>
<p>The Exchange Student will be dismissed from the program if they suffer from a medical condition or psychological condition that DMD/PHP deems to be overly burdensome to the Host Family or DMD/PHP staff.</p>
<p>The Exchange Student will refrain from obscene, indecent, violent or disorderly conduct while on the program. Exchange Students shall also refrain from perpetrating any form of harassment -  including but not limited to; violent threats, physical abuse, sexual harassment, harassment based on sexual orientation, gender, race, religion or any other factor - of host family members, DMD/PHP staff, fellow students, school staff, members of the community or any other individuals.</p>
<p>Exchange students shall not engage in any self-endangering behaviors. In addition, students shall refrain from any other conduct likely to bring the U.S. State Department or DMD/PHP into notoriety or disrepute.</p>
<p>Any material that an Exchange Student publishes on the internet (such as on social networking sites or blogs) that violates Program Rules will be grounds for student dismissal.</p>
<p>The Exchange Student and his Parents acknowledge that DMD/PHP reserves the right to dismiss any student who fails to uphold any and all of the rules listed above, detailed in the student handbook, or detailed in any government or industry regulation. DMD/PHP also reserves the right to dismiss students for other inappropriate behaviors and/or actions not explicitly stated in the rules above or student handbook, that in DMD/PHP’s reasonable judgment negatively impact the host family, community or program. In the event that a student is dismissed from the program, the parent or natural guardians are responsible for all additional expenses incurred above those of the regular program costs. In the case of early dismissal, program fees will not be reimbursed.</p>
<p>The Exchange Student and his Parents acknowledge that DMD/PHP is not acting in the capacity of in loco parentis with respect to you, and that your natural parents still retain all of their rights and obligations and are expected to maintain regular and frequent (once or twice per month) contact with you telephonically, electronically or in person (if possible, after five months of your program start date).</p>
</cfsavecontent>
<!--- Public High School Agreement --->
<cfsavecontent variable="publicAgreement">
    <p style="font-size:10px; padding-left:10px;">
        In the City of #cityInfo#, country of #countryInfo#, on the #dayInfo# day of #monthInfo# in the year of #yearInfo#, I/We the undersigned parents of #studentInfo# my/our #subject#, 
        and I, the "Exchange Student", understand and agree that this agreement shall constitute a binding contract between the undersigned and "#client.companyshort#". "#client.companyshort#" is defined to include: International Student Exchange, Inc., its affiliates, and their owners, directors, officers, and employees.
    </p>
    
    <ol style="font-size:10px; padding-right:10px;">
    
        <li>
          The #progDesig# Secondary School Program is a cultural exchange program where the Exchange Student will live with a volunteer family in the United States and attend school during the entire length of the program.  
        </li>
        
        <li>
           The volunteer host families are screened by #client.companyshort# in accordance with USDOS and CSIET standard and vary in many ways including family composition, geographic location, size of the home, standard of accommodation and numerous other factors.  </u></b>
        </li>
        
        <li>
           The Exchange Student will accept placement with a family of any race, creed, or color or family composition.  Live as a member of your host family, respect your host family and their rules and customs, and accept the responsibilities given to you. #client.companyshort#, in its sole discretion, is responsible for choosing a student's host family placement.  Rejection of a placement or a request to be relocated from my host family after arrival without material cause, can result in termination from #CLIENT.companyshort#'s exchange program.
        </li>
        
        <li>
          The Exchange Student agrees to follow the regulations of the #progDesig# Exchange Visitor Visa and the U.S. State as well as all #CLIENT.companyshort# program rules that are detailed in the #CLIENT.companyshort# student handbook.
        </li>
        
        <li>
           The Exchange Student will abide by the federal, state, and local laws of the United States and any state, city, town, county or other jurisdictional region.
        </li>
        
        <li>
           Under these laws, consumption of alcoholic beverages by anyone under the age of 21, and the use or possession of illegal or un-prescribed prescription drugs, and the use of tobacco product by anyone under the age of 18 is prohibited.
        </li>
        
        <li>The Exchange Student will attend the arrival orientation.</li>
        
        <li>The Exchange Student will read and carefully consider all materials made available that relate to safety, health, legal, environmental, political, cultural and religious conditions in your host town. Be aware of local conditions that may present health or safety risks when making daily choices and decisions.</li>
        
        <li>The Exchange Student will respect the host high school's guidelines and policies, including those with regard to conduct, delinquency, grade levels, participation in graduation ceremonies, and issuance of a high school diploma.  The exchange student will obey all lawful orders  of school officials.
        </li>
        
        <li>
            The Exchange Student must maintain a C+ average or higher in all courses at the host high school, evaluated on a quarterly basis. Courses must include English (other than English as a second language) and an American History course and two other academic courses. Attend school every day that it is in session and follow school policies with regards to absences.
        </li>
        
        <li>
           The Exchange Student may be required to hire tutors, at their own expense, if in the opinion of #CLIENT.companyshort# and/or school officials, their language skills are inadequate for the program.
        </li>
        
        <li>
           The Exchange Student will travel only with adult members of the Host Family, the #CLIENT.companyshort# Area Representative, on official school trips, or #CLIENT.companyshort# sponsored trips.   Travel home during the program is prohibited.  Travel with or visits from natural family members are not permitted.
        </li>
        
        <li>The Exchange Student understands that driving or purchasing a motorized vehicle (car, motorcycle, boat, or any other vehicle requiring a driver's license) is prohibited. Driving is permitted with the instructor of an official driver's education course and only during class hours. This is solely for the purpose of obtaining a driving license and does not allow the student to drive after a license is obtained.</li>
        
        <li>
           The Exchange Student will have access to a minimum of $300 U.S. dollars per month to cover personal expenses. Do not borrow money from your host family. Do not lend money to your host family.
        </li>
        
        <li>The Exchange Student will arrive no more than five days prior to the start of the school and depart no more than five days after the end of school.</li>
         
        <li>
           Participation in extra-curricular activities or athletics is not guaranteed. Employment is not allowed on either a full or part-time basis while on the #progDesig# visa high school program. However, students may accept sporadic or intermittent employment such as babysitting or yard work.
        </li>
        
        <li>
           Exchange Student's primary intention for participation in the program, and primary focus during the program, should be the cultural exchange experience.  Graduation from an American high school is uncommon and at the discretion of the school.  Students are not to ask the host family or any #CLIENT.companyshort# staff for assistance in entrance to college in the US, campus visits, test preparation or change their visa or immigration status.

        </li>
        
        <li>
           The Exchange Student may not initiate any life-changing decisions or actions while on the program, including changing religions (though a student is free to explore the tenets of any religion), pregnancy, adoption or marriage. Students may not alter their body in any way while on the program (for example, with tattoos or body piercings).
        </li>
        
        <li>The Exchange Student will be dismissed from the program if they suffer from a medical condition or psychological condition that #CLIENT.companyshort# deems to be overly burdensome to the Host Family or #CLIENT.companyshort# staff.</li>
    	
        <li>The Exchange Student will refrain from obscene, indecent, violent or disorderly conduct while on the program. Exchange Students shall also refrain from perpetrating any form of harassment -  including but not limited to; violent threats, physical abuse, sexual harassment, harassment based on sexual orientation, gender, race, religion or any other factor - of host family members, #CLIENT.companyshort# staff, fellow students, school staff, members of the community or any other individuals.</li>
        <li>Exchange students shall not engage in any self-endangering behaviors. In addition, students shall refrain from any other conduct likely to bring the U.S. State Department or #CLIENT.companyshort# into notoriety or disrepute.</li>
        <li>Any material that an Exchange Student publishes on the internet (such as on social networking sites or blogs) that violates Program Rules will be grounds for student dismissal.</li>
        <li>The Exchange Student and his Parents acknowledge that #CLIENT.companyshort# reserves the right to dismiss any student who fails to uphold any and all of the rules listed above, detailed in the student handbook, or detailed in any government or industry regulation.  #CLIENT.companyshort# also reserves the right to dismiss students for other inappropriate behaviors and/or actions not explicitly stated in the rules above or student handbook, that in #CLIENT.companyshort#'s reasonable judgment negatively impact the host family, community or program. In the event that a student is dismissed from the program, the parent or natural guardians are responsible for all additional expenses incurred above those of the regular program costs. In the case of early dismissal, program fees will not be reimbursed.</li>
        <li>The Exchange Student and his Parents acknowledge that #CLIENT.companyshort# is not acting in the capacity of in loco parentis with respect to you, and that your natural parents still retain all of their rights and obligations and are expected to maintain regular and frequent (once or twice per month) contact with you via phone, email, social media or VOIP.</li>
      
        
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
            is grounds to terminate the agreement and send the students home (without any refund and at the parents' expense). 
        </li>
        
    </ol>    
</cfsavecontent>

<table width="670px" cellpadding=3 cellspacing=0 align="center">
	<tr>
		<td style="text-align:justify;">
			<p style="font-weight:bold;">Please read carefully, print, sign and date where indicated.</p>
            
            <cfif ListFind("14,15,16", qGetStudentInfo.app_indicated_program)>            	
				<!--- Canada Agreement --->
                #canadaAgreement#
            <cfelseif ListFind("5", qGetStudentInfo.app_indicated_program)>
            	#phpAgreement#
            <cfelse>
		        <!--- Public High School Agreement --->
                #publicAgreement#
            </cfif>            
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