import React from 'react';
import { Button, Image, View, Text, FlatList, ScrollView, Dimensions } from 'react-native';
import { createStackNavigator, createAppContainer, createSwitchNavigator } from 'react-navigation'; // 1.0.0-beta.27
import LoginScreen from './LoginScreen';
import ChooseTagScreen from '../choose_tag/ChooseTagScreen';

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
  }
});

class TutorialView1 extends React.Component {
  render() {
    return (
      <View style={styles.scrollItemContainer}>
        <Image style={styles.backgroundImage} resizeMode="stretch" source={require("../../assets/main_tutorial/tutorial_bg_01.png")}/>
        <Image style={styles.backgroundImage} resizeMode="stretch" source={require("../../assets/main_tutorial/tutorial_img_01.png")}/>
        <View style={{
          alignSelf: 'center',
          alignItems: 'center',
        }}>
          <Image style={{marginTop:92}} source={require("../../assets/main_tutorial/tutorial_txt_01.png")}/>
          <Text style={styles.tutorialText}>
            Mycleは、期限つきのゴールを決めて{"\n"}参加者全員で達成を目指します。
          </Text>
        </View>

      </View>
    );
  }
}

class TutorialView2 extends React.Component {
  render() {
    return (
      <View style={styles.scrollItemContainer}>
        <Image style={styles.backgroundImage} resizeMode="stretch" source={require("../../assets/main_tutorial/tutorial_bg_02.png")}/>
        <View style={{
          alignSelf: 'center',
          alignItems: 'center',
        }}>
          <Image style={{marginTop:92}} source={require("../../assets/main_tutorial/tutorial_txt_02.png")}/>
          <Text style={styles.tutorialText}>
          達成を目指す過程で、{"\n"}たくさんの新しい仲間と出会えます。
          </Text>
        </View>

      </View>
    );
  }
}

export default class MainTutorialScreen extends React.Component {
  static navigationOptions = { header: null};

  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
  }

  handleClick() {
    this.props.navigation.navigate('ChooseTag');
  }

  // Render any loading content that you like here
  render() {
    return (
      <View style={styles.container}>
        <ScrollView
          style={{flex: 1}}
          horizontal={true}
          pagingEnabled={true}>
          <TutorialView1/>
          <TutorialView2/>
          <LoginScreen onPress={this.handleClick}/>
        </ScrollView>
      </View>
    );
  }
}