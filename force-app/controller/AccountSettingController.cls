public with sharing class AccountSettingController extends ApexBaseController {
    
    public AccountSettingViewModel viewModel {get; set;}
    public Account__c accountOld {get; set;}
    public Account__c accountNew {get; set;} 
    public Account__c accountVerify {get; set;} 
    private Account__c tempAccount {get; set;}

    public Boolean isMainShow {get; set;}
    public Boolean isChangeName {get; set;}
    public Boolean isChangeEmail {get; set;}
    public Boolean isChangePassword {get; set;}
    public Boolean ifChangeEmail {get; set;}
    
    public AccountSettingController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new AccountSettingViewModel(accountId);
            initAccounts();  
        }  

        showView('Main');
        ifChangeEmail = false;     
    }

    private void initAccounts() {
        accountVerify = new Account__c();
        accountOld = new Account__c();
        accountNew = new Account__c();
    }

    public Pagereference submitPassword() {
        if (!checkPasswordFormat())
            clearPassword();
        else {
            viewModel.account.Password__c = accountNew.Password__c;    
            if (viewModel.updatePasswordAccount()) {
                addMessage(Apexpages.Severity.INFO, '更新成功');
                showView('Main');
            } 
        }
        return null;
    }

    private Boolean checkPasswordFormat() {
        if (!AuthUtility.checkPassword(viewModel.account.Email__c, viewModel.account.Password__c, accountOld.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, '您輸入的舊密碼有誤');
            return false;
        }
        if (accountNew.Password__c == null) {
            addMessage(Apexpages.Severity.ERROR, '請輸入密碼');
            return false;
        }
        if (!checkPasswordLength(accountNew)) {
            addMessage(Apexpages.Severity.ERROR, '新密碼長度不符');            
            return false;
        }
        if (!PasswordUtility.checkPasswordHasEnglish(accountNew.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, '密碼至少需要一個數字和英文');            
            return false;
        }
        if (accountVerify.Password__c == null) {
            addMessage(Apexpages.Severity.ERROR, '請輸入驗證碼');    
            return false;
        }
        if (!accountNew.Password__c.equals(accountVerify.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, '密碼不一致'); 
            return false;
        }

        return true;    
    }

    private Boolean checkPasswordLength(Account__c account) {
        if (account.Password__c.length() < 8)
            return false; 
        
        return true;
    }

    public Pagereference submitName() {
        if (viewModel.account.LastName__c == null) 
            addMessage(Apexpages.Severity.ERROR, '請輸入暱稱');
        else {
            if(viewModel.updateName()) {
                addMessage(Apexpages.Severity.INFO, '更新成功');
                showView('Main');
            }
        }
        return null;
    }

    public Pagereference submitEmail() {
        if (viewModel.account.Email__c == null) 
            addMessage(Apexpages.Severity.ERROR, '請輸入信箱');
        else {
            if (viewModel.updateEmail()) {
                addMessage(Apexpages.Severity.INFO, '更新成功');
                showView('Main');
                ifChangeEmail = true;
                EmailUtility.sendEmail(viewModel.account.Email__c, 'AccountActivation');
                Pagereference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RegisterResultPage');
                page.getParameters().put('id', viewModel.account.Id);
                page.setRedirect(true);

                return page;
            }

            addMessage(Apexpages.Severity.ERROR, '帳號已存在');
        }
        return null;
    }

    public void showView(String view) {
        isMainShow = false; 
        isChangeName = false;
        isChangeEmail = false;
        isChangePassword = false;

        if (view.equals('Main'))
            isMainShow = true;
        else if (view.equals('ChangePassword'))
            isChangePassword = true;
        else if (view.equals('ChangeName'))
            isChangeName = true;
        else if (view.equals('ChangeEmail'))
            isChangeEmail = true;
    }

    private void clearPassword() {
        accountOld.Password__c = '';
        accountNew.Password__c = ''; 
        accountVerify.Password__c = '';
    }

    public PageReference changeName() {
        showView('ChangeName');
        cloneAccount();
        return null; 
    }
    
    public PageReference changeEmail() {
        showView('ChangeEmail');
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
        tempAccount = viewModel.account.clone();
    }

    public void cancelChange() {
		showView('Main');
        rollbackAccount();
    }

    private void rollbackAccount() {
        viewModel.account.LastName__c = tempAccount.LastName__c;
        viewModel.account.Email__c = tempAccount.Email__c;
        viewModel.account.Password__c = tempAccount.Password__c;
    }
    
    public PageReference toSummaryPage(){
        return ApexUtility.toPage('SummaryPage');
    }
    
    public PageReference toAccountSettingPage(){
    	return ApexUtility.toPage('AccountSettingPage');
    }
    
    public PageReference toSubscriptionManagementPage(){
    	return ApexUtility.toPage('SubscriptionManagementPage');
    }
    
    public PageReference logOut() {  
        return AuthUtility.logOut();
    }

}