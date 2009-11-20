<?php /* Smarty version 2.5.0, created on 2007-02-20 16:35:04
         compiled from reports/report_data.tpl.php */ ?>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<?php if (isset($this->_foreach['rows'])) unset($this->_foreach['rows']);
$this->_foreach['rows']['name'] = 'rows';
$this->_foreach['rows']['total'] = count((array)$this->_tpl_vars['report']->report_data->rows);
$this->_foreach['rows']['show'] = $this->_foreach['rows']['total'] > 0;
if ($this->_foreach['rows']['show']):
$this->_foreach['rows']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['report']->report_data->rows as $this->_tpl_vars['row']):
        $this->_foreach['rows']['iteration']++;
        $this->_foreach['rows']['first'] = ($this->_foreach['rows']['iteration'] == 1);
        $this->_foreach['rows']['last']  = ($this->_foreach['rows']['iteration'] == $this->_foreach['rows']['total']);
?>
<tr bgcolor="<?php echo $this->_tpl_vars['row']->bgcolor; ?>
" class="<?php echo $this->_tpl_vars['row']->style; ?>
">
	<?php if (isset($this->_foreach['cols'])) unset($this->_foreach['cols']);
$this->_foreach['cols']['name'] = 'cols';
$this->_foreach['cols']['total'] = count((array)$this->_tpl_vars['row']->cols);
$this->_foreach['cols']['show'] = $this->_foreach['cols']['total'] > 0;
if ($this->_foreach['cols']['show']):
$this->_foreach['cols']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['row']->cols as $this->_tpl_vars['col']):
        $this->_foreach['cols']['iteration']++;
        $this->_foreach['cols']['first'] = ($this->_foreach['cols']['iteration'] == 1);
        $this->_foreach['cols']['last']  = ($this->_foreach['cols']['iteration'] == $this->_foreach['cols']['total']);
?>
		<td align="<?php echo $this->_tpl_vars['col']->align; ?>
" valign="<?php echo $this->_tpl_vars['col']->valign; ?>
" width="<?php echo $this->_tpl_vars['col']->width; ?>
" <?php echo $this->_tpl_vars['col']->nowrap; ?>
 bgcolor="<?php echo $this->_tpl_vars['col']->bgcolor; ?>
" colspan="<?php echo $this->_tpl_vars['col']->col_span; ?>
"><span class="<?php echo $this->_tpl_vars['col']->style; ?>
"><?php echo $this->_tpl_vars['col']->data; ?>
</span></td>
	<?php endforeach; endif; ?>
</tr>
<?php endforeach; endif; ?>

<?php if (empty ( $this->_tpl_vars['report']->report_data->rows )): ?>
	<tr><td><span class="cer_maintable_text">No data for selected criteria.</span></td></tr>
<?php endif; ?>

</table>