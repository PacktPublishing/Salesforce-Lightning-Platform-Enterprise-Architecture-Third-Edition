const { jestConfig } = require('@salesforce/lwc-jest/config');
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^lightning/platformShowToastEvent$':
            '<rootDir>/force-app/test/jest-mocks/lightning/platformShowToastEvent'
    }
};
