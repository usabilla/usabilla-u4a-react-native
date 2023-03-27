declare module 'usabilla-react-native' {
  const UBReactNative: {
    initialize: (appID: string) => void;
    setDebugEnabled: (debugEnabled: boolean) => void;
    onBackPressed: () => void;
    areNavigationButtonsVisible: () => boolean;
    setDefaultNavigationButtonsVisibility: (visible: boolean) => void;
    loadLocalizedStringFile: (localizedStringFile: string) => void;
    localizedStringFile: (formId: string) => void;
    loadFeedbackForm: (formId: string) => void;
    loadFeedbackFormWithCurrentViewScreenshot: (formId: string) => void;
    preloadFeedbackForms: (formIds: string[]) => void;
    removeCachedForms: () => void;
    sendEvent: (event: string) => void;
    resetCampaignData: (callback: (...args: any[]) => any) => void;
    setCustomVariables: (customVariables: any) => void;
    setFormDidLoadSuccessfully: (callback: (...args: any[]) => any) => void;
    setFormDidClose: (callback: (...args: any[]) => any) => void;
    setFormDidFailLoading: (callback: (...args: any[]) => any) => void;
    setCampaignDidClose: (callback: (...args: any[]) => any) => void;
    dismiss: () => void;
    setDataMasking: (masks?: string[], character?: string) => void;
    getDefaultDataMasks: () => string[];
    isUBInitialised: (callback: (...args: any[]) => any) => void;
  };

  export default UBReactNative;
}
