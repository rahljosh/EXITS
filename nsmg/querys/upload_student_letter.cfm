
<cfftp action="open" username="uploadletter" password="smg123" server="10.1.1.101" connection="RemoteSite" stoponerror="yes">

<cfftp action="putfile" stoponerror="yes"connection="RemoteSite" localfile="#form.stu_letter#" remotefile="#client.studentid#.pdf">

<Cfoutput>
FTP Opperation Return Value: #cfftp.ReturnValue#<br>
FTP Opperation Successful: #cfftp.succeeded#<br>

</Cfoutput>

<cfftp action="close" connection="RemoteSite" stoponerror="yes">

<A Href="?curdoc=forms/student_app_8">Back to Upload</A> :: <A Href="?curdoc=student_info">Back to Student Overview</A>