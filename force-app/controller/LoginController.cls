public with sharing class LoginController extends ApexBaseController {
    public LoginViewModel viewModel {get; set;}
    public String facebookUserEmail {get; set;}
    public String facebookUserID {get; set;}
    public String facebookUserName {get; set;}
    public String facebookUserToken {get; set;}
    public String googleUserName {get; set;}
    public String googleUserEmail {get; set;}
    public String googleUserID {get; set;}

   
    public LoginController() {
        String logout = ApexPages.currentPage().getParameters().get('logout');
        if (logout != null && logout == 'true')
            AuthUtility.deleteAuthCookies();
        viewModel = new LoginViewModel();
    }

    public Pagereference checkAuthentication() {
        if(viewModel.account.Password__c == null || viewModel.account.Email__c == null) {
            addMessage(Apexpages.Severity.WARNING, System.Label.Msg_Login_AccountPasswordEmpty);
            return null;
        }

        Account__c realAccount = AccountModel.getAccountByEmail(viewModel.account.Email__c);
        if (!isAccountAndPasswordValid(realAccount))
            return null;

        saveLoginCookies(realAccount);
        resetPasswordRetryToZero(realAccount);
        return loginSuccessRedirectionPage();
    }

    public Pagereference checkFacebookAuthentication() {
        return null;
    }

    public Pagereference checkGoogleAuthentication() {
        return null;
    }

    private void clearPassword() {
        viewModel.account.Password__c = '';
    }
    
    private Decimal loginFail(Account__c realAccount) {
        realAccount.PasswordRetry__c ++;
        return realAccount.PasswordRetry__c;
    }

    private Boolean isAccountAndPasswordValid(Account__c realAccount) {
        if (realAccount == null)
            return resultAccountNotExisting();
        if (!realAccount.Active__c)
            return resultAccountNotActive();
        if (realAccount.Locked__c)
            return resultAccountLocked();
        if (!AuthUtility.checkPassword(realAccount.Email__c, realAccount.Password__c, viewModel.account.Password__c))
            return resultAccountPasswordNotCorrect(realAccount);

        return true;
    }

    private Boolean resultAccountNotExisting() {
        addMessage(Apexpages.Severity.WARNING, System.Label.Msg_AccountNotExist);
        clearPassword();
        return false;
    }

    private Boolean resultAccountNotActive() {
        addMessage(Apexpages.Severity.WARNING, System.Label.Msg_Login_AccountNotVerify);
        clearPassword();
        return false;
    }

    private Boolean resultAccountLocked() {
        addMessage(Apexpages.Severity.WARNING, System.Label.Msg_Login_AccountLocked);
        clearPassword();
        return false;
    }

    private Boolean resultAccountPasswordNotCorrect(Account__c realAccount) {
        if(realAccount.PasswordRetry__c < 2) {
            addMessage(Apexpages.Severity.WARNING, System.Label.Msg_Login_LockedRemind);
            loginFail(realAccount);
            update realAccount;
        } else {
            addMessage(Apexpages.Severity.WARNING, System.Label.Msg_Login_AccountLocked);
            AccountModel.lockAccountForThreeTimes(realAccount);    
        }
        clearPassword();
        return false;
    }
    
    public Pagereference checkAutoLogin() {
        Cookie authToken = ApexPages.currentPage().getCookies().get(Label.COOKIE_AUTH_TOKEN);
        Cookie accountId = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        if (authToken != null && accountId != null) {
            addMessage(Apexpages.Severity.INFO, '登入成功:' + viewModel.sessionString);
            Pagereference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/SummaryPage');
            page.setRedirect(true);
            return page;
        }
        return null;
    }

    public void saveLoginCookies(Account__c realAccount) {
        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, Constants.COOKIE_DURATION, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, Constants.COOKIE_DURATION, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});
    }

    public void resetPasswordRetryToZero(Account__c realAccount) {
        realAccount.PasswordRetry__c = 0;
        update realAccount;
    }

    public Pagereference loginSuccessRedirectionPage() {
        addMessage(Apexpages.Severity.INFO, '登入成功:' + viewModel.sessionString);
        Pagereference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/SummaryPage');
        page.setRedirect(true);
        return page;
    }

    public Pagereference loginWithFacebook() {
        if (facebookUserToken == null)
            return null;
        
        Account__c accountCreated = AccountModel.createAccountByFacebook(facebookUserEmail, facebookUserName);
        Account__c accountSF = null;
        if (accountCreated == null) {
            accountSF = AccountModel.getAccountByFacebookEmail(facebookUserEmail);
            if (accountSF.FacebookEmail__c == null) {
                accountSF.FacebookEmail__c = facebookUserEmail;
                upsert accountSF;
            }
        } else {
            accountSF = accountCreated;
        }

        saveLoginCookies(accountSF);
        return loginSuccessRedirectionPage();
        
    }

    public Pagereference loginWithGoogle() {
        if (googleUserEmail == null)
            return null;
        
        Account__c accountCreated = AccountModel.createAccountByGoogle(googleUserEmail, googleUserName);
        Account__c accountSF = null;
        if (accountCreated == null) {
            accountSF = AccountModel.getAccountByGoogleEmail(googleUserEmail);
            if (accountSF.GoogleEmail__c == null) {
                accountSF.GoogleEmail__c = googleUserEmail;
                upsert accountSF;
            }
        } else {
            accountSF = accountCreated;
        }

        saveLoginCookies(accountSF);
        return loginSuccessRedirectionPage();
        
    }
}