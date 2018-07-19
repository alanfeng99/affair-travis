public class GMOPaymentAPI {

    public GMOPaymentBean__c gmoPaymentBean {get; set;}

    public GMOPaymentAPI (GMOPaymentBean__c gmoPaymentBeanParam) {
        gmoPaymentBean = gmoPaymentBeanParam;
    }

    public void executePayment() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(System.Label.GMOPAYMENT_API_URL);
        request.setMethod('POST');

        gmoPaymentBean = addCommonGMOPaymentBeanValues(gmoPaymentBean);
        String requestBody = buildGMOPaymentBodyForRegisteredID(gmoPaymentBean);
        request.setBody(requestBody);
        
        HttpResponse response = http.send(request);
        GMOPaymentBean__c beanAPIResponse = deserializationGMOResponse(response.getBody());
        ApexUtility.mergeSecondObjectIntoFirstObject(gmoPaymentBean, beanAPIResponse);
        
        insert gmoPaymentBean;
    }

    public GMOPaymentBean__c addCommonGMOPaymentBeanValues(GMOPaymentBean__c gmoPaymentBeanParam) {
        gmoPaymentBeanParam.version__c = '1';
        gmoPaymentBeanParam.character_code__c = 'UTF-8';
        gmoPaymentBeanParam.process_code__c = '2';
        gmoPaymentBeanParam.lang_id__c = 'en';
        gmoPaymentBeanParam.user_agent__c = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36';
        gmoPaymentBeanParam.st_code__c = '10000-00000-00000-00000-00000-00000-00000';
        gmoPaymentBeanParam.mission_code__c = '1';
        gmoPaymentBeanParam.currency_id__c = 'TWD';
        gmoPaymentBeanParam.pan_bank__c = 'CitiBank';
        gmoPaymentBeanParam.pan_country__c = 'TW';
        
        return gmoPaymentBeanParam;
    }

    public String buildGMOPaymentBodyForRegisteredID(GMOPaymentBean__c gmoPaymentBeanParam) {
        Map<String, String> params = new Map<String,String>();
        params.put('contract_code', gmoPaymentBeanParam.contract_code__c);
        params.put('version', gmoPaymentBeanParam.version__c);
        params.put('character_code', gmoPaymentBeanParam.character_code__c);
        params.put('process_code', gmoPaymentBeanParam.process_code__c);
        params.put('user_id', gmoPaymentBeanParam.user_id__c);
        params.put('user_name', gmoPaymentBeanParam.user_name__c);
        params.put('user_mail_add', gmoPaymentBeanParam.user_mail_add__c);
        params.put('lang_id', gmoPaymentBeanParam.lang_id__c);
        params.put('ip_address', gmoPaymentBeanParam.ip_address__c);
        params.put('user_agent', gmoPaymentBeanParam.user_agent__c);
        params.put('item_code', gmoPaymentBeanParam.item_code__c);
        params.put('item_name', gmoPaymentBeanParam.item_name__c);
        params.put('order_number', gmoPaymentBeanParam.order_number__c);
        params.put('st_code', gmoPaymentBeanParam.st_code__c);
        params.put('mission_code', gmoPaymentBeanParam.mission_code__c);
        params.put('currency_id', gmoPaymentBeanParam.currency_id__c);
        params.put('item_price', gmoPaymentBeanParam.item_price__c);
        params.put('pan_bank', gmoPaymentBeanParam.pan_bank__c);
        params.put('pan_country', gmoPaymentBeanParam.pan_country__c);
        params.put('card_holder_name', gmoPaymentBeanParam.card_holder_name__c);
        params.put('add_info1', gmoPaymentBeanParam.add_info1__c);

        if (gmoPaymentBeanParam.card_number__c != null) {
            params.put('card_number', gmoPaymentBeanParam.card_number__c);
            params.put('expire_year', gmoPaymentBeanParam.expire_year__c);
            params.put('expire_month', gmoPaymentBeanParam.expire_month__c);
            params.put('security_code', gmoPaymentBeanParam.security_code__c);
        }

        String mapToString = '';
        
        for(String key:params.keySet())
            mapToString += key + '=' + params.get(key) + ';';
        mapToString = mapToString.removeEnd(';');

        return mapToString;
    }

    public GMOPaymentBean__c deserializationGMOResponse(String response) {
        Dom.Document doc = new Dom.Document();
        doc.load(response);
        
        Dom.XMLNode xroot = doc.getRootElement();
        Dom.Document docNewXml = new Dom.Document();
        Dom.XMLNode xrootNewXml = docNewXml.createRootElement(xroot.getName(),null,null);
        for (Dom.XMLNode node : xroot.getChildren()) {
            if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getAttributeCount() > 0) {
                String nodeAttributeKey = node.getAttributeKeyAt(0);
                String nodeAttributeValue = node.getAttribute(nodeAttributeKey, null);
                Dom.XMLNode tmp = xrootNewXml.addChildElement(nodeAttributeKey + '__c',null,null);
                tmp.addTextNode(nodeAttributeValue);
            }
        }
        String newXml = docNewXml.toXmlString();
        XMLSerializer xmlSerializer = new XMLSerializer();

        GMOPaymentBean__c gmoPaymentBeanDeserialized = new GMOPaymentBean__c();
        gmoPaymentBeanDeserialized = (GMOPaymentBean__c) xmlSerializer.deSerialize(newXml, GMOPaymentBean__c.class);
        return gmoPaymentBeanDeserialized;
    }
}