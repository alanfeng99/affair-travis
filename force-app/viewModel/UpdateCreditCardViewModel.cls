public with sharing class UpdateCreditCardViewModel {
    public Account account {get; set;}
    public List<Subscription__c> subscriptions {get; set;}
    public CreditCardBean creditCardBean {get; set;}

    public UpdateCreditCardViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
        creditCardBean = new CreditCardBean();
    }

    public Boolean updateAccount() {
        return AccountModel.updateAccount(account);     
    }

    public Boolean updateSubscription() {
        Order order = new Order();
        order.paymentMethod = Constants.PAYMENT_METHOD_CREDIT_CARD;
        order.itemCode = '0';
        order.itemName = 'Change credit card operation';
        order.totalPrice = '1';
            
        GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBeanForChange(account, order, creditCardBean);
        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
        gmoPaymentBean = gmoPaymentAPI.directPayment();

        String transCode = null;
        if (gmoPaymentBean.result__c == '1' && gmoPaymentBean.trans_code__c != null && !String.isBlank(gmoPaymentBean.trans_code__c))
            transCode = gmoPaymentBean.trans_code__c;

        if (transCode == null)
            return false;

        Boolean cancelPaymentResult = gmoPaymentAPI.cancelPayment(System.Label.GMOPAYMENT_CONTRACT_CODE, transCode);
        insert gmoPaymentBean;

        if (!cancelPaymentResult)
            return false;

        if (creditCardBean.cc != null && !String.isBlank(creditCardBean.cc))
                account.credit_card_number__c = CreditcardUtility.hideCreditCardNumber(creditCardBean.cc);
        update account;
        return true;   
    }
}