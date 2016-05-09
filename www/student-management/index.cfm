<!--- Relocate to Login Page if we are not at www.student-management.com --->
<cfif CGI.SERVER_PORT NEQ 443>
	<cflocation url="https://#cgi.HTTP_HOST#">
 </cfif>
<cfif CGI.HTTP_HOST NEQ 'www.student-management.com'>

	<!--- Redirect to Login Page --->
   <cflocation url="login.cfm" addtoken="no">

<cfelse>
<cfparam name="form.sendForm" default="0" type="integer" />
<cfparam name="form.name" default="0" type="string" />
<cfparam name="form.email" default="0" type="string" />
<cfparam name="form.subject" default="0" type="string" />
<cfparam name="form.message" default="0" type="string" />
<cfparam name="messageSent" default="0" type="integer" />

<cfif val(form.sendForm) >
	<cfmail to = "contact@student-management.com" from = "#form.email#" subject = "Website Contact - #form.subject#">
    		FROM: #form.name# - #form.email#
            
            MESSAGE:
            #form.message#
            
            --------------------------------------------------------------------
            Message sent from the website www.student-management.com
    </cfmail> 
    
	<cfset messageSent = 1 />
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Student Management Group - Travel and Study Creating</title>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" />
<link rel="stylesheet" href="css/accordion-slider.css" type="text/css" media="screen" />


<link href='http://fonts.googleapis.com/css?family=Rokkitt' rel='stylesheet' type='text/css'>
<link REL="shortcut icon" HREF="images/template/favicon.ico">

<!--[if IE 7]>
<link rel="stylesheet" href="css/ie7.css" type="text/css"/>
<![endif]-->


<!--  import jquery library //-->
<script type="text/javascript" src="js/jquery.min.js"></script>
<!-- imports site plugin -->
<script type="text/javascript" src="js/site.plugin.js"></script>
<!-- import Custom plugin configuration  //--> 
<script type="text/javascript" src="js/custom.js"></script>

<script type="text/javascript" src="js/jquery.validate.min.js"></script>

<!-- Enable Accorion Slider  //--> 
<script type="text/javascript">
	$(document).ready(function(){
		rizalAccordionSlider();
		
		$("#contact_form").validate();
	});
</script>


</head>


</head>
<body>

<div id="header-full" class="full">
	<div class="container">
		<div id="header">
			<div id="logo" class="fl">
				<h1><a href="#"><img src="images/template/logo.png" alt="Student Management Group" /></a></h1>
			</div>
			<div id="menu" class="fr">
				<ul id="main-nav">
					<li><a href="#about">About Us</a></li>
					<li><a href="#programs">Programs</a></li>
					<li class="last"><a href="#contact">Contact</a></li>
					
				</ul>
			</div>
		</div><!-- end of #header //-->
	</div>	
</div><!-- end of #header-full //-->

