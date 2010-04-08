<cfset pic = 0>
<cfset newup = 0>

<link rel="stylesheet" href="forms.css" type="text/css">


<cfform method="post" action="../querys/upload_host_pics.cfm" enctype="multipart/form-data">
Family Pictures
<div class=row>
If possible, please upload at least two recent family snapshots, including one in the front of your home. Children’s school
pictures are fine.
</div>
<div class=row1>
Pictures must be JPG format.<br>
<cfform method="post" action="../querys/upload_host_pics.cfm" enctype="multipart/form-data">
Picture 1: <cfif form.picture1 is ''>  No picture Specified.<cfelseif form.picture1 is not ''><CFFILE ACTION="Upload" FILEFIELD="picture1" DESTINATION="d:\web\newsmg\hostpics\" NAMECONFLICT="MAKEUNIQUE"><CFIF File.ServerFileExt is not 'jpg'><cffile action="DELETE" file="d:\web\newsmg\hostpics\#file.serverfile#"><INPUT NAME="picture1" TYPE="file" SIZE = 25><font color="red"><b><cfoutput>#file.serverfile#</cfoutput>, is not a jpg file, select another.<cfset newup=1></b></font><cfelse><cfoutput><Cfset pic = pic +1><cffile action="RENAME" source="d:\web\newsmg\hostpics\#file.serverfile#" destination="d:\web\newsmg\hostpics\#client.hostid#_#pic#.jpg"> <font color="green">Upload successful!</font></cfoutput></cfif></cfif><br>
Picture 2: <cfif form.picture2 is ''>  No picture Specified.<cfelseif form.picture2 is not ''><CFFILE ACTION="Upload" FILEFIELD="picture2" DESTINATION="d:\web\newsmg\hostpics\" NAMECONFLICT="MAKEUNIQUE"><CFIF File.ServerFileExt is not 'jpg'><cffile action="DELETE" file="d:\web\newsmg\hostpics\#file.serverfile#"><INPUT NAME="picture2" TYPE="file" SIZE = 25><font color="red"><b><cfoutput>#file.serverfile#</cfoutput>, is not a jpg file, select another.<cfset newup=1></b></font><cfelse><cfoutput><Cfset pic = pic +1><cffile action="RENAME" source="d:\web\newsmg\hostpics\#file.serverfile#" destination="d:\web\newsmg\hostpics\#client.hostid#_#pic#.jpg"><font color="green">Upload successful!</font></cfoutput></cfif></cfif><br>
Picture 3: <cfif form.picture3 is ''>  No picture Specified.<cfelseif form.picture3 is not ''><CFFILE ACTION="Upload" FILEFIELD="picture3" DESTINATION="d:\web\newsmg\hostpics\" NAMECONFLICT="MAKEUNIQUE"><CFIF File.ServerFileExt is not 'jpg'><cffile action="DELETE" file="d:\web\newsmg\hostpics\#file.serverfile#"><INPUT NAME="picture3" TYPE="file" SIZE = 25><font color="red"><b><cfoutput>#file.serverfile#</cfoutput>, is not a jpg file, select another.<cfset newup=1></b></font><cfelse><cfoutput><Cfset pic = pic +1><cffile action="RENAME" source="d:\web\newsmg\hostpics\#file.serverfile#" destination="d:\web\newsmg\hostpics\#client.hostid#_#pic#.jpg"><font color="green">Upload successful!</font></cfoutput></cfif></cfif><br>
Picture 4: <cfif form.picture4 is ''>  No picture Specified.<cfelseif form.picture4 is not ''><CFFILE ACTION="Upload" FILEFIELD="picture4" DESTINATION="d:\web\newsmg\hostpics\" NAMECONFLICT="MAKEUNIQUE"><CFIF File.ServerFileExt is not 'jpg'><cffile action="DELETE" file="d:\web\newsmg\hostpics\#file.serverfile#"><INPUT NAME="picture4" TYPE="file" SIZE = 25><font color="red"><b><cfoutput>#file.serverfile#</cfoutput>, is not a jpg file, select another.<cfset newup=1></b></font><cfelse><cfoutput><Cfset pic = pic +1><cffile action="RENAME" source="d:\web\newsmg\hostpics\#file.serverfile#" destination="d:\web\newsmg\hostpics\#client.hostid#_#pic#.jpg"><font color="green">Upload successful!</font></cfoutput></cfif></cfif><br>
<cfif newup is 1><div class="button"><input type="submit" value="Upload Picture(s)">
<i>Click only once, will take a few momments for picture(s) to upload.</i></div></cfif></cfform>
</cfform>
</div>

<CFQUERY name="selectdb" datasource="caseusa">
USE smg
</CFQUERY>
<cfquery name="piccount" datasource="caseusa">
Update smg_hosts
set pictures = #pic#
where hostid = #client.hostid#
</cfquery>

<cfquery name="get_pic" datasource="caseusa">
select pictures from
smg_hosts 
where hostid = #client.hostid#
</cfquery>


<table>
	<tr>
<cfloop index="x" from=1 to=#get_pic.pictures#>		

<cfoutput query=get_pic><td><cfoutput><img width=100 height=133 src="../hostpics/#client.hostid#_#x#.jpg"></cfoutput></td>
<cfif (x MOD 2 ) is 0></tr><tr></cfif>
</cfoutput>
</cfloop>
</table>

</table>

<cfform method="post" action="?curdoc=forms/family_app_13">
<div class="button"><input type="submit" value="Next"></div>
</cfform>
<br>




</body>
</html>
