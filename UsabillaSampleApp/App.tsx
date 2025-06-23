/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */

import React from 'react'
import {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  SafeAreaView,
  TouchableWithoutFeedback,
  PixelRatio,
  TextInput,
} from 'react-native';

import usabilla from 'usabilla-react-native';

/// Usabilla Configuration
// Replace appId with your usabilla app id.
const appId = "YOUR_APP_ID_HERE"
// Replace FormId with your usabilla form id.
const formId = "YOUR_FORM_ID_HERE"
// Replace custom variable with your usabilla custom variable created for targeting specific Campaign..
const customVars = { feature_flag: true };

type Props = {};
type State = { text: string };
export default class App extends Component<Props, State> {

  constructor(props: any) {
    super(props);
    this.state = {text: ''};
    usabilla.initialize(appId);
    usabilla.setDataMasking(usabilla.getDefaultDataMasks(), 'X');
    usabilla.setCustomVariables(customVars);
    usabilla.setFormDidLoadSuccessfully((reminder) => console.log("successfull loading form: ", reminder));
    usabilla.setFormDidFailLoading((reminder) => console.log("Error loading form: ", reminder));
    usabilla.setFormDidClose((reminder) => console.log("Form closed: ", reminder));
    usabilla.setCampaignDidClose((reminder) => console.log("Campaign closed: ", JSON.stringify(reminder)))
  }

  resetCampaignData() {
    usabilla.resetCampaignData(() => {
      console.log("Campaign data is successfully reset!")
    })
  }

  sendEvent(event: string) {
    usabilla.sendEvent(event)
  }

  requestFormWithDefaultScreenshot() {
    
    const footerImage = 'footer';
    const selectedEmoticonImages = [
    'cat_hate',
    'cat_sad',
    'cat_neutral',
    'cat_smile',
    'cat_love'
  ];
  
  const unselectedEmoticonImages = [
    'emoticon_hate',
    'emoticon_sad',
    'emoticon_neutral',
    'emoticon_smile',
    'emoticon_love'
  ];
    usabilla.loadFeedbackForm(formId, selectedEmoticonImages);

    // Uncomment the line below to load the form with a screenshot of the current view.
    //usabilla.loadFeedbackFormWithCurrentViewScreenshot(formId, selectedEmoticonImages, unselectedEmoticonImages);
    console.log("successfull loading loadFeedbackFormWithCustomEmoticons: ");
  }
  render() {
    return (
      <SafeAreaView>
        <View style={styles.container}>
          <View style={styles.top}>
            <Text style={styles.welcome}>Usabilla</Text>
            <Text style={styles.welcome}>React Native</Text>
            <Text style={styles.welcome}>Demo App</Text>
          </View>
          <View style={styles.middle}>
            <View style={styles.showForm}>
              <TouchableWithoutFeedback onPress={this.requestFormWithDefaultScreenshot}>
                <View style={styles.buttonShowForm}>
                  <Text style={styles.textShowForm}>SHOW FORM</Text>
                </View>
              </TouchableWithoutFeedback>
            </View>
            <View style={styles.event}>
              <TextInput
                style={styles.eventInput}
                placeholder="Enter event here"
                onChangeText={(text) => this.setState({ text })}>
              </TextInput>
              <TouchableWithoutFeedback onPress={() => this.sendEvent(this.state.text)}>
                <View style={styles.buttonSend}>
                  <Text style={styles.textSend}>SEND EVENT</Text>
                </View>
              </TouchableWithoutFeedback>
            </View>
            <View style={styles.reset}>
              <TouchableWithoutFeedback onPress={this.resetCampaignData}>
                <View style={styles.buttonReset}>
                  <Text style={styles.textReset}>RESET</Text>
                </View>
              </TouchableWithoutFeedback>
            </View>
          </View>
        </View>
      </SafeAreaView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    width: "100%",
  },
  backgroundImage: {
    width: '100%',
    height: '100%',
  },
  top: {
    marginTop: PixelRatio.roundToNearestPixel(20),
    marginLeft: PixelRatio.roundToNearestPixel(40),
    textAlign: 'left',
  },
  welcome: {
    fontSize: 55 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    color: '#00A5C9',
  },
  middle: {
    marginTop: PixelRatio.roundToNearestPixel(115),
    marginLeft: PixelRatio.roundToNearestPixel(40),
    marginRight: PixelRatio.roundToNearestPixel(40),
    flexDirection: 'column',
  },
  showForm: {
    marginTop: PixelRatio.roundToNearestPixel(0),
  },
  buttonShowForm: {
    backgroundColor: '#00A5C9',
    borderWidth: PixelRatio.roundToNearestPixel(1),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderColor: '#ffffff',
    borderStyle: 'solid',
    width: 'auto',
  },
  textShowForm: {
    textAlign: 'center',
    color: '#ffffff',
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    lineHeight: PixelRatio.roundToNearestPixel(19),
    padding: PixelRatio.roundToNearestPixel(14),
  },
  event: {
    marginTop: PixelRatio.roundToNearestPixel(40),
    flexDirection: 'row',
    display: 'flex',
    height: PixelRatio.roundToNearestPixel(48),
  },
  eventInput: {
    padding: PixelRatio.roundToNearestPixel(10),
    marginRight: PixelRatio.roundToNearestPixel(16),
    borderWidth: PixelRatio.roundToNearestPixel(2),
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    lineHeight: PixelRatio.roundToNearestPixel(19),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderWidth: PixelRatio.roundToNearestPixel(2),
    borderStyle: 'solid',
    borderColor: '#C8D2DA',
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    flex: 0.5,
  },
  buttonSend: {
    backgroundColor: '#ffffff',
    borderWidth: PixelRatio.roundToNearestPixel(1),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderColor: '#00A5C9',
    flex: 0.5,
  },
  textSend: {
    textAlign: 'center',
    color: '#00A5C9',
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    padding: PixelRatio.roundToNearestPixel(12),
  },
  reset: {
    marginTop: PixelRatio.roundToNearestPixel(16),
  },
  buttonReset: {
    backgroundColor: '#ffffff',
    borderWidth: PixelRatio.roundToNearestPixel(1),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderColor: '#00A5C9',
    width: 'auto',
  },
  textReset: {
    textAlign: 'center',
    color: '#00A5C9',
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: 0,
    lineHeight: 19,
    padding: 14,
  },
  bottom: {
    width: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
    bottom: PixelRatio.roundToNearestPixel(0),
  },
});