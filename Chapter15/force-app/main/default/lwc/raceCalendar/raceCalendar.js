import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';
import getRaceCalendar from '@salesforce/apex/RaceCalendarComponentController.getRaceCalendar';

export default class RaceCalendar extends LightningElement {

    @wire(CurrentPageReference)
    pageRef;
    @wire(getRaceCalendar)
    calendar;
    currentlySelectedRate;

    handleSelect(event) {
        // Determine selected Race details
        const raceId = event.detail;
        const selectedRace = this.calendar.data.find(race => race.Id === raceId);
        const raceName = selectedRace.Name;
        // Toggle selected Race
        if(this.currentlySelectedRate!=null) {
            this.currentlySelectedRate.selected = false;
        }
        this.currentlySelectedRate = event.currentTarget;
        this.currentlySelectedRate.selected = true;
        // Send raceSelected component event 
        fireEvent(this.pageRef, 'raceSelected', { raceId: raceId, raceName: raceName });
    }
}