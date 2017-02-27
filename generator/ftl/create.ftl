<?php

function ${schema}_${tableName}_create() {
	<#list foraneas as for>    
	$${for.name} = $_GET["${for.name}"];
	</#list>
	<#list columnas as col>
	$${col.name} = $_POST["${col.name}"];
	</#list>
	
	//volver
	<#list foraneas as for>
	if($${for.name}) $page_volver= "${schema}_${for.table}_update&${for.name}=".$${for.name};
	else
	<#if !for_has_next>
		$page_volver= "${schema}_${tableName}_list";
	</#if>
	</#list>
	
	 //insert
    if (isset($_POST['insert'])) {
		<#list foraneas as for>
		$${for.name}= $_POST["${for.name}"];
		</#list>
		
        global $wpdb;
        $table_name = $wpdb->prefix ."${tableName}";

        $wpdb->insert(
                $table_name, //table
                array(<#list foraneas as for>'${for.name}'=>$${for.name} ,</#list> <#list columnas as col> '${col.name}' => $${col.name} <#if col_has_next>,</#if></#list> ), //data
                array('%s', '%s') //data format	 		
        );
        $message.="${titulo} inserted";
    }
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
    <div class="wrap">
        <h2>Add New ${titulo}</h2>
        <?php if (isset($message)): ?><div class="updated"><p><?php echo $message; ?></p></div><?php endif; ?>
        <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
            <p> </p>
            <table class='wp-list-table widefat fixed'>
				<#list foraneas as for>
				<tr>
                    <th class="ss-th-width">${for.name}</th>
                    <td><input type="text" name="${for.name}" value="<?php echo $${for.name}; ?>" <?php if ($${for.name}) echo readonly  ?> class="ss-field-width " /></td>
                </tr>
				</#list>
				<#list columnas as col>
				<tr>
                    <th class="ss-th-width">${col.alias}</th>
                    <td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="ss-field-width ${col.clase}" /></td>
                </tr>
				</#list>
            </table>
            <input type='submit' name="insert" value='Save' class='button'>
        </form>
		<a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_list') ?>">&laquo; Volver</a>
    </div>
    <script>
		$( ".datetime" ).datepicker();
		$( ".datetime" ).onclick(function(){$(this).datepicker('show')});
	</script>
    <?php
}