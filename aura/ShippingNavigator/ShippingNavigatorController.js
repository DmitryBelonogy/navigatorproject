({
    doinit: function(component, event, helper) {
        helper.initHelper(component, event);
    },
    handleChange: function (component, event) {
        let selectedOptionsList = event.getParam("value");
        component.set("v.selectedOptionsList" , selectedOptionsList);
    },
    createRoute: function(component, event, helper){
        helper.createRoutehelper(component, event);
    },
    updateData: function(component, event, helper){
        helper.updateHelper(component, event);
    },
    handelSelectObject: function(component, event, helper) {
        helper.selectObject(component, event);
    }
});