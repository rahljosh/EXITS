<?php include 'extensions/includes/_pageHeader.php'; ?>
<script language="javascript" type="text/javascript">
function showHide(shID) {
   if (document.getElementById(shID)) {
      if (document.getElementById(shID+'-show').style.display != 'none') {
         document.getElementById(shID+'-show').style.display = 'none';
         document.getElementById(shID).style.display = 'block';
      }
      else {
         document.getElementById(shID+'-show').style.display = 'inline';
         document.getElementById(shID).style.display = 'none';
      }
   }
}
</script>
<style type="text/css">
<!--

 /* This CSS is used for the Show/Hide functionality. */
   .more, .more1, .more2, .more3, .more4, .more5 {
	display: none;
	/* [disabled]border-top-width: 1px; */
	/* [disabled]border-bottom-width: 1px; */
	/* [disabled]border-top-style: solid; */
	/* [disabled]border-bottom-style: solid; */
	/* [disabled]border-top-color: #CCC; */
	/* [disabled]border-bottom-color: #CCC; */
}
   a.showLink {
	text-decoration: none;
	color: #00406B;
	padding-left: 8px;
	background: transparent url(down.gif) no-repeat left;
	font-size: 10px;
	font-weight: bold;
}
a.hideLink {
	text-decoration: none;
	color: #00406B;
	padding-left: 8px;
	background: transparent url(down.gif) no-repeat left;
	font-size: 9px;
	font-weight: bold;
}
   a.hideLink {
      background: transparent url(up.gif) no-repeat left; }
   a.showLink:hover, a.hideLink:hover {
      border-bottom: 1px dotted #36f; }

-->
</style>
<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/job-opportunity-header.jpg" width="1024" height="250" alt="Contact ISE student Exchange" />

 <div class="clearfloat">&nbsp;</div>
 <div class="bannerCallout" style="padding-left: 30px;">
 <div class="fltrt" style="width: 200px; padding: 35px;"><a href="mailto:contact@iseusa.com" class="basicBlueButton">Send Email</a></div>
   <h1>ISE Job Opportunities</h1>
   <p>Thank you for your interest in working with us. We are pleased that you are considering joining our diverse group of employees who all share a passion for international student exchange. </p>
<!--end bannerCallout --></div>
    <div class="sidebar1">
 <aside>
    <h2>Apply Now</h2>
<?php include 'formTemplates/_JobOpportunityForm.php'; ?>
<div class="dotLine">&nbsp;</div>

  </aside>
  </div>

<article class="content">
<h2>Area Representative</h2>

<p>ISE is searching for area representatives to help place and supervise exchange students for the upcoming school year.</p>
<div class="fltrt" style="width: 250px;"><img src="images/JO-AreaRep.jpg" width="250" height="293"  alt=""/></div>
<p><strong>SUPPORT:</strong> ISE Area Representatives receive unparalleled support in the field. Each area representative is paired with a Regional Manager who trains, develops, and coaches you throughout the placing season. In short, you are never alone.</p>

<p><strong>TRAINING:</strong> ISE uses a web-based training platform that is both visual and audio. During the year, New York office staff will run these trainings and all representatives are required to attend. Also, your Regional Manager will provide an in-person training for you with the rest of the region during the year. There are ample training guides and hands-on material for you to learn all about student exchange!</p>

<p><strong>NETWORKING:</strong> Our area representatives are skillful networkers, able to meet with people and develop long lasting relationships which foster positive environments for student exchange to thrive. Area representatives are able to meet with school officials and host families on a regular basis to provide the extra support that these individuals need.</p>

<p><strong>FLEXIBILITY:</strong> Area Representatives work from home and develop their own schedule to work in the field with families, students, and schools.</p>

<p><strong>COMMUNITY:</strong> Through networking and outreach area representatives develop long lasting bonds with exchange students, schools, and families. Area representatives reinforce positive growth and development within their communities.</p>

<div class="clearfloat">&nbsp;</div>
<div class="blueLine">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>

<h2>Regional Manager</h2>
<p>Regional Managers (RMs) are the senior field staff.  They are responsible for the development and overall quality of a designated region.   RMs' primary responsibility is to recruit, train and supervise the Area Representatives ("ARs") and Regional Advisors ("RAs") in their designated region.  A Regional Manager must ensure that exchange students in his or her region are placed with appropriate host families and in accredited schools in a timely and appropriate manner.  The Regional Manager also is responsible for ensuring that all placement paperwork complies with the Department of State Regulations and ISE policies.   Along with the Program Manager (based in New York), the Regional Manager is responsible for ensuring that every AR in his or her region receives adequate training and guidance to effectively perform his or her duties.  Ensuring the safety and wellbeing of each student in the region is the Regional Manager’s overriding responsibility.</p>

<div class="fltrt" style="width: 200px;"><img src="images/JO-RegManager.jpg" width="200" height="300"  alt=""/></div>
<p><strong>Reporting Structure:</strong></p>

<p>This position reports directly to a Program Manager.</p>

<p><strong>Specific Duties (generally applicable within designated region):</strong></p>
<ul style="margin-left: 10px; list-style-position: outside;
	list-style-type: decimal;">
<li>Be attentive and proactive, especially if there is even the slightest possibility that the safety or welfare of any exchange student may be in issue.</li>

<li>Ensure full compliance with all Department of State regulations and ISE policies.</li>

<li>Maintain a region in which each student has an equal opportunity to be successful.</li>

<li>Represent the company in the field.</li>

<li> Act as the ISE liaison with schools.</li> 

<li>Meet assigned annual goal for student placements.</li>

<li>Ensure that all student placements are completed in a timely and qualitative manner.</li>

<li>Recruit and train new ARs and RAs.</li>

<li>Supervise ARs in all aspects of their jobs.</li>

<li>Assist ARs in the recruitment of host families and in administering student and host family orientations.</li>

<li>Review all reports and evaluations from ARs.</li>

<li>Assist ARs in handling student services issues and work in conjunction with the office Facilitator in handling all such matters.</li>

<li>Ensure that all Host Family Applications, School Acceptance Forms and CBC’s are reviewed and sent to the New York office.</li>

<li>Communicate all flight information to the host family and AR.</li>

<li>Maintain frequent and open communication with assigned Program Manager and Facilitator.</li>

<li>Distribute material to ARs and monitor material requests.</li>

<li>Participate in ongoing training opportunities and mandatory regional training workshops.</li></ul>


<div class="clearfloat">&nbsp;</div>

<div class="dotLine">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>