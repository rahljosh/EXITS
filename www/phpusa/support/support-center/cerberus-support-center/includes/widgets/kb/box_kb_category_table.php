<?php
$categories = $kb->getCategories();
// [JAS]: If root isn't set or is 0, use root.  Otherwise a category branch
if($root) {
	$kb_root = $categories[$root];
} else {
	$kb_root = $kb->getRoot();
}

$ancestors = $kb_root->getAncestors(1);

if(is_array($ancestors))
foreach($ancestors as $ans_id => $ans) { 
	if($ans_id) { ?>
		<?php echo sprintf("<a href='%s' class='url'>%s</a>",BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&root=" . $ans_id,$kb->flat_categories[$ans_id]->name); ?> :
	<?php } else { ?>
		<?php echo sprintf("<a href='%s' class='url'>%s</a>",BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&root=0","Top"); ?> ::
	<?php } ?>
<?php } ?>

<table cellpadding="0" cellspacing="5" border="0" width="100%">
	<tr>
		<td width="50%" valign="top">
			<table cellpadding="1" cellspacing="0" border="0" style="padding-right:2px;border-right:1px dashed #dddddd">
				<?php
				$middle = ceil($kb_root->getChildCount()/2);
				$catidx = 1;
				if(0 != $kb_root->getChildCount()) {
				foreach($kb_root->children as $category_id => $category) {
				?>
					<tr>
						<td colspan="2" class="box_content_text"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_kb_folder.gif" align="absmiddle"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="5" height="1" align="absmiddle">
						<?php echo sprintf("<a href='%s' class='kb_parent'>%s</a>",BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&root=" . $category_id,$category->name); ?>
						(<?php echo $category->hits; ?>)</td>
					</tr>
					
					<?php
					$articles = $category->getMostViewedArticles(5,1);
					if(is_array($articles))
					foreach($articles as $article_id => $article) {
					?>
					<tr>
						<td width="100%"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_kb_article.gif" align="absmiddle" alt="article"> 
						<?php echo sprintf("<a href='%s' class='url'>%s</a>",BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&id=" . $article_id,$article->name); ?></td>
						<td align="right" align="0%" nowrap="nowrap">&nbsp;</td>
					</tr>
					<?php } /* foreach */ ?>
					
					<tr>
						<td width="100%">&nbsp;</td>
						<td width="0%">&nbsp;</td>
					</tr>

					<?php
					if($middle == $catidx) {
					?>
							</table>
						</td>
						<td width="50%" valign="top">
							<table cellpadding="1" cellspacing="0" border="0" style="padding-right:2px;border-right:1px dashed #dddddd">
					<?php } /* if */ ?>
				<?php $catidx++; } /* foreach */ ?>
				
				<?php } else { ?>
					<tr>
						<td width="100%" class="box_content_text"><i>Category <b><?php echo $kb_root->name; ?></b> has no subcategories.</i></td>
						<td width="0%">&nbsp;</td>
					</tr>
				
				<?php } /* if */ ?>
			
			</table>
		</td>
	</tr>
</table>