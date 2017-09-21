({
	getLightningTableData : function(component) {
		var sColumn = component.get("v.fields");
        var sObject = component.get("v.object");
        var action = component.get("c.getsObjectRecords");
        action.setParams({
            ObjectName : sObject,
            fieldstoget : sColumn
        });
        action.setCallback(this,function(response){
        var state = response.getState();
        if(state == 'SUCCESS'){
            var rtnValue = response.getReturnValue();
            component.set("v.mycolumn",rtnValue.tableColumn);
            component.set("v.mydata",rtnValue.tableRecord);
        }
       });
         $A.enqueueAction(action);
	},
    sortData: function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBy(fieldName, reverse))
        cmp.set("v.mydata", data);
    },
    sortBy: function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b > a));
        }
    }
})