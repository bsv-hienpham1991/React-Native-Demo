import React from 'react';
import { Button, Image, View, Text, FlatList, ScrollView, Dimensions, TouchableHighlight } from 'react-native';
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
    alignItems: 'stretch',
  },
  backgroundImage: {
    height: undefined, 
    width: undefined, 
    position:'absolute',
    left:0,
    right:0,
    top:0,
    bottom:0
  },
  scrollItemContainer: {
      flex: 1,
      alignItems: 'stretch',
      width: Dimensions.get('window').width
  },
  tutorialText: {
    paddingTop:23, textAlign: 'center', fontWeight: 'bold', 
    fontSize: 14, lineHeight: 24, color: 'rgb(33, 33, 33)'
  },
});

const buttonStyles = StyleSheet.create({
  rounded: {
    alignSelf: 'stretch', 
    marginHorizontal: 17, 
    marginBottom: 10, 
    borderRadius: 22
  },
  button: {
    justifyContent: 'center',
    alignItems: 'center',
    height: 44,
    borderRadius: 22
  },
  buttonContent: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center'
  },
  buttonText: {
    color: 'white',
    fontSize: 15,
    fontWeight: 'bold'
  },
  buttonImage: {
    marginRight: 12
  }
});

class LoginButton extends React.Component {
  render() {
    const colorStyle = {
      backgroundColor: this.props.backgroundColor,
    };

    return (
      <TouchableHighlight style={[buttonStyles.rounded]} onPress={this.props.onPress} underlayColor="black">
        <View style={[buttonStyles.button, colorStyle]}>
          <View style={buttonStyles.buttonContent}>
            {this.props.source != null &&
              <Image style={buttonStyles.buttonImage} source={this.props.source}/>
            }
            <Text style={buttonStyles.buttonText}>{this.props.text}</Text>
          </View>
        </View>
      </TouchableHighlight>
    );
  }
}

export default class LoginScreen extends React.Component {
  _onPressButton() {
    this.props.handleClick()
  }

  render() {
    return (
      <View style={styles.scrollItemContainer}>
        <Image style={styles.backgroundImage} resizeMode="stretch" source={require("../../assets/main_tutorial/tutorial_bg_01.png")}/>
        <View style={{
          alignSelf: 'center',
          alignItems: 'center',
        }}>
          <Image style={{marginTop:92}} source={require("../../assets/main_tutorial/tutorial_txt_03.png")}/>
          <Text style={styles.tutorialText}>
            Mycleを始めて、世界の中心に立とう。
          </Text>
        </View>
        <View style={{
          flex: 1,
        }}>
          <View style={{
            flex: 1,
            alignItems: 'center',
            justifyContent: 'center',
          }}>
            <View>
            <Image source={require("../../assets/service_logo_color.png")}/>
            </View>
          </View>
          <View style={{
            justifyContent: 'flex-end'
          }}>
            <LoginButton 
              backgroundColor='#FF5C20' 
              source={require("../../assets/main_tutorial/logo_m.png")} 
              text="すぐに始める" 
              onPress={this.props.onPress}
            />
            <LoginButton 
              backgroundColor='#315E99' 
              source={require("../../assets/main_tutorial/logo_f.png")} 
              text="Facebookで始める" 
              onPress={this._onPressButton}
            />
            <LoginButton 
              backgroundColor='#4BACDB' 
              source={require("../../assets/main_tutorial/logo_t.png")} 
              text="Twitterで始める" 
              onPress={this._onPressButton}
            />
            <LoginButton 
              backgroundColor='#736262' 
              source={require("../../assets/main_tutorial/logo_instagram.png")} 
              text="Instagramで始める" 
              onPress={this._onPressButton}
            />
          </View>
        </View>
      </View>
    );
  }
}