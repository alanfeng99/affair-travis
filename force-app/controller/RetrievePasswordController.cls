public with sharing class RetrievePasswordController extends ApexBaseController {
    
    public Account__c account {get; set;}
    
    public RetrievePasswordController() {
        account = new Account__c();
    }

    public Pagereference submit() {
        if (account.Email__c != null) {
            if (EmailUtility.sendEmail(account.Email__c, 'PasswordReset') == true) {
                turnActiveFalse(account);
                addMessage(ApexPages.Severity.INFO, '請檢查您的信箱');
                PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RetrievePasswordResultPage');
                page.setRedirect(true);
            
                return page;
            } else {
                addMessage(ApexPages.Severity.ERROR, '此信箱不存在');
            }
        }
        return null;
    }

    private void turnActiveFalse(Account__c account) {
        Account__c realAccount = AccountModel.getAccountByEmail(account.Email__c);
        
        realAccount.Active__c = false;
        update realAccount;
    }
}