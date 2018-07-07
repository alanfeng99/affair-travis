public with sharing class AuthUtility {
    public static Boolean checkPassword(String email, String realpassword, String password) {
        if(realpassword != null && realpassword.equals(password))
            return true;

        return false;
    }

    public static String generateToken() {
        String token = '';
        String dateNow = Datetime.now().format('yyyyMMddHHmmss');

        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        for (Integer i = 0; i < 7; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            token += chars.substring(idx, idx+1);
        }
        token += dateNow;
        for (Integer i = 0; i < 7; i++) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            token += chars.substring(idx, idx+1);
        }
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