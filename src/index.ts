import React from 'react'
import { EmitterSubscription, NativeEventEmitter, NativeModules } from 'react-native'

const tapdaqEventEmitter = new NativeEventEmitter(NativeModules.RNTapdaq)

export interface TapdaqConfig {
  userSubjectToGDPR?: boolean
  consentGiven?: boolean
  isAgeRestrictedUser?: boolean
}

export interface TapdaqReward {
  eventId: string
  name: string
  tag: string
  value: number
  customJson: string
  isValid: boolean
}

class RNTapdaq {
  get nativeModule() {
    return NativeModules.RNTapdaq
  }

  public initialize = (applicationId: string, clientKey: string, config?: TapdaqConfig): Promise<boolean> => {
    if (config) {
      return this.nativeModule.initializeWithConfig(applicationId, clientKey, config)
    }
    return this.nativeModule.initialize(applicationId, clientKey)
  }

  public isInitialized = (): Promise<boolean> => {
    return this.nativeModule.isInitialized()
  }

  public openTestControls = () => {
    this.nativeModule.openTestControls()
  }

  public setConsentGiven = (value: boolean) => {
    this.nativeModule.setConsentGiven(value)
  }

  public setIsAgeRestrictedUser = (value: boolean) => {
    this.nativeModule.setIsAgeRestrictedUser(value)
  }

  public setUserSubjectToGDPR = (value: boolean) => {
    this.nativeModule.setUserSubjectToGDPR(value)
  }

  public setUserId = (id: string) => {
    this.nativeModule.setUserId(id)
  }

  public isInterstitialReady = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.isInterstitialReady(placementTag)
  }

  public loadInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadInterstitial(placementTag)
  }

  public showInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.showInterstitial(placementTag)
  }

  public isRewardedVideoReady = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.isRewardedVideoReady(placementTag)
  }

  public loadRewardedVideo = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadRewardedVideo(placementTag)
  }

  public showRewardedVideo = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.showRewardedVideo(placementTag)
  }

  public addListerner = (callback: (message: string) => any): EmitterSubscription => {
    return tapdaqEventEmitter.addListener('tapdaq', callback)
  }

  public addOnRewardListener = (callback: (info: TapdaqReward) => any): EmitterSubscription => {
    return tapdaqEventEmitter.addListener('tapdaqReward', callback)
  }
}

export { default as MediatedNativeAd } from './components/MediatedNativeAd'

export default new RNTapdaq()
