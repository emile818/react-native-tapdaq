# react-native-tapdaq
Tapdaq bridge in React Native

## Getting started
`$ npm install react-native-tapdaq --save`

### Mostly automatic installation RN < 0.6
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

- Updated on March 2020 a working version from https://github.com/GieMik8/react-native-tapdaq


- For help contact emile@unicornlab.com


functions:

Name        | Arguments                                                           | Description
------------|-----------                                                          |----------------
js_version     |                   | get the js version 
initialize   | applicationId: string, clientKey: string, config?: TapdaqConfig  |initialize tapdaq
isInitialized     |                   | get the js version 
openTestControls     |                   | get the js version 
setConsentGiven     |                   | get the js version 
setIsAgeRestrictedUser     |                   | get the js version 
setUserSubjectToGDPR     |                   | get the js version 
setUserId     |                   | get the js version 
loadAndShowInterstitial     |       placementTag: string             | get the js version 
loadInterstitial     |     placementTag: string              | get the js version 
showInterstitial     |   placementTag: string                | get the js version 
loadAndShowBanner     |       placementTag: string            | get the js version 
hideBanner     |                   | get the js version 
loadBannerForPlacementTagSize     |   placementTag: string,type: string,x: number,y: number,width: number,height: number,  | get the js version 
loadAndShowRewarded     |      placementTag: string             | get the js version 
loadRewardedVideo     |      placementTag: string             | get the js version 
showRewardedVideo     |        placementTag: string           | get the js version 

