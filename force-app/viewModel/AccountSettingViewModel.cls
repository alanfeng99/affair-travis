public with sharing class AccountSettingViewModel {
    public Account__c account {get; set;}

    public AccountSettingViewModel(String userId) {
        account = AccountModel.getAccountById(userId); 
    }

    public Boolean updatePasswordAccount() {    
        return AccountModel.updateAccount(account);
    }

    public Boolean updateName() {
        return AccountModel.updateAccount(account);  
    }

    public Boolean updateEmail() {
        if(checkAccountByEmail(account.Email__c)) {     
            account.Active__c = false;      
            return AccountModel.updateAccount(account);                    
        }   
    
        return false;
    }

    private Boolean checkAccountByEmail(String email) {
        List<Account__c> accounts = [Select Id from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            return false;
        } 
        return true;
    }
}