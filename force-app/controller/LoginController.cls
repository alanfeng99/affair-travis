public with sharing class LoginController extends ApexBaseController {
    public LoginViewModel viewModel {get; set;}
    private Integer loginFailTimes {get; set;}
   
    public LoginController() {
        viewModel = new LoginViewModel();
        loginFailTimes = 0;
    }

    public Pagereference checkAuthentication() {
        if(viewModel.account.Password__c == null || viewModel.account.Email__c == null) {
            addMessage(Apexpages.Severity.WARNING, '請輸入帳號密碼');
            return null;
        }

        Account__c realAccount = AccountModel.getAccountByEmail(viewModel.account.Email__c);
        if (!isAccountAndPasswordValid(realAccount))
            return null;

        addMessage(Apexpages.Severity.INFO, '登入成功:' + viewModel.sessionString);
        Pagereference page = new Pagereference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/SummaryPage');
        page.setRedirect(true);
        return page;
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
    
    private Integer loginFail() {
        loginFailTimes ++;

        return loginFailTimes;
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

        String token = AccountModel.saveToken(realAccount);
        Cookie authToken = new Cookie(Label.COOKIE_AUTH_TOKEN, token, null, -1, false);
        Cookie accountId = new Cookie(label.COOKIE_ACCOUNT_ID, realAccount.Id, null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});
        
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
        if(loginFailTimes < 2) {
            addMessage(Apexpages.Severity.WARNING, '帳號或密碼不符，如果連續登入三次失敗，則帳號鎖定，請小心輸入');
            loginFail();
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
}