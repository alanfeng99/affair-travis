public with sharing class RegisterResultViewModel {
    private Account__c account {get; set;}
    
    public RegisterResultViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Account__c getAccount() {
        return account;
    }
}
