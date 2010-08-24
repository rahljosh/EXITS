
<!----Email the information to Granby Prep---->
<cfoutput>
<cfmail  to="josh@iseusa.com" replyto="#form.email#" from="support@granbyprep.com" type="html" SUBJECT="Granby Info Request"> 
<p> The info submitted was:
  <br /><br />
  <strong>Student Information</strong><br />
  Name:#form.firstname# #form.lastname#<br />
  Sex:#form.male# #form.female#
  <br />
  Date of Birth:#form.birth#<br />
  Current School:#form.current#<br />
  Current Grade: #form.grade# <br />
  Admission for what grade: #form.admission#<br />
  Admission for what grade: #form.admYear#<br />
  Day / Boarding school:#form.school#<br />
  Academic Interests:#form.academicInt#<br />
  Other Interests:#form.interests#<br />
  Sports Interests:#form.sportsInt#
  Comments:#form.comments#<br /><br /><br />
  
  <strong>Parent / Guardian Information</strong><br />
   Name:#form.ptfirstname# #form.ptlastname#<Br />
  Address:#form.address#<br />
  City:#form.city#<Br />
  State:#form.state#<br />
  Zip:#form.zip#<br />
  Country: #form.country#<br />
  Phone: #form.phone#<br />
  Email:#form.email#<br /><br />
  
  Have a rockin day.</p>

</cfmail>
<Cfabort>
  <p>Your information was submited to Granby Prep.  You will should be contacted shortly.<br />
  </p>
You should be redirected shorty. If not, click <a href="index.cfm">here</a>
</cfoutput>
