<?php /* Smarty version 2.5.0, created on 2007-01-18 15:53:40
         compiled from search/rpc/builder/ticket_created.tpl.php */ ?>
<input type="hidden" name="cmd" value="<?php echo $this->_tpl_vars['cmd']; ?>
">
<input type="hidden" name="criteria" value="<?php echo $this->_tpl_vars['criteria']; ?>
">
<table>
	<tr>
		<td>From:</td>
		<td><input type="text" name="from" value="" size="20"></td>
	</tr>
	<tr>
		<td>To:</td>
		<td><input type="text" name="to" value="" size="20"></td>
	</tr>
</table>
Dates can be entered relatively (e.g. "-1 day", "+1 week")<br>
or absolutely (e.g. "12/31/06 08:00:00")
<div align="right"><input type="button" value="Add &gt;&gt;" onclick="doSearchCriteriaSet('<?php echo $this->_tpl_vars['label']; ?>
');"></div>