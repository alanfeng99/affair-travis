public with sharing class AccountSettingController extends ApexBaseController {
    
    public AccountSettingViewModel viewModel {get; set;}
    public Account accountOld {get; set;}
    public Account accountNew {get; set;} 
    public Account accountVerify {get; set;} 
    private Account tempAccount {get; set;}

    public Boolean isMainShow {get; set;}
    public Boolean isChangeName {get; set;}
    public Boolean isChangeEmail {get; set;}
    public Boolean isChangePassword {get; set;}
    public Boolean ifChangeEmail {get; set;}
    public Boolean updatedCreditCard {get; set;}

    public String facebookUserEmail {get; set;}
    public String googleUserEmail {get; set;}

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

    public AccountSettingController(String accountId) {
        viewModel = new AccountSettingViewModel(accountId);
        initAccounts();
        updatedCreditCard = ApexPages.currentpage().getparameters().get('updatedCreditCard') == 'true';      

        showView('Main');
        ifChangeEmail = false;     
    }

    private void initAccounts() {
        accountVerify = new Account();
        accountOld = new Account();
        accountNew = new Account();
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
        if (!AuthUtility.checkPassword(viewModel.account.PersonEmail, viewModel.account.Password__c, accountOld.Password__c)) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_Password_Old);
            return false;
        }

        if (accountNew.Password__c == null) {
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_PasswordEmpty);
            return false;
        }
        
        if (!PasswordUtility.checkPasswordFormat(accountNew.Password__c)) {
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

    public Pagereference submitName() {
        if (viewModel.newLastName == null || String.isBlank(viewModel.newLastName)) 
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
        if (viewModel.newEmail == null || String.isBlank(viewModel.newEmail)) 
            addMessage(Apexpages.Severity.ERROR, System.Label.Msg_EmailEmpty);
        else {
            if (viewModel.updateEmail()) {
                addMessage(Apexpages.Severity.INFO, System.Label.Msg_UpdateCompleted);
                showView('Main');
                ifChangeEmail = true;
                EmailUtility.sendEmail(viewModel.newEmail, 'AccountActivation');
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
        viewModel.account.LastName = tempAccount.LastName;
        viewModel.account.PersonEmail = tempAccount.PersonEmail;
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

    public void saveLoginCookies(Account realAccount) {
        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, Constants.COOKIE_DURATION, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, Constants.COOKIE_DURATION, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});
    }

    public Pagereference linkAccountWithGoogle() {
        if (googleUserEmail == null) {
            addMessage(Apexpages.Severity.ERROR, 'Link Google wrong.');
            return null;
        }
            
        if (AccountModel.getAccountByOnlyGoogleEmail(googleUserEmail) != null) {
            addMessage(Apexpages.Severity.ERROR, 'An account is already linked with this Google account.');
            return null;
        }

        viewModel.account.GoogleEmail__c = googleUserEmail;
        if (!AccountModel.updateAccount(viewModel.account))
            addMessage(Apexpages.Severity.ERROR, 'Link Google wrong.');

        return null;
    }

    public Pagereference linkAccountWithFacebook() {
        if (facebookUserEmail == null) {
            addMessage(Apexpages.Severity.ERROR, 'Link Facebook wrong.');
            return null;
        }
            
        if (AccountModel.getAccountByOnlyFacebookEmail(facebookUserEmail) != null) {
            addMessage(Apexpages.Severity.ERROR, 'An account is already linked with this Facebook account.');
            return null;
        }
            
        viewModel.account.FacebookEmail__c = facebookUserEmail;
        if (!AccountModel.updateAccount(viewModel.account))
            addMessage(Apexpages.Severity.ERROR, 'Link Facebook wrong.');

        return null;
    }
}