<cfif get_student.intrepemail NEQ ''>
	
    <cfoutput>
    <cfsavecontent variable="email_message">
        #DateFormat(now(), 'dddd, mmmm dd, yyyy')#<br><br>
                            
        Dear #get_student.businessname#,<br><br>
        
        Please accept this notice as verification that the <cfif get_student.randid EQ 0>paper<cfelse>online</cfif>
        application for #get_student.firstname# #get_student.familylastname# (###get_student.studentid#) has been received in the Babylon offices of #client.companyname#. <br><br>
        
        Our admissions staff will be reviewing the application for acceptance into the #get_student.app_program# program as quickly
        as possible. <br><br>
        
        Please understand that this notice is only to verify that the application has been received in the offices
        and will be reviewed for acceptance as soon as possible. A request for further information and/or an acceptance letter
        will be issued upon the completion of our admissions team's review of the application.<br><br> 
        
        This notice should not be interpreted as verification that the student has been accepted into the program and only confirms
        that the application <cfif get_student.randid EQ 0>has arrived<cfelse>has been received</cfif> and is pending review for acceptance into the program.<br><br>
        
        Please note, if you use EXITS to manage your online applications, this application will now show under your current applications in received status.<br><br>
        
        Sincerely, <br><br>
        
        #client.companyname#<br><br>
    </cfsavecontent>
	</cfoutput>
    		
	<!--- send email --->
    <cfinvoke component="nsmg.cfc.email" method="send_mail">
        <cfinvokeargument name="email_to" value="#get_student.intrepemail#">
        <cfinvokeargument name="email_subject" value="Application Received - #get_student.firstname# #get_student.familylastname# (###get_student.studentid#)">
        <cfinvokeargument name="email_message" value="#email_message#">
        <cfinvokeargument name="email_from" value="#client.companyshort#">
    </cfinvoke>
	
</cfif>
