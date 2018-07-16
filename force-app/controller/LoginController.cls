public with sharing class LoginController extends ApexBaseController {
    public LoginViewModel viewModel {get; set;}
    public String facebookUserEmail {get; set;}
    public String facebookUserID {get; set;}
    public String facebookUserName {get; set;}
    public String facebookUserToken {get; set;}
   
    public LoginController() {
        viewModel = new LoginViewModel();
    }

    public Pagereference checkAuthentication() {
        if(viewModel.account.Password__c == null || viewModel.account.Email__c == null) {
            addMessage(Apexpages.Severity.WARNING, '請輸入帳號密碼');
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
        addMessage(Apexpages.Severity.WARNING, 'This user does not exist.');
        clearPassword();
        return false;
    }

    private Boolean resultAccountNotActive() {
        addMessage(Apexpages.Severity.WARNING, '您的帳號未通過驗證，請檢查信箱');
        clearPassword();
        return false;
    }

    private Boolean resultAccountLocked() {
        addMessage(Apexpages.Severity.WARNING, '您的帳號已被鎖定，請聯絡編集者客服');
        clearPassword();
        return false;
    }

    private Boolean resultAccountPasswordNotCorrect(Account__c realAccount) {
        if(realAccount.PasswordRetry__c < 2) {
            addMessage(Apexpages.Severity.WARNING, '帳號或密碼不符，登入三次失敗則帳號鎖定，請小心輸入');
            loginFail(realAccount);
            update realAccount;
        } else {
            addMessage(Apexpages.Severity.WARNING, '您的帳號已被鎖定，請聯絡編集者客服');
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
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, -1, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, -1, false);
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

    public void saveFacebookUserInformation() {
        System.debug('TEST FB USER Email:' + facebookUserEmail);
        System.debug('TEST FB USER id:' + facebookUserID);
        System.debug('TEST FB USER name:' + facebookUserName);
        System.debug('TEST FB USER token:' + facebookUserToken);
    }
}