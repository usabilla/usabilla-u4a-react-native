/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  Button,
  NativeModules,
  NativeEventEmitter
} from 'react-native';

var usabilla = require('usabilla-react-native')

/* Event emitters */
const UsabillaEventEmitter = new NativeEventEmitter(NativeModules.UsabillaBridge);

UsabillaEventEmitter.addListener(
  'UBFormLoadedSuccessfully',
  (reminder) => usabilla.showLoadedForm()
);

UsabillaEventEmitter.addListener(
  'UBFormFailedLoading',
  (reminder) => console.log("Emitted event: formFailedLoading", reminder.error)
);

UsabillaEventEmitter.addListener(
  'UBFormDidClose',
  (reminder) => console.log("Emitted event: formDidClose", reminder.formId)
);

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {
  onShowForm() {
      usabilla.loadFeedbackForm("5a744ccd8753b708620f8dd6");
  }

  render() {
    console.log("required :", usabilla);
    usabilla.initialize(null);
    
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit App.js
        </Text>
        <Text style={styles.instructions}>
          {instructions}
        </Text>
        <Button
        onPress={this.onShowForm}
        title="Show form"
        />
      </View>
    );
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
});
