<?php /* Smarty version 2.5.0, created on 2007-01-15 22:07:38
         compiled from search/rpc/builder/ticket_waiting.tpl.php */ ?>
<input type="hidden" name="cmd" value="<?php echo $this->_tpl_vars['cmd']; ?>
">
<input type="hidden" name="criteria" value="<?php echo $this->_tpl_vars['criteria']; ?>
">
<label><input name="crit_waiting" type="radio" value="1" checked>Yes</label><br>
<label><input name="crit_waiting" type="radio" value="0">No</label><br>
<div align="right"><input type="button" value="Add &gt;&gt;" onclick="doSearchCriteriaSet('<?php echo $this->_tpl_vars['label']; ?>
');"></div>