public class GMOPaymentAPI {

    public GMOPaymentBean__c gmoPaymentBean {get; set;}
    public String gmoPaymentURL {get; set;}

    public GMOPaymentAPI (GMOPaymentBean__c gmoPaymentBeanParam) {
        gmoPaymentBean = gmoPaymentBeanParam;
        gmoPaymentURL = System.Label.GMOPAYMENT_API_URL;
    }

    public HttpRequest prepareRequest(String endPoint) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(gmoPaymentURL + endPoint);
        request.setMethod('POST');

        return request;
    }

    public String directPayment() {
        HttpRequest request = prepareRequest(System.Label.ENDPOINT_DIRECT_PAYMENT);

        gmoPaymentBean = addCommonGMOPaymentBeanValues(gmoPaymentBean);
        String requestBody = buildGMOPaymentBodyForDirectPayment(gmoPaymentBean);
        request.setBody(requestBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        GMOPaymentBean__c beanAPIResponse = (GMOPaymentBean__c) deserializationGMOResponse(response.getBody(), GMOPaymentBean__c.class);
        ApexUtility.mergeSecondObjectIntoFirstObject(gmoPaymentBean, beanAPIResponse);
        
        if (gmoPaymentBean.result__c == '1' && gmoPaymentBean.trans_code__c != null && !String.isBlank(gmoPaymentBean.trans_code__c))
            return gmoPaymentBean.trans_code__c;

        insert gmoPaymentBean;
        return null;
    }

    public GMOPaymentCheckOrderResultBean checkOrder(String contract_code, String trans_code) {
        HttpRequest request = prepareRequest(System.Label.ENDPOINT_CHECK_ORDER);
        String requestBody = buildGMOPaymentBodyForCheckOrder(contract_code, trans_code);
        request.setBody(requestBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        insert gmoPaymentBean;
        
        return (GMOPaymentCheckOrderResultBean) deserializationGMOResponse(response.getBody(), GMOPaymentCheckOrderResultBean.class);
    }

    public GMOPaymentBean__c addCommonGMOPaymentBeanValues(GMOPaymentBean__c gmoPaymentBeanParam) {
        gmoPaymentBeanParam.version__c = '1';
        gmoPaymentBeanParam.character_code__c = 'UTF-8';
        gmoPaymentBeanParam.lang_id__c = 'en';
        gmoPaymentBeanParam.user_agent__c = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36';
        gmoPaymentBeanParam.mission_code__c = '1';
        gmoPaymentBeanParam.currency_id__c = 'TWD';
        gmoPaymentBeanParam.pan_bank__c = 'CitiBank';
        gmoPaymentBeanParam.pan_country__c = 'TW';
        gmoPaymentBeanParam.add_info1__c = '1';

        return gmoPaymentBeanParam;
    }

    public String buildGMOPaymentBodyForDirectPayment(GMOPaymentBean__c gmoPaymentBeanParam) {
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

        if (gmoPaymentBeanParam.card_number__c != null && gmoPaymentBeanParam.st_code__c == Constants.ST_CODE_CREDIT_CARD_PAYMENT) {
            params.put('card_number', gmoPaymentBeanParam.card_number__c);
            params.put('expire_year', gmoPaymentBeanParam.expire_year__c);
            params.put('expire_month', gmoPaymentBeanParam.expire_month__c);
            params.put('security_code', gmoPaymentBeanParam.security_code__c);
            gmoPaymentBeanParam.card_number__c = CreditcardUtility.hideCreditCardNumber(gmoPaymentBeanParam.card_number__c);
            gmoPaymentBeanParam.expire_year__c = '';
            gmoPaymentBeanParam.expire_month__c = '';
            gmoPaymentBeanParam.security_code__c = '';
        }

        return convertMapToString(params);
    }

    public String buildGMOPaymentBodyForCheckOrder(String contract_code, String trans_code) {
        Map<String, String> params = new Map<String,String>();

        params.put('contract_code', contract_code);
        params.put('trans_code', trans_code);

        return convertMapToString(params);
    }

    public String convertMapToString(Map<String,String> params) {
        String mapToString = '';
        
        for(String key:params.keySet())
            mapToString += key + '=' + params.get(key) + ';';
        mapToString = mapToString.removeEnd(';');
        System.debug(mapToString);
        return mapToString;
    }

    public object deserializationGMOResponse(String response, System.Type apexType) {
        String newXml = convertGMOPaymentXMLResult(response, apexType);
        XMLSerializer xmlSerializer = new XMLSerializer();
        return xmlSerializer.deSerialize(newXml, apexType);
    }

    public String convertGMOPaymentXMLResult(String response, System.Type apexType) {
        Dom.Document doc = new Dom.Document();
        doc.load(response);
        
        Dom.XMLNode xroot = doc.getRootElement();
        Dom.Document docNewXml = new Dom.Document();
        Dom.XMLNode xrootNewXml = docNewXml.createRootElement(xroot.getName(),null,null);
        for (Dom.XMLNode node : xroot.getChildren()) {
            if (node.getNodeType() == DOM.XMLNodeType.ELEMENT && node.getAttributeCount() > 0) {
                String nodeAttributeKey = node.getAttributeKeyAt(0);
                String nodeAttributeValue = node.getAttribute(nodeAttributeKey, null);
                nodeAttributeKey += apexType.toString().contains('__c') ? '__c' : '';
                Dom.XMLNode tmp = xrootNewXml.addChildElement(nodeAttributeKey, null, null);
                tmp.addTextNode(nodeAttributeValue);
            }
        }
        return docNewXml.toXmlString();
    }

    public static String generateStCode(String paymentMethod) {
        if (paymentMethod == '信用卡')
            return Constants.ST_CODE_CREDIT_CARD_PAYMENT;
        if (paymentMethod == '超商付款')
            return Constants.ST_CODE_SUPER_PAYMENT;
        if (paymentMethod == 'ATM轉帳')
            return Constants.ST_CODE_ATM;
        return Constants.ST_CODE_NOTHING;
    }

    public static String generateProcessCode(String paymentMethod) {
        if (paymentMethod == '信用卡')
            return Constants.PROCESS_CODE_REGISTER_CREDIT_CARD;
        return Constants.PROCESS_CODE_ONE_TIME;
    }
}