<cfform method="post" action="../querys/insert_student_letter.cfm">
<div class="application_section_header">Student Letter of Introduction</div><font size=-1><span class="edit_link">[ <a href="">overview</a> ]</span></font><br><br>
<cfinclude template="../student_app_menu.cfm">
<cfinclude template="../querys/get_student_info.cfm">
In your own words write a letter which will tell about your personal interests. Your letter should be typed in English. Feel free to continue onto another page. Some suggestions for what to include follow. 
<ul>
<li> Describe yourself. Tell about any extra special accomplishments or awards. (Are you an expert soccer player, musician, computer whiz?) 
<li> Tell your future host family about your hopes and expectations for your stay in the USA. 
<li> Describe a typical school day and weekend and how you spend your time with friends away from school.
<li> Describe a particular experience in your life which seems important to you. 
<li>Introduce members of your family and say a few words about them. Describe the responsibilities you have at home and how you feel about them. Discuss what you expect to gain for yourself, your family, and your country. 
<li> Describe how you will share your culture with your host family. Describe how and why you think your host community and family will benefit by welcoming YOU as an exchange student.
<div class=row>
</div>
<div row1>
<textarea cols="58" rows="25" name="letter" wrap="VIRTUAL"><cfoutput query="get_Student_info">#letter#</cfoutput></textarea>
</div>
<div class="button"><input type="submit" value="    Next    "></div>
</cfform>
