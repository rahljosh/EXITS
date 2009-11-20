<?php
include_once(FILESYSTEM_PATH . "includes/local-api/kb/cer_PublicKnowledgebase.class.php");

// [JAS]: [TODO] Move to the API
if(empty($kb_root_desc)) {
	$sql = "SELECT kb.id, kb.views, kb.title ".
		"FROM (kb) ".
		"WHERE kb.public = 1 ".
		"ORDER BY kb.views DESC ".
		"LIMIT 0,10";
} else {
	include_once(FILESYSTEM_PATH . "/cerberus-api/workstation/CerWorkstationKbTags.class.php");
	$tags = new CerWorkstationKbTags(1);
	
	$sql = sprintf("SELECT kb.id, kb.views, kb.title ".
		"FROM (kb) ".
		"INNER JOIN `kb_to_category` kbtc ON (kbtc.kb_id=kb.id) ".
		"WHERE kb.public = 1 ".
		"AND kbtc.kb_category_id IN (%s) ".
		"GROUP BY kb.id ".
		"ORDER BY kb.views DESC ".
		"LIMIT 0,10",
			implode(',', $kb_root_desc)
	);
}
$res = $cerberus_db->query($sql);
?>

<table cellpadding="0" cellspacing="0" border="0" width='100%'>

	<tr>
		<td class="white_back">
		
			<table cellpadding="0" cellspacing="0" border="0" class="white_back" width='100%'>
				  <tr>
				    <td width="519" class="kb_most_viewed_articles">Most Viewed Knowledgebase Articles</td>
				    <td width="21" class="kb_most_diag"><img src="<?php echo DIRECTORY_NAME; ?>/includes/images/spacer.gif" width="21" height="21"></td>
				    <td width="90" class="kb_most_viewed_views">Views</td>
				  </tr>
			
				  <td colspan="3"><table cellpadding="3" cellspacing="0" border="0"width='100%'>
				  
			<?php
			if($cerberus_db->num_rows($res))
			{
				$row = 0;
				while($kb_row = $cerberus_db->fetch_row($res)) {
					if($row % 2) {
						$row_class = "kb_alt_bg_1"; }
					else {
						$row_class = "kb_alt_bg_2"; }
				?>
					<tr class="<?php echo $row_class; ?>">
						<td>
							<img src="<?php echo DIRECTORY_NAME; ?>/includes/images/crystal/16x16/icon_kb_article.gif" align="absmiddle">
							<?php
								$article_title = stripslashes($kb_row["title"]);
								echo sprintf("<a href='%s' class='url'>%s</a>",
										BASE_URL . "&mod_id=" . MODULE_KNOWLEDGEBASE . "&id=" . $kb_row["id"],
										$article_title
									);
							?>
						</td>
						<td align="center" valign="middle" class="box_content_text"><?php echo $kb_row["views"]; ?></td>
					</tr>
				<?php
					$row++;
				}
				
			}
			else {
				echo "<tr><td class='box_content_text'>No knowledgebase articles available.</td></tr>";
			}
			?>
			
			</table>

			</td>
			</tr>
			</table>
			
		</td>
	</tr>
	
</table>

<br>
