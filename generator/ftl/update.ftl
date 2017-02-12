<?php

function ${schema}_${tableName}_update() {
    global $wpdb;
    $table_name = $wpdb->prefix ."${tableName}";
    $${indice.name} = $_GET["${indice.name}"];
	<#list columnas as col>
	$${col.name} = $_POST["${col.name}"];
	</#list>
	
//update
    if (isset($_POST['update'])) {
        $wpdb->update(
                $table_name, //table
				array(<#list columnas as col> '${col.name}' => $${col.name}<#if col_has_next>,</#if></#list>), //data
                array('${indice.name}' => $${indice.name}), //where
				array(<#list columnas as col>'%s'<#if col_has_next>,</#if></#list>), //data format
                array('%s') //where format
        );
    }
//delete
    else if (isset($_POST['delete'])) {
        $wpdb->query($wpdb->prepare("DELETE FROM $table_name WHERE ${indice.name} = %s", $${indice.name}));
    } else {//selecting value to update	
        $results = $wpdb->get_results($wpdb->prepare("SELECT ${indice.name},<#list columnas as col> ${col.name} <#if col_has_next>,</#if></#list> from $table_name where ${indice.name}=%s", $${indice.name}));
        foreach ($results as $r) {
            $${indice.name} = $r->${indice.name};
            <#list columnas as col> 
			$${col.name} = $r->${col.name};
			</#list>			
        }
    }
    ?>
    <link type="text/css" href="<?php echo WP_PLUGIN_URL; ?>/${plugin}/style-admin.css" rel="stylesheet" />
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/smoothness/jquery-ui.css">
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    
    <div class="wrap">
        <h2>${titulo}</h2>

        <?php if ($_POST['delete']) { ?>
            <div class="updated"><p>${titulo} deleted</p></div>
            

        <?php } else if ($_POST['update']) { ?>
            <div class="updated"><p>${titulo} updated</p></div>
            

        <?php } else { ?>
            <form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
                <table class='wp-list-table widefat fixed'>
                    <tr><th>${indice.alias}</th><td><input type="text" name="${indice.name}" value="<?php echo $${indice.name}; ?>" disabled /></td></tr>
                    <#list columnas as col>
					<tr><th>${col.alias}</th><td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="${col.clase}"/></td></tr>
					</#list>
					
                </table>
                <input type='submit' name="update" value='Save' class='button'> &nbsp;&nbsp;
                <input type='submit' name="delete" value='Delete' class='button' onclick="return confirm('&iquest;Est&aacute;s seguro de borrar este elemento?')">
            </form>
        <?php } ?>
			<a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_list') ?>">&laquo; Volver</a>
			
    </div>
    <script>
		$( ".datetime" ).datepicker();
		$( ".datetime" ).onclick(function(){$(this).datepicker('show')});
	</script>
    <?php
}