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

    public static GMOPaymentBean__c generateGMOPaymentBean(Account__c account, Subscription__c subscription, CreditCardBean creditCardBean) {
        GMOPaymentBean__c gmoPaymentBean = generateGMOPaymentBean(account, subscription);
        
        if (account.credit_card_number__c == null) {
            gmoPaymentBean.card_number__c = creditCardBean.cc;
            gmoPaymentBean.expire_year__c = creditCardBean.expireYear;
            gmoPaymentBean.expire_month__c = creditCardBean.expireMonth;
            gmoPaymentBean.security_code__c = creditCardBean.cvc;
        }
        
        return gmoPaymentBean;
    }

    public static GMOPaymentBean__c generateGMOPaymentBean(Account__c account, Subscription__c subscription) {
        GMOPaymentBean__c gmoPaymentBean = new GMOPaymentBean__c();
        gmoPaymentBean.contract_code__c = '10081070';
        gmoPaymentBean.user_id__c = account.Id;
        gmoPaymentBean.user_name__c = account.LastName__c;
        gmoPaymentBean.user_mail_add__c = account.Email__c;

        gmoPaymentBean.card_holder_name__c = account.LastName__c;
        System.debug(subscription.Id);
        gmoPaymentBean.ip_address__c = ApexUtility.getUserIPAddress();
        SubscriptionProgram__c program = [SELECT ProgramId__c, ProgramName__c FROM SubscriptionProgram__c WHERE ID = :subscription.Program__c];
        gmoPaymentBean.item_code__c = program.ProgramId__c;
        gmoPaymentBean.item_name__c = program.ProgramName__c;
        gmoPaymentBean.order_number__c = ApexUtility.generateRandomNumeric(4) + Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.item_price__c = String.valueOf(subscription.Amount__c);

        return gmoPaymentBean;
    }
    
}