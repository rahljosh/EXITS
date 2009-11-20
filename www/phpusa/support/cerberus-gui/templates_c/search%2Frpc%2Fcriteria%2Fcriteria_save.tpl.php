<?php /* Smarty version 2.5.0, created on 2007-01-15 22:07:44
         compiled from search/rpc/criteria/criteria_save.tpl.php */ ?>
<input type="hidden" name="cmd" value="search_save">
<?php if (count ( $this->_tpl_vars['saved_searches'] )): ?>
	<label><input type="radio" name="save_mode" value="1"> 
	Save As: </label><select name="save_as">
	<?php if (isset($this->_foreach['searches'])) unset($this->_foreach['searches']);
$this->_foreach['searches']['name'] = 'searches';
$this->_foreach['searches']['total'] = count((array)$this->_tpl_vars['saved_searches']);
$this->_foreach['searches']['show'] = $this->_foreach['searches']['total'] > 0;
if ($this->_foreach['searches']['show']):
$this->_foreach['searches']['iteration'] = 0;
    foreach ((array)$this->_tpl_vars['saved_searches'] as $this->_tpl_vars['searchId'] => $this->_tpl_vars['search']):
        $this->_foreach['searches']['iteration']++;
        $this->_foreach['searches']['first'] = ($this->_foreach['searches']['iteration'] == 1);
        $this->_foreach['searches']['last']  = ($this->_foreach['searches']['iteration'] == $this->_foreach['searches']['total']);
?>
		<option value="<?php echo $this->_tpl_vars['search']->id; ?>
"><?php echo $this->_tpl_vars['search']->title; ?>

	<?php endforeach; endif; ?>
	</select>
	<br>
<?php endif; ?>

<label><input type="radio" name="save_mode" value="0" checked> New: </label><input type="text" name="save_new" value="" size="24"><br>
<input type="button" name="" value="Save" onclick="doSearchCriteriaSave(this.form.label.value);">
<input type="button" name="" value="Cancel" onclick="doSearchCriteriaClearIO(this.form.label.value);">