import React from 'react'
import { EmitterSubscription, NativeEventEmitter, NativeModules } from 'react-native'
const tapdaqEventEmitter = new NativeEventEmitter(NativeModules.RNTapdaq)
const version = '1.0.27'

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

  public js_version() {
    return version
  }

  public ios_version() {
    return this.nativeModule.versionIOS()
  }

  public initialize = (applicationId: string, clientKey: string, config?: TapdaqConfig): Promise<boolean> => {
    return new Promise((resolve, reject) => {
      let isInitialized = {}
      if (config) {
        isInitialized = this.nativeModule
          .initializeWithConfig(applicationId, clientKey, config)
          .then((status: boolean | PromiseLike<boolean> | undefined, error: any) => {
            if (status) {
              resolve(status)
            } else {
              reject(false)
            }
          })
      } else {
        isInitialized = this.nativeModule
          .initialize(applicationId, clientKey)
          .then((status: boolean | PromiseLike<boolean> | undefined, error: any) => {
            if (status) {
              resolve(status)
            } else {
              reject(false)
            }
          })
      }
    })
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

  public loadAndShowRandomAds = (placementTag: string): Promise<boolean> => {
    let type = Math.floor(Math.random() * 9)
    if (type === 0) {
      return this.loadAndShowStaticInterstitial(placementTag)
    } else if (type === 1) {
      return this.loadAndShowRewardedVideo(placementTag)
    } else if (type === 2) {
      return this.loadAndShowBanner(placementTag)
    } else if (type === 3) {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerLarge', -1, 0, 0, 0)
    } else if (type === 4) {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerMedium', -1, 0, 0, 0)
    } else if (type === 5) {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerFull', -1, 0, 0, 0)
    } else if (type === 6) {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerLeaderboard', -1, 0, 0, 0)
    } else if (type === 7) {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerSmart', -1, 0, 0, 0)
    } else {
      return this.loadBannerForPlacementTagSize(placementTag, 'TDMBannerStandard', -1, 0, 0, 0)
    }
  }

  public loadAndShowStaticInterstitial = (placementTag: string): Promise<boolean> => {
    return new Promise((resolve, reject) => {
      // @ts-ignore
      this.loadInterstitial(placementTag).then((status, error) => {
        if (status) {
          // @ts-ignore
          this.showInterstitial(placementTag).then((status, error) => {
            if (status) {
              resolve(status)
            } else {
              reject(false)
            }
          })
        } else {
          reject(false)
        }
      })
    })
  }
  public loadInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadInterstitial(placementTag)
  }
  public showInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.showInterstitial(placementTag)
  }
  public loadAndShowBanner = (placementTag: string): Promise<boolean> => {
    return new Promise((resolve, reject) => {
      // @ts-ignore
      this.loadBannerForPlacementTag(placementTag).then((status, error) => {
        if (status) {
          resolve(status)
        } else {
          reject(false)
        }
      })
    })
  }
  public loadBannerForPlacementTag = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadBannerForPlacementTag(placementTag)
  }
  public hideBanner = (): Promise<boolean> => {
    return this.nativeModule.hideBanner()
  }
  public loadBannerForPlacementTagSize = (
    placementTag: string,
    type: string,
    x: number,
    y: number,
    width: number,
    height: number,
  ): Promise<boolean> => {
    let newtype = 0
    if (type == 'TDMBannerLarge') {
      newtype = 1
    } else if (type == 'TDMBannerMedium') {
      newtype = 2
    } else if (type == 'TDMBannerFull') {
      newtype = 3
    } else if (type == 'TDMBannerLeaderboard') {
      newtype = 4
    } else if (type == 'TDMBannerSmart') {
      newtype = 5
    } else if (type == 'TDMBannerCustom') {
      newtype = 6
    }
    return this.nativeModule.loadBannerForPlacementTagSize(placementTag, newtype, x, y, width, height)
  }

  public isRewardedVideoReady = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.isRewardedVideoReady(placementTag)
  }

  public loadAndShowRewardedVideo = (placementTag: string): Promise<boolean> => {
    return new Promise((resolve, reject) => {
      // @ts-ignore
      this.loadRewardedVideo(placementTag).then((status, error) => {
        if (status) {
          // @ts-ignore
          this.showRewardedVideo(placementTag).then((status, error) => {
            if (status) {
              resolve(status)
            } else {
              reject(false)
            }
          })
        } else {
          reject(false)
        }
      })
    })
  }
  public loadRewardedVideo = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadRewardedVideo(placementTag)
  }
  public showRewardedVideo = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.showRewardedVideo(placementTag)
  }

  public loadAndShowNative = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadNativeAd(placementTag)
  }
  public loadAndShowStaticVideo = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadAndShowStaticVideo(placementTag)
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
