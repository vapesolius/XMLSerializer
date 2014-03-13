package com.XMLSerializer
{


    /**
     * Class for data to XML serialization.
     * @author vapes
     */
    public class XMLSerializer
    {
        /**
         * Serializes object to XML
         * @param o serializable object
         * @return result XML
         */
        public function toXML(o:*):XML
        {
            return (new ReflectionConverter).marshal(o);
        }

        /**
         * Serializes XML to object
         * @param xml
         * @return serializable object
         */
        public function fromXML(xml:XML):*
        {
            return (new ReflectionConverter).unmarshal(xml);
        }
    }
}

