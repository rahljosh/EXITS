

<cfftp action="open" server="10.1.1.101" stoponerror="yes"  passive="yes" username="uploadstupicture" password="smg123" connection="RemoteSite" >


<cfftp action="putfile"  connection="RemoteSite" localfile="#form.stu_picture#" remotefile="#client.studentid#.jpg">
<cfoutput>
#cfftp.errorcode#
FTP Opperation Return Value: #cfftp.ReturnValue#<br>
FTP Opperation Successful: #cfftp.succeeded#<br>


</Cfoutput> 

<cfftp action="close" connection="RemoteSite" stoponerror="yes">

<A Href="?curdoc=forms/student_app_8">Back to Upload</A> :: <A Href="?curdoc=student_info">Back to Student Overview</A>
