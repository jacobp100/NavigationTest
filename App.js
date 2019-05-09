import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { Navigator } from "./Navigator";

const colors = ["red", "yellow", "green", "blue"];

const TestComponent = ({ backgroundColor = "red", pushRoute }) => (
  <View style={{ flex: 1, backgroundColor }}>
    <TouchableOpacity onPress={pushRoute}>
      <Text style={{ padding: 100 }}>Push a route</Text>
    </TouchableOpacity>
  </View>
);

export default () => {
  const pushRoute = () => setRoutes(s => s.concat(routeFor(s.length)));

  const routeFor = index => ({
    key: String(index),
    component: TestComponent,
    title: `Route ${index + 1}`,
    barStyle: index === 2 ? "black" : undefined,
    props: { backgroundColor: colors[index % colors.length], pushRoute }
  });

  const [routes, setRoutes] = React.useState(() => [routeFor(0)]);

  const onRoutesUpdated = e => {
    const keys = e.nativeEvent.routeKeys;
    setRoutes(routes =>
      keys.map(key => routes.find(route => route.key === key))
    );
  };

  return (
    <Navigator
      style={{ flex: 1 }}
      routes={routes}
      onRoutesUpdated={onRoutesUpdated}
    />
  );
};
