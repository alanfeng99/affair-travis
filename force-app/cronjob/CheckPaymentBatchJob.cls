public with sharing class CheckPaymentBatchJob implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public Subscription__c subscription {get; set;}
    public String transCode {get; set;}
    
    public CheckPaymentBatchJob(Subscription__c subscriptionParam, String transCodeParam) {
        subscription = subscriptionParam;
        transCode = transCodeParam;
        
    }

    public Database.QueryLocator start(Database.BatchableContext BC) {
        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(null);
        GMOPaymentCheckOrderResultBean checkOrderResult = gmoPaymentAPI.checkOrder(System.Label.GMOPAYMENT_CONTRACT_CODE, transCode);

        if (checkOrderResult.GlobalPayment_result.state == '5') {
            subscription.Payment_status__c = Constants.PAYMENT_STATUS_DONE;
            update subscription;
        }

        String query = 'SELECT Id From account';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext info, List<SObject> opportunities) {}

    public void finish(Database.BatchableContext info) { }

}