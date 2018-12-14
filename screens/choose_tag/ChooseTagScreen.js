import React from 'react';
import { Button, Image, View, Text } from 'react-native';
import { createStackNavigator, createAppContainer, createSwitchNavigator } from 'react-navigation'; // 1.0.0-beta.27
import { requireNativeComponent } from 'react-native';

import {
  ActivityIndicator,
  AsyncStorage,
  StatusBar,
  StyleSheet,
} from 'react-native';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});

import fdasfs from 'react-native-my-library';
fdasfs.addEvent('Birthday Party', '4 Privet Drive, Surrey');;

// import CustomModule from 'react-native-custom-module';
// CustomModule.getModuleList((error, data) => {
//     if (error) {
//     } else {
//       //@todo
//     }
// });

export default class ChooseTagScreen extends React.Component {
  constructor(props) {
    super(props);
  }

  // Render any loading content that you like here
  render() {
    return (
      <View style={styles.container}>
        <StatusBar barStyle="default" />
      </View>
    );
  }
}
