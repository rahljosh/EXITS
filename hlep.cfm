		
			  <script>
			var rm = escape(window.document.referrer.replace("&","*"));
			var pm = window.document.URL.replace("&","*");
			var sm = 'https://srv0.velaro.com/visitor/monitor.aspx?siteid=2837&autorefresh=yes&origin=';
			sm=sm+rm+'&pa='+pm+'"></scr'+'ipt>';
			document.write('<script src="'+sm);
			</script> 
			
			<cfoutput>
			<table cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td align="center">
                    <a href="https://srv0.velaro.com/visitor/requestchat.aspx?siteid=2837&showwhen=inqueue&forcename=#session.name#&email=#session.email#&id=#session.userid#" target="VelaroChat"  onClick="this.newWindow = window.open('https://srv0.velaro.com/visitor/requestchat.aspx?siteid=2837&showwhen=inqueue&forcename=#session.name#&email=#session.email#&id=#session.userid#, 'VelaroChat', 'toolbar=no,location=no,directories=no,menubar=no,status=no,scrollbars=no,resizable=yes,replace=no');this.newWindow.focus();this.newWindow.opener=window;return false;">
                        <img alt="SMG Live Help Available" src="https://srv0.velaro.com/visitor/check.aspx?siteid=2837&showwhen=inqueue&forcename=#session.name#&email=#session.email#&id=#session.userid#" border="0">
                    </a>
                    </td>
                </tr>
            </table>