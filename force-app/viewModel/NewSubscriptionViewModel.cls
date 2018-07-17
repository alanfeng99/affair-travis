public with sharing class NewSubscriptionViewModel {
    public Account__c account {get; set;}
    public String errorMessage {get; set;}
    public String cc {get; set;}
    public String expireYear {get; set;}
    public String expireMonth {get; set;}
    public String cvc {get; set;}

    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Boolean newSubscription(List<Subscription__c> subscriptionInsertList) {
        Boolean updateResult = true;  
        try {
            for (Subscription__c sub : subscriptionInsertList) 
                if (sub.Payment_Method__c == '信用卡')
                    if(cc != null)
                       executePayment(sub);

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
        gmoPaymentBean.user_id = account.Id;
        gmoPaymentBean.user_name = account.LastName__c;
        gmoPaymentBean.user_mail_add = account.Email__c;

        if (account.credit_card_number__c == null) {
            gmoPaymentBean.card_number = cc;
            gmoPaymentBean.expire_year = expireYear;
            gmoPaymentBean.expire_month = expireMonth;
            gmoPaymentBean.security_code = cvc;
        }
                
        gmoPaymentBean.card_holder_name = account.LastName__c;
        System.debug(subscription.Id);
        gmoPaymentBean.ip_address = ApexUtility.getUserIPAddress();
        SubscriptionProgram__c program = [SELECT ProgramId__c, ProgramName__c FROM SubscriptionProgram__c WHERE ID = :subscription.Program__c];
        gmoPaymentBean.item_code = program.ProgramId__c;
        gmoPaymentBean.item_name = program.ProgramName__c;
        gmoPaymentBean.order_number = ApexUtility.generateRandomNumeric(4) + Datetime.now().format('yyyyMMddHHmmss');
        gmoPaymentBean.item_price = String.valueOf(subscription.Amount__c);

        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
        gmoPaymentAPI.saveCreditCardZPayment();
    }
}