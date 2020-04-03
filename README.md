Updated on March 2020 a working version from https://github.com/GieMik8/react-native-tapdaq
# react-native-tapdaq

Tapdaq bridge in React Native

## Getting started

`$ npm install react-native-tapdaq --save`

### Mostly automatic installation

`$ react-native link react-native-tapdaq`

## Usage


`import RNTapdaq from 'react-native-tapdaq'`

`await RNTapdaq.initialize(applicationId, clientKey,TapdaqConfig);`

`RNTapdaq.loadInterstitial("default");`

```
TapdaqConfig {
    userSubjectToGDPR?: boolean
    consentGiven?: boolean
    isAgeRestrictedUser?: boolean
}


```For help contact emile@unicornlab.com
