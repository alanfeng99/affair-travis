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
            for (Subscription__c sub : subscriptionInsertList) {
                if (sub.Payment_Method__c == '信用卡' && updateResult == true) {
                        GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBean(account, sub, creditCardBean);
                        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
                        updateResult = gmoPaymentAPI.executePayment();
                }
            }
            if (updateResult != true) {
                errorMessage = 'Payment went wrong.';
                return false;
            }
            
            List<Database.SaveResult> results = Database.insert(subscriptionInsertList);
            
            for (Database.SaveResult result : results) 
                if (result.isSuccess() == false) 
                    updateResult = false;

            if (creditCardBean.cc != null && !String.isBlank(creditCardBean.cc))
                account.credit_card_number__c = creditCardBean.cc.substring(0,4) + '****' + creditCardBean.cc.substring(creditCardBean.cc.length()-4, creditCardBean.cc.length());
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