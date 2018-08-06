public with sharing class PaymentCallBatchJob implements Database.Batchable<SObject>, Database.AllowsCallouts {
    public Account account {get; set;}
    public Order order {get; set;}
    public GMOPaymentBean__c gmoPaymentBean {get; set;}

    public PaymentCallBatchJob(Account accountParam, Order orderParam) {
        account = accountParam;
        order = orderParam;
    }

    public Database.QueryLocator start(Database.BatchableContext BC) 
    { 
        GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBeanForPayment(account, order);
        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);

        gmoPaymentBean = gmoPaymentAPI.directPayment();

        insert gmoPaymentBean;
        
        String query = 'SELECT Id FROM GMOPaymentBean__c where Id = ' + gmoPaymentAPI.Id;
        return Database.getQueryLocator(query);

        
    }

    public void execute(Database.BatchableContext info, List<SObject> opportunities) {}

    public void finish(Database.BatchableContext info) { }

}