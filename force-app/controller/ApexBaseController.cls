public virtual class ApexBaseController {

    public ApexBaseController() {
        
    }

    public virtual void addMessage(ApexPages.Severity severity, String message) {
        ApexPages.Message myMsg = new ApexPages.Message(severity,message);
        ApexPages.addMessage(myMsg);
    }

    public virtual Pagereference checkCookie() {
        Cookie authToken = ApexPages.currentPage().getCookies().get(Label.COOKIE_AUTH_TOKEN);
        Cookie accountId = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        if (authToken == null || accountId == null)
            return AuthUtility.logOut();

        return null;
    }
}
