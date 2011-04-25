
            <cfdocument format="PDF" filename="#AppPath.temp#permissionForm_#client.studentid#.pdf" overwrite="yes">
			<style type="text/css">
            <!--
        	<cfinclude template="../smg.css">            
            -->
            </style>
			<!--- form.pr_id and form.report_mode are required for the progress report in print mode.
			form.pdf is used to not display the logo which isn't working on the PDF. --->
            <cfset form.report_mode = 'print'>
            <cfset form.pdf = 1>
            <cfinclude template="tripPermission.cfm">
        </cfdocument>
                
        <cfsavecontent variable="email_message">
        <cfoutput>				
            <p>Your account information has been verified. </p>
            <p>Attached is a permission form and Terms & Conditions that needs to be signed by:<Br />
            <ul>
            <li>You</li>
            <li>Host Family</li>
            <li>Area Rep</li>
            <li>Regional Manager</li>
            <li>School </li>
            </ul>
           This form needs to be sent to <a href="mailto:info@mpdtoursamerica.com">info@mpdtoursamerica.com</a> at least 30 days prior to the departure date of your trip, or the earliest departure date if you have signed up for multiple trip.  
            </p>
        </cfoutput>
        </cfsavecontent>
        
        <cfinvoke component="nsmg.cfc.email" method="send_mail">
            <cfinvokeargument name="email_to" value="josh@pokytrails.com">
            <cfinvokeargument name="email_replyto" value="#client.email#">
            <cfinvokeargument name="email_subject" value="Trips Information">
            <cfinvokeargument name="email_message" value="#email_message#">
            <cfinvokeargument name="email_file" value="#AppPath.temp#permissionForm_#client.studentid#.pdf">
             
        </cfinvoke>	


