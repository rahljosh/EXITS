		<!--- Page Header --->
    <gui:pageHeader
        headerType="applicationNoHeader"
        filePath="../"
    />	
    	<!--- Table Header --->
        <gui:tableHeader
			tableTitle="Offline Background Checks"			
            width="90%"
            filePath="../"
        />    
      <cfinclude template="../querys/family_info.cfm">
    <h2>
        	&nbsp;&nbsp;&nbsp;&nbsp;O f f l i n e &nbsp;&nbsp;&nbsp; B a c k g r o u n d &nbsp;&nbsp;&nbsp; C h e c k s
            <font size=-2>[<a href="">overview</a>]</font>
      	</h2>
    <cfoutput>
        <form>
          <table width="90%" border="1" align="center" cellpadding="8" cellspacing="8" bordercolor="##C7CFDC" bgcolor="##FFFFFF" class="section">
            <tr>
            	<td width="80%" class="box">
                      <table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##ffffff">
                        <tr bgcolor="##FFFFCC">
                            <td><u>Date Authorized</u></td>
                            <td><u>Date Submitted</u></td>
                            <td><u>Date Expires</u></td>
                            <td><u>Date Approved</u></td>
                            <td><u>Notes</u></td>
                        </tr>
                        <tr>
                           <td><input type="text" class="datePicker" value="" name="dateAuthorized" /></td>
                            <td><input type="text" class="datePicker" value="" name="dateSubmitted" /></td>
                            <td><input type="text" class="datePicker" value="" name="dateExpires" /></td>
                            <td><input type="text" class="datePicker" value="" name="dateApproved" /></td>
                            <td><textarea name="notes"></textarea></td>
                        </tr>
                    </table>
                 </td>
            </tr>
            <tr>
            	<td align="center"><input type="submit" value="Submit Offline CBC"></td> 
            </tr>
            </table>
            
            </form>
     </cfoutput>