<div id="slider-container-full" class="full">
	<div class="container">
		<div id="home" class="page">
				<div id="slider" class="fl">
					<div id="accordion-slider-container">
						<ul id="accordion-slider">
							<li>
								<div>

									<img src="images/slides/MacDuffie_title.jpg" class="accordian-slider-logo" />
										
									<img src="images/slides/MacDuffie.jpg" alt="The MacDuffie School" title="The MacDuffie School" class="accordian-slider-image" onclick="window.open('MacDuffie.html','_self')"  />
									<p class="accordian-slider-caption">
										<span class="accordian-slider-captiontitle">
											<a href="MacDuffie.html">The MacDuffie School</a>
											</span>

											<a href="MacDuffie.html">MacDuffie is a small school with a rich liberal arts curriculum directed toward a diverse college-bound student body. Our students are a strong community of learners who are challenged to reach their full potential in and out of the classroom. MacDuffie also creates fertile ground for exploring artistic and athletic interests. Students develop the ability to communicate well, verbally and in writing, recognizing that genuine communication involves learning to question, analyze, and probe in the pursuit of understanding.</a>
									</p>
								</div>	
							</li>
							
							<li>
								<div>

									<img src="images/slides/PHP_title.jpg" class="accordian-slider-logo" />
								
									<img src="images/slides/PHP.jpg" alt="DMD - Private High School Program" title="DMD - Private High School Program" class="accordian-slider-image" onclick="window.open('DMD-PHP.html','_self')" />
									<p class="accordian-slider-caption">
										<span class="accordian-slider-captiontitle">
											<a href="DMD-PHP.html">DMD - Private High School Program</a>
											</span>

											<a href="DMD-PHP.html">The Private High School Program offers students, age 13 to 19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends. Our program strives to match students with the school that best fits their academic, social and extracurricular interests.</a>
								
									</p>
								</div>	
							</li>
							
							<li>
								<div>

									<img src="images/slides/ESI_title.jpg" class="accordian-slider-logo" />
									
									<img src="images/slides/ESI.jpg" alt="Exchange Service International" title="Exchange Service International" class="accordian-slider-image" onclick="window.open('Exchange_Service_International.html','_self')" />

									<p class="accordian-slider-caption">
										<span class="accordian-slider-captiontitle">
											<a href="Exchange_Service_International.html" >Exchange Service International</a>
											</span>

											<a href="Exchange_Service_International.html" >At ESI, we strive to increase cultural awareness by immersing our students in vibrant American communities with the freedom to choose the school in which they want to study. This attractive program allows students to share their lives with an American family and find the school that will best fit their needs academically, socially and geographically.</a>
									</p>
								</div>	
							</li>

							<li>
								<div>

									<img src="images/slides/SMG-Canada_title.jpg" class="accordian-slider-logo" />
									
									<img src="images/slides/SMG-Canada.jpg" alt="SMG Canada" title="SMG Canada"  class="accordian-slider-image" onclick="window.open('SMG-Canada.html','_self')" />
									<p class="accordian-slider-caption">
										<span class="accordian-slider-captiontitle">
											<a href="SMG-Canada.html" >SMG Canada</a>
											</span>

											<a href="SMG-Canada.html" >The Academic Year Program in Canada offers students the opportunity to spend time studying and increasing their cultural knowledge in some of the most beautiful places in North America. Canada offers a safe, peaceful and friendly environment boasting an education system that ranks amongst the best in the world.</a>
									</p>
								</div>	
							</li>
							
						</ul>
					</div>
					
				</div>
				<div id="slider-shadow" class="fl"></div>
				
				
		</div><!-- end of #home //-->
	</div><!-- end of .container //-->		
</div><!-- end of #container //-->


<div class="content-seperator full"></div><!-- end of #slider-content-seperator //-->



