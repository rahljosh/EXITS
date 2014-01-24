<?php include 'extensions/includes/_pageHeader.php'; ?>
<?php
$quotes = file("_quotes.txt");
srand((double)microtime() * 1000000);
$ranNum = rand(0, count($quotes)-1);
?>
<body>
<?php include '_slidingLogin.php'; ?>
<div class="container">
  <?php include '_header.php'; ?>
  <div class="clearfloat">&nbsp;</div>
  <?php include '_menu.php'; ?>
<img src="images/Become-host-family.jpg" width="1024" height="250" alt=" ISE student Scholarships" />

 <div class="clearfloat">&nbsp;</div>
 <div class="sidebar2">
   <div class="ltblueBorder" style="float: right;">
  <div class="boxBrdTp"><h1>Ready to Host</h1></div>
  <div class="boxBrdRt">
    <p>If you are ready to host or want to speak with an area representative. <a href="ready-host-student.cfm"><br>
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="ready-host-student.cfm"><img src="images/ready-host-exchange-student.jpg" width="109" height="111" alt="Ready to Host an exchange student"></a></div>
<!-- ltGreenBorder --></div>

  <div class="redBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Why Host?</h1></div>
       <div class="boxFlipRt"><a href="why-host-family.cfm"><img src="images/why-host-exchange-student.jpg" width="109" height="110" alt="Why host an exchange student"></a></div>
  <div class="boxFlipLt">
    <p>Being a host benefits your family and community. <a href="why-host-family.cfm"><br>
      details&#187;</a></p>
  </div>

<!-- redBorder --></div>

  <div class="greenBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Meet Our Students</h1></div>
  <div class="boxBrdRt">
    <p>We have many wonderful students to choose from<br> <a href="meet-our-students.cfm">
      details&#187;</a></p>
  </div>
   <div class="boxBrdLt"><a href="meet-our-students.cfm"><img src="images/meet-our-students.jpg" width="109" height="110" alt="meet our students"></a></div>
<!-- greenBorder --></div>

  <div class="orangeBorder" style="float: right;">
  <div class="boxBrdTp">
    <h1>Hosting Requirements</h1></div>
       <div class="boxFlipRt"><a href="hosting-requirements.cfm"><img src="images/hosting-requirements.jpg" width="110" height="109" alt="Hosting Requirements"></a></div>
  <div class="boxFlipLt">
    <p>If you are wondering if your family is a good fit to host, see what is required.<br> <a href="hosting-requirements.cfm">
        details&#187;</a></p>
  </div>
<!-- orangeBorder --></div>

    <div class="clearfloat">&nbsp;</div>  
<!-- end sidebar 2 --></div>

<article class="contentLft">
<div class="dotLine">&nbsp;</div>
<h1>Become a Host Family</h1>
<div class="dotLine">&nbsp;</div>
<script>
$(document).ready(function($){
    var deviceAgent = navigator.userAgent.toLowerCase();
    var agentID = deviceAgent.match(/(iphone|ipod|ipad)/);
    if (agentID) {
        $('#myLink').attr('href', 'http://youtu.be/U9D4yQms9Bs');
    }else
     { 
         $('#myLink').attr('href', 'https://youtube.googleapis.com/v/U9D4yQms9Bs');
     }
});</script>
<div style="float: right; margin: 10px;"><a id="myLink" href="" target="_blank"><img src="images/be-Host-family-video.png" width="200" height="150" alt="Be a Host Family" class="asideBrd" /></a></div>
<p>Hosting a foreign exchange student means opening your home and your heart to a teen from another country while they attend your local public high school.</p>
<p>ISE has many different hosting programs available.  Opportunities are available for periods of 5 months, 10 months or a full 12 month program, with the most common being the 10 month academic year program.</p>
<p>Exchange Students who participate in the program have been carefully screened before their acceptance. Participants are selected based on their academic achievements and their extracurricular interests. Interviewers identify individuals who demonstrate a curious, optimistic view on the challenges and adventures lying before them. Accepted students are responsible, outgoing and possess an adaptable nature. ISE partners are looking for "great kids" with positive attitudes and interests which have something special to offer a Host Family during their hosting experience.</p>


<div class="blueLine">&nbsp;</div><br />
<h2>Hosting Impacts You and Your Community!</h2>
<p><strong>In Your family -</strong> You will learn more about different culture views and how they impact life in the U.S. by exchanging ideas with your exchange student.  An exposure to different cultures will grow a deeper appreciation for what your family has and for the tremendous challenges facing other nations.</p>
<p><strong>In Schools –</strong> Classes will come alive with native accents, colloquialisms and contextual usage. Exchange students can clearly show how language and culture are intertwined.  Your exchange student will add new dimensions to the activities of your schools' international clubs and organizations.</p>
<p><strong>In Your Town -</strong> Worldwide events will take on a new significance when exchange students are in your community and ready to share their perspectives and experiences.  Students also participate in community service.<br><br>To have someone from ISE contact you about hosting, please fill out our <a href="ready-host-student.cfm"><font color="#3366FF">contact form</font></a>.</p><br />

<div class="blueLine">&nbsp;</div><br />

<div style="background-color: #FFC; padding: 20px; font-style: italic; width: 85%; margin: 5px 20px 5px 20px;">
	<p><?php echo $quotes[$ranNum]; ?></p>
</div>

 <div class="dotLine">&nbsp;</div>
   <div class="blueBtn"><img src="images/img-buttons/faqBtn-test.png" width="31" height="30" alt="ISE Student Trips" /><a href="host-family-faq.cfm" class="whiteLink">&nbsp;Questions</a></div>
       <div class="redBtn"><a href="host-family-resources.cfm" class="whiteLink"><img src="images/img-buttons/redBtn-test.png" width="31" height="30" alt="ISE Testimonial" /> &nbsp;Resources</a></div>
   <div class="clearfloat">&nbsp;</div>
</article>
 <?php include '_footer.php'; ?>
  <!-- end .container --></div>
</body>
</html>