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
            if (account.credit_card_number__c != null && String.isBlank(account.credit_card_number__c))
                    account.credit_card_number__c = EncryptionUtility.encrypt(account.credit_card_number__c);
            Database.UpsertResult result = Database.upsert(account);
            return result.isSuccess();    
        }

        return false;    
    }

    public Boolean checkField() {
        Boolean result = false;

        if (account.credit_card_number__c == null){
            errorMessage = '請填寫信用卡卡號';
        } else if (!CreditcardUtility.isCreditCardPattenMatching(account.credit_card_number__c)) {
            errorMessage = '請確認您填寫的信用卡號是否正確';
        } else if (account.Expiration_month__c == null) {
            errorMessage = '請選擇到期月份';
        } else if (account.Expiration_Year_text__c == null || account.Expiration_Year_text__c == '') {
            errorMessage = '請選擇到期年份';
        } else if (account.CVC__c == null) {
            errorMessage = '請填寫CVC';
        } else if (!CreditcardUtility.isCVCPattenMatching(account.CVC__c)) {
            errorMessage = 'CVC須填三碼(數字)';
        } else {
            result = true;
        }

        return result;
    }

    public void rollbackAccount() {
        account.credit_card_number__c = tempAccount.credit_card_number__c;
        account.Expiration_month__c = tempAccount.Expiration_month__c;
        
        account.CVC__c = tempAccount.CVC__c;
    }
}