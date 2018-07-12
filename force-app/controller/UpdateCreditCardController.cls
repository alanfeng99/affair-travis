public with sharing class UpdateCreditCardController extends ApexBaseController {
    public UpdateCreditCardViewModel viewModel {get; set;}
    private Account__c tempAccount {get; set;}
    public List<SelectOption> year {get; set;}
    public String subscriptionId {get; set;} 

    public UpdateCreditCardController() {
		Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	subscriptionId = ApexPages.currentpage().getparameters().get('subscriptionId');
            viewModel = new UpdateCreditCardViewModel(accountId);  
            tempAccount = viewModel.account.clone();
            viewModel.account.CVC__c = '';
        }    
    }

    public Pagereference updateCreditcard() {
        if (checkField()) {
            if (viewModel.account.credit_card_number__c != null && !String.isBlank(viewModel.account.credit_card_number__c))
                viewModel.account.credit_card_number__c = EncryptionUtility.encrypt(viewModel.account.credit_card_number__c);

            if(viewModel.updateAccount()) 
                if(updateReplenish()) {
                    addMessage(ApexPages.Severity.INFO, '更新成功');
                    PageReference page = ApexUtility.toPage('SubscriptionManagementPage');
                    page.getParameters().put('updateCreditcard','true');
                    return page;    
                }     
        }      
        return null;
    }

    public Pagereference cancel() {
        rollbackAccount();  
        return ApexUtility.toPage('SubscriptionManagementPage');
    }

    public List<SelectOption> getCreditcard_Year (){
        year = new List<SelectOption>();
        Integer yearFornow = Integer.valueOf(System.now().format('Y'));
        year.add(new SelectOption('','--None--'));
        for(Integer i=0; i<13; i++){
            year.add(new SelectOption(String.valueOf(yearFornow + i),String.valueOf(yearFornow + i)));
        }
        return year;
    }

    private Boolean checkField() {
        if (viewModel.account.credit_card_number__c == null){
            addMessage(ApexPages.Severity.ERROR, '請填寫信用卡卡號');
            return false;
        } 

        if (viewModel.account.Expiration_month__c == null) {
            addMessage(ApexPages.Severity.ERROR, '請選擇到期月份');
            return false;
        } 
        
        if (viewModel.account.Expiration_Year_text__c == null || viewModel.account.Expiration_Year_text__c == '') {
            addMessage(ApexPages.Severity.ERROR, '請選擇到期年份');
            return false;
        } 
        
        if (viewModel.account.CVC__c == null) {
            addMessage(ApexPages.Severity.ERROR, '請填寫CVC');
            return false;
        } 
        
        if (!CreditcardUtility.isCreditCardPattenMatching(viewModel.account.credit_card_number__c)) {
            addMessage(ApexPages.Severity.ERROR, '請確認您填寫的信用卡號是否正確');
            return false;
        } 

        if (!CreditcardUtility.isCVCPattenMatching(viewModel.account.CVC__c)) {
            addMessage(ApexPages.Severity.ERROR, '請檢查CVC填寫是否正確');
            return false;
        }

        return true;
    }
    
    private boolean updateReplenish() {
        for(Subscription__c sub : viewModel.subscriptions) {
            if(sub.id == subscriptionId) {
                sub.isReplenish__c = true;
                if(!viewModel.updateSubscription(sub))
                    return false; 
            }
        }
        return true;
    }

    private void rollbackAccount() {
        viewModel.account.credit_card_number__c = tempAccount.credit_card_number__c;
        viewModel.account.Expiration_month__c = tempAccount.Expiration_month__c;
        viewModel.account.CVC__c = tempAccount.CVC__c;
    }
}