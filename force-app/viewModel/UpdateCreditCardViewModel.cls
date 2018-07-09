public with sharing class UpdateCreditCardViewModel {

    private Account__c account;
    public List<Subscription__c> subscriptions {get; set;}
    private Account__c tempAccount {get; set;}
    public String errorMessage {get; set;}

    public UpdateCreditCardViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        subscriptions = SubscriptionModel.getSubscriptionsByUserId(userId);
        tempAccount = account.clone();
        
        account.CVC__c = '';
    }

    public Account__c getAccount() {
        return account;
    }

    public Boolean updateAccount() {
        if(checkField() == true){
            
            Database.UpsertResult result = Database.upsert(account);
            return result.isSuccess();    
        }

        return false;    
    }

    public Boolean checkField() {
        Boolean result = false;

        if (account.credit_card_number__c == null){
            errorMessage = '請填寫信用卡卡號';
        } else if (!isCreditCardPattenMatching(account.credit_card_number__c)) {
            errorMessage = '請確認您填寫的信用卡號是否正確';
        } else if (account.Expiration_month__c == null) {
            errorMessage = '請選擇到期月份';
        } else if (account.Expiration_Year_text__c == null) {
            errorMessage = '請選擇到期年份';
        } else if (account.CVC__c == null) {
            errorMessage = '請填寫CVC';
        } else if (account.CVC__c.length() != 3) {
            errorMessage = 'CVC須填三碼';
        } else {
            result = true;
        }

        return result;
    }

    private boolean isCreditCardPattenMatching(String str){
        boolean hasEng = false;
        Pattern MyPattern = Pattern.compile('^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$');
        Matcher MyMatcher = MyPattern.matcher(str);

        return MyMatcher.matches();
    }

    public void rollbackAccount() {
        account.credit_card_number__c = tempAccount.credit_card_number__c;
        account.Expiration_month__c = tempAccount.Expiration_month__c;
        
        account.CVC__c = tempAccount.CVC__c;
    }
}