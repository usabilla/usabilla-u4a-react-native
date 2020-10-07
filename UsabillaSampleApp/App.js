import React, { Component } from 'react';
import { Platform, PixelRatio, StyleSheet, SafeAreaView,Text, TextInput, View, Image, ImageBackground, TouchableWithoutFeedback} from 'react-native';
import usabilla from 'usabilla-react-native';
import { bgImage,logo } from './assets/images';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\nCmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\nShake or press menu button for dev menu',
})

export default class App extends Component<{}> {
  constructor() {
    super()
    this.state = {text: ''}
    usabilla.initialize("YOUR_APP_ID_HERE")
    usabilla.setDataMasking(usabilla.getDefaultDataMasks(), 'X');
    var customVars = {"test": 1};
    usabilla.setCustomVariables(customVars);
    usabilla.setFormDidLoadSuccessfully((reminder) => console.log("successfull loading form: ", reminder));
    usabilla.setFormDidFailLoading((reminder) => console.log("Error loading form: ", reminder));
    usabilla.setFormDidClose((reminder) => console.log("Form closed: ", reminder));
    usabilla.setCampaignDidClose((reminder) => console.log("Campaign closed: ",JSON.stringify(reminder)))
  }

  resetCampaignData() {
      usabilla.resetCampaignData(()=> {
          console.log("Campaign data is successfully reset!")
      })
  }

  sendEvent(event) {
   usabilla.sendEvent(event)
  }

  requestFormWithDefaultScreenshot() {
    usabilla.loadFeedbackFormWithCurrentViewScreenshot("YOUR_FORM_ID_HERE")
  }

  render() {
    return (
    <SafeAreaView>
      <View style={styles.container}>
        <ImageBackground source={bgImage} style={styles.backgroundImage}>
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
                onChangeText={(text) => this.setState({text})}>
              </TextInput>
              <TouchableWithoutFeedback onPress={() =>this.sendEvent(this.state.text)}>
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
          <View style={styles.bottom}>
            <Image style={styles.footerImage} source={ logo }></Image>
          </View>
        </ImageBackground>
      </View> 
    </SafeAreaView>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    width: "100%",
  },
  backgroundImage: {
    width: '100%',
    height: '100%'
  },
  top: {
    marginTop: PixelRatio.roundToNearestPixel(20),
    marginLeft: PixelRatio.roundToNearestPixel(40),
    textAlign: 'left',
  },
  welcome: {
    fontFamily: "MiloOT-Bold",
    fontSize: 55 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    color: '#00A5C9',
  },
  middle: {
    marginTop: PixelRatio.roundToNearestPixel(115),
    marginLeft: PixelRatio.roundToNearestPixel(40),
    marginRight: PixelRatio.roundToNearestPixel(40),
    flexDirection:'column',
  },
  showForm: {
    marginTop: PixelRatio.roundToNearestPixel(0),
  },
  buttonShowForm: {
    backgroundColor: '#00A5C9',
    borderWidth: PixelRatio.roundToNearestPixel(1),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderColor: '#ffffff',
    borderStyle:'solid',
    width: 'auto',
  },
  textShowForm: {
    textAlign: 'center',
    color: '#ffffff',
    fontFamily: "MiloOT-Medi",
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    lineHeight: PixelRatio.roundToNearestPixel(19),
    padding: PixelRatio.roundToNearestPixel(14),
  },
  event: {
    marginTop: PixelRatio.roundToNearestPixel(40),
    flexDirection:'row',
    display: 'flex',
    height: PixelRatio.roundToNearestPixel(48),
  },
  eventInput: {
    padding: PixelRatio.roundToNearestPixel(10),
    marginRight: PixelRatio.roundToNearestPixel(16),
    borderWidth: PixelRatio.roundToNearestPixel(2),
    fontFamily: "MiloOT-Text",
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: PixelRatio.roundToNearestPixel(0),
    lineHeight: PixelRatio.roundToNearestPixel(19),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderWidth: PixelRatio.roundToNearestPixel(2),
    borderStyle: 'solid',
    borderColor: '#C8D2DA',
    backgroundColor:'#FFFFFF',
    justifyContent: 'center',
    flex: 0.5
  },
  buttonSend: {
    backgroundColor: '#ffffff',
    borderWidth: PixelRatio.roundToNearestPixel(1),
    borderRadius: PixelRatio.roundToNearestPixel(2),
    borderColor: '#00A5C9',
    flex: 0.5
  },
  textSend: {
    textAlign: 'center',
    color: '#00A5C9',
    fontFamily: "MiloOT-Medi",
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
    fontFamily: "MiloOT-Medi",
    fontSize: 19 / PixelRatio.getFontScale(),
    letterSpacing: 0,
    lineHeight:19,
    padding: 14,
  },
  bottom: {
    width: '100%',
    justifyContent: 'center',
    alignItems: 'center',
    position: 'absolute',
    bottom: PixelRatio.roundToNearestPixel(0),
  },
  footerImage: {
    height: PixelRatio.roundToNearestPixel(50), 
    width: PixelRatio.roundToNearestPixel(83)
  }
})