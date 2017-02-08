Example: How to use values from model FreeMarker
${titulo}
/*
${titulo}
${autor}
<#list parametros as par>
  ${par.name},  ${par.tipo}, ${par.alias}
</#list>
<#list functions as fun>
    ${fun.service},  ${fun.name}
</#list>
<#list results as rel>
    ${rel.name},  ${rel.tipo}, ${rel.alias}
</#list>

*/