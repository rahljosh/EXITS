<div class="sidebar2">
  <div class="email">
  <cfform action="email_submit.cfm?request=send" method="post" name="form" id="form">
    <table width="160" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td width="84"><img src="images/email_icon.png" width="34" height="40" alt="Email icon" /></td>
        <td width="260">Join our e-mail list and receive info on new schools.</td>
      </tr>
     <tr>
    <td height="31" colspan="2" align="left" valign="middle">
      <label for="textfield"></label>
      <cfinput name="email" type="text"  message="Ooops!! Looks like you didn't enter a valid email address." validateat="onSubmit" validate="email" required="yes" id="email" typeahead="no" showautosuggestloadingicon="true" size="12" placeholder="user@domain.com"/>
      <input name="Submit" type="image" value="send" src="images/send.png" align="top">
    </td>
    </tr>
    </table>
    </cfform>
  <!-- end .email--></div>
  <div  align="center"><a href="http://www.esecutive.com/index.php" target="_blank"><img src="images/student_Insurance.png" width="150" height="41" alt="Student Insurance Information" border="0" /></a></div>
  
  <!-- end .sidebar2 --></div>