<?PHP
	



	session_start();
	include 'extensions/_pageHeader.php';
	//include 'dBug.php'; 
	//new dBug($_SESSION); 
	
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);

include 'extensions/includes/_pageHeader.php'; ?>
<?php
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);
?>
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

<body>

<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>

<img src="images/faq-header.jpg" alt="" width="1024" height="250" align="absbottom"/>
  <?php include '_menu.php'; ?>
<div style="width: 960px; margin: 5px auto;">
<div class="dotLine">&nbsp;</div>
<h1>Frequently Asked Questions</h1>
<div class="dotLine" style="margin-bottom: 0px;">&nbsp;</div>
 <div class="clearfloat">&nbsp;</div>
 </div>
     <div class="sidebar1">
 <aside>
    <h2>Questions</h2>
<ul style="margin-left: 20px; margin-right: 10px; padding-bottom: 5px; ">
  <li><a href="#q1" class="BKLink">How much do host families receive for hosting a student?</a></li>
<li><a href="#q2" class="BKLink">Do students coming for exchange in the U.S. speak English?</a></li>
<li><a href="#q3" class="BKLink">Do exchange students have responsibilities?</a></li>
<li><a href="#q4" class="BKLink">What do the exchange students bring money for?</a></li>
<li><a href="#q5" class="BKLink">What if my exchange students gets sick or needs medical attention?</a></li>
<li><a href="#q6" class="BKLink">What happens if the student and family relationship does not work out?</a></li>
<li><a href="#q7" class="BKLink">How old are the students who participate?</a></li>
<li><a href="#q8" class="BKLink">Do I need to secure a visa for my visitor?</a></li>
<li><a href="#q9" class="BKLink">What is required of the host family?</a></li>
<li><a href="#q10" class="BKLink">Are we good candidates for hosting?</a></li>
<li><a href="#q11" class="BKLink">How much does hosting cost?</a></li>
<li><a href="#q12" class="BKLink">How will our exchange students get around?</a></li>
<li><a href="#q13" class="BKLink">What kind of support will International Student Exchange give the host family and exchange students?</a></li>
<li><a href="#q14" class="BKLink">My family isn't a "traditional" family, is it still possible to host?</a></li>
<li><a href="#q15" class="BKLink">Am I the exchange student's legal guardian?</a></li>
<li><a href="#q16" class="BKLink">Can our exchange students drive while living here?</a></li>
<li><a href="#q17" class="BKLink">How long is the exchange student's stay?</a></li>
<li><a href="#q18" class="BKLink">Can young children benefit from hosting?</a></li>
</ul>
<div class="dotLine">&nbsp;</div>

  </aside>
  </div>

<article class="content">
<h2>Answers</h2>


<div id="q1">
<p><strong>1. How much do host families receive for hosting a student?</strong><br /><br />
  The United States Department of State mandates that host families are not compensated for volunteering to host a foreign exchange student.  Instead, they receive many blessings and benefits by hosting. However, when people do volunteer to become a host family, they may be entitled to a $50 per month tax deduction. Check with your accountant to make sure this deduction is available for you.</p>
  <p class="smSize">&dagger;<strong><a
