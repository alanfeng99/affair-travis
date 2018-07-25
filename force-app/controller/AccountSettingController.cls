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
    public Boolean updatedCreditCard {get; set;} 

    public String facebookUserEmail {get; set;}
    public String facebookUserID {get; set;}
    public String facebookUserName {get; set;}
    public String facebookUserToken {get; set;}
    public String googleUserName {get; set;}
    public String googleUserEmail {get; set;}
    public String googleUserID {get; set;}
    
    public AccountSettingController() {
        Cookie accountIdCookie = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        
        if (accountIdCookie != null) {
            String accountId = accountIdCookie.getValue();
        	viewModel = new AccountSettingViewModel(accountId);
            initAccounts();
            updatedCreditCard = ApexPages.currentpage().getparameters().get('updatedCreditCard') == 'true';
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
                addMessage(Apexpages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                showView('Main');
            } 
        }
        return null;
    }

    private Boolean checkPasswordFormat() {
        if (!AuthUtility.checkPassword(viewModel.account.Email__c, viewModel.account.Password__c, accountOld.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_Password_Old);
            return false;
        }
        if (accountNew.Password__c == null) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_PasswordEmpty);
            return false;
        }
        if (!checkPasswordLength(accountNew)) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_Password_New);            
            return false;
        }
        if (!PasswordUtility.checkPasswordHasEnglish(accountNew.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_PasswordFormat);            
            return false;
        }
        if (accountVerify.Password__c == null) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_ValidationEmpty);    
            return false;
        }
        if (!accountNew.Password__c.equals(accountVerify.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_Password_Inconsistent); 
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
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_NameEmpty);
        else {
            if(viewModel.updateName()) {
                addMessage(Apexpages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                showView('Main');
            }
        }
        return null;
    }

    public Pagereference submitEmail() {
        if (viewModel.account.Email__c == null) 
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_EmailEmpty);
        else {
            if (viewModel.updateEmail()) {
                addMessage(Apexpages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                showView('Main');
                ifChangeEmail = true;
                EmailUtility.sendEmail(viewModel.account.Email__c, 'AccountActivation');
                Pagereference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RegisterResultPage');
                page.getParameters().put('id', viewModel.account.Id);
                page.setRedirect(true);

                return page;
            }

            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_AccountAlreadyExist);
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

    public PageReference changeCreditCard() {
        return ApexUtility.toPage('UpdateCreditcardPage');
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

    public void saveLoginCookies(Account__c realAccount) {
        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, Constants.COOKIE_DURATION, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, Constants.COOKIE_DURATION, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});
    }

    public PageReference loginWithFacebook() {
        if (facebookUserToken == null)
            return null;
        
        Account__c accountCreated = AccountModel.createAccountByFacebook(facebookUserEmail, facebookUserName);
        Account__c accountSF = null;
        if (accountCreated == null) {
            accountSF = AccountModel.getAccountByEmail(facebookUserEmail);
            if (accountSF.FacebookEmail__c == null) {
                accountSF.FacebookEmail__c = facebookUserEmail;
                upsert accountSF;
            }
        } else {
            accountSF = accountCreated;
        }

        saveLoginCookies(accountSF);
        return null;
        
    }

    public Pagereference loginWithGoogle() {
        if (googleUserEmail == null)
            return null;
        
        Account__c accountCreated = AccountModel.createAccountByGoogle(googleUserEmail, googleUserName);
        Account__c accountSF = null;
        if (accountCreated == null) {
            accountSF = AccountModel.getAccountByEmail(googleUserEmail);
            if (accountSF.GoogleEmail__c == null) {
                accountSF.GoogleEmail__c = googleUserEmail;
                upsert accountSF;
            }
        } else {
            accountSF = accountCreated;
        }

        saveLoginCookies(accountSF);
        return null;
        
    }

}