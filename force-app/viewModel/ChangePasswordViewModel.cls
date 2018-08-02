public with sharing class ChangePasswordViewModel {
    public Account account {get; set;}
    public String password {get; set;} 

    public ChangePasswordViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Boolean submit() {
        account.Active__c = true;
        account.Password__c = password;
        return AccountModel.updateAccount(account);
    }
}