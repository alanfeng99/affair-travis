public class GMOPaymentAPI {

    public GMOPaymentBean__c gmoPaymentBean {get; set;}

    public GMOPaymentAPI (GMOPaymentBean__c gmoPaymentBeanParam) {
        gmoPaymentBean = gmoPaymentBeanParam;
    }

    public void executePayment() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://test.global-payment.asia/payment/api/direct_payment.cgi');
        request.setMethod('POST');
        
        String requestBody = buildGMOPaymentBodyForRegisteredID();
        request.setBody(requestBody);
        System.debug(request.getBody());

        HttpResponse response = http.send(request);
        System.debug(response.getBody());
        GMOPaymentBean__c beanAPIResponseToInsert = deserializationGMOResponse(response.getBody());
        beanAPIResponseToInsert = (GMOPaymentBean__c) ApexUtility.mergeSecondObjectIntoFirstObject(beanAPIResponseToInsert, gmoPaymentBean);
        
        System.debug(beanAPIResponseToInsert);
    }

    public String buildGMOPaymentBodyForRegisteredID() {
        Map<String, String> params = new Map<String,String>();
        params.put('contract_code', gmoPaymentBean.contract_code__c);
        params.put('version', '1');
        params.put('character_code', 'UTF-8');
        params.put('process_code', '2');
        params.put('user_id', gmoPaymentBean.user_id__c);
        params.put('user_name', gmoPaymentBean.user_name__c);
        params.put('user_mail_add', gmoPaymentBean.user_mail_add__c);
        params.put('lang_id', 'en');
        params.put('ip_address', gmoPaymentBean.ip_address__c);
        params.put('user_agent', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36');
        params.put('item_code', gmoPaymentBean.item_code__c);
        params.put('item_name', gmoPaymentBean.item_name__c);
        params.put('order_number', gmoPaymentBean.order_number__c);
        params.put('st_code', '10000-00000-00000-00000-00000-00000-00000');
        params.put('mission_code', '1');
        params.put('currency_id', 'TWD');
        params.put('item_price', gmoPaymentBean.item_price__c);
        params.put('pan_bank', 'CitiBank');
        params.put('pan_country', 'TW');
        params.put('card_holder_name', gmoPaymentBean.card_holder_name__c);
        params.put('add_info1', '1');

        if (gmoPaymentBean.card_number__c != null) {
            params.put('card_number', gmoPaymentBean.card_number__c);
            params.put('expire_year', gmoPaymentBean.expire_year__c);
            params.put('expire_month', gmoPaymentBean.expire_month__c);
            params.put('security_code', gmoPaymentBean.security_code__c);
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
        //Retrieve the root element for this document.
        Dom.XMLNode xroot = doc.getRootElement();
        Dom.Document docNewXml = new Dom.Document();
        Dom.XMLNode xrootNewXml = docNewXml.createRootElement(xroot.getName(),null,null);
        for (Dom.XMLNode node : xroot.getChildren()) {
            String nodeAttributeKey = node.getAttributeKeyAt(0);
            String nodeAttributeValue = node.getAttribute(nodeAttributeKey, null);
            Dom.XMLNode tmp = xrootNewXml.addChildElement(nodeAttributeKey + '__c',null,null);
            tmp.addTextNode(nodeAttributeValue);
        }
        String newXml = docNewXml.toXmlString();
        XMLSerializer xmlSerializer = new XMLSerializer();

        GMOPaymentBean__c gmoPaymentBeanDeserialized = new GMOPaymentBean__c();
        gmoPaymentBeanDeserialized = (GMOPaymentBean__c) xmlSerializer.deSerialize(newXml, GMOPaymentBean__c.class);
        return gmoPaymentBeanDeserialized;
    }
}