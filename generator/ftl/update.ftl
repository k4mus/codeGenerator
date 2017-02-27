<?php

function ${schema}_${tableName}_update() {
    global $wpdb;
    $table_name = $wpdb->prefix ."${tableName}";
    $${indice.name} = $_GET["${indice.name}"];
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
	
//update
    if (isset($_POST['update'])) <#list foraneas as for>
		$${for.name}= $_POST["${for.name}"];
		</#list>
		
        $wpdb->update(
                $table_name, //table
				array(<#list foraneas as for> '${for.name}' => $${for.name} ,</#list> <#list columnas as col> '${col.name}' => $${col.name}<#if col_has_next>,</#if></#list>), //data
                array('${indice.name}' => $${indice.name} ), //where
				array(<#list columnas as col>'%s'<#if col_has_next>,</#if></#list>), //data format
                array('%s') //where format
        );
    }
//delete
    else if (isset($_POST['delete'])) {
        $wpdb->query($wpdb->prepare("DELETE FROM $table_name WHERE ${indice.name} = %s", $${indice.name}));
    } else {//selecting value to update	
        $results = $wpdb->get_results($wpdb->prepare("SELECT ${indice.name} <#list foraneas as for> ,'${for.name}' </#list>,<#list columnas as col> ${col.name} <#if col_has_next>,</#if></#list> from $table_name where ${indice.name}=%s", $${indice.name}));
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
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.13.6/css/ui.jqgrid.min.css">
	<script src="//code.jquery.com/jquery-1.12.4.js"></script>
	<script src="//code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/free-jqgrid/4.13.6/js/jquery.jqgrid.min.js"></script>
    <div class="wrap">
        <h2></h2>

        <?php if ($_POST['delete']) { ?>
            <div class="updated"><p>${titulo} deleted</p></div>
        
        <?php } else if ($_POST['update']) { ?>
            <div class="updated"><p>${titulo} updated</p></div>
        
        <?php } else { ?>
		
		<div id="tabs">
		  <ul>
			<li><a href="#tabs-1">${titulo}</a></li>
			<#assign icont = 2/> 
			<#list tabs as tab>
			<li><a href="#tabs-${icont}" name=${tab.name}>${tab.titulo}</a></li>
			<#assign icont = icont+1/> 
			</#list>
		  </ul>
		  <div id="tabs-1">
			<form method="post" action="<?php echo $_SERVER['REQUEST_URI']; ?>">
                <table class='wp-list-table widefat fixed' id="tabla">
                    <tr>
						<th>${indice.alias}</th>
						<td><input type="text" name="${indice.name}" value="<?php echo $${indice.name}; ?>" disabled /></td>
					</tr>
					<#list foraneas as for>
					<tr>
						<th>${for.alias}</th>
						<td><input type="text" name="${for.name}" value="<?php echo $${for.name}; ?>"  <?php if ($${for.name}) echo readonly  ?> /></td>
					</tr>
					</#list>
                    <#list columnas as col>
					<tr><th>${col.alias}</th><td><input type="text" name="${col.name}" value="<?php echo $${col.name}; ?>" class="${col.clase}"/></td></tr>
					</#list>
                </table>
				<div id='pager'></div>
                <input type='submit' name="update" value='Save' class='button'> &nbsp;&nbsp;
                <input type='submit' name="delete" value='Delete' class='button' onclick="return confirm('&iquest;Est&aacute;s seguro de borrar este elemento?')">
            </form>
		</div>
		<#assign icont = 2/> 
		<#list tabs as tab>	
		<div id="tabs-${icont}">
			<?php	${tab.fun};?>
		</div>
		<#assign icont = icont+1/> 
		</#list>
        <?php } ?>
			<a href="<?php echo admin_url('admin.php?page=${schema}_${tableName}_list') ?>">&laquo; Volver</a>
			
    </div>
    <script>
		$( ".datetime" ).datepicker();
		$( "#tabs" ).tabs();
		
	</script>
    <?php
}