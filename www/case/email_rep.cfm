
<META http-equiv="refresh" content="5;URL=http://www.case-usa.org"> 

<!----Insert the data that we are going to collect and put it in the database---->
<cfif form.contact_type is 'rep'>
<!----Insert Rep info---->
    <cfquery name="insert_rep_info" datasource="caseusa">
    insert into case_web_contacts (firstname, lastname, address, city, state, zip, phone, cellphone, email,date_entered, contact_type, comments, where_learn_case)
                        values('#form.firstname#','#form.lastname#','#form.address#','#form.city#',#form.state#,'#form.zip#','#form.phone#','#form.cellphone#','#form.email#',#now()#,'#form.contact_type#', '#form.comments#','#learnaboutcase#')			
    </cfquery>
    <cfquery name="contactid" datasource="caseusa">
    select max(contactid) as cid
    from case_web_contacts
    </cfquery>
<cfelseif form.contact_type is 'stu'>
<!----Insert Student Info---->
  <cfquery name="insert_stu_info" datasource="caseusa">
    insert into case_web_contacts (firstname, lastname, address, city,  zip, phone, cellphone, email,date_entered, contact_type, comments, country)
                        values('#form.firstname#','#form.lastname#','#form.address#','#form.city#','#form.zip#','#form.phone#','#form.cellphone#','#form.email#',#now()#,'#form.contact_type#', '#form.comments#','#country#')			
    </cfquery>
    <cfquery name="contactid" datasource="caseusa">
    select max(contactid) as cid
    from case_web_contacts
    </cfquery>
<cfelseif form.contact_type is 'host'>
<!-----Insert Host Info---->
     <cfquery name="insert_host_info" datasource="caseusa">
    insert into case_web_contacts (firstname, lastname, address, city, state, zip, phone, cellphone, email, high_school,date_entered, contact_type, comments, where_learn_case)
                        values('#form.firstname#','#form.lastname#','#form.address#','#form.city#',#form.state#,'#form.zip#','#form.phone#','#form.cellphone#','#form.email#','#form.highschool#',#now()#,'#form.contact_type#', '#form.comments#', '#form.learnaboutcase#')			
    </cfquery>
    <cfquery name="contactid" datasource="caseusa">
    select max(contactid) as cid
    from case_web_contacts
    </cfquery>
</cfif>
<cfif isDefined('form.state')>
    <cfquery name="state" datasource="caseusa">
    select statename 
    from smg_states
    where id = #form.state#
    </cfquery>
</cfif>
<!----Email the information to Stacy---->

<cfmail to="stacy@case-usa.org" replyto="#form.email#" from="support@case-usa.org" subject="#form.contact_type# Contact from Website" type="html"> 
Information was just submitted via the website! You can view this information here:
http://www.case-usa.org/internal/index.cfm?curdoc=web_contact_info&id=#contactid.cid#

The info submitted was:<br /><br />
Name:#form.firstname# #form.lastname#<Br />
Address:#form.address#<br />
City:#form.city#<Br />
<cfif form.contact_type neq 'stu'>
State:#form.state#<br />
</cfif>
Zip:#form.zip#<br />
Phone:#form.phone#<br />
Cell:#form.cellphone#<Br />
Email:#form.email#<br />
Type of Contact:#form.contact_type#<br />
Comments:#form.comments#<br /><br /><br />


</cfmail>

<cfoutput>

  <p>Your information was submited to CASE.  You will should be contacted shortly.<br />
  </p>
You should be redirected shorty. If not, click <a href="index.cfm">here</a>
</cfoutput>
