import { LightningElement, wire, track } from 'lwc';
import getStandings from '@salesforce/apex/RaceStandingsComponentController.getStandings';

const columns = [
    { label: '', fieldName: 'Position', type: 'number', fixedWidth: 70 },
    { label: 'Driver', fieldName: 'Driver' },
    { label: 'Team', fieldName: 'Team' },
    { label: 'Wins', fieldName: 'Wins', type: 'number', fixedWidth: 70  },
    { label: 'Points', fieldName: 'Points', type: 'number', fixedWidth: 100 }
];

export default class RaceStandings extends LightningElement {
    @track 
    columns = columns;
    @wire(getStandings)
    standings;
}