<div class="container">

	<div id="welcome-message-container" class="fl">
		<h1 class="welcome-message">Travel and Study Creating Global Understanding</h1>
	</div>

	<div class="fix"></div>
	<a name="about"></a>
	<hr />

	<div  class="page about">
		<div class="title-page-container fl">
			<span class="title-bg-lf fl"></span>
			<div class="title-bg fl"><h2>About Us</h2></div>
			<span class="title-bg-rt fl"></span>
			
			
			<div id="social-icons-container" class="fr">
				<ul	id="social-icons">
					<li><a href="#"><img src="images/social/icon-facebook.png" alt="Facebook" /></a></li>
					<li><a href="#"><img src="images/social/icon-twitter.png" alt="Twitter" /></a></li>
					<li class="icon-last"><a href="#"><img src="images/social/icon-youtube.png" alt="Youtube" /></a></li>
				</ul>
			</div>

		</div><!-- end of .title-page-container //-->

		<div id="about-content" class="content fl">	
			
			<img src="images/smg-students.jpg" align="right" style="padding:5px; border:1px solid #999; background-color:#fff;-moz-box-shadow: 0 0 5px #888; -webkit-box-shadow: 0 0 5px#888; box-shadow: 0 0 5px #888; margin:10px 10px 5px 20px" />

			<p>Student Management Group (SMG) is an international consulting and operational organization with headquarters on Long Island in New York. It operates an outstanding High School in Canada Program as well as an exciting and comprehensive outbound program for American teens to travel abroad on either short or long term stays. SMG also assists in the development of strategies for F-1 programs such as the F-1 Public School program and the F-1 Private High School Program in the United States.</p>

			<p>SMG does extensive work with the development of operations and curriculum for private 6-8 boarding schools in the United States as well as replication of such schools in foreign countries. SMG has been asked to assist in marketing and program development in several countries including China, Vietnam and Brazil. "Working together we can make a difference", the mission of SMG, is more than a slogan with words; it is why we exist. We all know why we are involved in such a lofty and difficult mission. That is what makes us strive for perfection. The knowledge and perspective gained by all from the home stays, educational and foreign experiences affect everyone.</p>

			<p>SMG is managed by both educators and business people. We are very well aware that such programs and consultations require careful planning and organization as well as our care, love and attention. We know that we can make a difference in this world by working together for a common goal and mission. To love what we are doing and to be involved in such special programs make all the effort and dedication well worth it.</p>
			
		
		
		</div><!-- end of #about-content //-->

	<div class="fix"></div>	
	
	<a name="programs"></a>
	</div><!-- end of #about //-->




	<hr />




	<div  class="page services">
		
		<div class="title-page-container fl">
			<span class="title-bg-lf fl"></span>
			<div class="title-bg fl"><h2>Programs</h2></div>
			<span class="title-bg-rt fl"></span>
		</div><!-- end of .title-page-container //-->
		
		<div id="services-content" class="fl">
			
			
			<div class="fl columns one_half first">
				<h3>The MacDuffie School</h3>
				<a href="MacDuffie.html"><img src="images/logos/macduffie.png" style="float:left; margin: 0 15px 0 0" /></a>
				<p>MacDuffie is a small school with a rich liberal arts curriculum directed toward a diverse college-bound student body. Our students are a strong community of learners who are challenged to reach their full potential in and out of the classroom. MacDuffie also creates fertile ground for exploring artistic and athletic interests. </p>

				<p>
					<a class="button" title="Learn More" href="MacDuffie.html">
						<span class="left">
							<span class="middle">Read More</span>
							<span class="right">
							</span>
						</span>
					</a>
				</p>
			</div>
			
			<div class="fl columns one_half last">
				<h3>DMD - Private High School Program</h3>
				<a href="DMD-PHP.html"><img src="images/logos/dmd-php.png" style="float:left; margin: 0 15px 0 0" /></a>
				<p>The Private High School Program offers students, age 13 to 19 years old, the opportunity to study and live in the United States. Students are able to further their own education by attending a high level academic institution while at the same time interacting with American families and friends. Our program strives to match students with the school that best fits their academic, social and extracurricular interests.</p>

				<p>
					<a class="button" title="Learn More" href="DMD-PHP.html">
						<span class="left">
							<span class="middle">Read More</span>
							<span class="right">
							</span>
						</span>
					</a>
				</p>
			</div>
			
			<div class="fl columns one_half first">
				<h3>SMG Canada</h3>
				<a href="SMG-Canada.html"><img src="images/logos/smg-canada.png" style="float:left; margin: 0 15px 0 0" /></a>
				<p>The Academic Year Program in Canada offers students the opportunity to spend time studying and increasing their cultural knowledge in some of the most beautiful places in North America. Canada offers a safe, peaceful and friendly environment boasting and education system that ranks amongst the best in the world.</p>

				<p>
					<a class="button" title="Learn More" href="SMG-Canada.html">
						<span class="left">
							<span class="middle">Read More</span>
							<span class="right">
							</span>
						</span>
					</a>
				</p>
			</div>
			
			<div class="fl columns one_half last">
				<h3>Exchange Service International</h3>
				<a href="Exchange_Service_International.html"><img src="images/logos/esi.png" style="float:left; margin: 0 15px 0 0" /></a>
				<p>At ESI, we strive to increase cultural awareness by immersing our students in vibrant American communities with the freedom to choose the school in which they want to study. This attractive program allows students to share their lives with an American family and find the school that will best fit their needs academically, socially and geographically.</p>

				<p>
					<a class="button" title="Learn More" href="Exchange_Service_International.html">
						<span class="left">
							<span class="middle">Read More</span>
							<span class="right">
							</span>
						</span>
					</a>
				</p>
			</div>
			
			<!-- end of four columns //-->
			
			
				
		</div>
			
		<div class="fix"></div>	
		<a name="contact"></a>

	</div><!-- end of #services-content //-->
		




	<hr />
	<div  class="page contact">
			
		<div class="title-page-container fl">
			<span class="title-bg-lf fl"></span>
			<div class="title-bg fl"><h2>Contact Us</h2></div>
			<span class="title-bg-rt fl"></span>
		</div><!-- end of .title-page-container //-->
			
		<div class="contact-content fl">
				 
			<div class="fix"></div>
				 
			<div class="contact-content-lf fl">
				<h3>Questions? Comments?</h3>
				
				<p>Student Managements is happy to respond to any inquiries you may have. You may email us at <a href="mailto:contact@student-management.com">contact@student-management.com</a>. </p>
				<p>If you have questions regarding hosting, working as an area representative, or anything related to student exchange, we would be more than happy to answer your question!</p>

				<span class="bold-caps">Toll Free :</span>800-766-4656<br />
				<span class="bold-caps">Local :</span>631-893-4540 <br />
				<span class="bold-caps">Fax :</span>631-893-4550<br /><br />
				
				<h3>Mailing Address: </h3>
				<p>Student Management Group<br/>
				119 Cooper Street<br />
				Babylon, NY 11702</p> 
				
			</div>
				
				
			<div class="contact-content-rt fl">
            
            	<cfif val(messageSent) >
                	<div style="width:100%; border:1px solid #033; padding:10px; margin-bottom:10px; text-align:center; background-color:#A7BEAE; color:#033; font-weight:bold">
                    	Message Sent!
                    </div>
                </cfif>
					
				<form id="contact_form" name="contact_form" method="post" action="<cfoutput>#CGI.script_name#</cfoutput>#contact">		
                	<input type="hidden" name="sendForm" value="1" />				
					<p><label for="name">Name <span class="asterisk">*</span></label> 
						<input  class="textbox required" type="text" name="name" id="name" /></p>
					<p><label for="email">E-mail <span class="asterisk">*</span> </label> 
						<input  class="textbox required email" type="text" name="email" id="email" /></p>
					<p><label for="subject">Subject <span class="asterisk">*</span></label>
						<input  class="textbox required" type="text" name="subject" id="subject" /></p>
					<p><label for="message">Message <span class="asterisk">*</span></label>
						<textarea class="textarea required" name="message" id="message"></textarea></p>
					<p><input type="submit" name="submit" value="Send Message" id="submit" /> </p>
					<p id="message-outcome"></p>
				</form>
				
				<div class="fix"></div>
				
			</div>
				
			<div class="fix"></div>
		</div><!-- contact-content//-->
			
	<div class="fix"></div>	
	</div><!-- end of #contact //-->
		
	<div class="fix"></div>	
</div><!-- end of .container//-->



<div class="content-seperator full"></div><!-- end of #slider-content-seperator //-->

<div id="footer-full">
	<div id="footer" >
		<p>&copy; 2013. All Rights Reserved.</p>
	</div><!-- end of footer //-->
</div><!-- end of #footer-full //-->
	

<a href="#" class="scrollup">Scroll</a>

</body>
</html>
</cfif>