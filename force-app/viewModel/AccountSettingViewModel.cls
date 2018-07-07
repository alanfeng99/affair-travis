public with sharing class AccountSettingViewModel {

    public Account__c account {get; set;}
    public Account__c accountOld {get; set;}
    public Account__c accountNew {get; set;} 
    public Account__c accountVerify {get; set;} 
    private Account__c tempAccount {get; set;}
    
    public Boolean isMainShow {get; set;}
    public Boolean isChangeName {get; set;}
    public Boolean isChangeEmail {get; set;}
    public Boolean isChangePassword {get; set;}
    public Boolean ifChangeEmail {get; set;}

    public String errorMessage {get; set;}

    public AccountSettingViewModel(String userId) {
        account = AccountModel.getAccountById(userId);
        initAccounts();
        showView('Main');
        ifChangeEmail = false;
    }

    public Boolean updatePasswordAccount() {
        Boolean result = false;
        
        if (AuthUtility.checkPassword(account.Email__c, account.Password__c, accountOld.Password__c) == false) {
            errorMessage = '您輸入的舊密碼有誤';
        } else if (accountNew.Password__c == null){
            errorMessage = '請輸入密碼';
        } else if (checkPasswordLength(accountNew) == false) {
            errorMessage = '新密碼長度不符';            
        } else if (accountVerify.Password__c == null) {
            errorMessage = '請輸入驗證碼';
        } else if (accountNew.Password__c.equals(accountVerify.Password__c) == false){
            errorMessage = '密碼不一致';
        } else {
            account.Password__c = accountNew.Password__c;
            Database.SaveResult updateResult = Database.update(account);
            result = updateResult.isSuccess();
        }
        
        if (result == false) {
            clearPassword();
        }
        return result;
    }

    private void initAccounts() {
        accountVerify = new Account__c();
        accountOld = new Account__c();
        accountNew = new Account__c();
    }
    
    public Boolean updateName() {
        if(account.LastName__c == null) {
            errorMessage = '請輸入暱稱';
        } else {
            Database.UpsertResult result = Database.upsert(account); 
            return result.isSuccess();  
        }
        return false;
    }

    public Boolean updateEmail() {
        if(account.Email__c == null) {
            errorMessage = '請輸入信箱';
        } else {
        	if(checkAccountByEamil(account.Email__c) == true) {     
                account.Active__c = false; 
                ifChangeEmail = true;     
                Database.UpsertResult result = Database.upsert(account); 
                return result.isSuccess();                       
            }   
        }
        return false;
    }

    private Boolean checkAccountByEamil(String email) {
        List<Account__c> accounts = [Select Id from Account__c where Email__c = :email];
        if (accounts.size() > 0) {
            errorMessage = '帳號已存在';
            return false;
        } 

        return true;
    }

    private Boolean checkPasswordLength(Account__c account) {
        if (account.Password__c.length() < 8) {
            return false;
        }
        return true;
    }

    private void clearPassword() {
        accountOld.Password__c = '';
        accountNew.Password__c = ''; 
        accountVerify.Password__c = '';
    }
    
    public PageReference changeName() {
        isMainShow = false;
        isChangeName = true;
        isChangeEmail = false;
        isChangePassword = false;  
        cloneAccount();
        return null; 
    }
    
    public PageReference changeEmail() {
        isMainShow = false;
        isChangeName = false;
        isChangeEmail = true;
        isChangePassword = false; 
        cloneAccount();
        return null; 
    }
    
    public PageReference changePassword() {
        showView('ChangePassword');
        cloneAccount();
        initAccounts();
        return null;
    }

    private void cloneAccount() {
        tempAccount = account.clone();
    }
    
    public void cancelChange() {
		showView('Main');
        rollbackAccount();
    }

    public void showView(String view) {
        isMainShow = false; 
        isChangeName = false;
        isChangeEmail = false;
        isChangePassword = false;

        if (view.equals('Main')) {
            isMainShow = true;
        } else if (view.equals('ChangePassword')) {
            isChangePassword = true;
        }
    }

    private void rollbackAccount() {
        account.LastName__c = tempAccount.LastName__c;
        account.Email__c = tempAccount.Email__c;
        account.Password__c = tempAccount.Password__c;
    }
}