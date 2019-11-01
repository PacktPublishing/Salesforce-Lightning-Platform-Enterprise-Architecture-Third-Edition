import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getDriverList from '@salesforce/apex/RaceSetupComponentController.getDriverList';
import addDrivers from '@salesforce/apex/RaceSetupComponentController.addDriversLwc';

const columns = [
    { label: 'Driver', fieldName: 'Name' }
];

export default class RaceSetup extends LightningElement {
    @api
    raceId;
    @wire(getDriverList)
    drivers;
    columns = columns;

    handleCancel() {
        // Notify the parent Aura component to send e.force:closeQuickAction
        this.dispatchEvent(new CustomEvent('close', { detail: null }));
    }
    handleAddDrivers() {
        // Construct list of selected drivers
        var selectedRows = this.template.querySelector('lightning-datatable').getSelectedRows();
        var selectedDrivers = [];
        selectedRows.forEach(element => {
            selectedDrivers.push(element.RecordId);
            });
        // Call Apex controller methods to add drivers
        addDrivers(
                { raceId : this.raceId, 
                  driversToAdd : selectedDrivers  })
            .then(result => {
                // Send toast confirmation to user
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Add Drivers',
                        message: 'Add ' + result + ' drivers.',
                        variant: 'success',
                    }));
                // Notify the parent Aura component to send e.force:closeQuickAction
                this.dispatchEvent(new CustomEvent('added', { detail: result }));
            })
            .catch(error => {
                // Send toast confirmation to user
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Add Drivers',
                        message : error.body.message,
                        variant: 'error',
                    }));
            });            
    }
}