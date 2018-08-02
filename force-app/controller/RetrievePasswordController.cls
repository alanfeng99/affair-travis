public with sharing class RetrievePasswordController extends ApexBaseController {
    public Account account {get; set;}
    
    public RetrievePasswordController() {
        account = new Account();
    }

    public Pagereference submit() {
        if (account.PersonEmail != null) {
            if (EmailUtility.sendEmail(account.PersonEmail, 'PasswordReset') == true) {
                turnActiveFalse(account);
                PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RetrievePasswordResultPage');
                page.setRedirect(true);
            
                return page;
            } else {
                addMessage(ApexPages.Severity.ERROR, System.Label.Msg_EmailNotExist);
            }
        }
        return null;
    }

    private void turnActiveFalse(Account account) {
        Account realAccount = AccountModel.getAccountByEmail(account.PersonEmail);
        
        realAccount.Active__c = false;
        update realAccount;
    }
}