href="http://ecfr.gpoaccess.gov/cgi/t/text/text-idx?c=ecfr&sid=bfef5f6152d538eed70ad639c221a216&rgn=div8&view=text&node=22:1.0.1.7.37.2.1.6&idno=22"
target="_blank" class=external>CFR Title 22, Part 62, Subpart B,
&sect;62.25 (j)(2)</a></strong><br />
<em>Utilize a standard application form developed by the sponsor that
includes, at a minimum, all data fields provided in Appendix F,
"Information to be Collected on Secondary School Student Host Family
Applications". The form must include a statement stating that: "The
income data collected will be used solely for the purposes of
determining that the basic needs of the exchange student can be met,
including three quality meals and transportation to and from school
activities." Such application form must be signed and dated at the
time of application by all potential host family applicants. The host
family application must be designed to provide a detailed summary and
profile of the host family, the physical home environment (to include
photographs of the host family home's exterior and grounds, kitchen,
student's bedroom, bathroom, and family or living room), family
composition, and community environment. Exchange students are not
permitted to reside with their relatives.</em></p>
</div>


<div class="blueLine">&nbsp;</div>

<div id="q2">
<div class="testimonial" style="float:right; margin: 0 20px 0 20px; padding: 15px;"> <p>Did you know that exchange students with ISE programs come from over 40 different countries?</p></div>
<p><strong>2. Do students coming for exchange in the U.S. speak English?</strong><br /><br />
Yes, It is required that all students must be able to function in their classrooms while an exchange student. Our students are screened abroad as well as by their acceptance committee in America. They have to Skype with one of our administrators in the US.  All students speak English, but some cultures will be more proficient in the beginning.
</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q3">
<div class="testimonial" style="float:right; width: 250px; margin: 0 20px 0 20px; padding: 15px;"><p>Exchange students are living out their dream by coming to America. Meet some of our students to see the types of high quality students we provide through the ISE program.</p></div>
<p><strong>3. Do exchange students have responsibilities?</strong><br /><br />
  Exchange students are expected to adapt to the host family's lifestyle and ground rules and to participate in family activities. Our students know that this program is not a trip or a tour, but an academic home stay that requires work and effort that will result in learning. Students are expected to help out with family chores.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q4">
<div class="testimonial" style="float:right; margin: 0 20px 0 20px; padding: 15px;">Exchange students love to get together with other students and have fun!</div>
<p><strong>4. What do the exchange students bring money for?</strong><br /><br />
 Exchange students have their own pocket money provided by their natural families. The students will take care of their own phone bills, school lunches, school expenses and recreation such as movies and bowling <em>(We ask that every student has at least $300 a month of spending money)</em>.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q5">
<p><strong>5. What if my exchange students gets sick or needs medical attention?</strong><br /><br />
  The ISE Program is covered by full medical insurance with a small deductible. Any liability is the responsibility of the organization.  If in doubt, call the information hot line or your Area Representative. A copy of your student's physical exam is in his application package.</p></div>


  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q6">
<p><strong>6. What happens if the student and family relationship does not work out?</strong><br /><br />
  If an exchange student and host family have a misunderstanding, the local representative and his/her immediate supervisor provide counsel and support with guidance from the National Office. If a host family has an insurmountable difficulty or an unexpected change in family life, the Area Program Representative will arrange for another placement for the student.</p></div>

 <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q7">
<p><strong>7. How old are the students who participate?</strong><br /><br />
Exchange students are 15-18 years old when they enter the U.S. The high school that the exchange students attends will determine what grade the student will enter from the student application.</p></div>

 <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>
  
<div id="q8">
<p><strong>8. Do I need to secure a visa for my visitor?</strong><br /><br />
  <strong> No.</strong> Exchange students enter the U.S. on what is called a J-1 exchange visitor visa, secured with a DS 2019 form issued by participating programs. The Program assumes all responsibilities for visas, visa issues and any other travel documents.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q9">
<p><strong>9. What is required of the host family?</strong></p>
<ul>
<li>Have an understanding of the responsibilities involved.</li>
<li>Have two or more host family members, married or related by blood (single people may host with approval from natural family).</li>
<li>Host parents must be a minimum of 25 years of age.</li>
<li>Provide the exchange students with a bed and a place to study. An exchange student may not share a bed. An exchange student may share a room, but only with a host sibling of the same gender who is within five years of the student's age.</li>
<li>Provide breakfast, lunch, dinner and snacks for the exchange student. The exchange student is prepared to buy lunch on school days.</li>
<li>Be financially secure and able to assume the costs of hosting a teenager. Many families do enjoy supplying the extras at times of their choice.</li></ul></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q10">
<div class="testimonial" style="float:right; margin: 0 20px 0 20px;">Complete a no obligation Hosting Pre-Application and a local representative will assist you in your selection process.</div>
<p><strong>10. Are we good candidates for hosting?</strong><br /><br />
  Exchange students enjoy living on farms, in small towns, suburbs and big cities. Every community offers the opportunity for friendship and learning. Whether you are a married couple with children at home, a single parent, an empty nester or a grandparent, as long as you have some extra love to go around, that's all you need!</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q11">
<p><strong>11. How much does hosting cost?</strong><br /><br />
 Your financial responsibility is quite minimal. If you can afford food on the table, that's basically enough. Your exchange student's natural parents will pay for all travel costs, program fees and health insurance. They will also provide the exchange student with a monthly spending allowance used for school expenses, social activities, clothing and other essentials.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q12">
<p><strong>12. How will our exchange student get around?</strong><br /><br />
  ISE understands that you are very busy with work responsibilities and extra-curricular activities. Our exchange students are not allowed to drive, but will take school and public buses whenever available. They often make friends who drive. Host family members are not expected to be chauffeurs, but to simply offer the exchange students a ride when it is convenient and help them make alternative arrangements.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>
 
 <div id="q13"> 
<p><strong>13. What kind of support will International Student Exchange give the host family and exchange students?</strong><br /><br />
  A professionally trained Area Representative will be assigned to work with a host family and exchange student for the entire program. Your Area Representative will visit with you and your student monthly, offering advice and support. The Area Representative will maintain regular contact with your local high school and complete a monthly report, evaluating your exchange student's progress in family life, academic achievement and social activity. Your Area Representative, in turn, is supported by a team of dedicated regional and national program staff, available 24/7 in case of emergency.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q14">
<p><strong>14. My family isn't a &quot;traditional&quot; family, is it still possible to host?</strong><br /><br />
Of Course! Our host families come in all shapes and sizes. Host families may include single parent households, parents with adult children, families with small children and many other varieties. </p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q15">
<p><strong>15. Am I the exchange student's legal guardian?</strong><br /><br />
  No. The exchange student's natural parents remain legal guardians. The exchange student's program takes legal responsibility for the exchange student during the course of the program. Each exchange student's Certificate of Health contains a medical release form so that host parents may secure medical treatment in the case of an emergency.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q16">
<p><strong>16. Can our exchange student drive while living here?</strong><br /><br />
  Exchange students may NOT drive a car while on program. Time permitting, exchange students may take driver's education and drive only the driver's education automobile.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q17">
<p><strong>17. How long is the exchange student's stay?</strong><br /><br />
School year exchange students arrive in August or September for a 10 month academic stay, returning home to their home country in May or June. Semester  exchange students come for a 5 month stay and either arrive in August and stay until January or arrive in January and stay until June.  Exchange students from the Southern Hemisphere can come in January for the 12 month program.</p></div>

  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>

<div class="blueLine">&nbsp;</div>

<div id="q18">
<p><strong>18. Can young children benefit from hosting?</strong><br /><br />
  Many of the  exchange students accepted into the program indicate an interest in being placed in host families with small children. As for your own children, their facility for learning a language is never greater than when they are young; and their interest, curiosity and acceptance of people different from themselves is strongest at a young age.</p></div>
  
  <p class="smSize"><a href="#top">Return to top &#8593;</a></p>


<div class="clearfloat">&nbsp;</div>
<div class="dotLine">&nbsp;</div>
<div class="clearfloat">&nbsp;</div>

</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>