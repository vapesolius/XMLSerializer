package com.XMLSerializer
{
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;



    /**
     *	Class contain methods fos serialization and deserialization
     * @author vapes
     */
    public class ReflectionConverter
    {
        /**
         * Constructor
         */
        public function ReflectionConverter()
        {
        }

        /**
         *	Serializes object to XML
         * @param source serializable object
         * @return result XML
         */
        public function marshal(source:Object):XML
        {
            var writer:XMLWriter=new XMLWriter();
            var objDescriptor:XML=describeType(source);
            var property:XML;	
            var propertyType:String;	
            var propertyValue:Object;	

            var qualifiedClassName:String=objDescriptor.@name;
            qualifiedClassName=qualifiedClassName.replace("::",".");
            writer.xml.setName(qualifiedClassName);

            if (String(objDescriptor.@name) == "Object" || String(objDescriptor.@name) == "Array"){
                for (var objectKey:String in source){
                    propertyValue = source[objectKey];
                    if (propertyValue!=null){	
                        if (propertyValue is String || propertyValue is Boolean || propertyValue is Number){
                            writer.addElement(objectKey, propertyValue.toString(),getQualifiedClassName(propertyValue));
                        }
                        else {
                            writer.addElement(objectKey, (new ReflectionConverter).marshal(propertyValue));
                        }						
                    }	
                }
                return writer.xml;
            }


            for each(property in objDescriptor.elements("variable")){				
                propertyValue=source[property.@name];
                if (propertyValue!=null){	
                    if (propertyValue is String || propertyValue is Boolean || propertyValue is Number){
                        writer.addProperty(property.@name, propertyValue.toString());
                    }
                    else {
                        writer.addProperty(property.@name, (new ReflectionConverter).marshal(propertyValue));
                    }						
                }					
            }	
            for each(property in objDescriptor.elements("accessor")){
                if (property.@access=="readonly"){
                    continue;
                }
                propertyValue=source[property.@name];
                if (source[property.@name]!=null){			
                    if (propertyValue is String || propertyValue is Boolean || propertyValue is Number){
                        writer.addProperty(property.@name, propertyValue.toString());
                    }
                    else {
                        writer.addProperty(property.@name, (new ReflectionConverter).marshal(propertyValue));
                    }		
                }					
            }
            return writer.xml;
        }
        /**
         *	Deserializes XML to Object
         * @param xml serializable XML
         * @return result Object
         */
        public function unmarshal(xml:XML):Object
        {
            var node:XML;
            var objectClass:Class;
            var objDescriptor:XML;
            var object:Object;
            var child:XML;
            var propertyType:String;
            var propertyClass:Class;
            node=xml;
            objectClass=flash.utils.getDefinitionByName(node.name()) as Class;
            object=new objectClass();
            objDescriptor=describeType(object);
            for each(child in xml.children()){
                node=child;
                if (node.name() == 'element'){
                    propertyType = node.@type;
                    if (propertyType){
                        propertyClass=flash.utils.getDefinitionByName(propertyType) as Class;	
                        object[String(node.@key)]=new propertyClass(node.toString());
                    }else{
                        object[String(node.@key)]=(new ReflectionConverter).unmarshal(node.children()[0]);
                    }
                }else{
                    propertyType=getTypeFromDescriptor(node.name(), objDescriptor);
                    if (propertyType!=null){
                        propertyClass=flash.utils.getDefinitionByName(propertyType) as Class;						
                        if (new propertyClass() is String || new propertyClass() is Boolean || new propertyClass() is Number){
                            object[node.name()]=new propertyClass(node.toString());
                        }	
                        else{
                            object[node.name()]=(new ReflectionConverter).unmarshal(node.children()[0]);
                        }		
                    }	}				
            }			
            return object;
        }

        /**
         * Checks if property with given name exists in class and returns property type.
         * Returns null if class has no property with that name.
         *
         * @param name property name
         * @return
         *
         */
        private function getTypeFromDescriptor(name:String, objDescriptor:XML):String
        {
            for each (var property:XML in objDescriptor.elements("variable"))
            {
                if (property.@name == name)
                {
                    return (String(property.@type)); //.replace("::","."));
                }
            }
            for each (var accessor:XML in objDescriptor.elements("accessor"))
            {
                if (accessor.@name == name)
                {
                    return (String(accessor.@type)); //.replace("::","."));
                }
            }
            return null;
        }


    }
}

