public with sharing class PaymentResultViewModel {
    public GMOPaymentBean__c gmoPaymentBean {get; set;}

    public PaymentResultViewModel(String orderId) {
        gmoPaymentBean = [SELECT trans_code__c, order_number__c, item_price__c, item_name__c, st_code__c, user_id__c 
                        FROM GMOPaymentBean__c WHERE order_number__c = :orderId];
    }

    public SubscriptionGMOPaymentBean__c getSubGMOPaymentBean(String orderId) {
        List<SubscriptionGMOPaymentBean__c> subGMOPaymentBeans = [SELECT GMOPaymentBeanId__c, SubscriptionId__c FROM SubscriptionGMOPaymentBean__c
                            WHERE GMOPaymentBeanId__c = :orderId];
        if (subGMOPaymentBeans.size() != 1) 
            return null;

        return subGMOPaymentBeans.get(0);
    }

    public Account getAccount(String accountId) {
        Account account = AccountModel.getAccountById(accountId);
        return account;
    }
}
