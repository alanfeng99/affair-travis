public with sharing class PaymentResultViewModel {
    public GMOPaymentBean__c gmoPaymentBean {get; set;}

    public PaymentResultViewModel(String orderId) {
        gmoPaymentBean = [SELECT trans_code__c, order_number__c, item_price__c, item_name__c, st_code__c 
                        FROM GMOPaymentBean__c WHERE order_number__c = :orderId];
    }

    public SubscriptionGMOPaymentBean__c getSubGMOPaymentBean(String orderId) {
        SubscriptionGMOPaymentBean__c subGMOPaymentBean = [SELECT GMOPaymentBeanId__c, SubscriptionId__c FROM SubscriptionGMOPaymentBean__c
                            WHERE GMOPaymentBeanId__c = :orderId];

        return subGMOPaymentBean;
    }
}
