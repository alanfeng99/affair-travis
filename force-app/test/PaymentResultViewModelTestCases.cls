@isTest
public with sharing class PaymentResultViewModelTestCases {
    public static testMethod void testConstructor() {
        GMOPaymentBean__c paymentBean = new GMOPaymentBean__c(contract_code__c = '10081070', order_number__c = '784420180802115557', st_code__c = '00010-00000-00000-00000-00000-00000-00000', trans_code__c = '131551');
        insert paymentBean;
        PaymentResultViewModel viewModel = new PaymentResultViewModel(paymentBean.order_number__c);
        System.assertNotEquals(null, viewModel.gmoPaymentBean);
    }

    public static testMethod void testGetSubGMOPaymentBean_Null_Return_Null() {
        GMOPaymentBean__c paymentBean = new GMOPaymentBean__c(contract_code__c = '10081070', order_number__c = '784420180802115557', st_code__c = '00010-00000-00000-00000-00000-00000-00000', trans_code__c = '131551');
        insert paymentBean;
        PaymentResultViewModel viewModel = new PaymentResultViewModel(paymentBean.order_number__c);
        SubscriptionGMOPaymentBean__c subGMOPaymentBean = viewModel.getSubGMOPaymentBean(paymentBean.order_number__c);
        System.assertEquals(null, subGMOPaymentBean);
    }

    public static testMethod void testGetSubGMOPaymentBean_Not_Null() {
        GMOPaymentBean__c paymentBean = new GMOPaymentBean__c(contract_code__c = '10081070', order_number__c = '784420180802115557', st_code__c = '00010-00000-00000-00000-00000-00000-00000', trans_code__c = '131551');
        insert paymentBean;
        SubscriptionGMOPaymentBean__c tempSubGMOPaymentBean = new SubscriptionGMOPaymentBean__c(GMOPaymentBeanId__c = '784420180802115557');
        insert tempSubGMOPaymentBean;
        PaymentResultViewModel viewModel = new PaymentResultViewModel(paymentBean.order_number__c);
        SubscriptionGMOPaymentBean__c subGMOPaymentBean = viewModel.getSubGMOPaymentBean(paymentBean.order_number__c);
        System.assertNotEquals(null, subGMOPaymentBean);
    }

    public static testMethod void testGetAccount() {
        Account tempAccount = new Account(LastName = 'jin');
        insert tempAccount;
        GMOPaymentBean__c paymentBean = new GMOPaymentBean__c(contract_code__c = '10081070', order_number__c = '784420180802115557', st_code__c = '00010-00000-00000-00000-00000-00000-00000', trans_code__c = '131551');
        insert paymentBean;
        PaymentResultViewModel viewModel = new PaymentResultViewModel(paymentBean.order_number__c);
        Account account = viewModel.getAccount(tempAccount.id);
        System.assertNotEquals(null, account);
    }
}
