<?php /* Smarty version 2.5.0, created on 2007-01-19 08:28:58
         compiled from home/getwork/monitor.tpl.php */ ?>
<script type="text/javascript">
	<?php echo '
	function cbGetMonitorEvents(e, obj) {
		getMonitorEvents();
		setTimeout("cbGetMonitorEvents()",15000);
	}
	'; ?>


	YAHOO.util.Event.addListener(window,"load",cbGetMonitorEvents);
</script>
<span class="text_title">Monitor</span><br />
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr><td bgcolor="#DDDDDD"><img src="includes/images/spacer.gif" alt="" width="1" height="1" /></td></tr></table>
<br />

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
	<form action="index.php" method="post">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="form_submit" value="getwork_items">
    <td width="100%" valign="top">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
		   <tr>
		     <td bgcolor="#3C96FC"><img alt="A scroll" src="includes/images/icone/16x16/scroll_view.gif" width="16" height="16" /><span class="text_title_white">Latest Activity</span><span class="text_heading"> &nbsp; </span> <a href="javascript:void(0);" onclick="getMonitorEvents();" class="link_box_edit">force refresh</a> | <a href="javascript:void(0);" onclick="clearMonitorEvents();" class="link_box_edit">clear</a></td>
		   </tr>
		</table>
	   <span id="monitorContent"></span><br>
	 </td>
    </form>
  </tr>
</table>