import type { TurboModule } from 'react-native';
import { TurboModuleRegistry, NativeModules } from 'react-native';

/**
 * TypeScript interface for the native Usabilla bridge.
 * All native methods should be defined here for type safety.
 */
export interface UsabillaBridgeSpec extends TurboModule {
  initialize(appId: string): Promise<void> | void;
  setDebugEnabled(debugEnabled: boolean): void;
  onBackPressed(): boolean | void;
  areNavigationButtonsVisible(): Promise<boolean>;
  setDefaultNavigationButtonsVisibility(visible: boolean): void;
  loadLocalizedStringFile?(localizedStringFile: string): void;
  loadFeedbackForm(formId: string, selectedEmoticonImages?: string[], unselectedEmoticonImages?: string[]): void;
  loadFeedbackFormWithCurrentViewScreenshot(formId: string, selectedEmoticonImages?: string[], unselectedEmoticonImages?: string[]): void;
  preloadFeedbackForms(formIds: string[]): void;
  removeCachedForms(): void;
  sendEvent(event: string): void;
  resetCampaignData(callback?: (...args: any[]) => any): void;
  setCustomVariables(customVariables: any): void;
  dismiss(): Promise<boolean>;
  setDataMasking?(masks?: string[], character?: string): void;
  getDefaultDataMasks?(): string[];
  isUBInitialised?(callback: (...args: any[]) => any): void;
}

/**
 * Get the native Usabilla bridge module, supporting both TurboModules and legacy NativeModules.
 */
const turboModule = TurboModuleRegistry.get<UsabillaBridgeSpec>('UsabillaBridge');
const NativeUsabillaBridge: UsabillaBridgeSpec = turboModule || (NativeModules.UsabillaBridge as UsabillaBridgeSpec);

export default NativeUsabillaBridge;