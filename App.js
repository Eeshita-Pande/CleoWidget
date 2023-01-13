import React, {useState} from 'react';
import {Text, View, StyleSheet, ImageBackground} from 'react-native';
import {NativeModules} from 'react-native';
import SharedGroupPreferences from 'react-native-shared-group-preferences';
import { render } from 'react-native/Libraries/Renderer/implementations/ReactNativeRenderer-prod';

 const group = 'group.com.eeshita.widget';
 const SharedStorage = NativeModules.SharedStorage;
 const image = {uri: "https://i.ibb.co/7VyRPzB/React-Landing.png"};
 const App = () => {

const [text] = useState(100);
const widgetData = {
     text,
 };

 const sendDataToiOS = async () => {
 try {
 // iOS
 await SharedGroupPreferences.setItem('widgetKey', widgetData, group);
 } catch (error) {
 console.log({error});
 }
 };

 sendDataToiOS();

 return (
 <View style={styles.container}>
    <ImageBackground source={image} resizeMode="cover" style={styles.image}>
    </ImageBackground>


 </View>
 );
 };

 const styles = StyleSheet.create({
    container: {
      flex: 1,
    },
    image: {
      flex: 2,
      justifyContent: "center"
    },
    text: {
      color: "white",
      fontSize: 42,
      lineHeight: 84,
      fontWeight: "bold",
      textAlign: "center",
      backgroundColor: "#000000c0"
    }
  });
 
 export default App;

