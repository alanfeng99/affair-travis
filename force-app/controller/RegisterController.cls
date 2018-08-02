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
            AuthUtility.deleteAuthCookies();
            
            return page;
        }
        return null;
    }

    public Boolean registerByEmail() {
        if (!EmailUtility.emailFormatValidation(viewModel.email)) { 
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_EmailFormat);  
            return false;
        }

        if (AccountModel.getAccountByEmail(viewModel.email) != null) {
            addMessage(ApexPages.Severity.ERROR, System.Label.Msg_AccountAlreadyExist); 
            return false;
        }

        Account accountCreated = AccountModel.createAccountByEmail(viewModel.email);
                
        viewModel.account = accountCreated;

        if (EmailUtility.sendEmail(viewModel.email, 'AccountActivation'))
            return true;
        
        addMessage(ApexPages.Severity.ERROR, System.Label.Msg_EmailSendFail); 
        return false;
    }
}