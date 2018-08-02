public with sharing class RegisterResultViewModel {
    private Account account {get; set;}
    
    public RegisterResultViewModel(String accountId) {
        account = AccountModel.getAccountById(accountId);
    }

    public Account getAccount() {
        return account;
    }
}
