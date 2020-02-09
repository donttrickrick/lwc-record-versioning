({
    doInit : function(component, event, helper) {
        // $A.get('e.force:closeQuickAction').fire();
        
        // When an option is selected, navigate to the next screen
        var response = event.getSource().getLocalId();
        var navigate = component.get("v.navigateFlow");
        navigate("FINISH");
    }
})