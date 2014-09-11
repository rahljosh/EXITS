<!--- Kill Extra Output --->
<cfsilent>

	<cfparam name="sd" default="son/daughter">
	<cfparam name="hs" default="he/she">
   	<cfparam name="hh" default="his/her">

</cfsilent>
<Cfquery name="companyInfo" datasource="#APPLICATION.dsn#">
    select *
    from smg_companies
    where companyid = <cfqueryparam cfsqltype="cf_sql_integer" value="#CLIENT.companyid#">
      </Cfquery>
<style>
.cap{text-transform:capitalize;}
</style>
<cfoutput>
<cfsavecontent variable="publicAgreement">
<p style="font-size:10px;" >This form is important.  It includes terms and conditions and releases #client.companyshort# from legal liability.</p>
<p style="font-size:10px;" >All participants and their parent(s)/guardian(s) MUST sign this form.</p>
<p style="font-size:10px;" >I understand and agree that this agreement shall constitute a binding contract between the undersigned and "#CLIENT.companyshort#". "#CLIENT.companyshort#" is defined to include: #CLIENT.companyname#, its affiliates, and their owners, directors, officers, and employees.</p>
<ol>
<li style="font-size:10px;">I hereby waive and release #CLIENT.companyshort# to the maximum extent permitted by law, from any claims, causes of action, and liability for any loss or damage (including, without limitation, damage to property, personal injury, illness, or death) suffered or incurred in connection with the Program, by me (or my dependent), whether based on breach of contract, statutory duty or warranty, negligence, or any other grounds.</li>
<li style="font-size:10px;">I will indemnify #CLIENT.companyshort# for any loss or damage incurred or suffered by it and caused by me (or my dependent) in connection with the Program.</li>
<li style="font-size:10px;">#CLIENT.companyshort# does not own or operate any entity which is to or does provide goods or services for the Program (except that it employs regional directors and staff and may cover participant with #CLIENT.companyshort# affiliated travel insurance), including, for example, arrangements for or ownership or control over houses, apartments, or other lodging facilities, airline, vessel, bus, or other transportation companies, local ground operators, visa processing services, providers or organizers of optional excursions, food service, or entertainment providers, etc. All such persons and entities are independent contractors. As a result, #CLIENT.companyshort# is not liable for any negligent or willful act or failure to act of any such person or entity, or of any other third party. Without limitation, #CLIENT.companyshort# is not responsible for any injury, loss, or damage to person or property, death, delay, or inconvenience in connection with the provision of any goods or services occasioned by or resulting from, but not limited to, acts of God, force majeure, acts of war or civil unrest, insurrection or revolt, strikes or other labor activities, criminal, terrorist or threatened terrorist activities of any kind, overbooking or downgrading of accommodations, structural or other defective conditions in houses, apartments, or other lodging facilities (or in any heating, plumbing, electrical, or structural problem therein), mechanical or other failure of airplanes or other means of transportation or for any failure of any transportation mechanism to arrive or depart timely, dangers associated with animals, sanitation problems, food poisoning, epidemics or the threat thereof, disease, lack of access to or quality of medical care, difficulty in evacuation in case of a medical or other emergency, or for any other cause beyond the direct control of #CLIENT.companyshort#.</li>
<li style="font-size:10px;">I understand that perceived or actual epidemics (such as, but not limited to, H1N1, SARS, or bird flu) can delay, disrupt, interrupt, or cancel programs. I agree to assume all risk of any such problems which could result from any such occurrences.</li>
<li style="font-size:10px;">#CLIENT.companyshort# retains the right, in its sole discretion, to contact participant's school, parents, and/or guardian with regard to health issues or any other matter whatsoever which relates to participant or participant's program. These rights transcend any and all privacy regulations that may apply.</li>
<li style="font-size:10px;">In the event of a medical emergency, #CLIENT.companyshort# will attempt to cause appropriate treatment to be administered. However, it makes no warranty that it will be able to cause effective (or any) emergency treatment to be administered.</li>
<li style="font-size:10px;">#CLIENT.companyshort#, in its sole discretion, can approve or disapprove of any participant's housing.</li>
<li style="font-size:10px;">#CLIENT.companyshort# reserves the right to decline, accept, dismiss, or retain any person as a participant in any program at any time before or during the program for any reason.  If a participant is removed by #CLIENT.companyshort# from a program for cause, or if the participant voluntarily leaves the program, there will be no refund of any payments made.</li>
<li style="font-size:10px;"> I agree that all of the information provided in the application is true to the best of my knowledge and that any falsification of or failure to disclose any relevant information may lead to immediate dismissal from the program.</li>
<li style="font-size:10px;">All program applications are subject to acceptance by #CLIENT.companyshort# in #companyInfo.city#, #companyInfo.state#, U.S.A.</li>
<li style="font-size:10px;">I give #CLIENT.companyshort# permission to use any written, photographic, or video images of me (or my dependent) in the course of reporting on and/or promoting #CLIENT.companyshort# programs.</li>
<li style="font-size:10px;">Participant and parent(s)/guardian(s) are responsible for all fees and charges associated with this program. This includes, but is not limited to, any private school tuition, fees, medical bills not paid by insurance, or other associated costs incurred.</li>
<li style="font-size:10px;">I give my son/daughter permission to travel with the host family, organized and adult supervised school or organizational function, or #CLIENT.companyshort# organized trip.</li>
<li style="font-size:10px;">In the event any part of this "#CLIENT.companyshort# Program Participant Contract and Waiver" is found to be legally void or unenforceable, then such part will be stricken but the rest of this document will be given full force and effect.</li>
<li style="font-size:10px;">COMPULSORY ARBITRATION: I agree that any dispute concerning, relating, or referring to this contract, any literature concerning this program, or the program itself shall be resolved exclusively by binding arbitration in #companyInfo.city#, #companyInfo.state#, according to the then existing commercial rules of the American Arbitration Association. The arbitrator and not any federal, state, or local court or agency shall have exclusive authority to resolve any dispute relating to the interpretation, applicability, enforceability, conscionability, or formation of this contract, including but not limited to any claim that all or any part of this contract is void or voidable. Such proceedings will be governed by substantive New York law without reference to its conflict of laws provisions.</li>
</ol>
</cfsavecontent>

