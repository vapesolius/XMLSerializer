package com.XMLSerializer 
{
    public class XMLWriter
    {
        public var xml:XML;

        public function XMLWriter()
        {
            xml=<obj/>;
        }

        public function reset():void {
            xml=new XML();
        }

        public function addProperty(propertyName:String, propertyValue:*):XML {
            var xmlProperty:XML=<new/>
            xmlProperty.setName(propertyName);
            xmlProperty.appendChild(propertyValue);
            xml.appendChild(xmlProperty);
            return xmlProperty;		
        }

        public function addAttribute(propertyName:String, attribute:String, attributeValue:*):void {
            xml.elements(propertyName)[0].@[attribute]=attributeValue;
        }

        public function addElement(keyName:String, elementValue:*,propertyType:String = ''):XML {
            var xmlProperty:XML=<new/>
            xmlProperty.setName("element");
            xmlProperty.@['key'] = keyName;
            if (propertyType)xmlProperty.@['type'] = propertyType;
            xmlProperty.appendChild(elementValue);
            xml.appendChild(xmlProperty);
            return xmlProperty;	
        }
    }
}

