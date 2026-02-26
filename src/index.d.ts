declare module 'usabilla-react-native' {
  export interface UsabillaReactNative {
    initialize(appID: string): Promise<void> | void;
    setDebugEnabled(debugEnabled: boolean): void;
    onBackPressed(): boolean | void;
    areNavigationButtonsVisible(): Promise<boolean>;
    setDefaultNavigationButtonsVisibility(visible: boolean): void;
    loadLocalizedStringFile(localizedStringFile: string): void;
    loadFeedbackForm(formId: string, selectedEmoticonImages?: string[], unselectedEmoticonImages?: string[]): void;
    loadFeedbackFormWithCurrentViewScreenshot(formId: string, selectedEmoticonImages?: string[], unselectedEmoticonImages?: string[]): void;
    preloadFeedbackForms(formIds: string[]): void;
    removeCachedForms(): void;
    sendEvent(event: string): void;
    resetCampaignData(callback?: (...args: any[]) => any): void;
    setCustomVariables(customVariables: any): void;
    setFormDidLoadSuccessfully(callback: (...args: any[]) => any): void;
    setFormDidClose(callback: (...args: any[]) => any): void;
    setFormDidFailLoading(callback: (...args: any[]) => any): void;
    setCampaignDidClose(callback: (...args: any[]) => any): void;
    dismiss(): Promise<boolean>;
    setDataMasking(masks?: string[], character?: string): void;
    getDefaultDataMasks(): string[];
    isUBInitialised(callback: (...args: any[]) => any): void;
  }
  const usabilla: UsabillaReactNative;
  export default usabilla;
}
