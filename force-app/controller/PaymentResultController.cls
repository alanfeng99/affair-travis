public with sharing class PaymentResultController {
    public SubscriptionGMOPaymentBean__c subGMOPaymentBean {get; set;}
    public PaymentResultViewModel viewModel {get; set;}
    public Subscription__c subscription {get; set;}
    public Account account {get; set;}
    public String paymentMethod {get; set;}
    public String other_01 {get; set;}
    public String expirationDate {get; set;}

    public PaymentResultController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);

        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
            String orderId = Apexpages.currentPage().getParameters().get('ordernumber');
            viewModel = new PaymentResultViewModel(orderId);
            account = viewModel.getAccount(accountId);
            getPaymentResultInfo(orderId);
        }  
    }

    public Pagereference toUpdateCreditcardPage() {    
      	return ApexUtility.toPage('UpdateCreditcardPage');
    }

    public PageReference toSummaryPage() {
        return ApexUtility.toPage('SummaryPage');
    }
    
    public PageReference toAccountSettingPage() {
    	return ApexUtility.toPage('AccountSettingPage');
    }
    
    public PageReference toSubscriptionManagementPage() {
    	return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public PageReference logOut() {  
        return AuthUtility.logOut();
    } 

    private void getPaymentResultInfo(String orderId) {
        GMOPaymentAPI gmoPaymentAPI = new GMOPaymentAPI(viewModel.gmoPaymentBean);
        paymentMethod = GMOPaymentAPI.getPaymentMethodFromStCode(viewModel.gmoPaymentBean.st_code__c);
        GMOPaymentCheckOrderResultBean checkOrderResult = gmoPaymentAPI.checkOrder(System.Label.GMOPAYMENT_CONTRACT_CODE, viewModel.gmoPaymentBean.trans_code__c);
        if (paymentMethod == Constants.PAYMENT_METHOD_ATM) {
            other_01 = checkOrderResult.GlobalPayment_result.other_01.split('-').get(1);
        } else if (paymentMethod == Constants.PAYMENT_METHOD_SUPER_PAYMENT) {
            other_01 = checkOrderResult.GlobalPayment_result.other_01;
            
            if (other_01.length() == 16) 
                other_01 = other_01.substring(0, 4) +' '+ other_01.substring(4, 8)+ ' ' + other_01.substring(8, 12) + ' ' + other_01.substring(12, 16);
            expirationDate = (Datetime.now().addDays(2)).format('yyyy/MM/dd') ;
        } else {
            subGMOPaymentBean = viewModel.getSubGMOPaymentBean(orderId);
            subscription = SubscriptionModel.getUniqueSubscriptionById(subGMOPaymentBean.SubscriptionId__c);
        }
    }
}
