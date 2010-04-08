

<cfform action="?curdoc=querys/insert_school_questions" method="post">
<div class="application_section_header">School Information</div>
<div class=row1>

Transportation to school:<br>
<cfinput type="radio" name="transportation" value="School Bus">School Bus <cfinput type="radio" name="transportation" value="Car">Car <cfinput type="radio" name="transportation" value="Public Transportation">Public Transportation<br>
 <cfinput type="radio" name="transportation" value="Walk">Walk <cfinput type="radio" name="transportation" value="Other">Other: <cfinput type="text" name="other_desc" size=10>

<span class=spacer></span>
</div>
<div class="row">
Special programs, unique features or electives available to foreign students:<br>
<textarea cols="50" rows="4" name="special_programs" wrap="VIRTUAL"></textarea><br>




<br>
<span class=spacer></span>
</div>
<div class="button"><input type="submit" value="    next    "></div>
</cfform>