<cfsavecontent variable="phpAgreement">
<p style="font-size:10px;" >This form is important.  It includes terms and conditions and releases DMD Private High School Program (DMD/PHP) from legal liability.</p>
<p style="font-size:10px;" >All participants and their parent(s)/guardian(s) MUST sign this form.</p>
<p style="font-size:10px;" >I understand and agree that this agreement shall constitute a binding contract between the undersigned and "DMD/PHP". "DMD/PHP" is defined to include: KCK International, Inc. which does business as DMD Private High School Program, its affiliates, and their owners, directors, officers, and employees.</p>
<ol>
<li style="font-size:10px;">I hereby waive and release DMD/PHP to the maximum extent permitted by law, from any claims, causes of action, and liability for any loss or damage (including, without limitation, damage to property, personal injury, illness, or death) suffered or incurred in connection with the Program, by me (or my dependent), whether based on breach of contract, statutory duty or warranty, negligence, or any other grounds.</li>
<li style="font-size:10px;">I will indemnify DMD/PHP for any loss or damage incurred or suffered by it and caused by me (or my dependent) in connection with the Program.</li>
<li style="font-size:10px;">DMD/PHP does not own or operate any entity which is to or does provide goods or services for the Program (except that it employs  staff and may cover participant with DMD/PHP affiliated travel insurance), including, for example, arrangements for or ownership or control over houses, apartments, or other lodging facilities, airline, vessel, bus, or other transportation companies, local ground operators, visa processing services, providers or organizers of optional excursions, food service, or entertainment providers, etc. All such persons and entities are independent contractors. As a result, DMD/PHP is not liable for any negligent or willful act or failure to act of any such person or entity, or of any other third party. Without limitation, DMD/PHP is not responsible for any injury, loss, or damage to person or property, death, delay, or inconvenience in connection with the provision of any goods or services occasioned by or resulting from, but not limited to, acts of God, force majeure, acts of war or civil unrest, insurrection or revolt, strikes or other labor activities, criminal, terrorist or threatened terrorist activities of any kind, overbooking or downgrading of accommodations, structural or other defective conditions in houses, apartments, or other lodging facilities (or in any heating, plumbing, electrical, or structural problem therein), mechanical or other failure of airplanes or other means of transportation or for any failure of any transportation mechanism to arrive or depart timely, dangers associated with animals, sanitation problems, food poisoning, epidemics or the threat thereof, disease, lack of access to or quality of medical care, difficulty in evacuation in case of a medical or other emergency, or for any other cause beyond the direct control of DMD/PHP.</li>
<li style="font-size:10px;">I understand that perceived or actual epidemics (such as, but not limited to, H1N1, SARS, or bird flu) can delay, disrupt, interrupt, or cancel programs. I agree to assume all risk of any such problems which could result from any such occurrences.</li>
<li style="font-size:10px;">DMD/PHP retains the right, in its sole discretion, to contact participant’s school, parents, and/or guardian with regard to health issues or any other matter whatsoever which relates to participant or participant’s program. These rights transcend any and all privacy regulations that may apply.</li>
<li style="font-size:10px;">In the event of a medical emergency, DMD/PHP will attempt to cause appropriate treatment to be administered. However, it makes no warranty that it will be able to cause effective (or any) emergency treatment to be administered.</li>
<li style="font-size:10px;">DMD/PHP, in its sole discretion, can approve or disapprove of any participant's housing.</li>
<li style="font-size:10px;">DMD/PHP reserves the right to decline, accept, dismiss, or retain any person as a participant in any program at any time before or during the program for any reason.  If a participant is removed by DMD/PHP from a program for cause, or if the participant voluntarily leaves the program, there will be no refund of any payments made.</li>
<li style="font-size:10px;">I agree that all of the information provided in the application is true to the best of my knowledge and that any falsification of or failure to disclose any relevant information may lead to immediate dismissal from the program.</li>
<li style="font-size:10px;">All program applications are subject to acceptance by DMD/PHP in Babylon, NY, U.S.A.</li>
<li style="font-size:10px;"> I give DMD/PHP permission to use any written, photographic, or video images of me (or my dependent) in the course of reporting on and/or promoting DMD/PHP programs.</li>
<li style="font-size:10px;">Participant and parent(s)/guardian(s) are responsible for all fees and charges associated with this program. This includes, but is not limited to, any private school tuition, fees, medical bills not paid by insurance, or other associated costs incurred.</li>
<li style="font-size:10px;"> I give my son/daughter permission to travel with the host family, organized and adult supervised school or organizational function, or DMD/PHP organized trip. </li>
<li style="font-size:10px;">In the event any part of this " DMD/PHP Program Participant Contract and Waiver" is found to be legally void or unenforceable, then such part will be stricken but the rest of this document will be given full force and effect.</li>
<li style="font-size:10px;">COMPULSORY ARBITRATION: I agree that any dispute concerning, relating, or referring to this contract, any literature concerning this program, or the program itself shall be resolved exclusively by binding arbitration in Babylon, NY, according to the then existing commercial rules of the American Arbitration Association. The arbitrator and not any federal, state, or local court or agency shall have exclusive authority to resolve any dispute relating to the interpretation, applicability, enforceability, conscionability, or formation of this contract, including but not limited to any claim that all or any part of this contract is void or voidable. Such proceedings will be governed by substantive New York law without reference to its conflict of laws provisions.</li>
</ol>

</cfsavecontent>

 		<cfif  ListFind("6", client.companyid)>
            	#phpAgreement#
            <cfelse>
		        <!--- Public High School Agreement --->
                #publicAgreement#
            </cfif>  
</cfoutput>
