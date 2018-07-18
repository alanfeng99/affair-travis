public with sharing class NewSubscriptionViewModel {
    public Account__c account {get; set;}
    public String errorMessage {get; set;}
    public CreditCardBean creditCardBean {get; set; }
    
    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
        creditCardBean = new CreditCardBean();
    }

    public Boolean newSubscription(List<Subscription__c> subscriptionInsertList) {
        Boolean updateResult = true;  
        try {
            for (Subscription__c sub : subscriptionInsertList) 
                if (sub.Payment_Method__c == '信用卡')
                    if(creditCardBean.cc != null) {
                        GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBean(account, sub, creditCardBean);
                        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
                        gmoPaymentAPI.executePayment();
                    }

            List<Database.SaveResult> results = Database.insert(subscriptionInsertList);
            
            for (Database.SaveResult result : results) 
                if (result.isSuccess() == false) 
                    updateResult = false;

            if (updateResult) 
                for (Subscription__c sub : subscriptionInsertList) 
                    if (sub.Payment_Method__c == '信用卡') 
                        update account;

            return updateResult;   
        } catch (DmlException ex) {
            errorMessage = ex.getMessage();
            return false;
        }
    }
}