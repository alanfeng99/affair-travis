public with sharing class ChangePasswordViewModel {
    public Account__c account {get; set;}   

    public ChangePasswordViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Boolean submit() {
        account.Active__c = true;
        return AccountModel.updateAccount(account);
    }
}