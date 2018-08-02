public with sharing class AccountSettingViewModel {
    public Account account {get; set;}
    public String newLastName {get; set;}
    public String newEmail {get; set;}
    public String newPassword {get; set;}

    public AccountSettingViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        newLastName = account.LastName;
        newEmail = account.PersonEmail;
    }

    public Boolean updatePasswordAccount() {    
        return AccountModel.updateAccount(account);
    }

    public Boolean updateName() {
        account.LastName = newLastName;
        return AccountModel.updateAccount(account);  
    }

    public Boolean updateEmail() {
        if(checkAccountByEmail(newEmail)) {     
            account.Active__c = false;
            account.PersonEmail = newEmail;
            return AccountModel.updateAccount(account);                    
        }   
    
        return false;
    }

    private Boolean checkAccountByEmail(String email) {
        List<Account> accounts = [Select Id from Account where PersonEmail = :email];
        if (accounts.size() > 0) {
            return false;
        } 
        return true;
    }
}