<link rel="stylesheet" href="../linked/css/buttons.css" type="text/css">
<table cellpadding=10 align="center">
    <tr>
  
    <td valign="center" align="left">
      <cfif isDefined('form.updateDesc')>
        		<font color="##066e26">Information has been updated!</font>
      <cfelse>
    Made any changes?<br>  Click Update!
       </cfif>
        
     
        <td align="right">
      
                  <input type="hidden" name="updateDesc" />
        	
            <input name="update" type="submit" value="Update"  alt="Update Application" border="0" class="buttonBlue" />
            </form>
           
            </td>
        </td>
        
       
    </tr>
    
</table>
