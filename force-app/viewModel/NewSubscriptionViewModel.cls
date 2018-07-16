public with sharing class NewSubscriptionViewModel {
    public Account__c account {get; set;}
    public String errorMessage {get; set;}

    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Boolean newSubscription(List<Subscription__c> subscriptionInsertList) {
        Boolean updateResult = true;  
        try {
            for (Subscription__c sub : subscriptionInsertList) 
                if (sub.Payment_Method__c == '信用卡') {
                    if(account.credit_card_number__c != null)
                       executePayment(sub);
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
    
    public void executePayment(Subscription__c subscription) {
        GMOPaymentBean gmoPaymentBean = new GMOPaymentBean();

        gmoPaymentBean.contract_code = '10081070';
        gmoPaymentBean.user_id = account.Email__c;
        gmoPaymentBean.user_name = account.LastName__c;
        gmoPaymentBean.user_mail_add = account.Email__c;
        gmoPaymentBean.card_number = EncryptionUtility.decrypt(account.credit_card_number__c);
        gmoPaymentBean.expire_year = account.Expiration_Year_text__c;
        gmoPaymentBean.expire_month = account.Expiration_month__c;
        gmoPaymentBean.security_code = account.CVC__c;
        gmoPaymentBean.card_holder_name = account.LastName__c;
        
        gmoPaymentBean.ip_address = ApexUtility.getUserIPAddress();
        gmoPaymentBean.item_code = subscription.Program__r.ProgramId__c;
        gmoPaymentBean.item_name = subscription.Program__r.ProgramName__c;
        gmoPaymentBean.order_number = ApexUtility.generateRandomNumeric(4) + Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.item_price = String.valueOf(subscription.Amount__c);

        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
        gmoPaymentAPI.saveCreditCardZPayment();
    }
}