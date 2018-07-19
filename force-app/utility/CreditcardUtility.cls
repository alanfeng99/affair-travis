public with sharing class CreditcardUtility {
    public CreditcardUtility() {

    }

    public static boolean isCreditCardPattenMatching(String creditCardNumber){
        Pattern MyPattern = Pattern.compile('^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\\d{3})\\d{11})$');
        Matcher MyMatcher = MyPattern.matcher(creditCardNumber);
        return MyMatcher.matches();
    }

    public static boolean isCVCPattenMatching(String cvc){
        Pattern MyPattern = Pattern.compile('[1-9][0-9]{2}');
        Matcher MyMatcher = MyPattern.matcher(cvc);

        return MyMatcher.matches();
    }

    public static String hideCreditCardNumber(String creditCardNumber) {
        return creditCardNumber.substring(0,4) + '****' + creditCardNumber.substring(creditCardNumber.length()-4, creditCardNumber.length());
    }
}
