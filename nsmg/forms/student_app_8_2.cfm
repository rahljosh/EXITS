

<div class="application_section_header">Student Letter of Introduction</div><font size=-1><span class="edit_link">[ <a href="?curdoc=student_info">overview</a> ]</span></font><br><br>
<cfinclude template="../student_app_menu.cfm">
<cfinclude template="../querys/get_student_info.cfm">


<cfif #cgi.remote_addr# is '68.161.228.208'>
<cfform method="post" action="?curdoc=student_info">
Since you are located in the head office building, you do not need to enter the letter information, the letter will show up for this student when it is scanned. 
<br>
You have finished imputing this students app.   <br>
<div class="button"><input type="submit" value="    Next    "></div>
</cfform>
<cfelse> <br>


To upload a scanned letter, click browse.  Once you have selected the letter, click 'Upload'<br><br>
<cfform method="post" action="?curdoc=temp/ftp-try" enctype="multipart/form-data">
 <cfoutput>Location of scanned letter: <input type="file" name="stu_letter" size= "15"></cfoutput>
 <div align="center"><input type="submit" value="Upload Letter"></div></cfform>
<div class=row>
</div>
<div row1>
<cfform method="post" action="../querys/insert_student_letter.cfm">
<!----
<textarea cols="58" rows="25" name="letter" wrap="VIRTUAL"><cfoutput query="get_Student_info">#letter#</cfoutput></textarea>
---->
</div><br>
<br>

<div class="button"><input type="submit" value="    Next    "></div>
</cfform>
</cfif>

