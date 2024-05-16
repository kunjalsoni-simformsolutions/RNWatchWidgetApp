/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React, {useEffect, useState} from 'react';
import {Button, Text, View} from 'react-native';
import {
  watchEvents,
  sendMessage,
  getReachability,
} from 'react-native-watch-connectivity';

function App(): React.JSX.Element {
  const [count, setCount] = useState(0);

  useEffect(() => {
    watchEvents.on('message', message => {
      const newCount = message.count as number;
      if (newCount !== null && newCount !== undefined) {
        setCount(newCount);
      }
    });
  }, []);

  return (
    <View
      style={{
        height: '100%',
        flexDirection: 'column',
        justifyContent: 'center',
      }}>
      <View style={{alignItems: 'center'}}>
        <Button
          title="+"
          onPress={async () => {
            const isReachable = await getReachability();
            if (isReachable) {
              const newCount = count + 1;
              setCount(newCount);

              // This method will send message to watchOS app
              sendMessage(
                {count: newCount},
                (replyObj: any) => {
                  console.log('reply from watchOS app: ', replyObj);
                },
                error => {
                  console.log('error sending message: ', error);
                },
              );
            }
          }}
        />
        <Text style={{margin: 24}}>{count}</Text>
        <Button
          title="-"
          onPress={async () => {
            const isReachable = await getReachability();
            if (isReachable) {
              const newCount = count - 1;
              setCount(newCount);
              sendMessage(
                {count: newCount},
                (replyObj: any) => {
                  console.log('reply from watchOS app: ', replyObj);
                },
                error => {
                  console.log('error sending message: ', error);
                },
              );
            }
          }}
        />
      </View>
    </View>
  );
}

export default App;
