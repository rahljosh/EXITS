
<cfquery name="host_letter" datasource="MySQL">
select familyletter
from smg_hosts
where hostid = #client.hostid#
</cfquery>
<cfform method="post" action="querys/insert_family_letter.cfm">
<span class="application_section_header">Family Letter of Introduction</span>
<cfinclude template="../family_app_menu.cfm"><br><br>
<div class=row>
Your letter is THE most important part of this application. Along with photos of your family and your home, this letter will be your
personal explanation of you and your family and why you have decided to host an exchange student. We ask that you be brief yet
thorough with your introduction to your “extended” family. Please include all information that might be of importance to your newest
son or daughter and their parents, such as personalities, background, lifestyle and hobbies.
</div>
<div row1>
<textarea cols="50" rows="25" name="letter" wrap="VIRTUAL"><cfoutput>#host_letter.familyletter#</cfoutput></textarea>
</div>
<div class="button"><input type="submit" value="    Next    "></div>
</cfform>



