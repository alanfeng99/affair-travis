public with sharing class PasswordUtility {
    public PasswordUtility() {

    }

    public static Boolean checkPasswordHasEnglish(String password) {
        Pattern MyPattern = Pattern.compile('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,12}$');
        Matcher MyMatcher = MyPattern.matcher(password);
        return MyMatcher.matches();
    }
}
