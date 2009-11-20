<?php /* Smarty version 2.5.0, created on 2007-01-18 15:53:32
         compiled from search/rpc/builder/ticket_mask.tpl.php */ ?>
<input type="hidden" name="cmd" value="<?php echo $this->_tpl_vars['cmd']; ?>
">
<input type="hidden" name="criteria" value="<?php echo $this->_tpl_vars['criteria']; ?>
">
<input type="text" name="crit_mask" value="" size="20" onkeydown="doSearchEnterKiller(this.form);"><br>
<span class="cer_footer_text">(you can search by partial ticket masks or full ticket IDs)</span>
<div align="right"><input type="button" value="Add &gt;&gt;" onclick="doSearchCriteriaSet('<?php echo $this->_tpl_vars['label']; ?>
');"></div>