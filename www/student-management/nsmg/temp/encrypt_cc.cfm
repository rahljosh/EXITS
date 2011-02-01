<cfquery name="clear_cc" datasource="mysql">
update student_tours
set cc = ''
where paid <> ''
</cfquery>
<!----
<Cfquery name="encryptcc" datasource="mysql">
select cc, studentid
from student_tours
where studentid = 23252
</cfquery>
---->
<Cfset cc = ''>
<cfoutput>
#cc# :: <cfset EncrpytedCC = encrypt(cc, 'BB9ztVL+zrYqeWEq1UALSj4pkc4vZLyR', "desede", "hex")> #encrpytedcc#<Br />
</cfoutput>
<!----
<Cfquery name="updatecc" datasource="mysql">
update student_tours
set cc = '#encrpytedcc#'
where studentid = #studentid#
</cfquery>
---->

<!---- 
</Cfloop>
 
</cfoutput>
---->