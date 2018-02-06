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
  NativeModules
} from 'react-native';

var usabilla = require('usabilla-react-native')

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends Component<{}> {

  constructor() {
    super();
    usabilla.initialize(null);
    usabilla.setFormDidLoadSuccessfully(this.onFormLoaded);
    usabilla.setFormDidFailLoading((reminder) => console.log("Error loading form:", reminder));
    usabilla.setFormDidCloase((reminder) => console.log(reminder.formId));
  }

  onFormLoaded() {
    usabilla.showLoadedForm();
  }

  onShowForm() {
    usabilla.loadFeedbackForm("5a744ccd8753b708620f8dd6")
  }

  render() {    
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
