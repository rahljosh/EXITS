<?php /* Smarty version 2.5.0, created on 2007-01-15 11:11:28
         compiled from home.tpl.php */ ?>
<?php $this->_load_plugins(array(
array('modifier', 'escape', 'home.tpl.php', 92, false),
array('modifier', 'cat', 'home.tpl.php', 93, false),
array('modifier', 'cer_href', 'home.tpl.php', 93, false),
array('modifier', 'htmlentities', 'home.tpl.php', 146, false),)); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><?php echo @constant('LANG_HTML_TITLE'); ?>
</title>
<META HTTP-EQUIV="content-type" CONTENT="<?php echo @constant('LANG_CHARSET'); ?>
">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
<META HTTP-EQUIV="Pragma-directive" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Directive" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("cerberus.css.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<link rel="stylesheet" href="includes/cerberus_2006.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="skins/fresh/cerberus-theme.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css">
<link rel="stylesheet" href="includes/css/container.css?v=<?php echo @constant('GUI_BUILD'); ?>
" type="text/css"> 

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("keyboard_shortcuts_jscript.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<script type="text/javascript" src="includes/scripts/yahoo/YAHOO.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/event.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/connection.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dom.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/animation.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/autocomplete.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/dragdrop.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/yahoo/container.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>

<script type="text/javascript" src="includes/scripts/cerb3/dashboard.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/quickworkflow.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/searchbuilder.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/ticket.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
<script type="text/javascript" src="includes/scripts/cerb3/knowledgebase.js?v=<?php echo @constant('GUI_BUILD'); ?>
" ></script>
</head>

<?php echo '
<script type="text/javascript">
	function savePageLayout() {
		// [JAS]: Force submit the form
		document.formSaveLayout.submit();
	}
	var refreshActive = true;
	var refreshMsec = '; ?>
<?php if ($this->_tpl_vars['selDashboard']->reload_mins): ?><?php echo $this->_tpl_vars['selDashboard']->reload_mins; ?>
<?php else: ?>0<?php endif; ?><?php echo ' * 60 * 1000;
	var oTimeout = null;
	
	function doRefresh() {
		'; ?>

		<?php if (isset ( $this->_tpl_vars['selDashboard'] ) && ! empty ( $this->_tpl_vars['selDashboard']->reload_mins )): ?>
		oTimeout = setTimeout('autoRefresh()', refreshMsec);
		<?php endif; ?>
		<?php echo '
	}
	function autoRefresh() {
		if(refreshActive) {
			document.location = \'index.php\';
		}
	}
	function toggleRefresh(state) {
		var l = document.getElementById(\'pauseLink\');
		if(null == l || null == refreshActive) return;

		var toState = (null==state) ? !refreshActive : state;

		if(!toState) { // turn off
			refreshActive = false;
			l.innerHTML = \'start \' + (refreshMsec/60/1000) + \'m refresh\';
			clearTimeout(oTimeout);
		} else { // turn on
			refreshActive = true;
			l.innerHTML = \'stop \' + (refreshMsec/60/1000) + \'m refresh\';
			oTimeout = setTimeout(\'autoRefresh()\', refreshMsec);
		}
	}
	YAHOO.util.Event.addListener(window,"load",doRefresh);
</script>
'; ?>


<body bgcolor="#FFFFFF" <?php if ($this->_tpl_vars['session']->vars['login_handler']->user_prefs->keyboard_shortcuts): ?>onkeypress="doShortcutsIE(window,event);"<?php endif; ?>>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("header.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

<br>
<form action="index.php" name="formSaveLayout" method="post" style="margin:0px;">
	<input type="hidden" name="sid" value="<?php echo $this->_tpl_vars['session_id']; ?>
">
	<input type="hidden" name="form_submit" value="save_layout">
	<input type="hidden" name="default_dashboard_id" value="<?php echo $this->_tpl_vars['selDashboard']->id; ?>
">
</form>

<form action="index.php" method="post" style="margin:0px;">
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td width="100%">
			<?php if ($this->_tpl_vars['selDashboard']): ?>
			<span class="text_title"><?php echo $this->_run_mod_handler('escape', true, $this->_tpl_vars['selDashboard']->title, 'htmlall'); ?>
</span>
			<a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "index.php?form_submit=add_view&dashid=", $this->_tpl_vars['selDashboard']->id)); ?>
" class="box_text" title="Add a new Ticket View">add view</a>
			| <a href="javascript:;" onclick="toggleDiv('divEditDashboard');" class="box_text" title="Customize Dashboard">customize</a>
			| <a href="<?php echo $this->_run_mod_handler('cer_href', true, $this->_run_mod_handler('cat', true, "index.php?form_submit=delete_dashboard&dashid=", $this->_tpl_vars['selDashboard']->id)); ?>
" class="box_text" title="Remove Dashboard" onclick="return confirm('Are you sure you want to delete this dashboard?');">remove</a>
			<?php else: ?>
			<span class="text_title">No Active Dashboard</span>
			<a href="javascript:;" onclick="toggleDiv('divCreateDashboard');" class="box_text" title="Create a new dashboard">add a dashboard</a>
			<?php endif; ?>
			| <a href="javascript:;" onclick="toggleRefresh(false);createTicket();" class="box_text">create new ticket</a>
			<?php if ($this->_tpl_vars['selDashboard'] && $this->_tpl_vars['selDashboard']->reload_mins): ?>
				| <a href="javascript:;" onclick="toggleRefresh();" class="box_text" id='pauseLink'>stop <?php echo $this->_tpl_vars['selDashboard']->reload_mins; ?>
m refresh</a>
			<?php endif; ?>
		</td>
		<td align="right" width="0%" nowrap="nowrap">
			Dashboard: 
			<select name="dashid" class="box_text" onchange="this.form.submit();">
				<option value="">- choose a dashboard -
				<?php if (count((array)$this->_tpl_vars['dashboards'])):
    foreach ((array)$this->_tpl_vars['dashboards'] as $this->_tpl_vars['dash']):
?>
					<?php if ($this->_tpl_vars['dash']->id): ?>
					<option value="<?php echo $this->_tpl_vars['dash']->id; ?>
" <?php if ($this->_tpl_vars['dash']->id == $this->_tpl_vars['selDashboard']->id): ?>selected<?php endif; ?>><?php echo $this->_tpl_vars['dash']->title; ?>
</option>
					<?php endif; ?>
				<?php endforeach; endif; ?>
			</select>
			<input type="submit" value="Switch" class="cer_button_face" />
			<a href="javascript:;" onclick="toggleDiv('divCreateDashboard');" class="box_text" title="Create a new dashboard">add dashboard</a>
		</td>
	</tr>
</table>
</form>

<div id="divCreateTicket"></div>

<div id="divCreateDashboard" style="display:none;">
	<form action="index.php" style="margin:0px;">
	<input type="hidden" name="form_submit" value="create_dashboard">
	<table class="table_purple" bgcolor="#F0F0FF">
		<tr>
			<td>
				<b>Dashboard Name:</b> <input type="text" name="newDashboardName" value="" size="50">
				<input type="submit" name="" value="Create"><input type="button" value="Cancel" onclick="toggleDiv('divCreateDashboard',0);">
			</td>
		</tr>
	</table>
	</form>
	<br>
</div>

<div id="divEditDashboard" style="display:none;">
	<form action="index.php" style="margin:0px;">
	<table class="table_purple" bgcolor="#F0F0FF">
		<tr>
			<td colspan="2">
				<input type="hidden" name="dashid" value="<?php echo $this->_tpl_vars['selDashboard']->id; ?>
">
				<input type="hidden" name="form_submit" value="edit_dashboard">
				<b>Dashboard Name:</b> <input type="text" name="dashboard_name" value="<?php echo $this->_run_mod_handler('htmlentities', true, $this->_tpl_vars['selDashboard']->title); ?>
" size="50"><br>
			</td>
		</tr>
		<tr>
			<td colspan='2'><i>On this dashboard...</i></td>
		</tr>
		<tr>
			<td valign="top">
				<b>Monitor these Teams:</b><br>
				<?php if (empty ( $this->_tpl_vars['acl']->teams )): ?>
					You are not a member of any teams.
				<?php endif; ?>
				<?php if (count((array)$this->_tpl_vars['teams'])):
    foreach ((array)$this->_tpl_vars['teams'] as $this->_tpl_vars['dash_teamId'] => $this->_tpl_vars['dash_team']):
?>
				<?php if ($this->_tpl_vars['acl']->teams[$this->_tpl_vars['dash_teamId']]): ?>
					<input type="hidden" name="dashboard_hide_teams[]" value="<?php echo $this->_tpl_vars['dash_teamId']; ?>
">
					<label><input type="checkbox" name="dashboard_teams[]" value="<?php echo $this->_tpl_vars['dash_teamId']; ?>
" <?php if ($this->_tpl_vars['selDashboard']->hide_teams[$this->_tpl_vars['dash_teamId']]): ?><?php else: ?>checked<?php endif; ?>><?php echo $this->_tpl_vars['dash_team']->name; ?>
</label><br>
				<?php endif; ?>
				<?php endforeach; endif; ?>
			</td>
			<td valign="top">
				<b>Monitor these Mailboxes:</b><br>
				<?php if (empty ( $this->_tpl_vars['acl']->queues )): ?>
					Your teams have no mailboxes configured.
				<?php endif; ?>
				<?php if (count((array)$this->_tpl_vars['queues'])):
    foreach ((array)$this->_tpl_vars['queues'] as $this->_tpl_vars['dash_queueId'] => $this->_tpl_vars['dash_queue']):
?>
				<?php if ($this->_tpl_vars['acl']->queues[$this->_tpl_vars['dash_queueId']]): ?>
					<input type="hidden" name="dashboard_hide_queues[]" value="<?php echo $this->_tpl_vars['dash_queueId']; ?>
">
					<label><input type="checkbox" name="dashboard_queues[]" value="<?php echo $this->_tpl_vars['dash_queueId']; ?>
" <?php if ($this->_tpl_vars['selDashboard']->hide_queues[$this->_tpl_vars['dash_queueId']]): ?><?php else: ?>checked<?php endif; ?>><?php echo $this->_tpl_vars['dash_queue']->queue_name; ?>
</label><br>
				<?php endif; ?>
				<?php endforeach; endif; ?>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2">
				<b>Auto refresh dashboard</b> every <input name="dashboard_reload" type="text" value="<?php echo $this->_tpl_vars['selDashboard']->reload_mins; ?>
" size="2" maxlength="3"> minute(s).
			</td>
		</tr>
		<tr>
			<td colspan="2"><input type="submit" value="Save Dashboard"><input type="button" value="Cancel" onclick="toggleDiv('divEditDashboard',0);"></td>
		</tr>
	</table>
	</form>
	<br>
</div>

<table width="100%" border="0" cellspacing="5" cellpadding="1">
  <tr> 
   <td valign="top" width="0%" nowrap> 
   	<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/dashboard/rpc/dashboard_loads.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
	</td>
    <td valign="top" width="100%">
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/dashboard/dashboard.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
		<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("home/whos_online_box.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
    </td>
  </tr>
</table>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include("footer.tpl.php", array());
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
<?php if ($this->_tpl_vars['run_cron'] === true): ?>
	<script type="text/javascript">
		YAHOO.util.Event.addListener(window,"load",runScheduledTasks);
	</script>
<?php endif; ?>
</body>
</html>