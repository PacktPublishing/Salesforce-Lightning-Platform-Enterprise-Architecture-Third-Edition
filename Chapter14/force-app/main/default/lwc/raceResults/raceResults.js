import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import getRaceResults from '@salesforce/apex/RaceResultsComponentController.getRaceResults';

const columns = [
    { label: 'Driver', fieldName: 'Driver' },
    { label: 'Team', fieldName: 'Team' },
    { label: 'Grid', fieldName: 'Grid', type: 'number', fixedWidth: 70 },
    { label: 'Race Time', fieldName: 'RaceTime' },
    { label: 'Points', fieldName: 'Points', type: 'number', fixedWidth: 100 }
];

export default class RaceResults extends LightningElement {

    // Public properties
    @api
    recordId;

    // Internal properties
    @wire(CurrentPageReference) 
    pageRef;
    @wire(getRaceResults, { raceId: '$recordId' })
    results;
    @track
    columns = columns;
    @track
    raceName = '';
    get raceTitle() {
        return 'Results ' + this.raceName;
    }

    /**
     * Listen to raceSelected component event to update the race results
     */
    connectedCallback() {
        registerListener('raceSelected', this.handleRaceSelected, this);
    }    
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    /**
     * Update the bound raceId to the @wire to refresh race details
     * @param {} race 
     */
    handleRaceSelected(race) {
        this.recordId = race.raceId;
        this.raceName = race.raceName;
    }
}