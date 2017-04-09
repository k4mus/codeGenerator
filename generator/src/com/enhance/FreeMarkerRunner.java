package com.enhance;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.Version;


import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class FreeMarkerRunner{
	
	private static Configuration cfg = null;
	
	static{		
		// Freemarker below configuration object deprecated
		//Configuration cfg = new Configuration();
		//Please use this. To make it backward compatible. Please visit here for more info: 
		//http://freemarker.org/docs/api/freemarker/template/Configuration.html
		cfg = new Configuration(new Version("2.3.0"));
	}
	
	public static void main(String[] args) {
		JSONParser parser = new JSONParser();
		try {
			
			// Load template
			if (args.length<3) {
				System.out.println("Sin argumentos"); return; 
			}
			String pahtFTL = args[0];
			String templateName = args[1];
			String modelName =  args[2];
			String tipo= args[3];
			String outputPath = null;
			System.out.println("Argumentos: rutaFTL, plantilla, modelo, tipo");
			System.out.println("Argumentos: "+pahtFTL+","+templateName+","+modelName+","+tipo);
			if (pahtFTL.isEmpty() || templateName.isEmpty() || modelName.isEmpty() || tipo.isEmpty()){
				System.out.println("faltan argumentos");
				return;
			}
			
			Template template = cfg.getTemplate(pahtFTL+"/"+templateName);
			//Load Model on Jason
			JSONObject obj = (JSONObject) parser.parse(new FileReader(modelName));
			ArrayList jsonMapTablas= (ArrayList) jsonToMap(obj).get("tablas");
			String dirPath="";
			Map demo = null;
			for (int i =0; i<jsonMapTablas.size();i++){
				demo = (Map) jsonMapTablas.get(i);
				dirPath= demo.get("schema").toString()+"\\"+demo.get("tableName").toString();
				File dir = new File(dirPath);
			    if (!dir.exists())dir.mkdirs();
			    
			    outputPath= dirPath+"/"+demo.get("schema")+"_"+demo.get("tableName")+"_"+tipo;
	            // File output
				Writer file = new FileWriter(new File(outputPath));
				//Freemarker union model-template
				template.process(demo, file);
				file.flush();
				file.close();
				System.out.println("Codigo creado: "+ outputPath);
			}
			if (demo.get("schema")!=null && outputPath!=null && templateName.equalsIgnoreCase("init.ftl")){
				template = cfg.getTemplate(pahtFTL+"/"+"init_0.ftl");
				
				outputPath=demo.get("schema").toString();
				outputPath+="\\init.php";
				Writer file = new FileWriter(new File(outputPath));
				template.process( jsonToMap(obj), file);
				file.flush();
				file.close();
			}
			JSONObject jsonObject = (JSONObject) obj;
            //parse model to Map
//            Map demo = jsonToMap(jsonObject);
            
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	
	public static Map<String, Object> jsonToMap(JSONObject json) {
	    Map<String, Object> retMap = new HashMap<String, Object>();

	    if(json != null) {
	        retMap = toMap(json);
	    }
	    return retMap;
	}

	public static Map<String, Object> toMap(JSONObject object) {
	    Map<String, Object> map = new HashMap<String, Object>();

	    //Iterator<String> keysItr = object.keys();
	    Set<String> aux =  object.keySet();
	    Iterator<String> keysItr =  aux.iterator();
	    while(keysItr.hasNext()) {
	        String key = keysItr.next();
	        Object value = object.get(key);

	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        map.put(key, value);
	    }
	    return map;
	}

	public static List<Object> toList(JSONArray array)  {
	    List<Object> list = new ArrayList<Object>();
	    for(int i = 0; i < array.size(); i++) {
	        Object value = array.get(i);
	        if(value instanceof JSONArray) {
	            value = toList((JSONArray) value);
	        }

	        else if(value instanceof JSONObject) {
	            value = toMap((JSONObject) value);
	        }
	        list.add(value);
	    }
	    return list;
	}
	
}
