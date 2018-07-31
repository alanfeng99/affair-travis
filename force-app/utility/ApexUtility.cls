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
        req.setEndpoint('https://www.trackip.net/ip?json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String jsonInput = res.getBody();
        
        Map<String,String> responseBodyMapped = (Map<String,String>)JSON.deserialize(jsonInput, Map<String,String>.class);
        		
        return responseBodyMapped.get('IP');
    }
    
    public static GMOPaymentBean__c generateGMOPaymentBeanForCancel(Account__c account, Order order) {
        GMOPaymentBean__c gmoPaymentBean = generateGMOPaymentBean(account, order);
        gmoPaymentBean.process_code__c = Constants.PROCESS_CODE_DELETE_CREDIT_CARD;
        return gmoPaymentBean;
    }

    public static GMOPaymentBean__c generateGMOPaymentBeanForChange(Account__c account, Order order, CreditCardBean creditCardBean) {
        GMOPaymentBean__c gmoPaymentBean = generateGMOPaymentBean(account, order);
        gmoPaymentBean.process_code__c = Constants.PROCESS_CODE_CHANGE_CREDIT_CARD;
        
        gmoPaymentBean.card_number__c = creditCardBean.cc;
        gmoPaymentBean.expire_year__c = creditCardBean.expireYear;
        gmoPaymentBean.expire_month__c = creditCardBean.expireMonth;
        gmoPaymentBean.security_code__c = creditCardBean.cvc;
        
        return gmoPaymentBean;
    }
    
    public static GMOPaymentBean__c generateGMOPaymentBeanForPayment(Account__c account, Order order, CreditCardBean creditCardBean) {
        GMOPaymentBean__c gmoPaymentBean = generateGMOPaymentBeanForPayment(account, order);
        
        if (account.credit_card_number__c == null) {
            gmoPaymentBean.card_number__c = creditCardBean.cc;
            gmoPaymentBean.expire_year__c = creditCardBean.expireYear;
            gmoPaymentBean.expire_month__c = creditCardBean.expireMonth;
            gmoPaymentBean.security_code__c = creditCardBean.cvc;
        }
        
        return gmoPaymentBean;
    }

    public static GMOPaymentBean__c generateGMOPaymentBeanForPayment(Account__c account, Order order) {
        GMOPaymentBean__c gmoPaymentBean = generateGMOPaymentBean(account, order);
        gmoPaymentBean.process_code__c = GMOPaymentAPI.generateProcessCode(order.paymentMethod);
        
        return gmoPaymentBean;
    }

    public static GMOPaymentBean__c generateGMOPaymentBean(Account__c account, Order order) {
        GMOPaymentBean__c gmoPaymentBean = new GMOPaymentBean__c();

        gmoPaymentBean.st_code__c = GMOPaymentAPI.generateStCode(order.paymentMethod);
        gmoPaymentBean.contract_code__c = System.Label.GMOPAYMENT_CONTRACT_CODE;
        gmoPaymentBean.user_id__c = account.Id;
        gmoPaymentBean.user_name__c = account.LastName__c;
        gmoPaymentBean.user_mail_add__c = account.Email__c;
        gmoPaymentBean.card_holder_name__c = account.LastName__c;
        gmoPaymentBean.ip_address__c = ApexUtility.getUserIPAddress();
        gmoPaymentBean.item_code__c = order.itemCode;
        gmoPaymentBean.item_name__c = order.itemName;
        gmoPaymentBean.order_number__c = ApexUtility.generateRandomNumeric(4) + Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.item_price__c = order.totalPrice;

        return gmoPaymentBean;
    }
    
    public static SObject mergeSecondObjectIntoFirstObject(SObject object1, SObject object2) {
        for(SObjectField field:object1.getSObjectType().getDescribe().fields.getMap().values()) {
            try {
                Object opp1Field = object1.get(field);
                Object opp2Field = object2.get(field);
                if (opp2Field != null) 
                    object1.put(field, opp1Field == null ? opp2Field : opp1Field);
            } catch (SObjectException ex) {
            }
        }
        return object1;
    }

    public static SObject copyFirstObjectValuesIntoSecondObject(SObject object1, SObject object2) {
        if (object1 == null || object2 == null)
            return null;
        
        for(SObjectField field : object1.getSObjectType().getDescribe().fields.getMap().values()) {
            try {
                String fieldObject1 = String.valueOf(field);
                Object opp1Field = object1.get(fieldObject1);

                String fieldObject2 = null;
                String[] fieldObject2Possible = new String[] {fieldObject1, fieldObject1 + '__c', fieldObject1.removeEnd('__c')};
                Boolean object2HasKey = false;
                for (Integer i = 0; i < fieldObject2Possible.size(); i++) {
                    if (object2.getSObjectType().getDescribe().fields.getMap().containsKey(fieldObject2Possible[i])) {
                        fieldObject2 = fieldObject2Possible[i];
                        break;
                    }
                }
                
                if (opp1Field != null && fieldObject2 != null)
                    object2.put(fieldObject2, opp1Field);
            } catch (SObjectException ex) {
                throw ex;
            }
        }
	    return object2;
    }
    
}