 <form method="post" action="index.cfm?page=hello">
 <input type="hidden" name="processLogin" />
 	<cfif client.hostid eq -2>
    <div align="center">
    	<font color="##CC0000">The email and password you submitted do not match an account on file.<br />  Please check your information and try again.</font>
    </div>
    </cfif>
     <p align="center">Please login to access your application<br /><br />
     <table align="center">
        <tr>
            <td>Email</td><td><input type="text" name="username" size=20 /></td>
        </tr>
        <tr>
            <td>Password</td><td><input type="password" name="password" size=20 /></p></td>
        </tr>
    	<tr>
        	<td colspan=2><input type="submit" value="Login" /></td>
        </tr>
    </table>
    
  </form>
    </p> 