public with sharing class NewSubscriptionViewModel {
    public Account__c account {get; set;}
    public String errorMessage {get; set;}
    public CreditCardBean creditCardBean {get; set; }
    
    public NewSubscriptionViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
        creditCardBean = new CreditCardBean();
    }

    public Boolean newSubscription(List<Subscription__c> subscriptionInsertList, String programId) {
        Boolean updateResult = true;  
        try {
            Subscription__c firstSub = subscriptionInsertList.get(0);
            SubscriptionProgram__c program = [SELECT ProgramId__c, ProgramName__c FROM SubscriptionProgram__c WHERE ProgramId__c = :programId];
            
            Order order = new Order();
            order.paymentMethod = firstSub.Payment_method__c;
            order.itemCode = program.ProgramId__c;
            order.itemName = program.ProgramName__c;
            order.totalPrice = String.valueOf(firstSub.Amount__c * subscriptionInsertList.size());
            
            GMOPaymentBean__c gmoPaymentBean = ApexUtility.generateGMOPaymentBeanForPayment(account, order, creditCardBean);
            GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(gmoPaymentBean);
            gmoPaymentBean = gmoPaymentAPI.directPayment();
            
            String transCode = null;
            if (gmoPaymentBean.result__c == '1' && gmoPaymentBean.trans_code__c != null && !String.isBlank(gmoPaymentBean.trans_code__c))
                transCode = gmoPaymentBean.trans_code__c;

            if (transCode == null) {
                errorMessage = System.label.Msg_PayFail;
                return false;
            }

            GMOPaymentCheckOrderResultBean checkOrderResult = gmoPaymentAPI.checkOrder(System.Label.GMOPAYMENT_CONTRACT_CODE, transCode);

            insert gmoPaymentBean;

            for (Subscription__c sub : subscriptionInsertList)
                sub.PaymentInformation__c = checkOrderResult.GlobalPayment_result.other_01;

			List<Database.SaveResult> results = Database.insert(subscriptionInsertList);
            for (Database.SaveResult result : results) 
                if (result.isSuccess() == false) 
                    updateResult = false;
            
            if (updateResult)
                for (Subscription__c sub : subscriptionInsertList)
                    SubscriptionGMOPaymentBean__c subLinkToPayment = new SubscriptionGMOPaymentBean__c(SubscriptionId__c = sub.Id, GMOPaymentBeanId__c = gmoPaymentBean.Id);

            if (updateResult) {
                if (order.paymentMethod == '信用卡' && creditCardBean.cc != null && !String.isBlank(creditCardBean.cc)) {
                    account.credit_card_number__c = CreditcardUtility.hideCreditCardNumber(creditCardBean.cc);
                    update account;
                }
            }
            
            return updateResult;   
        } catch (DmlException ex) {
            errorMessage = ex.getMessage();
            return false;
        }
    }
}