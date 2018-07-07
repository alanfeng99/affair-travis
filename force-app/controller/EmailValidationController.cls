public with sharing class EmailValidationController extends ApexBaseController {
    public Boolean validation {get; set;}
    public String accountId {get; set;}
    public EmailValidationController() {
        accountId = ApexPages.currentpage().getparameters().get('id');
    }

    public void checkAccount() {
        if (accountId != null) {
            if (checkAccountById(accountId) == false) {
                addMessage(ApexPages.Severity.WARNING,'已通過驗證');
            } else {
                addMessage(ApexPages.Severity.WARNING,'驗證成功');
            }
        } else {
            addMessage(ApexPages.Severity.WARNING,'此連結無效');
        }
        validation = false;
    }
    
    private Boolean checkAccountById(String accountId) {
        List<Account> accounts = [Select Id from Account where Id = :accountId and Verified__c = false];
        if (accounts.size() > 0) {
            Account account = accounts.get(0);
            account.Verified__c = true;
            upsert account;
            return true;
        } else {
            return false;
        }
    }
}