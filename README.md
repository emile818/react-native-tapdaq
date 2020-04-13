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



functions:

Name        | Arguments                                                           | Description
------------|-----------                                                          |----------------
js_version     |                   | get the version of this dependencies
initialize   | applicationId: string, clientKey: string, config?: TapdaqConfig  |initialize tapdaq
isInitialized     |                   | test if tapdaq is is Initialized or not 
openTestControls     |                   | open the test controls 
setConsentGiven     |      value: boolean             | set Consent Given
setIsAgeRestrictedUser     |    value: boolean               |setIsAgeRestrictedUser
setUserSubjectToGDPR     |     value: boolean              | set User Subject To GDPR
setUserId     |          id: string         | get the js version 
loadAndShowInterstitial     |       placementTag: string             | load And Show Interstitial  banner
loadInterstitial     |     placementTag: string              | load the Interstitial
showInterstitial     |   placementTag: string                | show the Interstitial 
loadAndShowBanner     |       placementTag: string            | load and show the banner 
hideBanner     |                   | hide the banner
loadBannerForPlacementTagSize     |   placementTag: string,type: string,x: number,y: number,width: number,height: number,  | load and show the banner for specific stype and properties
loadAndShowRewarded     |      placementTag: string             | load And ShowRewarded banner 
loadRewardedVideo     |      placementTag: string             | load the Rewarded Video 
showRewardedVideo     |        placementTag: string           | show the Rewarded Video banner


```
TapdaqConfig {
    userSubjectToGDPR?: boolean
    consentGiven?: boolean
    isAgeRestrictedUser?: boolean
}

- Updated on March 2020 a working version from https://github.com/GieMik8/react-native-tapdaq


- For help contact emile@unicornlab.com

