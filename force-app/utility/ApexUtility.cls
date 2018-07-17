public with sharing class ApexUtility {
    public static PageReference toPage(String myVar){
        PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/' + myVar);
    	page.setRedirect(true);
    	return page;  
    }

    public static String generateRandomAlphaNumeric(Integer size) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randomAlphaNumeric = '';

        for (Integer i = 0; i < size; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomAlphaNumeric += chars.substring(idx, idx+1);
        }
        return randomAlphaNumeric;
    }

    public static String generateRandomNumeric(Integer size) {
        final String chars = '0123456789';
        String randomAlphaNumeric = '';

        for (Integer i = 0; i < size; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randomAlphaNumeric += chars.substring(idx, idx+1);
        }
        return randomAlphaNumeric;
    }

     public static String getUserIPAddress() {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint( 'https://www.trackip.net/ip?json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String jsonInput = res.getBody();
        
        Map<String,String> responseBodyMapped = (Map<String,String>)JSON.deserialize(jsonInput, Map<String,String>.class);
        		
        return responseBodyMapped.get('IP');
    }

    public static GMOPaymentBean generateGMOPaymentBean(Account__c account, Subscription__c subscription, CreditCardBean creditCardBean) {
        GMOPaymentBean gmoPaymentBean = generateGMOPaymentBean(account, subscription);
        
        if (account.credit_card_number__c == null) {
            gmoPaymentBean.card_number = creditCardBean.cc;
            gmoPaymentBean.expire_year = creditCardBean.expireYear;
            gmoPaymentBean.expire_month = creditCardBean.expireMonth;
            gmoPaymentBean.security_code = creditCardBean.cvc;
        }
        
        return gmoPaymentBean;
    }

    public static GMOPaymentBean generateGMOPaymentBean(Account__c account, Subscription__c subscription) {
        GMOPaymentBean gmoPaymentBean = new GMOPaymentBean();
        gmoPaymentBean.contract_code = '10081070';
        gmoPaymentBean.user_id = account.Id;
        gmoPaymentBean.user_name = account.LastName__c;
        gmoPaymentBean.user_mail_add = account.Email__c;

        gmoPaymentBean.card_holder_name = account.LastName__c;
        System.debug(subscription.Id);
        gmoPaymentBean.ip_address = ApexUtility.getUserIPAddress();
        SubscriptionProgram__c program = [SELECT ProgramId__c, ProgramName__c FROM SubscriptionProgram__c WHERE ID = :subscription.Program__c];
        gmoPaymentBean.item_code = program.ProgramId__c;
        gmoPaymentBean.item_name = program.ProgramName__c;
        gmoPaymentBean.order_number = ApexUtility.generateRandomNumeric(4) + Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.item_price = String.valueOf(subscription.Amount__c);

        return gmoPaymentBean;
    }
    
}