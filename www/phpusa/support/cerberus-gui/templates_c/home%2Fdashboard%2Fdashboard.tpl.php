<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:31
         compiled from home/dashboard/dashboard.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'cer_href', 'home/dashboard/dashboard.tpl.php', 22, false),)); ?><script type="text/javascript">
//	YAHOO.util.Event.addListener(window,"load",getTeamWorkloads);
</script>

<?php if ($this->_tpl_vars['selDashboard']): ?>
<?php if (count((array)$this->_tpl_vars['selDashboard']->views)):
    foreach ((array)$this->_tpl_vars['selDashboard']->views as $this->_tpl_vars['viewId'] => $this->_tpl_vars['view']):
?>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("views/ticket_view.tpl.php", array('view' => $this->_tpl_vars['dashboardViews'][$this->_tpl_vars['viewId']]));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<br>
<?php endforeach; endif; ?>
<?php else: ?>
	<table cellpadding="3" cellspacing="0" border="0" width="100%" class="table_purple" bgcolor="#F0F0FF">
	<tr>
		<td>
		<span class="link_ticket">Welcome to Ticket Dashboards!</span><br>
		You do not have a dashboard selected.<br>
		<br>
		Dashboards allow you to create and save highly customizable lists of tickets.  You can load your 
		dashboards from the 'Dashboards' list to the top right of this box.  You can save your favorite 
		dashboard by selecting it and clicking the 'Save Page Layout' link at the top of this page.<br>
		<br>
		Would you like to create a default dashboard now?<br>
		<a href="<?php echo $this->_run_mod_handler('cer_href', true, "index.php?form_submit=default_dashboard"); ?>
">Yes!  Please create a default dashboard for me.</a><br>
		</td>
	</tr>
	</table>
	<br>
<?php endif; ?>