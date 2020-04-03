import React, { useState, ReactElement } from 'react'
import { requireNativeComponent, UIManager, findNodeHandle, ViewStyle, NativeSyntheticEvent } from 'react-native'

const TapdaqNativeAdView = requireNativeComponent('TapdaqMediatedNativeAdView')
const TapdaqNativeAdViewConfig = UIManager.getViewManagerConfig('TapdaqMediatedNativeAdView')

interface TapdaqAd {
  placement?: string
  hasVideoContent?: boolean
}

interface MediatedNativeAdProps {
  placement: string
  onLoadStart?: (e: NativeSyntheticEvent<any>) => void
  onClick?: (e: NativeSyntheticEvent<any>) => void
  onError?: (e: NativeSyntheticEvent<any>) => void
  onLoad?: (e: NativeSyntheticEvent<TapdaqAd>) => void
  onDestroy?: (e: NativeSyntheticEvent<any>) => void
  style?: ViewStyle
  imageStyle?: ViewStyle
}

const styles = {
  root: {
    width: '100%',
    height: 290,
    opacity: 1,
  },
}

// TODO: do not use Hooks
const MediatedNativeAd = (compProps: MediatedNativeAdProps): ReactElement<MediatedNativeAdProps> => {
  const {
    style = {},
    imageStyle = {},
    onLoadStart = () => null,
    onClick = () => null,
    onError = () => null,
    onLoad = () => null,
    onDestroy = () => null,
    placement = 'default',
    ...other
  } = compProps

  const [ad, setAd] = useState<TapdaqAd>({})
  const [ready, setReady] = useState<boolean>(false)
  let ref = React.createRef()

  const finalStyle = { ...styles.root, ...style }
  if (!ready) {
    finalStyle.height = 0
    finalStyle.opacity = 0
  }

  const localOnLoad = (e: NativeSyntheticEvent<TapdaqAd>) => {
    setReady(true)
    setAd(e.nativeEvent)
    if (compProps.onLoad) {
      compProps.onLoad(e)
    }
  }

  const localOnLoadStart = (e: NativeSyntheticEvent<any>) => {
    setReady(false)
    setAd({})
    if (compProps.onLoadStart) {
      compProps.onLoadStart(e)
    }
  }

  // const destroyNativeAd = () => {
  //   setReady(false)
  //   UIManager.dispatchViewManagerCommand(findNodeHandle(ref), TapdaqNativeAdViewConfig.Commands.destroyAd, [])
  // }

  // const playNativeAdVideo = () => {
  //   if (!ad.hasVideoContent) {
  //     return
  //   }
  //   UIManager.dispatchViewManagerCommand(findNodeHandle(ref), TapdaqNativeAdViewConfig.Commands.playAd, [])
  // }

  // const pauseNativeAdVideo = () => {
  //   if (!ad.hasVideoContent) {
  //     return
  //   }
  //   UIManager.dispatchViewManagerCommand(findNodeHandle(ref), TapdaqNativeAdViewConfig.Commands.pauseAd, [])
  // }

  return (
    <TapdaqNativeAdView
      ref={(r: any) => {
        ref = r
      }}
      {...other}
      placement={placement}
      style={finalStyle}
      onLoad={localOnLoad}
      onLoadStart={localOnLoadStart}
      onClick={onClick}
      onError={onError}
      onDestroy={onDestroy}
    />
  )
}

export default MediatedNativeAd
