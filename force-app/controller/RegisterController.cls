public with sharing class RegisterController extends ApexBaseController {
    public RegisterViewModel viewModel {get; set;}

    public RegisterController() {
        viewModel = new RegisterViewModel();       
    }

    public Pagereference register() {      
        if (registerByEmail()) { 
            PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RegisterResultPage');
            page.getParameters().put('id', viewModel.account.Id);
            page.setRedirect(true);
            
            return page;
        }
        return null;
    }

    public Boolean registerByEmail() {
        if (!EmailUtility.emailFormatValidation(viewModel.account.Email__c)) { 
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_EmailFormat);  
            return false;
        }

        if (AccountModel.getAccountByEmail(viewModel.account.Email__c) != null) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_AccountAlreadyExist); 
            return false;
        }

        Account__c accountCreated = AccountModel.createAccountByEmail(viewModel.account.Email__c);
        
        // Jin: no need to check here
        // if (accountCreated == null) {
        //     addMessage(ApexPages.Severity.ERROR, System.Label.Msg_AccountAlreadyExist); 
        //     return false;
        // }
        
        viewModel.account = accountCreated;

        if (EmailUtility.sendEmail(viewModel.account.Email__c, 'AccountActivation'))
            return true;
        
        addMessage(ApexPages.Severity.ERROR, System.Label.Msg_EmailSendFail); 
        return false;
    }
}