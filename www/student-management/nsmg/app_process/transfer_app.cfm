<cfquery name="student_info" datasource="#application.dsn#">
select firstname, familylastname, studentid
from smg_students
where studentid = #url.studentid#
</cfquery>
<cfoutput>
<table>
	<Tr>
    	<td>
Currently, there is only one company, CASE, using the EXITS network that accepts applcations from other companies.<Br><br></td>
	</Tr>
    <Tr>
    	<td>
Please verify that you would like to transfer <strong>#student_info.firstname# #student_info.familylastname# (#student_info.studentid#)</strong>.<br><Br> An email will be sent to the international rep informing them that the applciation has been transfered to CASE.  The application will not show as approved unti CASE approves the applicatioin.  Once this application has been transfered to CASE, SMG will no longer be able to see the application.</td>
	</Tr>
    <Tr>
    
    	<td align="Center">
        <form action="app_process/finalize_transfer.cfm" method="post">
        <input type="checkbox" name="approve" value=#url.studentid#>Yes, please transfer this applciation.<Br><INPUT type="image" name="submit" src="student_app/pics/transfer_03.png" alt="Transfer Application" border="0" align="top"></form></td>
    </Tr>
</table>
</cfoutput>
<br><br>
