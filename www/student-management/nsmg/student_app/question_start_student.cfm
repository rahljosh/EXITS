<script src="linked/js/jquery.colorbox.js"></script>
<script>
        $(document).ready(function(){
            //Examples of how to assign the ColorBox event to elements
            
            $(".iframe").colorbox({width:"700px", height:"640px", iframe:true, 
            
               onClosed:function(){ location.reload(true); } });

        });
    </script>
<table width=100% cellpadding=0 cellspacing=0 border=0 height=24>
	<tr valign=middle height=24>
		<td height=24 width=13 background="pics/header_leftcap.gif">&nbsp;</td>
		<td width=26 background="pics/header_background.gif"><img src="pics/news.gif"></td>
		<td background="pics/header_background.gif"><h2>Start Application </td><td background="pics/header_background.gif" width=16></td>
		<td width=17 background="pics/header_rightcap.gif">&nbsp;</td>
	</tr>
</table>
<cfif ListFind('6579,126,48,6439,16276,6381,13405,12725,8328,127,132,558,130,16194,658612002,14664,8,20937,48,16517,15465',client.userid)>
<Table  width=100% cellpadding=4 cellspacing=0 border=0  class="section">
	<Tr>
    	<td><img src="pics/exits-nexits.jpg" height=60%/></td>
        
        <Td valign="center"><h1>Don't worry, this is not an error.</h1>
            <p>Your account has been transferred to our new enrollment system.</p>
            <p>Please click <A href="http://nexits.org">here</A> to login and register new students.  Use your email to login to the system.</p>
            <a href="http://nexits.org">http://nexits.org</a>
            
		</Td>
</Table>
<cfelse>					
    <table width=100% cellpadding=4 cellspacing=0 border=0 class="section"> 
        <tr>
            <td style="line-height:20px;" valign="top" width="100%">
            <table width=100% valign="top">			
                <tr>
                    <td colspan=2>
                        Please select which option applies to this application...<br><br>
                    </td>
                </tr>
                <tr>
                    <Td valing="top" width=49%>	
                        <div align="justify">
                            <h2>Option 1</h2> Students will fill out their own application. You will fill out some basic information and they will
                            recieve an email with instructions on submitting their application. <br>
                            <font size=-1><em>Students must have an email account and internet access to fill out the application</em></font><br><br><div align="center"> <a href="student_app/start_student.cfm?option=1" class='iframe'><img src="student_app/pics/start-application.gif" border=0></a> 
                        </div>
                    </td>
                    <td width="2%">&nbsp;</td>
                    <td valign="top" width="49%">
                        <div align="justify">
                            <h2>Option 2</h2> If you have a hard copy of an application that you would like to submit to SMG, 
                            follow this link to submit an online application for a student.  
                            The same information that is mandatory for students to fill out, is also mandatory for applications that you fill out for them.<br><br><div align="center"><a href="student_app/start_student.cfm?option=2&r=y" class='iframe'><img src="student_app/pics/start-application.gif" border=0></a>
                        </div>
                    </td>
                </tr>
            </table>
            
            
    </td>
        <td align="right" valign="top" rowspan=2>
    
        </tr>
        
    </table>
</cfif>
	<!----footer of table---->
			<table width=100% cellpadding=0 cellspacing=0 border=0>
				<tr valign=bottom >
					<td width=9 valign="top" height=12><img src="pics/footer_leftcap.gif" ></td>
					<td width=100% background="pics/header_background_footer.gif"></td>
					<td width=9 valign="top"><img src="pics/footer_rightcap.gif"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>