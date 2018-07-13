public with sharing class AuthUtility {
    public static Boolean checkPassword(String email, String realpassword, String password) {
        if(realpassword != null && realpassword.equals(password))
            return true;

        return false;
    }

    public static String generateToken() {
        String dateNow = Datetime.now().format('yyyyMMddHHmmss');

        String token = '';

        token += ApexUtility.generateRandomAlphaNumeric(7);        
        token += dateNow;
        token += ApexUtility.generateRandomAlphaNumeric(7);
        return token;
    }

    public static PageReference logOut() {
        PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/LoginPage');
        page.setRedirect(true);
        Cookie authToken = ApexPages.currentPage().getCookies().get(Label.COOKIE_AUTH_TOKEN);
        Cookie accountId = ApexPages.currentPage().getCookies().get(Label.COOKIE_ACCOUNT_ID);
        if (authToken != null) {
            authToken = new Cookie(authToken.getName(), authToken.getValue(), authToken.getPath(), 0, authToken.isSecure());
        }
        if (accountId != null) {
            accountId = new Cookie(accountId.getName(), authToken.getValue(), accountId.getPath(), 0, accountId.isSecure());
        }
        ApexPages.currentPage().setCookies(new Cookie[]{authToken, accountId});

        return page;
    }
}