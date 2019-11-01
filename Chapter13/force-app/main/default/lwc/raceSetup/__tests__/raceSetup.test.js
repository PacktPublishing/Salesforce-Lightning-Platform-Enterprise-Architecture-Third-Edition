// raceSetup.test.js
import { createElement } from 'lwc';
import RaceSetup from 'c/raceSetup';
import { registerApexTestWireAdapter } from '@salesforce/lwc-jest';
import getDriverList from '@salesforce/apex/RaceSetupComponentController.getDriverList';
import addDrivers from '@salesforce/apex/RaceSetupComponentController.addDriversLwc';
import { ShowToastEventName } from 'lightning/platformShowToastEvent';

// Mock list of Drivers
const mockGetDriverList = require('./data/getDriverList.json');

// Mocking imperative Apex method call
jest.mock(
    '@salesforce/apex/RaceSetupComponentController.addDriversLwc',
    () => {
        return {
            default: jest.fn()
        };
    },
    { virtual: true }
);

// Register as Apex wire adapter. Some tests verify that provisioned values trigger desired behavior.
const getDriverListAdapter = registerApexTestWireAdapter(getDriverList);

describe('c-raceSetup', () => {

    // The jsdom instance is shared across test cases in a single file so reset the DOM
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    // Helper function to wait until the microtask queue is empty. 
    // This is needed for promise timing when calling imperative Apex.
    function flushPromises() {
        // eslint-disable-next-line no-undef
        return new Promise(resolve => setImmediate(resolve));
    }

    // Test: displays drivers
    it('displays drivers', () => {

        // Given
        const element = createElement('c-raceSetup', {
            is: RaceSetup
        });

        // Then
        document.body.appendChild(element);
        getDriverListAdapter.emit(mockGetDriverList);

        // When 
        return Promise.resolve().then(() => {
            const tableEl = element.shadowRoot.querySelector('lightning-datatable');
            expect(tableEl.data.length).toBe(mockGetDriverList.length);
        });
    });
    
    // Test: add drivers success
    it('add drivers success', () => {

        // Given
        const MOCK_APEX_RESPONSE = 2;
        const RACE_ID = 'a02580000050sJmAAI';
        const DRIVER1_ID = 'a015800000AmuwHAAR';
        const DRIVER2_ID = 'a015800000AmuwRAAR';
        const SELECTED_ROWS = 
            [
                {
                    "RecordId": DRIVER1_ID,
                    "Name": "Lewis Hamilton",
                    "Selected": true
                },
                {
                    "RecordId": DRIVER2_ID,
                    "Name": "Sergio Pérez",
                    "Selected": true
                }
            ];
        const EXPECTED_APEX_PARAMETERS  =
            {
                "raceId" : RACE_ID,
                "driversToAdd" : [DRIVER1_ID, DRIVER2_ID]
            };        
        const showToastHandler = jest.fn();
        const addedHandler = jest.fn();
        const element = createElement('c-raceSetup', {
            is: RaceSetup
        });
        element.raceId = RACE_ID;
        element.addEventListener(ShowToastEventName, showToastHandler);
        element.addEventListener('added', addedHandler);
        addDrivers.mockResolvedValue(MOCK_APEX_RESPONSE);

        // Then
        document.body.appendChild(element);
        const tableEl = element.shadowRoot.querySelector('lightning-datatable');            
        tableEl.getSelectedRows = jest.fn().mockReturnValue(SELECTED_ROWS);

        // When 
        const buttonEl = element.shadowRoot.querySelectorAll('lightning-button')[1];
        buttonEl.click();
        return flushPromises().then(() => {
            expect(addDrivers.mock.calls[0][0]).toEqual(EXPECTED_APEX_PARAMETERS);
            expect(addedHandler).toHaveBeenCalled();
            expect(showToastHandler).toHaveBeenCalled();
            expect(showToastHandler.mock.calls[0][0].detail.message).toBe('Add ' + MOCK_APEX_RESPONSE + ' drivers.');
        });
    });

    // Test: add drivers fail
    it('add drivers fail', () => {

        // Given
        const MOCK_APEX_RESPONSE = {
            body: { message: 'Contestants can only be added to scheduled races' },
            ok: false,
            status: 400,
            statusText: 'Bad Request'
        };     
        const SELECTED_ROWS = 
            [
                {
                    "RecordId": 'a015800000AmuwHAAR',
                    "Name": "Lewis Hamilton",
                    "Selected": true
                },
                {
                    "RecordId": 'a015800000AmuwHAAR',
                    "Name": "Sergio Pérez",
                    "Selected": true
                }
            ];
        const showToastHandler = jest.fn();
        const element = createElement('c-raceSetup', {
            is: RaceSetup
        });
        element.addEventListener(ShowToastEventName, showToastHandler);
        addDrivers.mockRejectedValue(MOCK_APEX_RESPONSE);

        // Then
        document.body.appendChild(element);
        const tableEl = element.shadowRoot.querySelector('lightning-datatable');            
        tableEl.getSelectedRows = jest.fn().mockReturnValue(SELECTED_ROWS);

        // When 
        const buttonEl = element.shadowRoot.querySelectorAll('lightning-button')[1];
        buttonEl.click();
        return flushPromises().then(() => {
            expect(showToastHandler).toHaveBeenCalled();
            expect(showToastHandler.mock.calls[0][0].detail.message).toBe('Contestants can only be added to scheduled races');
        });
    });    
});