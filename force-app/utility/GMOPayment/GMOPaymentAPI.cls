public class GMOPaymentAPI {

    public GMOPaymentBean gmoPaymentBean {get; set;}

    public GMOPaymentAPI (GMOPaymentBean gmoPaymentBeanParam) {
        gmoPaymentBean = gmoPaymentBeanParam;
    }

    public void saveCreditCardZPayment() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://test.global-payment.asia/payment/api/direct_payment.cgi');
        request.setMethod('POST');
        
        request.setBody(buildGMOPaymentBody());
        System.debug(request.getBody());

        //HttpResponse response = http.send(request);
        //System.debug(response.getBody());
    }

    public String buildGMOPaymentBody() {
        Map<String, String> params = new Map<String,String>();
        params.put('contract_code', gmoPaymentBean.contract_code);
        params.put('version', '1');
        params.put('character_code', 'UTF-8');
        params.put('process_code', '2');
        params.put('user_id', gmoPaymentBean.user_id);
        params.put('user_name', gmoPaymentBean.user_name);
        params.put('user_mail_add', gmoPaymentBean.user_mail_add);
        params.put('lang_id', 'en');
        params.put('ip_address', gmoPaymentBean.ip_address);
        params.put('user_agent', 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36');
        params.put('item_code', gmoPaymentBean.item_code);
        params.put('item_name', gmoPaymentBean.item_name);
        params.put('order_number', gmoPaymentBean.order_number);
        params.put('st_code', '10000-00000-00000-00000-00000-00000-00000');
        params.put('mission_code', '1');
        params.put('currency_id', 'TWD');
        params.put('item_price', gmoPaymentBean.item_price);
        if (gmoPaymentBean.card_number != null) {
            params.put('card_number', gmoPaymentBean.card_number);
            params.put('expire_year', gmoPaymentBean.expire_year);
            params.put('expire_month', gmoPaymentBean.expire_month);
            params.put('security_code', gmoPaymentBean.security_code);
        }
        params.put('pan_bank', 'CitiBank');
        params.put('pan_country', 'TW');
        params.put('card_holder_name', gmoPaymentBean.card_holder_name);
        params.put('add_info1', '1');
        String mapToString = '';
        
        for(String key:params.keySet())
            mapToString += key + '=' + params.get(key) + ';';
        mapToString = mapToString.removeEnd(';');

        return mapToString;
    }
}