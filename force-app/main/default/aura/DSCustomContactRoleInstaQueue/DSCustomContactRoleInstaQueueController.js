({
	addContactRoleToInstaQueue : function(component, event, helper) {
        console.log(component.get('v.recordId'));
		var action = component.get("c.httpPostContactRole");
        action.setParams({
            "record": component.get("v.recordId")
        });
        action.setCallback(this,function(response){console.log(response.getState());console.log(response.getReturnValue());});
        $A.enqueueAction(action);
	}
})