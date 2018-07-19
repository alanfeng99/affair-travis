public with sharing class NewSubscriptionViewModel {
    public Account__c account {get; set;}
    public String errorMessage {get; set;}
    public CreditCardBean creditCardBean {get; set; }
    
    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
        creditCardBean = new CreditCardBean();
    }

    public Boolean newSubscription(Subscription__c subscriptionToInsert, List<SubscriptionRecipient__c> recipients) {
        Boolean updateResult = true;  
        try {
            if (subscriptionToInsert.Payment_Method__c == '信用卡' && updateResult == true) {
                    GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBean(account, subscriptionToInsert, creditCardBean);
                    GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
                    updateResult = gmoPaymentAPI.executePayment() == null? false:true;
            }
            if (updateResult != true) {
                errorMessage = 'Payment went wrong.';
                return false;
            }

            Database.SaveResult dbInsertResult = Database.insert(subscriptionToInsert);
            updateResult = dbInsertResult.isSuccess();
            
            if (updateResult)
                for (SubscriptionRecipient__c recipient : recipients)
                    recipient.ParentSubscription__c = subscriptionToInsert.Id;

            List<Database.SaveResult> dbInsertRecipientsResults = Database.insert(recipients);
            for (Database.SaveResult dbInsertRecipientsResult : dbInsertRecipientsResults)
                if (!dbInsertRecipientsResult.isSuccess())
                    updateResult = false;

            if (updateResult)
                if (subscriptionToInsert.Payment_Method__c == '信用卡' && creditCardBean.cc != null && !String.isBlank(creditCardBean.cc))
                    account.credit_card_number__c = CreditcardUtility.hideCreditCardNumber(creditCardBean.cc);
            
            return updateResult;   
        } catch (DmlException ex) {
            errorMessage = ex.getMessage();
            return false;
        }
    }
}