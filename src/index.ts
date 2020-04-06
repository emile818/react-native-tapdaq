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


    return new Promise((resolve, reject) => {

      if (config) {
        this.nativeModule.initializeWithConfig(applicationId, clientKey, config)
      }else{
        this.nativeModule.initialize(applicationId, clientKey)
      }
      setTimeout(async () => {
        const isInitialized = await this.isInitialized()
        if(isInitialized){
          resolve(true);
        }else{
          reject(false)
        }
      }, 2000);

    });


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


  public loadAndShowInterstitial = (placementTag: string): Promise<boolean> => {

    return new Promise((resolve, reject) => {
      this.loadInterstitial(placementTag).then((status,error) => {
        if(status){
          this.showInterstitial(placementTag).then((status,error)=>{

            if(status){
              resolve(status);
            }else{
              reject(false)
            }
          })
        }else{
          reject(false)
        }
      })
    });

  }
  public loadInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadInterstitial(placementTag)
  }

  public showInterstitial = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.showInterstitial(placementTag)
  }

  public loadAndShowBanner = (placementTag: string): Promise<boolean> => {

    return new Promise((resolve, reject) => {
      this.loadBannerForPlacementTag(placementTag).then((status,error) => {

        if(status){
          resolve(status);
        }else{
          reject(false)
        }
      })
    });

  }
  public loadBannerForPlacementTag = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.loadBannerForPlacementTag(placementTag)
  }

  public loadBannerForPlacementTagSize = (placementTag: string,type:number,x:number,y:number,width:number,height:number): Promise<boolean> => {
    return this.nativeModule.loadBannerForPlacementTagSize(placementTag,type,x,y,width,height)
  }


  public isRewardedVideoReady = (placementTag: string): Promise<boolean> => {
    return this.nativeModule.isRewardedVideoReady(placementTag)
  }

  public loadAndShowRewarded = (placementTag: string): Promise<boolean> => {

    return new Promise((resolve, reject) => {
      this.loadRewardedVideo(placementTag).then((status,error) => {
        if(status){
          this.showRewardedVideo(placementTag).then((status,error)=>{
            if(status){
              resolve(status);
            }else{
              reject(false)
            }
          })
        }else{
          reject(false)
        }
      })
    });

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
