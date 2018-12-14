import React from 'react';
import { Button, Image, View, Text } from 'react-native';
import { createStackNavigator, createAppContainer, createSwitchNavigator } from 'react-navigation'; // 1.0.0-beta.27

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

export default class SplashScreen extends React.Component {
  static navigationOptions = { header: null};

  constructor(props) {
    super(props);
    this._bootstrapAsync();
  }

  // Fetch the token from storage then navigate to our appropriate place
  _bootstrapAsync = async () => {
    const userToken = await AsyncStorage.getItem('userToken');

    // This will switch to the App screen or Auth screen and this loading
    // screen will be unmounted and thrown away.
setTimeout(function () {
    this.props.navigation.navigate(userToken ? 'MainTutorial' : 'Auth');
}.bind(this), 2000);

  };

  // Render any loading content that you like here
  render() {
    return (
      <View style={styles.container}>
        <View style={{alignItems: 'center'}}>
          <Image style={{marginBottom: 15}} source={require("../assets/service_logo_color.png")}/>
          <Text style={{fontWeight: 'bold', fontSize: 14}}>感動体験を創造するコミュニティの世界へ。</Text>
        </View>
        <StatusBar barStyle="default" />
      </View>
    );
  }
}
