<?php

$page = (isset($_GET['page'])) ? $_GET['page'] : 0;

$content = range(1, 1000);

$pages = array_chunk($content, 25);

echo implode('<br />', $pages[$page]).'<hr>';

$total_pages = count($pages);

$prevpage = $page - 1;
$nextpage = $page + 1;

if ($page > 0)
{
    if($page < $total_pages - 1)
    {
        $page_div = ' | ';
    }
    else
    {
        $page_div = '';
    }

    echo "<a href=\"?page={$prevpage}\">Prev</a>{$page_div}";
}

if ($nextpage < $total_pages)
{
  echo "<a href=\"?page={$nextpage}\">Next</a>";
}

?>