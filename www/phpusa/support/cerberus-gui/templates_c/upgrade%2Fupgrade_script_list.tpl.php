<?php /* Smarty version 2.5.0, created on 2007-01-15 11:10:42
         compiled from upgrade/upgrade_script_list.tpl.php */ ?>
<?php if (isset($this->_foreach['scripts'])) unset($this->_foreach['scripts']);
$this->_foreach['scripts']['name'] = 'scripts';
$this->_foreach['scripts']['total'] = count((array)$this->_tpl_vars['script_list']);
$this->_foreach['scripts']['show'] = $this->_foreach['scripts']['total'] > 0;
if ($this->_foreach['scripts']['show']):
$this->_foreach['scripts']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['script_list'] as $this->_tpl_vars['script']):
        $this->_foreach['scripts']['iteration']++;
        $this->_foreach['scripts']['first'] = ($this->_foreach['scripts']['iteration'] == 1);
        $this->_foreach['scripts']['last']  = ($this->_foreach['scripts']['iteration'] == $this->_foreach['scripts']['total']);
?>
	<tr bgcolor="#<?php if ($this->_foreach['scripts']['iteration'] % 2 == 0): ?>dedede<?php else: ?>d0d0d0<?php endif; ?>">
		<td align="center" valign="middle">
			<?php if ($this->_tpl_vars['script']->precursor_ran): ?>
				<input type="radio" name="upgrade_script_name" value="<?php echo $this->_tpl_vars['script']->script_ident; ?>
">
			<?php endif; ?>
		</td>
		<td valign="top">
			<span class="cer_maintable_heading">&nbsp;<?php echo $this->_tpl_vars['script']->script_name; ?>
</span>&nbsp;<br>
			<span class="cer_footer_text">&nbsp;<b>Author: </b><?php echo $this->_tpl_vars['script']->script_author; ?>
&nbsp;
			<?php if (! $this->_tpl_vars['script']->precursor_ran): ?> -- <b>*required precursor scripts have not run*</b><?php endif; ?>
			</span><br>
		</td>
	</tr>
	<tr><td colspan="<?php echo $this->_tpl_vars['col_span']; ?>
" bgcolor="#FFFFFF"><img alt="" src="includes/images/spacer.gif" width="1" height="1"></td></tr>
<?php endforeach; endif; ?>