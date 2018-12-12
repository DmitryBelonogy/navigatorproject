({
	initHelper : function(component, event) {
        let now = new Date();
        let hours = now.getHours() <= 10 ? '0' + now.getHours() : now.getHours();
        let minutes = now.getMinutes() <= 10 ? '0' + now.getMinutes() : now.getMinutes();
        component.set('v.lastUpdate', hours + ':' + minutes);
		let action = component.get("c.getOrders");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let resp = response.getReturnValue();
                let orders = [];
                for(let i = 0; i < resp.length; i++) {
                    let order = {
                        label: resp[i].address,
                        value: resp[i].coordinates
                    };
                    orders.push(order);
                }
                component.set('v.options', orders);
            }
            else if (state === "INCOMPLETE") {
                this.showToast('INCOMPLETE', 'ERROR', 'error');
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast(errors[0].message, 'ERROR', 'error');
                    }
                } else {
                    this.showToast('Unknown error', 'ERROR', 'error');
                }
            }
        });
        $A.enqueueAction(action);
	},
    createRoutehelper : function(component, event) {
        let orders = component.get("v.selectedOptionsList");
        let wayBack = component.get("v.wayBack");
        let message = {
            orders: orders,
            wayBack: wayBack
        };        
        this.pushDataToMap(component, message);
    },
    pushDataToMap : function(component, data) {
        let vfOrigin = 'https://' + window.location.host.split('.')[0] + '--c.visualforce.com';
        let vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(JSON.stringify(data), vfOrigin);
    },
    updateHelper : function(component, event) {
        this.initHelper(component, event);
        let message = {
            isUpdate: true
        };
        this.pushDataToMap(component, message);
    },
    showToast : function(message, title, type) {
        let toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'title': title,
            'message': message,
            'type': type
        });
        toastEvent.fire();
    }
})