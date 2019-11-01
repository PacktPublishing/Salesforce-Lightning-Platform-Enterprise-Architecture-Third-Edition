const { jestConfig } = require('@salesforce/lwc-jest/config');
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^lightning/platformShowToastEvent$':
            '<rootDir>/force-app/test/jest-mocks/lightning/platformShowToastEvent'
    },
    "reporters": [
        "default",
        [
        "jest-junit",
            {
                suiteName: "lwc tests",
                outputName: "./lwc.junit.xml"
            }
        ]
    ]
};
