<br><br>
<cfif client.companyid eq 11>
<div align="center">

<img src="pics/wep-footer.jpg" height=20  />

</div>
<cfelse>
<cfoutput>
<img src="pics/logos/#client.companyid#_px.png" width="100%" height="12">

<div align="center">



#client.companyname# :: Powered by <font face="Arial"><a href="http://www.exitgroup.org/" target="_blank"><font color="black">E</font><font color="orange"><strong>X</strong></font><font color="black">ITS</font></a> - AWS</font><br /></div>
<img src="pics/logos/#client.companyid#_px.png" width="100%" height="1">
</cfoutput>
</cfif>

<!----
<script src="https://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-880717-1";
urchinTracker();
</script>
---->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-880717-1");
pageTracker._initData();
pageTracker._trackPageview();
</script>
</body>
</html>
