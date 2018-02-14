import React, { Component } from 'react'
import {
  Platform,
  StyleSheet,
  Text,
  TextInput,
  View,
  Button
} from 'react-native'

var usabilla = require('usabilla-react-native')

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\nCmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\nShake or press menu button for dev menu',
})

export default class App extends Component<{}> {
  constructor() {
    super()
    this.state = {text: ''}
    usabilla.initialize("YOUR_APP_ID_HERE")
    var customVars = {"flight-number": "99999999", "user-type": "premium", "number-flights": 12}
    usabilla.setCustomVariables(customVars)
    usabilla.setFormDidLoadSuccessfully(this.onFormLoaded)
    usabilla.setFormDidFailLoading((reminder) => console.log("Error loading form:", reminder))
    usabilla.setFormDidClose((reminder) => console.log(reminder.formId))
  }

  onFormLoaded() {
    usabilla.showLoadedForm()
  }

  requestForm() {
    usabilla.loadFeedbackForm("YOUR_FORM_ID_HERE")
  }

  resetCampaignData() {
    usabilla.resetCampaignData()
  }

  sendEvent(event) {
    usabilla.sendEvent(event)
  }

  requestFormWithDefaultScreenshot() {
    usabilla.loadFeedbackFormWithCurrentViewScreenshot("YOUR_FORM_ID_HERE")
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>Welcome to React Native!</Text>
        <Text style={styles.instructions}>To get started, edit App.js</Text>
        <Text style={styles.instructions}>{instructions}</Text>
        <Button onPress={this.requestForm} title="Form" />
        <TextInput
          style={{height: 40, width: 150}}
          placeholder="Event"
          onChangeText={(text) => this.setState({text})} />
        <Button onPress={() => this.sendEvent(this.state.text)} title="Send event" />
        <Text />
        <Button onPress={this.resetCampaignData} title="Reset" />
        <Text />
        <Button onPress={this.requestFormWithDefaultScreenshot} title="Form with screenshot" />
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
})
