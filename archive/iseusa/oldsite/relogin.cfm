<cf_header>

<div class="page-title">Login</div>
<br>
<form action="internal/loginapply2.cfm" method="post">
<TABLE align="center">
	<TR>
		<TD align="center">
			</td>
	</tr>
	<tr>
		<td align="center">user: <cfoutput><input type="text" name="loginname"size=10 value="#url.username#"></cfoutput></td>
	</tr>
	<tr>
		<td align="center">pass: <input type="password" name="password" size=11></td>
	<tr>
	<td align="center"><input type="submit" value="submit"></td>
	</tr>
	<tr>
		<td align="center"><div align="center"><A href="pass_request.cfm">Forgot your password?</a></td>
	</tR>
</table>
</form>
<cf_footer>
