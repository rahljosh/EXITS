<?php /* Smarty version 2.5.0, created on 2007-01-18 16:10:10
         compiled from search/rpc/builder/ticket_status.tpl.php */ ?>
<input type="hidden" name="cmd" value="<?php echo $this->_tpl_vars['cmd']; ?>
">
<input type="hidden" name="criteria" value="<?php echo $this->_tpl_vars['criteria']; ?>
">
<label><input name="crit_status" type="radio" value="0" checked>Any Status</label><br>
<label><input name="crit_status" type="radio" value="1">Any Active Status</label><br>
<label><input name="crit_status" type="radio" value="2">Open</label><br>
<label><input name="crit_status" type="radio" value="3">Closed</label><br>
<label><input name="crit_status" type="radio" value="4">Deleted</label><br>
<div align="right"><input type="button" value="Add &gt;&gt;" onclick="doSearchCriteriaSet('<?php echo $this->_tpl_vars['label']; ?>
');"></div>