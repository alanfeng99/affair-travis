public with sharing class RegisterController extends ApexBaseController {
    public RegisterViewModel viewModel {get; set;}

    public RegisterController() {
        viewModel = new RegisterViewModel();       
    }

    public Pagereference register() {
        Boolean result = viewModel.registerByEmail();
        
        if (result == false) { 
            addMessage(ApexPages.Severity.ERROR,viewModel.getErrorMessage());
        } else {
            PageReference page = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/RegisterResultPage');
            page.getParameters().put('id', viewModel.account.Id);
            page.setRedirect(true);
            
            return page;
        }
        return null;
    }
}